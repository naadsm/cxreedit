{***************************************************************
 *
 * Unit Name         : REEdit
 * Purpose           : Regular Expression Edit
 * Original Author   : hubdog(Xing Chen)
 * BeginDate         : 2001-9-13
 * History  : 1.0a
 *            1.1a(将定义好的正则表达式放到注册表中，同时
 *                 将控件的错误信息同正则表达式绑定）
 *            1.2a （不允许在表达式中出现同名的表达式）
 *            1.3a (将注册表中规则导出为文件，和将规则文件导入到注册表)
 *            1.4a (当表达式无效时，禁止添加到正则表达式列表中)
 *            1.5a (增加了CanEmpty和Empty属性)
 * 2001-10-19 1.6a 应该增加一个输入校验表达式，它可以和Expression不一样
 *                 主要是用于输入控制输入无效字符的。同时要修改属性编辑器,使其支持多选设定
 *            1.7a 有待增加对Delphi6的支持，主要是属性编辑器方面，另外就是应该将属性编辑器单元
 *                 同控件单元分离，同时将注册单元也分离（待完成）
 *            1.8a 增加左右对齐控制，增加$符号等的显示，但不能编辑（待完成)
              1.9a 增加跳字符号控制(待完成)
              Done: 删除键和回退键的无效问题? 如果输入的键有回退键和删除键，应该让其生效

 Subsequent modifications:
 Author: Aaron Reeves <Aaron.Reeves@colostate.edu>
 Version 1.9.2 (June 15, 2006) - Component is installed in a standard way/location
 Version 1.9.3 (July 13, 2009) - Implemented copy/paste, etc., in KeyDown()

 Modified version Copyright (c) 2006 - 2009 Animal Population Health Institute at Colorado State University

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General
 Public License as published by the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 ****************************************************************}

{$I CXDefine.inc}
unit REEdit;
{$R *.res}

interface

uses
  {$IFDEF CX_debug}udbg,{$ENDIF}Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RegExpr; //, {$IFDEF CX_D5}Dsgnintf{$ELSE}DesignIntf{$ENDIF};

type
  TEditAlign = (eaLeft, eaRight);

  TREEdit = class(TCustomEdit)
  private
    //FValid: Boolean;
    // FExprValid:Boolean;
    FRegExpr: TRegExpr;
    FExpression: string;
    FErrorMessage: string;
    FCanEmpty: Boolean;
    FInputExpression: string;
    FAlign: TEditAlign;
    procedure SetExpression(const Value: string);
    function GetValid: Boolean;
    procedure SetErrorMessage(const Value: string);
    //function GetExprValid: Boolean;
    function GetEmpty: Boolean;
    procedure SetCanEmpty(const Value: Boolean);
    procedure SetInputExpression(const Value: string);
    procedure SetAlign(const Value: TEditAlign);
    { Private declarations }
  protected
    { Protected declarations }
    procedure ProcessInput(var Msg: TWMChar); message WM_Char;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsExprValid(Expr: string): Boolean; //正则表达式是否有效
    property RegExpr: TRegExpr read FRegExpr; //正则表达式对象
  published
    { Published declarations }
   // property ExprValid: Boolean read GetExprValid; //判断正则表达式是否有效
    property Expression: string read FExpression write SetExpression; //正则表达
    property InputExpression: string read FInputExpression write
      SetInputExpression; //输入的正则表达式校验，不符合表达式的不允许输入
    property Valid: Boolean read GetValid; //输入是否符合正则表达式
    property ErrorMessage: string read FErrorMessage write SetErrorMessage;
    property CanEmpty: Boolean read FCanEmpty write SetCanEmpty default True;
    //是否可以为空
    property Empty: Boolean read GetEmpty; //是否为空
    //当输入无效时要显示的错误信息
    property EditAlign: TEditAlign read FAlign write SetAlign;
    //property DisplayTemplete:string;//比如:$xxx%s.xx
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

procedure Register;

implementation
//uses REProp;
uses Clipbrd;

procedure Register;
begin
  RegisterComponents('APHIControls', [TREEdit]);
  //考虑去掉PropertyEditor，而是改成ComponentEditor
end;

{ TREEdit }

constructor TREEdit.Create(AOwner: TComponent);
begin
  inherited;
  FRegExpr := TRegExpr.Create;
  FExpression := ''; //这里应该赋值一个允许所有的字符串无限制输入的表达式
  FCanEmpty := True; //可以为空
  FAlign := eaLeft; //左对齐
end;

destructor TREEdit.Destroy;
begin
  FRegExpr.Free;
  inherited;
end;

function TREEdit.GetEmpty: Boolean;
begin
  Result := Text = '';
end;

{function TREEdit.GetExprValid: Boolean;
begin
  try
    if FExpression <> '' then
    begin
      FRegExpr.Expression:=FExpression;
      FRegExpr.Compile;
      Result := True;
    end;
  except
    Result := False;
  end;
end;}

function TREEdit.GetValid: Boolean;
begin
  //当表达式为空时，认为输入是有效的
  Result := False;
  if (not CanEmpty) and Empty then
    Result := False
  else if (Expression = '') then
    Result := True
  else if (Expression <> '') then
  begin
    FRegExpr.expression := FExpression;
    FRegExpr.compile;
    Result := FRegExpr.Exec(Text)
  end;
end;

procedure TREEdit.ProcessInput(var Msg: TWMChar);
var
  S: string;
begin
  //todo:判断回退键和删除键，前后键
{$IFDEF CX_debug}
  Debugger.LogFmtMsg('CharCode:%d', [Msg.CharCode]);
{$ENDIF}
  S := Text + string(Chr(Msg.CharCode));
  if FInputExpression <> '' then
  begin
    //这里没有try-except处理是假定肯定可以编译通过
    FRegExpr.Expression := FInputExpression;
    FRegExpr.Compile;
    if FRegExpr.Exec(S) then
      inherited
    else if Msg.CharCode=8 then//如果是删除键
      inherited
    else
      Msg.Result := 0;
  end
  else
    inherited;
end;

function TREEdit.IsExprValid(Expr: string): Boolean;
begin
  Result := False;
  if Expr <> '' then
  begin
    try
      FRegExpr.Expression := Expr;
      FRegExpr.compile;
      Result := True;
    except
    end;
  end;
end;

procedure TREEdit.SetCanEmpty(const Value: Boolean);
begin
  FCanEmpty := Value;
end;

procedure TREEdit.SetErrorMessage(const Value: string);
begin
  FErrorMessage := Value;
end;

procedure TREEdit.SetExpression(const Value: string);
begin
  //FRegExpr.Expression := Value;
  if FExpression = Value then
    Exit;
  if IsExprValid(Value) or (Value = '') then
    FExpression := Value
  else
    raise Exception.create('Invalid regular expression');
  //FRegExpr.Expression := FExpression;
end;

procedure TREEdit.SetInputExpression(const Value: string);
begin
  //FRegExpr.Expression := Value;
  if FInputExpression = Value then
    Exit;
  if IsExprValid(Value) or (Value = '') then
    FInputExpression := Value
  else
    raise Exception.create('Invalid input regular expression');
  //FRegExpr.Expression := FExpression;
end;

procedure TREEdit.SetAlign(const Value: TEditAlign);
begin
  if FAlign = Value then
    Exit;
  FAlign := Value;
  RecreateWnd;
end;

procedure TREEdit.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if EditAlign = earight then
    Params.Style := Params.Style or ES_RIGHT;
end;

procedure TREEdit.DoEnter;
begin
  inherited;
  //进入时，将显示字符去掉
end;

procedure TREEdit.DoExit;
begin
  inherited;
  //设置显示字符
end;

procedure TREEdit.KeyDown(var Key: Word; Shift: TShiftState);
    var
      pasteStr: string;
      preStr, postStr: string;
      copyStr: string;
      newSelStart: integer;
    begin
      // FIX ME: Rather bizarrely, if an "anything goes" input expression is used,
      // copy/paste, etc., work as usual.  But is a more restrictive input expression
      // is used, copy/paste will not work unless the code below is present.
      // This is only a problem with paste: if a permissive RE is used, it is possible
      // to get the pasted text twice.
      //
      // The fix implemented in the "paste" code below is a hack, but I don't know what else to do.
      //
      // Another issue might come up with other languages.  Keys for copy/paste here assume US English
      // shortcut keys.  These may differ in other languages/regions.

      inherited;

      if( ( ssCtrl in shift ) ) then
        begin
          case key of
            65: // CTRL-A
              self.SelectAll;
            67: // CTRL-C
              begin
                if( 0 < self.SelLength ) then
                  begin
                    copyStr := copy( self.Text, self.SelStart + 1, self.SelLength );
                    clipboard.SetTextBuf( PChar( copyStr ) );
                  end
                ;
              end
            ;
            86: // CTRL-V
              begin
                if( not( self.ReadOnly ) ) then
                  begin
                    if Clipboard.HasFormat( CF_TEXT ) then
                      begin
                        if( '.*' <> self.InputExpression ) then
                          begin
                            pasteStr := Clipboard.AsText;
                            newSelStart := self.SelStart + length( pasteStr );

                            preStr := copy( self.Text, 0, self.SelStart );
                            postStr := copy( self.Text, self.SelStart + self.SelLength + 1, length( self.Text ) );
                            pasteStr := preStr + pasteStr + postStr;

                            if( ExecRegExpr( self.InputExpression, ( pasteStr ) ) ) then
                              begin
                                self.Text := '';
                                self.text := pasteStr;
                                self.SelStart := newSelStart;
                              end
                            ;
                          end
                        ;
                      end
                    ;
                  end
                ;
              end
            ;
            88: // CTRL-X
              begin
                if( not( self.ReadOnly ) ) then
                  begin
                    if( 0 < self.SelLength ) then
                      begin
                        copyStr := copy( self.Text, self.SelStart + 1, self.SelLength );
                        newSelStart := self.SelStart;

                        clipboard.SetTextBuf( PChar( copyStr ) );

                        preStr := copy( self.Text, 0, self.SelStart );
                        postStr := copy( self.Text, self.SelStart + self.SelLength + 1, length( self.Text ) );
                        pasteStr := preStr + postStr;

                        if( ExecRegExpr( self.InputExpression, ( pasteStr ) ) ) then
                          begin
                            self.Text := pasteStr;
                            self.SelStart := newSelStart;
                          end
                        ;
                      end
                    ;
                  end
                ;
              end
            ;
          end;
        end
      else if( self.ReadOnly ) then
        // Do nothing
      else if( ssAlt in shift ) then
        // Do nothing
      else if( self.SelLength = length( self.Text ) ) then
        self.Text := ''
      ;

  end
;

end.
//备注;表达式'bn'将会把'bbbnnbn'判断为正确的字符串，怀疑是bug
//我的解决办法是用^bn$来判断
