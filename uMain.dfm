object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = #45348#51060#48260' '#52964#47672#49828' API'
  ClientHeight = 475
  ClientWidth = 920
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 75
    Height = 15
    Caption = #52964#47672#49828' '#50500#51060#46356
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 111
    Height = 15
    Caption = #50528#54540#47532#52992#51060#49496' '#50500#51060#46356
  end
  object Label3: TLabel
    Left = 8
    Top = 69
    Width = 36
    Height = 15
    Caption = #49884#53356#47551
  end
  object btnToken: TButton
    Left = 8
    Top = 113
    Width = 75
    Height = 25
    Caption = #51064#51613#53664#53360
    TabOrder = 0
    OnClick = btnTokenClick
  end
  object eLog: TMemo
    Left = 8
    Top = 147
    Width = 913
    Height = 320
    Lines.Strings = (
      'eLog')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object eAccountID: TEdit
    Left = 144
    Top = 8
    Width = 224
    Height = 23
    TabOrder = 2
  end
  object eClientID: TEdit
    Left = 144
    Top = 37
    Width = 224
    Height = 23
    TabOrder = 3
  end
  object eSecret: TEdit
    Left = 144
    Top = 66
    Width = 224
    Height = 23
    TabOrder = 4
  end
  object Button1: TButton
    Left = 169
    Top = 113
    Width = 75
    Height = 25
    Caption = #44256#44061#54788#54889
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 89
    Top = 113
    Width = 74
    Height = 25
    Caption = #49324#50857#51088#51221#48372
    TabOrder = 6
    OnClick = Button2Click
  end
end
