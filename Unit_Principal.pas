unit Unit_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Data.Win.ADODB;

type
  TForm1 = class(TForm)
    btn_IntegrarPedidos: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    PedidoSIC: TFDQuery;
    QueryTOTVS: TADOQuery;
    procedure btn_IntegrarPedidosClick(Sender: TObject);
  private
    // Métodos auxiliares privados para logging e validação de tamanhos
    procedure LogExecSqlError(const E: Exception; Query: TADOQuery; const Operacao, Tabela: string; PedidoID, ProximoRecNo: Integer; const Violations: string);
    function GetTableFieldSizeMap(ADOConn: TADOConnection; const TableName: string): TStringList;
    function ValidateStringParamsAgainstSchema(Query: TADOQuery; FieldSizes: TStringList): string;
  public
    { Public declarations }
    function  CalcularQuantidadeSegundaUM(QuantidadePrimeiraUM: Double; FatorConversao: Double; TipoConversao: String): Double;
    procedure CheckFieldSizes(Query: TADOQuery);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit_dm1, System.IOUtils, ComObj;

function TForm1.CalcularQuantidadeSegundaUM(QuantidadePrimeiraUM: Double; FatorConversao: Double; TipoConversao: String): Double;
begin
  // Inicializa o resultado para evitar resultados não definidos
  Result := 0.0;
  // Verifica o tipo de conversão e calcula a quantidade na segunda unidade de medida
  if TipoConversao = 'M' then
    Result := QuantidadePrimeiraUM * FatorConversao
  else if TipoConversao = 'D' then
    Result := QuantidadePrimeiraUM / FatorConversao;
end;

procedure TForm1.btn_IntegrarPedidosClick(Sender: TObject);
var
  QueryProtheus   : TADOQuery;
  qProtheus       : TADOQuery;
  VerificaRegistro: TADOQuery;
  UltimoRecNo, ProximoRecNo: Integer;
  FatorConversao  : Double;
  TipoConversao   : String;
  FieldSizes      : TStringList;
  Violations      : string;
begin
  QueryProtheus := TADOQuery.Create(self);
  qProtheus     := TADOQuery.Create(self);
  VerificaRegistro := TADOQuery.Create(self); // Novo query para verificação
  // Mapa de tamanhos dos campos da SC7010 para validação preventiva
  FieldSizes := GetTableFieldSizeMap(dm1.ADOConnection, 'SC7010');

  // Força ordenação por pedidoitem_id para gerar C7_ITEM sequencial por pedido
  with PedidoSIC do
  begin
    Close;
    SQL.Clear;

    SQL.Add('select');
    SQL.Add('  i.status, p.pedido_id, p.emissao, i.qtde, i.produto_id, pr.referencia as ERP_PRODUTO, i.produto,');
    SQL.Add('  pr.unidade, i.preco, i.total, f.erp_codigo, c.erp_codigo as ERP_COND, i.pedidoitem_id, i.item as ITEM,');
    SQL.Add('  cc.codigo_centro');
    SQL.Add('from tbpedido p');
    SQL.Add('  inner join tbpedido_item i on p.pedido_id = i.pedido_id and i.deletado = ''N''');
    SQL.Add('  inner join tbprodutos pr on pr.produto_id = i.produto_id and pr.deletado = ''N''');
    SQL.Add('  inner join tbpessoas f on f.pessoa_id     = p.pessoa_id and f.deletado = ''N''');
    SQL.Add('  left join tbcondpagto c on c.condpagto_id = p.condpagto_id and c.deletado = ''N''');
    SQL.Add('  left join tbcc cc on cc.cc_id             = i.cc_id and c.deletado = ''N'' ');

    SQL.Add('where p.deletado = ''N''');
    SQL.Add('  and (p.SYNC IS NULL OR p.SYNC = '''' OR p.SYNC = ''S'')');
    SQL.Add('  and (i.SYNC IS NULL OR i.SYNC = '''' OR i.SYNC = ''S'')');


    SQL.Add('and cast(p.data_inc as date) >= ''01.10.2025'' ');

    SQL.Add('and p.pedido_id = 60072');

    SQL.Add('order by p.pedido_id, i.pedidoitem_id');
    Open;
  end;

  PedidoSIC.First;
  while not PedidoSIC.Eof do
  begin


    // Verificar se o ITEM já existe (C7_FILIAL + C7_NUM + C7_ITEM) ignorando deletados
    VerificaRegistro.Connection := dm1.ADOConnection;
    VerificaRegistro.Close;
    VerificaRegistro.SQL.Clear;
    VerificaRegistro.SQL.Add('SELECT 1 FROM SC7010 (NOLOCK) ');
    VerificaRegistro.SQL.Add('WHERE D_E_L_E_T_ = '''' ');

    VerificaRegistro.SQL.Add('AND C7_FILIAL = :FILIAL AND C7_NUM = :NUM AND C7_ITEM = :ITEM ');

    VerificaRegistro.Parameters.ParamByName('FILIAL').Value := '01';
    VerificaRegistro.Parameters.ParamByName('NUM').Value    := Format('%.6d', [PedidoSIC.FieldByName('PEDIDO_ID').AsInteger]);
    VerificaRegistro.Parameters.ParamByName('ITEM').Value   := Format('0%.3s', [PedidoSIC.FieldByName('ITEM').AsString]);
    VerificaRegistro.Open;

    // Se o registro não existe, fazer o INSERT
    if VerificaRegistro.IsEmpty then
    begin
      With QueryProtheus do
      begin
        Connection := dm1.ADOConnection;
        SQL.Clear;
        SQL.Add('INSERT INTO SC7010 (C7_FILIAL, C7_TIPO, C7_ITEM, C7_PRODUTO, C7_UM, C7_SEGUM, C7_QUANT,');
        SQL.Add('C7_PRECO, C7_TOTAL, C7_QTSEGUM, C7_IPI, C7_DATPRF, C7_LOCAL, C7_FORNECE, C7_CC, C7_COND,');
        SQL.Add('C7_CONTA, C7_LOJA, C7_FILENT, C7_EMISSAO, C7_NUM, C7_QUJE, C7_DESCRI, C7_IPIBRUT, C7_CONAPRO,');
        SQL.Add('C7_USER, C7_TES, C7_POLREPR, C7_RATEIO, C7_ACCPROC, R_E_C_N_O_, R_E_C_D_E_L_, C7_DINICOM, C7_DINITRA,');
        SQL.Add('C7_DINICQ, C7_FISCORI, S_T_A_M_P_)');
        SQL.Add('VALUES (:C7_FILIAL, :C7_TIPO, :C7_ITEM, :C7_PRODUTO, :C7_UM, :C7_SEGUM, :C7_QUANT,');
        SQL.Add(':C7_PRECO, :C7_TOTAL, :C7_QTSEGUM, :C7_IPI, :C7_DATPRF, :C7_LOCAL, :C7_FORNECE, :C7_CC, :C7_COND,');
        SQL.Add(':C7_CONTA, :C7_LOJA, :C7_FILENT, :C7_EMISSAO, :C7_NUM, :C7_QUJE, :C7_DESCRI, :C7_IPIBRUT, :C7_CONAPRO,');
        SQL.Add(':C7_USER, :C7_TES, :C7_POLREPR, :C7_RATEIO, :C7_ACCPROC, :R_E_C_N_O_, :R_E_C_D_E_L_, :C7_DINICOM, :C7_DINITRA,');
        SQL.Add(':C7_DINICQ, :C7_FISCORI, :S_T_A_M_P_)');

        // Ajuste de acordo com os limites da tabela
        Parameters.ParamByName('C7_FILIAL').Value    := Copy('01', 1, 2); // varchar(2)
        Parameters.ParamByName('C7_TIPO').Value      := 1; // Pedido de compra
        Parameters.ParamByName('C7_ITEM').Value      := Copy(Format('0%.3s', [PedidoSIC.FieldByName('ITEM').AsString]), 1, 4); // varchar(4)
        Parameters.ParamByName('C7_PRODUTO').Value   := Copy(PedidoSIC.FieldByName('ERP_PRODUTO').AsString, 1, 15); // varchar(15)
        Parameters.ParamByName('C7_UM').Value        := Copy(PedidoSIC.FieldByName('UNIDADE').AsString, 1, 2); // varchar(2)
        Parameters.ParamByName('C7_SEGUM').Value     := Copy(dm1.fRetornaCampoProtheus('B1_SEGUM','SB1010','B1_COD',PedidoSIC.FieldByName('ERP_PRODUTO').AsString), 1, 2);
        Parameters.ParamByName('C7_QUANT').Value     := PedidoSIC.FieldByName('QTDE').AsFloat; // float
        Parameters.ParamByName('C7_PRECO').Value     := PedidoSIC.FieldByName('PRECO').AsFloat; // float

        if PedidoSIC.FieldByName('TOTAL').AsFloat <= 0 then
          Parameters.ParamByName('C7_TOTAL').Value := PedidoSIC.FieldByName('PRECO').AsFloat * PedidoSIC.FieldByName('QTDE').AsFloat
        else
          Parameters.ParamByName('C7_TOTAL').Value := PedidoSIC.FieldByName('TOTAL').AsFloat;

        FatorConversao := StrToFloatDef(dm1.fRetornaCampoProtheus('B1_CONV','SB1010','B1_COD',PedidoSIC.FieldByName('ERP_PRODUTO').AsString), 0);
        TipoConversao  := dm1.fRetornaCampoProtheus('B1_TIPCONV','SB1010','B1_COD',PedidoSIC.FieldByName('ERP_PRODUTO').AsString);

        if (SameText(TipoConversao, 'D')) and (FatorConversao = 0) then
          Parameters.ParamByName('C7_QTSEGUM').Value := 0
        else
          Parameters.ParamByName('C7_QTSEGUM').Value := CalcularQuantidadeSegundaUM(PedidoSIC.FieldByName('QTDE').AsFloat, FatorConversao, TipoConversao);

        Parameters.ParamByName('C7_IPI').Value       := 0; // float
        Parameters.ParamByName('C7_DATPRF').Value    := Copy(FormatDateTime('YYYYMMDD', PedidoSIC.FieldByName('EMISSAO').AsDateTime), 1, 8); // varchar(8)
        Parameters.ParamByName('C7_LOCAL').Value     := Copy('01', 1, 2); // varchar(2)
        Parameters.ParamByName('C7_FORNECE').Value   := Copy(PedidoSIC.FieldByName('ERP_CODIGO').AsString, 1, 6); // varchar(6)
        Parameters.ParamByName('C7_CC').Value        := Copy(PedidoSIC.FieldByName('codigo_centro').AsString, 1, 15); // varchar(15)
        Parameters.ParamByName('C7_COND').Value      := Copy(PedidoSIC.FieldByName('ERP_COND').AsString, 1, 3); // varchar(3)
        Parameters.ParamByName('C7_CONTA').Value     := Copy('', 1, 20); // varchar(20)
        Parameters.ParamByName('C7_LOJA').Value      := Copy('01', 1, 2); // varchar(2)
        Parameters.ParamByName('C7_FILENT').Value    := Copy('01', 1, 2); // varchar(2)
        Parameters.ParamByName('C7_EMISSAO').Value   := Copy(FormatDateTime('YYYYMMDD', PedidoSIC.FieldByName('EMISSAO').AsDateTime), 1, 8); // varchar(8)
        Parameters.ParamByName('C7_NUM').Value       := Copy(Format('%.6d', [PedidoSIC.FieldByName('PEDIDO_ID').AsInteger]), 1, 6); // varchar(6)
        Parameters.ParamByName('C7_QUJE').Value      := 0; // float
        Parameters.ParamByName('C7_DESCRI').Value    := Copy(PedidoSIC.FieldByName('PRODUTO').AsString, 1, 30); // varchar(30)
        Parameters.ParamByName('C7_IPIBRUT').Value   := Copy('0', 1, 1); // varchar(1)
        Parameters.ParamByName('C7_CONAPRO').Value   := Copy('L', 1, 1); // varchar(1)
        Parameters.ParamByName('C7_USER').Value      := Copy('000001', 1, 6); // varchar(6)
        Parameters.ParamByName('C7_TES').Value       := Copy('', 1, 3); // varchar(3)
        Parameters.ParamByName('C7_POLREPR').Value   := Copy('N', 1, 1); // varchar(1)
        Parameters.ParamByName('C7_ACCPROC').Value   := Copy('2', 1, 1); // varchar(1)

        // C7_RATEIO
        // Valor '1' (Sim) no pedido: Permite a distribuição dos valores para diferentes centros de custo tanto no pedido quanto na entrada.
        // Valor '2' (Não) no pedido: Impede o rateio. Se a rotina de entrada (MATA103) estiver configurada para obrigar a informação de centro de custo, o sistema irá bloquear a operação se o usuário tentar ratear     
        Parameters.ParamByName('C7_RATEIO').Value    := '1'; // varchar(1)                

        with qProtheus do
        begin
          Connection := dm1.ADOConnection;
          Close;
          SQL.Text := 'SELECT MAX(R_E_C_N_O_) AS UltimoRecNo FROM SC7010 (NOLOCK) WHERE D_E_L_E_T_ = '''' ';
          Open;
        end;

        if not qProtheus.FieldByName('UltimoRecNo').IsNull then
          UltimoRecNo := qProtheus.FieldByName('UltimoRecNo').AsInteger
        else
          UltimoRecNo := 0;

        ProximoRecNo := UltimoRecNo + 1;

        Parameters.ParamByName('R_E_C_N_O_').Value   := ProximoRecNo; // Registro eletrônico número de ordem
        Parameters.ParamByName('R_E_C_D_E_L_').Value := 0; // Registro eletrônico de deleção
        Parameters.ParamByName('C7_DINICOM').Value   := Copy(FormatDateTime('YYYYMMDD', PedidoSIC.FieldByName('EMISSAO').AsDateTime), 1, 8); // varchar(8)
        Parameters.ParamByName('C7_DINITRA').Value   := Copy(FormatDateTime('YYYYMMDD', PedidoSIC.FieldByName('EMISSAO').AsDateTime), 1, 8); // varchar(8)
        Parameters.ParamByName('C7_DINICQ').Value    := Copy(FormatDateTime('YYYYMMDD', PedidoSIC.FieldByName('EMISSAO').AsDateTime), 1, 8); // varchar(8)
        Parameters.ParamByName('C7_FISCORI').Value   := Copy('01', 1, 2); // varchar(2)
        Parameters.ParamByName('S_T_A_M_P_').Value   := Now; // datetime
        // Validacao preventiva de tamanho de campos baseado no schema
        Violations := ValidateStringParamsAgainstSchema(QueryProtheus, FieldSizes);
        if Violations <> '' then
        begin
          LogExecSqlError(Exception.Create('Violacao de tamanho detectada antes do ExecSQL'), QueryProtheus, 'INSERT', 'SC7010', PedidoSIC.FieldByName('PEDIDO_ID').AsInteger, ProximoRecNo, Violations);
          ShowMessage('Pedido ' + IntToStr(PedidoSIC.FieldByName('PEDIDO_ID').AsInteger) +
                      ' ITEM ' + Format('0%.3s', [PedidoSIC.FieldByName('ITEM').AsString]) +
                      ': existem campos maiores que o limite do Protheus.' + sLineBreak +
                      'Detalhes no log.');
        end
        else
        begin
          try
            ExecSQL;

            // Atualiza sincronizacao no Firebird apos sucesso no Protheus
            var FBUpd: TFDQuery;
            var SyncTime: TDateTime;
            SyncTime := Now;
            dm1.FDConnection.StartTransaction;
            try
              FBUpd := TFDQuery.Create(nil);
              try
                FBUpd.Connection := dm1.FDConnection;
                // Atualiza item
                FBUpd.SQL.Text := 'update tbpedido_item set sync = :s, sync_data = :d where pedidoitem_id = :id';
                FBUpd.ParamByName('s').AsString := 'S';
                FBUpd.ParamByName('d').AsDateTime := SyncTime;
                FBUpd.ParamByName('id').AsInteger := PedidoSIC.FieldByName('PEDIDOITEM_ID').AsInteger;
                FBUpd.ExecSQL;
                // Atualiza cabecalho somente se todos os itens estiverem sincronizados
                FBUpd.SQL.Text := 'update tbpedido p set sync = :s, sync_data = :d ' +
                                  'where p.pedido_id = :pid ' +
                                  'and not exists (select 1 from tbpedido_item i ' +
                                  '                 where i.pedido_id = p.pedido_id ' +
                                  '                   and coalesce(i.sync, '''') <> ''S'')';
                FBUpd.ParamByName('s').AsString := 'S';
                FBUpd.ParamByName('d').AsDateTime := SyncTime;
                FBUpd.ParamByName('pid').AsInteger := PedidoSIC.FieldByName('PEDIDO_ID').AsInteger;
                FBUpd.ExecSQL;
              finally
                FBUpd.Free;
              end;
              dm1.FDConnection.Commit;
            except
              on E: Exception do
              begin
                dm1.FDConnection.Rollback;
                ShowMessage('Falha ao atualizar SYNC no Firebird para o pedido ' + IntToStr(PedidoSIC.FieldByName('PEDIDO_ID').AsInteger) + ': ' + E.Message);
                raise;
              end;
            end;
          except
            on E: EOleException do
            begin
              LogExecSqlError(E, QueryProtheus, 'INSERT', 'SC7010', PedidoSIC.FieldByName('PEDIDO_ID').AsInteger, ProximoRecNo, '');
              ShowMessage('Erro ao inserir o pedido ' + IntToStr(PedidoSIC.FieldByName('PEDIDO_ID').AsInteger) + ': ' + E.Message + sLineBreak + 'Detalhes no log.');
            end;
            on E: Exception do
            begin
              LogExecSqlError(E, QueryProtheus, 'INSERT', 'SC7010', PedidoSIC.FieldByName('PEDIDO_ID').AsInteger, ProximoRecNo, '');
              raise;
            end;
          end;
        end;
      end;
    end;
    PedidoSIC.Next;
  end;
  QueryProtheus.Free;
  qProtheus.Free;
  VerificaRegistro.Free;
  if Assigned(FieldSizes) then
    FieldSizes.Free;

  ShowMessage('Concluído com Sucesso');
end;

procedure TForm1.CheckFieldSizes(Query: TADOQuery);
var
  i: Integer;
  ParamValue: String;
  ParamSize: Integer;
begin
  for i := 0 to Query.Parameters.Count - 1 do
  begin
    ParamValue := Query.Parameters[i].Value;
    // Se o parâmetro for do tipo string, verificamos o tamanho
    if VarIsStr(Query.Parameters[i].Value) then
    begin
      ParamSize := Length(ParamValue);
      if ParamSize > Query.Parameters[i].Size then
      begin
        ShowMessage('O valor do campo ' + Query.Parameters[i].Name + ' excede o tamanho permitido. ' +
                    'Tamanho atual: ' + IntToStr(ParamSize) + ' Tamanho permitido: ' + IntToStr(Query.Parameters[i].Size));
      end;
    end;
  end;
end;

// Gera um mapa NomeDoCampo -> Tamanho (apenas campos string) a partir do schema via SELECT TOP 0
function TForm1.GetTableFieldSizeMap(ADOConn: TADOConnection; const TableName: string): TStringList;
var
  Q: TADOQuery;
  i: Integer;
begin
  Result := TStringList.Create;
  Result.NameValueSeparator := '=';
  Q := TADOQuery.Create(nil);
  try
    Q.Connection := ADOConn;
    Q.SQL.Text := 'SELECT TOP 0 * FROM ' + TableName + ' (NOLOCK)';
    Q.Open;
    for i := 0 to Q.Fields.Count - 1 do
    begin
      if Q.Fields[i].DataType in [ftString, ftWideString, ftFixedChar, ftFixedWideChar] then
        Result.Values[UpperCase(Q.Fields[i].FieldName)] := IntToStr(Q.Fields[i].Size);
    end;
  finally
    Q.Free;
  end;
end;

// Valida os parametros string do Query contra os tamanhos do schema
function TForm1.ValidateStringParamsAgainstSchema(Query: TADOQuery; FieldSizes: TStringList): string;
var
  i, Limit, Len: Integer;
  P: TParameter;
  Col, S: string;
  Msg: TStringList;
begin
  Result := '';
  Msg := TStringList.Create;
  try
    for i := 0 to Query.Parameters.Count - 1 do
    begin
      P := Query.Parameters[i];
      if VarIsStr(P.Value) then
      begin
        S := VarToStrDef(P.Value, '');
        Len := Length(S);
        Col := UpperCase(P.Name);
        Limit := StrToIntDef(FieldSizes.Values[Col], 0);
        if (Limit > 0) and (Len > Limit) then
          Msg.Add(Format('%s: len=%d > limit=%d; value="%s"', [P.Name, Len, Limit, Copy(S, 1, 200)]));
      end;
    end;
    if Msg.Count > 0 then
      Result := Msg.Text;
  finally
    Msg.Free;
  end;
end;

// Loga detalhes completos da falha de ExecSQL
procedure TForm1.LogExecSqlError(const E: Exception; Query: TADOQuery; const Operacao, Tabela: string; PedidoID, ProximoRecNo: Integer; const Violations: string);
var
  SL: TStringList;
  i, Len, DeclSize: Integer;
  P: TParameter;
  S, SchemaSizeStr, LogDir, LogFile: string;
  FieldSizesLocal: TStringList;
begin
  SL := TStringList.Create;
  FieldSizesLocal := nil;
  try
    LogDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'logs');
    ForceDirectories(LogDir);
    LogFile := LogDir + 'ComprasProtheus_' + FormatDateTime('yyyymmdd', Now) + '.log';

    SL.Add('[' + FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + '] ' + Operacao + ' ' + Tabela);
    SL.Add('PedidoID=' + IntToStr(PedidoID) + ' ProximoRecNo=' + IntToStr(ProximoRecNo));
    SL.Add('Erro: ' + E.ClassName + ' - ' + E.Message);
    SL.Add('SQL:');
    SL.Add(Query.SQL.Text);
    SL.Add('Parametros:');

    try
      if Assigned(Query.Connection) then
        FieldSizesLocal := GetTableFieldSizeMap(TADOConnection(Query.Connection), Tabela);
    except
      FieldSizesLocal := nil;
    end;

    for i := 0 to Query.Parameters.Count - 1 do
    begin
      P := Query.Parameters[i];
      S := VarToStrDef(P.Value, '');
      Len := Length(S);
      DeclSize := P.Size;
      SchemaSizeStr := '';
      if Assigned(FieldSizesLocal) then
        SchemaSizeStr := FieldSizesLocal.Values[UpperCase(P.Name)];

      SL.Add(Format(' - %s = "%s" | len=%d | ParamSize=%d | SchemaSize=%s',
                    [P.Name, Copy(S, 1, 200), Len, DeclSize, SchemaSizeStr]));
    end;

    if Violations <> '' then
    begin
      SL.Add('Violations:');
      SL.Add(Violations);
    end;

    SL.Add(StringOfChar('-', 80));
    TFile.AppendAllText(LogFile, SL.Text, TEncoding.UTF8);
  finally
    SL.Free;
    if Assigned(FieldSizesLocal) then
      FieldSizesLocal.Free;
  end;
end;

end.
