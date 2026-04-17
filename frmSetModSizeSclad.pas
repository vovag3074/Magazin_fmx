unit frmSetModSizeSclad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.TMSFNCTypes,
  FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, System.Rtti,
  FMX.TMSFNCDataGridCell, FMX.TMSFNCDataGridData, FMX.TMSFNCDataGridBase,
  FMX.TMSFNCDataGridCore, FMX.TMSFNCDataGridRenderer, FMX.TMSFNCCustomControl,
  FMX.TMSFNCDataGrid, FMX.TMSFNCButton;

type
  TfmSetSize = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    lbName: TLabel;
    qInfo: TFDQuery;
    qList: TFDQuery;
    tlSize: TTMSFNCDataGrid;
    lbCnt: TLabel;
    qUpd: TFDCommand;
    TMSFNCButton1: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    procedure FormActivate(Sender: TObject);
    procedure tlSizeSelectCell(Sender: TObject; AStartCell,
      AEndCell: TTMSFNCDataGridCellCoord);
    procedure TMSFNCButton1Click(Sender: TObject);
  private
    { Private declarations }
    FMod: Integer;
    FIsV: Integer;
    function FSum: Double;
  public
    { Public declarations }
    procedure ListSize(NoModel: Integer; is_Vit: Integer);
    property SizeListSum:Double read FSum;
  end;

var
  fmSetSize: TfmSetSize;

implementation

uses
  frmMain;

{$R *.fmx}

{ TfmSetSize }

procedure TfmSetSize.FormActivate(Sender: TObject);
begin
 tlSize.AdaptToStyle:=True;
end;

function TfmSetSize.FSum: Double;
begin
  Result := tlSize.ColumnSum(2, 1, tlSize.RowCount);
end;

procedure TfmSetSize.ListSize(NoModel, is_Vit: Integer);
begin
  FMod := NoModel;
  FIsV := is_Vit;
  lbName.Text:='';
  //-------13.03.2014----------------------------------------------
  // в заголовок добавил название модели
  //---------------------------------------------------------------
  fmMain.StartReadTransaction;
  qInfo.Close;
  qInfo.Prepare;
  qInfo.ParamByName('NM').AsInteger:=FMod;
  qInfo.Active:=true;
  lbName.Text:=qInfo.FieldByName('NAZVAN').AsString;
  qInfo.Close;
  //---------------------------------------------------------------
  tlSize.RowCount:=0;
  qList.Close;
  qList.Prepare;
  qList.ParamByName('NM').AsInteger := FMod;
  qList.Active := true;
  var K, R:Integer;
  K := qList.RecordCount;
  if K > 0 then
  begin
    tlSize.RowCount := K+1;
    R := 1;
    qList.First;
    repeat
      tlSize.Ints[0,R] := qList.FieldByName('NO_MST').AsInteger;
      tlSize.Cells[1,R] := qList.FieldByName('NO_SIZE').AsString;
      tlSize.Floats[2,R] := qList.FieldByName('CNT_MOD').AsFloat;
      Inc(R);
      qList.Next;
    until (qList.Eof);
    tlSize.FocusedCell := MakeCell(1, 1);
  end;
end;

procedure TfmSetSize.tlSizeSelectCell(Sender: TObject; AStartCell,
  AEndCell: TTMSFNCDataGridCellCoord);
begin
 lbCnt.Text := tlSize.ColumnSum(2, 1, tlSize.RowCount).ToString;
end;

procedure TfmSetSize.TMSFNCButton1Click(Sender: TObject);
var I: Integer;
begin
 for I := 1 to tlSize.RowCount-1 do
   begin
     fmMain.StartMainTransaction;
     if tlSize.Floats[2,I]>=0 then
     begin
       qUpd.Active:=false;
       qUpd.Prepare;
       //ShowMessage('Key='+tlSize.Ints[0,I].ToString+' Row= '+I.ToString);
       qUpd.ParamByName('NO_MSIS').AsInteger:=tlSize.Ints[0,I];
       qUpd.ParamByName('CNT_SIZE').Value := tlSize.Floats[2,I];
       qUpd.ParamByName('ISVIT').AsSmallInt := 0;
       qUpd.Execute;
     end;
     fmMain.IBT.Commit;
   end;
   ModalResult := mrOK;
end;

end.
