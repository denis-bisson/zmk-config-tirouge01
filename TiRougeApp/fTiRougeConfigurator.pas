unit fTiRougeConfigurator;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmTiRougeConfigurator = class(TForm)
    ckbLY_ACSY: TCheckBox;
    ckbLY_ACSH: TCheckBox;
    ckbLY_NUMB: TCheckBox;
    ckbLY_CRSR: TCheckBox;
    ckbLY_FUNC: TCheckBox;
    ckbLY_CONF: TCheckBox;
    ckbLY_SYMA: TCheckBox;
    ckbLY_DFLT: TCheckBox;
    ckbShowKeyZones: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTiRougeConfigurator: TfrmTiRougeConfigurator;

implementation

{$R *.dfm}

end.
