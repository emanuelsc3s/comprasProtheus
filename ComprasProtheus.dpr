program ComprasProtheus;

uses
  Vcl.Forms,
  Unit_Principal in 'Unit_Principal.pas' {Form1},
  Unit_dm1 in 'Unit_dm1.pas' {dm1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tdm1, dm1);
  Application.Run;
end.
