unit frmProdaga;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.TMSFNCButton, FMX.Controls.Presentation,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCPopup, FMX.Calendar, FMX.Layouts,
  FMX.ListBox, FMX.Objects, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl, FMX.TMSFNCImage,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.TabControl, FMX.ExtCtrls, FMX.Effects, FMX.TMSFNCTreeViewBase,
  FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView,
  FMX.TMSFNCBitmapContainer;

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
  frmMain, frmAddProdaga;

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
    tlLog.Nodes.Clear;
    tlPMod.Nodes.Clear;
    tlOpl.Nodes.Clear;
    pmProd.Width := 800;
    tbInfo.TabIndex := 0;
    pmProd.PlacementTarget := TListBoxItem(Sender);
   // формируем список продаж
    FActiveProd := TListBoxItem(Sender).Tag;
    pmProd.Popup();
    ShowProdMod;
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
      S := qPred.FieldByName('AG_NAME').AsString;
      S := S + ' Сумма = ' + qPred.FieldByName('SUM_PRED').AsFloat.ToString;
      if qPred.FieldByName('POL_PRED').IsNull then
        S := S + '  <Получатель не назначен>'
      else
        S := S + ' Получатель: ' + qPred.FieldByName('POL_PRED').AsString;
      Node.Text := S;
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
  tlLog.AdaptToStyle:=True;
  tlLog.NodesAppearance.ExtendedFontColor:=TAlphaColors.Khaki;
  tlLog.NodesAppearance.ExtendedFont.Size:=14;
  tlLog.NodesAppearance.ShowLines:=True;
  tlOpl.AdaptToStyle:=True;
  eData.Text := DateToStr(now);
  myCalendar.Data := now;
    //-----------------------
    // вставляем заголовок
    //-----------------------
  Header := TListBoxHeader.Create(tlProd);
  Header.StyleLookup := 'prodHead';
  tlProd.AddObject(Header);
end;

procedure TfmProd.myCalendarDateSelected(Sender: TObject);
begin
  eData.Text := DateToStr(myCalendar.Date);
  ppCalendar.IsOpen := False;
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
        Node.Text[0]:= DateToStr(qLogAg.FieldByName('DATA_PROD').AsDateTime);
        Node.Text[1] := qLogAg.FieldByName('OPERATION').AsString;
        Node.Text[2] := qLogAg.FieldByName('COUNT_OF_NO_MOD_SIZE').AsInteger.ToString;
        Node.Text[3] := qLogAg.FieldByName('SUM_OF_CENA_PROD').AsFloat.ToString;
        if qLogAg.FieldByName('LOG_DOP').AsString.Trim <>'' then
         begin
           ANode := tlLog.AddNode(Node);
           ANode.Text[0] := qLogAg.FieldByName('LOG_DOP').AsString;
           ANode.Extended:=True;
         end;
        Node.Values[0].CollapsedIconName := 'Item2';
        Node.Values[0].ExpandedIconName := 'Item2';
        var I:Integer;
        I := qLogAg.FieldByName('TYPE_OP').AsInteger;
        case I of
         1: begin
            Node.Values[0].CollapsedIconName := 'Item3';
            Node.Values[0].ExpandedIconName := 'Item3';
         end;
         2: begin
            Node.Values[0].CollapsedIconName := 'Item4';
            Node.Values[0].ExpandedIconName := 'Item4';
         end;
         5: begin
            Node.Values[0].CollapsedIconName := 'Item5';
            Node.Values[0].ExpandedIconName := 'Item5';
         end;
         6: begin
            Node.Values[0].CollapsedIconName := 'Item6';
            Node.Values[0].ExpandedIconName := 'Item6';
         end;
         7: begin
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
  ReadProd;
end;

procedure TfmProd.TMSFNCButton5Click(Sender: TObject);
begin
  fmMain.ClearOldFrame;
end;

end.

