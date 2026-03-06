unit frmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCToolBar,
  FMX.TMSFNCCustomControl, FMX.TMSFNCCustomComponent, FMX.TMSFNCStyles;

type
  TfmMain = class(TForm)
    sbMain: TStatusBar;
    stbMain: TStyleBook;
    TMSFNCToolBar1: TTMSFNCToolBar;
    TMSFNCToolBarButton1: TTMSFNCToolBarButton;
    TMSFNCToolBarButton2: TTMSFNCToolBarButton;
    TMSFNCToolBarSeparator1: TTMSFNCToolBarSeparator;
    TMSFNCToolBarButton3: TTMSFNCToolBarButton;
    TMSFNCToolBarButton4: TTMSFNCToolBarButton;
    pMain: TPanel;
    TMSFNCStylesManager1: TTMSFNCStylesManager;
    procedure TMSFNCToolBarButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

uses
  frmInpSclad;

{$R *.fmx}

procedure TfmMain.TMSFNCToolBarButton1Click(Sender: TObject);
begin
 fmInpMag := TfmInpMag.Create(pMain);
 fmInpMag.Parent := pMain;
 fmInpMag.Align:= TAlignLayout.Client;
 fmInpMag.eScan.SetFocus;
 fmInpMag.ModList.AdaptToStyle:=True;
end;

end.
