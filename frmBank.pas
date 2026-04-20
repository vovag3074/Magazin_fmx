unit frmBank;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.TMSFNCButton, FMX.Layouts, FMX.ListBox,
  FMX.Objects, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl, FMX.TMSFNCImage, FMX.Edit,
  FMX.Calendar, FMX.TMSFNCCustomComponent, FMX.TMSFNCPopup;

type
  TfmBank = class(TFrame)
    Panel1: TPanel;
    TMSFNCButton5: TTMSFNCButton;
    tlDop: TListBox;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    ListBoxItem1: TListBoxItem;
    ListBoxGroupFooter1: TListBoxGroupFooter;
    Rectangle1: TRectangle;
    TMSFNCImage1: TTMSFNCImage;
    Label1: TLabel;
    eData: TEdit;
    DropDownEditButton1: TDropDownEditButton;
    ppCalendar: TTMSFNCPopup;
    myCalendar: TCalendar;
    Layout1: TLayout;
    procedure TMSFNCButton5Click(Sender: TObject);
    procedure DropDownEditButton1Click(Sender: TObject);
    procedure myCalendarDateSelected(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadINI;
    procedure SaveINI;
  end;

 var fmBank:TfmBank;

implementation

uses
  frmMain;

{$R *.fmx}

procedure TfmBank.DropDownEditButton1Click(Sender: TObject);
begin
 ppCalendar.Popup;
end;

procedure TfmBank.LoadINI;
begin
 //
 eData.Text:= DateToStr(now);
end;

procedure TfmBank.myCalendarDateSelected(Sender: TObject);
begin
 eData.Text := DateToStr(myCalendar.Date);
 ppCalendar.IsOpen := False;
end;

procedure TfmBank.SaveINI;
begin
 //
end;

procedure TfmBank.TMSFNCButton5Click(Sender: TObject);
begin
 fmMain.ClearOldFrame;
end;

end.
