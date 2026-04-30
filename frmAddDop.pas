unit frmAddDop;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCButton, FMX.Objects,
  FMX.Edit, FMX.DateTimeCtrls, FMX.ListBox, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.ImageList,
  FMX.ImgList, FMX.SVGIconImageList, FMX.Calendar.Helpers,
  FMX.CalendarHolidayDays.Style, System.Rtti;

type
  TfmAddDop = class(TForm)
    Rectangle1: TRectangle;
    TMSFNCButton1: TTMSFNCButton;
    eDolg: TLabel;
    eAgn: TEdit;
    TMSFNCButton2: TTMSFNCButton;
    Label2: TLabel;
    eDate: TDateEdit;
    Label3: TLabel;
    eSum: TEdit;
    Label4: TLabel;
    TMSFNCButton3: TTMSFNCButton;
    eBank: TEdit;
    TMSFNCButton4: TTMSFNCButton;
    Label5: TLabel;
    ePol: TEdit;
    TMSFNCButton5: TTMSFNCButton;
    Label6: TLabel;
    eDop: TEdit;
    Label7: TLabel;
    eVal: TComboBox;
    eType: TComboBox;
    eCurs: TEdit;
    TMSFNCButton6: TTMSFNCButton;
    qVal: TFDQuery;
    SVGIconImageList1: TSVGIconImageList;
    Panel1: TPanel;
    qRead: TFDQuery;
    Z: TGroupBox;
    eDPol: TDateEdit;
    Label1: TLabel;
    btOK: TTMSFNCButton;
    TMSFNCButton7: TTMSFNCButton;
    qPred: TFDCommand;
    qIns: TFDCommand;
    qAdd: TFDCommand;
    TMSFNCButton8: TTMSFNCButton;
    procedure TMSFNCButton3Click(Sender: TObject);
    procedure TMSFNCButton6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCButton2Click(Sender: TObject);
    procedure TMSFNCButton4Click(Sender: TObject);
    procedure TMSFNCButton5Click(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure TMSFNCButton8Click(Sender: TObject);
  private
    { Private declarations }
    FAgent: Integer;
    FDolg: Double;
    isEdit: Boolean;
    FKey: NativeInt;
    FTR_ID: string;
    FValut: Integer;
    function SaveDop: Boolean;
    procedure ReadUserVal;
    procedure ShowDolg;
  public
    { Public declarations }
  end;

var
  fmAddDop: TfmAddDop;

implementation

uses
  frmMain, frmCalc, frmSelectAgent, frmSelectBankAttribyte, frmInfoOplata;

{$R *.fmx}

procedure TfmAddDop.btOKClick(Sender: TObject);
begin
  if SaveDop then
    ModalResult := mrOk;
end;

procedure TfmAddDop.FormCreate(Sender: TObject);
begin
  ReadUserVal;
end;

procedure TfmAddDop.ReadUserVal;
var
  MyVal: TListBoxItem;
begin
  eVal.Items.Clear;
  qVal.Close;
  qVal.Prepare;
  qVal.Active := True;
  if qVal.RecordCount > 0 then
  begin
    qVal.First;
    repeat
      MyVal := TListBoxItem.Create(eVal);
      MyVal.Height := 36;
      MyVal.Tag := qVal.FieldByName('NO_VAL').AsInteger;
      MyVal.Text := qVal.FieldByName('NAZVAN').AsString;
      MyVal.ImageIndex := 0;
      eVal.AddObject(MyVal);
      qVal.Next;
    until qVal.Eof;
    qVal.Close;
  end;
  eVal.ItemIndex := 0;
end;

function TfmAddDop.SaveDop: Boolean;
var
  FTmp: Double;
  VTmp: Double; // с учетом курса
  FVSum: Double; // сумма с курсом
  FOst: Double;
begin
  Result := false;
  // -----03.08.2022 --- добавляем валюту -------------
  // ----- 17.01.2014 --- добавил id транзакции--------
  FTR_ID := fmMain.GetTranID;
  // ---------------------------------------------------
  if FAgent = -1 then
  begin
    ShowError('Выберите агента');
    eAgn.SetFocus;
    Exit;
  end;
  if eSum.Text.ToDouble <= 0 then
  begin
    ShowError('Укажите сумму отправки');
    eSum.SetFocus;
    Exit;
  end;
  if trim(eBank.Text) = '' then
  begin
    ShowError('Укажите банк');
    eBank.SetFocus;
    Exit;
  end;
  if trim(ePol.Text) = '' then
  begin
    ShowError('Укажите получателя');
    ePol.SetFocus;
    Exit;
  end;
  if isEdit then
  begin

  end
  else
  begin
   //--------------------------------------
   // 31-avg-2022 предварительный осмотр оплаты
   //--------------------------------------
    if eType.ItemIndex = 0 then  // учитываем прямой или обратный курс
    begin
      FVSum := eSum.Text.ToDouble * eCurs.Text.ToDouble;
    end
    else
    begin
      FVSum := eSum.Text.ToDouble / eCurs.Text.ToDouble;
    end;
    FVSum := Round(FVSum);
    FTmp := FVSum - FDolg;
    if FTmp < 0 then
      FTmp := 0;
    FOst := FDolg - FVSum;
    if FOst < 0 then
      FOst := 0;

    if not ShowInfoOplEx('', FDolg, FOst, eSum.Text.ToDouble, FVSum, FTmp) then
      Exit;
      //===================================================================

    if eType.ItemIndex = 0 then
    begin
      FVSum := Round((eSum.Text.ToDouble * eCurs.Text.ToDouble));
    end
    else
    begin
      FVSum := Round((eSum.Text.ToDouble / eCurs.Text.ToDouble));
    end;
    if FDolg < FVSum then
    begin
       // Сумма внесена большаая чем нужно
      FTmp := (eSum.Text.ToDouble) - FDolg;
      VTmp := FVSum - FDolg;
      if eType.ItemIndex = 0 then
      begin
        eSum.Text := Round((FDolg / eCurs.Text.ToDouble)).ToString;
      end
      else
      begin
        eSum.Text := Round((FDolg * eCurs.Text.ToDouble)).ToString;
      end;
      if ShowQuestion('Сумма больше долга на ' + FloatToStr(VTmp) + ' Добавить эту сумму в предоплату?') then
      begin
        qPred.Active := false;
        qPred.Prepare;
        qPred.ParamByName('NG').AsInteger := FAgent;
        qPred.ParamByName('SUM_PRED').Value := VTmp;
        qPred.ParamByName('DATA_PRED').AsDate := eDate.Date;
        qPred.ParamByName('STR_PRED').AsString := ePol.Text;
        qPred.ParamByName('IS_VIRT').AsSmallInt := 1; // Деньги виртуальные
        qPred.ParamByName('TRAN_ID').AsString := FTR_ID;
        qPred.Execute;
        fmMain.IBT.Commit;
        Application.ProcessMessages;
      end;
    end;
    qAdd.Active := false;
    qAdd.Prepare;
    qAdd.ParamByName('NO_AGN').AsInteger := FAgent;
    qAdd.ParamByName('DATA_POL').AsDate := eDate.Date;
    qAdd.ParamByName('SUM_OPL').Value := eSum.Text.ToDouble;
    qAdd.ParamByName('NO_VAL').AsInteger := eVal.ListItems[eVal.ItemIndex].Tag;
    qAdd.ParamByName('KURS_VAL').Value := eCurs.Text.ToDouble;
    qAdd.ParamByName('VSUM_OPL').Value := eSum.Text.ToDouble;
    qAdd.ParamByName('MY_BANK').AsString := eBank.Text;
    qAdd.ParamByName('MY_USER').AsString := ePol.Text;
    qAdd.ParamByName('DOP_STR').AsString := eDop.Text;
    qAdd.ParamByName('TR_ID').AsString := FTR_ID;
    qAdd.ParamByName('DATA_NAK').AsDate := eDPol.Date;
    qAdd.ParamByName('IS_MULT').asBoolean := eType.ItemIndex = 0;
    qAdd.Execute;
  end;
  // 27.08.2016 --- заносим протокол
  try
    qIns.Close;
    qIns.Prepare;
    qIns.ParamByName('NO_AGN').AsInteger := FAgent;
    qIns.ParamByName('DATA_OTP').AsDate := eDPol.Date;
    qIns.ParamByName('FULL_AGN_NAME').AsString := eAgn.Text;
    qIns.ParamByName('FULL_SITY_NAME').AsString := 'Банк';
    qIns.ParamByName('SL_OTP').AsString := eBank.Text;
    qIns.ParamByName('NO_SKL').AsInteger := 0;
    qIns.ParamByName('K_VO_MEST').AsInteger := 0;
    qIns.ParamByName('NO_DEK').AsString := '';
    qIns.ParamByName('NAME_BANH').AsString := eBank.Text;
    qIns.ParamByName('SUM_OPL').value := eSum.Text.ToDouble;
    qIns.ParamByName('POL_NAME').AsString := ePol.Text;
    qIns.ParamByName('NO_POL').AsString := '';
    qIns.Execute;
    fmMain.IBT.Commit;
  except
  end;
  // если ошибка протокола - игнорируем
  Result := true;
end;

procedure TfmAddDop.ShowDolg;
var
  Item: TListBoxItem;
begin
  fmMain.StartReadTransaction;
  qRead.Close;
  qRead.Prepare;
  qRead.ParamByName('NG').AsInteger := FAgent;
  qRead.Active := true;
  FDolg := qRead.FieldByName('AG_DOLG').AsFloat;
  eDolg.Text := FloatToStr(FDolg);
  FValut := qRead.FieldByName('PRED_VAL').AsInteger;
  var I: Integer;
  for I := 0 to eVal.Items.Count - 1 do
  begin
    Item := eVal.ListItems[I];
    if Item.Tag = FValut then
    begin
      eVal.ItemIndex := I;
      Break;
    end;
  end;
  eCurs.Text := '1';
  fmMain.IBT_Read.Rollback;
end;

procedure TfmAddDop.TMSFNCButton2Click(Sender: TObject);
begin
  eAgn.Text := '';
  FAgent := -1;
  fmSelAgn := TfmSelAgn.Create(fmAddDop);
  fmSelAgn.LoadList;
  if fmSelAgn.ShowModal = mrOk then
  begin
    eAgn.Text := fmSelAgn.NameAgent;
    FAgent := fmSelAgn.NoAgent;
    ShowDolg;
    fmSelAgn.Release;
    fmSelAgn := nil;
  end;
end;

procedure TfmAddDop.TMSFNCButton3Click(Sender: TObject);
begin
  showCalc(eSum);
end;

procedure TfmAddDop.TMSFNCButton4Click(Sender: TObject);
var
  PolName, PolBank, PolNo: string;
begin
  if SelectBankAttribute(PolName, PolBank, PolNo) = mrOk then
  begin
    eBank.Text := PolBank;
    ePol.Text := PolName;
  end;
end;

procedure TfmAddDop.TMSFNCButton5Click(Sender: TObject);
var
  PolName, PolBank, PolNo: string;
begin
  if SelectBankAttribute(PolName, PolBank, PolNo) = mrOk then
  begin
    eBank.Text := PolBank;
    ePol.Text := PolName;
  end;
end;

procedure TfmAddDop.TMSFNCButton6Click(Sender: TObject);
begin
  showCalc(eCurs);
end;

procedure TfmAddDop.TMSFNCButton8Click(Sender: TObject);
begin
  if SaveDop then
  begin
    eBank.Text := '';
    ePol.Text := '';
    eDop.Text := '';
    eSum.Text := '0';
    ShowDolg;
  end;
end;

end.

