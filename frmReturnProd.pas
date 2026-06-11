unit frmReturnProd;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCToolBar, FMX.Edit, FMX.TMSFNCButton,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.Comp.Client, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FMX.Objects,
  FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCTreeView, FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer;

type
  TfmRetProd = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    tlProd: TListBox;
    TMSFNCToolBarButton1: TTMSFNCToolBarButton;
    btHist: TTMSFNCToolBarButton;
    eCode: TEdit;
    TMSFNCButton1: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    qAdd: TFDCommand;
    qList: TFDQuery;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ListBoxHeader1: TListBoxHeader;
    Rectangle2: TRectangle;
    qHist: TFDQuery;
    ppHistory: TPopup;
    Panel3: TPanel;
    Panel4: TPanel;
    tlHist: TTMSFNCTreeView;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    btOKSel: TTMSFNCButton;
    eCena: TEdit;
    qUpd_Cena: TFDCommand;
    btCalc: TTMSFNCButton;
    qRet: TFDCommand;
    Layout2: TLayout;
    procedure TMSFNCButton2Click(Sender: TObject);
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure btHistClick(Sender: TObject);
    procedure btOKSelClick(Sender: TObject);
    procedure updateCena;
    procedure btCalcClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCToolBarButton1Click(Sender: TObject);
  private
    { Private declarations }
    FAgent: Integer;
    TranID: string;
    /// <summary>
    ///   показать список товаров по возврату
    /// </summary>
    procedure ListRet;
    procedure selectCena;
    procedure DoSelectCena(Sender: TObject);
  public
    { Public declarations }
     { Public declarations }
    /// <summary>
    ///   ”становить активного агента
    /// </summary>
    /// <param name="NoAgent">
    ///   є агента
    /// </param>
    procedure SetAgent(NoAgent: Integer);
  end;

var
  fmRetProd: TfmRetProd;

implementation

uses
  frmMain, frmCalc;

{$R *.fmx}

procedure TfmRetProd.btCalcClick(Sender: TObject);
begin
  showCalc(eCena);
end;

procedure TfmRetProd.btHistClick(Sender: TObject);
var
  Node: TTMSFNCTreeViewNode;
begin
  tlHist.AdaptToStyle := True;
  tlHist.Nodes.Clear;
  qHist.Close;
  fmMain.StartReadTransaction;
  try
    qHist.Prepare;
    qHist.ParamByName('NG').AsInteger := FAgent;
    qHist.ParamByName('NM').AsInteger := tlProd.ItemByIndex(tlProd.ItemIndex).Tag;
    qHist.Active := True;
    if qHist.RecordCount > 0 then
    begin
      qHist.First;
      repeat
        Node := tlHist.AddNode;
        Node.Text[0] := qHist.FieldByName('M_NAZVAN').AsString;
        Node.Text[1] := DateToStr(qHist.FieldByName('DATA_PROD').AsDateTime);
        Node.Text[2] := qHist.FieldByName('CENA_PROD').AsFloat.ToString;
        Node.Text[3] := qHist.FieldByName('CNT_MOD_PROD').AsInteger.ToString;
        Node.Values[0].CollapsedIconName := 'Item1';
        Node.Values[0].ExpandedIconName := 'Item1';
        qHist.Next;
      until qHist.Eof;
      tlHist.SelectNode(tlHist.Nodes[0]);
      btOKSel.Enabled:=True;
    end;
  except
    on E: Exception do
    begin
      ShowError(E.Message);
    end;
  end;
  fmMain.EndReadTransaction;
  ppHistory.Popup();
end;

procedure TfmRetProd.DoSelectCena(Sender: TObject);
begin
  if Sender is TListBoxItem then
  begin
    selectCena;
  end;
end;

procedure TfmRetProd.FormCreate(Sender: TObject);
begin
  eCena.OnChangeTracking := fmMain.onEditChangeTracking;
end;

procedure TfmRetProd.ListRet;
var
  Node: TListBoxItem;
begin
  fmMain.StartReadTransaction;
  tlProd.Clear;
  qList.Close;
  qList.Prepare;
  qList.ParamByName('NG').AsInteger := FAgent;
  qList.Active := true;
  if qList.RecordCount > 0 then
  begin
    qList.First;
    repeat
      Node := TListBoxItem.Create(tlProd);
      Node.StyleLookup := 'ProdList';
      Node.Tag := qList.FieldByName('NO_MOD').AsInteger;
      Node.TagString := qList.FieldByName('ID_TRANSACTION').AsString;
      Node.Text := qList.FieldByName('NAZVAN').AsString;
      Node.StylesData['prodCnt'] := qList.FieldByName('COUNT_OF_NO_MODSIZ').AsInteger;
      Node.StylesData['prodCena'] := qList.FieldByName('CENA_MOD').AsFloat;
      Node.OnClick := DoSelectCena;
      tlProd.AddObject(Node);
      qList.Next;
    until (qList.Eof);
    tlProd.ItemIndex := 0;
    selectCena;
  end;
  fmMain.EndReadTransaction;
end;

procedure TfmRetProd.selectCena;
var
  Item: TListBoxItem;
begin
  if tlProd.Items.Count > 0 then
  begin
    Item := tlProd.ItemByIndex(tlProd.ItemIndex);
    eCena.Text := Item.StylesData['prodCena'].ToString;
  end;
end;

procedure TfmRetProd.SetAgent(NoAgent: Integer);
begin
  TranID := fmMain.GetTranID;
  FAgent := NoAgent;
  ListRet;
end;

procedure TfmRetProd.TMSFNCButton1Click(Sender: TObject);
var
  S: string;
  I: Integer;
begin
  if eCode.Text.Trim = '' then
  begin
    Exit;
  end;
  S := eCode.Text.Trim;
  repeat
    I := Pos('0', S);
    if I = 1 then
    begin
      Delete(S, 1, 1);
    end;
  until I <> 1;
  // очистили от пробелов и ведущих нулей
  try
    fmMain.StartMainTransaction;
    qAdd.Close;
    qAdd.Prepare;
    qAdd.ParamByName('BAR_CODE').AsString := S;
    qAdd.ParamByName('ID_TRAN').AsString := TranID;
    qAdd.ParamByName('NG').AsInteger := FAgent;
    qAdd.Execute;
    fmMain.EndMainTransaction;
  except
    on E: Exception do
    begin
      fmMain.ShowIBError(E.Message);
    end;
  end;
  eCode.Text := '';
  ListRet;
end;

procedure TfmRetProd.TMSFNCButton2Click(Sender: TObject);
begin
  if tlProd.Items.Count > 0 then
  begin
    if ShowQuestion('¬ернуть модели на склад?') then
    begin
      qRet.Close;
      fmMain.StartMainTransaction;
      qRet.Prepare;
      qRet.ParamByName('NO_AGN').AsInteger := FAgent;
      qRet.ParamByName('TR_ID').AsString := tlProd.ItemByIndex(tlProd.ItemIndex).TagString;
      qRet.Execute;
      fmMain.EndMainTransaction;
      ShowInfo('¬озврат товара с установленной ценой произведен');
      ModalResult := mrOK;
    end
    else
    begin
      ModalResult := mrCancel;
    end;
  end
  else
  begin
    ModalResult := mrCancel;
  end;
end;

procedure TfmRetProd.btOKSelClick(Sender: TObject);
begin
  if tlHist.Nodes.Count > 0 then
  begin
    eCena.Text := tlHist.FocusedNode.Text[2];
    ppHistory.IsOpen := False;
    updateCena;
  end;
end;

procedure TfmRetProd.TMSFNCToolBarButton1Click(Sender: TObject);
begin
  updateCena;
end;

procedure TfmRetProd.updateCena;
begin
  qUpd_Cena.Close;
  fmMain.StartMainTransaction;
  qUpd_Cena.Prepare;
  qUpd_Cena.ParamByName('NO_AGN').AsInteger := FAgent;
  qUpd_Cena.ParamByName('NO_MOD').AsInteger := tlProd.ItemByIndex(tlProd.ItemIndex).Tag;
  qUpd_Cena.ParamByName('TRAN_ID').AsString := tlProd.ItemByIndex(tlProd.ItemIndex).TagString;
  qUpd_Cena.ParamByName('CENA_MOD').value := eCena.Text.ToDouble;
  qUpd_Cena.Execute;
  fmMain.EndMainTransaction;
  ListRet;
end;

end.

