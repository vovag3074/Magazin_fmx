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
    cbIgn: TCheckBox;
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
    qRType: TFDQuery;
    qTType: TFDQuery;
    qWType: TFDCommand;
    qRKat: TFDQuery;
    qTKat: TFDQuery;
    qTKat2: TFDQuery;
    qWKat: TFDCommand;
    qUpdKat2: TFDCommand;
    qUpdKat3: TFDCommand;
    qUpdKat4: TFDCommand;
    qRMod: TFDQuery;
    qUMod: TFDQuery;
    qUmod2: TFDCommand;
    qWMod: TFDCommand;
    qBar: TFDQuery;
    qTMod: TFDQuery;
    qRSize: TFDQuery;
    qWSize: TFDCommand;
    qTCode: TFDQuery;
    qTSize: TFDQuery;
    qTEnable: TFDQuery;
    qInsType: TFDCommand;
    qRCode: TFDQuery;
    qUCode: TFDCommand;
    qWCode: TFDCommand;
    qExpZak: TFDQuery;
    qInsZak: TFDCommand;
    qTZakList: TFDQuery;
    qExpZalList: TFDQuery;
    qInsDetZak: TFDCommand;
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
    /// Синхронизация типов категорий моделей
    /// </summary>
    procedure CopyType;
    /// <summary>
    /// Синхронизация категорий
    /// </summary>
    procedure CopyKat;
    /// <summary>
    /// Синхронизация моделей
    /// </summary>
    procedure CopyMod;
    /// <summary>
    /// Синхронизация размеров
    /// </summary>
    procedure CopySize;
    /// <summary>
    /// Копироватние списка разрешенных моделей
    /// </summary>
    procedure CopyEnableType;
    /// <summary>
    /// Синхронизация штрих кодов моделей
    /// </summary>
    procedure CopyCode;
    /// <summary>
    /// Копирование активных заказов
    /// </summary>
    procedure CopyZakaz;
    procedure CopyZakDetail(CodeZakaza: String);

    /// <summary>
    /// Получение кода размера по названию
    /// </summary>
    /// <param name="No_Size">
    /// название размера
    /// </param>
    function GetSize(const No_Size: Integer): Integer;
    /// <summary>
    /// Получить код города по названию
    /// </summary>
    /// <param name="ST_Name">
    /// название города
    /// </param>
    function GetSityByName(const ST_Name: string): Integer;
    /// <summary>
    /// получить код валюты по названию
    /// </summary>
    /// <param name="V_Name">
    /// название валюты
    /// </param>
    function GetValByName(const V_Name: string): Integer;
    /// <summary>
    /// получение кода типа модели по uin
    /// </summary>
    /// <param name="Barcode">
    /// uin
    /// </param>
    function GetNoTypeByCode(Barcode: string): Integer;
     /// <summary>
    /// получение категории по уникальному коду
    /// </summary>
    /// <param name="UIN_Name">
    /// уникальный код
    /// </param>
    /// <remarks>
    /// код не повторяется в отличие от ключа
    /// </remarks>
    function GetKatByUIN(const UIN_Name: string): Integer;
     /// <summary>
    /// Получение кода категории по названию
    /// </summary>
    /// <param name="K_Name">
    /// имя категории
    /// </param>
    function GetKatByName(const K_Name: string): Integer;
    /// <summary>
    /// получение кода модели по штрих-коду
    /// </summary>
    /// <param name="Barcode">
    /// штрих - код
    /// </param>
    /// <remarks>
    /// штрих код иникален. первая цифра соответствует № цеха
    /// </remarks>
    function GetNoModFromBarcode(Barcode: string): Integer;
    /// <summary>
    /// Получение кода модели по названию
    /// </summary>
    /// <param name="Mod_Name">
    /// название модели
    /// </param>
    /// <param name="Kat_Name">
    /// название категории
    /// </param>
    function GetModByName(const Mod_Name: string; const Kat_Name: string): Integer;
      /// <summary>
    /// получение кода размера по uin
    /// </summary>
    /// <param name="MyCode">
    /// uin размера
    /// </param>
    function GetSizeModByCode(const MyCode: String): Integer;
    /// <summary>
    /// проверка на существующий заказ
    /// </summary>
    /// <param name="CodeZakaz">
    /// код заказа
    /// </param>
    /// <remarks>
    /// если заказ такой есть он игнорируется в дальнейшем
    /// </remarks>
    function isIgnoreZakaz(CodeZakaz: String): Boolean;
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
  myIni.WriteInteger('DBMaster', 'DB_ShoesMaster4', eDB.ItemIndex);
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
      MyItem.Height := 33;
      MyItem.Text := qDB.FieldByName('NAME').AsString;
      eDB.addObject(MyItem);
      qDB.Next;
    until (qDB.Eof);
  end;
  eDB.ItemIndex := myIni.ReadInteger('DBMaster', 'DB_ShoesMaster4', -1);
end;

function TfmSync.GetKatByName(const K_Name: string): Integer;
begin
  qTKat.Close;
  qTKat.Prepare;
  qTKat.ParamByName('NKT').AsString := K_Name;
  qTKat.Active := true;
  if not qTKat.FieldByName('NO_KAT').IsNull then
  begin
    Result := qTKat.FieldByName('NO_KAT').AsInteger;
  end
  else
  begin
    //ShowInfo('Категория : '+K_Name+' не вернула значение');
    Result := -1;
  end;
end;

function TfmSync.GetKatByUIN(const UIN_Name: string): Integer;
begin
  Result := -1;
  qTKat2.Close;
  qTKat2.Prepare;
  qTKat2.ParamByName('UN').AsString := UIN_Name;
  qTKat2.Active := true;
  if not qTKat2.FieldByName('NO_KAT').IsNull then
    Result := qTKat2.FieldByName('NO_KAT').AsInteger;
end;

function TfmSync.GetModByName(const Mod_Name, Kat_Name: string): Integer;
begin
  Result := -1;
  qTMod.Close;
  qTMod.Prepare;
  qTMod.ParamByName('NZM').AsString := Mod_Name;
  qTMod.ParamByName('NZK').AsString := Kat_Name;
  qTMod.Active := true;
  if not qTMod.FieldByName('NO_MOD').IsNull then
    Result := qTMod.FieldByName('NO_MOD').AsInteger;
end;

function TfmSync.GetNoModFromBarcode(Barcode: string): Integer;
begin
  Result := -1;
  qBar.Close;
  qBar.Prepare;
  qBar.ParamByName('BC').AsString := Barcode;
  qBar.Active := true;
  if not qBar.FieldByName('NO_MOD').IsNull then
    Result := qBar.FieldByName('NO_MOD').AsInteger;
  qBar.Close;
end;

function TfmSync.GetNoTypeByCode(Barcode: string): Integer;
begin
  Result := -1;
  qTType.Close;
  qTType.Prepare;
  qTType.ParamByName('UN').AsString := Barcode;
  qTType.Active := true;
  if not qTType.FieldByName('NO_TM').IsNull then
    Result := qTType.FieldByName('NO_TM').AsInteger;
  qTType.Close;
end;

function TfmSync.GetSityByName(const ST_Name: string): Integer;
begin
  qTSity.Close;
  qTSity.Prepare;
  qTSity.ParamByName('STN').AsString := ST_Name;
  qTSity.Active := true;
  Result := qTSity.FieldByName('NO_ST').AsInteger;
end;

function TfmSync.GetSize(const No_Size: Integer): Integer;
begin
 Result := -1;
  qTSize.Close;
  qTSize.Prepare;
  qTSize.ParamByName('NS').AsInteger := No_Size;
  qTSize.Active := true;
  if not qTSize.FieldByName('NO_SMT').IsNull then
    Result := qTSize.FieldByName('NO_SMT').AsInteger;
end;

function TfmSync.GetSizeModByCode(const MyCode: String): Integer;
begin
  Result := -1;
  qTCode.Close;
  qTCode.Prepare;
  qTCode.ParamByName('UC').AsString := MyCode;
  qTCode.Active := true;
  if not qTCode.FieldByName('NO_MST').IsNull then
    Result := qTCode.FieldByName('NO_MST').AsInteger;
end;

function TfmSync.GetValByName(const V_Name: string): Integer;
begin
  Result := -1;
  qTVal.Close;
  qTVal.Prepare;
  qTVal.ParamByName('NV').AsString := V_Name;
  qTVal.Active := true;
  if not qTVal.FieldByName('NO_VAL').IsNull then
    Result := qTVal.FieldByName('NO_VAL').AsInteger;
end;

function TfmSync.isIgnoreZakaz(CodeZakaz: String): Boolean;
begin
  qTZakList.Close;
  qTZakList.Prepare;
  qTZakList.ParamByName('CZ').AsString := CodeZakaz;
  qTZakList.Active := true;
  Result := not qTZakList.FieldByName('NO_ZAK').IsNull;
  qTZakList.Close;
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
      lbInfo.Text := 'Чтение покупателя № ' + IntToStr(K) + ' из ' + IntToStr(T);
      Application.ProcessMessages;
      qTAgn.Close;
      qTAgn.Prepare;
      qTAgn.ParamByName('AGN').AsString := qRAgn.FieldByName('AG_BAR_CODE').AsString;
      qTAgn.ParamByName('STN').AsString := qRAgn.FieldByName('ST_BAR_CODE').AsString;
      qTAgn.Active := true;
      if qTAgn.FieldByName('NO_AGN').IsNull then
      begin
        try
          I := GetSityByName(qRAgn.FieldByName('ST_BAR_CODE').AsString);
          qWAgn.Close;
          qWAgn.ParamByName('AG_NAME').AsString := qRAgn.FieldByName('AG_NAME').AsString;
          qWAgn.ParamByName('NO_SITY').AsInteger := I;
          qWAgn.ParamByName('AG_DOP').AsString := qRAgn.FieldByName('AG_DOP').AsString;
          qWAgn.ParamByName('IS_DEL').AsInteger := qRAgn.FieldByName('IS_DEL').AsInteger;
          qWAgn.ParamByName('IS_SKIDKA').AsInteger := qRAgn.FieldByName('IS_SKIDKA').AsInteger;
          qWAgn.ParamByName('PRED_VAL').AsInteger := GetValByName(qRAgn.FieldByName('V_NAME').AsString);
          qWAgn.ParamByName('BAR_CODE').AsString := qRAgn.FieldByName('AG_BAR_CODE').AsString;
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

procedure TfmSync.CopyCode;
var
  I,J,K: Integer;
begin
  fmMain.StartMainTransaction;
  qRCode.Close;
  qRCode.Prepare;
  qRCode.Active := true;
  J:= qRCode.RecordCount;
  K:=0;
  if J > 0 then
  begin
    qRCode.First;
    repeat
      I := GetSizeModByCode(qRCode.FieldByName('UN_SM').AsString);
      if I = -1 then
      begin
        // Если нет - вставляем
        qWCode.Active := False;
        qWCode.Prepare;
        qWCode.ParamByName('NO_MOD').AsInteger :=
          GetModByName(qRCode.FieldByName('M_NAZVAN').AsString,
          qRCode.FieldByName('K_NAZVAN').AsString);
        qWCode.ParamByName('NO_SIZE').AsInteger :=
          GetSize(qRCode.FieldByName('NO_SIZE').AsInteger);
        qWCode.ParamByName('UN_CODE').AsString :=
          qRCode.FieldByName('UN_SM').AsString;
        qWCode.ParamByName('IS_ENABLE').AsSmallInt :=
          qRCode.FieldByName('IS_ENABLE').AsInteger;
        try
          qWCode.Execute;
        except
        end;
      end
      else
      begin
        // если этот размер есть - обновим разрешения
        qUCode.Active := False;
        qUCode.Prepare;
        qUCode.ParamByName('NO_MST').AsInteger := I;
        qUCode.ParamByName('IS_ENABLE').AsSmallInt :=
          qRCode.FieldByName('IS_ENABLE').AsInteger;
        qUCode.Execute;
      end;
      qRCode.Next;
      lbInfo.Text:='Обновляем код № '+K.ToString+' из '+J.ToString;
      Inc(K);
      Application.ProcessMessages;
    until (qRCode.Eof);
    fmMain.IBT.Commit;
  end;
end;

procedure TfmSync.CopyEnableType;
begin
  fmMain.StartMainTransaction;
  qTEnable.Close;
  qTEnable.Prepare;
  qTEnable.Active := true;
  if qTEnable.RecordCount > 0 then
  begin
    qTEnable.First;
    repeat
      qInsType.Active := False;
      qInsType.Prepare;
      qInsType.ParamByName('BAR_CODE').AsString :=
        qTEnable.FieldByName('BAR_CODE').AsString;
      qInsType.ParamByName('NO_SIZE').AsInteger :=
        qTEnable.FieldByName('NO_SIZE').AsInteger;
      qInsType.Execute;
      qTEnable.Next;
    until (qTEnable.Eof);
    fmMain.IBT.Commit;
  end;
end;

procedure TfmSync.CopyKat;
begin
  if fmMain.IBT.Active then
  begin
    fmMain.IBT.Commit;
    Application.ProcessMessages;
  end;
  fmMain.IBT.StartTransaction;
  qRKat.Close;
  qRKat.Prepare;
  qRKat.Active := true;
  if qRKat.RecordCount > 0 then
  begin
    qRKat.First;
    repeat
      if GetKatByUIN(qRKat.FieldByName('UIN_KAT').AsString) = -1 then
      begin
        if GetKatByName(qRKat.FieldByName('NAZVAN').AsString) = -1 then
        begin
          // если не нашли не по имени не по коду, то категория новая
          qWKat.Close;
          qWKat.Prepare;
          qWKat.ParamByName('NAZVAN').AsString := qRKat.FieldByName('NAZVAN').AsString;
          qWKat.ParamByName('SUM_SKID').AsFloat := qRKat.FieldByName('SUM_SKID').AsFloat;
          qWKat.ParamByName('UIN_KAT').AsString := qRKat.FieldByName('UIN_KAT').AsString;
          qWKat.ParamByName('NO_TYPE').AsInteger := GetNoTypeByCode(qRKat.FieldByName('BAR_CODE').AsString);
          qWKat.Execute;
        end
        else
        begin
          // категория есть, кода нет - обновляем код
          qUpdKat2.Active := False;
          qUpdKat2.Prepare;
          qUpdKat2.ParamByName('NO_KAT').AsInteger := GetKatByName(qRKat.FieldByName('NAZVAN').AsString);
          qUpdKat2.ParamByName('UIN_KAT').AsString := qRKat.FieldByName('UIN_KAT').AsString;
          qUpdKat2.ParamByName('NO_TYPE').AsInteger := GetNoTypeByCode(qRKat.FieldByName('BAR_CODE').AsString);
          qUpdKat2.Execute;
        end;
      end
      else
      begin
        if GetKatByName(qRKat.FieldByName('NAZVAN').AsString) = -1 then
        begin
          // код есть имени нет - меняем имя
          qUpdKat3.Active := False;
          qUpdKat3.Prepare;
          qUpdKat3.ParamByName('NAZVAN').AsString := qRKat.FieldByName('NAZVAN').AsString;
          qUpdKat3.ParamByName('NO_KAT').AsInteger := GetKatByUIN(qRKat.FieldByName('UIN_KAT').AsString);
          qUpdKat3.ParamByName('NO_TYPE').AsInteger := GetNoTypeByCode(qRKat.FieldByName('BAR_CODE').AsString);
          qUpdKat3.Execute;
        end
        else
        begin
          // есть и имя и код - обновляем тип
          qUpdKat4.Active := False;
          qUpdKat4.Prepare;
          qUpdKat4.ParamByName('NO_TYPE').AsInteger := GetNoTypeByCode(qRKat.FieldByName('BAR_CODE').AsString);
          qUpdKat4.ParamByName('NO_KAT').AsInteger := GetKatByUIN(qRKat.FieldByName('UIN_KAT').AsString);
          qUpdKat4.Execute;
        end;
      end;
      qRKat.Next;
      Application.ProcessMessages;
    until qRKat.Eof;
    fmMain.IBT.Commit;
  end;
end;

procedure TfmSync.CopyMod;
const
  qsStd = 'update MODEL_TABLE' + #13#10 + 'set IS_DEL = :IS_DEL,' + #13#10 + '    BARCODE = :BARCODE,' + #13#10 + '    M_CENA = :M_CENA' + #13#10 + 'where ((NAZVAN = :NAZVAN) and' + #13#10 + '      (NO_KAT = :NO_KAT))  ';
  qsIgn = 'update MODEL_TABLE' + #13#10 + 'set IS_DEL = :IS_DEL,' + #13#10 + '    BARCODE = :BARCODE ' + #13#10 + 'where ((NAZVAN = :NAZVAN) and' + #13#10 + '      (NO_KAT = :NO_KAT))  ';
var
  I, J: Integer;
begin
  fmMain.StartMainTransaction;
  // 10.10.2013 Этап первый. Проверяем Barcode моделей и корректируем имя
  qRMod.Close;
  qRMod.Prepare;
  qRMod.Active := true;
  if qRMod.RecordCount > 0 then
  begin
    qUMod.Active := False; // 02.04.2014 если поставили опцию игнорировать цены,
    qUMod.SQL.Text := qsStd; // то меняем запрос на тот, который без цены.
    if cbIgn.IsChecked then // иначе цена будет нулевая.
    begin
      qUMod.SQL.Text := qsIgn;
    end;
    qRMod.First;
    repeat
      if GetNoModFromBarcode(qRMod.FieldByName('barcode').AsString) > -1 then
      begin
        var N: Integer;
        N := GetKatByName(qRMod.FieldByName('K_NAME').AsString);
        // 18,03,2026 модель можно прицепить к категории материалы, защита от дурака
        if N <> -1 then
        begin
          qUMod2.ParamByName('NK').AsInteger := N;
          qUMod2.ParamByName('NAZVAN').AsString := qRMod.FieldByName('M_Name').AsString;
          qUMod2.ParamByName('NO_MOD').AsInteger := GetNoModFromBarcode(qRMod.FieldByName('barcode').AsString);
          qUMod2.Execute;
        end;
      end;
      Application.ProcessMessages;
      qRMod.Next;
    until qRMod.Eof;
    fmMain.IBT.Commit;
  end; // if qRMod.RecordCount > 0
  // проверяем № модели и категории, если категория меняется, то переносим
  // Старая часть. Считается, что название модели не меняется
  Application.ProcessMessages;
  fmMain.IBT.StartTransaction;
  qRMod.Close;
  qRMod.Prepare;
  qRMod.Active := true;
  J := 0;
  I := qRMod.RecordCount;
  if I > 0 then
  begin
    qRMod.First;
    repeat
      inc(J);
      lbInfo.Text := 'Обновление модели № ' + IntToStr(J) + ' из ' + IntToStr(I);
      Application.ProcessMessages;
      if GetModByName(qRMod.FieldByName('M_NAME').AsString, qRMod.FieldByName('K_NAME').AsString) = -1 then // новая модель
      begin
        if qRMod.FieldByName('IS_DEL').AsInteger = 0 then
        // удаленные модели не читаем
        begin
          qWMod.Prepare;
          qWMod.ParamByName('NAZVAN').AsString := qRMod.FieldByName('M_Name').AsString;
          qWMod.ParamByName('BARCODE').AsString := qRMod.FieldByName('BARCODE').AsString;
          qWMod.ParamByName('NO_KAT').AsInteger := GetKatByName(qRMod.FieldByName('K_NAME').AsString);
          // в новой цена копируется по любому.....
          qWMod.ParamByName('M_CENA').AsFloat := qRMod.FieldByName('M_CENA').AsFloat;
          qWMod.ParamByName('IS_DEL').AsInteger := qRMod.FieldByName('IS_DEL').AsInteger;
          qWMod.Execute;
        end; // if qRMod.FieldByName('IS_DEL').AsInteger=0
      end
      else // -1
      begin // Старая модель
        qUMod.ParamByName('NAZVAN').AsString := qRMod.FieldByName('M_Name').AsString;
        qUMod.ParamByName('NO_KAT').AsInteger := GetKatByName(qRMod.FieldByName('K_NAME').AsString);
        qUMod.ParamByName('IS_DEL').AsInteger := qRMod.FieldByName('IS_DEL').AsInteger;
        if not cbIgn.isChecked then // а тут проверяем нужно ли копировать цену.
        begin
          qUMod.ParamByName('M_CENA').AsFloat := qRMod.FieldByName('M_CENA').AsFloat;
        end;
        qUMod.ParamByName('barcode').AsString := qRMod.FieldByName('barcode').AsString;
        qUMod.Execute;
      end;
      qRMod.Next;
    until (qRMod.Eof);
    fmMain.IBT.Commit;
  end;
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
      qTSity.ParamByName('STN').AsString := qRSity.FieldByName('bar_code').AsString;
      qTSity.Active := true;
      if qTSity.FieldByName('NO_ST').IsNull then
      begin
        qWSity.Close;
        qWSity.Prepare;
        qWSity.ParamByName('st_name').AsString := qRSity.FieldByName('st_name').AsString;
        qWSity.ParamByName('IS_DEL').AsInteger := qRSity.FieldByName('IS_DEL').AsInteger;
        qWSity.ParamByName('IS_STAR').AsInteger := qRSity.FieldByName('IS_STAR').AsInteger;
        qWSity.ParamByName('BAR_CODE').AsString := qRSity.FieldByName('BAR_CODE').AsString;
        qWSity.Execute;
      end;
      // ВСТАВЛЯЕМ ГОРОД
      qRSity.Next;
      Application.ProcessMessages;
    until (qRSity.Eof);
    fmMain.IBT.Commit;
  end;
end;

procedure TfmSync.CopySize;
begin
  fmMain.StartMainTransaction;
  qRSize.Close;
  qRSize.Prepare;
  qRSize.Active := true;
  if qRSize.RecordCount > 0 then
  begin
    qRSize.First;
    repeat
      if GetSize(qRSize.FieldByName('NO_SIZE').AsInteger) = -1 then
      begin
        qWSize.Active := False;
        qWSize.Prepare;
        qWSize.ParamByName('NO_SIZE').AsInteger := qRSize.FieldByName('NO_SIZE')
          .AsInteger;
        qWSize.Execute;
      end;
      qRSize.Next;
    until (qRSize.Eof);
    fmMain.IBT.Commit;
  end;
end;

procedure TfmSync.CopyType;
begin
  if fmMain.IBT.Active then
  begin
    fmMain.IBT.Commit;
    Application.ProcessMessages;
  end;
  fmMain.IBT.StartTransaction;
  qRType.Close;
  qRType.Prepare;
  qRType.Active := true;
  if qRType.RecordCount > 0 then
  begin
    qRType.First;
    repeat
      if GetNoTypeByCode(qRType.FieldByName('BAR_CODE').AsString) = -1 then
      begin
        qWType.Active := False;
        qWType.Prepare;
        qWType.ParamByName('NAME_TYPE').AsString := qRType.FieldByName('NAME_TYPE').AsString;
        qWType.ParamByName('CODE_TYPE').AsString := qRType.FieldByName('BAR_CODE').AsString;
        qWType.Execute;
      end;
      qRType.Next;
    until (qRType.Eof);
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
        qWVal.ParamByName('nzv').AsString := qRVal.FieldByName('NAZVAN').AsString;
        qWVal.Execute;
      end;
      qRVal.Next;
    until (qRVal.Eof);
    fmMain.IBT.Commit;
  end;
end;

procedure TfmSync.CopyZakaz;
var
  Zak_Code: String;
  MyDate: TDate;
begin
  MyDate := IncDay(Date, 60);
  qExpZak.Close;
  qExpZak.Prepare;
  qExpZak.Active := true;
  if qExpZak.RecordCount > 0 then
  begin
    qExpZak.First;
    repeat
      Zak_Code := qExpZak.FieldByName('BAR_CODE').AsString;
      if not isIgnoreZakaz(Zak_Code) then
      begin
        qInsZak.Active := False;
        qInsZak.Prepare;
        qInsZak.ParamByName('CODE_ZAK').AsString := Zak_Code;
        qInsZak.ParamByName('CODE_AGN').AsString :=
          qExpZak.FieldByName('AGENT_CODE').AsString;
        qInsZak.ParamByName('CNT_MOD').AsFloat :=
          qExpZak.FieldByName('CNT_MOD').AsFloat;
        qInsZak.ParamByName('DATA_END').AsDate := MyDate;
        qInsZak.ParamByName('IS_MOVE').AsInteger := 0;
        qInsZak.Execute;
        fmMain.IBT.Commit;
        Application.ProcessMessages;
        // ----------------------------------------------------------
        // Пишем список моделей с заказом
        // ----------------------------------------------------------
        CopyZakDetail(Zak_Code);
      end;
      qExpZak.Next;
    until (qExpZak.Eof);
  end;
end;

procedure TfmSync.CopyZakDetail(CodeZakaza: String);
begin
  fmMain.StartMainTransaction;
  qExpZalList.Close;
  qExpZalList.Prepare;
  qExpZalList.ParamByName('NZ').AsString := CodeZakaza;
  qExpZalList.Active := true;
  if qExpZalList.RecordCount > 0 then
  begin
    repeat
      qInsDetZak.Active := False;
      qInsDetZak.Prepare;
      qInsDetZak.ParamByName('CODE_ZAK').AsString :=
        qExpZalList.FieldByName('BAR_CODE').AsString;
      qInsDetZak.ParamByName('CODE_MOD').AsString :=
        qExpZalList.FieldByName('UN_SM').AsString;
      qInsDetZak.ParamByName('CNT_MOD').AsFloat :=
        qExpZalList.FieldByName('CNT_MOD_SIZE').AsFloat;
      qInsDetZak.Execute;
      qExpZalList.Next;
    until (qExpZalList.Eof);
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
  qDelOldZak.Active := False;
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
  ibc_Read.Connected := True;
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
  CopyType;
  lbInfo.Text := 'Читаем категории';
  Application.ProcessMessages;
  CopyKat;
  lbInfo.Text := 'Читаем модели';
  Application.ProcessMessages;
  CopyMod;
  lbInfo.Text := 'Читаем размеры';
  Application.ProcessMessages;
  CopySize;
  lbInfo.Text := 'Читаем разрешенные размеры';
  Application.ProcessMessages;
  CopyEnableType;
  lbInfo.Text := 'Читаем коды';
  Application.ProcessMessages;
  CopyCode;
  lbInfo.Text := 'Читаем заказы';
  Application.ProcessMessages;
  CopyZakaz;
  lbInfo.Text := 'Обновляем склад';
  Application.ProcessMessages;
 // fmMain.UpdateSclad;
  // -----------------------------------
  lbInfo.Text := '';
  Application.ProcessMessages;
  ModalResult := mrOk;
end;

end.

