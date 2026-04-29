unit frmSelectBankAttribyte;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, System.Rtti, FMX.TMSFNCDataGridCell,
  FMX.TMSFNCDataGridData, FMX.TMSFNCDataGridBase, FMX.TMSFNCDataGridCore,
  FMX.TMSFNCDataGridRenderer, FMX.TMSFNCCustomControl, FMX.TMSFNCDataGrid,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCBitmapContainer, FMX.TMSFNCButton;

type
  TfmSelBank = class(TForm)
    qRead: TFDQuery;
    Panel1: TPanel;
    tlBankAttrib: TTMSFNCDataGrid;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    btOK: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    procedure FormCreate(Sender: TObject);
    procedure tlBankAttribDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ReadAtt;
  end;

var
  fmSelBank: TfmSelBank;

function SelectBankAttribute(var NamePol, NameBank, KodBank: String): Integer;

implementation

uses
  frmMain;

{$R *.fmx}

procedure TfmSelBank.FormCreate(Sender: TObject);
begin
 tlBankAttrib.AdaptToStyle:=True;
end;

function SelectBankAttribute(var NamePol, NameBank, KodBank: String): Integer;
begin
  NamePol := '';
  NameBank := '';
  KodBank := '';
  fmSelBank := TfmSelBank.Create(Application);
  fmSelBank.ReadAtt;
  Result := fmSelBank.ShowModal;
  if Result = mrOk then
  begin
    var I:Integer := fmSelBank.tlBankAttrib.FocusedCell.Row;
    NamePol := fmSelBank.tlBankAttrib.Cells[1,I].ToString;
    NameBank := fmSelBank.tlBankAttrib.Cells[0,I].ToString;
    KodBank := fmSelBank.tlBankAttrib.Cells[2,I].ToString;
  end;
  FreeAndNil(fmSelBank);
end;

procedure TfmSelBank.ReadAtt;
begin
  btOk.Enabled := false;
  tlBankAttrib.RowCount:=1;
  qRead.Close;
  qRead.Prepare;
  qRead.Active := true;
  var K:Integer := qRead.RecordCount;
  if  K > 0 then
  begin
    tlBankAttrib.RowCount:=K + 1;
    qRead.First;
    var I:Integer;
    I:=1;
    repeat
      tlBankAttrib.Cells[0,I]:= qRead.FieldByName('NAME_BANH').AsString;
      tlBankAttrib.Cells[1,I] := qRead.FieldByName('POL_NAME').AsString;
      tlBankAttrib.Cells[2,I] := qRead.FieldByName('NO_POL').AsString;
      Inc(I);
      qRead.Next;
    until (qRead.Eof);
    qRead.Close;
    tlBankAttrib.SelectedCells[1,1];
    btOk.Enabled := tlBankAttrib.RowCount > 1;
  end;
end;

procedure TfmSelBank.tlBankAttribDblClick(Sender: TObject);
begin
 ModalResult := mrOk;
end;

end.
