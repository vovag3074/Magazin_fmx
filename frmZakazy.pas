unit frmZakazy;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.TMSFNCButton, FMX.Controls.Presentation, FMX.Calendar,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCPopup, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Layouts, FMX.ListBox,
  FMX.SearchBox, FMX.Objects, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCTreeView, FMX.TMSFNCBitmapContainer;

type
  TfmZak = class(TFrame)
    pnTool: TPanel;
    TMSFNCButton5: TTMSFNCButton;
    eData: TEdit;
    DropDownEditButton1: TDropDownEditButton;
    myCalendar: TCalendar;
    ppCalendar: TTMSFNCPopup;
    qAgent: TFDQuery;
    tlZak: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    lbSearch: TSearchBox;
    ClearEditButton1: TClearEditButton;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    lbSumZak: TLabel;
    ppZakItem: TPopup;
    Panel2: TPanel;
    Panel3: TPanel;
    tlZakDet: TTMSFNCTreeView;
    qMod: TFDQuery;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    qSize: TFDQuery;
    TMSFNCButton1: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    TMSFNCButton3: TTMSFNCButton;
    HintPanel: TCalloutPanel;
    HintLabel: TLabel;
    procedure DropDownEditButton1Click(Sender: TObject);
    procedure myCalendarDateSelected(Sender: TObject);
    procedure TMSFNCButton5Click(Sender: TObject);
    procedure eDataChange(Sender: TObject);
    procedure tlZakDetBeforeExpandNode(Sender: TObject; ANode:
      TTMSFNCTreeViewVirtualNode; var ACanExpand: Boolean);
    procedure tlZakDetGetNodeTextColor(Sender: TObject; ANode:
      TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
    procedure tlZakDetGetNodeSelectedTextColor(Sender: TObject; ANode:
      TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
    procedure tlZakDetGetNodeSelectedColor(Sender: TObject; ANode:
      TTMSFNCTreeViewVirtualNode; var AColor: TTMSFNCGraphicsColor);
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure TMSFNCButton2Click(Sender: TObject);
    procedure TMSFNCButton3Click(Sender: TObject);
    procedure TMSFNCButton1MouseEnter(Sender: TObject);
    procedure TMSFNCButton1MouseLeave(Sender: TObject);
  private
    { Private declarations }
    FCount: Double;
    procedure LoadListZak;
    procedure zakazItemClick;
    procedure DoZakItemClick(Sender: TObject);
    procedure ListZakItem(NoZak: Integer; NoAgn: Integer);
    procedure UpdZakaz;
    procedure InsZakaz;
    procedure CheckZak;
  public
    { Public declarations }
    procedure SaveINI;
    procedure LoadINI;
  end;

var
  fmZak: TfmZak;

type
  pNodeData = ^tNodeData;

  tNodeData = record
    ID_Agent: Integer;
    ID_Model: Integer;
    ID_Size: Integer;
    ID_Key: Integer;
  end;

implementation

uses
  frmMain, frmInsertZakaz, frmReport;

{$R *.fmx}

procedure TfmZak.UpdZakaz;
begin
  fmInsZak := TfmInsZak.Create(fmZak);
  fmInsZak.EditZakaz(tlZak.ItemByIndex(tlZak.ItemIndex).Tag);
  if fmInsZak.ShowModal = mrOk then
  begin
    LoadListZak;
    Application.ProcessMessages;
    lbSearch.Text := fmInsZak.eAgn.Text;
  end;
  fmInsZak.Free;
  fmInsZak := nil;
end;

procedure TfmZak.CheckZak;
begin
 ShowReportJson('ShUserZakInfo.fr3', '[{"NZ":"' + IntToStr(tlZak.ItemByIndex(tlZak.ItemIndex).Tag)+'"}]');
end;

procedure TfmZak.DoZakItemClick(Sender: TObject);
begin
  if Sender is TListBoxItem then
  begin
    zakazItemClick;
  end;
end;

procedure TfmZak.DropDownEditButton1Click(Sender: TObject);
begin
  myCalendar.Date := StrToDate(eData.Text);
  ppCalendar.Popup;
end;

procedure TfmZak.eDataChange(Sender: TObject);
begin
  LoadListZak;
end;

procedure TfmZak.InsZakaz;
begin
  fmInsZak := TfmInsZak.Create(fmZak);
  if fmInsZak.ShowModal = mrOk then
  begin
    LoadListZak;
    Application.ProcessMessages;
    lbSearch.Text := fmInsZak.eAgn.Text;
  end;
  fmInsZak.Free;
  fmInsZak := nil;
end;

procedure TfmZak.ListZakItem(NoZak: Integer; NoAgn: Integer);
var
  Node: TTMSFNCTreeViewNode;
  Data: pNodeData;
begin
  tlZakDet.Nodes.Clear;
  qMod.Close;
  qMod.Prepare;
  qMod.ParamByName('SZ').AsInteger := NoZak;
  qMod.Active := True;
  if qMod.RecordCount > 0 then
  begin
    qMod.First;
    repeat
      Node := tlZakDet.AddNode();
      Node.Text[0] := qMod.FieldByName('NAZVAN').AsString;
      Node.Text[1] := qMod.FieldByName('SUM_OF_CNT_MOD').AsFloat.ToString;
      Node.Values[0].CollapsedIconName := 'Item1';
      Node.Values[0].ExpandedIconName := 'Item1';
//        if qMod.FieldByName('IS_OK').AsInteger = 1 then
//          Node.OverlayIndex := 4;
//        Node.ImageIndex := 1;
//        Node.HasChildren := True;
      new(Data);
      Data^.ID_Agent := NoAgn;
      Data^.ID_Model := qMod.FieldByName('NO_MOD').AsInteger;
      Data^.ID_Size := -1;
      Data^.ID_Key := NoZak;
      Node.DataPointer := Data;
      Node.DataBoolean := True;
      tlZakDet.AddNode(Node);//добавить дочерний элемент
      qMod.Next;
    until (qMod.Eof);
    if tlZakDet.Nodes.Count > 0 then
    begin
      tlZakDet.SelectNode(tlZakDet.Nodes[0]);
    end;
  end;
end;

procedure TfmZak.LoadINI;
begin
  tlZak.Items.Clear;
  tlZakDet.AdaptToStyle := True;
  eData.Text := DateToStr(Now);
  myCalendar.Date := Now;
end;

procedure TfmZak.LoadListZak;
var
  Node: TListBoxItem;
begin
  fmMain.StartReadTransaction;
  FCount := 0;
  tlZak.Items.Clear;
  tlZak.BeginUpdate;
  qAgent.Prepare;
  qAgent.ParamByName('ED').AsDate := StrToDate(eData.Text);
  qAgent.Active := True;
  if qAgent.RecordCount > 0 then
  begin
    qAgent.First;
    repeat
      Node := TListBoxItem.Create(tlZak);
      Node.StyleLookup := 'zakList';
      Node.Text := qAgent.FieldByName('AG_NAME').AsString + ' ' + qAgent.FieldByName
        ('ST_NAME').AsString;
      Node.StylesData['zakCnt'] := qAgent.FieldByName('M_CNT_MOD').AsFloat.ToString;
      FCount := FCount + qAgent.FieldByName('M_CNT_MOD').AsFloat;
      Node.StylesData['zakOpis'] := qAgent.FieldByName('PRIM_ZAK').AsString;
      Node.ImageIndex := 0;
      Node.Tag := qAgent.FieldByName('NO_SZ').AsInteger;
      Node.TagFloat := qAgent.FieldByName('NO_AGN').AsInteger;
      Node.OnClick := DoZakItemClick;
      tlZak.AddObject(Node);
      qAgent.Next;
    until (qAgent.Eof);
    tlZak.ItemIndex := 0;
  end;
  tlZak.EndUpdate;
  qAgent.Close;
  lbSumZak.Text := 'Всего: ' + FCount.ToString;
  fmMain.EndReadTransaction;
end;

procedure TfmZak.myCalendarDateSelected(Sender: TObject);
begin
  eData.Text := DateToStr(myCalendar.Date);
  ppCalendar.IsOpen := False;
end;

procedure TfmZak.SaveINI;
begin

end;

procedure TfmZak.tlZakDetBeforeExpandNode(Sender: TObject; ANode:
  TTMSFNCTreeViewVirtualNode; var ACanExpand: Boolean);
var
  AData, Data: pNodeData;
  Node: TTMSFNCTreeViewNode;
begin
  AData := ANode.Node.DataPointer;
  ANode.Node.RemoveChildren;
  qSize.Close;
  qSize.Prepare;
  qSize.ParamByName('NM').AsInteger := AData^.ID_Model;
  qSize.ParamByName('SZ').AsInteger := AData^.ID_Key;
  qSize.Active := True;
  if qSize.RecordCount > 0 then
  begin
    qSize.First;
    repeat
      Node := tlZakDet.AddNode(ANode.Node);
      Node.Text[0] := qSize.FieldByName('NO_SIZE').AsInteger.ToString;
      Node.Text[1] := qSize.FieldByName('CNT_MOD').AsFloat.ToString;
      Node.Values[0].CollapsedIconName := 'Item2';
      Node.Values[0].ExpandedIconName := 'Item2';
      new(Data);
      Data^.ID_Agent := AData^.ID_Agent;
      Data^.ID_Key := AData^.ID_Key;
      Data^.ID_Model := AData^.ID_Model;
      Data^.ID_Size := qSize.FieldByName('NO_SZD').AsInteger;
      Node.DataPointer := Data;
      Node.DataBoolean := False;
      qSize.Next;
    until (qSize.Eof);
  end;
end;

procedure TfmZak.tlZakDetGetNodeSelectedColor(Sender: TObject; ANode:
  TTMSFNCTreeViewVirtualNode; var AColor: TTMSFNCGraphicsColor);
begin
  if ANode.Node.DataBoolean then
  begin
    AColor := TAlphaColors.Black;
  end;
end;

procedure TfmZak.tlZakDetGetNodeSelectedTextColor(Sender: TObject; ANode:
  TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
begin
  if ANode.Node.DataBoolean then
  begin
    ATextColor := TAlphaColors.Yellow;
  end;
end;

procedure TfmZak.tlZakDetGetNodeTextColor(Sender: TObject; ANode:
  TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
begin
  if ANode.Node.DataBoolean then
  begin
    ATextColor := TAlphaColors.Yellow;
  end;
end;

procedure TfmZak.TMSFNCButton1Click(Sender: TObject);
begin
  UpdZakaz;
end;

procedure TfmZak.TMSFNCButton1MouseEnter(Sender: TObject);
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
      HintPanel.Position.Y := p.Top - (HintPanel.Height / 2) - (TControl(Sender).Height / 2)+50;
      HintPanel.Width := HintPanel.Width + HintPanel.CalloutLength;
      HintLabel.Padding.Left := HintPanel.CalloutLength;
      HintLabel.Padding.Top := -HintPanel.CalloutLength;
    end;
    HintPanel.BringToFront;
    HintPanel.Visible := True;
    HintLabel.Text := s;
  end;
end;

procedure TfmZak.TMSFNCButton1MouseLeave(Sender: TObject);
begin
 HintPanel.Visible := false;
end;

procedure TfmZak.TMSFNCButton2Click(Sender: TObject);
begin
  InsZakaz;
end;

procedure TfmZak.TMSFNCButton3Click(Sender: TObject);
begin
 CheckZak;
end;

procedure TfmZak.TMSFNCButton5Click(Sender: TObject);
begin
  fmMain.ClearOldFrame;
end;

procedure TfmZak.zakazItemClick;
var
  Item: TListBoxItem;
begin
  Item := tlZak.ItemByIndex(tlZak.ItemIndex);
  ppZakItem.PlacementTarget := Item;
  ListZakItem(Item.Tag, Trunc(Item.TagFloat));
  ppZakItem.Popup();
end;

end.

