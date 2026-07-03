unit frmSetupApp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, NativeXML,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, FMX.Edit,
  FMX.TMSFNCButton, CryptBase, AESObj, MiscObj, CryptoConst, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.Comp.Client,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCToolBar, FMX.DateTimeCtrls, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FMX.Layouts, FMX.ListBox;

type
  TfmSetup = class(TForm)
    tbSetup: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    tiSaveProt: TTabItem;
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
    Panel2: TPanel;
    btAdd: TTMSFNCButton;
    qStop: TFDCommand;
    TMSFNCButton1: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    SD: TSaveDialog;
    TabControl2: TTabControl;
    TabItem3: TTabItem;
    eSave: TEdit;
    eSaveBtn: TEllipsesEditButton;
    btOKSave: TTMSFNCToolBarButton;
    eStart: TDateEdit;
    eEnd: TDateEdit;
    qData: TFDQuery;
    qMove: TFDQuery;
    qSity: TFDQuery;
    qAgn: TFDQuery;
    qProd: TFDQuery;
    qOpl: TFDQuery;
    qRet: TFDQuery;
    lbInfoProt: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    tlStartStop: TListBox;
    qDss: TFDQuery;
    qDelSS: TFDCommand;
    procedure FormCreate(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btTestClick(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure eSaveBtnClick(Sender: TObject);
    procedure btOKSaveClick(Sender: TObject);
    procedure TMSFNCButton1Click(Sender: TObject);
  private
    { Private declarations }
    XMLDoc: TNativeXml;
    Node: TXmlNode;
    procedure NormalizeFName(var S: string);
    procedure exportFullLogBazar;
    procedure ExportDiapBazar;
    procedure ExportMoveTovar;
    procedure ExportAgentList;
    procedure ExportProdTov;
    procedure AxportSityList;
    procedure ExportOplataTovar;
    procedure ExportRetTovar;
    procedure LoadStartStop;
    procedure LoadDataProt;
  public
    { Public declarations }
  end;

var
  fmSetup: TfmSetup;

implementation

uses
  frmMain, frmSelectDate;

{$R *.fmx}

procedure TfmSetup.AxportSityList;
begin
  qSity.Close;
  fmMain.StartReadTransaction;
  qSity.Prepare;
  qSity.ParamByName('SD').AsDate := eStart.Date;
  qSity.ParamByName('ED').AsDate := eEnd.Date;
  qSity.Active := True;
  if qSity.RecordCount > 0 then
  begin
    qSity.First;
    repeat
      Node := XMLDoc.Root.NodeNew('Use_Sity');
      Node.AttributeAdd('ST_Code', qSity.FieldByName('ST_BAR_CODE').AsString);
      Node.AttributeAdd('ST_Name', qSity.FieldByName('ST_NAME').AsString);
      Node.AttributeAdd('ST_Delete', IntToStr(qSity.FieldByName('IS_DEL').AsInteger));
      Node.AttributeAdd('ST_Star', IntToStr(qSity.FieldByName('IS_STAR').AsInteger));
      qSity.Next;
    until (qSity.Eof);
  end;
  fmMain.EndReadTransaction;
end;

procedure TfmSetup.btAddClick(Sender: TObject);
var D: TDate;
begin
  try
    if ShowQuestion('Закрыть базар?') then
    begin
      try
        D := Now;
        if selectDate('Закрытие базара', 'Укажите дату закрытия', D) = mrOk then
        begin
          fmMain.StartMainTransaction;
          qStop.Prepare;
          qStop.ParamByName('DATA_STOP').Value := D;
          qStop.Execute;
          fmMain.EndMainTransaction;
          LoadStartStop;
          LoadDataProt;
        end;
      except
      end;
      Application.ProcessMessages;
      if ShowQuestion('Сохранить протокол базара?') then
      begin
        tbSetup.TabIndex:=1;
      end;
    end;
  finally
  end;
end;

procedure TfmSetup.btOKSaveClick(Sender: TObject);
begin
  exportFullLogBazar;
end;

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
    fmMain.IBC.Connected := False;
  end;
  fmMain.IBC.Params.Database := eDB.Text;
  fmMain.IBC.Params.Values['Server'] := eSrv.Text;
  fmMain.IBC.Params.Username := eUser.Text;
  fmMain.IBC.Params.Password := ePass.Text;
  try
    fmMain.IBC.Connected := True;
    ShowInfo('Соединение с Базой Данных успешно');
  except
    on E: Exception do
    begin
      ShowError(E.Message);
    end;
  end;
end;

procedure TfmSetup.eSaveBtnClick(Sender: TObject);
var
  S: string;
begin
  S := DateTimeToStr(now);
  NormalizeFName(S);
  SD.FileName := S;
  if SD.Execute then
  begin
    eSave.Text := SD.FileName;
    btOKSave.Enabled := trim(eSave.Text) <> '';
  end;
end;

procedure TfmSetup.ExportAgentList;
begin
  qAgn.Close;
  qAgn.Prepare;
  qAgn.ParamByName('SD').AsDate := eStart.Date;
  qAgn.ParamByName('ED').AsDate := eEnd.Date;
  qAgn.Active := True;
  if qAgn.RecordCount > 0 then
  begin
    qAgn.First;
    repeat
      Node := XMLDoc.Root.NodeNew('Use_Agent');
      Node.AttributeAdd('AG_Bar_Code', qAgn.FieldByName('AG_BAR_CODE').AsString);
      Node.AttributeAdd('AG_Name', qAgn.FieldByName('AG_NAME').AsString);
      Node.AttributeAdd('AG_Dolg', FloatToStr(qAgn.FieldByName('AG_DOLG').AsFloat));
      Node.AttributeAdd('AG_Valuta', qAgn.FieldByName('V_NAZVAN').AsString);
      Node.AttributeAdd('Sity_Code', qAgn.FieldByName('ST_BAR_CODE').AsString);
      Node.AttributeAdd('AG_Dop', qAgn.FieldByName('AG_DOP').AsString);
      Node.AttributeAdd('AG_Main', IntToStr(qAgn.FieldByName('IS_DEF_PROD').AsInteger));
      Node.AttributeAdd('AG_Skidka', IntToStr(qAgn.FieldByName('IS_SKIDKA').AsInteger));
      Node.AttributeAdd('AG_Deleted', IntToStr(qAgn.FieldByName('IS_DEL').AsInteger));
      qAgn.Next;
    until (qAgn.Eof);
  end;
end;

procedure TfmSetup.ExportDiapBazar;
begin
  Node := XMLDoc.Root.NodeNew('Start_Stop');
  Node.AttributeAdd('Start_Baz', DateToStr(eStart.Date));
  Node.AttributeAdd('Stop_Baz', DateToStr(eEnd.Date));
end;

procedure TfmSetup.exportFullLogBazar;
begin
  XMLDoc := TNativeXml.Create(Self);
  XMLDoc.CreateName('LogBazar'); // создали корневой узел
  lbInfoProt.Text := 'Сохраняем перемещения...';
  Application.ProcessMessages;
  ExportDiapBazar;
  ExportMoveTovar;
  lbInfoProt.Text := 'Сохраняем города...';
  Application.ProcessMessages;
  AxportSityList;
  lbInfoProt.Text := 'Сохраняем покупателей...';
  Application.ProcessMessages;
  ExportAgentList;
  lbInfoProt.Text := 'Сохраняем продажу...';
  Application.ProcessMessages;
  ExportProdTov;
  lbInfoProt.Text := 'Сохраняем оплаты...';
  Application.ProcessMessages;
  ExportOplataTovar;
  lbInfoProt.Text := 'Сохраняем возвраты...';
  Application.ProcessMessages;
  ExportRetTovar;
  lbInfoProt.Text := '';
  Application.ProcessMessages;
  XMLDoc.BinaryMethod := bmZlib;
  XMLDoc.SaveToBinaryFile(eSave.Text);
  //XMLDoc.SaveToFile(eSave.Text); // это для отладки
  ShowNotify('Протокол базара сохранен');
end;

procedure TfmSetup.ExportMoveTovar;
begin
  qMove.Close;
  fmMain.StartReadTransaction;
  qMove.Prepare;
  qMove.ParamByName('SD').AsDate := eStart.Date;
  qMove.ParamByName('ED').AsDate := eEnd.Date;
  qMove.Active := True;
  if qMove.RecordCount > 0 then
  begin
    qMove.First;
    repeat
      Node := XMLDoc.Root.NodeNew('Move_Tov');
      Node.AttributeAdd('UN_Code', qMove.FieldByName('UN_CODE').AsString);
      Node.AttributeAdd('Cnt_Mod', IntToStr(qMove.FieldByName('COUNT_OF_NO_SIZE_MOD').AsInteger));
      qMove.Next;
    until qMove.Eof;
  end;
  fmMain.EndReadTransaction;
end;

procedure TfmSetup.ExportOplataTovar;
begin
  qOpl.Close;
  qOpl.Prepare;
  qOpl.ParamByName('SD').AsDate := eStart.Date;
  qOpl.ParamByName('ED').AsDate := eEnd.Date;
  qOpl.Active := True;
  if qOpl.RecordCount > 0 then
  begin
    qOpl.First;
    repeat
      Node := XMLDoc.Root.NodeNew('Oplata_Tov');
      Node.AttributeAdd('Code_Agent', qOpl.FieldByName('BAR_CODE').AsString);
      Node.AttributeAdd('Sum_Oplata', qOpl.FieldByName('SUM_OF_SUM_OP').AsString);
      Node.AttributeAdd('Code_Model', qOpl.FieldByName('UN_CODE').AsString);
      Node.AttributeAdd('Data_Opl', DateToStr(qOpl.FieldByName('DATA_OP').AsDateTime));
      Node.AttributeAdd('is_Pred', IntToStr(qOpl.FieldByName('IS_PRED').AsInteger));
      Node.AttributeAdd('is_Bank', IntToStr(qOpl.FieldByName('IS_VIRT').AsInteger));
      qOpl.Next;
    until qOpl.Eof;
  end;
end;

procedure TfmSetup.ExportProdTov;
begin
  qProd.Close;
  qProd.Prepare;
  qProd.ParamByName('SD').AsDate := eStart.Date;
  qProd.ParamByName('ED').AsDate := eEnd.Date;
  qProd.Active := True;
  if qProd.RecordCount > 0 then
  begin
    qProd.First;
    repeat
      Node := XMLDoc.Root.NodeNew('Prod_Tov');
      Node.AttributeAdd('NO_AGN', qProd.FieldByName('BAR_CODE').AsString);
      Node.AttributeAdd('COD_MOD', qProd.FieldByName('UN_CODE').AsString);
      Node.AttributeAdd('CENA_PROD', FloatToStr(qProd.FieldByName('CENA_PROD').AsFloat));
      Node.AttributeAdd('OPLATA_PROD', FloatToStr(qProd.FieldByName('OPLATA').AsFloat));
      Node.AttributeAdd('Data_Prod', DateToStr(qProd.FieldByName('DATA_PROD').AsDateTime));
      qProd.Next;
    until (qProd.Eof);
  end;
end;

procedure TfmSetup.ExportRetTovar;
begin
  qRet.Close;
  qRet.Prepare;
  qRet.ParamByName('SD').AsDate := eStart.Date;
  qRet.ParamByName('ED').AsDate := eEnd.Date;
  qRet.Active := True;
  if qRet.RecordCount > 0 then
  begin
    qRet.First;
    repeat
      Node := XMLDoc.Root.NodeNew('Ret_Tov');
      Node.AttributeAdd('UN_Code', qRet.FieldByName('UN_CODE').AsString);
      Node.AttributeAdd('Cnt_Mod', IntToStr(qRet.FieldByName('COUNT_OF_NO_SIZE_MOD').AsInteger));
      qRet.Next;
    until qRet.Eof;
  end;
end;

procedure TfmSetup.FormCreate(Sender: TObject);
begin
  LoadStartStop;
  LoadDataProt;
  // ---------------DataBase----------------------------------
  eDB.Text := myINI.ReadString('DBConnect', 'DataBaseName', '');
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

procedure TfmSetup.LoadDataProt;
begin
  //---------------Protocol-----------------------------------
  qData.Close;
  fmMain.StartReadTransaction;
  qData.Prepare;
  qData.Active := True;
  eStart.Data := qData.FieldByName('START_BAZAR').AsDateTime;
  eEnd.Data := qData.FieldByName('END_BAZAR').AsDateTime;
  qData.Close;
  fmMain.EndReadTransaction;
end;

procedure TfmSetup.LoadStartStop;
var
  Node: TListBoxItem;
begin
  tlStartStop.Items.Clear;
  fmMain.StartReadTransaction;
  qDss.Close;
  qDss.Prepare;
  qDss.Active := true;
  if qDss.RecordCount > 0 then
  begin
    qDss.First;
    repeat
      Node := tListBoxItem.Create(tlStartStop);
      Node.Tag := qDss.FieldByName('NO_SSS').AsInteger;
      Node.Text := DateToStr(qDss.FieldByName('DATA_STOP').AsDateTime);
      tlStartStop.AddObject(Node);
      qDss.Next;
    until (qDss.Eof);
    tlStartStop.ItemIndex := 0;
  end;
  fmMain.EndReadTransaction;
end;

procedure TfmSetup.NormalizeFName(var S: string);
var
  I: Integer;
begin
  repeat
    I := pos('.', S);
    if I > 0 then
    begin
      delete(S, I, 1);
      insert('_', S, I);
    end;
  until (I = 0);
  repeat
    I := pos(':', S);
    if I > 0 then
    begin
      delete(S, I, 1);
      insert('_', S, I);
    end;
  until (I = 0);
  repeat
    I := pos(' ', S);
    if I > 0 then
    begin
      delete(S, I, 1);
      insert('_', S, I);
    end;
  until (I = 0);
end;

procedure TfmSetup.TMSFNCButton1Click(Sender: TObject);
var
  S: string;
begin
  if tlStartStop.Count = 0 then
    Exit;
  S := tlStartStop.ItemByIndex(tlStartStop.ItemIndex).Text;
  if ShowQuestion('Удалить дату ' + S + ' из списка закрытых базаров?') then
  begin
    fmMain.StartMainTransaction;
    qDelSS.Close;
    qDelSS.Prepare;
    qDelSS.ParamByName('NO_SSS').AsInteger := tlStartStop.itemByIndex(tlStartStop.ItemIndex).Tag;
    qDelSS.Execute;
    fmMain.EndMainTransaction;
    LoadStartStop;
    LoadDataProt;
  end;
end;

end.

