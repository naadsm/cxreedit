object Form1: TForm1
  Left = 920
  Top = 421
  Width = 296
  Height = 335
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 72
    Top = 160
    Width = 67
    Height = 13
    Caption = 'Test TREEdit:'
  end
  object Label2: TLabel
    Left = 72
    Top = 216
    Width = 118
    Height = 13
    Caption = 'Ctrl-C: Copy selected text'
  end
  object Label3: TLabel
    Left = 72
    Top = 232
    Width = 110
    Height = 13
    Caption = 'Ctrl-X: Cut selected text'
  end
  object Label4: TLabel
    Left = 72
    Top = 248
    Width = 78
    Height = 13
    Caption = 'Ctrl-V: Paste text'
  end
  object Label5: TLabel
    Left = 72
    Top = 264
    Width = 91
    Height = 13
    Caption = 'Ctrl-A-Select all text'
  end
  object REEdit1: TREEdit
    Left = 72
    Top = 176
    Width = 121
    Height = 21
    InputExpression = '.*'
    EditAlign = eaLeft
    TabOrder = 0
  end
  object rdoIntegers: TRadioButton
    Left = 40
    Top = 16
    Width = 201
    Height = 17
    Caption = 'Integers only'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = rdoClick
  end
  object rdoDecimals: TRadioButton
    Left = 40
    Top = 32
    Width = 201
    Height = 17
    Caption = 'Decimals'
    TabOrder = 2
    OnClick = rdoClick
  end
  object rdoAnyText: TRadioButton
    Left = 40
    Top = 48
    Width = 209
    Height = 17
    Caption = 'Any text'
    TabOrder = 3
    OnClick = rdoClick
  end
  object rdoCustom: TRadioButton
    Left = 40
    Top = 64
    Width = 209
    Height = 17
    Caption = 'Custom input expression:'
    Enabled = False
    TabOrder = 4
    OnClick = rdoClick
  end
  object leCustomRegExp: TEdit
    Left = 56
    Top = 80
    Width = 201
    Height = 21
    Enabled = False
    TabOrder = 5
  end
end
