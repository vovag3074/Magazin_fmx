unit frmOplata;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCButton, FMX.Edit,
  FMX.ListBox, System.ImageList, FMX.ImgList, FMX.SVGIconImageList,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.TMSFNCEdit, FMX.TMSFNCTypes,
  FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.TMSFNCHTMLText;

type
  TfmOpl = class(TForm)
    Panel1: TPanel;
    mSum: TPanel;
    TMSFNCButton1: TTMSFNCButton;
    eSum: TLabel;
    ePred: TEdit;
    eVal: TComboBox;
    eOpl: TEdit;
    TMSFNCButton6: TTMSFNCButton;
    eType: TComboBox;
    SVGIconImageList2: TSVGIconImageList;
    eCurs: TEdit;
    TMSFNCButton2: TTMSFNCButton;
    eDop: TMemo;
    dxRet: TTMSFNCButton;
    btOK: TTMSFNCButton;
    btBank: TTMSFNCButton;
    EditButton1: TEditButton;
    qRead: TFDQuery;
    qClose: TFDCommand;
    qPred: TFDCommand;
    qStrPred: TFDCommand;
    qOpl: TFDCommand;
    qDop: TFDCommand;
    lbInfo: TTMSFNCHTMLText;
    qGetPred_t: TFDQuery;
    qGetPred2_t: TFDQuery;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    qGetPred: TFDStoredProc;
    qGetPredSUM_FROM_PRED: TFloatField;
    qGetPred2: TFDStoredProc;
    qGetPred2SUM_FROM_PRED: TFloatField;
    procedure TMSFNCButton6Click(Sender: TObject);
    procedure TMSFNCButton2Click(Sender: TObject);
    procedure btBankClick(Sender: TObject);
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure EditButton1Click(Sender: TObject);
    procedure eOplChangeTracking(Sender: TObject);
  private
    { Private declarations }
    procedure readValutList;
    procedure setOplata(isNewTransaction: Boolean = false);
  public
    { Public declarations }
    FAgent: Integer;
    FDolg: Double;
    FTemp: Integer;
    FData: tDate;
    FPred: Double;
    FBankPred: Double; // 02.07.2019 разделил банковскую и наличную предоплату
    FValut: Integer; // 23,03,2019 добавили валюту покупателя по умодчанию
    isPred: Integer; // если предоплата = 1
    FTranID: string;
    procedure ReadAgent(NoAgent: Integer; isTemp: Integer; MyData: tDate);
  end;

var
  fmOpl: TfmOpl;

implementation

uses
  frmMain, frmCalc, frmInfoOplata, frmReport, frmPredopByCeh;

{$R *.fmx}

{ TfmOpl }

procedure TfmOpl.btBankClick(Sender: TObject);
begin
  if btBank.IsPressed then
  begin
    ePred.Text := FloatToStr(FBankPred);
    ePred.Enabled := FBankPred > 0;
  end
  else
  begin
    ePred.Text := FloatToStr(FPred);
    ePred.Enabled := FPred > 0;
  end;
end;

procedure TfmOpl.btOKClick(Sender: TObject);
var
  S: string;
  FTmp: Double;
  FVSum: Double;
  FOst: Double;
begin
  if eOpl.Text = '' then
  begin
    eOpl.Text := '0';
  end;
   //--------------------------------------
   // 31-avg-2022 предварительный осмотр оплаты
   //--------------------------------------
  if eType.ItemIndex = 0 then  // учитываем прямой или обратный курс
  begin
    FVSum := eOpl.Text.ToDouble * eCurs.Text.ToDouble;
  end
  else
  begin
    FVSum := eOpl.Text.ToDouble / eCurs.Text.ToDouble;
  end;
  FVSum := Round(FVSum);
  FTmp := FVSum - FDolg;
  if FTmp < 0 then
    FTmp := 0;
  FOst := FDolg - FVSum;
  if FOst < 0 then
    FOst := 0;

  if not ShowInfoOplEx('', FDolg, FOst, eOpl.Text.ToDouble, FVSum, FTmp) then
    Exit;
  //---------------------------------------
  // 04-dec-2019 при нажатии на ok - тутже блокируем ее.
  // иногда наблюдается двойное срабатывание
  //---------------------------------------
  btOK.Enabled := False;
  // ------------------------------------------
  // 02-jul-2019 добавил разделение по наличной и безналичной предоплате
  // ------------------------------------------
  btBank.IsPressed := false; // при наличной оплате кнопка поднята
  // --------------------------------------
  // 27-jan-2015 добавили № транзакции
  // -------------------------------------
  FTranID := fmMain.GetTranID;
  // -------------------------------------------
  // 12-jan-2015 перенес закрытие продажи сюда
  // --------------------------------------------
  fmMain.StartMainTransaction;
  qClose.Active := false;
  qClose.Prepare;
  qClose.Execute;
  fmMain.IBT.Commit;
  Application.ProcessMessages;
  // -----------------------------------------
  if eOpl.Text.ToDouble > 0 then
  begin
    if eType.ItemIndex = 0 then  // учитываем прямой или обратный курс
    begin
      FVSum := eOpl.Text.ToDouble * eCurs.Text.ToDouble;
    end
    else
    begin
      FVSum := eOpl.Text.ToDouble / eCurs.Text.ToDouble;
    end;
    FVSum := Round(FVSum); // округляем
    if FVSum > FDolg then
    begin
      // Сумма внесена большаая чем нужно
      FTmp := FVSum - FDolg;
      eOpl.Text := FDolg.ToString;
      if ShowQuestion('Сумма больше долга на  ' + FloatToStr(FTmp) + ' ' + 'Добавить эту сумму в предоплату?') then
      begin
        // Восстанавливаем сумму в исходной валюте
        if eType.ItemIndex = 0 then
        begin
          FTmp := round(FTmp / eCurs.Text.ToDouble);
          eOpl.Text := FloatToStr(round(eOpl.Text.ToDouble / eCurs.Text.ToDouble));
        end
        else
        begin
          FTmp := round(FTmp * eCurs.Text.ToDouble);
          eOpl.Text := FloatToStr(round(eOpl.Text.ToDouble * eCurs.Text.ToDouble));
        end;
        try
          fmMain.StartMainTransaction;
          qPred.Active := false;
          qPred.Prepare;
          qPred.ParamByName('NG').AsInteger := FAgent;
          qPred.ParamByName('SUM_PRED').Value := FTmp;
          qPred.ParamByName('DATA_PRED').AsDate := FData;
          qPred.ParamByName('STR_PRED').AsString := '';
          qPred.ParamByName('IS_VIRT').AsSmallInt := 0;
          qPred.ParamByName('NO_VAL').AsInteger := eVal.ListItems[eVal.ItemIndex].Tag;
          qPred.ParamByName('KURS_VAL').Value := eCurs.Text.ToDouble;
          qPred.ParamByName('TRAN_ID').AsString := FTranID;
          qPred.ParamByName('IS_Mult').AsBoolean := eType.ItemIndex = 0;
          qPred.Execute;
          fmMain.IBT.Commit;
          Application.ProcessMessages;
        except
          on E: Exception do
          begin
            ShowError(E.Message);
          end;
        end;
        S := SetPredByCeh(FTmp {* eCurs.EditValue}, FAgent, FData);
//        // надо записать строку в получение
        Application.ProcessMessages;
        qStrPred.Close;
        qStrPred.Prepare;
        qStrPred.ParamByName('POL_PRED').AsString := S;
        qStrPred.ParamByName('NG').AsInteger := FAgent;
        qStrPred.ParamByName('DP').AsDate := FData;
        qStrPred.Execute;
        fmMain.IBT.Commit;
      end;
    end;
    SetOplata;
  end // if eOpl.EditValue > 0 then
  else
  begin
//    // 15.12.2014 если оплаты нет, но доп строка есть, то
//    // записываем ее в журнал
    try
      if trim(eDop.Text) <> '' then
      begin
        fmMain.StartMainTransaction;
        qDop.Active := false;
        qDop.Prepare;
        qDop.ParamByName('NO_AGN').AsInteger := FAgent;
        qDop.ParamByName('DATA_OTP').AsDate := FData;
        qDop.ParamByName('DOP_OPIS').AsString := trim(eDop.Text);
        qDop.Execute;
        fmMain.EndMainTransaction;
      end;
    except
      on e: Exception do
      begin
        fmMain.ShowIBError(e.message);
      end;

    end;
  end;
  if ShowQuestion('Чек нужен?') then
  begin
    S := '[{"NG":"' + IntToStr(FAgent) + '"';
    S := S + ',"DT":"' + DateToStr(FData) + '"}]';
    PrintReportJson('SRepProdAgn.fr3', S);
  end;
  ModalResult := mrOk;
end;

procedure TfmOpl.EditButton1Click(Sender: TObject);
begin
  EditButton1.Enabled := False;
  FTranID := fmMain.GetTranID;
  // -------------------------------------------
  // 10-feb-2015 перенес закрытие продажи сюда
  // --------------------------------------------
  fmMain.StartMainTransaction;
  qClose.Close;
  qClose.Prepare;
  qClose.Execute;
  fmMain.IBT.Commit;
  // -------------------------------------------
  isPred := 1;
  fmMain.StartMainTransaction;
  if btBank.IsPressed then
  begin
    try
      if FBankPred > FDolg then
        FBankPred := FDolg;
      // костыль, чтобы не списывалась предоплата дважды
      qGetPred2.Close;
      qGetPred2.Prepare;
      qGetPred2.ParamByName('NO_AGENT').AsInteger := FAgent;
      qGetPred2.ParamByName('IN_SUM_PRED').Value := FBankPred;
      qGetPred2.Active := True;
      eOpl.Text := qGetPred2.FieldByName('SUM_FROM_PRED').AsFloat.toString;
      qGetPred2.Close;
    except
      on E: Exception do
      begin
        fmMain.ShowIBError(E.Message);
        fmMain.IBT.Rollback;
      end;
    end;
  end
  else
  begin
    try
      if FPred > FDolg then
        FPred := FDolg;
      // костыль, чтобы не списывалась предоплата дважды
      qGetPred.Close;
      qGetPred.Prepare;
      qGetPred.ParamByName('NO_AGENT').AsInteger := FAgent;
      qGetPred.ParamByName('IN_SUM_PRED').Value := FPred;
      qGetPred.Active := True;
      eOpl.Text := qGetPred.FieldByName('SUM_FROM_PRED').AsFloat.ToString;
      qGetPred.Close;
    except
      on E: Exception do
      begin
        fmMain.ShowIBError(E.Message);
        fmMain.IBT.Rollback;
      end;
    end;
  end;
//  fmMain.EndMainTransaction;
  SetOplata(false);
  ModalResult := mrOk;
end;

procedure TfmOpl.eOplChangeTracking(Sender: TObject);
begin
  fmMain.onEditChangeTracking(Sender);
end;

procedure TfmOpl.ReadAgent(NoAgent, isTemp: Integer; MyData: tDate);
begin
  FAgent := NoAgent;
  FTemp := isTemp;
  FData := MyData;
  isPred := 0; // по умолчанию - реальная оплата
  btBank.IsPressed := false;
  readValutList;
  fmMain.StartReadTransaction;
  qRead.Close;
  qRead.Prepare;
  qRead.ParamByName('NG').AsInteger := FAgent;
  qRead.Active := True;
  FDolg := qRead.FieldByName('AG_DOLG').AsFloat;
  eSum.Text := FloatToStr(FDolg);
  FPred := qRead.FieldByName('AG_PRED').AsFloat;
  FBankPred := qRead.FieldByName('AG_BANK_PRED').AsFloat;
  if btBank.IsPressed then
  begin
    ePred.Text := FloatToStr(FBankPred);
    ePred.Enabled := FBankPred > 0;
  end
  else
  begin
    ePred.Text := FloatToStr(FPred);
    ePred.Enabled := FPred > 0;
  end;
  FValut := qRead.FieldByName('PRED_VAL').AsInteger;
  fmMain.GetValutFromComboBox(FValut, eVal);
  qRead.Close;
  lbInfo.Text := 'Предоплаты <br> Наличными: <b>' + FPred.ToString + '</b><br> По банку: <b>' + FBankPred.ToString + '</b>';
  fmMain.EndReadTransaction;
end;

procedure TfmOpl.readValutList;
var
  Item: TListBoxItem;
begin
  for var Pair in DistValut do
  begin
    Item := TListBoxItem.Create(eVal);
    Item.Text := Pair.Value;
    Item.Tag := Pair.Key;
    Item.ImageIndex := 0;
    eVal.AddObject(Item);
  end;
  eVal.ItemIndex := 0;
end;

procedure TfmOpl.setOplata(isNewTransaction: Boolean = false);
begin
  try
    if isNewTransaction then
    begin
      fmMain.StartMainTransaction;
    end;
    qOpl.Active := false;
    qOpl.Prepare;
    qOpl.ParamByName('NG').AsInteger := FAgent;
    qOpl.ParamByName('IT').AsSmallInt := FTemp;
    qOpl.ParamByName('SUM_OP').Value := eOpl.Text.ToDouble;
    qOpl.ParamByName('DOP_OP').AsString := eDop.Text;
    qOpl.ParamByName('MY_DATA').AsDate := FData;
    qOpl.ParamByName('is_virt').AsSmallInt := 0;
    if btBank.IsPressed then
      qOpl.ParamByName('is_virt').AsSmallInt := 1;
    qOpl.ParamByName('is_pred').AsSmallInt := isPred;
    qOpl.ParamByName('TRAN_ID').AsString := FTranID;
    qOpl.ParamByName('NO_VAL').asInteger := eVal.ListItems[eVal.ItemIndex].Tag;
    qOpl.ParamByName('KURS_VAL').Value := eCurs.Text.ToDouble;
    qOpl.ParamByName('IS_MULT').AsBoolean := eType.ItemIndex = 0;
    qOpl.Execute;
    fmMain.EndMainTransaction;
  except
    on E: Exception do
    begin
      fmMain.ShowIBError('Oplata error: ' + E.Message);
    end;

  end;
end;

procedure TfmOpl.TMSFNCButton1Click(Sender: TObject);
begin
  eOpl.Text := eSum.Text;
end;

procedure TfmOpl.TMSFNCButton2Click(Sender: TObject);
begin
  showCalc(eCurs);
end;

procedure TfmOpl.TMSFNCButton6Click(Sender: TObject);
begin
  if eOpl.Text.Trim = '' then
    eOpl.Text := '0';
  showCalc(eOpl);
end;

end.

