unit frmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCToolBar,
  System.IniFiles, FMX.TMSFNCCustomControl, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCStyles, FMX.TMSFNCHint, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Phys, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.FMXUI.Wait, FireDAC.Comp.Client, Data.DB,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet,
{$IFDEF LINUX}
  FMUX.Api, FMUX.Config, Posix.Stdlib,
{$ENDIF}
{$IFDEF MSWindows}
  Winapi.DwmApi, FMX.Platform.Win, System.Notification,
{$ENDIF}
{$IFDEF MACOS}
  Macapi.Foundation, Macapi.Consts, Macapi.CocoaTypes, Macapi.CoreText,
  Macapi.AppKit, //You need it to create an '''NSApplication''' instance.
  Macapi.Helpers, //You need it to use the function StrToNSStr().
{$ENDIF}
  FMX.DialogService, FireDAC.Phys.IBBase, FMX.TMSFNCCustomScrollControl,
  FMX.TMSFNCTileList;

type
  TfmMain = class(TForm)
    sbMain: TStatusBar;
    stbMain: TStyleBook;
    tbMain: TTMSFNCToolBar;
    btMoveToSclad: TTMSFNCToolBarButton;
    TMSFNCToolBarButton2: TTMSFNCToolBarButton;
    TMSFNCToolBarSeparator1: TTMSFNCToolBarSeparator;
    btInvSclad: TTMSFNCToolBarButton;
    TMSFNCToolBarButton4: TTMSFNCToolBarButton;
    pMain: TPanel;
    TMSFNCStylesManager1: TTMSFNCStylesManager;
    IBM: TFDManager;
    IBC: TFDConnection;
    IBT: TFDTransaction;
    IBT_Read: TFDTransaction;
    qUpdSclad: TFDCommand;
    TMSFNCToolBarButton5: TTMSFNCToolBarButton;
    qTestZal: TFDQuery;
    FBDriver: TFDPhysFBDriverLink;
    Lang1: TLang;
    myList: TTMSFNCTileList;
    TMSFNCToolBarSeparator2: TTMSFNCToolBarSeparator;
    TMSFNCToolBarButton1: TTMSFNCToolBarButton;
    procedure btMoveToScladClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TMSFNCToolBarButton5Click(Sender: TObject);
    procedure btInvScladClick(Sender: TObject);
    procedure myListItemClick(Sender: TObject; AItemIndex: Integer);
  private
    { Private declarations }
    procedure LoadFormMoveToSclad;
    procedure LoadFormInv;
  public
    { Public declarations }
    procedure StartMainTransaction;
    procedure StartReadTransaction;
    procedure UpdateSclad;
    procedure ClearOldFrame;
     /// <summary>
    /// Тест заказа на уже проданный или уже переданный
    /// </summary>
    /// <param name="NoZakaz">
    /// № заказа
    /// </param>
    /// <param name="isMove">
    /// 1 - уже переданный
    /// </param>
    /// <param name="isProd">
    /// 1 - уже проданный
    /// </param>
    /// <param name="NoAgn">
    /// № агента
    /// </param>
    /// <param name="NameAgn">
    /// Имя агента
    /// </param>
    function TestZakaz(NoZakaz: string; var isMove, isProd: Boolean; var NoAgn: Integer; var NameAgn: string): Integer;
    procedure ShowIBError(SError: string);
  end;

procedure ShowInfo(T: string);

procedure ShowError(T: string);

function ShowQuestion(T: string): Boolean;

procedure ShowNotify(S: string);

function getStartProgrammDir: string;
/// <summary>
/// Вспомогательная процедура. Позволяет избавиться от ненужных для хранения
/// знаков разделения UIN
/// </summary>

procedure myCreateGUID(var P: string);

var
  fmMain: TfmMain;
  myINI: TIniFile;
  {$IFDEF MSWINDOWS}
  NtC: TNotificationCenter;
  Nt: TNotification;
 {$ENDIF}

implementation

uses
  frmInpSclad, frmInvScald;

{$R *.fmx}

procedure TfmMain.ClearOldFrame;
begin
  tbMain.Visible := true;
  myList.Visible := True;
  if Assigned(fmInpMag) then
  begin
    fmInpMag.SaveINI;
    fmInpMag.Free;
    fmInpMag := nil;
  end
  else if Assigned(fmInv) then
  begin
    fmInv.SaveINI;
    fmInv.Free;
    fmInv := nil;
  end;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  myINI.Free;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  myINI := TIniFile.Create(getStartProgrammDir + PathDelim + 'Bazar.ini');
  IBC.Connected := True;
end;

procedure TfmMain.LoadFormInv;
begin
  tbMain.Visible := False;
  myList.Visible := False;
  fmInv := TfmInv.Create(pMain);
  fmInv.Parent := pMain;
  fmInv.Align := TAlignLayout.Client;
  fmInv.tlMod.AdaptToStyle := True;
  fmInv.tlSize.AdaptToStyle := True;
  fmInv.LoadINI;
  fmInv.ListMod;
end;

procedure TfmMain.LoadFormMoveToSclad;
begin
  tbMain.Visible := False;
  myList.Visible := False;
  fmInpMag := TfmInpMag.Create(pMain);
  fmInpMag.Parent := pMain;
  fmInpMag.Align := TAlignLayout.Client;
  fmInpMag.eTxt.SetFocus;
  fmInpMag.tlMove.AdaptToStyle := True;
  fmInpMag.LoadINI;
  fmInpMag.readSclad;
end;

procedure TfmMain.myListItemClick(Sender: TObject; AItemIndex: Integer);
begin
  if AItemIndex = 0 then    //получение
  begin
    btMoveToSclad.OnClick(Sender);
  end;
  if AItemIndex = 4 then  // возврат
  begin

  end;
  if AItemIndex = 1 then  //склад
  begin
    btInvSclad.OnClick(Sender);
  end;
end;

procedure TfmMain.ShowIBError(SError: string);
var
  My: tStringList;
  I, J: Integer;
  S: string;
begin
  try
    My := tStringList.Create;
    My.Clear;
    My.Text := UTF8ToString(SError);
    for I := 0 to My.Count - 1 do
    begin
      S := My.Strings[I];
      if Pos('exception', S) > 0 then
      begin
        My.Delete(I);
        My.Delete(I);
        Break;
      end;
    end;
    S := My.Text;
    I := Length(S);
    J := Pos('At', S);
    if J > 0 then
      Delete(S, J, I - J);
    ShowNotify(S);
  finally
    My.Clear;
    FreeAndNil(My);
  end;
end;

procedure TfmMain.StartMainTransaction;
begin
  if fmMain.IBT.Active then
  begin
    fmMain.IBT.Commit;
    Application.ProcessMessages;
  end;
  fmMain.IBT.StartTransaction;
end;

procedure TfmMain.StartReadTransaction;
begin
  if fmMain.IBT_Read.Active then
  begin
    fmMain.IBT_Read.Rollback;
    Application.ProcessMessages;
    fmMain.IBT_Read.StartTransaction;
  end;
end;

function TfmMain.TestZakaz(NoZakaz: string; var isMove, isProd: Boolean; var NoAgn: Integer; var NameAgn: string): Integer;
begin
  Result := -1;
  isMove := false;
  isProd := false;
  NoAgn := -1;
  NameAgn := '';
  qTestZal.Close;
  qTestZal.Prepare;
  qTestZal.ParamByName('CZ').AsString := NoZakaz;
  qTestZal.Active := True;
  if not qTestZal.FieldByName('NO_AGN').IsNull then
  begin
    Result := qTestZal.FieldByName('NO_AGN').AsInteger;
    isMove := qTestZal.FieldByName('IS_MOVE').AsInteger = 1;
    isProd := qTestZal.FieldByName('IS_PROD').AsInteger = 1;
    NameAgn := qTestZal.FieldByName('AG_NAME').AsString + ' (' + qTestZal.FieldByName('ST_NAME').AsString + ')';
    NoAgn := qTestZal.FieldByName('NO_AGN').AsInteger;
  end;
  qTestZal.Close;
end;

procedure TfmMain.btInvScladClick(Sender: TObject);
begin
  LoadFormInv;
end;

procedure TfmMain.btMoveToScladClick(Sender: TObject);
begin
  LoadFormMoveToSclad;
end;

procedure TfmMain.TMSFNCToolBarButton5Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfmMain.UpdateSclad;
begin
  StartMainTransaction;
  qUpdSclad.Active := false;
  qUpdSclad.Prepare;
  qUpdSclad.Execute;
  IBT.Commit;
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

procedure ShowNotify(S: string);
var
  LChannel: TChannel;
begin
  // создаем немодальное окно с иконкой
  // для windows -позиция - справа внизу
  // для macOS - справа вверху
  // Linux - вверху по центру
  {$IFDEF MACOS}
  var ANotification: NSUserNotification := TNSUserNotification.Wrap(TNSUserNotification.Alloc.init);
  ANotification.setTitle(StrToNSStr('Мастер обуви'));
  ANotification.setSubtitle(StrToNSStr('Предупреждение'));
  ANotification.setInformativeText(StrToNSStr(S));
  ANotification.setSoundName(NSUserNotificationDefaultSoundName);
  var ANotificationCenter: NSUserNotificationCenter := TNSUserNotificationCenter.Wrap(TNSUserNotificationCenter.OCClass.defaultUserNotificationCenter);
  ANotificationCenter.deliverNotification(ANotification);
  {$ENDIF}
  {$IFDEF MSWindows}
  if not Assigned(NtC) then
  begin
    NtC := tNotificationCenter.Create(fmMain);
    NtC.PlatformInitialize;
  end;
  if NtC.Supported then
  begin
    LChannel := NtC.CreateChannel;
    try
      LChannel.Id := 'MyChannel';
      LChannel.Title := LChannel.Id;
      LChannel.Importance := TImportance.High;
      NtC.CreateOrUpdateChannel(LChannel);
      Nt := NtC.CreateNotification;
      Nt.Name := 'Рабочее место продавца';
      Nt.Title := 'Информация';
      Nt.AlertBody := S;
      NtC.PresentNotification(Nt);
    finally
      LChannel.Free;
    end;
  end;
  {$ENDIF}
  {$IFDEF LINUX}
  _system(PAnsiChar(AnsiString('notify-send "Информация" "' + S + '"')));
  {$ENDIF}
end;

procedure myCreateGUID(var P: string);
var
  S: string[36];
  MyGuid0: TGUID;
begin
  CreateGUID(MyGuid0);
  S := GUIDToString(MyGuid0);
  S := Copy(S, 2, length(S) - 1);
  P := StringReplace(S, '-', '', [rfReplaceAll]);
end;

end.

