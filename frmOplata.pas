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
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfmOpl = class(TForm)
    Panel1: TPanel;
    зSum: TPanel;
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
    procedure TMSFNCButton6Click(Sender: TObject);
    procedure TMSFNCButton2Click(Sender: TObject);
    procedure btBankClick(Sender: TObject);
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure readValutList;
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
  frmMain, frmCalc, frmInfoOplata, frmReport;

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
        fmMain.StartMainTransaction;
        qPred.Active := false;
        qPred.Prepare;
        qPred.ParamByName('NG').AsInteger := FAgent;
        qPred.ParamByName('SUM_PRED').AsFloat := FTmp;
        qPred.ParamByName('DATA_PRED').AsDate := FData;
        qPred.ParamByName('STR_PRED').AsString := '';
        qPred.ParamByName('IS_VIRT').AsInteger := 0;
        qPred.ParamByName('NO_VAL').AsInteger := eVal.Text.ToInteger;
        qPred.ParamByName('KURS_VAL').asFloat := eCurs.Text.ToDouble;
        qPred.ParamByName('TRAN_ID').AsString := FTranID;
        qPred.ParamByName('IS_Mult').AsBoolean := eType.ItemIndex = 0;
        qPred.Execute;
        fmMain.IBT.Commit;
        Application.ProcessMessages;
//        S := SetPredByCeh(FTmp {* eCurs.EditValue}, FAgent, FData);
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
//    SetOplata;
//    fmMain.IBT.Commit;
//  end // if eOpl.EditValue > 0 then
//  else
//  begin
//    // 15.12.2014 если оплаты нет, но доп строка есть, то
//    // записываем ее в журнал
//    eDop.PostEditValue;
//    if trim(eDop.Text) <> '' then
//    begin
//      qDop.Active := false;
//      qDop.Prepare;
//      qDop.ParamByName('NO_AGN').AsInteger := FAgent;
//      qDop.ParamByName('DATA_OTP').AsDate := FData;
//      qDop.ParamByName('DOP_OPIS').AsString := trim(eDop.Text);
//      qDop.Execute;
//      fmMain.IBT.Commit;
//    end;
//  end;
//  if isPrintCheck then
//  begin
    if ShowQuestion('Чек нужен?') then
    begin
      S := '[{"NG"="' + IntToStr(FAgent) + '"';
      S := S + ',"DT"="' + DateToStr(FData) + '"}]';
      PrintReportJson('SRepProdAgn.fr3', S);
    end;
  end;
  ModalResult := mrOk;
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
  showCalc(eOpl);
end;

end.

