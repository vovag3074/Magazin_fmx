unit frmInpSclad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.Controls.Presentation, FMX.TMSFNCButton, FMX.Edit,
  FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCTreeView, FMX.TMSFNCSplitter;

type
  TfmInpMag = class(TFrame)
    Panel1: TPanel;
    btAssept: TTMSFNCButton;
    Panel2: TPanel;
    eTxt: TEdit;
    EditButton1: TTMSFNCButton;
    ModList: TTMSFNCTreeView;
    TMSFNCButton1: TTMSFNCButton;
    pmRep: TPopup;
    pnRep: TPanel;
    TMSFNCButton2: TTMSFNCButton;
    TMSFNCButton3: TTMSFNCButton;
    TMSFNCButton4: TTMSFNCButton;
    pnTree: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    TMSFNCButton5: TTMSFNCButton;
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure EditButton1Click(Sender: TObject);
    procedure TMSFNCButton4Click(Sender: TObject);
    procedure TMSFNCButton5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure readSclad;
    procedure LoadINI;
    procedure SaveINI;
  end;

 var fmInpMag:TfmInpMag;


implementation

uses
  frmSynhro, frmMain;

{$R *.fmx}

{ TfmInpMag }

procedure TfmInpMag.EditButton1Click(Sender: TObject);
begin
 eTxt.Text:='';
end;

procedure TfmInpMag.LoadINI;
begin
 pnTree.Width:=myINI.ReadInteger('Move','TreeWidth',300);
end;

procedure TfmInpMag.readSclad;
begin
 ModList.Nodes.Clear;
end;

procedure TfmInpMag.SaveINI;
begin
 myINI.WriteInteger('Move','TreeWidth',Trunc(pnTree .Width));
end;

procedure TfmInpMag.TMSFNCButton1Click(Sender: TObject);
begin
 pmRep.Popup();
end;

procedure TfmInpMag.TMSFNCButton4Click(Sender: TObject);
begin
  fmSync := TfmSync.Create(fmInpMag);
  fmSync.ShowModal;
  fmSync.Free;
end;

procedure TfmInpMag.TMSFNCButton5Click(Sender: TObject);
begin
 fmMain.ClearOldFrame;
end;

end.
