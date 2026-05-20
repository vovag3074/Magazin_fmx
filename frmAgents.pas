unit frmAgents;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.TMSFNCButton, FMX.Controls.Presentation;

type
  TfmAgn = class(TFrame)
    Panel1: TPanel;
    TMSFNCButton5: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    procedure TMSFNCButton5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadINI;
    procedure SaveINI;
  end;

var fmAgn : TfmAgn;

implementation

uses
  frmMain;

{$R *.fmx}

{ TfmAgn }

procedure TfmAgn.LoadINI;
begin

end;

procedure TfmAgn.SaveINI;
begin

end;

procedure TfmAgn.TMSFNCButton5Click(Sender: TObject);
begin
 fmMain.ClearOldFrame;
end;

end.
