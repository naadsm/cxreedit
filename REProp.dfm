object RegExprEditForm: TRegExprEditForm
  Left = 129
  Top = 130
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Regular Expression Editor'
  ClientHeight = 326
  ClientWidth = 648
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    Left = 8
    Top = 8
    Width = 633
    Height = 273
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 209
    Top = 19
    Width = 142
    Height = 13
    Caption = 'Existing regular expression list:'
  end
  object Bevel1: TBevel
    Left = 360
    Top = 24
    Width = 265
    Height = 17
    Shape = bsTopLine
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 115
    Height = 13
    Caption = 'Input regular expression:'
  end
  object Label3: TLabel
    Left = 16
    Top = 208
    Width = 78
    Height = 13
    Caption = 'Input test string: '
  end
  object Label4: TLabel
    Left = 16
    Top = 148
    Width = 110
    Height = 13
    Caption = 'Input Error Information: '
  end
  object Label5: TLabel
    Left = 16
    Top = 96
    Width = 91
    Height = 26
    Caption = 'Input validate input'#13#10' regular expression:'
  end
  object Bevel3: TBevel
    Left = 16
    Top = 200
    Width = 169
    Height = 9
    Shape = bsTopLine
  end
  object Label6: TLabel
    Left = 16
    Top = 16
    Width = 140
    Height = 26
    Caption = 'Note: red color means invalid '#13#10'expression or string'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lvRegExpr: TListView
    Left = 208
    Top = 40
    Width = 425
    Height = 225
    Columns = <
      item
        Caption = 'Name'
        Width = 80
      end
      item
        Caption = 'Expression'
        Width = 120
      end
      item
        Caption = 'InputExpression'
        Width = 120
      end
      item
        Caption = 'Error Information'
        Width = 100
      end>
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnKeyDown = lvRegExprKeyDown
  end
  object Button1: TButton
    Left = 475
    Top = 296
    Width = 75
    Height = 25
    Action = ActionConfirm
    TabOrder = 1
  end
  object Button2: TButton
    Left = 560
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object Button3: TButton
    Left = 143
    Top = 71
    Width = 50
    Height = 25
    Action = ActionAdd
    TabOrder = 5
  end
  object Button5: TButton
    Left = 143
    Top = 103
    Width = 50
    Height = 25
    Action = ActionEdit
    TabOrder = 6
  end
  object edtErrMsg: TEdit
    Left = 16
    Top = 164
    Width = 121
    Height = 21
    TabOrder = 7
  end
  object btnImport: TButton
    Left = 304
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Import...'
    TabOrder = 8
    OnClick = btnImportClick
  end
  object Button7: TButton
    Left = 389
    Top = 296
    Width = 75
    Height = 25
    Action = ActionExport
    TabOrder = 9
  end
  object edtRegExpr: TREEdit
    Left = 16
    Top = 72
    Width = 121
    Height = 21
    EditAlign = eaLeft
    TabOrder = 3
    OnChange = edtRegExprChange
  end
  object edtInputExpr: TREEdit
    Left = 16
    Top = 122
    Width = 121
    Height = 21
    EditAlign = eaLeft
    TabOrder = 10
    OnChange = edtInputExprChange
  end
  object edtTest: TREEdit
    Left = 16
    Top = 232
    Width = 121
    Height = 21
    EditAlign = eaLeft
    TabOrder = 4
    OnChange = edtTestChange
    OnEnter = edtTestEnter
  end
  object ActionList1: TActionList
    Left = 264
    Top = 288
    object ActionAdd: TAction
      Caption = '-------->>'
      OnExecute = ActionAddExecute
      OnUpdate = ActionAddUpdate
    end
    object ActionEdit: TAction
      Caption = '<<--------'
      OnExecute = ActionEditExecute
      OnUpdate = ActionEditUpdate
    end
    object ActionConfirm: TAction
      Caption = 'OK'
      OnExecute = ActionConfirmExecute
      OnUpdate = ActionConfirmUpdate
    end
    object ActionExport: TAction
      Caption = 'Export...'
      OnExecute = ActionExportExecute
      OnUpdate = ActionExportUpdate
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 144
    Top = 288
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'red'
    Filter = 'Regular expression file(*.red)|*.red'
    Title = 'Select output file'
    Left = 224
    Top = 288
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'red'
    Filter = 'Regular expression file(*.red)|*.red'
    Title = 'Open regular expression file'
    Left = 176
    Top = 288
  end
end
