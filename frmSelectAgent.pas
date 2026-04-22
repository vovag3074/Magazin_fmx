unit frmSelectAgent;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.TMSFNCButton,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData,
  FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCBitmapContainer;

type
  TfmSelAgn = class(TForm)
    Panel1: TPanel;
    EFindSity: TEdit;
    EditButton1: TEditButton;
    eFind: TEdit;
    EditButton2: TEditButton;
    TMSFNCButton1: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    tlSity: TTMSFNCTreeView;
    Splitter1: TSplitter;
    Panel2: TPanel;
    qRead: TFDQuery;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    tlAgn: TTMSFNCTreeView;
    qUsr: TFDQuery;
    TMSFNCButton3: TTMSFNCButton;
    dxAdd: TTMSFNCButton;
    procedure FormCreate(Sender: TObject);
    procedure EFindSityTyping(Sender: TObject);
    procedure EditButton1Click(Sender: TObject);
    procedure tlSityFocusedNodeChanged(Sender: TObject;
      ANode: TTMSFNCTreeViewVirtualNode);
    procedure tlAgnGetNodeTextColor(Sender: TObject;
      ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer;
      var ATextColor: TTMSFNCGraphicsColor);
    procedure tlAgnGetNodeSelectedTextColor(Sender: TObject;
      ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer;
      var ATextColor: TTMSFNCGraphicsColor);
    procedure tlAgnGetNodeSelectedColor(Sender: TObject;
      ANode: TTMSFNCTreeViewVirtualNode; var AColor: TTMSFNCGraphicsColor);
    procedure eFindTyping(Sender: TObject);
  private
    { Private declarations }
    FAgNo: Integer;
    FAgSkidka: Boolean;
    FSumSkidka: Double;
    FAgName: string;
    procedure ListAgent;
  public
    { Public declarations }
    property NoAgent: Integer read FAgNo;
    property isSkidka: Boolean read FAgSkidka;
    property SumSkidka: Double read FSumSkidka;
    property NameAgent: string read FAgName;
    procedure LoadList;
  end;

var
  fmSelAgn: TfmSelAgn;

implementation

uses
  frmMain;

threadvar
  FPage, FSPage: Integer;

{$R *.fmx}

{ TfmSelAgn }

procedure TfmSelAgn.EditButton1Click(Sender: TObject);
begin
 eFindSity.Text:='';
 LoadList;
 EFindSity.SetFocus;
end;

procedure TfmSelAgn.EFindSityTyping(Sender: TObject);
begin
  LoadList;
end;

procedure TfmSelAgn.eFindTyping(Sender: TObject);
begin
 if eFind.Text.Trim<>'' then
 begin
   ListAgent;
 end;
end;

procedure TfmSelAgn.FormCreate(Sender: TObject);
begin
  FPage := 0;
  FSPage := 0;
end;

procedure TfmSelAgn.ListAgent;
var
  ANode: TTMSFNCTreeViewNode;
begin
  try
    FPage := 0;
    tlAgn.Nodes.Clear;
    dxAdd.Enabled := tlSity.FocusedNode.DataInteger > 0;
    qUsr.Close;
    qUsr.Prepare;
    qUsr.ParamByName('NO_SITY').AsInteger := tlSity.FocusedNode.DataInteger;
    qUsr.ParamByName('AGN').AsString := eFind.Text;
    qUsr.ParamByName('PG').AsInteger := FPage;
    qUsr.Active := true;
    if qUsr.RecordCount > 0 then
    begin
      qUsr.First;
     // fmMain.dxUpdSity.Enabled := AFocusedNode.Values[1] <> -1;
     // fmMain.dxDelSity.Enabled := AFocusedNode.Values[1] <> -1;
      try
        tlAgn.BeginUpdate;
        repeat
          ANode := tlAgn.AddNode;
          if tlSity.FocusedNode.DataInteger = -1 then
          begin
            ANode.Text[0] := qUsr.FieldByName('FULL_NAME').AsString;
          end
          else
          begin
            ANode.Text[0] := qUsr.FieldByName('AG_NAME').AsString;
          end;
          ANode.DataInteger := qUsr.FieldByName('NO_AGN').AsInteger;
          ANode.Text[1] := qUsr.FieldByName('AG_DOLG').AsFloat.ToString;
          ANode.Text[2] := qUsr.FieldByName('AG_PRED').AsFloat.ToString;
          ANode.Text[3] := qUsr.FieldByName('SUM_SKIDKA').AsFloat.ToString;
          if qUsr.FieldByName('IS_SKIDKA').AsInteger = 1 then
          begin
            ANode.Values[0].CollapsedIconName := 'Item5';
            ANode.Values[0].ExpandedIconName := 'Item5';
          end else
          begin
            ANode.Values[0].CollapsedIconName := 'Item4';
            ANode.Values[0].ExpandedIconName := 'Item4';
          end;
          if not qUsr.FieldByName('STATUS').isNull then
          begin
           // if qUsr.FieldByName('STATUS').AsInteger <> 0 then
           //   ANode.OverlayIndex := 8 + qUsr.FieldByName('STATUS').AsInteger;
          end;
          qUsr.Next;
        until (qUsr.Eof);
      finally
        tlAgn.EndUpdate;
        if tlAgn.Nodes.Count>0 then
        begin
          tlAgn.SelectNode(tlAgn.Nodes[0]);
        end;
      end;
    end;
  except
  end;
end;

procedure TfmSelAgn.LoadList;
var
  Node: TTMSFNCTreeViewNode;
begin
  tlSity.AdaptToStyle := True;
  tlAgn.AdaptToStyle := True;
  // Это для поиска
  try
    tlSity.BeginUpdate;
    tlSity.Nodes.Clear;
    if trim(eFindSity.Text) = '' then
    begin
      Node := tlSity.AddNode();
      Node.Text[0] := 'Все';
      Node.DataInteger := -1;
      Node.Values[0].CollapsedIconName := 'Item1';
      Node.Values[0].ExpandedIconName := 'Item1';
    end;
    // -------------------------
    qRead.Close;
    qRead.Prepare;
    qRead.ParamByName('SK').AsInteger := FSPage;
    qRead.ParamByName('FNDSITY').AsString := trim(eFindSity.Text);
    qRead.Active := true;
    if qRead.RecordCount > 0 then
    begin
      repeat
        Node := tlSity.AddNode;
        Node.Text[0] := qRead.FieldByName('ST_NAME').AsString;
        Node.DataInteger:= qRead.FieldByName('NO_ST').AsInteger;
        Node.Values[0].CollapsedIconName := 'Item2';
        Node.Values[0].ExpandedIconName := 'Item2';
        if qRead.FieldByName('IS_STAR').AsInteger = 1 then
        begin
           Node.Values[0].CollapsedIconName := 'Item3';
           Node.Values[0].ExpandedIconName := 'Item3';
        end;
        qRead.Next;
      until qRead.Eof;
    end;
    // -------------------------
    if tlSity.Nodes.Count>0 then
     begin
       tlSity.SelectNode(tlSity.Nodes[0]);
       ListAgent;
     end;
  finally
    tlSity.EndUpdate;
  end;
end;

procedure TfmSelAgn.tlAgnGetNodeSelectedColor(Sender: TObject;
  ANode: TTMSFNCTreeViewVirtualNode; var AColor: TTMSFNCGraphicsColor);
begin
 if ANode.Node.Text[2].ToDouble >0 then
 begin
   AColor :=  TAlphaColors.Aqua;
 end;
 if ANode.Node.Text[1].ToDouble >0 then
 begin
   AColor :=  TAlphaColors.Magenta;
 end;
end;

procedure TfmSelAgn.tlAgnGetNodeSelectedTextColor(Sender: TObject;
  ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer;
  var ATextColor: TTMSFNCGraphicsColor);
begin
 if ANode.Node.Text[2].ToDouble >0 then
 begin
   ATextColor :=  TAlphaColors.Black;
 end;
 if ANode.Node.Text[1].ToDouble >0 then
 begin
   ATextColor :=  TAlphaColors.Black;
 end;
end;

procedure TfmSelAgn.tlAgnGetNodeTextColor(Sender: TObject;
  ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer;
  var ATextColor: TTMSFNCGraphicsColor);
begin
 if ANode.Node.Text[2].ToDouble >0 then
 begin
   ATextColor :=  TAlphaColors.Aqua;
 end;
 if ANode.Node.Text[1].ToDouble >0 then
 begin
   ATextColor :=  TAlphaColors.Magenta;
 end;
end;

procedure TfmSelAgn.tlSityFocusedNodeChanged(Sender: TObject;
  ANode: TTMSFNCTreeViewVirtualNode);
begin
 eFind.Text := '';
 ListAgent;
end;

end.

