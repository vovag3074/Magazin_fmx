unit frmAddDop;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCButton, FMX.Objects,
  FMX.Edit, FMX.DateTimeCtrls;

type
  TfmAddDop = class(TForm)
    Rectangle1: TRectangle;
    TMSFNCButton1: TTMSFNCButton;
    Label1: TLabel;
    eAgn: TEdit;
    TMSFNCButton2: TTMSFNCButton;
    Label2: TLabel;
    DateEdit1: TDateEdit;
    Label3: TLabel;
    eSum: TEdit;
    Label4: TLabel;
    TMSFNCButton3: TTMSFNCButton;
    procedure TMSFNCButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAddDop: TfmAddDop;

implementation

uses
  frmMain, frmCalc;

{$R *.fmx}

procedure TfmAddDop.TMSFNCButton3Click(Sender: TObject);
begin
 showCalc(eSum);
end;

end.
