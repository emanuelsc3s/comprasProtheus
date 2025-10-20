unit Unit_dm1;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, Data.DB, Data.Win.ADODB, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase;

type
  Tdm1 = class(TDataModule)
    ADOConnection: TADOConnection;
    FDConnection: TFDConnection;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function fRetornaCampoProtheus(prCampo, prTabela, prCampoWhere, prValorWhere: String): String;
  end;

var
  dm1: Tdm1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function Tdm1.fRetornaCampoProtheus(prCampo, prTabela, prCampoWhere, prValorWhere: String): String;
var
  vlQuery : TADOQuery;
begin
  vlQuery := TADOQuery.Create(Owner);
  try
    with vlQuery do
      begin
        Connection := dm1.ADOConnection;

        Close;
        SQL.Text := 'select ' + prCampo + ' from ' + prTabela;
        SQL.Add(' where D_E_L_E_T_ = '''' ');
        SQL.Add(' and ' + prCampoWhere + ' = ''' + prValorWhere + ''' ');

        Open;
      end;

    Result := vlQuery.FieldByName(prCampo).AsString;
  finally
    vlQuery.Free;
  end;
end;

procedure Tdm1.DataModuleCreate(Sender: TObject);
begin
  ADOConnection.Connected := True;
end;

end.
