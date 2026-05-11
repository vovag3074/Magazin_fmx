unit frmLockPredop;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.Comp.Client,
  FMX.Edit, FMX.TMSFNCButton;

type
  TfmLockPred = class(TForm)
    Panel1: TPanel;
    qAdd: TFDCommand;
    eName: TEdit;
    EditButton1: TEditButton;
    eSum: TEdit;
    TMSFNCButton6: TTMSFNCButton;
    TMSFNCButton1: TTMSFNCButton;
    btOK: TTMSFNCButton;
    procedure TMSFNCButton6Click(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure EditButton1Click(Sender: TObject);
  private
    { Private declarations }
    FSum: Double;
    FNo: Integer;
    FAgent: Integer;
    FDate: TDate;
    procedure SSum(mySum: Double);
  public
    { Public declarations }
    property SetSum: Double read FSum write SSum;
    property Agent: Integer read FAgent write FAgent;
    property SetMyData: TDate read FDate write FDate;
  end;

var
  fmLockPred: TfmLockPred;

implementation

uses
  frmMain, frmCalc, frmSelForPred;

{$R *.fmx}

procedure TfmLockPred.EditButton1Click(Sender: TObject);
begin
  fmSelPred := TfmSelPred.Create(fmLockPred);
  if fmSelPred.ShowModal = mrOk then
  begin
    FNo := fmSelPred.NoCeha;
    eName.Text := fmSelPred.NamePol;
    btOK.Enabled := true;
  end;
  FreeAndNil(fmSelPred);
end;

procedure TfmLockPred.SSum(mySum: Double);
begin
  FSum := mySum;
  eSum.Text := FSum.ToString;
end;

procedure TfmLockPred.btOKClick(Sender: TObject);
begin
try
  fmMain.StartMainTransaction;
  qAdd.Close;
  qAdd.Prepare;
  qAdd.ParamByName('NO_CEH').AsInteger := FNo;
  qAdd.ParamByName('NO_AGN').AsInteger := FAgent;
  qAdd.ParamByName('SUM_PRED').Value := eSum.Text.ToDouble;
  qAdd.ParamByName('DATA_POL').AsDate := FDate;
  qAdd.Execute;
  fmMain.EndMainTransaction;
  ModalResult := mrOK;
except on E:Exception do
 begin
   ShowError(E.Message);
 end;
end;
end;

procedure TfmLockPred.TMSFNCButton6Click(Sender: TObject);
begin
  showCalc(eSum);
end;

end.

