program Bazar;

uses
  System.StartUpCopy,
  FMX.Forms,
  frmMain in 'frmMain.pas' {fmMain},
  frmInpSclad in 'frmInpSclad.pas' {fmInpMag: TFrame},
  frmSynhro in 'frmSynhro.pas' {fmSync},
  frmSaveMove in 'frmSaveMove.pas' {fmSMove},
  frmReport in 'frmReport.pas' {fmReport},
  frmReportList in 'frmReportList.pas' {fmRepList},
  frmInvScald in 'frmInvScald.pas' {fmInv: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
