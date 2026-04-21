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
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 18
  object imgTiRouge: TImage
    Left = 8
    Top = 40
    Width = 1800
    Height = 765
  end
  object lblLayerModifier: TLabel
    Left = 760
    Top = 56
    Width = 146
    Height = 18
    Caption = 'Layers and Modifiers'
  end
  object clbLayerModifier: TCheckListBox
    Left = 760
    Top = 80
    Width = 257
    Height = 289
    ItemHeight = 18
    Items.Strings = (
      'LY_DEFT'
      'LY_ACSY'
      'LY_ACSH'
      'LY_NUMB'
      'LY_CRSR'
      'LY_FUNC'
      'LY_CONF'
      'LY_TMPL'
      'Numbers + Left Shift + Right Ctrl'
      'Numbers + AltGr'
      'Function Keys'
      'Cursors'
      'Modifier and layers'
      'ALL')
    TabOrder = 0
    OnClick = actTestExecute
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
