unit frmSelectPol;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.TMSFNCButton, FMX.Objects, FMX.TMSFNCTypes,
  FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCImage;

type
  TfmSelPol = class(TForm)
    Panel1: TPanel;
    tlPol: TListBox;
    qRead: TFDQuery;
    TMSFNCButton1: TTMSFNCButton;
    dxOK: TTMSFNCButton;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    TMSFNCImage1: TTMSFNCImage;
    Label1: TLabel;
    procedure tlPolDblClick(Sender: TObject);
  private
    function FPol: String;
    { Private declarations }
  public
    { Public declarations }
   property GetNoPol: String read FPol;
   procedure ListPol;
  end;

var
  fmSelPol: TfmSelPol;

function GetPolMoney: string;

implementation

uses
  frmMain;

{$R *.fmx}

function GetPolMoney: string;
begin
  Result := '';
  fmSelPol := TfmSelPol.Create(Application);
  fmSelPol.ListPol;
  if fmSelPol.ShowModal = mrOk then
  begin
    Result := fmSelPol.GetNoPol;
  end;
end;

{ TfmSelPol }

function TfmSelPol.FPol: String;
var Node:TListBoxItem;
begin
  Node := tlPol.ItemByIndex(tlPol.ItemIndex);
  Result := Node.Text;
end;

procedure TfmSelPol.ListPol;
var
  Node: TListBoxItem;
begin
  tlPol.Items.Clear;
  dxOK.Enabled := false;
  qRead.Close;
  qRead.Prepare;
  qRead.Active := true;
  if qRead.RecordCount > 0 then
  begin
    qRead.First;
    dxOK.Enabled := true;
    repeat
      Node := TListBoxItem.Create(tlPol);
      Node.StyleLookup:='itemPol';
      Node.Text := qRead.FieldByName('FIO_FAB').AsString;
      Node.OnDblClick:=dxOK.OnClick;
      tlPol.AddObject(Node);
      qRead.Next;
    until (qRead.Eof);
    tlPol.ItemIndex:=0;
  end;
  qRead.Close;
end;

procedure TfmSelPol.tlPolDblClick(Sender: TObject);
begin
 if tlPol.Items.Count>0 then
 begin
   dxOK.OnClick(Sender);
 end;
end;

end.
