unit fTiRouge;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.ActnMan, Vcl.ExtCtrls, Vcl.PlatformDefaultStyleActnCtrls, Vcl.Menus,
  Vcl.StdCtrls, Vcl.AppEvnts, Vcl.CheckLst;

type
  TForm1 = class(TForm)
    imgTiRouge: TImage;
    amTiRouge: TActionManager;
    actTest: TAction;
    mmTiRouge: TMainMenu;
    est1: TMenuItem;
    lblLayerModifier: TLabel;
    mainApplicationEvents: TApplicationEvents;
    clbLayerModifier: TCheckListBox;
    procedure actTestExecute(Sender: TObject);
    procedure cbLayersModifiersChange(Sender: TObject);
    procedure mainApplicationEventsActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FisFirstAction: boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  Vcl.Imaging.pngimage, System.Types, System.UITypes, System.Math;

{$R *.dfm}

const
  NB_KEYS = 36;
  NB_LAYERS = 12;

  {(*}
  LAYER_MODIFIER_BASE                  =  0;
  LAYER_MODIFIER_BASE_LSHIFT           =  1;
  LAYER_MODIFIER_BASE_RCTRL            =  2;
  LAYER_MODIFIER_BASE_LSHIFT_RCTRL     =  3;
  LAYER_MODIFIER_BASE_ALTGR            =  4;
  LAYER_MODIFIER_NUMBERS               =  5;
  LAYER_MODIFIER_NUMBERS_LSHIFT        =  6;
  LAYER_MODIFIER_NUMBERS_RCTRL         =  7;
  LAYER_MODIFIER_NUMBERS_LSHIFT_RCRTRL =  8;
  LAYER_MODIFIER_NUMBERS_ALTGR         =  9;
  LAYER_MODIFIER_FUNCTION_KEYS         = 10;
  LAYER_MODIFIER_CURSORS               = 11;

  COLOR_BASE                  = clBlack;
  COLOR_BASE_LSHIFT           = clBlue;
  COLOR_BASE_RCTRL            = clPurple;
  COLOR_BASE_LSHIFT_RCTRL     = clTeal;
  COLOR_BASE_ALTGR            = clNavy;
  COLOR_NUMBERS               = clGreen;
  COLOR_NUMBERS_LSHIFT        = clMaroon;
  COLOR_NUMBERS_RCTRL         = clPurple;
  COLOR_NUMBERS_LSHIFT_RCRTRL = clTeal;
  COLOR_NUMBERS_ALTGR         = clNavy;
  COLOR_FUNCTION_KEYS         = clFuchsia;
  COLOR_CURSORS               = clNavy;
  {*)}

type
  THomeRowKeyMod = (hrkmNone, hrkmShift, hrkmLCtrl, hrkmRCtrl, hrkmSftRCtrl, hrkmAlt, hrkmAltGr, hrkmGui, hrkmNbr, hrkmSNbr, hrkmFctn, hrkmCrsr);

  TKeyboardKey = record
    X: Real;
    Y: Real;
    W: Real;
    H: Real;
    A: Real;
    Mp: string;
    Ly: array[0..pred(NB_LAYERS)] of string;
    Hr: THomeRowKeyMod;
  end;

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
    (X:	   0; Y: 40 ; W:94     ; H:94      ; A:0       ; Mp:'1,0'  ; Ly:('b'      , 'ú'       , 'Ú'  , ' ' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 00 - R1  L0
    (X:	 100; Y: 13 ; W:94     ; H:94      ; A:0       ; Mp:'1,1'  ; Ly:('y'      , 'í'       , 'Í'  , ' ' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 01 - R1  L1
    (X:	 200; Y:  0 ; W:94     ; H:94      ; A:0       ; Mp:'1,2'  ; Ly:('o'      , 'ê'       , 'Ê'  , ' ' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 02 - R1  L2
    (X:	 300; Y: 13 ; W:94     ; H:94      ; A:0       ; Mp:'1,3'  ; Ly:('u'      , 'ù'       , 'Ù'  , ' ' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmSftRCtrl), // 03 - R1  L3
    (X:	 400; Y: 13 ; W:94     ; H:94      ; A:0       ; Mp:'1,4'  ; Ly:('z'      , 'û'       , 'Û'  , ' ' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 04 - R1  L4
    (X:	 673; Y: 13 ; W:94     ; H:94      ; A:0       ; Mp:'1,5'  ; Ly:('q'      , ' '       , ' '  , '=' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmFctn    ), // 05 - R1  L5
    (X:	 773; Y: 13 ; W:94     ; H:94      ; A:0       ; Mp:'1,11' ; Ly:('l'      , '&'       , ' '  , '7' , '°'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 06 - R1  R1
    (X:	 873; Y:  0 ; W:94     ; H:94      ; A:0       ; Mp:'1,10' ; Ly:('d'      , '*'       , ' '  , '8' , ''    , '7'  , '&' , '' , '⅞', '{', 'F7'  ,'α' ) ; Hr: hrkmNone    ), // 07 - R1  R2
    (X:	0973; Y: 13 ; W:94     ; H:94      ; A:0       ; Mp:'1,9'  ; Ly:('w'      , '('       , ' '  , '9' , ''    , '8'  , '*' , '' , '™', '}', 'F8'  ,'↑' ) ; Hr: hrkmSftRCtrl), // 08 - R1  R3
    (X:	1073; Y: 40 ; W:94     ; H:94      ; A:0       ; Mp:'1,8'  ; Ly:('v'      , ')'       , ' '  , '0' , ''    , '9'  , '(' , '' , '±', '[', 'F9'  ,'↑↑') ; Hr: hrkmNone    ), // 09 - R1  R4
    (X:	   0; Y:140 ; W:94     ; H:94      ; A:0       ; Mp:'1,7'  ; Ly:('c'      , 'ç'       , 'Ç'  , ' ' , ''    , '0'  , ')' , '' , '' , ']', 'F10' ,''  ) ; Hr: hrkmNone    ), // 10 - R1  R5
    (X:	 100; Y:113 ; W:94     ; H:94      ; A:0       ; Mp:'1,6'  ; Ly:('i'      , 'î'       , 'Î'  , ' ' , '«'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 11 - R1  R6
    (X:	 200; Y:100 ; W:94     ; H:94      ; A:0       ; Mp:'2,0'  ; Ly:('e'      , 'é'       , 'É'  , ' ' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 12 - R2  L0
    (X:	 300; Y:113 ; W:94     ; H:94      ; A:0       ; Mp:'2,1'  ; Ly:('a'      , 'à'       , 'À'  , ' ' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmGui     ), // 13 - R2  L1
    (X:	 400; Y:113 ; W:94     ; H:94      ; A:0       ; Mp:'2,2'  ; Ly:(','      , 'â'       , 'Â'  , ' ' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmAlt     ), // 14 - R2  L2
    (X:	 673; Y:113 ; W:94     ; H:94      ; A:0       ; Mp:'2,3'  ; Ly:(';'      , ' '       , ' '  , '-' , '€'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmLCtrl   ), // 15 - R2  L3
    (X:	 773; Y:113 ; W:94     ; H:94      ; A:0       ; Mp:'2,4'  ; Ly:('h'      , '$'       , ' '  , '4' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmShift   ), // 16 - R2  L4
    (X:	 873; Y:100 ; W:94     ; H:94      ; A:0       ; Mp:'2,5'  ; Ly:('t'      , '%'       , ' '  , '5' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmSNbr    ), // 17 - R2  L5
    (X:	 973; Y:113 ; W:94     ; H:94      ; A:0       ; Mp:'2,11' ; Ly:('s'      , '?'       , ' '  , '6' , '<'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 18 - R2  R1
    (X:	1073; Y:140 ; W:94     ; H:94      ; A:0       ; Mp:'2,10' ; Ly:('n'      , '_'       , ' '  , '*' , ''    , '4'  , '$' , '¼', '€', '' , 'F4'  ,'←' ) ; Hr: hrkmShift   ), // 19 - R2  R2
    (X:	   0; Y:240 ; W:94     ; H:94      ; A:0       ; Mp:'2,9'  ; Ly:('g'      , 'ü'       , 'Ü'  , ' ' , ''    , '5'  , '%' , '½', '⅜', '' , 'F5'  ,'↓' ) ; Hr: hrkmLCtrl   ), // 20 - R2  R3
    (X:	 100; Y:213 ; W:94     ; H:94      ; A:0       ; Mp:'2,8'  ; Ly:('x'      , 'ï'       , 'Ï'  , ' ' , ''    , '6'  , '?' , '¾', '⅝', '' , 'F6'  ,'→' ) ; Hr: hrkmAlt     ), // 21 - R2  R4
    (X:	 200; Y:200 ; W:94     ; H:94      ; A:0       ; Mp:'2,7'  ; Ly:('j'      , 'è'       , 'È'  , ' ' , ''    , '-'  , '_' , '' , '' , '' , 'F11' ,''  ) ; Hr: hrkmGui     ), // 22 - R2  R5
    (X:	 300; Y:213 ; W:94     ; H:94      ; A:0       ; Mp:'2,6'  ; Ly:('k'      , 'ë'       , 'Ë'  , ' ' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 23 - R2  R6
    (X:	 400; Y:213 ; W:94     ; H:94      ; A:0       ; Mp:'3,0'  ; Ly:('.'      , 'ô'       , 'Ô'  , ' ' , '`'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 24 - R3  L0
    (X:	 673; Y:213 ; W:94     ; H:94      ; A:0       ; Mp:'3,1'  ; Ly:('/'      , ' '       , ' '  , '+' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 25 - R3  L1
    (X:	 773; Y:213 ; W:94     ; H:94      ; A:0       ; Mp:'3,2'  ; Ly:('r'      , '!'       , ' '  , '1' , '»'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmAltGr   ), // 26 - R3  L2
    (X:	 873; Y:200 ; W:94     ; H:94      ; A:0       ; Mp:'3,3'  ; Ly:('m'      , '@'       , ' '  , '2' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmRCtrl   ), // 27 - R3  L3
    (X:	 973; Y:213 ; W:94     ; H:94      ; A:0       ; Mp:'3,4'  ; Ly:('f'      , '#'       , ' '  , '3' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNbr     ), // 28 - R3  L4
    (X:	1073; Y:240 ; W:94     ; H:94      ; A:0       ; Mp:'3,5'  ; Ly:('p'      , '+'       , ' '   ,'/' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmCrsr    ), // 29 - R3  L5
    (X:	 240; Y:325 ; W:94     ; H:94      ; A:0       ; Mp:'3,11' ; Ly:('⎋'      , ' '       , ' '  , ' ' , '>'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 30-  R3  R1
    (X:	 340; Y:325 ; W:94     ; H:94      ; A:0       ; Mp:'3,10' ; Ly:('⌫'      , ' '       , ' '  , ' ' , ''    , '1'  , '!' , '¹', '¡', '' , 'F1'  ,'Ω' ) ; Hr: hrkmNone    ), // 31-  R3  R2
    (X:	 450; Y:339 ; W:94     ; H:94      ; A:15      ; Mp:'3,9'  ; Ly:('⇥'      , ' '       , ' '  , ' ' , ''    , '2'  , '@' , '²', '' , '' , 'F2'  ,'q' ) ; Hr: hrkmRCtrl   ), // 32 - R3  R3
    (X:	 624; Y:339 ; W:94     ; H:94      ; A:345     ; Mp:'3,8'  ; Ly:('↵'      , ' '       , ' '  , ' ' , ''    , '3'  , '#' , '³', '£', '' , 'F3'  ,'↓↓') ; Hr: hrkmAltGr   ), // 33 - R3  R4
    (X:	 733; Y:325 ; W:94     ; H:94      ; A:0       ; Mp:'3,7'  ; Ly:('␣'      , ' '       , ' '  , ' ' , ''    , '='  , '+' , '' , '' , '' , 'F12' ,''  ) ; Hr: hrkmNone    ), // 34 - R3  R5
    (X:	 833; Y:325 ; W:94     ; H:94      ; A:0       ; Mp:'3,6'  ; Ly:(' '      , ' '       , ' '  , ' ' , '|'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ) // 35 - R3  R6
  );
{*)}

procedure TForm1.actTestExecute(Sender: TObject);
var
  OFFSET_X: real;
  OFFSET_Y: real;
  ResizedFactor: Real;
  iIndexKey: integer;
  CenterX, CenterY: Real;
  Angle: Real;
  Corner1, Corner2, Corner3, Corner4: TKeyboardKey;
  RotCorner1, RotCorner2, RotCorner3, RotCorner4: TKeyboardKey;
  TextWidth, TextHeight: integer;
  sTextToWrite: string;
  paramLayerIndex: integer;
  StartX, StartY, DeltaX, DeltaY: real;
  sModWord: string;
begin
  clbLayerModifier.Enabled := False;
  Application.ProcessMessages;
  try
    // Ensure the TImage's Bitmap is initialized and has proper dimensions
    if imgTiRouge.Picture.Bitmap = nil then
      imgTiRouge.Picture.Bitmap := TBitmap.Create;

    // Set the dimensions of the Bitmap to match the desired area for drawing
    imgTiRouge.Picture.Bitmap.Width := imgTiRouge.Width;
    imgTiRouge.Picture.Bitmap.Height := imgTiRouge.Height;

    imgTiRouge.Picture.Bitmap.Canvas.Pen.Color := $A0A0A0;
    imgTiRouge.Picture.Bitmap.Canvas.Pen.Width := 3;
    imgTiRouge.Picture.Bitmap.Canvas.Pen.Style := psSolid;
    imgTiRouge.Picture.Bitmap.Canvas.Brush.Style := bsSolid;
    imgTiRouge.Picture.Bitmap.Canvas.Brush.Color := $E0E0E0;
    // imgTiRouge.Picture.Bitmap.Canvas.Font.Name := 'Segoe UI Variable';
    imgTiRouge.Picture.Bitmap.Canvas.Font.Name := 'Segoe UI Symbol';

    ResizedFactor := 1.5;
    OFFSET_X := 50 * ResizedFactor;
    OFFSET_Y := 50 * ResizedFactor;

    iIndexKey := 0;
    while iIndexKey < NB_KEYS do
    begin
      if MyKeys[iIndexKey].Ly[0] <> '' then
      begin
        CenterX := OFFSET_X + MyKeys[iIndexKey].X * ResizedFactor;
        CenterY := OFFSET_Y + MyKeys[iIndexKey].Y * ResizedFactor;

        Corner1.X := CenterX - (MyKeys[iIndexKey].W / 2) * ResizedFactor;
        Corner1.Y := CenterY - (MyKeys[iIndexKey].H / 2) * ResizedFactor;

        Corner2.X := CenterX + (MyKeys[iIndexKey].W / 2) * ResizedFactor;
        Corner2.Y := CenterY - (MyKeys[iIndexKey].H / 2) * ResizedFactor;

        Corner3.X := CenterX + (MyKeys[iIndexKey].W / 2) * ResizedFactor;
        Corner3.Y := CenterY + (MyKeys[iIndexKey].H / 2) * ResizedFactor;

        Corner4.X := CenterX - (MyKeys[iIndexKey].W / 2) * ResizedFactor;
        Corner4.Y := CenterY + (MyKeys[iIndexKey].H / 2) * ResizedFactor;

        Angle := DegToRad(MyKeys[iIndexKey].A);

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

        // Text will be transparent...
        imgTiRouge.Picture.Bitmap.Canvas.Brush.Style := bsClear;

        for paramLayerIndex := 0 to pred(NB_LAYERS) do
        begin
          if (clbLayerModifier.Checked[paramLayerIndex]) or
            (clbLayerModifier.Checked[pred(clbLayerModifier.Items.Count)]) then
          begin
            sTextToWrite := MyKeys[iIndexKey].Ly[paramLayerIndex];

            // Measure the text dimensions
            imgTiRouge.Picture.Bitmap.Canvas.Font.Orientation := 0;
            case paramLayerIndex of
              LAYER_MODIFIER_BASE:
                begin
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Color := COLOR_BASE;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Size := 25;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Style := [fsBold];
                end;

              LAYER_MODIFIER_BASE_LSHIFT:
                begin
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Color := COLOR_BASE_LSHIFT;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Size := 25;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Style := [fsBold];
                end;

              LAYER_MODIFIER_BASE_RCTRL:
                begin
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Color := COLOR_BASE_RCTRL;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Size := 14;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Style := [fsBold];
                end;

              LAYER_MODIFIER_BASE_LSHIFT_RCTRL:
                begin
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Color := COLOR_BASE_LSHIFT_RCTRL;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Size := 14;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Style := [fsBold];
                end;

              LAYER_MODIFIER_BASE_ALTGR:
                begin
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Color := COLOR_BASE_ALTGR;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Size := 14;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Style := [fsBold];
                end;

              LAYER_MODIFIER_NUMBERS:
                begin
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Color := COLOR_NUMBERS;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Size := 22;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Style := [fsBold];
                end;

              LAYER_MODIFIER_NUMBERS_LSHIFT:
                begin
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Color := COLOR_NUMBERS_LSHIFT;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Size := 22;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Style := [fsBold];
                end;

              LAYER_MODIFIER_NUMBERS_RCTRL:
                begin
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Color := COLOR_NUMBERS_RCTRL;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Size := 14;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Style := [fsBold];
                end;

              LAYER_MODIFIER_NUMBERS_LSHIFT_RCRTRL:
                begin
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Color := COLOR_NUMBERS_LSHIFT_RCRTRL;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Size := 14;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Style := [fsBold];
                end;

              LAYER_MODIFIER_NUMBERS_ALTGR:
                begin
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Color := COLOR_NUMBERS_ALTGR;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Size := 14;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Style := [fsBold];
                end;

              LAYER_MODIFIER_FUNCTION_KEYS:
                begin
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Color := COLOR_FUNCTION_KEYS;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Size := 14;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Style := [fsBold];
                end;

              LAYER_MODIFIER_CURSORS:
                begin
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Color := COLOR_CURSORS;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Size := 14;
                  imgTiRouge.Picture.Bitmap.Canvas.Font.Style := [fsBold];
                end;
            end;

            TextWidth := imgTiRouge.Picture.Bitmap.Canvas.TextWidth(sTextToWrite);
            TextHeight := imgTiRouge.Picture.Bitmap.Canvas.TextHeight('Mq');

            StartX := 0;
            StartY := 0;
            case paramLayerIndex of
              LAYER_MODIFIER_BASE:
                begin
                  StartX := CenterX - (TextWidth / 2);
                  StartY := CenterY - (TextHeight / 2);
                  //                  if not SameText(MyKeys[iIndexKey].Ly[1], '') then
                  //                  begin
                  //                    StartX := CenterX - TextWidth - 3;
                  //                    StartY := CenterY - 9;
                  //                  end
                  //                  else
                  //                  begin
                  //                    StartX := CenterX - (TextWidth / 2);
                  //                    StartY := CenterY - (TextHeight / 2);
                  //                  end;
                end;

              LAYER_MODIFIER_BASE_LSHIFT:
                begin
                  StartX := CenterX;
                  StartY := CenterY - 9;
                end;

              LAYER_MODIFIER_BASE_RCTRL:
                begin
                  StartX := CenterX - (MyKeys[iIndexKey].W / 2) + 4;
                  StartY := CenterY - (MyKeys[iIndexKey].H / 2) + TextHeight + 4;
                end;

              LAYER_MODIFIER_BASE_LSHIFT_RCTRL:
                begin
                  StartX := CenterX - (MyKeys[iIndexKey].W / 2) + 4;
                  StartY := CenterY - (MyKeys[iIndexKey].H / 2) + 3;
                end;

              LAYER_MODIFIER_BASE_ALTGR:
                begin
                  StartX := CenterX - (MyKeys[iIndexKey].W / 2) + 4;
                  StartY := CenterY - (MyKeys[iIndexKey].H / 2) + (2 * TextHeight) + 5;
                end;

              LAYER_MODIFIER_NUMBERS:
                begin
                  StartX := CenterX - TextWidth - 3;
                  StartY := CenterY - TextHeight - 11;
                end;

              LAYER_MODIFIER_NUMBERS_LSHIFT:
                begin
                  StartX := CenterX;
                  StartY := CenterY - TextHeight - 11;
                end;

              LAYER_MODIFIER_NUMBERS_RCTRL:
                begin
                  StartX := CenterX + (MyKeys[iIndexKey].W / 2) - TextWidth - 3;
                  StartY := CenterY - (MyKeys[iIndexKey].H / 2) + TextHeight + 4;
                end;

              LAYER_MODIFIER_NUMBERS_LSHIFT_RCRTRL:
                begin
                  StartX := CenterX + (MyKeys[iIndexKey].W / 2) - TextWidth - 3;
                  StartY := CenterY - (MyKeys[iIndexKey].H / 2) + 3;
                end;

              LAYER_MODIFIER_NUMBERS_ALTGR:
                begin
                  StartX := CenterX + (MyKeys[iIndexKey].W / 2) - TextWidth - 3;
                  StartY := CenterY - (MyKeys[iIndexKey].H / 2) + (2 * TextHeight) + 5;
                end;

              LAYER_MODIFIER_FUNCTION_KEYS:
                begin
                  StartX := CenterX + (MyKeys[iIndexKey].W / 2) - TextWidth - 3;
                  StartY := CenterY - (MyKeys[iIndexKey].H / 2) + (3 * TextHeight) + 7;
                end;

              LAYER_MODIFIER_CURSORS:
                begin
                  StartX := CenterX - (MyKeys[iIndexKey].W / 2) + 4;
                  StartY := CenterY - (MyKeys[iIndexKey].H / 2) + (2 * TextHeight) + 5;
                end;
            end;

            // Calculate the difference between the Start point and Center point
            DeltaX := StartX - CenterX;
            DeltaY := StartY - CenterY;

            // Apply the rotation formulas
            StartX := CenterX + (DeltaX * Cos(Angle)) - (DeltaY * Sin(Angle));
            StartY := CenterY + (DeltaX * Sin(Angle)) + (DeltaY * Cos(Angle));

            // Calculate the top-left corner of the text
            imgTiRouge.Picture.Bitmap.Canvas.Font.Orientation := Trunc(MyKeys[iIndexKey].A) * -10;
            //            imgTiRouge.Picture.Bitmap.Canvas.Brush.Style := bsSolid;
            //            imgTiRouge.Picture.Bitmap.Canvas.Brush.Color := clYellow;
            imgTiRouge.Picture.Bitmap.Canvas.TextOut(Trunc(StartX), Trunc(StartY), sTextToWrite);
          end;
        end;

        if clbLayerModifier.Checked[pred(pred(clbLayerModifier.Items.Count))] or
          clbLayerModifier.Checked[pred(clbLayerModifier.Items.Count)] then
        begin
          sModWord := '';
          case MyKeys[iIndexKey].Hr of
          {(*}
            hrkmNone: ;
            hrkmShift: sModWord    := 'LShft';
            hrkmLCtrl: sModWord    := 'LCtrl';
            hrkmRCtrl: sModWord    := 'RCtrl';
            hrkmSftRCtrl: sModWord := 'SftRCtrl';
            hrkmAlt: sModWord      := 'Alt';
            hrkmAltGr: sModWord    := 'AltGr';
            hrkmGui: sModWord      := 'Win';
            hrkmNbr: sModWord      := 'Number';
            hrkmSNbr: sModWord     := 'SfhtNum';
            hrkmCrsr: sModWord     := 'Cursor';
            hrkmFctn: sModWord     := 'Fctn';
          {*)}
          end;

          if sModWord <> '' then
          begin
            imgTiRouge.Picture.Bitmap.Canvas.Font.Orientation := 0;
            imgTiRouge.Picture.Bitmap.Canvas.Font.Size := 10;
            imgTiRouge.Picture.Bitmap.Canvas.Font.Style := [fsBold];
            imgTiRouge.Picture.Bitmap.Canvas.Font.Color := clRed;

            TextHeight := imgTiRouge.Picture.Bitmap.Canvas.TextHeight(sModWord);
            StartX := CenterX - (MyKeys[iIndexKey].W / 2) + 4;
            StartY := MyKeys[iIndexKey].Y + MyKeys[iIndexKey].H - TextHeight + 2;
            imgTiRouge.Picture.Bitmap.Canvas.TextOut(Trunc(StartX), Trunc(StartY), sModWord);
          end;
        end;
      end;

      inc(iIndexKey);
    end;
  finally
    clbLayerModifier.Enabled := True;
  end;
end;

procedure TForm1.cbLayersModifiersChange(Sender: TObject);
begin
  actTestExecute(actTest);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FisFirstAction := True;
end;

procedure TForm1.mainApplicationEventsActivate(Sender: TObject);
begin
  Application.ProcessMessages;
  if FisFirstAction then
  begin
    FisFirstAction := False;
    Application.ProcessMessages;
    actTestExecute(actTest);
  end;

end;

end.

