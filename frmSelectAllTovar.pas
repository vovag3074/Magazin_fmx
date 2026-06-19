unit frmSelectAllTovar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCTreeView, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Edit, FMX.TMSFNCButton, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCBitmapContainer;

type
  TfmSelAllTov = class(TForm)
    Panel1: TPanel;
    tlMod: TTMSFNCTreeView;
    Splitter1: TSplitter;
    tlSize: TTMSFNCTreeView;
    qKat: TFDQuery;
    qMod: TFDQuery;
    eFnd: TEdit;
    qSize: TFDQuery;
    TMSFNCButton4: TTMSFNCButton;
    btOK: TTMSFNCButton;
    ClearEditButton1: TClearEditButton;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCButton1: TTMSFNCButton;
    procedure FormCreate(Sender: TObject);
    procedure tlModGetNodeTextColor(Sender: TObject; ANode:
      TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
    procedure eFndKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar;
      Shift: TShiftState);
    procedure tlModAfterSelectNode(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode);
    procedure TMSFNCButton1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ListChild(ANode: TTMSFNCTreeViewNode);
    procedure goUp;
    procedure goDown;
    procedure showSizeList;
  public
    { Public declarations }
    /// <summary>
    /// Чтение списка моделей
    /// </summary>
    procedure ReadModList;
  end;

var
  fmSelAllTov: TfmSelAllTov;

function GetAllManualCode: string;

implementation

uses
  frmMain, frmSynhro;

{$R *.fmx}

{ TfmSelAllTov }

procedure TfmSelAllTov.eFndKeyDown(Sender: TObject; var Key: Word; var KeyChar:
  WideChar; Shift: TShiftState);
begin
  if Shift = [ssCtrl] then
  begin
    if Key = vkReturn then
    begin
      ModalResult := mrOk;
      Key := 0;
    end;
  end
  else if Shift = [] then
  begin
    if Key = VKDOWN then
    begin
      goDown;
      Key := 0;
    end;
    if Key = VKUP then
    begin
      goUp;
      Key := 0;
    end;
    if Key = vkReturn then
    begin
      ReadModList;
      if eFnd.Text.Trim <> '' then
      begin
        tlMod.LookupNode(eFnd.Text.Trim, False, 0, False, True);
        showSizeList;
        Key := 0;
      end;
    end;
    if Key = vkEscape then
    begin
      eFnd.Text := '';
      ReadModList;
      Key := 0;
    end;
  end;
end;

procedure TfmSelAllTov.FormCreate(Sender: TObject);
begin
  tlMod.AdaptToStyle := True;
  tlSize.AdaptToStyle := True;
end;

procedure TfmSelAllTov.goDown;
var
  Node: tTmsFNCTreeViewNode;
begin
  Node := tlMod.GetNextNode(tlMod.FocusedNode);
  if Assigned(Node) then
  begin
    tlMod.SelectNode(Node);
    tlMod.ScrollToNode(Node, True);
    showSizeList;
  end;
end;

procedure TfmSelAllTov.goUp;
var
  Node: tTmsFNCTreeViewNode;
begin
  Node := tlMod.GetPreviousNode(tlMod.FocusedNode);
  if Assigned(Node) then
  begin
    tlMod.SelectNode(Node);
    tlMod.ScrollToNode(Node, True);
    showSizeList;
  end;
end;

procedure TfmSelAllTov.ListChild(ANode: TTMSFNCTreeViewNode);
var
  Node: TTMSFNCTreeViewNode;
const
  SelectDef = 'select MS.CNT_MOD, M.M_CENA, M.NAZVAN, M.NO_MOD ' +
    ' from MODEL_IN_SCLAD MS ' + ' inner join MODEL_TABLE M on (MS.NO_MOD = M.NO_MOD) ';
  WhereFnd = 'where ((M.NO_KAT = :NK) and' + #13#10 +
    '      (M.UPPER_NAZVAN starting with :SNM) and' + #13#10 +
    '      (MS.IS_VIT = 0) and' + #13#10 + '      ((M.IS_DEL = 0) or' + #13#10 +
    '      (MS.CNT_MOD > 0))) ';
  WhereAll = 'where ((M.NO_KAT = :NK) and' + #13#10 +
    '      (MS.IS_VIT = 0) and' + #13#10 + '      ((M.IS_DEL = 0) or' + #13#10 +
    '      (MS.CNT_MOD > 0))) ';
  OrderDef = ' order by M.NAZVAN ';
begin
  ANode.RemoveChildren;
  qMod.Close;
  // ------ 11.02.2017 ------------------------------------
  // меняем вариант поиска по названию
  // пробуем вариант поиска с фильтрацией по запросу
  // -------------------------------------------------------
  qMod.SQL.Clear;
  if trim(eFnd.Text) <> '' then
  begin
    qMod.SQL.Add(SelectDef);
    qMod.SQL.Add(WhereFnd);
    qMod.SQL.Add(OrderDef);
    qMod.Prepare;
    qMod.ParamByName('SNM').AsString := trim(eFnd.Text);
  end
  else
  begin
    qMod.SQL.Add(SelectDef);
    qMod.SQL.Add(WhereAll);
    qMod.SQL.Add(OrderDef);
    qMod.Prepare;
  end;
  qMod.ParamByName('NK').AsInteger := ANode.DataInteger;
  qMod.Active := True;
  if qMod.RecordCount > 0 then
  begin
    repeat
      Node := tlMod.AddNode(ANode);
      Node.DataInteger := qMod.FieldByName('NO_MOD').AsInteger;
      Node.Text[0] := qMod.FieldByName('NAZVAN').AsString;
      Node.Text[1] := qMod.FieldByName('CNT_MOD').AsFloat.ToString;
      Node.Text[2] := qMod.FieldByName('M_CENA').AsFloat.ToString;
      Node.Values[0].CollapsedIconName := 'Item2';
      Node.Values[0].ExpandedIconName := 'Item2';
      Node.DataBoolean := False;
//      Node.ImageIndex := 1;
//      Node.SelectedIndex := Node.ImageIndex;
      qMod.Next;
    until (qMod.Eof);
  end;
end;

procedure TfmSelAllTov.ReadModList;
var
  Node: TTMSFNCTreeViewNode;
begin
  tlMod.Nodes.Clear;
  qKat.Active := false;
  qKat.Prepare;
  qKat.Active := True;
  if qKat.RecordCount > 0 then
  begin
    tlMod.BeginUpdate;
    qKat.First;
    repeat
      if qKat.FieldByName('COUNT_OF_NO_MOD').AsInteger > 0 then
      begin
        Node := tlMod.AddNode();
        Node.DataInteger := qKat.FieldByName('NO_KAT').AsInteger;
        Node.Text[0] := qKat.FieldByName('NAZVAN').AsString;
        Node.DataBoolean := True;
        Node.Values[0].CollapsedIconName := 'Item1';
        Node.Values[0].ExpandedIconName := 'Item1';
        ListChild(Node);
      end;
      qKat.Next;
    until (qKat.Eof);
    tlMod.EndUpdate;
    tlMod.ExpandAll;
    tlMod.SelectNode(tlMod.Nodes[0]);
    showSizeList;
  end;
end;

procedure TfmSelAllTov.showSizeList;
var
  ANode, Node: TTMSFNCTreeViewNode;
begin
  btOK.Enabled := false;
  try
    tlSize.Nodes.Clear;
    ANode := tlMod.FocusedNode;
    if not ANode.DataBoolean then
    begin
      qSize.Close;
      qSize.Prepare;
      qSize.ParamByName('NM').AsInteger := ANode.DataInteger;
      qSize.Active := True;
      if qSize.RecordCount > 0 then
      begin
        qSize.First;
        repeat
          Node := tlSize.AddNode;
          Node.DataInteger := qSize.FieldByName('NO_MST').AsInteger;
          Node.Text[0] := qSize.FieldByName('NO_SIZE').AsInteger.ToString;
          Node.Text[1] := qSize.FieldByName('UN_CODE').AsString;
          Node.Values[0].CollapsedIconName := 'Item3';
          Node.Values[0].ExpandedIconName := 'Item3';
          qSize.Next;
        until (qSize.Eof);
        tlSize.SelectNode(tlSize.Nodes[0]);
        btOK.Enabled := True;
      end;
    end;
  except
  end;
end;

procedure TfmSelAllTov.tlModAfterSelectNode(Sender: TObject; ANode:
  TTMSFNCTreeViewVirtualNode);
begin
  showSizeList;
end;

procedure TfmSelAllTov.tlModGetNodeTextColor(Sender: TObject; ANode:
  TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
begin
  if ANode.Node.DataBoolean then
  begin
    ATextColor := TAlphaColors.Yellow;
  end
  else if ANode.Node.Text[1].ToDouble = 0 then
  begin
    ATextColor := TAlphaColors.Lightgreen;
  end;
end;

procedure TfmSelAllTov.TMSFNCButton1Click(Sender: TObject);
begin
  fmSync := TfmSync.Create(fmSelAllTov);
  fmSync.ShowModal;
  fmSync.Free;
  fmSync:=nil;
end;

function GetAllManualCode: string;
var
  Node: TTMSFNCTreeViewNode;
begin
  Result := '';
  fmSelAllTov := TfmSelAllTov.Create(Application);
  fmSelAllTov.ReadModList;
  if fmSelAllTov.ShowModal = mrOk then
  begin
    Node := fmSelAllTov.tlSize.FocusedNode;
    Result := Node.Text[1];
  end;
  FreeAndNil(fmSelAllTov);
end;

end.

