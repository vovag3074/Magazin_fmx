unit frmSelDopZakaz;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Layouts, FMX.ListBox,
  FMX.Edit, FMX.SearchBox, FMX.TMSFNCButton;

type
  TfmSelDopZak = class(TForm)
    Panel1: TPanel;
    qList: TFDQuery;
    tlDop: TListBox;
    SearchBox1: TSearchBox;
    btOK: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    procedure btOKClick(Sender: TObject);
    procedure tlDopDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DopStr:String;
    procedure InitList;
  end;

var
  fmSelDopZak: TfmSelDopZak;

implementation

uses
  frmMain;

{$R *.fmx}

{ TfmSelDopZak }

procedure TfmSelDopZak.btOKClick(Sender: TObject);
begin
 DopStr:=tlDop.ItemByIndex(tlDop.ItemIndex).Text;
 ModalResult:=mrOk;
end;

procedure TfmSelDopZak.InitList;
var Node: TListBoxItem;
begin
 fmMain.StartReadTransaction;
 DopStr:='';
 tlDop.Items.Clear;
 qList.Close;
 qList.Prepare;
 qList.Active:=true;
 if qList.RecordCount>0 then
 begin
   tlDop.BeginUpdate;
   qList.First;
   repeat
     Node:= TListBoxItem.Create(tlDop);
     Node.Text:=qList.FieldByName('PRIM_ZAK').AsString;
     tlDop.AddObject(Node);
     qList.Next;
   until (qList.Eof);
   tlDop.EndUpdate;
   tlDop.ItemIndex:=0;
 end;
 fmMain.EndReadTransaction;
end;

procedure TfmSelDopZak.tlDopDblClick(Sender: TObject);
begin
 btOKClick(Sender);
end;

end.
