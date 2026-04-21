unit frmInvScald;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.TMSFNCButton, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCEdit, FMX.Edit, FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData,
  FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCBitmapContainer, FMX.Layouts, FMX.ListBox, FMX.Objects, System.Rtti,
  FMX.TMSFNCDataGridCell, FMX.TMSFNCDataGridData, FMX.TMSFNCDataGridBase,
  FMX.TMSFNCDataGridCore, FMX.TMSFNCDataGridRenderer, FMX.TMSFNCDataGrid,
  FMX.TMSFNCGridCell, FMX.TMSFNCGridOptions, FMX.TMSFNCCustomScrollControl,
  FMX.TMSFNCGridData, FMX.TMSFNCCustomGrid, FMX.TMSFNCGrid, FMX.TMSFNCPopupMenu,
  FMX.Menus, System.ImageList, FMX.ImgList, FMX.SVGIconImageList, FMX.Platform,
  FMX.Clipboard, FMX.TMSFNCPopup;

type
  TfmInv = class(TFrame)
    Panel1: TPanel;
    TMSFNCButton5: TTMSFNCButton;
    pnMod: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    pnZakList: TPanel;
    Panel4: TPanel;
    Panel2: TPanel;
    eFind: TEdit;
    TMSFNCButton1: TTMSFNCButton;
    tlMod: TTMSFNCTreeView;
    qKat: TFDQuery;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    qMod: TFDQuery;
    Panel5: TPanel;
    lbSum: TLabel;
    Panel3: TPanel;
    cbAll: TCheckBox;
    cxZakList: TListBox;
    Panel6: TPanel;
    qZakList: TFDQuery;
    Rectangle1: TRectangle;
    Label1: TLabel;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    Label2: TLabel;
    Label3: TLabel;
    Splitter3: TSplitter;
    tlSize: TTMSFNCDataGrid;
    qSize: TFDQuery;
    tlZak: TTMSFNCTreeView;
    qModZak: TFDQuery;
    pmZak: TPopupMenu;
    miCopyCode: TMenuItem;
    SVGIconImageList1: TSVGIconImageList;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    qDelSelZak: TFDCommand;
    qDelAllZakaz: TFDCommand;
    btUpdSclad: TTMSFNCButton;
    btSetModSize: TTMSFNCButton;
    lbSumZak: TLabel;
    pmMod: TPopupMenu;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    btRep: TTMSFNCButton;
    ppRep: TTMSFNCPopup;
    pnRep: TPanel;
    repOst: TTMSFNCButton;
    repZak: TTMSFNCButton;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    miRepSize: TMenuItem;
    myZakList: TLayout;
    procedure TMSFNCButton5Click(Sender: TObject);
    procedure tlModBeforeExpandNode(Sender: TObject; ANode:
      TTMSFNCTreeViewVirtualNode; var ACanExpand: Boolean);
    procedure cbAllChange(Sender: TObject);
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure eFindKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar;
      Shift: TShiftState);
    procedure miCopyCodeClick(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure btUpdScladClick(Sender: TObject);
    procedure btSetModSizeClick(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure btRepClick(Sender: TObject);
    procedure pmModPopup(Sender: TObject);
    procedure repOstClick(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure tlModFocusedNodeChanged(Sender: TObject;
      ANode: TTMSFNCTreeViewVirtualNode);
  private
    { Private declarations }
    function ListDet(ANode: TTMSFNCTreeViewNode): Float64;
     /// <summary>
    /// Читаем список активных заказов на складе.
    /// </summary>
    procedure ListActiveZakaz;
    procedure ListModZakInfo;
    procedure goUp;
    procedure goDown;
    procedure ViewDetNode(Node: TTMSFNCTreeViewNode);
    /// <summary>
    /// Отметить выбранный заказ как проданный и убрать из списка
    /// </summary>
    procedure DelSelectZakaz;
     /// <summary>
    /// Отметить все заказы как проданные
    /// </summary>
    procedure DelAllZakaz;
    /// <summary>
    /// Настройка размеров
    /// </summary>
    procedure SetModSize;
     /// <summary>
    /// Отчет о наличии на складе
    /// </summary>
    procedure RepOstSclad;
  public
    { Public declarations }
    procedure LoadINI;
    procedure SaveINI;
     /// <summary>
    /// Читаем содержимое склада. Сначала по категориям.
    /// </summary>
    /// <remarks>
    /// Есть особенность - если в категории ничего нет, то не отображается
    /// даже в режиме "показать все"
    /// </remarks>
    procedure ListMod;
  end;

var
  fmInv: TfmInv;

implementation

uses
  frmMain, frmSetModSizeSclad, frmReport;

{$R *.fmx}

procedure TfmInv.cbAllChange(Sender: TObject);
begin
  ListMod;
end;

procedure TfmInv.DelAllZakaz;
begin
  if cxZakList.Count > 0 then
  begin
    if ShowQuestion('Убрать все заказы?') then
    begin
      fmMain.StartMainTransaction;
      qDelAllZakaz.Close;
      qDelAllZakaz.Prepare;
      qDelAllZakaz.Execute;
      fmMain.IBT.Commit;
      cxZakList.Items.Clear;
    end;
  end;
end;

procedure TfmInv.DelSelectZakaz;
var
  item: TListBoxItem;
begin
  if cxZakList.Count > 0 then
  begin
    item := cxZakList.ListItems[cxZakList.ItemIndex];
    var S: string;
    S := item.StylesData['myCode'].AsString;
    S := S + ' для ' + item.Text;
    if ShowQuestion('Убрать заказ № ' + S + '?') then
    begin
      fmMain.StartMainTransaction;
      qDelSelZak.Close;
      qDelSelZak.Prepare;
      qDelSelZak.ParamByName('NZ').AsInteger := item.Tag;
      qDelSelZak.Execute;
      fmMain.IBT.Commit;
      cxZakList.Items.Delete(cxZakList.ItemIndex);
    end;
  end;
end;

procedure TfmInv.eFindKeyDown(Sender: TObject; var Key: Word; var KeyChar:
  WideChar; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    tlMod.LookupNode(eFind.Text.Trim, False, 0, False, true);
    eFind.SetFocus;
  end
  else if Key = vkUp then
  begin
    goUp;
    Key := 0;
    eFind.SetFocus;
  end
  else if Key = vkDown then
  begin
    goDown;
    Key := 0;
    eFind.SetFocus;
  end
  else if Key = vkEscape then
  begin
    eFind.Text := '';
    Key := 0;
    eFind.SetFocus;
  end;
  ViewDetNode(tlMod.FocusedNode);
end;

procedure TfmInv.goDown;
var
  Node: TTMSFNCTreeViewNode;
begin
  Node := tlMod.GetNextNode(tlMod.FocusedNode);
  if Assigned(Node) then
  begin
    tlMod.SelectNode(Node);
    tlMod.ScrollToNode(Node, True);
  end;
end;

procedure TfmInv.goUp;
var
  Node: tTmsFNCTreeViewNode;
begin
  Node := tlMod.GetPreviousNode(tlMod.FocusedNode);
  if Assigned(Node) then
  begin
    tlMod.SelectNode(Node);
    tlMod.ScrollToNode(Node, True);
  end;
end;

procedure TfmInv.ListActiveZakaz;
var
  item: TListBoxItem;
  FCountZak: Double;
begin
  FCountZak := 0;
  cxZakList.Clear;
  qZakList.Close;
  qZakList.Active := true;
  if qZakList.RecordCount > 0 then
  begin
    qZakList.First;
    try
      cxZakList.BeginUpdate;
      repeat
        item := TListBoxItem.Create(cxZakList);
        item.StyleLookup := 'myZakListStyle';
        item.Text := qZakList.FieldByName('AG_NAME').AsString + ' ' + qZakList.FieldByName
          ('ST_NAME').AsString;
        item.StylesData['myCount'] := qZakList.FieldByName('CNT_MOD').AsFloat.ToString;
        item.StylesData['myCode'] := qZakList.FieldByName('CODE_ZAK').AsString;
        item.Tag := qZakList.FieldByName('NO_ZAK').AsInteger;
        cxZakList.AddObject(item);
        FCountZak := FCountZak + qZakList.FieldByName('CNT_MOD').AsFloat;
        qZakList.Next;
      until (qZakList.Eof);
    finally
      cxZakList.EndUpdate;
      lbSumZak.Text := FCountZak.ToString;
    end;
    if cxZakList.Items.Count > 0 then
    begin
      cxZakList.ItemIndex := 0;
    end;
  end;
end;

function TfmInv.ListDet(ANode: TTMSFNCTreeViewNode): Float64;
const
  mySel = 'select MS.CNT_MOD, M.M_CENA, M.NAZVAN, M.NO_MOD ' +
    ' from MODEL_IN_SCLAD MS ' + ' inner join MODEL_TABLE M on (MS.NO_MOD = M.NO_MOD) ';
  WhereStd = ' where ((M.NO_KAT = :NK) and ' +
    '      (MS.IS_VIT = :IV) and (MS.CNT_MOD > 0)) ';
  WhereAll = ' where ((M.NO_KAT = :NK) and ' +
    '      (MS.IS_VIT = :IV) and (MS.CNT_MOD >= 0) ' + ' and (M.IS_DEL = 0))';
  myOrder = ' order by M.NAZVAN ';
var
  Node: TTMSFNCTreeViewNode;
  Cnt: Float64;
begin
  Cnt := 0;
  ANode.RemoveChildren;
  qMod.Close;
  // 24.09.2014 добавили возможность показывать все модели
  if cbAll.IsChecked then
  begin
    qMod.SQL.Text := mySel + WhereAll + myOrder;
  end
  else
  begin
    qMod.SQL.Text := mySel + WhereStd + myOrder;
  end;
  qMod.Prepare;
  qMod.ParamByName('NK').AsInteger := ANode.DataInteger;
  qMod.ParamByName('IV').AsSmallInt := 0;
  qMod.Active := true;
  if qMod.RecordCount > 0 then
  begin
    repeat
      Node := tlMod.AddNode(ANode);
      Node.DataInteger := qMod.FieldByName('NO_MOD').AsInteger;
      Node.DataBoolean := True;
      Node.Text[0] := qMod.FieldByName('NAZVAN').AsString;
      Node.Text[1] := qMod.FieldByName('CNT_MOD').AsFloat.ToString;
      Node.Text[2] := qMod.FieldByName('M_CENA').AsFloat.ToString;
      Node.Values[0].CollapsedIconName := 'Item2';
      Node.Values[0].ExpandedIconName := 'Item2';
      Cnt := Cnt + qMod.FieldByName('CNT_MOD').AsFloat;
      qMod.Next;
    until (qMod.Eof);
  end;
  Result := Cnt;
end;

procedure TfmInv.ListMod;
var
  Node: TTMSFNCTreeViewNode;
  FSumMod: Double;
begin
  FSumMod := 0;
  tlMod.Nodes.Clear;
  tlMod.BeginUpdate;
  fmMain.StartReadTransaction;
  qKat.Close;
  qKat.Prepare;
  qKat.ParamByName('IV').AsSmallInt := 0;
  qKat.Active := true;
  if qKat.RecordCount > 0 then
  begin
    qKat.First;
    repeat
      if qKat.FieldByName('SUM_OF_CNT_MOD').AsInteger > 0 then
      begin
        Node := tlMod.AddNode();
        Node.DataInteger := qKat.FieldByName('NO_KAT').AsInteger;
        Node.DataBoolean := False;
        Node.DataString := qKat.FieldByName('NAZVAN').AsString +
          '<font color = "Yellow">  (' + FloatToStr(qKat.FieldByName('SUM_SKID').AsFloat)
          + ') </font>';
        Node.Text[0] := qKat.FieldByName('NAZVAN').AsString;
        Node.Values[0].CollapsedIconName := 'Item1';
        Node.Values[0].ExpandedIconName := 'Item1';
        Node.Extended := True;
        var F: Double := ListDet(Node);
        Node.Text[0] := Node.DataString + '<font color = "Red"> [' + F.ToString
          + ']</font>';
        FSumMod := FSumMod + F;
      end;
      qKat.Next;
    until (qKat.Eof);
    tlMod.EndUpdate;
    tlMod.ExpandAll;
    if tlMod.Nodes.Count > 0 then
    begin
      tlMod.SelectNode(tlMod.Nodes[0]);
    end;
    lbSum.Text := FSumMod.ToString;
  end;
  ListActiveZakaz;
end;

procedure TfmInv.ListModZakInfo;
var
  Node, ANode: TTMSFNCTreeViewNode;
begin
  tlZak.Nodes.Clear;
  ANode := tlMod.FocusedNode;
  qModZak.Close;
  qModZak.Prepare;
  qModZak.ParamByName('NM').AsInteger := ANode.DataInteger;
  qModZak.Active := true;
  if qModZak.RecordCount > 0 then
  begin
    qModZak.First;
    repeat
      Node := tlZak.AddNode();
      Node.Text[0] := qModZak.FieldByName('FULL_NAME_STD').AsString;
      Node.Text[1] := qModZak.FieldByName('CNT_NO_MST').AsInteger.ToString;
      Node.Values[0].CollapsedIconName := 'Item3';
      Node.Values[0].ExpandedIconName := 'Item3';
      qModZak.Next;
    until (qModZak.Eof);
//    tlZak.GotoBOF;
  end;
end;

procedure TfmInv.LoadINI;
begin
  pnMod.Width := myINI.ReadInteger('Sclad', 'ModList', 300).ToSingle;
  pnZakList.Width := myINI.ReadInteger('Sclad', 'ZakList', 300).ToSingle;
  tlSize.Height := myINI.ReadInteger('Sclad', 'SizeList', 300).ToSingle;
end;

procedure TfmInv.MenuItem2Click(Sender: TObject);
begin
  DelSelectZakaz;
end;

procedure TfmInv.MenuItem3Click(Sender: TObject);
begin
 DelAllZakaz;
end;

procedure TfmInv.MenuItem4Click(Sender: TObject);
begin
  btUpdScladClick(Sender);
end;

procedure TfmInv.MenuItem5Click(Sender: TObject);
begin
 btSetModSizeClick(Sender);
end;

procedure TfmInv.MenuItem6Click(Sender: TObject);
begin
 RepOstSclad;
end;

procedure TfmInv.miCopyCodeClick(Sender: TObject);
var
  item: TListBoxItem;
  ClipboardService: IFMXClipboardService;
begin
  if cxZakList.Count > 0 then
  begin
    item := cxZakList.ListItems[cxZakList.ItemIndex];
    if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService,
      ClipboardService) then
    begin
      var S: string;
      S := item.StylesData['myCode'].AsString;
      ClipboardService.SetClipboard(S);
      S := 'Заказ №: ' + S + ' скопирован в буфер обмена';
      ShowNotify(S);
    end;
  end;
end;

procedure TfmInv.pmModPopup(Sender: TObject);
begin
 miRepSize.Enabled := not tlMod.FocusedNode.Extended;
end;

procedure TfmInv.repOstClick(Sender: TObject);
begin
 RepOstSclad;
end;

procedure TfmInv.RepOstSclad;
begin
 ShowReportJson('ShRepOstMag.fr3', '[{"IV":"0"}]');
end;

procedure TfmInv.SaveINI;
begin
  myINI.WriteInteger('Sclad', 'ModList', Trunc(pnMod.Width));
  myINI.WriteInteger('Sclad', 'ZakList', Trunc(pnZakList.Width));
  myINI.WriteInteger('Sclad', 'SizeList', Trunc(tlSize.Height));
end;

procedure TfmInv.SetModSize;
begin
  if not tlMod.FocusedNode.Extended then
  begin
    fmSetSize := TfmSetSize.Create(fmInv);
    fmSetSize.ListSize(tlMod.FocusedNode.DataInteger, 0);
    if fmSetSize.ShowModal = mrOk then
    begin
      tlMod.FocusedNode.Text[1]:=fmSetSize.SizeListSum.ToString;
      fmMain.StartReadTransaction;
      ViewDetNode(tlMod.FocusedNode);
      ShowNotify('После изменения размеров не забудьте обновить склад...');
    end;
    fmSetSize.Free;
    fmSetSize:=nil;
  end;
end;

procedure TfmInv.tlModBeforeExpandNode(Sender: TObject; ANode:
  TTMSFNCTreeViewVirtualNode; var ACanExpand: Boolean);
begin
  ListDet(ANode.Node);
end;

procedure TfmInv.tlModFocusedNodeChanged(Sender: TObject;
  ANode: TTMSFNCTreeViewVirtualNode);
begin
  fmMain.StartReadTransaction;
  ViewDetNode(ANode.Node);
end;

procedure TfmInv.TMSFNCButton1Click(Sender: TObject);
begin
  eFind.Text := '';
  eFind.SetFocus;
end;

procedure TfmInv.btUpdScladClick(Sender: TObject);
begin
 fmMain.UpdateSclad;
 ListMod;
end;

procedure TfmInv.btRepClick(Sender: TObject);
begin
 repZak.Enabled := not  tlMod.FocusedNode.Extended;
 ppRep.Popup();
end;

procedure TfmInv.btSetModSizeClick(Sender: TObject);
begin
  SetModSize;
end;

procedure TfmInv.TMSFNCButton5Click(Sender: TObject);
begin
 tlMod.Nodes.Clear;
 cxZakList.Items.Clear;
 tlZak.Nodes.Clear;
 fmMain.IBT_Read.Rollback;
  fmMain.ClearOldFrame;
end;

procedure TfmInv.ViewDetNode(Node: TTMSFNCTreeViewNode);
var
  myCol: Integer;
begin
  try
    tlSize.RowCount := 1;
    if Node.DataBoolean then
    begin
      qSize.Close;
      qSize.Prepare;
      qSize.ParamByName('IV').AsSmallInt := 0;
      qSize.ParamByName('NM').AsInteger := tlMod.FocusedNode.DataInteger;
      qSize.Active := true;
      var R: Integer;
      R := qSize.RecordCount;
      if R > 0 then
      begin
        tlSize.RowCount := R + 1;
        qSize.First;
        myCol := 1;
        try
          tlSize.BeginUpdate;
          repeat
            begin
              tlSize.Cells[0, myCol] := qSize.FieldByName('NO_SIZE').AsInteger.ToString;
              tlSize.Cells[1, myCol] := qSize.FieldByName('CNT_MOD').AsInteger.ToString;
              tlSize.Ints[2, myCol] := qSize.FieldByName('N0_MSIS').AsInteger;
              Inc(myCol);
            end;
            qSize.Next;
          until (qSize.Eof);
        finally
          tlSize.EndUpdate;
        end;
        if tlSize.RowCount > 0 then
        begin
          tlSize.SelectedRows[0];
        end;
        ListModZakInfo;
      end;
    end;
  except
  end;
end;

end.

