unit frmSelectDate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.DateTimeCtrls, FMX.TMSFNCButton;

type
  TfmSelData = class(TForm)
    Panel1: TPanel;
    eData: TDateEdit;
    lbInfo: TLabel;
    TMSFNCButton1: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSelData: TfmSelData;

function selectDate(Title:string;Info:string;var myDate:tDate):Integer;

implementation

uses
  frmMain;

{$R *.fmx}

function selectDate(Title:string;Info:string;var myDate:tDate):Integer;
begin
  fmSelData := TfmSelData.Create(Application);
  fmSelData.Caption := Title;
  fmSelData.lbInfo.Text:=Info;
  fmSelData.eData.Date:=myDate;
  Result := fmSelData.ShowModal;
  fmSelData.Free;
  fmSelData:=nil;
end;

end.
