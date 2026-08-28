unit frmSelectSity;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCButton, FMX.Layouts,
  FMX.ListBox, FMX.Edit, FMX.SearchBox, System.ImageList, FMX.ImgList,
  FMX.SVGIconImageList, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfmSelSity = class(TForm)
    Panel1: TPanel;
    btOK: TTMSFNCButton;
    btCancel: TTMSFNCButton;
    tlSity: TListBox;
    SearchBox1: TSearchBox;
    SVGIconImageList1: TSVGIconImageList;
    qRead: TFDQuery;
    ListBoxItem1: TListBoxItem;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ListSity;
  end;

var
  fmSelSity: TfmSelSity;

function GetSityNo:Integer;

implementation

uses
  frmMain;

{$R *.fmx}

{ TfmSelSity }

function GetSityNo:Integer;
begin
  Result:=-1;
  fmSelSity:= TfmSelSity.Create(Application);
  fmSelSity.ListSity;
  if fmSelSity.ShowModal=mrOk then
  begin
    Result := fmSelSity.tlSity.ItemByIndex(fmSelSity.tlSity.ItemIndex).Tag;
  end;
  FreeAndNil(fmSelSity);
end;

procedure TfmSelSity.ListSity;
var
  Node: TListBoxItem;
begin
 try
    tlSity.BeginUpdate;
    tlSity.Items.Clear;
    qRead.Close;
    qRead.Active := true;
    if qRead.RecordCount > 0 then
    begin
      repeat
        Node := TListBoxItem.Create(tlSity);
        Node.Text:= qRead.FieldByName('ST_NAME').AsString;
        Node.Tag := qRead.FieldByName('NO_ST').AsInteger;
        Node.ImageIndex := 0;
//        if qRead.FieldByName('IS_STAR').AsInteger = 1 then
//          Node.ImageIndex := 1;
        tlSity.AddObject(Node);
        qRead.Next;
      until qRead.Eof;
    end;
    // -------------------------
   tlSity.ItemIndex:=0;
  finally
    tlSity.EndUpdate;
  end;
end;

end.
