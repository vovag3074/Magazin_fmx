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
    TMSFNCButton1: TTMSFNCButton;
    Panel2: TPanel;
    eScan: TEdit;
    EditButton1: TTMSFNCButton;
    ModList: TTMSFNCTreeView;
    TMSFNCSplitter1: TTMSFNCSplitter;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure readSclad;
  end;

 var fmInpMag:TfmInpMag;


implementation

{$R *.fmx}

{ TfmInpMag }

procedure TfmInpMag.readSclad;
begin
 ModList.Nodes.Clear;
end;

end.
