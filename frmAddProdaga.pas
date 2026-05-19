unit frmAddProdaga;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData,
  FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView, FMX.Edit, FMX.TMSFNCButton,
  System.ImageList, FMX.ImgList, FMX.SVGIconImageList, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Objects, FMX.SearchBox,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer;

type
  TfmAddProdAgn = class(TForm)
    Panel1: TPanel;
    lbZak: TListBox;
    tlList: TTMSFNCTreeView;
    eAgn: TEdit;
    btSelAgn: TEditButton;
    eTxt: TEdit;
    eCena: TEdit;
    TMSFNCButton1: TTMSFNCButton;
    eEnter: TTMSFNCButton;
    eType: TComboBox;
    SVGIconImageList1: TSVGIconImageList;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    qZak: TFDQuery;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    qGetAgn: TFDQuery;
    qMod: TFDQuery;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    qIns: TFDCommand;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    TMSFNCButton3: TTMSFNCButton;
    btSave: TTMSFNCButton;
    qLock: TFDCommand;
    Panel2: TPanel;
    lbSumProd: TLabel;
    ltZak: TLayout;
    TMSFNCButton2: TTMSFNCButton;
    procedure FormCreate(Sender: TObject);
    procedure eTypeChange(Sender: TObject);
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure btSelAgnClick(Sender: TObject);
    procedure lbZakDblClick(Sender: TObject);
    procedure eEnterClick(Sender: TObject);
    procedure TMSFNCButton3Click(Sender: TObject);
    procedure eTxtKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar;
      Shift: TShiftState);
    procedure btSaveClick(Sender: TObject);
  private
    { Private declarations }
    FAgent: Integer;
    FSumTov, FOplTov, FDolg: Double;
    FCount: Integer;
    FNewCashe: Double;
    procedure ShowZakList;
    procedure getAgent(NoAgn: Integer; var NameAgn: string; var isSkidka:
      Boolean; var SumSkidka: Double);
    procedure ListTemp;
  public
    { Public declarations }
  end;

var
  fmAddProdAgn: TfmAddProdAgn;
  ItemS: TSearchBox;

implementation

uses
  frmMain, frmCalc, frmSelectAgent, frmProdaga, frmOplata;

{$R *.fmx}

procedure TfmAddProdAgn.btSelAgnClick(Sender: TObject);
begin
  eAgn.Text := '';
  fmSelAgn := TfmSelAgn.Create(fmAddProdAgn);
  fmSelAgn.LoadList;
  if fmSelAgn.ShowModal = mrOk then
  begin
    eAgn.Text := fmSelAgn.NameAgent;
    FAgent := fmSelAgn.NoAgent;
    if fmSelAgn.isSkidka then
    begin
      eType.ItemIndex := 1;
      eCena.Text := fmSelAgn.SumSkidka.ToString;
    end
    else
    begin
      eType.ItemIndex := 0;
      eCena.Text := '0';
    end;
    fmSelAgn.DisposeOf;
    fmSelAgn := nil;
    ItemS.Text := eAgn.Text;
    ListTemp;
  end;
end;

procedure TfmAddProdAgn.eTxtKeyDown(Sender: TObject; var Key: Word; var KeyChar:
  WideChar; Shift: TShiftState);
begin
  if ((Key = vkSpace) or (Key = vkInsert)) then
  begin
    btSelAgnClick(Sender);
  end;
end;

procedure TfmAddProdAgn.eTypeChange(Sender: TObject);
begin
  eCena.Enabled := eType.ItemIndex > 0;
  btSave.Enabled := eType.ItemIndex = 1;
end;

procedure TfmAddProdAgn.FormCreate(Sender: TObject);
begin
  ItemS := TSearchBox.Create(lbZak);
  ItemS.Height := 33;
  lbZak.AddObject(ItemS);
  FAgent := -1;
  FSumTov := 0;
  FOplTov := 0;
  FDolg := 0;
  tlList.AdaptToStyle := True;
  fmMain.StartReadTransaction;
  ShowZakList;
  ListTemp;
end;

procedure TfmAddProdAgn.getAgent(NoAgn: Integer; var NameAgn: string; var
  isSkidka: Boolean; var SumSkidka: Double);
begin
  qGetAgn.Close;
  qGetAgn.Prepare;
  qGetAgn.ParamByName('NG').AsInteger := NoAgn;
  qGetAgn.Active := True;
  if qGetAgn.FieldByName('IS_DEL').AsInteger = 0 then
  begin
    NameAgn := qGetAgn.FieldByName('FULL_NAME_STD').AsString;
    FAgent := NoAgn;
    isSkidka := qGetAgn.FieldByName('IS_SKIDKA').AsInteger = 1;
    SumSkidka := qGetAgn.FieldByName('SUM_SKIDKA').AsFloat;
  end
  else
  begin
    ShowError('Покупатель ' + qGetAgn.FieldByName('FULL_NAME_STD').AsString +
      ' не доступен. Выберите вручную');
    NameAgn := '';
    isSkidka := false;
    SumSkidka := 0;
    FAgent := -1;
  end;
  qGetAgn.Close;
end;

procedure TfmAddProdAgn.lbZakDblClick(Sender: TObject);
var
  Item: TListBoxItem;
  sumSkid: Double;
  isSkd: Boolean;
  T: string;
begin
  if lbZak.Items.Count > 0 then
  begin
    Item := lbZak.ListItems[lbZak.ItemIndex];
    var S: string;
    S := Item.StylesData['codeZak'].AsString;
    eTxt.Text := S;
    if FAgent <= 0 then
    begin
      getAgent(Item.tag, T, isSkd, sumSkid);
      eAgn.Text := T;
      if isSkd then
      begin
        eType.ItemIndex := 1;
        eCena.Text := sumSkid.ToString;
      end
      else
      begin
        eType.ItemIndex := 0;
        eCena.Text := '0';
      end;
    end;
    ListTemp;
    eTxt.SetFocus;
  end;
end;

procedure TfmAddProdAgn.ListTemp;
var
  Node: TTMSFNCTreeViewNode;
begin
  tlList.Nodes.Clear;
  FSumTov := 0;
  FOplTov := 0;
  FDolg := 0;
  FCount := 0;
  fmMain.StartReadTransaction;
  qMod.Close;
  qMod.Prepare;
  qMod.ParamByName('NG').AsInteger := FAgent;
  qMod.ParamByName('SD').AsDate := StrToDate(fmProd.eData.Text);
  qMod.Active := true;
  if qMod.RecordCount > 0 then
  begin
    qMod.First;
    try
      tlList.BeginUpdate;
      repeat
        Node := tlList.AddNode();
        Node.DataInteger := qMod.FieldByName('NO_MOD').AsInteger;
        Node.Text[0] := qMod.FieldByName('M_NAZVAN').AsString;
        Node.Text[1] := qMod.FieldByName('COUNT_OF_NO_LPT').AsInteger.ToString;
        FCount := FCount + qMod.FieldByName('COUNT_OF_NO_LPT').AsInteger;
        Node.Text[2] := qMod.FieldByName('CENA_PROD').AsFloat.ToString;
        Node.Text[3] := qMod.FieldByName('SUM_PROD').AsFloat.ToString;
        Node.Text[4] := qMod.FieldByName('OPLATA').AsFloat.ToString;
        Node.Text[5] := FloatToStr(qMod.FieldByName('SUM_PROD').AsFloat - qMod.FieldByName
          ('OPLATA').AsFloat);
        Node.Values[0].CollapsedIconName := 'Item1';
        Node.Values[0].ExpandedIconName := 'Item1';
        Node.DataBoolean := True;
        FSumTov := FSumTov + qMod.FieldByName('SUM_PROD').AsFloat;
        FOplTov := FOplTov + qMod.FieldByName('OPLATA').AsFloat;
        FDolg := FDolg + (qMod.FieldByName('SUM_PROD').AsFloat - qMod.FieldByName
          ('OPLATA').AsFloat);
        qMod.Next;
      until (qMod.Eof);
    finally
      tlList.EndUpdate;
      if tlList.Nodes.Count > 0 then
      begin
        tlList.SelectNode(tlList.Nodes[0]);
      end;
    end;
  end;
   lbSumProd.Text := 'Продано: '+FCount.ToString+' | на сумму: '+FSumTov.toString+
      ' | оплачено: '+FOplTov.ToString+' | долг: '+FDolg.ToString;
end;

procedure TfmAddProdAgn.ShowZakList;
var
  Item: TListBoxItem;
begin
  lbZak.Items.Clear;
  ItemS.Text := '';
  fmMain.StartReadTransaction;
  qZak.Close;
  qZak.Prepare;
  qZak.Active := True;
  if qZak.RecordCount > 0 then
  begin
    qZak.First;
    repeat
      Item := TListBoxItem.Create(lbZak);
      Item.StyleLookup := 'zakItem';
      Item.Text := qZak.FieldByName('AG_NAME').AsString + ' ' + qZak.FieldByName
        ('ST_NAME').AsString;
      Item.StylesData['codeZak'] := qZak.FieldByName('CODE_ZAK').AsString;
      Item.StylesData['cntZak'] := qZak.FieldByName('CNT_MOD').AsFloat;
      Item.Tag := qZak.FieldByName('NO_AGN').AsInteger;
      qZak.Next;
      lbZak.AddObject(Item);
    until qZak.Eof;
  end;
  if FAgent > -1 then
  begin
    ItemS.Text := eAgn.Text;
  end;
end;

procedure TfmAddProdAgn.TMSFNCButton1Click(Sender: TObject);
begin
  showCalc(eCena);
end;

procedure TfmAddProdAgn.btSaveClick(Sender: TObject);
begin
  qLock.Close;
  fmMain.StartMainTransaction;
  qLock.Prepare;
  qLock.ParamByName('NO_AGN').AsInteger := FAgent;
  qLock.ParamByName('SUM_SKIDKA').Value := eCena.Text.ToDouble;
  qLock.Execute;
  fmMain.EndMainTransaction;
  eTxt.SetFocus;
end;

procedure TfmAddProdAgn.eEnterClick(Sender: TObject);
var
  isMove, isProd: Boolean;
  FAgn: Integer;
  NAgn: string;
begin
  // 16.03.2019 агент должен быть определен
  if trim(eAgn.Text) = '' then
  begin
    ShowError('Укажите покупателя...');
    Exit;
  end;
  if isLowConnect then
  begin
//    fmLowScan := TfmLowScan.Create(Application);
//    if trim(eTxt.Text) <> '' then
//    begin
//      fmLowScan.AddCode(eTxt.Text, FAgent);
//    end;
//    if fmLowScan.ShowModal = mrOk then
//    begin
//      eTxt.Text := '';
//      eTxt.SetFocus;
//      ListTemp;
//    end;
//    eTxt.Text := '';
//    FreeAndNil(fmLowScan);
  end
  else
  begin
    try
      if trim(eTxt.Text) = '' then
        Exit;
      qIns.Active := false;
      var T: Int64;
      T := eTxt.Text.ToInt64;
      eTxt.Text := T.ToString;
      fmMain.TestZakaz(eTxt.Text, isMove, isProd, FAgn, NAgn);
      if ((isProd) and (FAgn > 0)) then
      begin
        if not ShowQuestion('Заказ №' + eTxt.Text +
          ' уже продавался. Продать еще раз?') then
        begin
          eTxt.Text := '';
          eTxt.SetFocus;
          Exit;
        end;
      end;
      fmMain.StartMainTransaction;
      qIns.Prepare;
      qIns.ParamByName('NO_AGN').AsInteger := FAgent;
      qIns.ParamByName('DATA_PROD').AsDate := StrToDate(fmProd.eData.Text);
      qIns.ParamByName('CODE_MOD').AsString := eTxt.Text;
      qIns.ParamByName('TYPE_PROD').AsInteger := eType.ItemIndex;
      qIns.ParamByName('SUM_TYPE').Value := eCena.Text.ToDouble;
      qIns.ParamByName('OPLATA').Value := 0;
      qIns.Execute;
      fmMain.IBT.Commit;
      // -------------------------
      eTxt.Text := '';
      eTxt.SetFocus;
      ListTemp;
      ShowZakList;
    except
      on E: Exception do
      begin
        fmMain.ShowIBError(E.Message);
        eTxt.Text := '';
        eTxt.SetFocus;
        ListTemp;
      end;
    end;
  end;
end;

procedure TfmAddProdAgn.TMSFNCButton3Click(Sender: TObject);
begin
  if eTxt.Text.Trim <> '' then
  begin
    eEnter.OnClick(Sender);
    Exit;
  end;
  if ((tlList.Nodes.Count > 0) and (FAgent > 0)) then // если что-то продали и агент
  begin // не магазин, то спрашиваем оплату
    try
      fmOpl := TfmOpl.Create(fmAddProdAgn);
      fmOpl.dxRet.Visible := true;
      fmOpl.ReadAgent(FAgent, 0, StrToDate(fmProd.eData.Text));
      if fmOpl.ShowModal = mrOk then
      begin
        ModalResult := mrOk;
      end;
    finally
      fmOpl.Free;
      fmOpl := nil;
    end;
  end
  else
  begin
    ModalResult := mrOk;
  end;
end;

end.

