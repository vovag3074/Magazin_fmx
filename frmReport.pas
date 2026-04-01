unit frmReport;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.frxDesgn,
  FMX.frxClass, FMX.frxDCtrl, FMX.frxChBox, FMX.frxBarcode, FMX.frxPreview,
  FMX.frxBarcode2DView, FMX.frxGradient, FMX.frLocalization, System.JSON,
  System.JSON.BSON, System.JSON.Builders, System.JSON.Readers, System.JSON.Types,
  System.JSON.Utils, FMX.frLanguageRussian, FMX.frCoreClasses, FMX.fs_imenusrtti,
  FMX.fs_idialogsrtti, FMX.fs_ipascal, FMX.frxExportCSV, FMX.frxExportText,
  FMX.frxExportImage, FMX.frxExportHTML, FMX.frxExportPDF, FMX.frxExportRTF,
  FMX.frxExportBaseDialog, FMX.frxExportXML, FMX.frxCross, FMX.frxFDComponents,
  FMX.frxPrintDialog;

type
  TfmReport = class(TForm)
    myRep: TfrxReport;
    myDis: TfrxDesigner;
    frxCrossObject1: TfrxCrossObject;
    frxGradientObject1: TfrxGradientObject;
    frx2DBarCodeObject1: Tfrx2DBarCodeObject;
    frxBarCodeObject1: TfrxBarCodeObject;
    frxCheckBoxObject1: TfrxCheckBoxObject;
    frxDialogControls1: TfrxDialogControls;
    frxXMLExport1: TfrxXMLExport;
    frxRTFExport1: TfrxRTFExport;
    frxPDFExport1: TfrxPDFExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxBMPExport1: TfrxBMPExport;
    frxJPEGExport1: TfrxJPEGExport;
    frxSimpleTextExport1: TfrxSimpleTextExport;
    frxCSVExport1: TfrxCSVExport;
    fsPascal1: TfsPascal;
    fsDialogsRTTI1: TfsDialogsRTTI;
    fsMenusRTTI1: TfsMenusRTTI;
    frLocalizationController1: TfrLocalizationController;
    frxFDComponents1: TfrxFDComponents;
    procedure myRepGetValue(const VarName: string; var Value: Variant);
  private
    { Private declarations }
    FParam: TStringList;
    function GetParam(Str: string): string;
    procedure ParseJson(const myJson: string);
  public
    { Public declarations }
  end;

var
  fmReport: TfmReport;

procedure ShowReportJson(NameRep: string; ParamList: string);

function getReportPatch: string;

implementation

{$R *.fmx}

uses
  frmMain, frmReportList;

function TfmReport.GetParam(Str: string): string;
begin
  Result := '';
  if FParam.Text = '' then
    Exit;
  Result := FParam.Values[Str];
end;

procedure TfmReport.myRepGetValue(const VarName: string; var Value: Variant);
var
  T: string;
begin
  if Assigned(FParam) then
  begin
    T := FParam.Values[VarName];
    if T.Trim <> '' then
    begin
      Value := T;
    end;
  end;
end;

procedure TfmReport.ParseJson(const myJson: string);
var
  LJsonArr: TJSONArray;
  LJsonValue: TJSONValue;
  LItem: TJSONValue;
  MyPar: string;
  MyVal: string;
begin
  //ShowInfo(myJson);
  if Length(myJson) > 0 then
  begin
    if not Assigned(FParam) then
    begin
      FParam := TStringList.Create;
      FParam.Clear;
    end;
    LJsonArr := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(myJson), 0) as TJSONArray;
    for LJsonValue in LJsonArr do
    begin
      for LItem in TJSONArray(LJsonValue) do
      begin
        MyPar := TJSONPair(LItem).JsonString.Value;
        //ShowInfo(MyPar);
        MyVal := TJSONPair(LItem).JsonValue.Value;
        //ShowInfo(MyVal);
        FParam.Add(MyPar + '=' + MyVal);
        myRep.Variables[MyPar] := MyVal;
      end;
    end;
  end;
end;

function getReportPatch: string;
begin
  result := getStartProgrammDir + PathDelim + 'Rep' + PathDelim;
end;

procedure GetRepName(var NameRep: string);
begin
  // отчеты в подкаталоге рабочего каталога
  if pos('*', NameRep) = 0 then
  begin
    NameRep := getReportPatch + NameRep;
  end
  else
  begin
    fmRepList := TfmRepList.Create(fmReport);
    fmRepList.ListReport(NameRep);
    if fmRepList.showModal = mrOk then
    begin
      NameRep := fmRepList.ReportName;
    end;
    fmRepList.Free;
  end;
end;

procedure ShowReportJson(NameRep: string; ParamList: string);
begin
  GetRepName(NameRep);
  if NameRep.Trim <> '' then
  begin
    fmReport := TfmReport.Create(Application);
    fmReport.myRep.LoadFromFile(NameRep);
    fmReport.ParseJson(ParamList);
    fmReport.myRep.PrepareReport();
    fmReport.myRep.ShowPreparedReport;
    FreeAndNil(fmReport);
  end;
end;

end.

