unit frmOplata;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCButton, FMX.Edit,
  FMX.ListBox, System.ImageList, FMX.ImgList, FMX.SVGIconImageList;

type
  TfmOpl = class(TForm)
    Panel1: TPanel;
    зSum: TPanel;
    TMSFNCButton1: TTMSFNCButton;
    Label1: TLabel;
    ePred: TEdit;
    SVGIconImageList1: TSVGIconImageList;
    eVal: TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
    FAgent: Integer;
    FDolg: Double;
    FTemp: Integer;
    FData: tDate;
    FPred: Double;
    FBankPred: Double; // 02.07.2019 разделил банковскую и наличную предоплату
    FValut: Integer; // 23,03,2019 добавили валюту покупателя по умодчанию
    isPred: Integer; // если предоплата = 1
    FTranID: string;
    procedure ReadAgent(NoAgent: Integer; isTemp: Integer; MyData: tDate);
  end;

var
  fmOpl: TfmOpl;

implementation

uses
  frmMain;

{$R *.fmx}

{ TfmOpl }

procedure TfmOpl.ReadAgent(NoAgent, isTemp: Integer; MyData: tDate);
begin
 FAgent := NoAgent;
  FTemp := isTemp;
  FData := MyData;
  isPred := 0; // по умолчанию - реальная оплата
//  btBank.SpeedButtonOptions.Down := false;
//  qRead.Close;
//  qRead.Prepare;
//  qRead.ParamByName('NG').AsInteger := FAgent;
//  qRead.Active := True;
//  FDolg := qRead.FieldByName('AG_DOLG').AsFloat;
//  eSum.Caption := FloatToStr(FDolg);
//  FPred := qRead.FieldByName('AG_PRED').AsFloat;
//  FBankPred := qRead.FieldByName('AG_BANK_PRED').AsFloat;
//  if btBank.SpeedButtonOptions.Down then
//  begin
//    ePred.Text := FloatToStr(FBankPred);
//    ePred.Enabled := FBankPred > 0;
//  end
//  else
//  begin
//    ePred.Text := FloatToStr(FPred);
//    ePred.Enabled := FPred > 0;
//  end;
//  FValut := qRead.FieldByName('PRED_VAL').AsInteger;
//  qRead.Close;
//  eDop.Properties.LookupItems.Clear;
//  qLook.Close;
//  qLook.Prepare;
//  qLook.Active := True;
//  if qLook.RecordCount > 0 then
//  begin
//    qLook.First;
//    repeat
//      eDop.Properties.LookupItems.Add(qLook.FieldByName('DOP_OPIS').AsString);
//      qLook.Next;
//    until (qLook.Eof);
//  end;
//  ReadUserVal;
end;

end.
