unit frmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.DialogService,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCToolBar,System.IniFiles,
  FMX.TMSFNCCustomControl, FMX.TMSFNCCustomComponent, FMX.TMSFNCStyles,
  FMX.TMSFNCHint, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Phys,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.FMXUI.Wait, FireDAC.Comp.Client, Data.DB;

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
    IBM: TFDManager;
    IBC: TFDConnection;
    IBT: TFDTransaction;
    IBT_Read: TFDTransaction;
    procedure TMSFNCToolBarButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowInfo(T: string);
procedure ShowError(T: string);
function ShowQuestion(T: string): Boolean;
function getStartProgrammDir: string;


var
  fmMain: TfmMain;
  myINI: TIniFile;

implementation

uses
  frmInpSclad;

{$R *.fmx}

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 myINI.Free;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
 myINI := TIniFile.Create(getStartProgrammDir + PathDelim +'Bazar.ini');
 IBC.Connected:=True;
end;

procedure TfmMain.TMSFNCToolBarButton1Click(Sender: TObject);
begin
 fmInpMag := TfmInpMag.Create(pMain);
 fmInpMag.Parent := pMain;
 fmInpMag.Align:= TAlignLayout.Client;
 fmInpMag.eTxt.SetFocus;
 fmInpMag.ModList.AdaptToStyle:=True;
 fmInpMag.readSclad;
end;

procedure ShowInfo(T: string);
begin
  TDialogService.PreferredMode := TDialogService.TPreferredMode.Sync;
  FMX.DialogService.TDialogService.MessageDialog(T, TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, -1, nil);
end;

procedure ShowError(T: string);
begin
  TDialogService.PreferredMode := TDialogService.TPreferredMode.Sync;
  FMX.DialogService.TDialogService.MessageDialog(T, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, -1, nil);
end;

function ShowQuestion(T: string): Boolean;
var
  f: Boolean;
begin
  f := False;
  TDialogService.PreferredMode := TDialogService.TPreferredMode.Sync;
  FMX.DialogService.TDialogService.MessageDialog(T, TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, -1,
    procedure(const AResult: TModalResult)
    begin
      if (AResult = mrYes) then
      begin
        f := true;
      end;
    end);
  Result := f;
end;

function getStartProgrammDir: string;
var
  S: string;
begin
  S := (ExtractFilePath(ParamStr(0)));
  Result := S;
end;


end.
