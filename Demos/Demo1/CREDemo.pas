unit CREDemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ActnList, REEdit;

type
  TForm1 = class(TForm)
    REEdit1: TREEdit;
    Button1: TButton;
    ActionList1: TActionList;
    ActionValidate: TAction;
    RadioGroup1: TRadioGroup;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    procedure ActionValidateUpdate(Sender: TObject);
    procedure ActionValidateExecute(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ActionValidateUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled:=REEdit1.Valid;
  if not REEdit1.Valid then
    REEdit1.Font.Color:=clRed
  else
    REEdit1.Font.Color:=clGreen;
end;

procedure TForm1.ActionValidateExecute(Sender: TObject);
begin
  ShowMessage('Correct input , congratulation');
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex=0 then
    REEdit1.EditAlign:=eaLeft
  else
    REEdit1.EditAlign:=earight;
  REEdit1.SetFocus;
end;

end.
