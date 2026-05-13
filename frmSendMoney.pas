unit frmSendMoney;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox,
  FMX.StdCtrls, FMX.TMSFNCButton, FMX.Controls.Presentation, FMX.Edit,
  System.ImageList, FMX.ImgList, FMX.SVGIconImageList, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.Comp.Client,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet;

type
  TfmSndMoney = class(TForm)
    eVal: TComboBox;
    eSum: TEdit;
    TMSFNCButton6: TTMSFNCButton;
    ePol: TEdit;
    TMSFNCButton1: TTMSFNCButton;
    SVGIconImageList2: TSVGIconImageList;
    Panel1: TPanel;
    dxOK: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    qIns: TFDCommand;
    qUpd: TFDCommand;
    qRead: TFDQuery;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCButton6Click(Sender: TObject);
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure dxOKClick(Sender: TObject);
  private
    { Private declarations }
    isEdit: Boolean;
    FKey: Integer;
  public
    { Public declarations }
    procedure ReadVal;
    procedure EditSnd(NoKey: Integer);
  end;

var
  fmSndMoney: TfmSndMoney;

implementation

uses
  frmMain, frmCalc, frmSelectPol, frmProdaga;

{$R *.fmx}

procedure TfmSndMoney.dxOKClick(Sender: TObject);
begin
  if ePol.Text = '' then
  begin
    ShowError('Укажите получателя!');
    ePol.SetFocus;
    Exit;
  end;
  fmMain.StartMainTransaction;
  if not isEdit then
  begin
    qIns.Active := false;
    qIns.Prepare;
    qIns.ParamByName('DATA_SND').AsDate := StrToDate(fmProd.eData.Text);
    qIns.ParamByName('SUM_SND').Value := eSum.Text.ToDouble;
    qIns.ParamByName('POL_SND').AsString := ePol.Text;
    qIns.ParamByName('NO_VAL').AsInteger := eVal.ListItems[eVal.ItemIndex].Tag;
    qIns.Execute;
  end
  else
  begin
    qUpd.Active := false;
    qUpd.Prepare;
    qUpd.ParamByName('SUM_SND').Value := eSum.Text.ToDouble;
    qUpd.ParamByName('POL_SND').AsString := ePol.Text;
    qUpd.ParamByName('NO_VAL').AsInteger := eVal.ListItems[eVal.ItemIndex].Tag;
    qUpd.ParamByName('NP').AsInteger := FKey;
    qUpd.Execute;
  end;
  fmMain.EndMainTransaction;
  ModalResult := mrOk;
end;

procedure TfmSndMoney.EditSnd(NoKey: Integer);
begin
  isEdit := true;
  FKey := NoKey;
  //ShowInfoEx(IntToStr(FKey));
  fmMain.StartReadTransaction;
  qRead.Close;
  qRead.Prepare;
  qRead.ParamByName('NP').AsInteger := FKey;
  qRead.Active := true;
  ePol.Text := qRead.FieldByName('POL_SND').AsString;
  eSum.Text := qRead.FieldByName('SUM_SND').AsFloat.ToString;
  fmMain.GetValutFromComboBox(qRead.FieldByName('NO_VAL').AsInteger, eVal);
  qRead.Close;
  fmMain.EndReadTransaction;
end;

procedure TfmSndMoney.FormCreate(Sender: TObject);
begin
  isEdit := false;
  FKey := -1;
end;

procedure TfmSndMoney.ReadVal;
var
  Item: TListBoxItem;
begin
  for var Pair in DistValut do
  begin
    Item := TListBoxItem.Create(eVal);
    Item.Text := Pair.Value;
    Item.Tag := Pair.Key;
    Item.ImageIndex := 0;
    eVal.AddObject(Item);
  end;
  eVal.ItemIndex := -1;
end;

procedure TfmSndMoney.TMSFNCButton1Click(Sender: TObject);
begin
 ePol.Text := GetPolMoney;
end;

procedure TfmSndMoney.TMSFNCButton6Click(Sender: TObject);
begin
 showCalc(eSum);
end;

end.
