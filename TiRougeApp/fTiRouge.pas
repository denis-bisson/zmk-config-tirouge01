unit fTiRouge;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.ActnMan, Vcl.ExtCtrls, Vcl.PlatformDefaultStyleActnCtrls, Vcl.Menus,
  Vcl.StdCtrls, Vcl.AppEvnts, Vcl.CheckLst;

const
  NB_LAYERS = 8;

type
  THomeRowKeyMod = (
    hrkmDEFT, // 0
    hrkmACSY, // 1
    hrkmACSH, // 2
    hrkmNUMB, // 3
    hrkmCRSR, // 4
    hrkmFUNC, // 5
    hrkmCONF, // 6
    hrkmSYMA, // 7
    hrkmLWin, // 8
    hrkmLAlt, // 9
    hrkmLCtrl, // 10
    hrkmLShift, // 11
    hrkmRCtrl, // 12
    hrkmRAlt, // 13
    hrkmAltGr, // 14
    hrkmNONE, //15
    LAYER_COUNT); // 16

  TKeyZone = record
    X1, X2, X3, X4, X5: integer;
    Y1, Y2, Y3, Y4, Y5: integer;
    R1, R2, R3: integer;
    C1, C2, C3: integer;
  end;

  TLayerDefinition = record
    Checkbox: TCheckbox;
    FullName: string;
    FontColor: TColor;
    FontStyles: TFontStyles;
    FontSize: integer;
  end;

  TKeyboardKey = record
    X: Real;
    Y: Real;
    W: Real;
    H: Real;
    A: Real;
    Mp: string;
    Ly: array[0..7] of string;
    Hr: THomeRowKeyMod;
  end;

  TfrmTiRouge = class(TForm)
    imgTiRouge: TImage;
    amTiRouge: TActionManager;
    actTest: TAction;
    mmTiRouge: TMainMenu;
    est1: TMenuItem;
    mainApplicationEvents: TApplicationEvents;
    actShowConfig: TAction;
    Actions1: TMenuItem;
    Showconfiguration1: TMenuItem;
    N1: TMenuItem;
    procedure actTestExecute(Sender: TObject);
    procedure cbLayersModifiersChange(Sender: TObject);
    procedure mainApplicationEventsActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure actShowConfigExecute(Sender: TObject);
  private
    { Private declarations }
    FisFirstAction: boolean;
    FResizedFactor: Real;
    zn: TKeyZone;
    FLayersList: array[0..NB_LAYERS - 1] of TLayerDefinition;

    procedure SetTextStartPosition(const paramLayer: integer; const paramKey: TKeyboardKey; const CenterX, CenterY: Real; const TextWidth, TextHeight: Integer; var StartX, StartY: Real);
    procedure ShowLayerKeyFunction(const paramLayerIndex: integer; const AKeyboardKey: TKeyboardKey; const paramCenterX, paramBottomY: Real);
    procedure LoadConfiguration;
    procedure SaveConfiguration;
    procedure InitializeLayerList;
  public
    { Public declarations }
  end;

var
  frmTiRouge: TfrmTiRouge;

implementation

uses
  // Delphi
  Vcl.Imaging.pngimage, System.Types, System.UITypes, System.Math,
  System.IniFiles,
  // Third party

  // TiRouge
  fTiRougeConfigurator;

{$R *.dfm}

const
  NB_KEYS = 36;

  {(*}
  LAYER_MODIFIER_BASE                  =  0;
  LY_ACSY                              =  1;
  LY_ACSH                              =  2;
  LY_NUMB                              =  3;
  LY_CRSR                              =  4;
  LY_FUNC                              =  5;
  LY_CONF                              =  6;
  LY_SYMA                              =  7;
  LAYER_MODIFIER_NUMBERS_LSHIFT        =  8;
  LAYER_MODIFIER_NUMBERS_RCTRL         =  9;
  LAYER_MODIFIER_NUMBERS_LSHIFT_RCRTRL = 10;
  LAYER_MODIFIER_NUMBERS_ALTGR         = 11;
  LAYER_MODIFIER_CURSORS               = 12;
  {*)}

  //      OEM 1 = ;
  //      OEM 2 = é
  //      OEM 3 = è
  //      OEM 4 = ^ (dead key)
  //      OEM 5 = à
  //      OEM 6 = ç
  //      OEM 7 = /
  //      OEM 8 = Right Ctrl
  //  OEM MINUS = -
  //   OEM PLUS = +
  //  OEM COMMA = ,
  // OEM PERIOD = .

const
{(*}
  MyKeys : array[0..pred(NB_KEYS)] of TKeyboardKey =
  (
//                                                                        D      A           A      N     C       F      C     S
//                                                                        E      C           C      U     R       U      O     Y
//                                                                        F      S           S      M     S       N      N     M
//                                                                        T      Y           H      B     R       C      F     A
    (X:	   0; Y: 40 ; W:94     ; H:94      ; A:0       ; Mp:'1,0'  ; Ly:('B'  , '^'       , '^'  , 'ß' , ''    , ''   , ''  , ''   ) ; Hr: hrkmNONE    ), // 00 - R1  L0
    (X:	 100; Y: 13 ; W:94     ; H:94      ; A:0       ; Mp:'1,1'  ; Ly:('Y'  , 'ë'       , 'Ë'  , ''  , ''    , ''   , ''  , 'Œ'  ) ; Hr: hrkmNONE    ), // 01 - R1  L1
    (X:	 200; Y:  0 ; W:94     ; H:94      ; A:0       ; Mp:'1,2'  ; Ly:('O'  , 'ê'       , 'Ê'  , '¼' , ''    , ''   , ''  , 'œ'  ) ; Hr: hrkmACSH    ), // 02 - R1  L2
    (X:	 300; Y: 13 ; W:94     ; H:94      ; A:0       ; Mp:'1,3'  ; Ly:('U'  , 'ô'       , 'Ô'  , '½' , ''    , ''   , ''  , 'µ'  ) ; Hr: hrkmCRSR    ), // 03 - R1  L3
    (X:	 400; Y: 13 ; W:94     ; H:94      ; A:0       ; Mp:'1,4'  ; Ly:('Z'  , 'û'       , 'Û'  , '¾' , ''    , ''   , '⟲' , 'Ω'  ) ; Hr: hrkmCONF    ), // 04 - R1  L4
    (X:	 673; Y: 13 ; W:94     ; H:94      ; A:0       ; Mp:'1,5'  ; Ly:('Q'  , ' '       , ' '  , '=' , '↖'   , ''   , '⟲' , ''   ) ; Hr: hrkmCONF    ), // 05 - R1  L5
    (X:	 773; Y: 13 ; W:94     ; H:94      ; A:0       ; Mp:'1,11' ; Ly:('L'  , '&'       , ' '  , '7' , ''    , '⑦' , ''  , '÷'  ) ; Hr: hrkmCRSR    ), // 06 - R1  R1
    (X:	 873; Y:  0 ; W:94     ; H:94      ; A:0       ; Mp:'1,10' ; Ly:('D'  , '*'       , ' '  , '8' , '⇞'   , '⑧' , ''  , 'º'  ) ; Hr: hrkmACSH    ), // 07 - R1  R2
    (X:	 973; Y: 13 ; W:94     ; H:94      ; A:0       ; Mp:'1,9'  ; Ly:('W'  , '('       , ' '  , '9' , ''    , '⑨' , ''  , '['  ) ; Hr: hrkmNONE    ), // 08 - R1  R3
    (X:	1073; Y: 40 ; W:94     ; H:94      ; A:0       ; Mp:'1,8'  ; Ly:('V'  , ')'       , ' '  , '0' , ''    , '⑩' , 'ᛒ0', ']'  ) ; Hr: hrkmNONE    ), // 09 - R1  R4
    (X:	   0; Y:140 ; W:94     ; H:94      ; A:0       ; Mp:'1,7'  ; Ly:('C'  , 'ç'       , 'Ç'  , ''  , ''    , ''   , ''  , '©'  ) ; Hr: hrkmLWin    ), // 10 - R1  R5
    (X:	 100; Y:113 ; W:94     ; H:94      ; A:0       ; Mp:'1,6'  ; Ly:('I'  , 'î'       , 'Î'  , '¶' , ''    , ''   , ''  , ''   ) ; Hr: hrkmLAlt    ), // 11 - R1  R6
    (X:	 200; Y:100 ; W:94     ; H:94      ; A:0       ; Mp:'2,0'  ; Ly:('E'  , 'é'       , 'É'  , '¹' , ''    , ''   , ''  , '€'  ) ; Hr: hrkmLCtrl   ), // 12 - R2  L0
    (X:	 300; Y:113 ; W:94     ; H:94      ; A:0       ; Mp:'2,1'  ; Ly:('A'  , 'à'       , 'À'  , '²' , ''    , ''   , ''  , 'æ'  ) ; Hr: hrkmLShift  ), // 13 - R2  L1
    (X:	 400; Y:113 ; W:94     ; H:94      ; A:0       ; Mp:'2,2'  ; Ly:(','  , 'ù'       , 'Ù'  , '³ ' , ''    , ''  , '⟲' , 'Æ'  ) ; Hr: hrkmRAlt    ), // 14 - R2  L2
    (X:	 673; Y:113 ; W:94     ; H:94      ; A:0       ; Mp:'2,3'  ; Ly:(';'  , '~'       , '~'  , '-' , '↘'   , ''   , '⏻' , '®'  ) ; Hr: hrkmRAlt    ), // 15 - R2  L3
    (X:	 773; Y:113 ; W:94     ; H:94      ; A:0       ; Mp:'2,4'  ; Ly:('H'  , '$'       , ' '  , '4' , '↑'   , '④' , 'ᛒ4', '↑'  ) ; Hr: hrkmLShift  ), // 16 - R2  L4
    (X:	 873; Y:100 ; W:94     ; H:94      ; A:0       ; Mp:'2,5'  ; Ly:('T'  , '%'       , ' '  , '5' , '⇟'   , '⑤' , ''  , '™'  ) ; Hr: hrkmLCtrl   ), // 17 - R2  L5
    (X:	 973; Y:113 ; W:94     ; H:94      ; A:0       ; Mp:'2,11' ; Ly:('S'  , '?'       , ' '  , '6' , ''    , '⑥' , ''  , '{'  ) ; Hr: hrkmLAlt    ), // 18 - R2  R1
    (X:	1073; Y:140 ; W:94     ; H:94      ; A:0       ; Mp:'2,10' ; Ly:('N'  , '_'       , ' '  , '*' , '⎀'   , '⑪' , ''  , '}'  ) ; Hr: hrkmLWin    ), // 19 - R2  R2
    (X:	   0; Y:240 ; W:94     ; H:94      ; A:0       ; Mp:'2,9'  ; Ly:('G'  , '`'       , '`'  , ''  , ''    , ''   , ''  , '¢'  ) ; Hr: hrkmSYMA    ), // 20 - R2  R3
    (X:	 100; Y:213 ; W:94     ; H:94      ; A:0       ; Mp:'2,8'  ; Ly:('X'  , 'ï'       , 'Ï'  , '×' , ''    , ''   , ''  , ''   ) ; Hr: hrkmNONE    ), // 21 - R2  R4
    (X:	 200; Y:200 ; W:94     ; H:94      ; A:0       ; Mp:'2,7'  ; Ly:('J'  , 'è'       , 'È'  , ' ' , ''    , ''   , ''  , ''   ) ; Hr: hrkmACSY    ), // 22 - R2  R5
    (X:	 300; Y:213 ; W:94     ; H:94      ; A:0       ; Mp:'2,6'  ; Ly:('K'  , 'â'       , 'Â'  , ' ' , ''    , ''   , ''  , ''   ) ; Hr: hrkmNUMB    ), // 23 - R2  R6
    (X:	 400; Y:213 ; W:94     ; H:94      ; A:0       ; Mp:'3,0'  ; Ly:('.'  , '´'       , '´'  , ' ' , ''    , ''   , ''  , '♪'  ) ; Hr: hrkmFUNC    ), // 24 - R3  L0
    (X:	 673; Y:213 ; W:94     ; H:94      ; A:0       ; Mp:'3,1'  ; Ly:('/'  , '¨'       , '¨'  , '+' , '←'   , ''   , 'ᛒ⟲', '←'  ) ; Hr: hrkmFUNC    ), // 25 - R3  L1
    (X:	 773; Y:213 ; W:94     ; H:94      ; A:0       ; Mp:'3,2'  ; Ly:('R'  , '!'       , ' '  , '1' , '↓'   , '①' , 'ᛒ1', '↓'  ) ; Hr: hrkmNUMB    ), // 26 - R3  L2
    (X:	 873; Y:200 ; W:94     ; H:94      ; A:0       ; Mp:'3,3'  ; Ly:('M'  , '@'       , ' '  , '2' , '→'   , '②' , 'ᛒ2', '→'  ) ; Hr: hrkmACSY    ), // 27 - R3  L3
    (X:	 973; Y:213 ; W:94     ; H:94      ; A:0       ; Mp:'3,4'  ; Ly:('F'  , '#'       , ' '  , '3' , ''    , '③' , 'ᛒ3', '<'  ) ; Hr: hrkmNONE    ), // 28 - R3  L4
    (X:	1073; Y:240 ; W:94     ; H:94      ; A:0       ; Mp:'3,5'  ; Ly:('P'  , '+'       , ' '   ,'/' , '⌦'   , '⑫' , ''  , '>'  ) ; Hr: hrkmSYMA    ), // 29 - R3  L5
    (X:	 240; Y:325 ; W:94     ; H:94      ; A:0       ; Mp:'3,11' ; Ly:('⎋'  , ' '       , ' '  , ' ' , ''    , ''   , ''  , ''   ) ; Hr: hrkmNONE    ), // 30-  R3  R1
    (X:	 340; Y:325 ; W:94     ; H:94      ; A:0       ; Mp:'3,10' ; Ly:('⌫' , ' '       , ' '  , ' ' , ''    , ''   , ''  , ''    ) ; Hr: hrkmNONE    ), // 31-  R3  R2
    (X:	 450; Y:339 ; W:94     ; H:94      ; A:15      ; Mp:'3,9'  ; Ly:('⇥' , ' '       , ' '  , ' ' , ''    , ''   , ''  , ''    ) ; Hr: hrkmNONE    ), // 32 - R3  R3
    (X:	 624; Y:339 ; W:94     ; H:94      ; A:345     ; Mp:'3,8'  ; Ly:('↵' , ' '       , ' '  , ' ' , ''    , ''   , ''  , ''    ) ; Hr: hrkmNONE    ), // 33 - R3  R4
    (X:	 733; Y:325 ; W:94     ; H:94      ; A:0       ; Mp:'3,7'  ; Ly:('␣' , ' '       , ' '  , ' ' , ''    , ''   , ''  , ''    ) ; Hr: hrkmNONE    ), // 34 - R3  R5
    (X:	 833; Y:325 ; W:94     ; H:94      ; A:0       ; Mp:'3,6'  ; Ly:(' ' , ' '       , ' '  , ' ' , ''    , ''   , ''  , ''    ) ; Hr: hrkmNONE    ) // 35 - R3  R6
  );
{*)}

procedure TfrmTiRouge.SetTextStartPosition(const paramLayer: integer; const paramKey: TKeyboardKey; const CenterX, CenterY: Real; const TextWidth, TextHeight: Integer; var StartX, StartY: Real);
const
  iBOTTOMBORDER = 5;
  iTOPBORDER = 5;
var
  DeltaX: real;
  DeltaY: real;
  Angle: real;
begin
  StartX := 0;
  StartY := 0;

  case paramLayer of
    LAYER_MODIFIER_BASE:
      begin
        StartX := zn.C2 - (TextWidth / 2);
        StartY := zn.R2 - (TextHeight / 2);
      end;

    LY_ACSY:
      begin
        StartX := zn.c2 - (TextWidth / 2);
        StartY := zn.r3 - (TextHeight / 2);
      end;

    LY_ACSH:
      begin
        StartX := zn.c2 - (TextWidth / 2);
        StartY := zn.r1 - (TextHeight / 2) + 3;
      end;

    LY_NUMB:
      begin
        StartX := zn.c3 - (TextWidth / 2);
        StartY := zn.r3 - (TextHeight / 2);
      end;

    LY_CRSR:
      begin
        StartX := zn.c3 - (TextWidth / 2);
        StartY := zn.r2 - (TextHeight / 2);
      end;

    LY_FUNC:
      begin
        StartX := zn.c3 - (TextWidth / 2);
        StartY := zn.r1 - (TextHeight / 2);
      end;

    LY_CONF:
      begin
        StartX := zn.c1 - (TextWidth / 2);
        StartY := zn.r1 - (TextHeight / 2);
      end;

    LY_SYMA:
      begin
        StartX := zn.c1 - (TextWidth / 2);
        StartY := zn.r3 - (TextHeight / 2);
      end;

    LAYER_MODIFIER_CURSORS:
      begin
        StartX := 0;
        StartY := 0;
      end;

    LAYER_MODIFIER_NUMBERS_LSHIFT:
      begin
        StartX := 0;
        StartY := 0;
      end;

    LAYER_MODIFIER_NUMBERS_RCTRL:
      begin
        StartX := 0;
        StartY := 0;
      end;

    LAYER_MODIFIER_NUMBERS_LSHIFT_RCRTRL:
      begin
        StartX := 0;
        StartY := 0;
      end;

    LAYER_MODIFIER_NUMBERS_ALTGR:
      begin
        StartX := 0;
        StartY := 0;
      end;
  end;

  // Calculate the difference between the Start point and Center point
  DeltaX := StartX - CenterX;
  DeltaY := StartY - CenterY;

  // Apply the rotation formulas
  Angle := DegToRad(paramKey.A);
  StartX := CenterX + (DeltaX * Cos(Angle)) - (DeltaY * Sin(Angle));
  StartY := CenterY + (DeltaX * Sin(Angle)) + (DeltaY * Cos(Angle));
end;

procedure TfrmTiRouge.ShowLayerKeyFunction(const paramLayerIndex: integer; const AKeyboardKey: TKeyboardKey; const paramCenterX, paramBottomY: Real);
var
  sLayerName: string;
  TextHeight, TextWidth: integer;
  StartX, StartY: real;
  localCanvas: TCanvas;
  iKeyLayerIndex: integer;
begin
  iKeyLayerIndex := ord(AKeyboardKey.Hr);
  sLayerName := FLayersList[iKeyLayerIndex].FullName;
  localCanvas := imgTiRouge.Picture.Bitmap.Canvas;
  localCanvas.Font.Orientation := 0;
  localCanvas.Font.Size := 14;
  localCanvas.Font.Style := [fsBold];
  localCanvas.Font.Color := FLayersList[iKeyLayerIndex].FontColor;
  TextHeight := localCanvas.TextHeight(sLayerName);
  TextWidth := localCanvas.TextWidth(sLayerName);
  StartX := paramCenterX - (TextWidth / 2);
  StartY := paramBottomY - TextHeight + 2;
  localCanvas.TextOut(Round(StartX), Round(StartY), sLayerName);
end;

procedure TfrmTiRouge.actShowConfigExecute(Sender: TObject);
begin
  frmTiRougeConfigurator.Show;
end;

procedure TfrmTiRouge.actTestExecute(Sender: TObject);
var
  OFFSET_X: real;
  OFFSET_Y: real;
  iIndexKey: integer;
  CenterX, CenterY: Real;
  Angle: Real;
  Corner1, Corner2, Corner3, Corner4: TKeyboardKey;
  RotCorner1, RotCorner2, RotCorner3, RotCorner4: TKeyboardKey;
  TextWidth, TextHeight: integer;
  sTextToWrite: string;
  iLayerIndex: integer;
  StartX, StartY: real;
  localKey: TKeyboardKey;
begin
  // Ensure the TImage's Bitmap is initialized and has proper dimensions
  if imgTiRouge.Picture.Bitmap = nil then
    imgTiRouge.Picture.Bitmap := TBitmap.Create;

  // Set the dimensions of the Bitmap to match the desired area for drawing
  imgTiRouge.Picture.Bitmap.Width := imgTiRouge.Width;
  imgTiRouge.Picture.Bitmap.Height := imgTiRouge.Height;

  // Fill the background with white color
  imgTiRouge.Picture.Bitmap.Canvas.Brush.Color := clBlack;
  imgTiRouge.Picture.Bitmap.Canvas.FillRect(Rect(0, 0, imgTiRouge.Picture.Bitmap.Width, imgTiRouge.Picture.Bitmap.Height));

  FResizedFactor := 1.5;
  OFFSET_X := 50 * FResizedFactor;
  OFFSET_Y := 50 * FResizedFactor;

  iIndexKey := 0;
  while iIndexKey < NB_KEYS do
  begin
    imgTiRouge.Picture.Bitmap.Canvas.Pen.Color := $A0A0A0;
    imgTiRouge.Picture.Bitmap.Canvas.Pen.Width := 3;
    imgTiRouge.Picture.Bitmap.Canvas.Pen.Style := psSolid;
    imgTiRouge.Picture.Bitmap.Canvas.Brush.Style := bsSolid;
    imgTiRouge.Picture.Bitmap.Canvas.Brush.Color := $E0E0E0;
    imgTiRouge.Picture.Bitmap.Canvas.Font.Name := 'Segoe UI Symbol';

    localKey := MyKeys[iIndexKey];

    if localKey.Ly[0] <> '' then
    begin
      CenterX := OFFSET_X + localKey.X * FResizedFactor;
      CenterY := OFFSET_Y + localKey.Y * FResizedFactor;

      zn.Y1 := Trunc(CenterY - (localKey.H / 2) * FResizedFactor);
      zn.Y5 := Trunc(CenterY + (localKey.H / 2) * FResizedFactor);
      zn.Y4 := zn.Y5 - 20;
      zn.Y2 := Trunc(zn.Y1 + ((zn.Y4 - zn.Y1) * 0.30));
      zn.Y3 := Trunc(zn.Y4 - ((zn.Y4 - zn.Y1) * 0.30));
      zn.R1 := (zn.Y1 + zn.Y2) div 2;
      zn.R2 := (zn.Y2 + zn.Y3) div 2;
      zn.R3 := (zn.Y3 + zn.Y4) div 2;
      zn.X1 := Trunc(CenterX - (localKey.W / 2) * FResizedFactor);
      zn.X4 := Trunc(CenterX + (localKey.W / 2) * FResizedFactor);
      zn.X2 := Trunc(zn.X1 + ((zn.X4 - zn.X1) * 0.30));
      zn.X3 := Trunc(zn.X4 - ((zn.X4 - zn.X1) * 0.30));
      zn.C1 := (zn.X1 + zn.X2) div 2;
      zn.C2 := (zn.X2 + zn.X3) div 2;
      zn.C3 := (zn.X3 + zn.X4) div 2;

      Corner1.X := CenterX - (localKey.W / 2) * FResizedFactor;
      Corner1.Y := CenterY - (localKey.H / 2) * FResizedFactor;

      Corner2.X := CenterX + (localKey.W / 2) * FResizedFactor;
      Corner2.Y := CenterY - (localKey.H / 2) * FResizedFactor;

      Corner3.X := CenterX + (localKey.W / 2) * FResizedFactor;
      Corner3.Y := CenterY + (localKey.H / 2) * FResizedFactor;

      Corner4.X := CenterX - (localKey.W / 2) * FResizedFactor;
      Corner4.Y := CenterY + (localKey.H / 2) * FResizedFactor;

      Angle := DegToRad(localKey.A);

      RotCorner1.X := CenterX + (Corner1.X - CenterX) * Cos(Angle) - (Corner1.Y - CenterY) * Sin(Angle);
      RotCorner1.Y := CenterY + (Corner1.X - CenterX) * Sin(Angle) + (Corner1.Y - CenterY) * Cos(Angle);

      RotCorner2.X := CenterX + (Corner2.X - CenterX) * Cos(Angle) - (Corner2.Y - CenterY) * Sin(Angle);
      RotCorner2.Y := CenterY + (Corner2.X - CenterX) * Sin(Angle) + (Corner2.Y - CenterY) * Cos(Angle);

      RotCorner3.X := CenterX + (Corner3.X - CenterX) * Cos(Angle) - (Corner3.Y - CenterY) * Sin(Angle);
      RotCorner3.Y := CenterY + (Corner3.X - CenterX) * Sin(Angle) + (Corner3.Y - CenterY) * Cos(Angle);

      RotCorner4.X := CenterX + (Corner4.X - CenterX) * Cos(Angle) - (Corner4.Y - CenterY) * Sin(Angle);
      RotCorner4.Y := CenterY + (Corner4.X - CenterX) * Sin(Angle) + (Corner4.Y - CenterY) * Cos(Angle);

      // We do not draw the key if there is nothing on layer 0.
      imgTiRouge.Picture.Bitmap.Canvas.MoveTo(Trunc(RotCorner1.X), Trunc(RotCorner1.Y));
      imgTiRouge.Picture.Bitmap.Canvas.LineTo(Trunc(RotCorner2.X), Trunc(RotCorner2.Y));
      imgTiRouge.Picture.Bitmap.Canvas.LineTo(Trunc(RotCorner3.X), Trunc(RotCorner3.Y));
      imgTiRouge.Picture.Bitmap.Canvas.LineTo(Trunc(RotCorner4.X), Trunc(RotCorner4.Y));
      imgTiRouge.Picture.Bitmap.Canvas.LineTo(Trunc(RotCorner1.X), Trunc(RotCorner1.Y));

      imgTiRouge.Picture.Bitmap.Canvas.Brush.Color := $C0C0C0;
      imgTiRouge.Picture.Bitmap.Canvas.FloodFill(Trunc(CenterX), Trunc(CenterY), imgTiRouge.Picture.Bitmap.Canvas.Pen.Color, fsBorder);

      imgTiRouge.Picture.Bitmap.Canvas.MoveTo(Trunc(RotCorner1.X), Trunc(RotCorner1.Y));
      imgTiRouge.Picture.Bitmap.Canvas.LineTo(Trunc(RotCorner2.X), Trunc(RotCorner2.Y));
      imgTiRouge.Picture.Bitmap.Canvas.LineTo(Trunc(RotCorner3.X), Trunc(RotCorner3.Y));
      imgTiRouge.Picture.Bitmap.Canvas.LineTo(Trunc(RotCorner4.X), Trunc(RotCorner4.Y));
      imgTiRouge.Picture.Bitmap.Canvas.LineTo(Trunc(RotCorner1.X), Trunc(RotCorner1.Y));

      if frmTiRougeConfigurator.ckbShowKeyZones.Checked then
      begin
        if localKey.Y <= 240 then
        begin
          imgTiRouge.Picture.Bitmap.Canvas.Pen.Color := $A0A0A0;
          imgTiRouge.Picture.Bitmap.Canvas.Pen.Width := 1;

          imgTiRouge.Picture.Bitmap.Canvas.MoveTo(zn.X1, zn.Y2);
          imgTiRouge.Picture.Bitmap.Canvas.LineTo(zn.X4, zn.Y2);
          imgTiRouge.Picture.Bitmap.Canvas.MoveTo(zn.X1, zn.Y3);
          imgTiRouge.Picture.Bitmap.Canvas.LineTo(zn.X4, zn.Y3);
          imgTiRouge.Picture.Bitmap.Canvas.MoveTo(zn.X1, zn.Y4);
          imgTiRouge.Picture.Bitmap.Canvas.LineTo(zn.X4, zn.Y4);

          imgTiRouge.Picture.Bitmap.Canvas.MoveTo(zn.X2, zn.Y1);
          imgTiRouge.Picture.Bitmap.Canvas.LineTo(zn.X2, zn.Y4);
          imgTiRouge.Picture.Bitmap.Canvas.MoveTo(zn.X3, zn.Y1);
          imgTiRouge.Picture.Bitmap.Canvas.LineTo(zn.X3, zn.Y4);
        end;
      end;

      // Text will be transparent...
      imgTiRouge.Picture.Bitmap.Canvas.Brush.Style := bsClear;

      for iLayerIndex := 0 to length(FLayersList) - 1 do
      begin
        if FLayersList[iLayerIndex].Checkbox.Checked then
        begin
          sTextToWrite := localKey.Ly[iLayerIndex];

          // Set font properties based on current layer
          imgTiRouge.Picture.Bitmap.Canvas.Font.Orientation := 0;
          imgTiRouge.Picture.Bitmap.Canvas.Font.Color := FLayersList[iLayerIndex].FontColor;
          imgTiRouge.Picture.Bitmap.Canvas.Font.Size := FLayersList[iLayerIndex].FontSize;
          imgTiRouge.Picture.Bitmap.Canvas.Font.Style := FLayersList[iLayerIndex].FontStyles;

          // Measure the text dimensions
          TextWidth := imgTiRouge.Picture.Bitmap.Canvas.TextWidth(sTextToWrite);
          TextHeight := imgTiRouge.Picture.Bitmap.Canvas.TextHeight('Mq');

          // Calculate the top-left corner of the text
          SetTextStartPosition(iLayerIndex, localKey, CenterX, CenterY, TextWidth, TextHeight, StartX, StartY);

          // Actually draw the text
          imgTiRouge.Picture.Bitmap.Canvas.Font.Orientation := Trunc(localKey.A) * -10;
          imgTiRouge.Picture.Bitmap.Canvas.TextOut(Trunc(StartX), Trunc(StartY), sTextToWrite);

          if (ord(localKey.Hr) = iLayerIndex) then
            ShowLayerKeyFunction(iLayerIndex, localKey, CenterX, Corner4.Y);
        end;
      end;
    end;

    inc(iIndexKey);
  end;
end;

procedure TfrmTiRouge.cbLayersModifiersChange(Sender: TObject);
begin
  actTestExecute(actTest);
end;

procedure TfrmTiRouge.FormCreate(Sender: TObject);
begin
  FisFirstAction := True;
end;

procedure TfrmTiRouge.FormShow(Sender: TObject);
begin
  frmTiRougeConfigurator.Show;
  Caption := 'TiRouge 1.0';
  frmTiRougeConfigurator.Caption := Caption + ' - Configurator';

end;

procedure TfrmTiRouge.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveConfiguration;
end;

procedure TfrmTiRouge.mainApplicationEventsActivate(Sender: TObject);
begin
  Application.ProcessMessages;
  if FisFirstAction then
  begin
    FisFirstAction := False;
    InitializeLayerList;
    LoadConfiguration;
    Application.ProcessMessages;
    actTestExecute(actTest);
  end;
end;

procedure TfrmTiRouge.LoadConfiguration;
var
  IniFile: TIniFile;
  iIndex: Integer;
begin
  // Load windows position from last time.
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    WindowState := TWindowState(IniFile.ReadInteger('MainForm', 'WindowState', Integer(wsNormal)));
    if WindowState = wsNormal then
    begin
      Left := IniFile.ReadInteger('MainForm', 'Left', Left);
      Top := IniFile.ReadInteger('MainForm', 'Top', Top);
      Width := IniFile.ReadInteger('MainForm', 'Width', Width);
      Height := IniFile.ReadInteger('MainForm', 'Height', Height);
    end;

    frmTiRougeConfigurator.ckbShowKeyZones.Checked := IniFile.ReadBool('Checkboxes', 'ShowKeyZones', frmTiRougeConfigurator.ckbShowKeyZones.Checked);
    frmTiRougeConfigurator.ckbShowKeyZones.OnClick := actTestExecute;
    for iIndex := 0 to length(FLayersList) - 1 do
      FLayersList[iIndex].Checkbox.Checked := IniFile.ReadBool('Checkboxes', Format('LayerModifier_%d', [iIndex]), FLayersList[iIndex].Checkbox.Checked);
  finally
    IniFile.Free;
  end;
end;

procedure TfrmTiRouge.SaveConfiguration;
var
  IniFile: TIniFile;
  iIndex: Integer;
begin
  // Save windows position for next time.
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    // If form is maximized, save normal-state bounds.
    if WindowState = wsMaximized then
    begin
      IniFile.WriteInteger('MainForm', 'WindowState', Integer(wsNormal));
    end
    else
    begin
      IniFile.WriteInteger('MainForm', 'WindowState', Integer(WindowState));
      IniFile.WriteInteger('MainForm', 'Left', Left);
      IniFile.WriteInteger('MainForm', 'Top', Top);
      IniFile.WriteInteger('MainForm', 'Width', Width);
      IniFile.WriteInteger('MainForm', 'Height', Height);
    end;

    IniFile.WriteBool('Checkboxes', 'ShowKeyZones', frmTiRougeConfigurator.ckbShowKeyZones.Checked);
    for iIndex := 0 to length(FLayersList) - 1 do
      IniFile.WriteBool('Checkboxes', Format('LayerModifier_%d', [iIndex]), FLayersList[iIndex].Checkbox.Checked);

  finally
    IniFile.Free;
  end;
end;

procedure TfrmTiRouge.InitializeLayerList;
begin
  FLayersList[ord(hrkmDEFT)].Checkbox := frmTiRougeConfigurator.ckbLY_DFLT;
  FLayersList[ord(hrkmDEFT)].FullName := 'Default';
  FLayersList[ord(hrkmDEFT)].FontColor := clBlack;
  FLayersList[ord(hrkmDEFT)].FontStyles := [fsBold];
  FLayersList[ord(hrkmDEFT)].FontSize := 40;
  FLayersList[ord(hrkmDEFT)].Checkbox.OnClick := actTestExecute;

  FLayersList[ord(hrkmACSY)].Checkbox := frmTiRougeConfigurator.ckbLY_ACSY;
  FLayersList[ord(hrkmACSY)].FullName := 'AccentLow';
  FLayersList[ord(hrkmACSY)].FontColor := clBlue;
  FLayersList[ord(hrkmACSY)].FontStyles := [fsBold];
  FLayersList[ord(hrkmACSY)].FontSize := 25;
  FLayersList[ord(hrkmACSY)].Checkbox.OnClick := actTestExecute;

  FLayersList[ord(hrkmACSH)].Checkbox := frmTiRougeConfigurator.ckbLY_ACSH;
  FLayersList[ord(hrkmACSH)].FullName := 'AccentUpr';
  FLayersList[ord(hrkmACSH)].FontColor := clPurple;
  FLayersList[ord(hrkmACSH)].FontStyles := [fsBold];
  FLayersList[ord(hrkmACSH)].FontSize := 25;
  FLayersList[ord(hrkmACSH)].Checkbox.OnClick := actTestExecute;

  FLayersList[ord(hrkmNUMB)].Checkbox := frmTiRougeConfigurator.ckbLY_NUMB;
  FLayersList[ord(hrkmNUMB)].FullName := 'Numbers';
  FLayersList[ord(hrkmNUMB)].FontColor := clTeal;
  FLayersList[ord(hrkmNUMB)].FontStyles := [fsBold];
  FLayersList[ord(hrkmNUMB)].FontSize := 25;
  FLayersList[ord(hrkmNUMB)].Checkbox.OnClick := actTestExecute;

  FLayersList[ord(hrkmCRSR)].Checkbox := frmTiRougeConfigurator.ckbLY_CRSR;
  FLayersList[ord(hrkmCRSR)].FullName := 'Cursors';
  FLayersList[ord(hrkmCRSR)].FontColor := clGreen;
  FLayersList[ord(hrkmCRSR)].FontStyles := [fsBold];
  FLayersList[ord(hrkmCRSR)].FontSize := 25;
  FLayersList[ord(hrkmCRSR)].Checkbox.OnClick := actTestExecute;

  FLayersList[ord(hrkmFUNC)].Checkbox := frmTiRougeConfigurator.ckbLY_FUNC;
  FLayersList[ord(hrkmFUNC)].FullName := 'Functions';
  FLayersList[ord(hrkmFUNC)].FontColor := clRed;
  FLayersList[ord(hrkmFUNC)].FontStyles := [];
  FLayersList[ord(hrkmFUNC)].FontSize := 25;
  FLayersList[ord(hrkmFUNC)].Checkbox.OnClick := actTestExecute;

  FLayersList[ord(hrkmCONF)].Checkbox := frmTiRougeConfigurator.ckbLY_CONF;
  FLayersList[ord(hrkmCONF)].FullName := 'Config';
  FLayersList[ord(hrkmCONF)].FontColor := clNavy;
  FLayersList[ord(hrkmCONF)].FontStyles := [];
  FLayersList[ord(hrkmCONF)].FontSize := 20;
  FLayersList[ord(hrkmCONF)].Checkbox.OnClick := actTestExecute;

  FLayersList[ord(hrkmSYMA)].Checkbox := frmTiRougeConfigurator.ckbLY_SYMA;
  FLayersList[ord(hrkmSYMA)].FullName := 'Symbols A';
  FLayersList[ord(hrkmSYMA)].FontColor := clMaroon;
  FLayersList[ord(hrkmSYMA)].FontStyles := [fsBold];
  FLayersList[ord(hrkmSYMA)].FontSize := 25;
  FLayersList[ord(hrkmSYMA)].Checkbox.OnClick := actTestExecute;
end;

end.

