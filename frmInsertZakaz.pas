unit frmInsertZakaz;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.DateTimeCtrls,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCTreeView, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer,
  FMX.TMSFNCButton;

type
  TfmInsZak = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    eAgn: TEdit;
    Panel3: TPanel;
    eData: TDateEdit;
    eDop: TEdit;
    EllipsesEditButton1: TEllipsesEditButton;
    SearchEditButton1: TSearchEditButton;
    tlMod: TTMSFNCTreeView;
    qMod: TFDQuery;
    qRead: TFDQuery;
    qSize: TFDQuery;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCButton1: TTMSFNCButton;
    dxDel: TTMSFNCButton;
    dxUpd: TTMSFNCButton;
    qIns: TFDCommand;
    qUpd: TFDCommand;
    TMSFNCButton3: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    HintPanel: TCalloutPanel;
    HintLabel: TLabel;
    eCode: TEdit;
    EditButton1: TTMSFNCButton;
    procedure FormCreate(Sender: TObject);
    procedure tlModBeforeExpandNode(Sender: TObject; ANode:
      TTMSFNCTreeViewVirtualNode; var ACanExpand: Boolean);
    procedure tlModGetNodeTextColor(Sender: TObject; ANode:
      TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
    procedure tlModGetNodeSelectedTextColor(Sender: TObject; ANode:
      TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
    procedure tlModGetNodeSelectedColor(Sender: TObject; ANode:
      TTMSFNCTreeViewVirtualNode; var AColor: TTMSFNCGraphicsColor);
    procedure SearchEditButton1Click(Sender: TObject);
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure TMSFNCButton3Click(Sender: TObject);
    procedure TMSFNCButton1MouseEnter(Sender: TObject);
    procedure TMSFNCButton1MouseLeave(Sender: TObject);
  private
    { Private declarations }
    FAgent, FZakaz: Integer;
    isEdit: Boolean;
    FCount: Double;
    FSumMod: Double;
    procedure ReadModelList;
    function isSave: Boolean;
    procedure readMyModel(BarCode:String);
  public
    { Public declarations }
    procedure EditZakaz(NoZakaz: Integer);
  end;

var
  fmInsZak: TfmInsZak;

type
  pNodeData = ^tNodeData;

  tNodeData = record
    ID_Model: Integer;
    ID_Size: Integer;
    ID_Code: string;
  end;

implementation

uses
  frmMain, frmZakazy, frmSelectAgent, frmOplata, frmReport, frmSelectAllTovar, frmSelectSize;

{$R *.fmx}

procedure TfmInsZak.EditZakaz(NoZakaz: Integer);
begin
  FZakaz := NoZakaz;
  isEdit := true;
  Caption := 'Изменить заказ';
  qRead.Close;
  qRead.Prepare;
  qRead.ParamByName('SZ').AsInteger := FZakaz;
  qRead.Active := true;
  FAgent := qRead.FieldByName('NO_AGN').AsInteger;
  eAgn.Text := qRead.FieldByName('Full_AG_Name').AsString;
  eData.Date := qRead.FieldByName('DATA_OTP').AsDateTime;
  eDop.Text := qRead.FieldByName('PRIM_ZAK').AsString;
  ReadModelList;
end;

procedure TfmInsZak.FormCreate(Sender: TObject);
begin
  tlMod.AdaptToStyle := True;
  eData.Date := StrToDate(fmZak.eData.Text);
  isEdit := false;
  FCount := 0;
  Caption := 'Новый заказ';
  ReadModelList;
end;

function TfmInsZak.isSave: Boolean;
begin
  Result := false;
  if FAgent = -1 then
  begin
    ShowError('Выберите покупателя!');
    eAgn.SetFocus;
    Exit;
  end;
  fmMain.StartMainTransaction;
  if isEdit then
  begin
    qUpd.ParamByName('SZ').AsInteger := FZakaz;
    qUpd.ParamByName('NO_AGN').AsInteger := FAgent;
    qUpd.ParamByName('DATA_OTP').AsDate := eData.Date;
    qUpd.ParamByName('PRIM_ZAK').AsString := eDop.Text;
    qUpd.Execute;
    Result := true;
  end
  else
  begin
    qIns.ParamByName('NO_AGN').AsInteger := FAgent;
    qIns.ParamByName('DATA_OTP').AsDate := eData.Date;
    qIns.ParamByName('PRIM_ZAK').AsString := eDop.Text;
    qIns.Execute;
    FZakaz := qIns.ParamByName('NO_SZ').AsInteger;
    Result := true;
    isEdit := true;
  end;
  fmMain.EndMainTransaction;
end;

procedure TfmInsZak.ReadModelList;
var
  Node: TTMSFNCTreeViewNode;
  Data: pNodeData;
begin
  tlMod.Nodes.Clear;
  FCount := 0;
  FSumMod := 0;
  if isEdit then
  begin
    qMod.Close;
    fmMain.StartReadTransaction;
    qMod.Prepare;
    qMod.ParamByName('NZ').AsInteger := FZakaz;
    qMod.Active := true;
    if qMod.RecordCount > 0 then
    begin
      qMod.First;
      repeat
        Node := tlMod.AddNode;
        Node.Text[0] := qMod.FieldByName('M_NAZVAN').AsString;
        Node.Text[1] := qMod.FieldByName('SUM_OF_CNT_MOD').AsFloat.ToString;
        Node.Text[2] := qMod.FieldByName('M_CENA').AsFloat.ToString;
        FCount := FCount + qMod.FieldByName('SUM_OF_CNT_MOD').AsFloat;
        FSumMod := FSumMod + (qMod.FieldByName('M_CENA').AsFloat * qMod.FieldByName
          ('SUM_OF_CNT_MOD').AsFloat);
        Node.Values[0].CollapsedIconName := 'Item1';
        Node.Values[0].ExpandedIconName := 'Item1';
        new(Data);
        Data^.ID_Model := qMod.FieldByName('NO_MOD').AsInteger;
        Data^.ID_Size := -1;
        Data^.ID_Code := qMod.FieldByName('CODE_MOD').AsString;
        tlMod.AddNode(Node);
        Node.DataPointer := Data;
        Node.DataBoolean := True;
        qMod.Next;
      until (qMod.Eof);
      tlMod.SelectNode(tlMod.Nodes[0]);
    end;
  end;
  fmMain.EndReadTransaction;
  dxUpd.Enabled := tlMod.Nodes.Count > 0;
  dxDel.Enabled := tlMod.Nodes.Count > 0;
end;

procedure TfmInsZak.readMyModel(BarCode: String);
begin
//  ShowInfo(BarCode);
 if GetMyZize(BarCode, FZakaz) = mrOk then
  begin
    ReadModelList;
  end;
end;

procedure TfmInsZak.SearchEditButton1Click(Sender: TObject);
begin
  eAgn.Text := '';
  fmSelAgn := TfmSelAgn.Create(fmInsZak);
  fmSelAgn.LoadList;
  if fmSelAgn.ShowModal = mrOk then
  begin
    eAgn.Text := fmSelAgn.NameAgent;
    FAgent := fmSelAgn.NoAgent;
  end;
  fmSelAgn.DisposeOf;
  fmSelAgn := nil;
  eCode.SetFocus;
end;

procedure TfmInsZak.tlModBeforeExpandNode(Sender: TObject; ANode:
  TTMSFNCTreeViewVirtualNode; var ACanExpand: Boolean);
var
  Node: TTMSFNCTreeViewNode;
  Data, AData: pNodeData;
begin
  ANode.Node.RemoveChildren;
  AData := ANode.Node.DataPointer;
  qSize.Close;
  qSize.Prepare;
  qSize.ParamByName('NM').AsInteger := AData^.ID_Model;
  qSize.ParamByName('SZ').AsInteger := FZakaz;
  qSize.Active := true;
  if qSize.RecordCount > 0 then
  begin
    qSize.First;
    repeat
      Node := tlMod.AddNode(ANode.Node);
      Node.Text[0] := qSize.FieldByName('NO_SIZE').AsInteger.ToString;
      Node.Text[1] := qSize.FieldByName('CNT_MOD').AsFloat.ToString;
      Node.Values[0].CollapsedIconName := 'Item2';
      Node.Values[0].ExpandedIconName := 'Item2';
      new(Data);
      Data^.ID_Model := AData^.ID_Model;
      Data^.ID_Size := qSize.FieldByName('NO_SZD').AsInteger;
      Data^.ID_Code := qSize.FieldByName('UN_CODE').AsString;
      Node.DataPointer := Data;
      Node.DataBoolean := False;
      qSize.Next;
    until (qSize.Eof);
  end;
end;

procedure TfmInsZak.tlModGetNodeSelectedColor(Sender: TObject; ANode:
  TTMSFNCTreeViewVirtualNode; var AColor: TTMSFNCGraphicsColor);
begin
  if ANode.Node.DataBoolean then
  begin
    AColor := TAlphaColors.Black;
  end;
end;

procedure TfmInsZak.tlModGetNodeSelectedTextColor(Sender: TObject; ANode:
  TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
begin
  if ANode.Node.DataBoolean then
  begin
    ATextColor := TAlphaColors.Yellow;
  end;
end;

procedure TfmInsZak.tlModGetNodeTextColor(Sender: TObject; ANode:
  TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
begin
  if ANode.Node.DataBoolean then
  begin
    ATextColor := TAlphaColors.Yellow;
  end;
end;

procedure TfmInsZak.TMSFNCButton1Click(Sender: TObject);
var
  S: string;
begin
  if isSave then
  begin
    S:=GetAllManualCode;
    eCode.Text := S;
    ReadMyModel(S);
    eCode.Text := '';
    eCode.SetFocus;
  end;
end;

procedure TfmInsZak.TMSFNCButton1MouseEnter(Sender: TObject);
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
      HintPanel.Position.Y := p.Top - (HintPanel.Height / 2) - (TControl(Sender).Height
        / 2) + 50;
      HintPanel.Width := HintPanel.Width + HintPanel.CalloutLength;
      HintLabel.Padding.Left := HintPanel.CalloutLength;
      HintLabel.Padding.Top := -HintPanel.CalloutLength;
    end;
    HintPanel.BringToFront;
    HintPanel.Visible := True;
    HintLabel.Text := s;
  end;
end;

procedure TfmInsZak.TMSFNCButton1MouseLeave(Sender: TObject);
begin
  HintPanel.Visible := false;
end;

procedure TfmInsZak.TMSFNCButton3Click(Sender: TObject);
begin
  if isSave then
  begin
    try
      fmOpl := TfmOpl.Create(fmZak);
      fmOpl.ReadAgent(FAgent, 0, Date);
      fmOpl.PrintCheck := false; // чек не нужен
      fmOpl.ShowModal;
    finally
      FreeAndNil(fmOpl);
    end;
    if ShowQuestion('Напечатать чек заказа?') then
    begin
      PrintReportJson('ShUserZakInfo.fr3', '[{"NZ":"' + IntToStr(FZakaz) + '"}]');
    end;
    ModalResult := mrOk;
  end;
end;

end.

