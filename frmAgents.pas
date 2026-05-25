unit frmAgents;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.TMSFNCButton, FMX.Controls.Presentation, FMX.Edit, FMX.SearchBox,
  FMX.Layouts, FMX.ListBox, System.ImageList, FMX.ImgList, FMX.SVGIconImageList,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Objects,
  FMX.Ani, FMX.TabControl, FMX.TMSFNCCustomComponent, FMX.TMSFNCPopup, FMX.Menus;

type
  TfmAgn = class(TFrame)
    Panel1: TPanel;
    TMSFNCButton5: TTMSFNCButton;
    btSity: TTMSFNCButton;
    tlSity: TListBox;
    SearchBox1: TSearchBox;
    btAgn: TTMSFNCButton;
    Splitter1: TSplitter;
    SVGIconImageList1: TSVGIconImageList;
    qRead: TFDQuery;
    eFind: TEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    tlAgn: TListBox;
    qUsr: TFDQuery;
    ltAgn: TLayout;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ltHeader: TLayout;
    Rectangle2: TRectangle;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image1: TImage;
    BitmapAnimation1: TBitmapAnimation;
    ClearEditButton1: TClearEditButton;
    SearchEditButton1: TSearchEditButton;
    lbFind: TLabel;
    t1: TTimer;
    ppSity: TPopup;
    Panel4: TPanel;
    dxInsSity: TTMSFNCButton;
    dxDelSity: TTMSFNCButton;
    dxUpdSity: TTMSFNCButton;
    ppAg: TPopup;
    Panel5: TPanel;
    dxInsAgn: TTMSFNCButton;
    dxUpdAgn: TTMSFNCButton;
    dxDelAgn: TTMSFNCButton;
    pmAgent: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    TMSFNCButton1: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    TMSFNCButton3: TTMSFNCButton;
    ppTest: TPopup;
    procedure TMSFNCButton5Click(Sender: TObject);
    procedure eFindKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar;
      Shift: TShiftState);
    procedure eFindChange(Sender: TObject);
    procedure t1Timer(Sender: TObject);
    procedure btSityClick(Sender: TObject);
    procedure btAgnClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure TMSFNCButton2Click(Sender: TObject);
    procedure TMSFNCButton3Click(Sender: TObject);
  private
    { Private declarations }
    FSity, FUser: string;
    isHeadSel: Boolean;
    FSelUser: Integer;
    procedure UpdateAgent;
    procedure LoadAgentList;
    procedure DoSelectSity(Sender: TObject);
    procedure DoSelectAgent(Sender: TObject);
     /// <summary>
    /// Начало поиска
    /// </summary>
    procedure StartFind;
  public
    { Public declarations }
    procedure LoadINI;
    procedure SaveINI;
    procedure LoadList;
  end;

var
  fmAgn: TfmAgn;

threadvar
  FPage: Integer;

implementation

uses
  frmMain, frmFullInfoPokup, frmOplata;

{$R *.fmx}

{ TfmAgn }

procedure TfmAgn.btAgnClick(Sender: TObject);
begin
  ppAg.Popup();
end;

procedure TfmAgn.btSityClick(Sender: TObject);
begin
  ppSity.Popup();
end;

procedure TfmAgn.DoSelectAgent(Sender: TObject);
var
  Item: TListBoxItem;
begin
  if Sender is TListBoxItem then
  begin
    Item := Sender as TListBoxItem;
    FSelUser := Item.Tag;
    if not Assigned(fmUserInfo.pnUserInfo) then
    begin
      fmUserInfo.Free;
      Application.ProcessMessages;
      fmUserInfo := TfmUserInfo.Create(ppTest);
      fmUserInfo.pnUserInfo.Parent := ppTest;
    end;
    tlAgn.PopupMenu := pmAgent;
//    ppAgn.ContentControl := fmUserInfo.pnUserInfo;
//    ppAgn.PlacementControl := Item;
//    ppAgn.Popup();
    ppTest.Popup();
    fmUserInfo.ShowInfoUser(Item.Tag);
  end;
end;

procedure TfmAgn.DoSelectSity(Sender: TObject);
begin
  LoadAgentList;
end;

procedure TfmAgn.eFindChange(Sender: TObject);
begin
  t1.Enabled := false;
  Application.ProcessMessages;
  if trim(eFind.Text) <> '' then
  begin
    t1.Enabled := True;
  end
  else
  begin
    if Assigned(tlSity.ItemByIndex(tlSity.ItemIndex)) then
      DoSelectSity(Sender);
  end;
end;

procedure TfmAgn.eFindKeyDown(Sender: TObject; var Key: Word; var KeyChar:
  WideChar; Shift: TShiftState);
begin
  if Key = vkdown then
  begin
    if tlAgn.ItemIndex >= (tlAgn.Items.Count - 1) then
    begin
      Key := 0;
      Exit;
    end;
    tlAgn.ItemIndex := tlAgn.ItemIndex + 1;
    Key := 0;
  end
  else if Key = VKUP then
  begin
    if tlAgn.ItemIndex = 1 then
    begin
      Key := 0;
      Exit;
    end;
    tlAgn.ItemIndex := tlAgn.ItemIndex - 1;
    Key := 0;
  end
  else if Key = vkEscape then
  begin
    Key := 0;
    eFind.Text := '';
  end;
end;

procedure TfmAgn.LoadAgentList;
var
  ANode, Node: TListBoxItem;
  myHeader: TListBoxGroupHeader;
begin
  // ------------------------------------------
  eFind.Text := '';
  FPage := 0;
  Node := tlSity.ItemByIndex(tlSity.ItemIndex);
  eFind.Visible := Node.tag = -1;
  lbFind.Visible := Node.Tag = -1;
  dxUpdSity.Enabled := Node.tag <> -1;
  dxDelSity.Enabled := Node.tag <> -1;
  dxInsAgn.Enabled := Node.tag <> -1;
    // -------------------------------------------
  tlAgn.Items.Clear;
  myHeader := TListBoxGroupHeader.Create(tlAgn);
  myHeader.StyleLookup := 'itemHeader';
  myHeader.CanFocus := False;
  myHeader.Tag := -1;
  tlAgn.AddObject(myHeader);
  qUsr.Close;
  qUsr.Prepare;
  qUsr.ParamByName('NO_SITY').AsInteger := Node.Tag;
  qUsr.ParamByName('AGN').AsString := '';
  qUsr.ParamByName('PG').AsInteger := FPage;
  qUsr.Active := True;
  if qUsr.RecordCount > 0 then
  begin
    qUsr.First;
    try
      tlAgn.BeginUpdate;
      repeat
        ANode := TListBoxItem.Create(tlAgn);
        ANode.StyleLookup := 'AgentIten';
        if Node.Tag = -1 then
        begin
          ANode.Text := qUsr.FieldByName('FULL_NAME').AsString;
        end
        else
        begin
          ANode.Text := qUsr.FieldByName('AG_NAME').AsString;
        end;
        ANode.Tag := qUsr.FieldByName('NO_AGN').AsInteger;
        ANode.StylesData['ItemD'] := qUsr.FieldByName('AG_DOLG').AsFloat;
        ANode.StylesData['ItemP'] := qUsr.FieldByName('AG_PRED').AsFloat;
        ANode.ImageIndex := 0;
//          if qUsr.FieldByName('IS_SKIDKA').AsInteger = 1 then
//            ANode.ImageIndex := 4;
//          ANode.SelectedIndex := ANode.ImageIndex;
//          if ((qUsr.FieldByName('STATUS').isNotNull) and
//            (qUsr.FieldByName('STATUS').AsInteger <> 0)) then
//          begin
//            ANode.OverlayIndex := 13 + qUsr.FieldByName('STATUS').AsInteger;
//          end;
        ANode.OnClick := DoSelectAgent;
        tlAgn.AddObject(ANode);
        qUsr.Next;
      until (qUsr.Eof);
    finally
      tlAgn.EndUpdate;
    end;
    tlAgn.ItemIndex := 1;
  end;
end;

procedure TfmAgn.LoadINI;
begin
  if not Assigned(fmUserInfo) then
  begin
    fmUserInfo := TfmUserInfo.Create(ppTest);
    ppTest.Width := fmUserInfo.pnUserInfo.Width;
    ppTest.Height := fmUserInfo.pnUserInfo.Height;
    fmUserInfo.pnUserInfo.Parent := ppTest;
  end;
  eFind.SetFocus;
  tlSity.Width := myINI.ReadInteger('Pokupateli', 'SityList', 300);
  LoadList;
end;

procedure TfmAgn.LoadList;
var
  Node: TListBoxItem;
begin
  // Это для поиска
  try
    fmMain.StartReadTransaction;
    tlSity.Items.Clear;
    tlSity.BeginUpdate;
    Node := TListBoxItem.Create(tlSity);
    Node.Text := 'Все';
    Node.Tag := -1;
    Node.ImageIndex := 0;
    Node.OnClick := DoSelectSity;
    tlSity.AddObject(Node);
    // -------------------------
    qRead.Close;
    qRead.Active := True;
    if qRead.RecordCount > 0 then
    begin
      repeat
        Node := TListBoxItem.Create(tlSity);
        Node.Text := qRead.FieldByName('ST_NAME').AsString;
        Node.Tag := qRead.FieldByName('NO_ST').AsInteger;
        Node.ImageIndex := 1;
        if qRead.FieldByName('IS_STAR').AsInteger = 1 then
          Node.ImageIndex := 2;
        Node.OnClick := DoSelectSity;
        tlSity.AddObject(Node);
        qRead.Next;
      until qRead.Eof;
      tlSity.ItemIndex := 0;
      LoadAgentList;
    end;
    // -------------------------
  finally
    tlSity.EndUpdate;
    fmMain.EndReadTransaction;
  end;
end;

procedure TfmAgn.MenuItem1Click(Sender: TObject);
begin
  try
    fmOpl := TfmOpl.Create(fmAgn);
    fmOpl.dxRet.Visible := False;
    fmOpl.ReadAgent(FSelUser, 0, now);
    if fmOpl.ShowModal = mrOk then
    begin
     // ReadProd;
    end;
  finally
    fmOpl.Free;
    fmOpl := nil;
  end;
end;

procedure TfmAgn.SaveINI;
begin
  myINI.WriteInteger('Pokupateli', 'SityList', Trunc(tlSity.Width));
  fmUserInfo.Free;
  fmUserInfo := nil;
end;

procedure TfmAgn.StartFind;
var
  ANode: TListboxItem;
  myHeader: TListBoxGroupHeader;
begin
  tlAgn.Items.Clear;
  myHeader := TListBoxGroupHeader.Create(tlAgn);
  myHeader.StyleLookup := 'itemHeader';
  myHeader.CanFocus := False;
  myHeader.Tag := -1;
  tlAgn.AddObject(myHeader);
  qUsr.Close;
  qUsr.Prepare;
  qUsr.ParamByName('NO_SITY').AsInteger := tlSity.ItemByIndex(tlSity.ItemIndex).Tag;
  qUsr.ParamByName('agn').AsString := eFind.Text;
  qUsr.ParamByName('PG').AsInteger := FPage;
  qUsr.Active := True;
  if qUsr.RecordCount > 0 then
  begin
    qUsr.First;
    try
      tlAgn.BeginUpdate;
      repeat
        ANode := TListBoxItem.Create(tlAgn);
        ANode.StyleLookup := 'AgentIten';
        if tlSity.ItemByIndex(tlSity.ItemIndex).Tag = -1 then
        begin
          ANode.Text := qUsr.FieldByName('FULL_NAME').AsString;
        end
        else
        begin
          ANode.Text := qUsr.FieldByName('AG_NAME').AsString;
        end;
        ANode.Tag := qUsr.FieldByName('NO_AGN').AsInteger;
        ANode.StylesData['ItemD'] := qUsr.FieldByName('AG_DOLG').AsFloat;
        ANode.StylesData['ItemP'] := qUsr.FieldByName('AG_PRED').AsFloat;
//          if qUsr.FieldByName('IS_SKIDKA').AsInteger = 1 then
//            ANode.ImageIndex := 4;
//          if ((qUsr.FieldByName('STATUS').isNotNull) and
//            (qUsr.FieldByName('STATUS').AsInteger <> 0)) then
//          begin
//            ANode.OverlayIndex := 13 + qUsr.FieldByName('STATUS').AsInteger;
//          end;
        ANode.OnClick := DoSelectAgent;
        tlAgn.AddObject(ANode);
        qUsr.Next;
      until qUsr.Eof;
    finally
      tlAgn.EndUpdate;
    end;
    tlAgn.ItemIndex := 1;
  end;
end;

procedure TfmAgn.t1Timer(Sender: TObject);
begin
  t1.Enabled := false;
  StartFind;
end;

procedure TfmAgn.TMSFNCButton1Click(Sender: TObject);
begin
  FPage := 0;
  StartFind;
end;

procedure TfmAgn.TMSFNCButton2Click(Sender: TObject);
begin
  FPage := FPage + 10;
  StartFind;
end;

procedure TfmAgn.TMSFNCButton3Click(Sender: TObject);
begin
  FPage := FPage - 10;
  if FPage < 0 then
    FPage := 0;
  StartFind;
end;

procedure TfmAgn.TMSFNCButton5Click(Sender: TObject);
begin
  fmMain.ClearOldFrame;
end;

procedure TfmAgn.UpdateAgent;
var
  Item: TListBoxItem;
begin
  Item := tlAgn.ItemByIndex(tlAgn.ItemIndex);
  try
    Item.BeginUpdate;
  finally
    Item.EndUpdate;
  end;
end;

end.

