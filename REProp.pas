{***************************************************************
 *
 * Unit Name: REProp
 * Purpose  : Regular Expression Editor
 * Author   : hubdog(Xing Chen)
 * BeginDate: 2001-9-14
 * EndDate  :
 * History  : 
 * 2001-10-19 1.1a
 *            1.6a 修改属性编辑器，增加了对输入格式的校验的属性绑定
 *            1.7a 考虑将PropertyEditor改成ComponentEditor同时，将Empty属性添加进来
 *                  并考虑用Ini类型的文件导出规则集合，另外当前是将规则附加在导出文件中
 *                  应该考虑打开文件时，不使用TStringList.create而是使用FileopenCreate标识
 *                 （待完成）
 ****************************************************************}

unit REProp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ActnList, Menus, RegExpr, REEdit, Registry;

type
  TRegExprEditForm = class(TForm)
    lvRegExpr: TListView;
    Label1: TLabel;
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Button3: TButton;
    Bevel2: TBevel;
    ActionList1: TActionList;
    ActionAdd: TAction;
    PopupMenu1: TPopupMenu;
    Button5: TButton;
    ActionEdit: TAction;
    ActionConfirm: TAction;
    edtErrMsg: TEdit;
    Label4: TLabel;
    btnImport: TButton;
    Button7: TButton;
    ActionExport: TAction;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    edtRegExpr: TREEdit;
    Label5: TLabel;
    edtInputExpr: TREEdit;
    Bevel3: TBevel;
    edtTest: TREEdit;
    Label6: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ActionAddUpdate(Sender: TObject);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionEditUpdate(Sender: TObject);
    procedure ActionEditExecute(Sender: TObject);
    procedure ActionConfirmUpdate(Sender: TObject);
    procedure ActionConfirmExecute(Sender: TObject);
    procedure lvRegExprKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ActionExportUpdate(Sender: TObject);
    procedure ActionExportExecute(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure edtRegExprChange(Sender: TObject);
    procedure edtInputExprChange(Sender: TObject);
    procedure edtTestChange(Sender: TObject);
    procedure edtTestEnter(Sender: TObject);
  private
    procedure SetErrMsg(const Value: string);
    procedure SetInputExpr(const Value: string);
    procedure SetRegExpr(const Value: string);
    function GetErrMsg: string;
    function GetRegExpr: string;
    function GetInputExpr: string;
    { Private declarations }
  public
    { Public declarations }
    property RegExpr: string read GetRegExpr write SetRegExpr; //正则表达式
    property InputExpr: string read GetInputExpr write SetInputExpr;
    //输入正则表达式
    property ErrMsg: string read GetErrMsg write SetErrMsg;
    //同表达式绑定的错误消息
  end;

const
  sREList = 'RegExprList'; //

var
  RegExprEditForm: TRegExprEditForm;

implementation

{$R *.DFM}

procedure TRegExprEditForm.FormShow(Sender: TObject);
var
  //REList:TStringList;
  REList: TRegIniFile;
  Sections: TStringList;
  I: Integer;
  Item: TListItem;
begin
  //加载保存的正则表达式列表文件
  {REList:=TStringList.Create;
  REList.LoadFromFile('C:\Program Files\Borland\Delphi5\lib\REDefine.Dat');
  for I:=0 to REList.Count-1 do
  begin
    Item:=lvRegExpr.Items.Add;
    Item.Caption:=REList.Names[I];
    Item.SubItems.Add(REList.Values[Item.Caption]);
    //Item.SubItems.Add(REList.Values[I]);
  end;
  REList.Free;}
  //加载正则表达式列表
  REList := TRegIniFile.Create(sREList);
  Sections := TStringList.Create;
  REList.ReadSections(Sections); //获得全部列表
  for I := 0 to Sections.Count - 1 do
  begin
    Item := lvRegExpr.Items.Add;
    Item.Caption := Sections.Strings[i];
    Item.SubItems.Add(REList.ReadString(Item.Caption, 'RegExpr', ''));
    Item.SubItems.Add(REList.ReadString(Item.Caption, 'InputExpr', ''));
    Item.SubItems.Add(REList.ReadString(Item.Caption, 'ErrorMsg', ''));
  end;
  Sections.Clear;
  Sections.Free;
  REList.Free;
end;

procedure TRegExprEditForm.ActionAddUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (edtRegExpr.Text <> '') and
    (edtRegExpr.Expression = edtRegExpr.Text) and (edtInputExpr.Expression =
    edtInputExpr.Text);
end;

procedure TRegExprEditForm.ActionAddExecute(Sender: TObject);
var
  sName: string;
  Item: TListItem;
begin
  sName := '';
  //显示输入正则表达式名称对话框
  while sName = '' do
  begin
    sName := InputBox('Input regular expression Name', 'Regular expression name',
      'Please input expression name');
    if sName = '' then
      Application.MessageBox('Must input regular expression name', 'Error', MB_OK)
    else if Assigned(lvRegExpr.FindCaption(0, sName, False, True, True)) then
    begin
      Application.MessageBox('Already exist same name expression，please re-input expression name', 'Error',
        MB_OK);
      sName := '';
    end
    else if sName = 'Please input expression name' then
      Exit;
  end;
  //添加到列表中
  Item := lvRegExpr.Items.Add;
  Item.Caption := sName;
  Item.SubItems.Add(edtRegExpr.Text);
  Item.SubItems.Add(edtInputExpr.Text);
  Item.SubItems.Add(edtErrMsg.Text);
end;

procedure TRegExprEditForm.ActionEditUpdate(Sender: TObject);
begin
  //当前必须有已经选好的正则表达式
  (Sender as TAction).Enabled := Assigned(lvRegExpr.ItemFocused);
end;

procedure TRegExprEditForm.ActionEditExecute(Sender: TObject);
begin
  //获得正则表达式
  edtRegExpr.Text := lvRegExpr.ItemFocused.SubItems[0];
  edtInputExpr.Text := lvRegExpr.ItemFocused.SubItems[1];
  edtErrMsg.Text := lvRegExpr.ItemFocused.SubItems[2];
end;

procedure TRegExprEditForm.ActionConfirmUpdate(Sender: TObject);
begin
  {if (edtRegExpr.Expression = edtRegExpr.Text) then
    edtRegExpr.Font.Color := clBlack
  else
    edtRegExpr.Font.Color := clRed;}
  (Sender as TAction).Enabled := (edtRegExpr.Text <> '') and
    (edtRegExpr.Expression = edtRegExpr.Text) and (edtInputExpr.Expression =
    edtInputExpr.Text);
end;

procedure TRegExprEditForm.ActionConfirmExecute(Sender: TObject);
var
  I: Integer;
  //REList:TStringList;
  REList: TRegIniFile;
  sName, sValue, sInputExpr, sErrMsg: string;
  Sections: TStringList;
begin
  RegExpr := edtRegExpr.Text;
  ErrMsg := edtErrMsg.Text;
  //保存当前正则表达式列表,注意要先清空当前注册表中的内容
  //REList:=TStringList.Create;
  Sections := TStringList.Create;
  REList := TRegIniFile.Create(sREList);
  //清空原有列表
  REList.ReadSections(Sections);
  for I := 0 to Sections.Count - 1 do
    REList.EraseSection(Sections.Strings[i]);

  //添加新列表
  for I := 0 to lvRegExpr.Items.Count - 1 do
  begin
    sName := lvRegExpr.Items.Item[i].Caption;
    sValue := lvRegExpr.Items.Item[i].SubItems.Strings[0];
    sInputExpr := lvRegExpr.Items.Item[I].SubItems.Strings[1];
    sErrMsg := lvRegExpr.Items.Item[i].SubItems.Strings[2];
    REList.WriteString(sName, 'RegExpr', sValue);
    REList.WriteString(sName, 'InputExpr', sInputExpr);
    REList.WriteString(sName, 'ErrorMsg', sErrMsg);
  end;
  REList.Free;
  // REList.SaveToFile('C:\Program Files\Borland\Delphi5\lib\REDefine.Dat');
  ModalResult := mrOk;
end;

procedure TRegExprEditForm.lvRegExprKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //如果是Delete键就删除当前项目
  if Assigned(lvRegExpr.ItemFocused) and (Key = vk_Delete) then
    if Application.MessageBox('Are you sure to delete current item?', 'Confirmation', MB_OKCANCEL)
      = idOk then
      lvRegExpr.Items.Delete(lvRegExpr.ItemFocused.Index);
end;

procedure TRegExprEditForm.ActionExportUpdate(Sender: TObject);
begin
  //输出文件校验
  (Sender as TAction).Enabled := lvRegExpr.Items.Count > 0;
end;

procedure TRegExprEditForm.ActionExportExecute(Sender: TObject);
var
  FS: TStringList;
  I: Integer;
begin
  //导出文件
  if SaveDialog.Execute then
  begin
    FS := TStringList.Create;
    for I := 0 to lvRegExpr.Items.Count - 1 do
    begin
      FS.Add(lvRegExpr.Items.Item[i].Caption);
      FS.Add(lvRegExpr.Items.Item[i].SubItems[0]);
      FS.Add(lvRegExpr.Items.Item[i].SubItems[1]);
      FS.Add(lvRegExpr.Items.Item[i].SubItems[2]);
    end;
    FS.SaveToFile(SaveDialog.FileName);
    FS.Free;
  end;
end;

procedure TRegExprEditForm.btnImportClick(Sender: TObject);
var
  FS: TStringList;
  I: Integer;
  Item: TListItem;
begin
  //导入文件
  if OpenDialog.Execute then
  begin
    FS := TStringList.Create;
    FS.LoadFromFile(OpenDialog.FileName);
    if (FS.Count mod 4) = 0 then
    begin
      for I := 0 to (FS.Count div 4) - 1 do
      begin
        if Assigned(lvRegExpr.FindCaption(0, FS.Strings[I * 4], False, True,
          True)) then
          if
            Application.MessageBox(PChar(format('Already exist %s expression，whether continue to add or not?', [FS.Strings[I * 3]])), 'Error', MB_OKCANCEL) = IDCANCEL then
            Continue;
        //添加到列表中
        Item := lvRegExpr.Items.Add;
        Item.Caption := FS.Strings[I * 4];
        Item.SubItems.Add(FS.Strings[I * 4 + 1]);
        Item.SubItems.Add(FS.Strings[I * 4 + 2]);
        Item.SubItems.Add(FS.Strings[I * 4 + 3]);
      end;
    end
    else
      Application.MessageBox('Invalid File format', 'Error', MB_OK);
  end;
end;

procedure TRegExprEditForm.edtRegExprChange(Sender: TObject);
begin
  if edtRegExpr.IsExprValid(edtRegExpr.Text) then
  begin
    edtRegExpr.Expression := edtRegExpr.Text;
    edtRegExpr.Font.Color := clBlack;
  end
  else
    edtRegExpr.Font.Color := clRed;
end;

procedure TRegExprEditForm.edtInputExprChange(Sender: TObject);
begin
  if edtInputExpr.IsExprValid(edtInputExpr.Text) then
  begin
    edtInputExpr.Expression := edtInputExpr.Text;
    edtInputExpr.Font.Color := clBlack;
  end
  else
    edtInputExpr.Font.Color := clRed;
end;

procedure TRegExprEditForm.edtTestChange(Sender: TObject);
var
  Edit: TREEdit;
begin
  Edit := (Sender as TREEdit);
  if Edit.valid then
    Edit.Font.Color := clBlack
  else
    Edit.Font.Color := clRed;
end;

procedure TRegExprEditForm.edtTestEnter(Sender: TObject);
begin
  edtTest.Expression := edtRegExpr.expression;
  edtTest.InputExpression := edtInputExpr.Expression;
end;

procedure TRegExprEditForm.SetErrMsg(const Value: string);
begin
  edtErrMsg.Text := Value;
end;

procedure TRegExprEditForm.SetInputExpr(const Value: string);
begin
  edtInputExpr.Text := Value;
end;

procedure TRegExprEditForm.SetRegExpr(const Value: string);
begin
  edtRegExpr.Text := Value;
end;

function TRegExprEditForm.GetErrMsg: string;
begin
  result := edtErrMsg.Text;
end;

function TRegExprEditForm.GetRegExpr: string;
begin
  Result := edtRegExpr.Text;
end;

function TRegExprEditForm.GetInputExpr: string;
begin
  result := edtInputExpr.text;
end;

end.
