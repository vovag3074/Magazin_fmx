unit frmAddDop;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCButton, FMX.Objects,
  FMX.Edit, FMX.DateTimeCtrls, FMX.ListBox, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.ImageList,
  FMX.ImgList, FMX.SVGIconImageList;

type
  TfmAddDop = class(TForm)
    Rectangle1: TRectangle;
    TMSFNCButton1: TTMSFNCButton;
    Label1: TLabel;
    eAgn: TEdit;
    TMSFNCButton2: TTMSFNCButton;
    Label2: TLabel;
    DateEdit1: TDateEdit;
    Label3: TLabel;
    eSum: TEdit;
    Label4: TLabel;
    TMSFNCButton3: TTMSFNCButton;
    eBank: TEdit;
    TMSFNCButton4: TTMSFNCButton;
    Label5: TLabel;
    ePol: TEdit;
    TMSFNCButton5: TTMSFNCButton;
    Label6: TLabel;
    Edit2: TEdit;
    Label7: TLabel;
    eVal: TComboBox;
    eType: TComboBox;
    eCurs: TEdit;
    TMSFNCButton6: TTMSFNCButton;
    qVal: TFDQuery;
    SVGIconImageList1: TSVGIconImageList;
    Panel1: TPanel;
    procedure TMSFNCButton3Click(Sender: TObject);
    procedure TMSFNCButton6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCButton2Click(Sender: TObject);
  private
    { Private declarations }
    FAgent: Integer;
    FDolg: Double;
    isEdit: Boolean;
    FKey: NativeInt;
    FTR_ID: string;
    FValut: Integer;
    procedure ReadUserVal;
    procedure ShowDolg;
  public
    { Public declarations }
  end;

var
  fmAddDop: TfmAddDop;

implementation

uses
  frmMain, frmCalc, frmSelectAgent;

{$R *.fmx}

procedure TfmAddDop.FormCreate(Sender: TObject);
begin
  ReadUserVal;
end;

procedure TfmAddDop.ReadUserVal;
var
  MyVal: TListBoxItem;
begin
  eVal.Items.Clear;
  qVal.Close;
  qVal.Prepare;
  qVal.Active := True;
  if qVal.RecordCount > 0 then
  begin
    qVal.First;
    repeat
//      Item := TListBoxItem.Create(eVal);
//      Item.Height := 33;
//      Item.Tag := ValutList.getID(I);
//      Item.Text := ValutList.getItem(I);
//      Item.ImageIndex := 0;
//      eVal.AddObject(Item);
      MyVal := TListBoxItem.Create(eVal);
      MyVal.Height := 36;
      MyVal.Tag := qVal.FieldByName('NO_VAL').AsInteger;
      MyVal.Text := qVal.FieldByName('NAZVAN').AsString;
      MyVal.ImageIndex := 0;
      eVal.AddObject(MyVal);
      qVal.Next;
    until qVal.Eof;
    qVal.Close;
  end;
  eVal.ItemIndex := 0;
end;

procedure TfmAddDop.ShowDolg;
begin

end;

procedure TfmAddDop.TMSFNCButton2Click(Sender: TObject);
begin
  eAgn.Text := '';
  FAgent := -1;
  fmSelAgn := TfmSelAgn.Create(fmAddDop);
  fmSelAgn.LoadList;
  if fmSelAgn.ShowModal = mrOk then
  begin
    eAgn.Text := fmSelAgn.NameAgent;
    FAgent := fmSelAgn.NoAgent;
    ShowDolg;
    fmSelAgn.Free;
    fmSelAgn := nil;
  end;
end;

procedure TfmAddDop.TMSFNCButton3Click(Sender: TObject);
begin
  showCalc(eSum);
end;

procedure TfmAddDop.TMSFNCButton6Click(Sender: TObject);
begin
  showCalc(eCurs);
end;

end.

