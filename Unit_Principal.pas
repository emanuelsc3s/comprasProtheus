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
    { Private declarations }
  public
    { Public declarations }
    function  CalcularQuantidadeSegundaUM(QuantidadePrimeiraUM: Double; FatorConversao: Double; TipoConversao: String): Double;
    procedure CheckFieldSizes(Query: TADOQuery);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit_dm1;

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
  QueryProtheus : TADOQuery;
  qProtheus     : TADOQuery;
  VerificaRegistro: TADOQuery;
  UltimoRecNo, ProximoRecNo: Integer;
  FatorConversao : Double;
  TipoConversao  : String;
begin
  QueryProtheus := TADOQuery.Create(self);
  qProtheus     := TADOQuery.Create(self);
  VerificaRegistro := TADOQuery.Create(self); // Novo query para verificação
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
        Parameters.ParamByName('C7_CC').Value        := Copy(PedidoSIC.FieldByName('codigo_centro').AsString, 1, 9); // varchar(9)
        Parameters.ParamByName('C7_COND').Value      := Copy(PedidoSIC.FieldByName('ERP_COND').AsString, 1, 3); // varchar(3)
        Parameters.ParamByName('C7_CONTA').Value     := Copy('', 1, 20); // varchar(20)
        Parameters.ParamByName('C7_LOJA').Value      := Copy('01', 1, 2); // varchar(2)
        Parameters.ParamByName('C7_FILENT').Value    := Copy('01', 1, 2); // varchar(2)
        Parameters.ParamByName('C7_EMISSAO').Value   := Copy(FormatDateTime('YYYYMMDD', PedidoSIC.FieldByName('EMISSAO').AsDateTime), 1, 8); // varchar(8)
        Parameters.ParamByName('C7_NUM').Value       := Copy(Format('%.6d', [PedidoSIC.FieldByName('PEDIDO_ID').AsInteger]), 1, 6); // varchar(6)
        Parameters.ParamByName('C7_QUJE').Value      := 0; // float
        Parameters.ParamByName('C7_DESCRI').Value    := Copy(PedidoSIC.FieldByName('PRODUTO').AsString, 1, 50); // varchar(50)
        Parameters.ParamByName('C7_IPIBRUT').Value   := Copy('0', 1, 1); // varchar(1)
        Parameters.ParamByName('C7_CONAPRO').Value   := Copy('L', 1, 1); // varchar(1)
        Parameters.ParamByName('C7_USER').Value      := Copy('000000', 1, 6); // varchar(6)
        Parameters.ParamByName('C7_TES').Value       := Copy('', 1, 3); // varchar(3)
        Parameters.ParamByName('C7_POLREPR').Value   := Copy('N', 1, 1); // varchar(1)
        Parameters.ParamByName('C7_RATEIO').Value    := Copy('2', 1, 1); // varchar(1)
        Parameters.ParamByName('C7_ACCPROC').Value   := Copy('2', 1, 1); // varchar(1)

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
        ExecSQL;
      end;
    end;
    PedidoSIC.Next;
  end;
  QueryProtheus.Free;
  qProtheus.Free;
  VerificaRegistro.Free;
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


end.
