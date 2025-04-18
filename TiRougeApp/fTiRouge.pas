unit fTiRouge;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.ActnMan, Vcl.ExtCtrls, Vcl.PlatformDefaultStyleActnCtrls, Vcl.Menus,
  Vcl.StdCtrls, Vcl.AppEvnts, Vcl.CheckLst, uEnhancedCheckList;

type
  TForm1 = class(TForm)
    imgTiRouge: TImage;
    amTiRouge: TActionManager;
    actTest: TAction;
    mmTiRouge: TMainMenu;
    est1: TMenuItem;
    lblLayerModifier: TLabel;
    mainApplicationEvents: TApplicationEvents;
    clbLayerModifier: TCheckListGlobal6;
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
  NB_KEYS = 44;
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
    (X:0	  ; Y:140 ; W:94     ; H:94      ; A:0       ; Mp:'1,0'  ; Ly:('esc'    , ''        , ''   , ''  , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 00 - R1  L0
    (X:100	; Y:140 ; W:94     ; H:94      ; A:0       ; Mp:'1,1'  ; Ly:('b'      , 'B'       , '”'  , '’' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 01 - R1  L1
    (X:200	; Y:114 ; W:94     ; H:94      ; A:0       ; Mp:'1,2'  ; Ly:('y'      , 'Y'       , '←'  , '¥' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 02 - R1  L2
    (X:300	; Y:100 ; W:94     ; H:94      ; A:0       ; Mp:'1,3'  ; Ly:('o'      , 'O'       , 'ø'  , 'Ø' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmSftRCtrl), // 03 - R1  L3
    (X:400	; Y:114 ; W:94     ; H:94      ; A:0       ; Mp:'1,4'  ; Ly:('u'      , 'U'       , '↓'  , '↑' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 04 - R1  L4
    (X:500	; Y:114 ; W:94     ; H:94      ; A:0       ; Mp:'1,5'  ; Ly:('è'      , 'È'       , ''   , 'ˇ' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmFctn    ), // 05 - R1  L5
    (X:1200	; Y:114 ; W:94     ; H:94      ; A:0       ; Mp:'1,11' ; Ly:(';'      , ':'       , '´'  , '˝' , '°'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 06 - R1  R1
    (X:1300	; Y:114 ; W:94     ; H:94      ; A:0       ; Mp:'1,10' ; Ly:('l'      , 'L'       , 'ŀ'  , 'Ŀ' , ''    , '7'  , '&' , '' , '⅞', '{', 'F7'  ,'α' ) ; Hr: hrkmNone    ), // 07 - R1  R2
    (X:1400	; Y:100 ; W:94     ; H:94      ; A:0       ; Mp:'1,9'  ; Ly:('d'      , 'D'       , 'ð'  , 'Ð' , ''    , '8'  , '*' , '' , '™', '}', 'F8'  ,'↑' ) ; Hr: hrkmSftRCtrl), // 08 - R1  R3
    (X:1500	; Y:114 ; W:94     ; H:94      ; A:0       ; Mp:'1,8'  ; Ly:('w'      , 'W'       , 'ł'  , 'Ł' , ''    , '9'  , '(' , '' , '±', '[', 'F9'  ,'↓↓') ; Hr: hrkmNone    ), // 09 - R1  R4
    (X:1600	; Y:140 ; W:94     ; H:94      ; A:0       ; Mp:'1,7'  ; Ly:('v'      , 'V'       , '“'  , '‘' , ''    , '0'  , ')' , '' , '' , ']', 'F10' ,''  ) ; Hr: hrkmNone    ), // 10 - R1  R5
    (X:1700	; Y:140 ; W:94     ; H:94      ; A:0       ; Mp:'1,6'  ; Ly:('z'      , 'Z'       , ''   , ''  , '«'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 11 - R1  R6
    (X:0	  ; Y:240 ; W:94     ; H:94      ; A:0       ; Mp:'2,0'  ; Ly:('tab'    , ''        , ''   , ''  , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 12 - R2  L0
    (X:100	; Y:240 ; W:94     ; H:94      ; A:0       ; Mp:'2,1'  ; Ly:('c'      , 'C'       , '¢'  , '©' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmGui     ), // 13 - R2  L1
    (X:200	; Y:214 ; W:94     ; H:94      ; A:0       ; Mp:'2,2'  ; Ly:('i'      , 'I'       , '→'  , 'ı' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmAlt     ), // 14 - R2  L2
    (X:300	; Y:200 ; W:94     ; H:94      ; A:0       ; Mp:'2,3'  ; Ly:('e'      , 'E'       , 'œ'  , 'Œ' , '€'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmLCtrl   ), // 15 - R2  L3
    (X:400	; Y:214 ; W:94     ; H:94      ; A:0       ; Mp:'2,4'  ; Ly:('a'      , 'A'       , 'æ'  , 'Æ' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmShift   ), // 16 - R2  L4
    (X:500	; Y:214 ; W:94     ; H:94      ; A:0       ; Mp:'2,5'  ; Ly:('é'      , 'É'       , ''   , '·' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmSNbr    ), // 17 - R2  L5
    (X:1200	; Y:214 ; W:94     ; H:94      ; A:0       ; Mp:'2,11' ; Ly:(','      , ''''      , '―'  , '×' , '<'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 18 - R2  R1
    (X:1300	; Y:214 ; W:94     ; H:94      ; A:0       ; Mp:'2,10' ; Ly:('h'      , 'H'       , 'ħ'  , 'Ħ' , ''    , '4'  , '$' , '¼', '€', '' , 'F4'  ,'←' ) ; Hr: hrkmShift   ), // 19 - R2  R2
    (X:1400	; Y:200 ; W:94     ; H:94      ; A:0       ; Mp:'2,9'  ; Ly:('t'      , 'T'       , 'ŧ'  , 'Ŧ' , ''    , '5'  , '%' , '½', '⅜', '' , 'F5'  ,'↓' ) ; Hr: hrkmLCtrl   ), // 20 - R2  R3
    (X:1500	; Y:214 ; W:94     ; H:94      ; A:0       ; Mp:'2,8'  ; Ly:('s'      , 'S'       , 'ß'  , '§' , ''    , '6'  , '?' , '¾', '⅝', '' , 'F6'  ,'→' ) ; Hr: hrkmAlt     ), // 21 - R2  R4
    (X:1600	; Y:240 ; W:94     ; H:94      ; A:0       ; Mp:'2,7'  ; Ly:('n'      , 'N'       , 'ŉ'  , '♪' , ''    , '-'  , '_' , '' , '' , '' , 'F11' ,''  ) ; Hr: hrkmGui     ), // 22 - R2  R5
    (X:1700	; Y:240 ; W:94     ; H:94      ; A:0       ; Mp:'2,6'  ; Ly:('q'      , 'Q'       , ''   , 'Ω' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 23 - R2  R6
    (X:0	  ; Y:340 ; W:94     ; H:94      ; A:0       ; Mp:'3,0'  ; Ly:('^'      , '¨'       , ''   , '˚' , '`'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 24 - R3  L0
    (X:100	; Y:340 ; W:94     ; H:94      ; A:0       ; Mp:'3,1'  ; Ly:('g'      , 'G'       , 'ŋ'  , 'Ŋ' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 25 - R3  L1
    (X:200	; Y:314 ; W:94     ; H:94      ; A:0       ; Mp:'3,2'  ; Ly:('x'      , 'X'       , ''   , ''  , '»'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmAltGr   ), // 26 - R3  L2
    (X:300	; Y:300 ; W:94     ; H:94      ; A:0       ; Mp:'3,3'  ; Ly:('j'      , 'J'       , 'ĳ'  , 'Ĳ' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmRCtrl   ), // 27 - R3  L3
    (X:400	; Y:314 ; W:94     ; H:94      ; A:0       ; Mp:'3,4'  ; Ly:('k'      , 'K'       , 'ĸ'  , ''  , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNbr     ), // 28 - R3  L4
    (X:500	; Y:314 ; W:94     ; H:94      ; A:0       ; Mp:'3,5'  ; Ly:('à'      , 'À'       , ''   , '˘' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmCrsr    ), // 29 - R3  L5
    (X:1200	; Y:314 ; W:94     ; H:94      ; A:0       ; Mp:'3,11' ; Ly:('.'      , '"'       , '/'  , '÷' , '>'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 30-  R3  R1
    (X:1300	; Y:314 ; W:94     ; H:94      ; A:0       ; Mp:'3,10' ; Ly:('r'      , 'R'       , '¶'  , '®' , ''    , '1'  , '!' , '¹', '¡', '' , 'F1'  ,'Ω' ) ; Hr: hrkmNone    ), // 31-  R3  R2
    (X:1400	; Y:300 ; W:94     ; H:94      ; A:0       ; Mp:'3,9'  ; Ly:('m'      , 'M'       , 'µ'  , 'º' , ''    , '2'  , '@' , '²', '' , '' , 'F2'  ,'q' ) ; Hr: hrkmRCtrl   ), // 32 - R3  R3
    (X:1500	; Y:314 ; W:94     ; H:94      ; A:0       ; Mp:'3,8'  ; Ly:('f'      , 'F'       , ''   , 'ª' , ''    , '3'  , '#' , '³', '£', '' , 'F3'  ,'↓↓') ; Hr: hrkmAltGr   ), // 33 - R3  R4
    (X:1600	; Y:340 ; W:94     ; H:94      ; A:0       ; Mp:'3,7'  ; Ly:('p'      , 'P'       , 'þ'  , 'Þ' , ''    , '='  , '+' , '' , '' , '' , 'F12' ,''  ) ; Hr: hrkmNone    ), // 34 - R3  R5
    (X:1700	; Y:340 ; W:94     ; H:94      ; A:0       ; Mp:'3,6'  ; Ly:('/'      , '\'       , ''   , ''  , '|'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 35 - R3  R6
    (X:703	; Y:585 ; W:94     ; H:194     ; A:45.00   ; Mp:'5,2'  ; Ly:('<?>'    , ''        , ''   , ''  , ''    ,''    , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 36 - R4  L4
    (X:996	; Y:585 ; W:94     ; H:194     ; A:315.00  ; Mp:'5,8'  ; Ly:('enter'  , ''        , ''   , ''  , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 37 - R4  R0
    (X:340	; Y:526 ; W:94     ; H:94      ; A:0       ; Mp:'5,3'  ; Ly:('ç'      , 'Ç'       , '~'  , '¯' , '~'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 38 - R5  L0
    (X:440	; Y:526 ; W:94     ; H:94      ; A:0       ; Mp:'5,4'  ; Ly:('del'    , ''        , ''   , ''  , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 39 - R5  L1
    (X:562	; Y:554 ; W:119    ; H:94      ; A:22.5    ; Mp:'5,5'  ; Ly:('back'   , ''        , ''   , ''  , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 40 - R5  L2
    (X:1138	; Y:554 ; W:119    ; H:94      ; A:337.50  ; Mp:'5,11' ; Ly:('space'  , ''        , ''   , ''  , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 41 - R5  R0
    (X:1260	; Y:526 ; W:94     ; H:94      ; A:0       ; Mp:'5,10' ; Ly:('-'      , '_'       , ''   , '¿' , ''    , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    ), // 42 - R5  R1
    (X:1360	; Y:526 ; W:94     ; H:94      ; A:0       ; Mp:'5,9'  ; Ly:('='      , '+'       , '¸'  , '˛' , '¬'   , ''   , ''  , '' , '' , '' , ''    ,''  ) ; Hr: hrkmNone    )  // 43 - R5  R2

  );
{*)}

procedure TForm1.actTestExecute(Sender: TObject);
const
  OFFSET_X = 50;
  OFFSET_Y = 50;

var
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
    imgTiRouge.Picture.Bitmap.Canvas.Font.Name := 'Segoe UI Variable';

    iIndexKey := 0;
    while iIndexKey < NB_KEYS do
    begin
      if MyKeys[iIndexKey].Ly[0] <> '' then
      begin
        CenterX := OFFSET_X + MyKeys[iIndexKey].X;
        CenterY := OFFSET_Y + MyKeys[iIndexKey].Y;

        Corner1.X := CenterX - (MyKeys[iIndexKey].W / 2);
        Corner1.Y := CenterY - (MyKeys[iIndexKey].H / 2);

        Corner2.X := CenterX + (MyKeys[iIndexKey].W / 2);
        Corner2.Y := CenterY - (MyKeys[iIndexKey].H / 2);

        Corner3.X := CenterX + (MyKeys[iIndexKey].W / 2);
        Corner3.Y := CenterY + (MyKeys[iIndexKey].H / 2);

        Corner4.X := CenterX - (MyKeys[iIndexKey].W / 2);
        Corner4.Y := CenterY + (MyKeys[iIndexKey].H / 2);

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
                  if not SameText(MyKeys[iIndexKey].Ly[1], '') then
                  begin
                    StartX := CenterX - TextWidth - 3;
                    StartY := CenterY - 9;
                  end
                  else
                  begin
                    StartX := CenterX - (TextWidth / 2);
                    StartY := CenterY - (TextHeight / 2);
                  end;
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

