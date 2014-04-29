{$I CXDefine.inc}
unit REDsgn;

interface
uses {$IFDEF CX_D5}Dsgnintf{$ELSE}DesignIntf, DesignEditors{$ENDIF}, REEdit, REProp, Forms, Controls;

type
  //正则表达式的属性编辑器      TPropertyEditor
  TRegExprProperty = class(TStringProperty)
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

procedure Register;

implementation
{ TRegExprProperty }

procedure Register;
begin
  //考虑去掉PropertyEditor，而是改成ComponentEditor
  RegisterPropertyEditor(TypeInfo(string), TREEdit, 'Expression',
    TRegExprProperty);
  RegisterPropertyEditor(TypeInfo(string), TREEdit, 'InputExpression',
    TRegExprProperty);
end;

procedure TRegExprProperty.Edit;
var
  AForm: TRegExprEditForm;
  I: Integer;
begin
  AForm := TRegExprEditForm.Create(Application);
  //AForm.RegExpr:=GetValue;
  AForm.RegExpr := TREEdit(GetComponent(0)).Expression;
  AForm.InputExpr := TREEdit(GetComponent(0)).InputExpression;
  AForm.ErrMsg := TREEdit(GetComponent(0)).ErrorMessage;
  try
    if AForm.ShowModal = mrOk then
    begin
      //SetValue(AForm.RegExpr);
      //这里考虑了将信息赋值给所有被多选的控件
      for I := 0 to PropCount - 1 do
      begin
        TREEdit(GetComponent(I)).Expression := AForm.RegExpr;
        TREEdit(GetComponent(I)).InputExpression := AForm.InputExpr;
        TREEdit(GetComponent(I)).ErrorMessage := AForm.ErrMsg;
      end;
    end;
  finally
    AForm.Free;
  end;
end;

function TRegExprProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

end.
