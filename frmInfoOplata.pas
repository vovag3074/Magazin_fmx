unit frmInfoOplata;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.TMSFNCButton,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCHTMLText;

type
  TfmInfoOpl = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    eSum: TEdit;
    eCursCum: TEdit;
    eStartDolg: TEdit;
    Оплата: TGroupBox;
    GroupBox1: TGroupBox;
    eDolg: TEdit;
    ePred: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    TMSFNCButton1: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    TMSFNCHTMLText1: TTMSFNCHTMLText;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmInfoOpl: TfmInfoOpl;


 {$REGION 'Documentation'}
  /// <summary>
  ///   Показать подробную информацию об оплате
  /// </summary>
  /// <param name="FIO">
  ///   Имя покупателя
  /// </param>
  /// <param name="OldSum">
  ///   Сумма долга
  /// </param>
  /// <param name="NewSum">
  ///   Сумма долга после оплаты
  /// </param>
  /// <param name="SumOpl">
  ///   Сумма оплаты
  /// </param>
  /// <param name="SumOplCurs">
  ///   Сумма оплаты по курсу
  /// </param>
  /// <param name="SumPred">
  ///   Сумма предоплаты
  /// </param>
  /// <returns>
  ///   Истина если нажата клавиша OK
  /// </returns>
  {$ENDREGION}
function ShowInfoOplEx(FIO: string; OldSum, NewSum, SumOpl, SumOplCurs, SumPred: Double): Boolean;

implementation

uses
  frmMain;

{$R *.fmx}

function ShowInfoOplEx(FIO: string; OldSum, NewSum, SumOpl, SumOplCurs, SumPred: Double): Boolean;
begin
  if SumOpl > 0 then
  begin
    fmInfoOpl := TfmInfoOpl.Create(Application);
  //------------------------------------------------
    fmInfoOpl.eStartDolg.Text := FloatToStr(OldSum);
    fmInfoOpl.eCursCum.Text := FloatToStr(SumOpl);
    fmInfoOpl.eSum.Text := FloatToStr(SumOplCurs);
    fmInfoOpl.eDolg.Text := FloatToStr(NewSum);
    fmInfoOpl.ePred.Text := FloatToStr(SumPred);
  //------------------------------------------------
    result := fmInfoOpl.ShowModal = mrOk;
    FreeAndNil(fmInfoOpl);
  end
  else
  begin
    Result := true;     // если ничего не оплачиваем, то принимаем как есть
  end;
end;

end.
