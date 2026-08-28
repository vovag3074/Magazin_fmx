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
  FMX.Ani, FMX.TabControl, FMX.TMSFNCCustomComponent, FMX.TMSFNCPopup, FMX.Menus,
  FMX.TMSFNCTaskDialog;

type
  TfmAgn = class(TFrame)
    Panel1: TPanel;
    TMSFNCButton5: TTMSFNCButton;
    btSity: TTMSFNCButton;
    tlSity: TListBox;
    sbSity: TSearchBox;
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
    dxDelAgn: TTMSFNCButton;
    dxUpdAgn: TTMSFNCButton;
    pmAgent: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    TMSFNCButton1: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    TMSFNCButton3: TTMSFNCButton;
    ppTest: TPopup;
    btAgnManage: TMenuItem;
    MenuItem5: TMenuItem;
    pmUpdAgn: TMenuItem;
    pmDelAgn: TMenuItem;
    qAddSity: TFDCommand;
    pmSity: TPopupMenu;
    pmInsSity: TMenuItem;
    pmUpdSity: TMenuItem;
    pmDelSity: TMenuItem;
    pmInsAgn: TMenuItem;
    MenuItem8: TMenuItem;
    pmMoveSity: TMenuItem;
    MenuItem10: TMenuItem;
    qReadSity: TFDQuery;
    qUpdSity: TFDCommand;
    qDelSity: TFDCommand;
    qRefAgent: TFDQuery;
    TMSFNCButton4: TTMSFNCButton;
    eSumDolg: TEdit;
    DropDownEditButton1: TDropDownEditButton;
    ppSumDolg: TPopup;
    Panel6: TPanel;
    tlDolg: TListBox;
    qDolg: TFDQuery;
    ltDolg: TLayout;
    Rectangle3: TRectangle;
    Label7: TLabel;
    Label8: TLabel;
    MenuItem4: TMenuItem;
    qDelAgn: TFDCommand;
    qUpdUsrSity: TFDCommand;
    procedure TMSFNCButton5Click(Sender: TObject);
    procedure eFindKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
    procedure t1Timer(Sender: TObject);
    procedure btSityClick(Sender: TObject);
    procedure btAgnClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure TMSFNCButton2Click(Sender: TObject);
    procedure TMSFNCButton3Click(Sender: TObject);
    procedure dxInsSityClick(Sender: TObject);
    procedure pmInsSityClick(Sender: TObject);
    procedure pmUpdSityClick(Sender: TObject);
    procedure dxUpdSityClick(Sender: TObject);
    procedure pmDelSityClick(Sender: TObject);
    procedure dxDelSityClick(Sender: TObject);
    procedure tlAgnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure TMSFNCButton4Click(Sender: TObject);
    procedure pmInsAgnClick(Sender: TObject);
    procedure pmUpdAgnClick(Sender: TObject);
    procedure dxUpdAgnClick(Sender: TObject);
    procedure DropDownEditButton1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure ClearEditButton1Click(Sender: TObject);
    procedure dxDelAgnClick(Sender: TObject);
    procedure pmDelAgnClick(Sender: TObject);
    procedure pmMoveSityClick(Sender: TObject);
  private
    { Private declarations }
    FSity, FUser: string;
    isHeadSel: Boolean;
    FSelUser: Integer;
    procedure UpdSity;
    procedure DelSity;
    procedure LoadAgentList;
    procedure DoSelectSity(Sender: TObject);
    procedure DoSelectAgent(Sender: TObject);
    procedure setSelectAgent;
     /// <summary>
    /// Начало поиска
    /// </summary>
    procedure StartFind;
    /// <summary>
    /// отчеты по покупателям
    /// </summary>
    procedure showRepAgn;
    procedure AddAgent;
    procedure ShowSumDolg;
    /// <summary>
    /// Удалить (спрятать) покупателя
    /// </summary>
    procedure DelAgent;
  public
    { Public declarations }
    procedure LoadINI;
    procedure SaveINI;
    procedure LoadList;
    /// <summary>
    /// обновление выбранного агента
    /// </summary>
    procedure refrSelAgn;
    /// <summary>
    /// редактирование выбранного агента
    /// </summary>
    procedure UpdateAgent;
    /// <summary>
    /// возврат со старой продажи
    /// </summary>
    procedure retOldProd;
    /// <summary>
    /// Поменять город у покупателя
    /// </summary>
    procedure MoveUserSity;
  end;

var
  fmAgn: TfmAgn;

threadvar
  FPage: Integer;
  OldFind: string;

implementation

uses
  frmMain, frmFullInfoPokup, frmOplata, frmAddString, frmReport,
  frmOperationAgent, frmPredoplata, frmReturnProd, frmSelectSity;

{$R *.fmx}

{ TfmAgn }

procedure TfmAgn.AddAgent;
begin
  fmOpAgent := TfmOpAgent.Create(fmMain);
  fmOpAgent.SetSity(tlSity.ItemByIndex(tlSity.ItemIndex).Tag);
  if fmOpAgent.ShowModal = mrOk then
  begin
    LoadAgentList;
  end;
  fmOpAgent.Free;
  fmOpAgent := nil;
end;

procedure TfmAgn.btAgnClick(Sender: TObject);
begin
  ppAg.Popup();
end;

procedure TfmAgn.btSityClick(Sender: TObject);
begin
  ppSity.Popup();
end;

procedure TfmAgn.ClearEditButton1Click(Sender: TObject);
begin
 eFind.Text:='';
 StartFind;
 eFind.SetFocus;
end;

procedure TfmAgn.DelAgent;
begin
  if ShowQuestion('Удалить выбранного агента?') then
  begin
    fmMain.StartMainTransaction;
    qDelAgn.Active := false;
    qDelAgn.Prepare;
    qDelAgn.ParamByName('NG').AsInteger := tlAgn.ItemByIndex(tlAgn.ItemIndex).tag;
    qDelAgn.Execute;
    fmMain.EndMainTransaction;
    LoadAgentList;
  end;
end;

procedure TfmAgn.DelSity;
var
  Item: TListBoxItem;
begin
  Item := tlSity.ItemByIndex(tlSity.ItemIndex);
  if ShowQuestion('Удалить город "' + Item.Text + '"?') then
  begin
    fmMain.StartMainTransaction;
    qDelSity.Prepare;
    qDelSity.ParamByName('STN').AsInteger := Item.Tag;
    qDelSity.Execute;
    fmMain.EndMainTransaction;
    LoadList;
  end;
end;

procedure TfmAgn.DoSelectAgent(Sender: TObject);
begin
  setSelectAgent;
end;

procedure TfmAgn.DoSelectSity(Sender: TObject);
begin
  LoadAgentList;
end;

procedure TfmAgn.DropDownEditButton1Click(Sender: TObject);
begin
  ppSumDolg.Popup();
  ShowSumDolg;
end;

procedure TfmAgn.dxDelAgnClick(Sender: TObject);
begin
 DelAgent;
end;

procedure TfmAgn.dxDelSityClick(Sender: TObject);
begin
  DelSity;
end;

procedure TfmAgn.dxInsSityClick(Sender: TObject);
var
  S: string;
  B: Integer;
begin
  B := 0;
  if GetString(S, 'Новый город', 'Название города') = mrOk then
  begin
    if ShowQuestion('Отметить город "' + S + '" как избранный?') then
    begin
      B := 1;
    end;
    fmMain.StartMainTransaction;
    qAddSity.Active := false;
    qAddSity.Prepare;
    qAddSity.ParamByName('ST_NAME').AsString := S;
    qAddSity.ParamByName('IS_STAR').AsSmallInt := B;
    qAddSity.Execute;
    fmMain.EndMainTransaction;
    LoadList;
    Application.ProcessMessages;
    sbSity.Text := S;
  end;
end;

procedure TfmAgn.dxUpdAgnClick(Sender: TObject);
begin
  UpdateAgent;
end;

procedure TfmAgn.dxUpdSityClick(Sender: TObject);
begin
  UpdSity;
end;

procedure TfmAgn.eFindKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
begin
  t1.Enabled := false;
  Application.ProcessMessages;
  ppTest.IsOpen := False;
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
  else if Key = vkReturn then
  begin
    if eFind.Text = oldFind then
    begin
      DoSelectAgent(Sender);
    end;
  end
  else if Key = vkEscape then
  begin
    if ppTest.IsOpen then
    begin
      ppTest.IsOpen := False;
      Exit;
    end;
    Key := 0;
    eFind.Text := '';
    oldFind := '';
    StartFind;
    Exit;
  end;
  if trim(eFind.Text) <> '' then
  begin
    if eFind.Text <> oldFind then
    begin
      t1.Enabled := True;
    end;
  end;
end;

procedure TfmAgn.LoadAgentList;
var
  ANode, Node: TListBoxItem;
  myHeader: TListBoxGroupHeader;
begin
  // ------------------------------------------
  fmMain.StartReadTransaction;
  eFind.Text := '';
  FPage := 0;
  Node := tlSity.ItemByIndex(tlSity.ItemIndex);
  eFind.Visible := Node.tag = -1;
  lbFind.Visible := Node.Tag = -1;
  dxUpdSity.Enabled := Node.tag <> -1;
  dxDelSity.Enabled := Node.tag <> -1;
  dxInsAgn.Enabled := Node.tag <> -1;
  pmUpdSity.Enabled := Node.tag <> -1;
  pmDelSity.Enabled := Node.tag <> -1;
  pmInsAgn.Enabled := Node.tag <> -1;
    // -------------------------------------------
  tlAgn.Items.Clear;
  FSelUser := -1;
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
  fmMain.EndReadTransaction;
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

 /// <summary>
 /// Оплата текущего долга
 /// </summary>
procedure TfmAgn.MenuItem1Click(Sender: TObject);
begin
  try
    fmOpl := TfmOpl.Create(fmAgn);
    fmOpl.dxRet.Visible := False;
    fmOpl.ReadAgent(tlAgn.ItemByIndex(tlAgn.ItemIndex).Tag, 0, now);
    if fmOpl.ShowModal = mrOk then
    begin
      refrSelAgn;
    end;
  finally
    fmOpl.Free;
    fmOpl := nil;
  end;
end;

procedure TfmAgn.MenuItem3Click(Sender: TObject);
begin
  fmPred := TfmPred.Create(fmAgn);
  fmPred.SetAgent(tlAgn.ItemByIndex(tlAgn.ItemIndex).Tag, now);
  if fmPred.ShowModal = mrOk then
  begin
    refrSelAgn;
  end;
  fmPred.free;
  fmPred:=nil;
end;

procedure TfmAgn.MenuItem4Click(Sender: TObject);
begin
 retOldProd;
end;

procedure TfmAgn.MoveUserSity;
  var
  I: Integer;
begin
  I := GetSityNo;
  if I <> -1 then
  begin
    fmMain.StartMainTransaction;
    qUpdUsrSity.Close;
    qUpdUsrSity.Prepare;
    qUpdUsrSity.ParamByName('NO_AGN').AsInteger := tlAgn.ItemByIndex(tlAgn.ItemIndex).Tag;
    qUpdUsrSity.ParamByName('NO_SITY').AsInteger := I;
    qUpdUsrSity.Execute;
    fmMain.EndMainTransaction;
    refrSelAgn;
  end;
end;

procedure TfmAgn.pmDelAgnClick(Sender: TObject);
begin
 DelAgent;
end;

procedure TfmAgn.pmDelSityClick(Sender: TObject);
begin
  DelSity;
end;

procedure TfmAgn.pmInsAgnClick(Sender: TObject);
begin
  AddAgent;
end;

procedure TfmAgn.pmInsSityClick(Sender: TObject);
begin
  dxInsSityClick(Sender);
end;

procedure TfmAgn.pmMoveSityClick(Sender: TObject);
begin
 MoveUserSity;
end;

procedure TfmAgn.pmUpdAgnClick(Sender: TObject);
begin
  UpdateAgent;
end;

procedure TfmAgn.pmUpdSityClick(Sender: TObject);
begin
  UpdSity;
end;

procedure TfmAgn.refrSelAgn;
var
  ANode: TListBoxItem;
begin
  ANode := tlAgn.ItemByIndex(tlAgn.ItemIndex);
  // читаем имя агента его долг и предоплату
  fmMain.StartReadTransaction;
  qRefAgent.Prepare;
  qRefAgent.ParamByName('NG').AsInteger := ANode.Tag;
  qRefAgent.Active := True;
  if qRefAgent.RecordCount > 0 then
  begin
    ANode.BeginUpdate;
    //ShowMessage(qRefAgent.FieldByName('AG_NAME').AsString+' '+qRefAgent.FieldByName('ST_NAME').AsString);
    ANode.Text := qRefAgent.FieldByName('AG_NAME').AsString + ' ' + qRefAgent.FieldByName('ST_NAME').AsString;
    ANode.StylesData['ItemD'] := qRefAgent.FieldByName('AG_DOLG').AsFloat;
    ANode.StylesData['ItemP'] := qRefAgent.FieldByName('AG_PRED').AsFloat;
    ANode.EndUpdate;
  end;
  qRefAgent.Close;
  fmMain.EndReadTransaction;
end;

procedure TfmAgn.retOldProd;
begin
 fmRetProd := TfmRetProd.Create(fmAgn);
 fmRetProd.SetAgent(tlAgn.ItemByIndex(tlAgn.ItemIndex).Tag);
 if fmRetProd.ShowModal=mrOk then
 begin
   refrSelAgn;
 end;
 fmRetProd.Free;
 fmRetProd:=nil;
end;

procedure TfmAgn.SaveINI;
begin
  myINI.WriteInteger('Pokupateli', 'SityList', Trunc(tlSity.Width));
  fmUserInfo.Free;
  fmUserInfo := nil;
end;

procedure TfmAgn.setSelectAgent;
var
  Item: TListBoxItem;
begin
  Item := tlAgn.ItemByIndex(tlAgn.ItemIndex);
  FSelUser := Item.Tag;
  if not Assigned(fmUserInfo.pnUserInfo) then
  begin
    fmUserInfo.Free;
    Application.ProcessMessages;
    fmUserInfo := TfmUserInfo.Create(ppTest);
    fmUserInfo.pnUserInfo.Parent := ppTest;
  end;
  tlAgn.PopupMenu := pmAgent;
  ppTest.PlacementTarget := Item;
  ppTest.Popup();
  fmUserInfo.ShowInfoUser(Item.Tag);
end;

procedure TfmAgn.showRepAgn;
begin
  ShowReportJson('repAnent*.fr3', '');
end;

procedure TfmAgn.ShowSumDolg;
var
  Node: TListBoxItem;
begin
  tlDolg.Items.Clear;
  qDolg.Close;
  fmMain.StartReadTransaction;
  qDolg.Prepare;
  qDolg.Active := True;
  if qDolg.RecordCount > 0 then
  begin
    qDolg.First;
    repeat
      Node := TListBoxItem.Create(tlDolg);
      Node.StyleLookup := 'sumDolgList';
      Node.Text := qDolg.FieldByName('nazvan').AsString;
      Node.StylesData['sumD'] := qDolg.FieldByName('sum_of_ag_dolg').AsFloat;
      tlDolg.AddObject(Node);
      qDolg.Next;
    until (qDolg.Eof);
    tlDolg.ItemIndex := 0;
  end;
  qDolg.Close;
  fmMain.EndReadTransaction;
end;

procedure TfmAgn.StartFind;
var
  ANode: TListboxItem;
  myHeader: TListBoxGroupHeader;
begin
  tlAgn.Items.Clear;
  FSelUser := -1;
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
  oldFind := eFind.Text;
  StartFind;
end;

procedure TfmAgn.tlAgnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  ClickedItem: TListBoxItem;
begin
  // Check if it's a right-click
  if Button = TMouseButton.mbRight then
  begin
    // Find the item under the local mouse coordinates
    ClickedItem := tlAgn.ItemByPoint(X, Y);

    // Verify an item was actually clicked
    if Assigned(ClickedItem) then
    begin
      // Make the clicked item the active selection
      tlAgn.ItemIndex := ClickedItem.Index;
//      tlAgn.OnClick(Sender);
    end;
  end;
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

procedure TfmAgn.TMSFNCButton4Click(Sender: TObject);
begin
  showRepAgn;
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
  fmOpAgent := TfmOpAgent.Create(fmMain);
  fmOpAgent.SetSity(tlSity.ItemByIndex(tlSity.ItemIndex).Tag);
  fmOpAgent.EditAgent(Item.Tag);
  if fmOpAgent.ShowModal = mrOk then
  begin
    refrSelAgn;
  end;
  fmOpAgent.Free;
  fmOpAgent := nil;
    //------------------------
end;

procedure TfmAgn.UpdSity;
var
  S: string;
  B: Boolean;
begin
  fmMain.StartMainTransaction;
  qReadSity.Close;
  qReadSity.Prepare;
  qReadSity.ParamByName('STN').AsInteger := tlSity.ItemByIndex(tlSity.ItemIndex).Tag;
  qReadSity.Active := True;
  S := qReadSity.FieldByName('ST_NAME').AsString;
  if GetString(S, 'Изменить город', 'Название города') = mrOk then
  begin
    B := ShowQuestion('Отметить город "' + S + '" как избранный?');
  end;
  qUpdSity.Active := false;
  qUpdSity.Prepare;
  qUpdSity.ParamByName('STN').AsInteger := tlSity.ItemByIndex(tlSity.ItemIndex).Tag;
  qUpdSity.ParamByName('ST_NAME').AsString := S;
  qUpdSity.ParamByName('IS_STAR').AsSmallInt := 0;
  if B then
    qUpdSity.ParamByName('IS_STAR').AsSmallInt := 1;
  qUpdSity.Execute;
  fmMain.EndMainTransaction;
  LoadList;
  sbSity.Text := S;
end;

end.

