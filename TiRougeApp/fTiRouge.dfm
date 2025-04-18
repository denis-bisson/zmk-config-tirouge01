object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 814
  ClientWidth = 1821
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  Menu = mmTiRouge
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 18
  object imgTiRouge: TImage
    Left = 8
    Top = 40
    Width = 1800
    Height = 765
  end
  object lblLayerModifier: TLabel
    Left = 736
    Top = 160
    Width = 146
    Height = 18
    Caption = 'Layers and Modifiers'
  end
  object clbLayerModifier: TCheckListGlobal6
    Left = 736
    Top = 184
    Width = 257
    Height = 233
    ItemHeight = 18
    Items.Strings = (
      'Base'
      'Base + Left Shift'
      'Base + Right Ctrl'
      'Base + Left Shift + Right Ctrl'
      'Base + AltGr'
      'Numbers'
      'Numbers + Left Shift'
      'Numbers + Right Ctrl'
      'Numbers + Left Shift + Right Ctrl'
      'Numbers + AltGr'
      'Modifier and layers'
      'ALL')
    TabOrder = 0
    OnClick = actTestExecute
    CheckWhenMove = True
  end
  object amTiRouge: TActionManager
    Left = 784
    Top = 248
    StyleName = 'Platform Default'
    object actTest: TAction
      Caption = 'Test'
      ShortCut = 120
      OnExecute = actTestExecute
    end
  end
  object mmTiRouge: TMainMenu
    Left = 592
    Top = 264
    object est1: TMenuItem
      Action = actTest
    end
  end
  object mainApplicationEvents: TApplicationEvents
    OnActivate = mainApplicationEventsActivate
    Left = 880
    Top = 264
  end
end
