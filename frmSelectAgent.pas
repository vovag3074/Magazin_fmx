unit frmSelectAgent;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.TMSFNCButton,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData,
  FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCBitmapContainer, FMX.TMSFNCPopup;

type
  TfmSelAgn = class(TForm)
    Panel1: TPanel;
    EFindSity: TEdit;
    EditButton1: TEditButton;
    eFind: TEdit;
    EditButton2: TEditButton;
    btFTS: TTMSFNCButton;
    btFTS2: TTMSFNCButton;
    tlSity: TTMSFNCTreeView;
    Splitter1: TSplitter;
    Panel2: TPanel;
    qRead: TFDQuery;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    tlAgn: TTMSFNCTreeView;
    qUsr: TFDQuery;
    TMSFNCButton3: TTMSFNCButton;
    dxAdd: TTMSFNCButton;
    pnFTS: TPanel;
    Panel3: TPanel;
    myFTS: TPopup;
    tlFind: TTMSFNCTreeView;
    qFTS: TFDQuery;
    TMSFNCButton1: TTMSFNCButton;
    btOk2: TTMSFNCButton;
    btOK: TTMSFNCButton;
    TMSFNCButton4: TTMSFNCButton;
    qAddSity: TFDCommand;
    procedure FormCreate(Sender: TObject);
    procedure EFindSityTyping(Sender: TObject);
    procedure EditButton1Click(Sender: TObject);
    procedure tlSityFocusedNodeChanged(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode);
    procedure tlAgnGetNodeTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
    procedure tlAgnGetNodeSelectedTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
    procedure tlAgnGetNodeSelectedColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; var AColor: TTMSFNCGraphicsColor);
    procedure eFindTyping(Sender: TObject);
    procedure btFTSClick(Sender: TObject);
    procedure btFTS2Click(Sender: TObject);
    procedure EditButton2Click(Sender: TObject);
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure btOk2Click(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure eFindKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
    procedure tlAgnDblClick(Sender: TObject);
    procedure tlFindDblClick(Sender: TObject);
    procedure TMSFNCButton3Click(Sender: TObject);
  private
    { Private declarations }
    FAgNo: Integer;
    FAgSkidka: Boolean;
    FSumSkidka: Double;
    FAgName: string;
    procedure goUp;
    procedure goDown;
    procedure ListAgent;
    procedure StartFTS;
    procedure StartFTS2;
  public
    { Public declarations }
    property NoAgent: Integer read FAgNo;
    property isSkidka: Boolean read FAgSkidka;
    property SumSkidka: Double read FSumSkidka;
    property NameAgent: string read FAgName;
    procedure LoadList;
  end;

var
  fmSelAgn: TfmSelAgn;

implementation

uses
  frmMain, frmAddString;

threadvar
  FPage, FSPage: Integer;

{$R *.fmx}

{ TfmSelAgn }

procedure TfmSelAgn.btFTS2Click(Sender: TObject);
begin
  if eFind.Text.Trim = '' then
  begin
    ShowError('Укажите строку для поиска');
    eFind.SetFocus;
  end
  else
  begin
    myFTS.PlacementTarget := btFTS2;
    StartFTS2;
    myFTS.Popup();
  end;
end;

procedure TfmSelAgn.btFTSClick(Sender: TObject);
begin
  if eFind.Text.Trim = '' then
  begin
    ShowError('Укажите начало строки для поиска');
    eFind.SetFocus;
  end
  else
  begin
    myFTS.PlacementTarget := btFTS;
    StartFTS;
    myFTS.Popup();
  end;
end;

procedure TfmSelAgn.btOk2Click(Sender: TObject);
begin
  if myFTS.IsOpen then
  begin
    FAgNo := tlFind.FocusedNode.DataInteger;
    FAgName := tlFind.FocusedNode.Text[0];
    FAgSkidka := tlFind.FocusedNode.DataBoolean;
    FSumSkidka := tlFind.FocusedNode.Text[3].ToDouble;
    ModalResult := mrOk;
  end;
end;

procedure TfmSelAgn.EditButton1Click(Sender: TObject);
begin
  eFindSity.Text := '';
  LoadList;
  EFindSity.SetFocus;
end;

procedure TfmSelAgn.EditButton2Click(Sender: TObject);
begin
  eFind.Text := '';
  LoadList;
  EFind.SetFocus;
end;

procedure TfmSelAgn.eFindKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
begin
  if Key = vkUp then
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
    ListAgent;
    eFind.SetFocus;
  end;
end;

procedure TfmSelAgn.EFindSityTyping(Sender: TObject);
begin
  LoadList;
end;

procedure TfmSelAgn.eFindTyping(Sender: TObject);
begin
  if eFind.Text.Trim <> '' then
  begin
    ListAgent;
  end;
  eFind.SetFocus;
end;

procedure TfmSelAgn.FormCreate(Sender: TObject);
begin
  FPage := 0;
  FSPage := 0;
end;

procedure TfmSelAgn.goDown;
var
  Node: TTMSFNCTreeViewNode;
begin
  Node := tlAgn.GetNextNode(tlAgn.FocusedNode);
  if Assigned(Node) then
  begin
    tlAgn.SelectNode(Node);
    tlAgn.ScrollToNode(Node, True);
  end;
end;

procedure TfmSelAgn.goUp;
var
  Node: tTmsFNCTreeViewNode;
begin
  Node := tlAgn.GetPreviousNode(tlAgn.FocusedNode);
  if Assigned(Node) then
  begin
    tlAgn.SelectNode(Node);
    tlAgn.ScrollToNode(Node, True);
  end;
end;

procedure TfmSelAgn.ListAgent;
var
  ANode: TTMSFNCTreeViewNode;
begin
  try
    FPage := 0;
    tlAgn.Nodes.Clear;
    dxAdd.Enabled := tlSity.FocusedNode.DataInteger > 0;
    qUsr.Close;
    qUsr.Prepare;
    qUsr.ParamByName('NO_SITY').AsInteger := tlSity.FocusedNode.DataInteger;
    qUsr.ParamByName('AGN').AsString := eFind.Text;
    qUsr.ParamByName('PG').AsInteger := FPage;
    qUsr.Active := true;
    if qUsr.RecordCount > 0 then
    begin
      qUsr.First;
     // fmMain.dxUpdSity.Enabled := AFocusedNode.Values[1] <> -1;
     // fmMain.dxDelSity.Enabled := AFocusedNode.Values[1] <> -1;
      try
        tlAgn.BeginUpdate;
        repeat
          ANode := tlAgn.AddNode;
          if tlSity.FocusedNode.DataInteger = -1 then
          begin
            ANode.Text[0] := qUsr.FieldByName('FULL_NAME').AsString;
          end
          else
          begin
            ANode.Text[0] := qUsr.FieldByName('AG_NAME').AsString;
          end;
          ANode.DataInteger := qUsr.FieldByName('NO_AGN').AsInteger;
          ANode.Text[1] := qUsr.FieldByName('AG_DOLG').AsFloat.ToString;
          ANode.Text[2] := qUsr.FieldByName('AG_PRED').AsFloat.ToString;
          ANode.Text[3] := qUsr.FieldByName('SUM_SKIDKA').AsFloat.ToString;
          if qUsr.FieldByName('IS_SKIDKA').AsInteger = 1 then
          begin
            ANode.Values[0].CollapsedIconName := 'Item5';
            ANode.Values[0].ExpandedIconName := 'Item5';
          end
          else
          begin
            ANode.Values[0].CollapsedIconName := 'Item4';
            ANode.Values[0].ExpandedIconName := 'Item4';
          end;
          if not qUsr.FieldByName('STATUS').isNull then
          begin
           // if qUsr.FieldByName('STATUS').AsInteger <> 0 then
           //   ANode.OverlayIndex := 8 + qUsr.FieldByName('STATUS').AsInteger;
          end;
          qUsr.Next;
        until (qUsr.Eof);
      finally
        tlAgn.EndUpdate;
        if tlAgn.Nodes.Count > 0 then
        begin
          tlAgn.SelectNode(tlAgn.Nodes[0]);
        end;
      end;
    end;
  except
  end;
end;

procedure TfmSelAgn.LoadList;
var
  Node: TTMSFNCTreeViewNode;
begin
  tlSity.AdaptToStyle := True;
  tlAgn.AdaptToStyle := True;
  tlFind.AdaptToStyle := True;
  fmMain.StartReadTransaction;
  // Это для поиска
  try
    tlSity.BeginUpdate;
    tlSity.Nodes.Clear;
    if trim(eFindSity.Text) = '' then
    begin
      Node := tlSity.AddNode();
      Node.Text[0] := 'Все';
      Node.DataInteger := -1;
      Node.Values[0].CollapsedIconName := 'Item1';
      Node.Values[0].ExpandedIconName := 'Item1';
    end;
    // -------------------------
    qRead.Close;
    qRead.Prepare;
    qRead.ParamByName('SK').AsInteger := FSPage;
    qRead.ParamByName('FNDSITY').AsString := trim(eFindSity.Text);
    qRead.Active := true;
    if qRead.RecordCount > 0 then
    begin
      repeat
        Node := tlSity.AddNode;
        Node.Text[0] := qRead.FieldByName('ST_NAME').AsString;
        Node.DataInteger := qRead.FieldByName('NO_ST').AsInteger;
        Node.Values[0].CollapsedIconName := 'Item2';
        Node.Values[0].ExpandedIconName := 'Item2';
        if qRead.FieldByName('IS_STAR').AsInteger = 1 then
        begin
          Node.Values[0].CollapsedIconName := 'Item3';
          Node.Values[0].ExpandedIconName := 'Item3';
        end;
        qRead.Next;
      until qRead.Eof;
    end;
    // -------------------------
    if tlSity.Nodes.Count > 0 then
    begin
      tlSity.SelectNode(tlSity.Nodes[0]);
      ListAgent;
    end;
  finally
    tlSity.EndUpdate;
  end;
  fmMain.IBT_Read.Rollback;
end;

procedure TfmSelAgn.StartFTS;
const
  myWhere = ' join FTS$POKUPATEL$WRD FTS$POKUPATEL$WRD$$ on FTS$POKUPATEL$WRD$$.FTS$WRD starting ''%%'' and ' + 'FTS$POKUPATEL$WRD$$.FTS$NO_AGN = AGENTS.NO_AGN ';
  myQuery = 'select first (10) skip (:PG) NO_AGN, ' + 'NO_SITY, ' + 'AG_NAME, ' + 'AG_DOLG, ' + 'AG_PRED, ' + 'FULL_NAME as Upper_full_name, ' + 'STATUS, ' + 'ST_NAME, ' + 'Sum_Skidka, ' + 'IS_SKIDKA, ' + '(AG_NAME || '' '' || ST_NAME) as FULL_NAME ' + 'from SITY_TABLE, AGENTS ';
  EndQuery_1 = 'where AGENTS.IS_DEL = 0 and ' + 'AGENTS.NO_SITY = SITY_TABLE.NO_ST ';
  EndQuery_2 = 'where AGENTS.IS_DEL = 0 and AGENTS.NO_SITY = :NS and' + 'AGENTS.NO_SITY = SITY_TABLE.NO_ST ';
var
  S: string;
  SL: tStringList;
  I: Integer;
  Node: TTMSFNCTreeViewNode;
begin
  tlFind.Nodes.Clear;
  qFTS.Close;
  qFTS.SQL.Clear;
  S := StringReplace(myQuery, ':PG', IntTostr(FPage), [rfReplaceAll]);
  qFTS.SQL.Add(S);
  SL := tStringList.Create;
  SL.Delimiter := ' ';
  SL.DelimitedText := eFind.Text;
  for I := 0 to SL.Count - 1 do
  begin
    S := StringReplace(myWhere, '%%', SL.Strings[I], [rfReplaceAll]);
    S := StringReplace(S, '$$', IntTostr(I), [rfReplaceAll]);
    qFTS.SQL.Add(S);
  end;
  if tlSity.FocusedNode.DataInteger <= 0 then
  begin
    qFTS.SQL.Add(EndQuery_1);
  end
  else
  begin
    S := StringReplace(EndQuery_2, ':NS', tlSity.DataInteger.ToString, [rfReplaceAll]);
    qFTS.SQL.Add(EndQuery_2);
  end;
  qFTS.Prepare;
  qFTS.Active := true;
  if qFTS.RecordCount > 0 then
  begin
    qFTS.First;
    repeat
      Node := tlFind.AddNode;
      Node.DataInteger := qFTS.FieldByName('NO_AGN').AsInteger;
      Node.Text[0] := qFTS.FieldByName('FULL_NAME').AsString;
      Node.Text[1] := qFTS.FieldByName('AG_DOLG').AsFloat.ToString;
      Node.Text[2] := qFTS.FieldByName('AG_PRED').AsFloat.ToString;
      if qFTS.FieldByName('IS_SKIDKA').AsInteger = 1 then
      begin
        Node.Values[0].CollapsedIconName := 'Item5';
        Node.Values[0].ExpandedIconName := 'Item5';
      end
      else
      begin
        Node.Values[0].CollapsedIconName := 'Item4';
        Node.Values[0].ExpandedIconName := 'Item4';
      end;
      Node.Text[3] := qFTS.FieldByName('Sum_Skidka').AsFloat.ToString;
      Node.DataBoolean := qFTS.FieldByName('IS_SKIDKA').AsInteger = 1;
      qFTS.Next;
    until qFTS.Eof;
    if tlFind.Nodes.Count > 0 then
    begin
      tlFind.SelectNode(tlFind.Nodes[0]);
    end;
    btOK2.Enabled := tlFind.Nodes.Count > 0;
  end;
end;

procedure TfmSelAgn.StartFTS2;
const
  myWhere = ' FROM AGENTS JOIN FTS$POKUPATEL$WRD FTS$POKUPATEL$WRD0 ' + ' ON FTS$POKUPATEL$WRD0.FTS$SYN STARTING WITH ''%%'' ' + ' AND FTS$POKUPATEL$WRD0.FTS$NO_AGN = AGENTS.NO_AGN ' + ' WHERE AGENTS.IS_DEL = 0 ' + ' PLAN JOIN ( FTS$POKUPATEL$WRD0 INDEX ( FTS$POKUPATEL$SYN ), ' + ' AGENTS INDEX ( PK_AGENTS ) ) ';
  myQuery = ' SELECT first (10) skip(:PG) AGENTS.NO_AGN, AGENTS.FULL_NAME_STD, ' + ' AGENTS.AG_DOLG, AGENTS.AG_PRED, AGENTS.AG_BANK_PRED ' + ' , AGENTS.SUM_SKIDKA, AGENTS.IS_SKIDKA ';
var
  S: string;
  I: Integer;
  Node: TTMSFNCTreeViewNode;
begin
  tlFind.Nodes.Clear;
  qFTS.Close;
  qFTS.SQL.Clear;
  S := StringReplace(myQuery, ':PG', IntTostr(FPage), [rfReplaceAll]);
  qFTS.SQL.Add(S);
  S := StringReplace(myWhere, '%%', eFind.Text, [rfReplaceAll]);
  qFTS.SQL.Add(S);
  qFTS.Prepare;
 // ShowInfoEx('1');
  qFTS.Active := true;
  if qFTS.RecordCount > 0 then
  begin
    qFTS.First;
    repeat
      Node := tlFind.AddNode;
      Node.DataInteger := qFTS.FieldByName('NO_AGN').AsInteger;
      Node.Text[0] := qFTS.FieldByName('FULL_NAME_STD').AsString;
      Node.Text[1] := qFTS.FieldByName('AG_DOLG').AsFloat.ToString;
      Node.Text[2] := FloatToStr(qFTS.FieldByName('AG_PRED').AsFloat + qFTS.FieldByName('AG_BANK_PRED').asFloat);
      if qFTS.FieldByName('IS_SKIDKA').AsInteger = 1 then
      begin
        Node.Values[0].CollapsedIconName := 'Item5';
        Node.Values[0].ExpandedIconName := 'Item5';
      end
      else
      begin
        Node.Values[0].CollapsedIconName := 'Item4';
        Node.Values[0].ExpandedIconName := 'Item4';
      end;
      Node.Text[3] := qFTS.FieldByName('Sum_Skidka').AsFloat.ToString;
      Node.DataBoolean := qFTS.FieldByName('IS_SKIDKA').AsInteger = 1;
      qFTS.Next;
    until qFTS.Eof;
    if tlFind.Nodes.Count > 0 then
    begin
      tlFind.SelectNode(tlFind.Nodes[0]);
    end;
    btOK2.Enabled := tlFind.Nodes.Count > 0;
  end;
end;

procedure TfmSelAgn.tlAgnDblClick(Sender: TObject);
begin
  btOKClick(Sender);
end;

procedure TfmSelAgn.tlAgnGetNodeSelectedColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; var AColor: TTMSFNCGraphicsColor);
begin
  if ANode.Node.Text[2].ToDouble > 0 then
  begin
    AColor := TAlphaColors.Aqua;
  end;
  if ANode.Node.Text[1].ToDouble > 0 then
  begin
    AColor := TAlphaColors.Magenta;
  end;
end;

procedure TfmSelAgn.tlAgnGetNodeSelectedTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
begin
  if ANode.Node.Text[2].ToDouble > 0 then
  begin
    ATextColor := TAlphaColors.Black;
  end;
  if ANode.Node.Text[1].ToDouble > 0 then
  begin
    ATextColor := TAlphaColors.Black;
  end;
end;

procedure TfmSelAgn.tlAgnGetNodeTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
begin
  if ANode.Node.Text[2].ToDouble > 0 then
  begin
    ATextColor := TAlphaColors.Aqua;
  end;
  if ANode.Node.Text[1].ToDouble > 0 then
  begin
    ATextColor := TAlphaColors.Magenta;
  end;
end;

procedure TfmSelAgn.tlFindDblClick(Sender: TObject);
begin
  btOk2Click(Sender);
end;

procedure TfmSelAgn.tlSityFocusedNodeChanged(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode);
begin
  eFind.Text := '';
  ListAgent;
end;

procedure TfmSelAgn.TMSFNCButton1Click(Sender: TObject);
begin
  myFTS.IsOpen := False;
end;

procedure TfmSelAgn.TMSFNCButton3Click(Sender: TObject);
var SityStr:string;
    isFav:Boolean;
begin
 if GetString(SityStr,'Новый город', 'Название города') = mrOk  then
 begin
   isFav := ShowQuestion('Добавить город '+SityStr+' как избранный?');
   fmMain.StartMainTransaction;
    qAddSity.Active := false;
    qAddSity.Prepare;
    qAddSity.ParamByName('ST_NAME').AsString := SityStr;
    qAddSity.ParamByName('IS_STAR').AsSmallInt := 0;
    if isFav then
      qAddSity.ParamByName('IS_STAR').AsSmallInt := 1;
    qAddSity.Execute;
   fmMain.IBT.Commit;
   LoadList;
   tlSity.LookupNode(SityStr, False, 0, False, true);
 end;
end;

procedure TfmSelAgn.btOKClick(Sender: TObject);
begin
  FAgNo := tlAgn.FocusedNode.DataInteger;
  FAgName := tlAgn.FocusedNode.Text[0];
  if tlSity.FocusedNode.DataInteger <> -1 then
  begin
    FAgName := tlAgn.FocusedNode.Text[0] + ' (' + tlSity.FocusedNode.Text[0] + ')';
  end;
  FAgSkidka := tlAgn.FocusedNode.DataBoolean;
  FSumSkidka := tlAgn.FocusedNode.Text[3].ToDouble;
  ModalResult := mrOk;
end;

end.

