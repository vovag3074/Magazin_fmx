unit frmPredoplata;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox, FMX.TMSFNCButton,
  FMX.Edit, System.ImageList, FMX.ImgList, FMX.SVGIconImageList,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfmPred = class(TForm)
    Panel1: TPanel;
    eOpl: TEdit;
    TMSFNCButton6: TTMSFNCButton;
    eCurs: TEdit;
    TMSFNCButton2: TTMSFNCButton;
    Label6: TLabel;
    Label5: TLabel;
    eType: TComboBox;
    Label4: TLabel;
    SVGIconImageList2: TSVGIconImageList;
    eVal: TComboBox;
    Label3: TLabel;
    eDop: TEdit;
    ClearEditButton1: TClearEditButton;
    qRead: TFDQuery;
    qPred: TFDCommand;
    TMSFNCButton3: TTMSFNCButton;
    TMSFNCButton1: TTMSFNCButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure TMSFNCButton6Click(Sender: TObject);
    procedure TMSFNCButton2Click(Sender: TObject);
  private
    { Private declarations }
    FAgent: Integer;
    FData: TDate;
    FValut: Integer;
    procedure ReadValList;
    procedure setPredop;
  public
    { Public declarations }
    procedure SetAgent(NoAgent: Integer; DataSt: TDate);
  end;

var
  fmPred: TfmPred;

implementation

uses
  frmMain, frmCalc;

{$R *.fmx}

{ TfmPred }

procedure TfmPred.FormCreate(Sender: TObject);
begin
  FAgent := -1;
  FData := Now;
  FValut := -1;
end;

procedure TfmPred.ReadValList;
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
  fmMain.GetValutFromComboBox(FValut, eVal);
end;

procedure TfmPred.SetAgent(NoAgent: Integer; DataSt: TDate);
begin
  fmMain.StartReadTransaction;
  FAgent := NoAgent;
  FData := DataSt;
  qRead.Close;
  qRead.Prepare;
  qRead.ParamByName('NG').AsInteger := FAgent;
  qRead.Active := True;
  FValut := qRead.FieldByName('PRED_VAL').AsInteger;
  fmPred.Caption := 'Предоплата для: '+qRead.FieldByName('FULL_NAME_STD').asString;
  qRead.Close;
  ReadValList();
  fmMain.EndReadTransaction;
end;

procedure TfmPred.setPredop;
var
  TranID: string;
begin
  fmMain.StartMainTransaction;
  TranID := fmMain.GetTranID;
  qPred.Active := false;
  qPred.Prepare;
  qPred.ParamByName('NG').AsInteger := FAgent;
  qPred.ParamByName('SUM_PRED').Value := eOpl.Text.ToDouble;
  qPred.ParamByName('DATA_PRED').AsDate := FData;
  qPred.ParamByName('STR_PRED').AsString := eDop.Text;
  qPred.ParamByName('IS_VIRT').AsSmallInt := 0;
  qPred.ParamByName('NO_VAL').AsInteger := eVal.ListItems[eVal.ItemIndex].Tag;
  qPred.ParamByName('KURS_VAL').Value := fmPred.eCurs.Text.ToDouble;
  qPred.ParamByName('TRAN_ID').AsString := TranID;
  qPred.ParamByName('IS_MULT').asBoolean := eType.ItemIndex = 0;
  qPred.Execute;
  fmMain.EndMainTransaction;
end;

procedure TfmPred.TMSFNCButton1Click(Sender: TObject);
begin
 if eOpl.Text.Trim='' then
  begin
    eOpl.Text:='0';
  end;
 setPredop;
 ModalResult:=mrOk;
end;

procedure TfmPred.TMSFNCButton2Click(Sender: TObject);
begin
 showCalc(eCurs);
end;

procedure TfmPred.TMSFNCButton6Click(Sender: TObject);
begin
 if eOpl.Text.Trim='' then
  begin
    eOpl.Text:='0';
  end;
 showCalc(eOpl);
end;

end.

