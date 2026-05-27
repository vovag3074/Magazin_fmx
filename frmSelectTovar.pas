unit frmSelectTovar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCTreeView, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer,
  FMX.TMSFNCButton;

type
  TfmSelTov = class(TForm)
    Panel1: TPanel;
    tlMod: TTMSFNCTreeView;
    qKat: TFDQuery;
    qMod: TFDQuery;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    Splitter1: TSplitter;
    tlSize: TTMSFNCTreeView;
    qSize: TFDQuery;
    btOK: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    procedure tlModFocusedNodeChanged(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode);
    procedure tlSizeDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure readModByKat(var ANode: TTMSFNCTreeViewNode);
    procedure ReadSizeMod;
  public
    { Public declarations }
    procedure ReadModList;
  end;

var
  fmSelTov: TfmSelTov;

function GetManualCode: string;

implementation

uses
  frmMain;

{$R *.fmx}

function GetManualCode: string;
begin
  Result := '';
  fmSelTov := TfmSelTov.Create(fmMain);
  fmSelTov.tlMod.AdaptToStyle := True;
  fmSelTov.tlSize.AdaptToStyle := True;
  fmSelTov.tlMod.Nodes.Clear;
  fmSelTov.tlSize.Nodes.Clear;
  fmSelTov.ReadModList;
  if fmSelTov.ShowModal = mrOk then
  begin
    Result := fmSelTov.tlSize.FocusedNode.Text[2];
  end;
  fmSelTov.Free;
  fmSelTov := nil;
end;

{ TfmSelTov }

procedure TfmSelTov.ReadModList;
var
  Node: TTMSFNCTreeViewNode;
begin
  tlMod.Nodes.Clear;
  qKat.Active := false;
  qKat.Prepare;
  qKat.Active := true;
  if qKat.RecordCount > 0 then
  begin
    qKat.First;
    repeat
      if qKat.FieldByName('SUM_OF_CNT_MOD').AsInteger > 0 then
      begin
        Node := tlMod.AddNode;
        Node.DataInteger := qKat.FieldByName('NO_KAT').AsInteger;
        Node.Text[0] := qKat.FieldByName('NAZVAN').AsString;
        Node.Extended := True;
        Node.DataBoolean := False; //категории
        Node.Values[0].CollapsedIconName := 'Item1';
        Node.Values[0].ExpandedIconName := 'Item1';
        readModByKat(Node);
      end;
      qKat.Next;
    until (qKat.Eof);
    tlMod.ExpandAll;
    if tlMod.Nodes.Count > 1 then
    begin
      tlMod.SelectNode(tlMod.Nodes[1]);
      ReadSizeMod;
    end;
  end;
end;

procedure TfmSelTov.ReadSizeMod;
var
  Node, BNode: TTMSFNCTreeViewNode;
begin
  btOK.Enabled := false;
  try
    tlSize.Nodes.Clear;
    BNode := tlMod.FocusedNode;
    if BNode.DataBoolean then
    begin
      qSize.Close;
      qSize.Prepare;
      qSize.ParamByName('NM').AsInteger := BNode.DataInteger;
      qSize.Active := true;
      if qSize.RecordCount > 0 then
      begin
        qSize.First;
        repeat
          Node := tlSize.AddNode;
          Node.DataInteger := qSize.FieldByName('N0_MSIS').AsInteger;
          Node.Text[0] := qSize.FieldByName('NO_SIZE').AsInteger.ToString;
          Node.Text[1] := qSize.FieldByName('CNT_MOD').AsInteger.ToString;
          Node.Text[2] := qSize.FieldByName('UN_CODE').AsString;
          Node.Values[0].CollapsedIconName := 'Item3';
          Node.Values[0].ExpandedIconName := 'Item3';
          qSize.Next;
        until (qSize.Eof);
        if tlSize.Nodes.Count > 0 then
        begin
          tlSize.SelectNode(tlSize.Nodes[0]);
          btOK.Enabled := True;
        end;
      end;
    end;
  except
  end;
end;

procedure TfmSelTov.tlModFocusedNodeChanged(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode);
begin
  ReadSizeMod;
end;

procedure TfmSelTov.tlSizeDblClick(Sender: TObject);
begin
  if btOK.Enabled then
  begin
    fmSelTov.ModalResult := mrOk;
  end;
end;

procedure TfmSelTov.readModByKat(var ANode: TTMSFNCTreeViewNode);
var
  Node: TTMSFNCTreeViewNode;
begin
  qMod.Close;
  qMod.Prepare;
  qMod.ParamByName('NK').AsInteger := ANode.DataInteger;
  qMod.Active := true;
  if qMod.RecordCount > 0 then
  begin
    repeat
      Node := tlMod.AddNode(ANode);
      Node.DataBoolean := True; // модели
      Node.DataInteger := qMod.FieldByName('NO_MOD').AsInteger;
      Node.Text[0] := qMod.FieldByName('NAZVAN').AsString;
      Node.Text[1] := qMod.FieldByName('CNT_MOD').AsFloat.ToString;
      Node.Text[2] := qMod.FieldByName('M_CENA').AsFloat.ToString;
      Node.Values[0].CollapsedIconName := 'Item2';
      Node.Values[0].ExpandedIconName := 'Item2';
      qMod.Next;
    until (qMod.Eof);
  end;
end;

end.

