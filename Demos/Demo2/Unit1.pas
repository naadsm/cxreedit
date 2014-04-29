unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, REEdit;

type
  TForm1 = class(TForm)
    REEdit1: TREEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    rdoIntegers: TRadioButton;
    rdoDecimals: TRadioButton;
    rdoAnyText: TRadioButton;
    rdoCustom: TRadioButton;
    leCustomRegExp: TEdit;
    procedure rdoClick(Sender: TObject);
  private
    { Private declarations }
  public
    constructor create( AOwner: TComponent ); override;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

  uses
    RegExpDefs
  ;

  constructor TForm1.create( AOwner: TComponent );
    begin
      inherited create( AOwner );

      REEdit1.InputExpression := RE_SIGNED_INTEGER_INPUT;
    end
  ;

  
  procedure TForm1.rdoClick(Sender: TObject);
    begin
      if( rdoIntegers.Checked ) then
        REEdit1.InputExpression := RE_SIGNED_INTEGER_INPUT
      else if( rdoDecimals.Checked ) then
        REEdit1.InputExpression := RE_SIGNED_DECIMAL_INPUT
      else if( rdoAnyText.Checked ) then
        REEdit1.InputExpression := '.*'
      else if( rdoCustom.Checked ) then
        // Do something, some day
      ;

      REEdit1.Text := '';
    end
  ;

end.
