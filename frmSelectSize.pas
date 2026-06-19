unit frmSelectSize;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, System.Rtti,
  FMX.TMSFNCDataGridCell, FMX.TMSFNCDataGridData, FMX.TMSFNCDataGridBase,
  FMX.TMSFNCDataGridCore, FMX.TMSFNCDataGridRenderer, FMX.TMSFNCCustomControl,
  FMX.TMSFNCDataGrid, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.TMSFNCButton, FMX.Edit;

type
  TfmSelSize = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    lbName: TLabel;
    tlSize: TTMSFNCDataGrid;
    qList: TFDQuery;
    qInfo: TFDQuery;
    lbCnt: TLabel;
    TMSFNCButton2: TTMSFNCButton;
    TMSFNCButton1: TTMSFNCButton;
    qIns: TFDCommand;
    cbIsDog: TCheckBox;
    eSum: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure tlSizeSelectCell(Sender: TObject; AStartCell, AEndCell,
      AFocusedCell: TTMSFNCDataGridCellCoord);
    procedure TMSFNCButton1Click(Sender: TObject);
  private
    { Private declarations }
    FZakaz: Integer;
    FMod: Integer;
  public
    { Public declarations }
    procedure ReadSize(NoZak: Integer; BarCode: string);
  end;

var
  fmSelSize: TfmSelSize;

function GetMyZize(BarCode: string; No_Zakaz: Integer): Integer;

implementation

uses
  frmMain;

{$R *.fmx}

{ TfmSelSize }

procedure TfmSelSize.FormCreate(Sender: TObject);
begin
  tlSize.AdaptToStyle := True;
end;

procedure TfmSelSize.ReadSize(NoZak: Integer; BarCode: string);
begin
  FZakaz := NoZak;
  tlSize.RowCount := 0;
  lbName.Text := '';
  qList.Close;
  qList.Prepare;
  qList.ParamByName('NO_ZAKAZ').AsInteger := NoZak;
  qList.ParamByName('BARCODE').AsString := BarCode;
  qList.Active := true;
  var K, R: Integer;
  K := qList.RecordCount;
  if K > 0 then
  begin
    FMod := qList.FieldByName('NO_MOD').AsInteger;
    qList.First;
    repeat
      tlSize.RowCount := K + 1;
      R := 1;
      qList.First;
      repeat
        tlSize.Ints[0, R] := qList.FieldByName('NO_MST').AsInteger;
        tlSize.Cells[1, R] := qList.FieldByName('NO_SIZE').AsInteger;
        tlSize.Ints[2, R] := qList.FieldByName('CNT_MST').AsInteger;
        Inc(R);
        qList.Next;
      until (qList.Eof);
      tlSize.FocusedCell := MakeCell(1, 1);
      eSum.Text := qList.FieldByName('ZENA_DOG').AsFloat.ToString;
      cbIsDog.isChecked := qList.FieldByName('IS_DOG').AsBoolean;
      qList.Next;
    until (qList.Eof);
    lbName.Text := '';
    // -------13.03.2014----------------------------------------------
    // в заголовок добавил название модели
    // ---------------------------------------------------------------
    qInfo.Close;
    qInfo.Prepare;
    qInfo.ParamByName('NM').AsInteger := FMod;
    qInfo.Active := true;
    lbName.Text := qInfo.FieldByName('NAZVAN').AsString;
    qInfo.Close;
    // ---------------------------------------------------------------
  end;
end;

procedure TfmSelSize.tlSizeSelectCell(Sender: TObject; AStartCell, AEndCell,
  AFocusedCell: TTMSFNCDataGridCellCoord);
begin
  lbCnt.Text := tlSize.ColumnSum(2, 1, tlSize.RowCount).ToString;
end;

procedure TfmSelSize.TMSFNCButton1Click(Sender: TObject);
var
  I: Integer;
begin
  fmMain.StartMainTransaction;
  for I := 0 to tlSize.RowCount - 1 do
  begin
    qIns.Close;
    qIns.Prepare;
    qIns.ParamByName('NO_ZAK').AsInteger := FZakaz;
    qIns.ParamByName('NO_MST').AsInteger := tlSize.Ints[0, I];
    qIns.ParamByName('CNT_MOD').Value := tlSize.Floats[2, I];
    qIns.ParamByName('DOG_CENA').Value := eSum.Text.ToDouble;
    qIns.ParamByName('IS_DOG').AsBoolean := cbIsDog.isChecked;
    qIns.Execute;
  end;
  fmMain.EndMainTransaction;
  ModalResult := mrOk;
end;

function GetMyZize(BarCode: string; No_Zakaz: Integer): Integer;
var
  S: string;
  T: Int64;
begin
  T := BarCode.ToInt64;
  S := T.ToString;
  //удаляем ведущие нули, если есть
  fmSelSize := TfmSelSize.Create(fmMain);
  fmSelSize.ReadSize(No_Zakaz, S);
  Result := fmSelSize.ShowModal;
  FreeandNil(fmSelSize);
end;

end.

