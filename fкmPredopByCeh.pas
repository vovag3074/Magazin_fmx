unit fкmPredopByCeh;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Layouts, FMX.ListBox,
  FMX.TMSFNCButton, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl, FMX.TMSFNCImage, FMX.Objects;

type
  TfmPredByCeh = class(TForm)
    Panel1: TPanel;
    eSum: TLabel;
    qRead: TFDQuery;
    tlPred: TListBox;
    Panel2: TPanel;
    qSum: TFDQuery;
    TMSFNCButton1: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    TMSFNCButton3: TTMSFNCButton;
    ltItem: TLayout;
    Rectangle1: TRectangle;
    TMSFNCImage1: TTMSFNCImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure TMSFNCButton1Click(Sender: TObject);
    procedure TMSFNCButton2Click(Sender: TObject);
  private
    { Private declarations }
    FSum, TSum: Double;
    FAgent: Integer;
    FDate: TDate;
    function GetPredString: string;
    procedure SetSum(inSum: Double);
    procedure SetAgent(NoAgn: Integer);
    procedure WrireOst;
    procedure ListPred(AddSum: Double = 0);
  public
    { Public declarations }
    property GlobalSumma: Double read FSum write SetSum;
    property Agent: Integer read FAgent write SetAgent;
    property DataPred: TDate read FDate write FDate;
    property PredString: string read GetPredString;
    function GetFullPred: Double;
  end;

var
  fmPredByCeh: TfmPredByCeh;

function SetPredByCeh(Sum_pred: Double; NoAgent: Integer; myData: TDate): string;

implementation

uses
  frmMain, frmLockPredop;

{$R *.fmx}

function SetPredByCeh(Sum_pred: Double; NoAgent: Integer; myData: TDate): string;
begin
  fmPredByCeh := TfmPredByCeh.Create(Application);
  fmPredByCeh.Agent := NoAgent;
  fmPredByCeh.DataPred := myData;
  Application.ProcessMessages;
  fmPredByCeh.GlobalSumma := Sum_pred;
  fmPredByCeh.ListPred(Sum_pred);
  fmPredByCeh.ShowModal;
  Result := fmPredByCeh.PredString;
  fmPredByCeh.Free;
end;

{ TfmPredByCeh }

function TfmPredByCeh.GetFullPred: Double;
begin
  fmMain.StartReadTransaction;
  qSum.Close;
  qSum.Prepare;
  qSum.ParamByName('NG').AsInteger := FAgent;
  qSum.ParamByName('DP').AsDate := FDate;
  qSum.Active := true;
  Result := qSum.FieldByName('SUM_OF_SUM_PRED').AsFloat;
  qSum.Close;
  fmMain.EndReadTransaction;
end;

function TfmPredByCeh.GetPredString: string;
var
  Node: TListBoxItem;
  I: Integer;
  S: string;
begin
  if tlPred.Count > 0 then
  begin
    S := '';
    for I := 0 to tlPred.Count - 1 do
    begin
      Node := tlPred.ItemByIndex(I);
      S := S + Node.Tag.ToString + '=' + Node.Text + '; ';
    end;
    Result := S;
  end
  else
  begin
    Result := '';
  end;
end;

procedure TfmPredByCeh.ListPred(AddSum: Double);
var
  Node: TListBoxItem;
begin
  try
    FSum := TSum;
    tlPred.Items.Clear;
    fmMain.StartReadTransaction;
    qRead.Close;
    qRead.Prepare;
    qRead.ParamByName('NG').AsInteger := FAgent;
    qRead.ParamByName('DP').AsDate := FDate;
    qRead.Active := True;
    if qRead.RecordCount > 0 then
    begin
      qRead.First;
      repeat
        Node := TListBoxItem.Create(tlPred);
        Node.StyleLookup := 'polItem';
        Node.Tag := qRead.FieldByName('NO_CEH').AsInteger;
        Node.Text := qRead.FieldByName('SUM_OF_SUM_PRED').AsFloat.ToString;
        FSum := FSum - qRead.FieldByName('SUM_OF_SUM_PRED').AsFloat;
        Node.StylesData['noCeh'] := qRead.FieldByName('NO_CEH').AsInteger.ToString;
        tlPred.AddObject(Node);
        qRead.Next;
      until (qRead.Eof);
      FSum := FSum + AddSum;
      if tlPred.Items.Count > 0 then
      begin
        tlPred.ItemIndex := 0;
      end;
      WrireOst;
    end;
    fmMain.EndReadTransaction;
  except
    on e: Exception do
    begin
      ShowError(E.Message);
    end;
  end;
end;

procedure TfmPredByCeh.SetAgent(NoAgn: Integer);
begin
  FAgent := NoAgn;
end;

procedure TfmPredByCeh.SetSum(inSum: Double);
begin
  FSum := inSum;// + GetFullPred;
  TSum := FSum;
  WrireOst
end;

procedure TfmPredByCeh.TMSFNCButton1Click(Sender: TObject);
begin
  fmLockPred := TfmLockPred.Create(fmPredByCeh);
  fmLockPred.Agent := FAgent;
  fmLockPred.SetMyData := FDate;
  fmLockPred.SetSum := FSum;
  if fmLockPred.ShowModal = mrOk then
  begin
    ListPred;
  end;
  fmLockPred.Free;
end;

procedure TfmPredByCeh.TMSFNCButton2Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfmPredByCeh.WrireOst;
begin
  eSum.Text := FloatToStr(FSum);
end;

end.

