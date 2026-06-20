unit frmSetupApp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, FMX.Edit,
  FMX.TMSFNCButton, CryptBase, AESObj, MiscObj, CryptoConst;

type
  TfmSetup = class(TForm)
    Panel1: TPanel;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Инструменты: TTabItem;
    Закрытие: TTabItem;
    eSrv: TEdit;
    eDB: TEdit;
    eUser: TEdit;
    ePass: TEdit;
    btTest: TTMSFNCButton;
    btSave: TTMSFNCButton;
    PasswordEditButton1: TPasswordEditButton;
    mySave: TAESEncryption;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btTestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSetup: TfmSetup;

implementation

uses
  frmMain;

{$R *.fmx}

procedure TfmSetup.btSaveClick(Sender: TObject);
begin
  mySave.inputFormat := TConvertType.raw;
  mySave.outputFormat := TConvertType.hexa;
  mySave.keyLength := TAESKeyLength.kl128;
  mySave.key := 'Ihello3074Ihello';      //16 char
  var T: string;
  T := mySave.Encrypt(ePass.Text);
  myINI.WriteString('DBConnect', 'ServerName', eSrv.Text);
  myINI.WriteString('DBConnect', 'DataBaseName', eDB.Text);
  myINI.WriteString('DBConnect', 'UserName', eUser.Text);
  myINI.WriteString('DBConnect', 'Password', T);
  ShowInfo('Настройки сохранены');
end;

procedure TfmSetup.btTestClick(Sender: TObject);
begin
  if fmMain.IBC.Connected then
  begin
    fmMain.IBC.Connected:=False;
  end;
  fmMain.IBC.Params.Database:=eDB.Text;
  fmMain.IBC.Params.Values['Server'] := eSrv.Text;
  fmMain.IBC.Params.Username := eUser.Text;
  fmMain.IBC.Params.Password := ePass.Text;
  try
    fmMain.IBC.Connected := True;
    ShowInfo('Соединение с Базой Данных успешно');
  except on E:Exception do
   begin
     ShowError(E.Message);
   end;
  end;
end;

procedure TfmSetup.FormCreate(Sender: TObject);
begin
  eDB.Text := myINI.ReadString('DBConnect', 'DataBaseName','');
  eSrv.Text := myINI.ReadString('DBConnect', 'ServerName', '');
  eUser.Text := myINI.ReadString('DBConnect', 'UserName', 'sysdba');
  var T: string;
  T := myINI.ReadString('DBConnect', 'Password', '');
  if T.Trim <> '' then
  begin
    mySave.inputFormat := TConvertType.raw;
    mySave.outputFormat := TConvertType.raw;
    mySave.key := 'Ihello3074Ihello';      //16 char
    mySave.keyLength := TAESKeyLength.kl128;
    mySave.inputFormat := TConvertType.hexa;
    T := mySave.Decrypt(T);
    ePass.Text := T;
  end;
end;

end.

