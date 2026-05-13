unit frmSelForPred;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  FMX.ListBox, FMX.Objects, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCImage, FMX.TMSFNCButton;

type
  TfmSelPred = class(TForm)
    qList: TFDQuery;
    Panel1: TPanel;
    Rectangle1: TRectangle;
    TMSFNCImage1: TTMSFNCImage;
    Label1: TLabel;
    Label2: TLabel;
    btOK: TTMSFNCButton;
    TMSFNCButton1: TTMSFNCButton;
    ListBoxItem1: TListBoxItem;
    tlPol: TListBox;
    ltItem: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure tlPolDblClick(Sender: TObject);
  private
    { Private declarations }
    FNo: Integer;
    FName: String;
    procedure ListPol;
  public
    { Public declarations }
    property NoCeha: Integer read FNo;
    property NamePol: String read FName;
  end;

var
  fmSelPred: TfmSelPred;

implementation

uses
  frmMain;

{$R *.fmx}

{ TfmSelPred }

procedure TfmSelPred.btOKClick(Sender: TObject);
  var
  Node: TListBoxItem;
begin
  if tlPol.Count > 0 then
  begin
    Node := tlPol.ItemByIndex(tlPol.ItemIndex);
    FNo := Node.Tag;
    FName := Node.Text;
    ModalResult := mrOk;
  end;
end;

procedure TfmSelPred.FormCreate(Sender: TObject);
begin
 ListPol;
end;

procedure TfmSelPred.ListPol;
var
  Node: TListBoxItem;
begin
try
  tlPol.Items.Clear;
  qList.Close;
  qList.Prepare;
  qList.Active := true;
  if qList.RecordCount > 0 then
  begin
    qList.First;
    repeat
      Node := TListBoxItem.Create(tlPol);
      Node.StyleLookup:='polItem';
      Node.Tag := qList.FieldByName('CODE_FAB').AsInteger;
      Node.Text := qList.FieldByName('FIO_FAB').AsString;
      Node.StylesData['noCeh']:= qList.FieldByName('CODE_FAB').AsInteger.ToString;
      tlPol.AddObject(Node);
      qList.Next;
    until (qList.Eof);
    tlPol.ItemIndex:=0;
    btOK.Enabled:=True;
  end;
except on E:Exception do
 begin
   ShowError(E.Message);
 end;
end;
end;

procedure TfmSelPred.tlPolDblClick(Sender: TObject);
begin
 btOKClick(Sender);
end;

end.
