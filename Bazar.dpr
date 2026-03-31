program Bazar;

uses
  System.StartUpCopy,
  FMX.Forms,
  frmMain in 'frmMain.pas' {fmMain},
  frmInpSclad in 'frmInpSclad.pas' {fmInpMag: TFrame},
  frmSynhro in 'frmSynhro.pas' {fmSync},
  frmSaveMove in 'frmSaveMove.pas' {fmSMove};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
