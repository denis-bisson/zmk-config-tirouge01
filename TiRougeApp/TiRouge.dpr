program TiRouge;

uses
  Vcl.Forms,
  fTiRouge in 'fTiRouge.pas' {Form1},
  fConfigurator in 'fConfigurator.pas' {frmConfigurator};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmConfigurator, frmConfigurator);
  Application.Run;
end.
