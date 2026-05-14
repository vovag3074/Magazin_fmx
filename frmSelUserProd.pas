unit frmSelUserProd;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.TMSFNCTypes,
  FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData,
  FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCBitmapContainer, FMX.TMSFNCURLBitmapContainer, FMX.TMSFNCButton;

type
  TfmSelProd = class(TForm)
    Panel1: TPanel;
    qList: TFDQuery;
    PokList: TTMSFNCTreeView;
    TMSFNCURLBitmapContainer1: TTMSFNCURLBitmapContainer;
    btOK: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
    FSelList:TStringList;
    FSelNoList:TStringList;
  public
    { Public declarations }
    procedure showList(DataProd:TDate);
    property  SelectList: TStringList read FSelList;
    property SelectNoList: TStringList read FSelNoList;
  end;

var
  fmSelProd: TfmSelProd;

implementation

uses
  frmMain;

{$R *.fmx}

{ TfmSelProd }

procedure TfmSelProd.btOKClick(Sender: TObject);
  var I:Integer;
      S:string;
begin
  for I := 0 to PokList.Nodes.Count-1 do
    begin
      if PokList.Nodes[I].Checked[0] then
       begin
          FSelList.Add(PokList.Nodes[I].Text[0]);
          FSelNoList.Add(PokList.Nodes[I].DataInteger.ToString);
       end;
    end;
 ModalResult := mrOk;
end;

procedure TfmSelProd.showList(DataProd: TDate);
var
  Node: tTmsFNCTreeViewNode;
begin
  FSelList := TStringList.Create;
  FSelList.Clear;
  FSelNoList := TStringList.Create;
  FSelNoList.Clear;
  PokList.AdaptToStyle:=True;
  fmMain.StartReadTransaction;
  //-----------------------------------
  PokList.Nodes.Clear;
  qList.Close;
  qList.ParamByName('DP').AsDate:=DataProd;
  qList.Active := True;
  if qList.RecordCount > 0 then
  begin
    qList.First;
    repeat
      Node := PokList.AddNode;
      Node.Text[0] := qList.FieldByName('FULL_NAME_STD').asString;
      Node.DataInteger := qList.FieldByName('NO_AGN').AsInteger;
      Node.CheckTypes[0]:=tvntCheckBox;
      Node.Checked[0]:=False;
      Node.Values[0].CollapsedIconName := 'Item1';
      Node.Values[0].ExpandedIconName := 'Item1';
      qList.Next;
    until (qList.Eof);
    PokList.SelectNode(PokList.Nodes[0]);
  end;
  //-----------------------------------
  fmMain.EndReadTransaction;
end;

end.
