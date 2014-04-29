object Form1: TForm1
  Left = 306
  Top = 154
  Width = 648
  Height = 362
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
    Left = 16
    Top = 148
    Width = 55
    Height = 13
    Caption = 'Input string:'
  end
  object Label2: TLabel
    Left = 360
    Top = 24
    Width = 255
    Height = 260
    Caption = 
      'Copywright'#13#10'----------------------------------------------------' +
      '----------   '#13#10'     TREEdit '#13#10'     Regular Expression Edit based' +
      ' on TRegExpr library'#13#10'     v 1.7'#13#10'Author:'#13#10'     Xing Chen'#13#10'     ' +
      'cxlib@cxlib.com'#13#10'     http://www.cxlib.com'#13#10'--------------------' +
      '-------------------------------------------'#13#10'     TRegExpr libra' +
      'ry'#13#10'     Regular Expressions for Delphi'#13#10'     v. 0.942'#13#10'Author:'#13 +
      #10'     Andrey V. Sorokin'#13#10'     St-Petersburg'#13#10'     Russia'#13#10'     a' +
      'nso@mail.ru, anso@usa.net'#13#10'     http://anso.da.ru'#13#10'     http://a' +
      'nso.virtualave.net'
    Color = clInactiveCaptionText
    ParentColor = False
  end
  object REEdit1: TREEdit
    Left = 88
    Top = 144
    Width = 182
    Height = 21
    Expression = '^abc$'
    InputExpression = '^[a-z]*$'
    ErrorMessage = 'Error Input String'
    EditAlign = eaLeft
    TabOrder = 0
  end
  object Button1: TButton
    Left = 280
    Top = 144
    Width = 75
    Height = 25
    Action = ActionValidate
    TabOrder = 1
  end
  object RadioGroup1: TRadioGroup
    Left = 88
    Top = 184
    Width = 185
    Height = 105
    Caption = 'Set edit alignment style'
    ItemIndex = 0
    Items.Strings = (
      'Left align'
      'Right align')
    TabOrder = 2
    OnClick = RadioGroup1Click
  end
  object Memo1: TMemo
    Left = 88
    Top = 32
    Width = 185
    Height = 89
    Color = clInfoBk
    Lines.Strings = (
      'Below edit'#39's regular expression is '
      '"^abc$", input expression is '
      '"^[a-z]*$".when you input error string , '
      'the text will be red')
    TabOrder = 3
  end
  object ActionList1: TActionList
    Left = 280
    Top = 176
    object ActionValidate: TAction
      Caption = 'Ok'
      OnExecute = ActionValidateExecute
      OnUpdate = ActionValidateUpdate
    end
  end
end
