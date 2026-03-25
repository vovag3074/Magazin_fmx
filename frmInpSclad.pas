unit frmInpSclad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.Controls.Presentation, FMX.TMSFNCButton, FMX.Edit,
  FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCTreeView, FMX.TMSFNCSplitter, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, NativeXml,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCBitmapContainer, FMX.Layouts, FMX.ListBox, FMX.Objects;

type
  TfmInpMag = class(TFrame)
    Panel1: TPanel;
    btAssept: TTMSFNCButton;
    Panel2: TPanel;
    eTxt: TEdit;
    EditButton1: TTMSFNCButton;
    tlMove: TTMSFNCTreeView;
    TMSFNCButton1: TTMSFNCButton;
    pmRep: TPopup;
    pnRep: TPanel;
    TMSFNCButton2: TTMSFNCButton;
    TMSFNCButton3: TTMSFNCButton;
    TMSFNCButton4: TTMSFNCButton;
    pnTree: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    TMSFNCButton5: TTMSFNCButton;
    qList: TFDQuery;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    lbZak: TListBox;
    ListBoxItem1: TListBoxItem;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBoxItem2: TListBoxItem;
    qReadZakaz: TFDQuery;
    Line1: TLine;
    Line2: TLine;
    edSum: TEdit;
    qDet: TFDQuery;
    qIns: TFDCommand;
    TMSFNCButton6: TTMSFNCButton;
    Layout1: TLayout;
    OD: TOpenDialog;
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure EditButton1Click(Sender: TObject);
    procedure TMSFNCButton4Click(Sender: TObject);
    procedure TMSFNCButton5Click(Sender: TObject);
    procedure tlMoveBeforeExpandNode(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; var ACanExpand: Boolean);
    procedure TMSFNCButton6Click(Sender: TObject);
  private
    { Private declarations }
    FSum: Double;
  public
    { Public declarations }
    procedure readSclad;
    procedure LoadINI;
    procedure SaveINI;
    procedure ListMoveTov;
    procedure InsertTovar;
    procedure ImportMove;
  end;

var
  fmInpMag: TfmInpMag;

type
  pNodeData = ^TNodeData;

  tNodeData = record
    NoKey: Integer;
    NoSize: Integer;
    ID: Integer;
  end;

implementation

uses
  frmSynhro, frmMain;

{$R *.fmx}

{ TfmInpMag }

procedure TfmInpMag.EditButton1Click(Sender: TObject);
begin
  InsertTovar;
end;

procedure TfmInpMag.ImportMove;
var
  XMLDoc: TNativeXml; // объект XML-документа
  NodeList: TsdNodeList; // список узлов
  S: String;
  miniLoad: Boolean;
begin
  miniLoad := False;
  if OD.Execute then
  begin
    XMLDoc := TNativeXml.Create(Self); // создаем экземпляр класса
    XMLDoc.BinaryMethod := bmZlib;
    XMLDoc.LoadFromBinaryFile(OD.FileName); // загружаем данные из потока
    if XMLDoc.IsEmpty then
      Exit;
    //XMLDoc.XmlFormat := xfReadable;
    //XMLDoc.SaveToFile('d:\debug.xml');
    NodeList := TsdNodeList.Create;
    // -------------19.07.2013---------------------
//    try
//      XMLDoc.Root.FindNodes('UUID_Move', NodeList);
//      S := NodeList.Items[0].Value;
//      if isUzeRead(S) then
//      begin
//        if not ShowQuestionEx('Этот протокол прочитан ранее.' +
//          ' Вы уверены, что надо его прочитать еще раз?') then
//        begin
//          Exit;
//        end;
//      end;
//    except
//    end;
//    // ===========================================================
//    try
//      fmMain.isShowError := False;
//      qInsCode.Active := False;
//      qInsCode.Prepare;
//      qInsCode.ParamByName('CODE_READ').AsString := S;
//      qInsCode.Execute;
//      fmMain.IBT.Commit;
//    except
//    end;
//     miniLoad := ShowQuestionEx('Для экономии времени попробовать упрощенный импорт?');
//    try
//      if not miniLoad then
//      begin
//        // ---------------------------------------------
//        // надо бы проверить список категорий и спрашивать если новая
//        ShowWaitP(True, 'Чтение списка категорий');
//        ReadImpKat(XMLDoc, NodeList);
//        // ----------------------------------------------
//        ShowWaitP(True, 'Чтение списка покупателей');
//        Application.ProcessMessages;
//        ReadAgentList(XMLDoc, NodeList);
//        ibt_Write.Commit;
//        ShowWaitP(True, 'Чтение списка моделей');
//        Application.ProcessMessages;
//        ReadMoveModelList(XMLDoc, NodeList);
//        ibt_Write.Commit;
//        Application.ProcessMessages;
//      end;
//      ShowWaitP(True, 'Чтение списка заказов');
//      Application.ProcessMessages;
//      ReadMyZakazList(XMLDoc, NodeList, 1);
//      ibt_Write.Commit;
//      Application.ProcessMessages;
//
//      ShowWaitP(True, 'Чтение списка отправок');
//      Application.ProcessMessages;
//      ReadMoveTov(XMLDoc, NodeList);
//      ibt_Write.Commit;
//      Application.ProcessMessages;
//      fmMain.IBT.Commit;
//      Application.ProcessMessages;
//      fmMain.UpdateSclad;
//      Application.ProcessMessages;
//    finally
//      ShowWaitP(False);
//      FreeAndNil(NodeList);
//      FreeAndNil(XMLDoc);
//      ListMoveTov;
//      eTxt.SetFocus;
//    end;
  end;
end;

procedure TfmInpMag.InsertTovar;
var
  isMove, isProd: Boolean;
  FAgn: Integer;
  NAgn: String;
  I: Integer;
begin
  try
    fmMain.TestZakaz(IntToStr(eTxt.Text.ToInt64), isMove, isProd, FAgn, NAgn);
    if isMove then
    begin
     if not ShowQuestion('Заказ №  ' + eTxt.Text + ' уже принимался. Принять еще раз?') then
      begin
        eTxt.Text := '';
        eTxt.SetFocus;
        Exit;
      end;
    end;
    qIns.Active := False;
    fmMain.StartMainTransaction;
    qIns.Prepare;
    qIns.ParamByName('NO_CODE').AsString := IntToStr(eTxt.Text.ToInt64);
    qIns.ParamByName('DT').AsDate := now;
    qIns.Execute;
    fmMain.IBT.Commit;
    eTxt.Text := '';
    ListMoveTov;
    eTxt.SetFocus;
  except
    on E: Exception do
    begin
      eTxt.Text := '';
      eTxt.SetFocus;
      fmMain.ShowIBError(E.Message);
    end;
  end;
end;

procedure TfmInpMag.ListMoveTov;
var
  Node, TNode: TTMSFNCTreeViewNode;
  item: TListBoxItem;
  S: string;
  I: Integer;
  Data: pNodeData;
begin
  try
    FSum := 0;
    S := '';
    try
      if tlMove.Nodes.Count > 0 then
      begin
        Node := tlMove.FocusedNode;
        S := Node.Text[0];
      end;
    except
    end;
    tlMove.BeginUpdate;
    tlMove.Nodes.Clear;
    qList.Close;
    qList.Prepare;
    qList.Active := True;
    if qList.RecordCount > 0 then
    begin
      qList.First;
      repeat
        Node := tlMove.AddNode();
        Node.Text[0] :='<html>'+ qList.FieldByName('m_nazvan').AsString +
        '<font color = "Yellow"> ( ' + qList.FieldByName('count_of_no_size_mod').AsFloat.ToString + ' ) </font>';
        FSum := FSum + qList.FieldByName('count_of_no_size_mod').AsFloat;
        Node.Extended := True;
        TNode := tlMove.AddNode(Node);
        Node.Values[0].CollapsedIconName := 'Item1';
        Node.Values[0].ExpandedIconName := 'Item1';
        Node.DataInteger := qList.FieldByName('no_mod').AsInteger;
        New(Data);
        Data^.ID := 0;
        Data^.NoKey := qList.FieldByName('no_mod').AsInteger;
        Data^.NoSize := -1;
        Node.DataPointer := Data;
        qList.Next;
      until (qList.Eof);
    end;
  finally
    tlMove.EndUpdate;
    if tlMove.Nodes.Count > 0 then
    begin
      tlMove.SelectNode(tlMove.Nodes[0]);
    end;
    if S <> '' then
      tlMove.LookupNode(S, False, 0, False, True, false);
    edSum.Text := FSum.ToString;
  end;
  try
    lbZak.Clear;
    lbZak.BeginUpdate;
    qReadZakaz.Close;
    qReadZakaz.Prepare;
    qReadZakaz.Active := True;
    if qReadZakaz.RecordCount > 0 then
    begin
      qReadZakaz.First;
      repeat
        item := TListBoxItem.Create(lbZak);
        item.StyleLookup := 'ItemZakaz';
        item.Height := 99;
        item.StylesData['CodeZakaz'] := qReadZakaz.FieldByName('CODE_ZAK').AsString;
        item.StylesData['Sity'] := qReadZakaz.FieldByName('ST_NAME').AsString;
        item.Text := qReadZakaz.FieldByName('AG_NAME').AsString;
        item.StylesData['SumZakaz'] := FloatToStr(qReadZakaz.FieldByName('SUM_OF_CNT_MOD').AsFloat);
        lbZak.AddObject(item);
        qReadZakaz.Next;
      until qReadZakaz.Eof;
    end;
  finally
    lbZak.EndUpdate;
    if lbZak.Items.Count > 0 then
    begin
      lbZak.ItemIndex := 0;
    end;
  end;
end;

procedure TfmInpMag.LoadINI;
begin
  pnTree.Width := myINI.ReadInteger('Move', 'TreeWidth', 300);
end;

procedure TfmInpMag.readSclad;
begin
  ListMoveTov;
end;

procedure TfmInpMag.SaveINI;
begin
  myINI.WriteInteger('Move', 'TreeWidth', Trunc(pnTree.Width));
end;

procedure TfmInpMag.tlMoveBeforeExpandNode(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; var ACanExpand: Boolean);
var
  Node: TTMSFNCTreeViewNode;
  Data: pNodeData;
begin
  ANode.Node.RemoveChildren;
  qDet.Close;
  qDet.Prepare;
  qDet.ParamByName('NM').AsInteger := ANode.Node.DataInteger;
  qDet.Active := True;
  if qDet.RecordCount > 0 then
  begin
    qDet.First;
    repeat
      Node := tlMove.AddNode(ANode.Node);
      Node.DataInteger := qDet.FieldByName('no_mod').AsInteger;
      Node.Text[0] := qDet.FieldByName('no_size').AsString;
      Node.Text[1] := qDet.FieldByName('cnt_mod').AsFloat.ToString;
      Node.Values[0].CollapsedIconName := 'Item2';
      Node.Values[0].ExpandedIconName := 'Item2';
      New(Data);
        Data^.ID:=1;
        Data^.NoKey:= qDet.FieldByName('no_mod').AsInteger;
        Data^.NoSize:= qDet.FieldByName('NO_SIZE_MOD').AsInteger;
        Node.DataPointer:=Data;
      qDet.Next;
    until (qDet.Eof);
  end;
  ACanExpand := True;
end;

procedure TfmInpMag.TMSFNCButton1Click(Sender: TObject);
begin
  pmRep.Popup();
end;

procedure TfmInpMag.TMSFNCButton4Click(Sender: TObject);
begin
  fmSync := TfmSync.Create(fmInpMag);
  fmSync.ShowModal;
  fmSync.Free;
end;

procedure TfmInpMag.TMSFNCButton5Click(Sender: TObject);
begin
  fmMain.ClearOldFrame;
end;

procedure TfmInpMag.TMSFNCButton6Click(Sender: TObject);
begin
  ImportMove;
end;

end.

