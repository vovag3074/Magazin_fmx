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
  FMX.TabControl, FMX.ExtCtrls, FMX.Effects;

type
  TfmProd = class(TFrame)
    Panel1: TPanel;
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
    Layout1: TLayout;
    Rectangle4: TRectangle;
    Label14: TLabel;
    Label15: TLabel;
    TMSFNCImage2: TTMSFNCImage;
    ListBoxItem1: TListBoxItem;
    pmProd: TPopup;
    tbInfo: TTabControl;
    tbNow: TTabItem;
    TabItem2: TTabItem;
    Panel2: TPanel;
    ltFooter: TLayout;
    Rectangle5: TRectangle;
    Label16: TLabel;
    procedure DropDownEditButton1Click(Sender: TObject);
    procedure TMSFNCButton5Click(Sender: TObject);
    procedure myCalendarDateSelected(Sender: TObject);
    procedure eDataChange(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
  private
    { Private declarations }
    FSum, FOpl, FCnt: Double;
    FNewCashe: Double;
    procedure ListInfoMoney;
    procedure ListInfoBankPred;
    procedure ListSendMoney;
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
  frmMain;

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
   //ShowInfo(TListBoxItem(Sender).Tag.ToString);
   pmProd.Width:=tlProd.Width-40;
   tbInfo.TabIndex:=0;
   pmProd.PlacementTarget:= TListBoxItem(Sender);
   pmProd.Popup();
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
         Node.Text := qPredBank.FieldByName('AG_NAME').AsString +' '+
           qPredBank.FieldByName('SUM_PRED').AsFloat.ToString;
        if qPredBank.FieldByName('POL_PRED').IsNull then
          Node.Text := Node.Text+ ' <Получатель не назначен>'
        else
          Node.Text := Node.Text+' '+ qPredBank.FieldByName('POL_PRED').AsString;
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
      S := S+' Сумма = '+qPred.FieldByName('SUM_PRED').AsFloat.ToString;
      if qPred.FieldByName('POL_PRED').IsNull then
        S:= S+'  <Получатель не назначен>'
      else
        S:= S+' Получатель: '+qPred.FieldByName('POL_PRED').AsString;
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
        Node.Text := 'Отдано на руки валюта: ' +  qSumSend.FieldByName('NAZVAN').AsString;
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
        Node.OnClick :=  ListBoxItem1Click;
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
    Node.Text:='Продано: '+FCnt.ToString+' |  На сумму: '+FSum.ToString+' |  Оплачено: '+
    FOpl.ToString;
    tlProd.AddObject(Node);
  finally
    tlProd.EndUpdate;
    if tlProd.Items.Count > 0 then
    begin
      tlProd.ItemIndex:=0;
    end;
    fmMain.EndReadTransaction;
  end;
  tlProd.ShowScrollBars:=True;
end;

procedure TfmProd.SaveINI;
begin

end;

procedure TfmProd.TMSFNCButton5Click(Sender: TObject);
begin
  fmMain.ClearOldFrame;
end;

end.

