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
  DateUtils, FMX.TMSFNCBitmapContainer, FMX.Layouts, FMX.ListBox, FMX.Objects;

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
    OD: TOpenDialog;
    qCodeRead: TFDQuery;
    qInsCode: TFDCommand;
    qTType: TFDQuery;
    qTKat: TFDQuery;
    qUpdKat: TFDCommand;
    qInsKat: TFDCommand;
    lbInfo: TLabel;
    qTAgn: TFDQuery;
    qTSity: TFDQuery;
    qInsSity: TFDCommand;
    qInsAgn: TFDCommand;
    qTVal: TFDQuery;
    qInsVal: TFDCommand;
    qTMod: TFDQuery;
    qModByCode: TFDQuery;
    qUpdMod3: TFDCommand;
    qInsMod: TFDCommand;
    qUpdMod2: TFDCommand;
    qUpdMod: TFDCommand;
    qInsSize: TFDCommand;
    qTZakList: TFDQuery;
    qInsZak: TFDCommand;
    qInsDetZak: TFDCommand;
    qImp: TFDCommand;
    spSetMove: TFDStoredProc;
    Layout1: TLayout;
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure EditButton1Click(Sender: TObject);
    procedure TMSFNCButton4Click(Sender: TObject);
    procedure TMSFNCButton5Click(Sender: TObject);
    procedure tlMoveBeforeExpandNode(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; var ACanExpand: Boolean);
    procedure TMSFNCButton6Click(Sender: TObject);
    procedure btAsseptClick(Sender: TObject);
  private
    { Private declarations }
    FSum: Double;
    function isUzeRead(const Code: string): Boolean;
    function isIgnoreZakaz(CodeZakaz: string): Boolean;
    function GetNoKatByNamme(KatName: string): Integer;
    function GetNoAgnByCode(AgnCode: string): Integer;
    function GetNoSityByCode(CodeSity: string): Integer;
    function GetNoValutByName(NameVal: string): Integer;
    function GetNoModByCode(BarCode: string): Integer;
    function GetNoModByBarcode(BarCodeMod: string): Integer;
     /// <summary>
    /// получение кода типа модели по uin
    /// </summary>
    /// <param name="Barcode">
    /// uin
    /// </param>
    function GetNoTypeByCode(BarCode: string): Integer;
    procedure ReadImpKat(var XMLDoc: TNativeXml; var NodeList: TsdNodeList);
    procedure ReadImpMod(var XMLDoc: TNativeXml; var NodeList: TsdNodeList);
    procedure ReadAgentList(var XMLDoc: TNativeXml; var NodeList: TsdNodeList);
    procedure ReadMoveModelList(var XMLDoc: TNativeXml; var NodeList: TsdNodeList);
    procedure ReadMyZakazList(var XMLDoc: TNativeXml; var NodeList: TsdNodeList; is_Move: Integer);
    /// <summary>
    /// Сохраняем подробности для выбранного заказа
    /// </summary>
    /// <param name="XMLDoc">
    /// Протокол
    /// </param>
    /// <param name="NodeList">
    /// Узел
    /// </param>
    /// <param name="ZakCode">
    /// № заказа
    /// </param>
    procedure SaveZakDetail(var XMLDoc: TNativeXml; ZakCode: string);
    procedure ReadMoveTov(var XMLDoc: TNativeXml; var NodeList: TsdNodeList);
     /// <summary>
    /// Вызов формы для сохранения протокола передачи обуви на магазин
    /// </summary>
    procedure SaveLogMove;
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
  frmSynhro, frmMain, frmSaveMove;

{$R *.fmx}

{ TfmInpMag }

procedure TfmInpMag.btAsseptClick(Sender: TObject);
begin
 if tlMove.Nodes.Count = 0 then
    Exit;
  if ShowQuestion('Принять этот список на склад? Проверте его на правильность. ' +
    'Вы уверены? ') then
  begin
    SaveLogMove;
    // А тут включаем перенос во внутренний журнал
    fmMain.StartMainTransaction;
    spSetMove.Close;
    spSetMove.Prepare;
    spSetMove.Execute;
    fmMain.IBT.Commit;
    ListMoveTov;
  end;
  fmMain.StartReadTransaction;
  fmMain.UpdateSclad;
  Application.ProcessMessages;
  eTxt.SetFocus;
end;

procedure TfmInpMag.EditButton1Click(Sender: TObject);
begin
  InsertTovar;
end;

function TfmInpMag.GetNoAgnByCode(AgnCode: string): Integer;
begin
  Result := -1;
  qTAgn.Close;
  qTAgn.Prepare;
  qTAgn.ParamByName('NG').AsString := AgnCode;
  qTAgn.Active := True;
  if not qTAgn.FieldByName('NO_AGN').IsNull then
  begin
    Result := qTAgn.FieldByName('NO_AGN').AsInteger;
  end;
  qTAgn.Close;
end;

function TfmInpMag.GetNoKatByNamme(KatName: string): Integer;
begin
  Result := -1;
  qTKat.Close;
  qTKat.Prepare;
  qTKat.ParamByName('NT').AsString := KatName;
  qTKat.Active := True;
  if not qTKat.FieldByName('NO_KAT').IsNull then
    Result := qTKat.FieldByName('NO_KAT').AsInteger;
  qTKat.Close;
end;

function TfmInpMag.GetNoModByBarcode(BarCodeMod: string): Integer;
begin
  Result := -1;
  qModByCode.Close;
  qModByCode.Prepare;
  qModByCode.ParamByName('BC').AsString := BarCodeMod;
  qModByCode.Active := True;
  if not qModByCode.FieldByName('NO_MOD').IsNull then
    Result := qModByCode.FieldByName('NO_MOD').AsInteger;
  qModByCode.Close;
end;

function TfmInpMag.GetNoModByCode(BarCode: string): Integer;
begin
  Result := -1;
  qTMod.Close;
  qTMod.Prepare;
  qTMod.ParamByName('UC').AsString := BarCode;
  qTMod.Active := True;
  if not qTMod.FieldByName('NO_MOD').IsNull then
    Result := qTMod.FieldByName('NO_MOD').AsInteger;
  qTMod.Close;
end;

function TfmInpMag.GetNoSityByCode(CodeSity: string): Integer;
begin
  Result := -1;
  qTSity.Close;
  qTSity.Prepare;
  qTSity.ParamByName('NC').AsString := CodeSity;
  qTSity.Active := True;
  if not qTSity.FieldByName('NO_ST').IsNull then
  begin
    Result := qTSity.FieldByName('NO_ST').AsInteger;
  end;
  qTSity.Close;
end;

function TfmInpMag.GetNoTypeByCode(BarCode: string): Integer;
begin
  Result := -1;
  qTType.Close;
  qTType.Prepare;
  qTType.ParamByName('UN').AsString := BarCode;
  qTType.Active := True;
  if not qTType.FieldByName('NO_TM').IsNull then
    Result := qTType.FieldByName('NO_TM').AsInteger;
  qTType.Close;
end;

function TfmInpMag.GetNoValutByName(NameVal: string): Integer;
var
  I: Integer;
begin
  qTVal.Close;
  qTVal.Prepare;
  qTVal.ParamByName('NV').AsString := NameVal;
  qTVal.Active := True;
  if not qTVal.FieldByName('NO_VAL').IsNull then
  begin
    Result := qTVal.FieldByName('NO_VAL').AsInteger;
    qTVal.Close;
  end
  else
  begin
    qInsVal.Active := False;
    qInsVal.Prepare;
    qInsVal.ParamByName('NAZVAN').AsString := NameVal;
    qInsVal.Execute;
    I := qInsVal.ParamByName('NO_VAL').AsInteger;
    fmMain.IBT.CommitRetaining;
    Result := I;
  end;
end;

procedure TfmInpMag.ImportMove;
var
  XMLDoc: TNativeXml; // объект XML-документа
  NodeList: TsdNodeList; // список узлов
  S: string;
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
    try
      XMLDoc.Root.FindNodes('UUID_Move', NodeList);
      S := NodeList.Items[0].Value;
      if isUzeRead(S) then
      begin
        if not ShowQuestion('Этот протокол прочитан ранее.' + ' Вы уверены, что надо его прочитать еще раз?') then
        begin
          Exit;
        end;
      end;
    except
    end;
    // ===========================================================
    try
      fmMain.StartMainTransaction;
      qInsCode.Active := False;
      qInsCode.Prepare;
      qInsCode.ParamByName('CODE_READ').AsString := S;
      qInsCode.Execute;
      fmMain.IBT.Commit;
    except
    end;
    miniLoad := ShowQuestion('Для экономии времени попробовать упрощенный импорт?');
    try
      if not miniLoad then
      begin
        // ---------------------------------------------
        // надо бы проверить список категорий и спрашивать если новая
        lbInfo.Text := 'Чтение списка категорий';
        Application.ProcessMessages;
        ReadImpKat(XMLDoc, NodeList);
        // ----------------------------------------------
        lbInfo.Text := 'Чтение списка покупателей';
        Application.ProcessMessages;
        ReadAgentList(XMLDoc, NodeList);
        lbInfo.Text := 'Чтение списка моделей';
        Application.ProcessMessages;
        ReadMoveModelList(XMLDoc, NodeList);
        Application.ProcessMessages;
      end;
      lbInfo.Text := 'Чтение списка заказов';
      Application.ProcessMessages;
      ReadMyZakazList(XMLDoc, NodeList, 1);

      Application.ProcessMessages;
      lbInfo.Text := 'Чтение списка отправок';
      Application.ProcessMessages;
      ReadMoveTov(XMLDoc, NodeList);
      Application.ProcessMessages;
      fmMain.UpdateSclad;
      Application.ProcessMessages;
    finally
      lbInfo.Text := '';
      try
        NodeList.Free;
        XMLDoc.Free;
      except
      end;
      ListMoveTov;
      eTxt.SetFocus;
    end;
  end;
end;

procedure TfmInpMag.InsertTovar;
var
  isMove, isProd: Boolean;
  FAgn: Integer;
  NAgn: string;
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

function TfmInpMag.isIgnoreZakaz(CodeZakaz: string): Boolean;
begin
  qTZakList.Close;
  qTZakList.Prepare;
  qTZakList.ParamByName('CZ').AsString := CodeZakaz;
  qTZakList.Active := True;
  Result := not qTZakList.FieldByName('NO_ZAK').IsNull;
  qTZakList.Close;
end;

function TfmInpMag.isUzeRead(const Code: string): Boolean;
begin
  qCodeRead.Active := False;
  qCodeRead.Prepare;
  qCodeRead.ParamByName('MCR').AsString := Code;
  qCodeRead.Active := True;
  Result := not qCodeRead.FieldByName('NORP').IsNull;
  qCodeRead.Active := False;
end;

procedure TfmInpMag.ListMoveTov;
var
  Node, TNode: TTMSFNCTreeViewNode;
  item: TListBoxItem;
  I: Integer;
  Data: pNodeData;
begin
  if fmMain.IBT_Read.Active then
  begin
    fmMain.IBT_Read.Rollback;
    Application.ProcessMessages;
    fmMain.IBT_Read.StartTransaction;
  end;
  try
    FSum := 0;
    tlMove.Nodes.Clear;
    tlMove.BeginUpdate;
    qList.Close;
    qList.Prepare;
    qList.Active := True;
    if qList.RecordCount > 0 then
    begin
      qList.First;
      repeat
        Node := tlMove.AddNode();
        Node.Text[0] := '<html>' + qList.FieldByName('m_nazvan').AsString + '<font color = "Yellow"> ( ' + qList.FieldByName('count_of_no_size_mod').AsFloat.ToString + ' ) </font>';
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
  fmMain.IBT_Read.Rollback;
end;

procedure TfmInpMag.LoadINI;
begin
  pnTree.Width := myINI.ReadInteger('Move', 'TreeWidth', 300);
end;

procedure TfmInpMag.ReadAgentList(var XMLDoc: TNativeXml; var NodeList: TsdNodeList);
var
  I: Integer;
  SityCode: string;
  SityName: string;
  AgentCode: string;
  AgentName: string;
  AgentOpis: string;
  isSkidka: Boolean;
  ValName: string;
  NoUser, NoSity: Integer;
begin
  XMLDoc.Root.FindNodes('AgentList', NodeList);
  for I := 0 to NodeList.Count - 1 do
  begin
    SityCode := NodeList.Items[I].AttributeValueByName['SityCode'];
    SityName := NodeList.Items[I].AttributeValueByName['SityName'];
    AgentCode := NodeList.Items[I].AttributeValueByName['AgentCode'];
    AgentName := NodeList.Items[I].AttributeValueByName['AgentName'];
    AgentOpis := NodeList.Items[I].AttributeValueByName['AgentOpis'];
    isSkidka := StrToBool(NodeList.Items[I].AttributeValueByName['isSkidka']);
    ValName := NodeList.Items[I].AttributeValueByName['ValName'];
    // проверяем - если агент есть, то идем далее....
    NoUser := GetNoAgnByCode(AgentCode);
    if NoUser <> -1 then
    begin
      Continue;
    end;
    // если агента нет, то
    // проверяем - этот город есть?
    NoSity := GetNoSityByCode(SityCode);
    if NoSity = -1 then
    begin
      // города тоже нет - вставляем
      fmMain.StartMainTransaction;
      qInsSity.Active := False;
      qInsSity.Prepare;
      qInsSity.ParamByName('ST_NAME').AsString := SityName;
      qInsSity.ParamByName('IS_STAR').AsSmallInt := 0;
      qInsSity.ParamByName('BAR_CODE').AsString := SityCode;
      qInsSity.Execute;
      NoSity := qInsSity.ParamByName('NO_ST').AsInteger;
      fmMain.IBT.Commit;
      Application.ProcessMessages;
    end;
    // вставляем агента. Для скрытия из списка - агенты вставляются с признаком
    // удален.
    fmMain.StartMainTransaction;
    qInsAgn.Active := False;
    qInsAgn.Prepare;
    qInsAgn.ParamByName('PRED_VAL').AsInteger := GetNoValutByName(ValName);
    qInsAgn.ParamByName('AG_NAME').AsString := AgentName;
    qInsAgn.ParamByName('AG_DOP').Value := AgentOpis;
    qInsAgn.ParamByName('IS_SKIDKA').AsSmallInt := isSkidka.ToInteger;
    qInsAgn.ParamByName('BAR_CODE').AsString := AgentCode;
    qInsAgn.ParamByName('NO_SITY').AsInteger := NoSity;
    qInsAgn.Execute;
    fmMain.IBT.Commit;
  end; // for i := 0 to NodeList.Count - 1 do
end;

procedure TfmInpMag.ReadImpKat(var XMLDoc: TNativeXml; var NodeList: TsdNodeList);
var
  I, J: Integer;
  KatName: string;
  KatSkid: Double;
  CodeType: string;
  UInKat: string;
  NoType: Integer;
begin
  XMLDoc.Root.FindNodes('Kat_List', NodeList);
  for I := 0 to NodeList.Count - 1 do
  begin
    KatName := NodeList.Items[I].AttributeValueByName['Name_Kat'];
    KatSkid := StrToFloat(NodeList.Items[I].AttributeValueByName['Sum_Skid']);
    CodeType := NodeList.Items[I].AttributeValueByName['TypeCode'];
    UInKat := NodeList.Items[I].AttributeValueByName['Kode_Kat'];
    NoType := GetNoTypeByCode(CodeType);
    J := GetNoKatByNamme(KatName);
    if J > -1 then
    begin
      // есть категория - проверяем скидки
      fmMain.StartMainTransaction;
      qUpdKat.Active := False;
      qUpdKat.Prepare;
      qUpdKat.ParamByName('NO_KAT').AsInteger := J;
      qUpdKat.ParamByName('SUM_SKID').Value := KatSkid;
      qUpdKat.ParamByName('UIN_KAT').AsString := UInKat;
      qUpdKat.Execute;
      fmMain.IBT.Commit;
    end
    else
    begin
      // Нет категории, вставляем новую
      if ShowQuestion('Добавить категорию: ' + KatName + ' ?') then
      begin
        fmMain.StartMainTransaction;
        qInsKat.Active := False;
        qInsKat.Prepare;
        qInsKat.ParamByName('NAZVAN').AsString := KatName;
        qInsKat.ParamByName('SUM_SKID').Value := KatSkid;
        qInsKat.ParamByName('UIN_KAT').AsString := UInKat;
        qInsKat.ParamByName('NO_TYPE').AsInteger := NoType;
        qInsKat.Execute;
        fmMain.IBT.Commit;
      end;
    end;
  end; // for I:=
end;

procedure TfmInpMag.ReadImpMod(var XMLDoc: TNativeXml; var NodeList: TsdNodeList);
var
  I: Integer;
  KatName, ModName, ModCode: string;
  NoKat: Integer;
  ModCena: Double;
begin
  XMLDoc.Root.FindNodes('ModelList', NodeList);
  for I := 0 to NodeList.Count - 1 do
  begin
    KatName := NodeList.Items[I].AttributeValueByName['KatName'];
    NoKat := GetNoKatByNamme(KatName);
    ModName := NodeList.Items[I].AttributeValueByName['ModName'];
    ModCode := NodeList.Items[I].AttributeValueByName['ModCode'];
    ModCena := StrToFloat(NodeList.Items[I].AttributeValueByName['ModCena']);
    if GetNoModByBarcode(ModCode) > 0 then
    begin
      try
        fmMain.StartMainTransaction;
        Application.ProcessMessages;
        qUpdMod3.ParamByName('NO_MOD').AsInteger := GetNoModByBarcode(ModCode);
        qUpdMod3.ParamByName('NAZVAN').AsString := ModName;
        qUpdMod3.ParamByName('M_CENA').Value := ModCena;
        qUpdMod3.Execute;
        fmMain.IBT.Commit;
      except
      end;
    end
    else
    begin
      //J := fmMain.IBC.Gen_ID('gen_model_table_id', 1);
      fmMain.StartMainTransaction;
      qInsMod.Active := False;
      qInsMod.Prepare;
      qInsMod.ParamByName('NO_KAT').AsInteger := NoKat;
      qInsMod.ParamByName('NAZVAN').AsString := ModName;
      qInsMod.ParamByName('M_CENA').Value := ModCena;
      qInsMod.ParamByName('BARCODE').AsString := ModCode;
      qInsMod.Execute;
      fmMain.IBT.Commit;
    end;
    Application.ProcessMessages;
  end;
end;

procedure TfmInpMag.ReadMoveModelList(var XMLDoc: TNativeXml; var NodeList: TsdNodeList);
var
  I, T: Integer;
  Bar_Code, Name_Kat, Name_Mod, BarCodeMod: string;
  No_Kat, No_Mod: Integer;
  isCena: Boolean;
begin
  // 28.03.2015 спрашиваем нужно ли учитывать цену
  isCena := ShowQuestion('Нужно ли при приеме учитывать цену?');
  // читаем список моделей
  XMLDoc.Root.FindNodes('Model', NodeList);
  // получаем список узлов Item
  for I := 0 to NodeList.Count - 1 do
  begin
    Bar_Code := NodeList.Items[I].AttributeValueByName['ModCode'];
    T := GetNoModByCode(Bar_Code);
    fmMain.StartMainTransaction;
    if T > 0 then
    begin
      if isCena then
      begin
        qUpdMod2.ParamByName('NO_MOD').AsInteger := T;
        qUpdMod2.ParamByName('NAZVAN').AsString := NodeList.Items[I].AttributeValueByName['ModName'];
        qUpdMod2.ParamByName('M_CENA').Value := StrToFloat(NodeList.Items[I].AttributeValueByName['ModCena']);
        qUpdMod2.Execute;
      end
      else
      begin
        qUpdMod.ParamByName('NO_MOD').AsInteger := T;
        qUpdMod.ParamByName('NAZVAN').AsString := NodeList.Items[I].AttributeValueByName['ModName'];
        qUpdMod.Execute;
      end;
      // если такая модель есть, то можно обновить цену и название
      fmMain.IBT.Commit;
    end
    else
    begin
      // если нет, то будем вставлять
      // 1 - ищем модель если она есть - вставляем новый штрих-код
      // иначе вставляем новую модель
      Name_Mod := NodeList.Items[I].AttributeValueByName['ModName'];
      BarCodeMod := NodeList.Items[I].AttributeValueByName['Mod_Barcode'];
      No_Mod := GetNoModByBarcode(BarCodeMod);
      if No_Mod > 0 then
      begin
        // такая модель уже есть, вставляем штрих-код с новым размером  и все
        fmMain.StartMainTransaction;
        qInsSize.Active := False;
        qInsSize.Prepare;
        qInsSize.ParamByName('NO_MOD').AsInteger := No_Mod;
        qInsSize.ParamByName('NO_SIZE').AsInteger := StrToInt(NodeList.Items[I].AttributeValueByName['ModSize']);
        qInsSize.ParamByName('BAR_CODE').AsString := Bar_Code;
        qInsSize.Execute;
        fmMain.IBT.Commit;
      end // if No_Mod > 0 then
      else
      begin
        // если этой модели нет, то процесс удлиняется... :)
        // 2- ищем категорию (она должна быть!)
        Name_Kat := NodeList.Items[I].AttributeValueByName['KatName'];
        No_Kat := GetNoKatByNamme(Name_Kat);
        if No_Kat <= 0 then
        begin
          // тупо пропускаем категории
          // ShowMyError('Категория ' + Name_Kat +
          // ' не найдена. Синхронизируйте справочники!');
        end // if No_Kat <= 0 then
        else
        begin
          fmMain.StartMainTransaction;
          qInsMod.Active := False;
          qInsMod.Prepare;
          qInsMod.ParamByName('NO_KAT').AsInteger := No_Kat;
          qInsMod.ParamByName('NAZVAN').AsString := Name_Mod;
          qInsMod.ParamByName('BARCODE').AsString := NodeList.Items[I].AttributeValueByName['Mod_Barcode'];
          qInsMod.ParamByName('M_CENA').AsFloat := StrToFloat(NodeList.Items[I].AttributeValueByName['ModCena']);
          qInsMod.Execute;
          No_Mod := qInsMod.ParamByName('NO_MOD').AsInteger;
          fmMain.IBT.Commit;
          Application.ProcessMessages;
          fmMain.StartMainTransaction;
          qInsSize.Active := False;
          qInsSize.Prepare;
          qInsSize.ParamByName('NO_MOD').AsInteger := No_Mod;
          qInsSize.ParamByName('NO_SIZE').AsInteger := StrToInt(NodeList.Items[I].AttributeValueByName['ModSize']);
          qInsSize.ParamByName('BAR_CODE').AsString := Bar_Code;
          qInsSize.Execute;
          fmMain.IBT.Commit;
          Application.ProcessMessages;
        end; // if No_Kat > 0 then
      end; // if No_Mod < 0 then
    end; // if T < 0
  end; // for i := 0 to NodeList.Count - 1 do
  Application.ProcessMessages;
  if fmMain.IBT.Active then
    fmMain.IBT.Commit;
end;

procedure TfmInpMag.ReadMoveTov(var XMLDoc: TNativeXml; var NodeList: TsdNodeList);
var
  I: Integer;
begin
  try
    // читаем список передачи
    XMLDoc.Root.FindNodes('Tovar', NodeList);
    // получаем список узлов Item
    fmMain.StartMainTransaction;
    for I := 0 to NodeList.Count - 1 do
    begin
      qImp.Active := False;
      qImp.Prepare;
      qImp.ParamByName('NO_CODE').AsString := NodeList.Items[I].AttributeValueByName['ModNo'];
      qImp.ParamByName('DATA_MOV').AsDate := StrToDate(NodeList.Items[I].AttributeValueByName['Data_Move']);
      qImp.Execute;
    end;
    fmMain.IBT.Commit;
  except
    on E: Exception do
      fmMain.ShowIBError(E.Message);
  end;
end;

procedure TfmInpMag.ReadMyZakazList(var XMLDoc: TNativeXml; var NodeList: TsdNodeList; is_Move: Integer);
var
  Zak_Code: string;
  Mod_Code: string;
  I: Integer;
  J: Double;
  MyDate: tDate;
  Agn_Code: string;
  myIgnore: Boolean;
begin
  fmMain.IBT.StartTransaction;
  Application.ProcessMessages;
  XMLDoc.Root.FindNodes('Zakaz', NodeList);
  for I := 0 to NodeList.Count - 1 do
  begin
    Zak_Code := NodeList[I].AttributeValueByName['ZakCode'];
    Agn_Code := NodeList[I].AttributeValueByName['AgentCode'];
    J := StrToFloat(NodeList[I].AttributeValueByName['CountMod']);
    MyDate := IncDay(Date, 60);
    myIgnore := isIgnoreZakaz(Zak_Code);
    // 25.02.2017 новый заказ вставляем - если его еще не вставляли
    if not myIgnore then
    begin
      fmMain.StartMainTransaction;
      qInsZak.Active := False;
      qInsZak.Prepare;
      qInsZak.ParamByName('CODE_ZAK').AsString := Zak_Code;
      qInsZak.ParamByName('CODE_AGN').AsString := Agn_Code;
      qInsZak.ParamByName('CNT_MOD').Value := J;
      qInsZak.ParamByName('DATA_END').AsDate := MyDate;
      qInsZak.ParamByName('IS_MOVE').AsSmallInt := is_Move;
      qInsZak.Execute;
      fmMain.IBT.Commit;
      Application.ProcessMessages;
      // 25,02,2017 Сохраняем детали заказа сразу после сохранения заказа
      // возможны задержки из-за лишних циклов, но циклы в памяти и не нужен список
      // заказов для игнорирования.
      SaveZakDetail(XMLDoc, Zak_Code);
    end;
  end;
  // for I := 0 to NodeList.Count - 1 do
end;

procedure TfmInpMag.readSclad;
begin
  ListMoveTov;
end;

procedure TfmInpMag.SaveINI;
begin
  myINI.WriteInteger('Move', 'TreeWidth', Trunc(pnTree.Width));
end;

procedure TfmInpMag.SaveLogMove;
begin
  fmSMove := TfmSMove.Create(fmInpMag);
  fmSMove.ShowModal;
  fmSMove.Free;
end;

procedure TfmInpMag.SaveZakDetail(var XMLDoc: TNativeXml; ZakCode: string);
var
  Zak_Code, Mod_Code: string;
  J: Double;
  I: Integer;
  NodeList: TsdNodeList;
begin
  // теперь записываем подробности
  NodeList := TsdNodeList.Create;
  XMLDoc.Root.FindNodes('ZakDetail', NodeList);
  for I := 0 to NodeList.Count - 1 do
  begin
    try
      Zak_Code := NodeList[I].AttributeValueByName['ZakCode'];
      Mod_Code := NodeList[I].AttributeValueByName['ModelCode'];
      J := StrToFloat(NodeList[I].AttributeValueByName['CountModel']);
      if ZakCode = Zak_Code then
      begin
        fmMain.StartMainTransaction;
        qInsDetZak.Active := False;
        qInsDetZak.Prepare;
        qInsDetZak.ParamByName('CODE_ZAK').AsString := Zak_Code;
        qInsDetZak.ParamByName('CODE_MOD').AsString := Mod_Code;
        qInsDetZak.ParamByName('CNT_MOD').Value := J;
        qInsDetZak.Execute;
        fmMain.IBT.Commit;
      end;
    except
    end;
  end;
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
      Data^.ID := 1;
      Data^.NoKey := qDet.FieldByName('no_mod').AsInteger;
      Data^.NoSize := qDet.FieldByName('NO_SIZE_MOD').AsInteger;
      Node.DataPointer := Data;
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

