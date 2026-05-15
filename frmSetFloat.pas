unit frmSetFloat;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.EditBox, FMX.NumberBox,
  FMX.TMSFNCButton;

type
  TfmSelFloat = class(TForm)
    Panel1: TPanel;
    eSum: TNumberBox;
    TMSFNCButton1: TTMSFNCButton;
    eInfo: TLabel;
    TMSFNCButton2: TTMSFNCButton;
    TMSFNCButton3: TTMSFNCButton;
    procedure TMSFNCButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function getNumberValue(Titel:String;Info:String;DecimalCnt:Integer;var Value:Double):Integer;

var
  fmSelFloat: TfmSelFloat;

implementation

uses
  frmMain, frmCalc;

{$R *.fmx}

function getNumberValue(Titel:String;Info:String;DecimalCnt:Integer;var Value:Double):Integer;
begin
  fmSelFloat := TfmSelFloat.Create(Application);
  fmSelFloat.Caption := Titel;
  fmSelFloat.eInfo.Text := Info;
  fmSelFloat.eSum.DecimalDigits:=DecimalCnt;
  fmSelFloat.eSum.Value := Value;
  Result := fmSelFloat.ShowModal;
  fmSelFloat.Free;
  fmSelFloat:=nil;
end;


procedure TfmSelFloat.TMSFNCButton1Click(Sender: TObject);
begin
 showCalc(eSum);
end;

end.
