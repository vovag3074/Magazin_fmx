unit frmOperationAgent;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.TMSFNCButton,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, System.ImageList, FMX.ImgList,
  FMX.SVGIconImageList, FMX.ListBox, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.Comp.Client, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet;

type
  TfmOpAgent = class(TForm)
    Panel1: TPanel;
    eName: TEdit;
    Label1: TLabel;
    cbSkid: TCheckBox;
    eSum: TEdit;
    btOK: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    SVGIconImageList2: TSVGIconImageList;
    eDop: TMemo;
    Label3: TLabel;
    eVal: TComboBox;
    TMSFNCButton6: TTMSFNCButton;
    qIns: TFDCommand;
    qUpd: TFDCommand;
    qRead: TFDQuery;
    procedure FormCreate(Sender: TObject);
    procedure cbSkidChange(Sender: TObject);
    procedure TMSFNCButton6Click(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
    FAgn: Integer;
    isEdit: Boolean;
    FSity: Integer;
    procedure readValutList;
    procedure SaveAgent;
  public
    { Public declarations }
    procedure SetSity(NoSity: Integer);
    procedure EditAgent(NoAgent:Integer);
  end;

var
  fmOpAgent: TfmOpAgent;

implementation

uses
  frmMain, frmCalc;

{$R *.fmx}

{ TfmOpAgent }

procedure TfmOpAgent.btOKClick(Sender: TObject);
begin
 SaveAgent;
 Application.ProcessMessages;
 fmOpAgent.ModalResult := mrOk;
end;

procedure TfmOpAgent.cbSkidChange(Sender: TObject);
begin
  eSum.Enabled := cbSkid.IsChecked;
end;

procedure TfmOpAgent.EditAgent(NoAgent: Integer);
begin
  isEdit := True;
  FAgn := NoAgent;
  Self.Caption := 'Обновить агента';
  fmMain.StartReadTransaction;
  qRead.Close;
  qRead.Prepare;
  qRead.ParamByName('NG').AsInteger := FAgn;
  qRead.Active := True;
  eName.Text := qRead.FieldByName('AG_NAME').AsString;
  var FVal:Integer;
  FVal := qRead.FieldByName('PRED_VAL').AsInteger;
  fmMain.GetValutFromComboBox(FVal, eVal);
  eDop.Lines.Text := qRead.FieldByName('AG_DOP').AsString;
  cbSkid.isChecked := qRead.FieldByName('IS_SKIDKA').AsInteger = 1;
  eSum.Text := qRead.FieldByName('SUM_SKIDKA').asFloat.ToString;
  qRead.Close;
  fmMain.EndReadTransaction;
end;

procedure TfmOpAgent.FormCreate(Sender: TObject);
begin
  FAgn := -1;
  FSity := -1;
  isEdit := False;
  readValutList;
end;

procedure TfmOpAgent.readValutList;
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

procedure TfmOpAgent.SaveAgent;
begin
  fmMain.StartMainTransaction;
  if isEdit then
  begin
    qUpd.Active := false;
    qUpd.Prepare;
    qUpd.ParamByName('NG').AsInteger := FAgn;
    qUpd.ParamByName('PRED_VAL').AsInteger := eVal.ListItems[eVal.ItemIndex].Tag;
    qUpd.ParamByName('AG_NAME').AsString := eName.Text;
    qUpd.ParamByName('AG_DOP').AsWideMemo := eDop.Lines.Text;
    qUpd.ParamByName('IS_SKIDKA').AsSmallInt := 0;
    if cbSkid.isChecked then
      qUpd.ParamByName('IS_SKIDKA').AsSmallInt := 1;
    qUpd.ParamByName('SUM_SKIDKA').Value := eSum.Text.ToDouble;
    qUpd.Execute;
  end
  else
  begin
    qIns.Active := false;
    qIns.Prepare;
    qIns.ParamByName('NO_SITY').AsInteger := FSity;
    qIns.ParamByName('PRED_VAL').AsInteger := eVal.ListItems[eVal.ItemIndex].Tag;
    qIns.ParamByName('AG_NAME').AsString := eName.Text;
    qIns.ParamByName('AG_DOP').AsWideMemo := eDop.Lines.Text;
    qIns.ParamByName('IS_SKIDKA').AsSmallInt := 0;
    if cbSkid.isChecked then
      qIns.ParamByName('IS_SKIDKA').AsSmallInt := 1;
    qIns.ParamByName('IS_DEF_PROD').AsSmallInt := 0;
    qIns.ParamByName('AG_DOLG').Value := 0;
    qIns.ParamByName('AG_PRED').Value := 0;
    qIns.ParamByName('STATUS').AsSmallInt:= 0;
    qIns.ParamByName('SUM_SKIDKA').Value := eSum.Text.ToDouble;
    qIns.Execute;
  end;
  // -------------------------------------------
  fmMain.EndMainTransaction;
end;

procedure TfmOpAgent.SetSity(NoSity: Integer);
begin
  if NoSity > -1 then
  begin
    FSity := NoSity;
  end;
end;

procedure TfmOpAgent.TMSFNCButton6Click(Sender: TObject);
begin
 showCalc(eSum);
end;

end.

