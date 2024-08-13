program NaverCommerce;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  FBC.Bcrypt in 'FBC.Bcrypt.pas',
  FBC.NaverCommerce in 'FBC.NaverCommerce.pas',
  FBC.Json in 'FBC.Json.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
