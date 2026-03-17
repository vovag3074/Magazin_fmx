unit frmSynhro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, DateUtils,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ExtCtrls, FMX.Edit, FMX.ComboEdit,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCWaitingIndicator, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.ListBox,
  System.ImageList, FMX.ImgList, FMX.TMSFNCButton, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.FMXUI.Wait,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef;

type
  TfmSync = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    pb: TTMSFNCWaitingIndicator;
    qDB: TFDQuery;
    eDB: TComboBox;
    ImageList1: TImageList;
    dxOK: TTMSFNCButton;
    dxCancel: TTMSFNCButton;
    IBC_Read: TFDConnection;
    lbInfo: TLabel;
    qDelOldZak: TFDCommand;
    qRSity: TFDQuery;
    qTSity: TFDQuery;
    qWSity: TFDCommand;
    IBT_Read: TFDTransaction;
    qRVal: TFDQuery;
    qTVal: TFDQuery;
    qWVal: TFDCommand;
    qRAgn: TFDQuery;
    qTAgn: TFDQuery;
    qWAgn: TFDCommand;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dxOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure DeleteOldZakaz;
    /// <summary>
    /// Синхронизацияч городов
    /// </summary>
    procedure CopySity;
    /// <summary>
    /// Синхронизация валют
    /// </summary>
    procedure CopyVal;
     /// <summary>
    /// Синхронизация покупателей
    /// </summary>
    procedure CopyAgn;
    /// <summary>
    /// Получить код города по названию
    /// </summary>
    /// <param name="ST_Name">
    /// название города
    /// </param>
    function GetSityByName(const ST_Name: String): Integer;
    /// <summary>
    /// получить код валюты по названию
    /// </summary>
    /// <param name="V_Name">
    /// название валюты
    /// </param>
    function GetValByName(const V_Name: String): Integer;
  public
    { Public declarations }
  end;

var
  fmSync: TfmSync;

implementation

uses
  frmMain;

{$R *.fmx}

procedure TfmSync.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 myIni.WriteInteger('DBMaster','DB_ShoesMaster4', eDB.ItemIndex);
end;

procedure TfmSync.FormCreate(Sender: TObject);
var
  MyItem: TListBoxItem;
begin
  pb.Visible := False;
  eDB.Items.Clear;
  qDB.Close;
  qDB.Prepare;
  qDB.Active := true;
  if qDB.RecordCount > 0 then
  begin
    qDB.First;
    repeat
      MyItem := TListBoxItem.Create(eDB);
      MyItem.ImageIndex := 0;
      MyItem.Height:=33;
      MyItem.Text := qDB.FieldByName('NAME').AsString;
      eDB.addObject(MyItem);
      qDB.Next;
    until (qDB.Eof);
  end;
  eDB.ItemIndex := myIni.ReadInteger('DBMaster','DB_ShoesMaster4', -1);
end;

function TfmSync.GetSityByName(const ST_Name: String): Integer;
begin
  qTSity.Close;
  qTSity.Prepare;
  qTSity.ParamByName('STN').AsString := ST_Name;
  qTSity.Active := true;
  Result := qTSity.FieldByName('NO_ST').AsInteger;
end;

function TfmSync.GetValByName(const V_Name: String): Integer;
begin
  Result := -1;
  qTVal.Close;
  qTVal.Prepare;
  qTVal.ParamByName('NV').AsString := V_Name;
  qTVal.Active := true;
  if not qTVal.FieldByName('NO_VAL').IsNull then
    Result := qTVal.FieldByName('NO_VAL').AsInteger;
end;

procedure TfmSync.CopyAgn;
var
  I, T, K: Integer;
begin
  // Переписываем ПОКУПАТЕЛЕЙ
  K := 0;
  if fmMain.IBT.Active then
  begin
    fmMain.IBT.Commit;
    Application.ProcessMessages;
  end;
   fmMain.IBT.StartTransaction;
  qRAgn.Close;
  qRAgn.Prepare;
  qRAgn.Active := true;
  T := qRAgn.RecordCount;
  if T > 0 then
  begin
    qRAgn.First;
    repeat
      inc(K);
      lbInfo.Text := 'Чтение покупателя № ' + IntToStr(K) + ' из ' +
        IntToStr(T);
      Application.ProcessMessages;
      qTAgn.Close;
      qTAgn.Prepare;
      qTAgn.ParamByName('AGN').AsString :=
        qRAgn.FieldByName('AG_BAR_CODE').AsString;
      qTAgn.ParamByName('STN').AsString :=
        qRAgn.FieldByName('ST_BAR_CODE').AsString;
      qTAgn.Active := true;
      if qTAgn.FieldByName('NO_AGN').IsNull then
      begin
        try
          I := GetSityByName(qRAgn.FieldByName('ST_BAR_CODE').AsString);
          qWAgn.Close;
          qWAgn.ParamByName('AG_NAME').AsString :=
            qRAgn.FieldByName('AG_NAME').AsString;
          qWAgn.ParamByName('NO_SITY').AsInteger := I;
          qWAgn.ParamByName('AG_DOP').AsString :=
            qRAgn.FieldByName('AG_DOP').AsString;
          qWAgn.ParamByName('IS_DEL').AsInteger := qRAgn.FieldByName('IS_DEL')
            .AsInteger;
          qWAgn.ParamByName('IS_SKIDKA').AsInteger :=
            qRAgn.FieldByName('IS_SKIDKA').AsInteger;
          qWAgn.ParamByName('PRED_VAL').AsInteger :=
            GetValByName(qRAgn.FieldByName('V_NAME').AsString);
          qWAgn.ParamByName('BAR_CODE').AsString :=
            qRAgn.FieldByName('AG_BAR_CODE').AsString;
          qWAgn.Execute;
        except
        end;
      end;
      // if qTAgn.FieldByName('NO_AGN').IsNull
      qRAgn.Next;
      Application.ProcessMessages;
    until (qRAgn.Eof);
  end;
  // if qRAgn.RecordCount>0
  fmMain.IBT.Commit;
end;

procedure TfmSync.CopySity;
begin
 if fmMain.IBT.Active then
  begin
    fmMain.IBT.Commit;
    Application.ProcessMessages;
  end;
   fmMain.IBT.StartTransaction;
  qRSity.Close;
  qRSity.Prepare;
  qRSity.Active := true;
  if qRSity.RecordCount > 0 then
  begin
    qRSity.First;
    repeat
      qTSity.Close;
      qTSity.Prepare;
      qTSity.ParamByName('STN').AsString :=
        qRSity.FieldByName('bar_code').AsString;
      qTSity.Active := true;
      if qTSity.FieldByName('NO_ST').IsNull then
      begin
        qWSity.Close;
        qWSity.Prepare;
        qWSity.ParamByName('st_name').AsString :=
          qRSity.FieldByName('st_name').AsString;
        qWSity.ParamByName('IS_DEL').AsInteger := qRSity.FieldByName('IS_DEL')
          .AsInteger;
        qWSity.ParamByName('IS_STAR').AsInteger := qRSity.FieldByName('IS_STAR')
          .AsInteger;
        qWSity.ParamByName('BAR_CODE').AsString :=
          qRSity.FieldByName('BAR_CODE').AsString;
        qWSity.Execute;
      end;
      // ВСТАВЛЯЕМ ГОРОД
      qRSity.Next;
      Application.ProcessMessages;
    until (qRSity.Eof);
    fmMain.IBT.Commit;
  end;
end;

procedure TfmSync.CopyVal;
  var
  I: Integer;
begin
  if fmMain.ibt.Active then
  begin
    fmMain.ibt.Commit;
  end;
  fmMain.ibt.StartTransaction;
  qRVal.Close;
  qRVal.Prepare;
  qRVal.Active := true;
  if qRVal.RecordCount > 0 then
  begin
    qRVal.First;
    repeat
      I := GetValByName(qRVal.FieldByName('NAZVAN').AsString);
      if I = -1 then
      begin
        qWVal.Close;
        qWVal.Prepare;
        qWVal.ParamByName('nzv').AsString :=
          qRVal.FieldByName('NAZVAN').AsString;
        qWVal.Execute;
      end;
      qRVal.Next;
    until (qRVal.Eof);
    fmMain.IBT.Commit;
  end;
end;

procedure TfmSync.DeleteOldZakaz;
var
  OldDate: TDate;
begin
  if fmMain.IBT.Active then
  begin
    fmMain.IBT.Commit;
    Application.ProcessMessages;
  end;
  fmMain.IBT.StartTransaction;
  OldDate := IncDay(now, -60);
  qDelOldZak.Active:=False;
  qDelOldZak.Prepare;
  qDelOldZak.ParamByName('ED').AsDate := OldDate;
  qDelOldZak.Execute;
  fmMain.IBT.Commit;
end;

procedure TfmSync.dxOKClick(Sender: TObject);
begin
 dxOK.Enabled := False;
  ibc_Read.Params.Database := eDB.Text;
  ibc_Read.Params.Username := fmMain.IBC.Params.Username;
  ibc_Read.Params.Password := fmMain.IBC.Params.Password;
  ibc_Read.Connected:=True;
  pb.Visible := true;
  pb.Active := true;
  Application.ProcessMessages;
  lbInfo.Text := 'Удаляем устаревшие заказы';
  Application.ProcessMessages;
  DeleteOldZakaz;
  // ------------------------------
  lbInfo.Text := 'Читаем города';
  Application.ProcessMessages;
  CopySity;

  lbInfo.Text := 'Читаем валюты';
  Application.ProcessMessages;
  CopyVal;

  lbInfo.Text := 'Читаем покупателей';
  Application.ProcessMessages;
  CopyAgn;
  // -----------------------------------
  lbInfo.Text := 'Читаем типы';
  Application.ProcessMessages;
 // CopyType;
  lbInfo.Text := 'Читаем категории';
  Application.ProcessMessages;
 // CopyKat;
  lbInfo.Text := 'Читаем модели';
  Application.ProcessMessages;
 // CopyMod;
  lbInfo.Text := 'Читаем размеры';
  Application.ProcessMessages;
 // CopySize;
  lbInfo.Text := 'Читаем разрешенные размеры';
  Application.ProcessMessages;
 // CopyEnableType;
  lbInfo.Text := 'Читаем коды';
  Application.ProcessMessages;
 // CopyCode;
  lbInfo.Text := 'Читаем заказы';
  Application.ProcessMessages;
 // CopyZakaz;
  lbInfo.Text := 'Обновляем склад';
  Application.ProcessMessages;
 // fmMain.UpdateSclad;
  // -----------------------------------
  lbInfo.Text := '';
  Application.ProcessMessages;
  ModalResult := mrOk;
end;

end.
