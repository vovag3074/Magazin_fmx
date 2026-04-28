unit frmBank;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.TMSFNCButton, FMX.Layouts, FMX.ListBox,
  FMX.Objects, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl, FMX.TMSFNCImage, FMX.Edit,
  FMX.Calendar, FMX.TMSFNCCustomComponent, FMX.TMSFNCPopup, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Effects,
  FMX.Filter.Effects, FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData,
  FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView, FMX.TMSFNCBitmapContainer,
  FMX.Calendar.Helpers, FMX.CalendarHolidayDays.Style, System.Rtti;

type
  TfmBank = class(TFrame)
    Panel1: TPanel;
    TMSFNCButton5: TTMSFNCButton;
    tlDop: TListBox;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    ListBoxItem1: TListBoxItem;
    ListBoxGroupFooter1: TListBoxGroupFooter;
    Rectangle1: TRectangle;
    TMSFNCImage1: TTMSFNCImage;
    Label1: TLabel;
    eData: TEdit;
    DropDownEditButton1: TDropDownEditButton;
    ppCalendar: TTMSFNCPopup;
    myCalendar: TCalendar;
    TMSFNCImage2: TTMSFNCImage;
    Rectangle2: TRectangle;
    Label2: TLabel;
    Rectangle3: TRectangle;
    Label3: TLabel;
    qBank: TFDQuery;
    qPol: TFDQuery;
    qSumBank: TFDQuery;
    Rectangle4: TRectangle;
    Label4: TLabel;
    qSumPol: TFDQuery;
    Panel2: TPanel;
    ppinfo: TPopup;
    Panel3: TPanel;
    lbInfo: TLabel;
    TMSFNCButton1: TTMSFNCButton;
    tlDet: TTMSFNCTreeView;
    qUsr: TFDQuery;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCButton2: TTMSFNCButton;
    Rectangle5: TRectangle;
    ltHeader: TLayout;
    ltItem: TLayout;
    ltFooter: TLayout;
    procedure TMSFNCButton5Click(Sender: TObject);
    procedure DropDownEditButton1Click(Sender: TObject);
    procedure myCalendarDateSelected(Sender: TObject);
    procedure eDataChange(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure TMSFNCButton2Click(Sender: TObject);
  private
    { Private declarations }
    procedure GetBankSum(NBank:String);
    procedure GetPolSum(NBank:string; NPol:string; myItem:TListBoxItem);
    procedure ReadBankList;
    procedure ReadPolList(NBank: string);
    procedure ListDetail(NBank,NPol:String);
  public
    { Public declarations }
    procedure LoadINI;
    procedure SaveINI;
  end;

var
  fmBank: TfmBank;

implementation

uses
  frmMain, frmAddDop;

{$R *.fmx}

procedure TfmBank.DropDownEditButton1Click(Sender: TObject);
begin
  ppCalendar.Popup;
end;

procedure TfmBank.eDataChange(Sender: TObject);
begin
  ReadBankList;
end;

procedure TfmBank.GetBankSum(NBank:String);
var Item:TListBoxGroupFooter;
begin
  qSumBank.Close;
  qSumBank.ParamByName('MB').AsString := NBank;
  qSumBank.ParamByName('SD').AsDate := StrToDate(eData.Text);
  qSumBank.Active := True;
  Item:=TListBoxGroupFooter.Create(tlDop);
  Item.StyleLookup := 'myFooter';
  Item.Height := ltFooter.Height;

  Item.Text:= 'Сумма по банку = '+qSumBank.FieldByName('SUM_OF_VSUM_OPL').AsFloat.ToString;

  tlDop.AddObject(Item);
  qSumBank.Close;
end;

procedure TfmBank.GetPolSum(NBank, NPol: string; myItem: TListBoxItem);
begin
 qSumPol.Close;
 qSumPol.ParamByName('SD').AsDate := StrToDate(eData.Text);
 qSumPol.ParamByName('MU').AsString := NPol;
 qSumPol.ParamByName('MB').AsString := NBank;
 qSumPol.Active:=True;
 myItem.BeginUpdate;
 myItem.StylesData['mySum'] := qSumPol.FieldByName('SUM_OF_VSUM_OPL').AsFloat.ToString;
 myItem.EndUpdate;
 qSumPol.Close;
end;

procedure TfmBank.ListBoxItem1Click(Sender: TObject);
begin
  if Sender is TListBoxItem then
  begin
    ppInfo.Width := tlDop.Width-40;
    ppinfo.Height := tlDop.Height / 3;
    ppinfo.PlacementTarget:= TListBoxItem(Sender);
    tlDet.AdaptToStyle:=True;
    tlDet.GlobalFont.Size:=18;
    ppInfo.Popup();
    ListDetail(TListBoxItem(Sender).TagString,TListBoxItem(Sender).Text);
  end;
end;

procedure TfmBank.ListDetail(NBank, NPol: String);
var Node: TTMSFNCTreeViewNode;
begin
 lbInfo.Text := 'Получения на '+NPol+' по банку '+NBank;
 tlDet.Nodes.Clear;
  qUsr.Close;
    qUsr.Prepare;
    qUsr.ParamByName('SD').AsDate := StrToDate(eData.Text);
    qUsr.ParamByName('MY').AsString := NPol;
    qUsr.ParamByName('MB').AsString := NBank;
    qUsr.Active := True;
    if qUsr.RecordCount > 0 then
    begin
      qUsr.First;
      repeat
        Node := tlDet.AddNode();
        Node.DataInteger := qUsr.FieldByName('NO_AG').AsInteger;
        Node.Text[0] := qUsr.FieldByName('AG_NAME').AsString;
        Node.Text[1] := qUsr.FieldByName('ST_NAME').AsString;
        Node.Text[2] := qUsr.FieldByName('SUM_OPL').AsFloat.ToString;
        Node.Text[5] := DateToStr(qUsr.FieldByName('DATA_NAK').AsDateTime);
        if qUsr.FieldByName('KURS_VAL').IsNull then   // если запись старая то курс = 1, а сумма олаты = сумме с учетом курса
        begin
          Node.Text[3] := '1';
          Node.Text[4] := qUsr.FieldByName('SUM_OPL').AsFloat.ToString;
        end
        else
        begin
          Node.Text[3] := qUsr.FieldByName('KURS_VAL').AsFloat.ToString;
          Node.Text[4] := qUsr.FieldByName('VSUM_OPL').AsFloat.ToString;
        end;

        Node.Values[0].CollapsedIconName := 'Item1';
        Node.Values[0].ExpandedIconName := 'Item1';
        qUsr.Next;
      until (qUsr.Eof);
    end;
end;

procedure TfmBank.LoadINI;
var
  Events: TArray<TDateTime>;
begin
 //
  eData.Text := DateToStr(now);
  myCalendar.Date := Now;
  ltItem.Visible := False;
  ltHeader.Visible := False;
  ltFooter.Visible := False;

  SetLength(Events, 1);
  Events[0] := now-5;
  myCalendar.Model.Data['Events'] := TValue.From<TArray<TDateTime>>(Events);
  myCalendar.Model.ShowEvents := True;
  myCalendar.Model.ShowWeekends:=False;
end;

procedure TfmBank.myCalendarDateSelected(Sender: TObject);
begin
  eData.Text := DateToStr(myCalendar.Date);
  ppCalendar.IsOpen := False;
end;

procedure TfmBank.ReadBankList;
var
  Item: TListBoxGroupHeader;
  S:string;
  I:Double;
begin
  qBank.close;
  tlDop.Items.Clear;
  fmMain.StartReadTransaction;
  qBank.ParamByName('SD').AsDate := StrToDate(eData.Text);
  qBank.Active := True;
  if qBank.RecordCount > 0 then
  begin
    qBank.First;
    repeat
      Item := TListBoxGroupHeader.Create(tlDop);
      Item.StyleLookup := 'myHeader';
      Item.Height := ltHeader.Height;
      S := qBank.FieldByName('MY_BANK').AsString;
      Item.Text := S;
      tlDop.AddObject(Item);
      ReadPolList(S);
      GetBankSum(S);
      qBank.Next;
    until qBank.Eof;
  end;
end;

procedure TfmBank.ReadPolList(NBank: string);
var
  Item: TListBoxItem;
begin
  qPol.Close;
  qPol.ParamByName('MB').AsString := NBank;
  qPol.ParamByName('SD').AsDate := StrToDate(eData.Text);
  qPol.Active := True;
  if qPol.RecordCount > 0 then
  begin
    repeat
      Item := TListBoxItem.Create(tlDop);
      Item.StyleLookup := 'miItem';
      Item.Height := ltItem.Height;
      Item.Text := qPol.FieldByName('MY_USER').AsString;
      Item.TagString:=NBank;
      tlDop.AddObject(Item);
      GetPolSum(NBank, qPol.FieldByName('MY_USER').AsString, Item);
      Item.OnClick := ListBoxItem1Click;
      qPol.Next;
    until qPol.Eof;
  end;
end;

procedure TfmBank.SaveINI;
begin
 //
end;


procedure TfmBank.TMSFNCButton1Click(Sender: TObject);
begin
 ppinfo.IsOpen:=False;
end;

procedure TfmBank.TMSFNCButton2Click(Sender: TObject);
begin
 fmAddDop := TfmAddDop.Create(fmBank);
 fmAddDop.eDate.Date := StrToDate(eData.Text);
 fmAddDop.eDPol.Date := StrToDate(eData.Text);
 if fmAddDop.ShowModal=mrOk then
 begin

 end;
 fmAddDop.Free;
 fmAddDop:=nil;
end;

procedure TfmBank.TMSFNCButton5Click(Sender: TObject);
begin
  fmMain.ClearOldFrame;
end;

end.

