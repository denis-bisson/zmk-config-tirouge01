program TiRouge;

uses
  Vcl.Forms,
  fTiRouge in 'fTiRouge.pas' {frmTiRouge},
  fTiRougeConfigurator in 'fTiRougeConfigurator.pas' {frmTiRougeConfigurator};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTiRouge, frmTiRouge);
  Application.CreateForm(TfrmTiRougeConfigurator, frmTiRougeConfigurator);
  Application.Run;
end.
