unit frmProdaga;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.TMSFNCButton, FMX.Controls.Presentation, System.Rtti,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCPopup, FMX.Calendar, FMX.Layouts,
  FMX.ListBox, FMX.Objects, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl, FMX.TMSFNCImage,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Threading, FMX.TabControl, FMX.ExtCtrls, FMX.Effects,
  FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCTreeView, FMX.TMSFNCBitmapContainer, FMX.Menus, System.ImageList,
  FMX.ImgList, FMX.SVGIconImageList, FMX.Calendar.Helpers,
  FMX.CalendarHolidayDays.Style;

type
  TfmProd = class(TFrame)
    pnTool: TPanel;
    TMSFNCButton5: TTMSFNCButton;
    eData: TEdit;
    DropDownEditButton1: TDropDownEditButton;
    TMSFNCButton2: TTMSFNCButton;
    ppCalendar: TTMSFNCPopup;
    myCalendar: TCalendar;
    qUsr: TFDQuery;
    qPred: TFDQuery;
    qPredBank: TFDQuery;
    qSumSend: TFDQuery;
    tlProd: TListBox;
    ltProd: TLayout;
    Rectangle1: TRectangle;
    TMSFNCImage1: TTMSFNCImage;
    Label1: TLabel;
    Line1: TLine;
    Label2: TLabel;
    Line2: TLine;
    Label3: TLabel;
    Line3: TLine;
    Label4: TLabel;
    Line4: TLine;
    Label5: TLabel;
    Line5: TLine;
    Label6: TLabel;
    tlHead: TLayout;
    Rectangle2: TRectangle;
    Label7: TLabel;
    Line6: TLine;
    Label8: TLabel;
    Line7: TLine;
    Label9: TLabel;
    Line8: TLine;
    Label10: TLabel;
    Line9: TLine;
    Label11: TLabel;
    Line10: TLine;
    Label12: TLabel;
    ltPred: TLayout;
    Rectangle3: TRectangle;
    Label13: TLabel;
    ltSend: TLayout;
    Rectangle4: TRectangle;
    Label14: TLabel;
    Label15: TLabel;
    TMSFNCImage2: TTMSFNCImage;
    ListBoxItem1: TListBoxItem;
    pmProd: TPopup;
    tbInfo: TTabControl;
    tbNow: TTabItem;
    tbHist: TTabItem;
    Panel2: TPanel;
    ltFooter: TLayout;
    Rectangle5: TRectangle;
    Label16: TLabel;
    tlPMod: TTMSFNCTreeView;
    qMod: TFDQuery;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    tbOpl: TTabItem;
    tlLog: TTMSFNCTreeView;
    qLogAg: TFDQuery;
    tlOpl: TTMSFNCTreeView;
    qLOpl: TFDQuery;
    pmProdAgn: TPopupMenu;
    MenuItem1: TMenuItem;
    Panel1: TPanel;
    btRepProd: TTMSFNCButton;
    HintPanel: TCalloutPanel;
    HintLabel: TLabel;
    btOplTov: TTMSFNCButton;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    SVGIconImageList1: TSVGIconImageList;
    qDataPol: TFDQuery;
    pmSendMoney: TPopupMenu;
    MenuItem4: TMenuItem;
    qInsPol: TFDCommand;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    qMoveProd: TFDCommand;
    TMSFNCButton1: TTMSFNCButton;
    TMSFNCButton3: TTMSFNCButton;
    TMSFNCButton4: TTMSFNCButton;
    TMSFNCButton6: TTMSFNCButton;
    TMSFNCButton7: TTMSFNCButton;
    btPolMoney: TTMSFNCButton;
    ppSendMoney: TPopup;
    Panel3: TPanel;
    Panel4: TPanel;
    lbSndMoney: TListBox;
    ListBoxItem2: TListBoxItem;
    qSnd: TFDQuery;
    TMSFNCButton9: TTMSFNCButton;
    ppMoney: TPopup;
    Panel5: TPanel;
    tlSumInfo: TListBox;
    Rectangle6: TRectangle;
    Label17: TLabel;
    Label18: TLabel;
    qSumCash: TFDQuery;
    ListBoxItem3: TListBoxItem;
    Panel6: TPanel;
    TMSFNCButton8: TTMSFNCButton;
    ltMoney: TLayout;
    procedure DropDownEditButton1Click(Sender: TObject);
    procedure TMSFNCButton5Click(Sender: TObject);
    procedure myCalendarDateSelected(Sender: TObject);
    procedure eDataChange(Sender: TObject);
    // процедура выводит всплывающее окно со списком продаж
    procedure ListBoxItem1Click(Sender: TObject);
    procedure tlPModGetNodeTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
    procedure tlPModGetNodeSelectedColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; var AColor: TTMSFNCGraphicsColor);
    procedure tlPModGetNodeSelectedTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
    procedure tbHistClick(Sender: TObject);
    procedure tbOplClick(Sender: TObject);
    procedure TMSFNCButton2Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure btRepProdClick(Sender: TObject);
    procedure btRepProdMouseEnter(Sender: TObject);
    procedure btRepProdMouseLeave(Sender: TObject);
    procedure btOplTovClick(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure TMSFNCButton7Click(Sender: TObject);
    procedure TMSFNCButton9Click(Sender: TObject);
    procedure btPolMoneyClick(Sender: TObject);
    procedure TMSFNCButton8Click(Sender: TObject);
  private
    { Private declarations }
    FSum, FOpl, FCnt: Double;
    FNewCashe: Double;
    FActiveProd: Integer; // выбранный покупатель в продаже
    procedure ListInfoMoney;
    procedure ListInfoBankPred;
    procedure ListSendMoney;
    procedure ShowProdMod;
    procedure ShowLog;
    procedure ShowLogOpl;
    procedure showLastProdList;
    procedure predMoneyClick(Sender: TObject);
    procedure sendMoneyClick(Sender: TObject);
    procedure setPredPol;
    procedure MoveProd;
    procedure ListFullMoneySend(NoVal: Integer);
  public
    { Public declarations }
    procedure LoadINI;
    procedure SaveINI;
    /// <summary>
    /// Отображение продажи за выбранную дату. В конце списка покупателей
    /// выводится список предоплат и передачи налички (инкассации)
    /// </summary>
    procedure ReadProd;
  end;

var
  fmProd: TfmProd;

implementation

uses
  frmMain, frmAddProdaga, frmReport, frmOplata, frmSelForPred, fкmPredopByCeh,
  frmSelectDate, frmSendMoney;

{$R *.fmx}

procedure TfmProd.DropDownEditButton1Click(Sender: TObject);
begin
  ppCalendar.Popup;
end;

procedure TfmProd.eDataChange(Sender: TObject);
begin
  ReadProd;
end;

procedure TfmProd.ListBoxItem1Click(Sender: TObject);
begin
//Для покупателей в продаже
  if Sender is TListBoxItem then
  begin
    tlProd.PopupMenu := pmProdAgn;
    tlLog.Nodes.Clear;
    tlPMod.Nodes.Clear;
    tlOpl.Nodes.Clear;
    pmProd.Width := 800;
    tbInfo.TabIndex := 0;
    pmProd.PlacementTarget := TListBoxItem(Sender);
   // формируем список продаж
    FActiveProd := TListBoxItem(Sender).Tag;
    HintPanel.Visible := False;
    pmProd.Popup();
    ShowProdMod;
  end;
end;

procedure TfmProd.ListFullMoneySend(NoVal: Integer);
var
  Node: TListBoxItem;
begin
  try
    lbSndMoney.Items.Clear;
    qSnd.Close;
    qSnd.Prepare;
    qSnd.ParamByName('DS').AsDate := StrToDate(eData.Text);
    qSnd.ParamByName('NV').AsInteger := NoVal;
    //ShowMessage('DS='+eData.Text+' NV='+NoVal.ToString);
    qSnd.Active := True;
    if qSnd.RecordCount > 0 then
    begin
      qSnd.First;
      repeat
        Node := TListBoxItem.Create(lbSndMoney);
        Node.Tag := qSnd.FieldByName('NO_LSCB').AsInteger;
        Node.Text := qSnd.FieldByName('POL_SND').AsString + ' получил: ' + qSnd.FieldByName('SUM_SND').AsFloat.ToString;
        lbSndMoney.AddObject(Node);
        qSnd.Next;
      until (qSnd.Eof);
      lbSndMoney.ItemIndex := 0;
    end;
  except
    on E: Exception do
    begin
      ShowError(E.Message);
    end;

  end;
end;

procedure TfmProd.ListInfoBankPred;
var
  Node: TListBoxItem;
begin
  qPredBank.Close;
  qPredBank.Prepare;
  qPredBank.ParamByName('DS').AsDate := StrToDate(eData.Text);
  qPredBank.Active := True;
  if qPredBank.RecordCount > 0 then
  begin
    qPredBank.First;
    repeat
      Node := TListBoxItem.Create(tlProd);
      Node.StyleLookup := 'predItem';
      Node.Tag := qPredBank.FieldByName('NO_PRGN').AsInteger;
      Node.Text := qPredBank.FieldByName('AG_NAME').AsString + ' ' + qPredBank.FieldByName('SUM_PRED').AsFloat.ToString;
      if qPredBank.FieldByName('POL_PRED').IsNull then
        Node.Text := Node.Text + ' <Получатель не назначен>'
      else
        Node.Text := Node.Text + ' ' + qPredBank.FieldByName('POL_PRED').AsString;
      qPredBank.Next;
    until qPredBank.Eof;
  end;
    // А тут показываем отдачу денег
    // Тут суммарная информация по передаче денег
end;

procedure TfmProd.ListInfoMoney;
var
  Node: TListBoxItem;
  S: string;
begin
// А тут предоплаты по наличке полная информация
  qPred.Close;
  qPred.Prepare;
  qPred.ParamByName('DS').AsDate := StrToDate(eData.Text);
  qPred.Active := True;
  if qPred.RecordCount > 0 then
  begin
    qPred.First;
    repeat
      Node := TListBoxItem.Create(tlProd);
      Node.StyleLookup := 'predItem';
      Node.Tag := qPred.FieldByName('NO_PRGN').AsInteger;
      Node.TagString := qPred.FieldByName('NO_AGN').AsInteger.ToString;
//      Node.Values[8] := -1;
      S := 'Наличная предоплата от: ' + qPred.FieldByName('AG_NAME').AsString;
      S := S + ' Сумма = ' + qPred.FieldByName('SUM_PRED').AsFloat.ToString;
      if qPred.FieldByName('POL_PRED').IsNull then
        S := S + '  <Получатель не назначен>'
      else
        S := S + ' Получатель: ' + qPred.FieldByName('POL_PRED').AsString;
      Node.Text := S;
      Node.OnClick := predMoneyClick;
      tlProd.AddObject(Node);
      qPred.Next;
    until qPred.Eof;
  end;
end;

procedure TfmProd.ListSendMoney;
var
  Node: TListBoxItem;
begin
  qSumSend.Close;
  qSumSend.Prepare;
  qSumSend.ParamByName('DS').AsDate := StrToDate(eData.Text);
  qSumSend.Active := True;
  if qSumSend.RecordCount > 0 then
  begin
    qSumSend.First;
    repeat
      Node := TListBoxItem.Create(tlProd);
      Node.StyleLookup := 'sndItem';
      Node.Text := 'Отдано на руки валюта: ' + qSumSend.FieldByName('NAZVAN').AsString;
      Node.StylesData['tVal'] := qSumSend.FieldByName('SUM_OF_SUM_SND').AsFloat.ToString;
      Node.Tag := qSumSend.FieldByName('NO_VAL').AsInteger;
      Node.OnClick := sendMoneyClick;
      qSumSend.Next;
      tlProd.AddObject(Node);
    until (qSumSend.Eof);
  end;
end;

procedure TfmProd.LoadINI;
var
  Header: TListBoxHeader;
begin
  tlPMod.AdaptToStyle := True;
  tlLog.AdaptToStyle := True;
  tlLog.NodesAppearance.ExtendedFontColor := TAlphaColors.Khaki;
  tlLog.NodesAppearance.ExtendedFont.Size := 14;
  tlLog.NodesAppearance.ShowLines := True;
  tlOpl.AdaptToStyle := True;
  eData.Text := DateToStr(now);
  myCalendar.Data := now;
    //-----------------------
    // вставляем заголовок
    //-----------------------
  Header := TListBoxHeader.Create(tlProd);
  Header.StyleLookup := 'prodHead';
  tlProd.AddObject(Header);
  // вставляем пометки в календарь
  showLastProdList;
end;

procedure TfmProd.MenuItem1Click(Sender: TObject);
begin
  btRepProdClick(Sender);
end;

procedure TfmProd.MenuItem2Click(Sender: TObject);
begin
  btOplTovClick(Sender);
end;

procedure TfmProd.MenuItem4Click(Sender: TObject);
begin
  setPredPol;
  ReadProd;
end;

procedure TfmProd.MenuItem5Click(Sender: TObject);
begin
  ShowReportJSON('ShRepHistAgn.fr3', '[{"NG":"' + IntToStr(FActiveProd) + '"}]');
end;

procedure TfmProd.MenuItem6Click(Sender: TObject);
begin
  ShowReportJSON('ShRepFullHistAgn.fr3', '[{"NG":"' + IntToStr(FActiveProd) + '"}]');
end;

procedure TfmProd.MenuItem8Click(Sender: TObject);
begin
  MoveProd;
end;

procedure TfmProd.MoveProd;
var
  I, NAGN: Integer;
  ND, OD: tDate;
begin
  if tlProd.Items.Count > 0 then // если ничего нет то и не надо
  begin
    ND := Now;
    I := selectDate('Перенос продажи', 'Выберите новую дату для продажи', ND);
    if I = mrOK then
    begin
      OD := StrToDate(eData.Text);
      NAGN := FActiveProd;
      fmMain.StartMainTransaction;
      qMoveProd.Active := false;
      qMoveProd.Prepare;
      qMoveProd.ParamByName('NEW_DATA').AsDate := ND;
      qMoveProd.ParamByName('OLD_DATA').AsDate := OD;
      qMoveProd.ParamByName('NO_AGN').AsInteger := NAGN;
      qMoveProd.Execute;
      fmMain.EndMainTransaction;
      ReadProd;
    end; // if I= mrYes then
  end; // if tlProd.Count>0 then
end;

procedure TfmProd.myCalendarDateSelected(Sender: TObject);
begin
  eData.Text := DateToStr(myCalendar.Date);
  ppCalendar.IsOpen := False;
end;

procedure TfmProd.predMoneyClick(Sender: TObject);
begin
  tlProd.PopupMenu := pmSendMoney;
end;

procedure TfmProd.ReadProd;
var
  Node: TListBoxItem;
begin
  FSum := 0;
  FOpl := 0;
  FCnt := 0;
  try
    tlProd.BeginUpdate;
    tlProd.Clear;
    fmMain.StartReadTransaction;
    qUsr.Close;
    qUsr.Prepare;
    qUsr.ParamByName('SD').AsDate := StrToDate(eData.Text);
    qUsr.Active := True;
    if qUsr.RecordCount > 0 then
    begin
      qUsr.First;
      repeat
        Node := TListBoxItem.Create(tlProd);
        Node.StyleLookup := 'prodItem';
        Node.Tag := qUsr.FieldByName('NO_AGN').AsInteger;
        Node.TagString := qUsr.FieldByName('NO_AGN').AsInteger.ToString;
        Node.Text := qUsr.FieldByName('AG_NAME').AsString + ' ' + qUsr.FieldByName('ST_NAME').AsString + ' Валюта: (' + qUsr.FieldByName('NAZVAN').AsString + ')';
        Node.StylesData['prodCnt'] := qUsr.FieldByName('COUNT_OF_NO_MOD_SIZE').AsInteger;
        Node.StylesData['prodSum'] := qUsr.FieldByName('SUM_TOV').AsFloat;
        Node.StylesData['prodOpl'] := qUsr.FieldByName('SUM_OPL').AsFloat;
//        Node.StylesData['prodOpl'] := (qUsr.FieldByName('SUM_TOV').AsFloat -qUsr.FieldByName('SUM_OPL').AsFloat);
        Node.StylesData['sumDolg'] := qUsr.FieldByName('AG_DOLG').AsFloat;
//        Node.Values[10] := qUsr.FieldByName('DOP_OPIS').AsString;
        Node.StylesData['sumPred'] := qUsr.FieldByName('AG_PRED').AsFloat;
//        if qUsr.FieldByName('IS_SKIDKA').AsInteger = 1 then
//          Node.OverlayIndex := 5;
        FSum := FSum + qUsr.FieldByName('SUM_TOV').AsFloat;
        FOpl := FOpl + qUsr.FieldByName('SUM_OPL').AsFloat;
        FCnt := FCnt + qUsr.FieldByName('COUNT_OF_NO_MOD_SIZE').AsInteger;
        Node.OnClick := ListBoxItem1Click;
        Node.PopupMenu := pmProdAgn;
        tlProd.AddObject(Node);
        qUsr.Next;
      until (qUsr.Eof);
    end;
    ListInfoMoney;
    ListInfoBankPred;
    ListSendMoney;
    //-------------------------------------
    Node := TListBoxItem.Create(tlProd);
    Node.StyleLookup := 'ftrProd';
    Node.Text := 'Продано: ' + FCnt.ToString + ' |  На сумму: ' + FSum.ToString + ' |  Оплачено: ' + FOpl.ToString;
    Node.PopupMenu := nil;
    tlProd.AddObject(Node);
  finally
    tlProd.EndUpdate;
    if tlProd.Items.Count > 0 then
    begin
      tlProd.ItemIndex := 0;
    end;
    fmMain.EndReadTransaction;
  end;
  tlProd.ShowScrollBars := False;
end;

procedure TfmProd.SaveINI;
begin

end;

procedure TfmProd.sendMoneyClick(Sender: TObject);
var
  Item: TListBoxItem;
begin
  if Sender is TListBoxItem then
  begin
    Item := Sender as TListBoxItem;
    ppSendMoney.Width := 600;
    ppSendMoney.PlacementTarget := TListBoxItem(Sender);
    ppSendMoney.Popup();
    ListFullMoneySend(Item.Tag);
  end;
end;

procedure TfmProd.setPredPol;
var
  S: string;
  Node: TListBoxItem;
  FAgent: Integer;
  FTmp: Double;
  FData: tDate;
begin
  Node := tlProd.ItemByIndex(tlProd.ItemIndex);
  FAgent := Node.TagString.ToInteger;
  FTmp := Node.Tag;
  FData := StrToDate(eData.Text);
  S := SetPredByCeh(FTmp, FAgent, FData);
  fmMain.StartMainTransaction;
  qInsPol.Active := false;
  qInsPol.Prepare;
  qInsPol.ParamByName('NO_PRGN').AsInteger := Node.Tag;
  qInsPol.ParamByName('POL_PRED').AsString := S;
  qInsPol.Execute;
  fmMain.EndMainTransaction;
end;

procedure TfmProd.showLastProdList;
var
  Events: TArray<TDateTime>;
  I: Integer;
begin
  TTask.Run(
    procedure
    begin
      // 1. Выполнение запроса в фоновом потоке
      qDataPol.Active := True;
      I := qDataPol.RecordCount;
      SetLength(Events, I);
      // 2. Обновление интерфейса - только через TThread.Synchronize
      TThread.Synchronize(nil,
        procedure
        begin
          if I > 0 then
          begin
            qDataPol.First;
            I := 0;
            repeat
              Events[I] := qDataPol.FieldByName('DATA_PROD').AsDateTime;
              inc(I);
              qDataPol.Next;
            until qDataPol.Eof;
            myCalendar.Model.Data['Events'] := TValue.From<TArray<TDateTime>>(Events);
            myCalendar.Model.ShowEvents := True;
            myCalendar.Model.ShowWeekends := False;
          end;
        end);
    end);
end;

procedure TfmProd.ShowLog;
var
  Node, ANode: TTMSFNCTreeViewNode;
begin
  try
    tlLog.Nodes.Clear;
    qLogAg.Close;
    qLogAg.Prepare;
    qLogAg.ParamByName('NG').AsInteger := FActiveProd;
    qLogAg.Active := True;
    if qLogAg.RecordCount > 0 then
    begin
      qLogAg.First;
      repeat
        Node := tlLog.AddNode;
        Node.Text[0] := DateToStr(qLogAg.FieldByName('DATA_PROD').AsDateTime);
        Node.Text[1] := qLogAg.FieldByName('OPERATION').AsString;
        Node.Text[2] := qLogAg.FieldByName('COUNT_OF_NO_MOD_SIZE').AsInteger.ToString;
        Node.Text[3] := qLogAg.FieldByName('SUM_OF_CENA_PROD').AsFloat.ToString;
        if qLogAg.FieldByName('LOG_DOP').AsString.Trim <> '' then
        begin
          ANode := tlLog.AddNode(Node);
          ANode.Text[0] := qLogAg.FieldByName('LOG_DOP').AsString;
          ANode.Extended := True;
        end;
        Node.Values[0].CollapsedIconName := 'Item2';
        Node.Values[0].ExpandedIconName := 'Item2';
        var I: Integer;
        I := qLogAg.FieldByName('TYPE_OP').AsInteger;
        case I of
          1:
            begin
              Node.Values[0].CollapsedIconName := 'Item3';
              Node.Values[0].ExpandedIconName := 'Item3';
            end;
          2:
            begin
              Node.Values[0].CollapsedIconName := 'Item4';
              Node.Values[0].ExpandedIconName := 'Item4';
            end;
          5:
            begin
              Node.Values[0].CollapsedIconName := 'Item5';
              Node.Values[0].ExpandedIconName := 'Item5';
            end;
          6:
            begin
              Node.Values[0].CollapsedIconName := 'Item6';
              Node.Values[0].ExpandedIconName := 'Item6';
            end;
          7:
            begin
              Node.Values[0].CollapsedIconName := 'Item7';
              Node.Values[0].ExpandedIconName := 'Item7';
            end;
        end;
        qLogAg.Next;
      until (qLogAg.Eof);
    end;
    tlLog.ExpandAll;
  except
  end;
end;

procedure TfmProd.ShowLogOpl;
var
  Node: TTMSFNCTreeViewNode;
begin
     // 05.08.2020 ----- состояние оплат
  try
    tlOpl.Nodes.Clear;
    qLOpl.Close;
    qLOpl.Prepare;
    qLOpl.ParamByName('NG').AsInteger := FActiveProd;
    qLOpl.Active := True;
    if qLOpl.RecordCount > 0 then
    begin
      qLOpl.First;
      repeat
        Node := tlOpl.AddNode();
        Node.Text[0] := qLOpl.FieldByName('NAZVAN').AsString;
        Node.Text[1] := DateToStr(qLOpl.FieldByName('DATA_PROD').AsDateTime);
        Node.Text[2] := DateToStr(qLOpl.FieldByName('DATA_OPL').AsDateTime);
        Node.Text[3] := qLOpl.FieldByName('CENA_PROD').AsFloat.ToString;
        Node.Text[4] := qLOpl.FieldByName('OPLATA').AsFloat.ToString;
        qLOpl.Next;
      until qLOpl.Eof;
    end;
  finally
  end;
end;

procedure TfmProd.ShowProdMod;
var
  Node: TTMSFNCTreeViewNode;
begin
  try
    tlPMod.Nodes.Clear;
    qMod.Close;
    qMod.Prepare;
    qMod.ParamByName('SD').AsDate := StrToDate(eData.Text);
    qMod.ParamByName('NG').AsInteger := FActiveProd;
    qMod.Active := True;
    if qMod.RecordCount > 0 then
    begin
      qMod.First;
      repeat
        Node := tlPMod.AddNode();
        Node.DataInteger := qMod.FieldByName('NO_MOD').AsInteger;
        Node.Text[0] := qMod.FieldByName('M_NAZVAN').AsString;
        Node.Text[1] := qMod.FieldByName('COUNT_OF_NO_LPT').AsInteger.ToString;
        Node.Text[2] := qMod.FieldByName('CENA_PROD').AsFloat.ToString;
        Node.Text[3] := qMod.FieldByName('SUM_PROD').AsFloat.ToString;
        Node.Text[4] := qMod.FieldByName('OPLATA').AsFloat.ToString;
        Node.Values[0].CollapsedIconName := 'Item1';
        Node.Values[0].ExpandedIconName := 'Item1';
        qMod.Next;
      until (qMod.Eof);
    end;
  finally
    if tlPMod.Nodes.Count > 0 then
    begin
      tlPMod.SelectNode(tlPMod.Nodes[0])
    end;
  end;
end;

procedure TfmProd.tbHistClick(Sender: TObject);
begin
  ShowLog;
end;

procedure TfmProd.tbOplClick(Sender: TObject);
begin
  ShowLogOpl;
end;

procedure TfmProd.tlPModGetNodeSelectedColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; var AColor: TTMSFNCGraphicsColor);
begin
  var T: Double;
  T := ANode.Text[3].ToDouble - ANode.Text[4].ToDouble;
  if T > 0 then
    AColor := TAlphaColors.Darkmagenta;
end;

procedure TfmProd.tlPModGetNodeSelectedTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
begin
  var T: Double;
  T := ANode.Text[3].ToDouble - ANode.Text[4].ToDouble;
  if T > 0 then
    ATextColor := TAlphaColors.White;
end;

procedure TfmProd.tlPModGetNodeTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
begin
  var T: Double;
  T := ANode.Text[3].ToDouble - ANode.Text[4].ToDouble;
  if T > 0 then
    ATextColor := TAlphaColors.Deeppink;
end;

procedure TfmProd.btPolMoneyClick(Sender: TObject);
var
  Node: TListBoxItem;
begin
  ppMoney.Popup();
  tlSumInfo.Items.Clear;
  qSumCash.Close;
  qSumCash.ParamByName('DP').AsDate := StrToDate(eData.Text);
  qSumCash.Active := true;
  if qSumCash.RecordCount > 0 then
  begin
    qSumCash.First;
    repeat
      Node := TListBoxItem.Create(tlSumInfo);
      Node.StyleLookup := 'moneyItem';
      Node.Text := qSumCash.FieldByName('NAZVAN').AsString;
      Node.StylesData['sumItem'] := qSumCash.FieldByName('mySum').AsFloat.ToString;
      //Node.StylesData[''];
      Node.Tag := qSumCash.FieldByName('NO_VAL').AsInteger;
      tlSumInfo.AddObject(Node);
      qSumCash.Next;
    until (qSumCash.Eof);
    tlSumInfo.ItemIndex := 0;
  end;
end;

procedure TfmProd.btRepProdClick(Sender: TObject);
begin
  ShowReportJson('SRepProdAgn.fr3', '[{"NG":"' + IntToStr(FActiveProd) + '", "DT":"' + eData.Text + '"}]');
end;

procedure TfmProd.btRepProdMouseEnter(Sender: TObject);
var
  p, r: TRectF;
  s: string;
begin
  if (Sender is TControl) then
  begin

    if Sender is TTMSFNCButton then
      s := TTMSFNCButton(Sender).Text
    else
      s := TControl(Sender).TagString;
    p := TControl(Sender).AbsoluteRect;

    r := RectF(0, 0, 400, 1000);
    if HintLabel.Canvas <> nil then
    begin
      HintLabel.Canvas.Font.Size := 16;
      HintLabel.Canvas.MeasureText(r, s, true, [], TTextAlign.Center, TTextAlign.Center);
      HintPanel.Width := r.Width + 22;
      HintPanel.Height := r.Height + HintPanel.CalloutLength + 30;
    end;
    if (p.Left + TControl(Sender).Width / 2 > HintPanel.Width / 2) then
    begin
      HintPanel.CalloutPosition := TCalloutPosition.Bottom;
      HintPanel.Position.X := p.Left + TControl(Sender).Width / 2 - HintPanel.Width / 2;
      HintPanel.Position.Y := p.Top - TControl(Sender).Height - 15;
      HintLabel.Padding.Left := 0;
      HintLabel.Padding.Top := 0;
    end
    else
    begin
      HintPanel.CalloutPosition := TCalloutPosition.Left;
      HintPanel.Position.X := p.Left + TControl(Sender).Width;
      HintPanel.Position.Y := p.Top - HintPanel.Height / 2 + TControl(Sender).Height / 2;
      HintPanel.Width := HintPanel.Width + HintPanel.CalloutLength;
      HintLabel.Padding.Left := HintPanel.CalloutLength;
      HintLabel.Padding.Top := -HintPanel.CalloutLength;
    end;
    HintPanel.BringToFront;
    HintPanel.Visible := True;
    HintLabel.Text := s;
  end;
end;

procedure TfmProd.btRepProdMouseLeave(Sender: TObject);
begin
  HintPanel.Visible := false;
end;

procedure TfmProd.TMSFNCButton2Click(Sender: TObject);
begin
  if StrToDate(eData.Text) < Date then
  begin
    ShowError('Продавать на прошлую дату нельзя!');
    Exit;
  end;
  fmAddProdAgn := TfmAddProdAgn.Create(fmProd);
  fmAddProdAgn.ShowModal;
  fmAddProdAgn.Free;
  fmAddProdAgn := nil;
  ReadProd;
end;

procedure TfmProd.btOplTovClick(Sender: TObject);
begin
  try
    fmOpl := TfmOpl.Create(fmAddProdAgn);
    fmOpl.dxRet.Visible := False;
    fmOpl.ReadAgent(FActiveProd, 0, StrToDate(fmProd.eData.Text));
    if fmOpl.ShowModal = mrOk then
    begin
      ReadProd;
    end;
  finally
    fmOpl.Free;
    fmOpl := nil;
  end;
end;

procedure TfmProd.TMSFNCButton5Click(Sender: TObject);
begin
  fmMain.ClearOldFrame;
end;

procedure TfmProd.TMSFNCButton7Click(Sender: TObject);
begin
  fmSndMoney := TfmSndMoney.Create(fmProd);
  fmSndMoney.ReadVal;
  fmSndMoney.ShowModal;
  fmSndMoney.Free;
  ReadProd;
end;

procedure TfmProd.TMSFNCButton8Click(Sender: TObject);
var
  Item: TListBoxItem;
begin
  if tlSumInfo.Items.Count > 0 then
  begin
    Item := tlSumInfo.ItemByIndex(tlSumInfo.ItemIndex);
    fmSndMoney := TfmSndMoney.Create(fmProd);
    fmSndMoney.ReadVal;
    fmSndMoney.eSum.Text := Item.StylesData['sumItem'].AsString;
    fmMain.GetValutFromComboBox(Item.Tag, fmSndMoney.eVal);
    fmSndMoney.ShowModal;
    fmSndMoney.Free;
    ReadProd;
  end;
end;

procedure TfmProd.TMSFNCButton9Click(Sender: TObject);
begin
  if lbSndMoney.Items.Count > 0 then
  begin
    fmSndMoney := TfmSndMoney.Create(fmProd);
    fmSndMoney.ReadVal;
    fmSndMoney.EditSnd(lbSndMoney.ItemByIndex(lbSndMoney.ItemIndex).Tag);
    fmSndMoney.ShowModal;
    fmSndMoney.Free;
    ReadProd;
  end;
end;

end.

