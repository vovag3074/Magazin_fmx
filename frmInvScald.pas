unit frmInvScald;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.TMSFNCButton, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCEdit, FMX.Edit, FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData,
  FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfmInv = class(TFrame)
    Panel1: TPanel;
    TMSFNCButton5: TTMSFNCButton;
    pnMod: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    pnZakList: TPanel;
    Panel4: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    TMSFNCButton1: TTMSFNCButton;
    tlMod: TTMSFNCTreeView;
    qKat: TFDQuery;
    procedure TMSFNCButton5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadINI;
    procedure SaveINI;
     /// <summary>
    /// „итаем содержимое склада. —начала по категори€м.
    /// </summary>
    /// <remarks>
    /// ≈сть особенность - если в категории ничего нет, то не отображаетс€
    /// даже в режиме "показать все"
    /// </remarks>
    procedure ListMod;
  end;

 var fmInv:TfmInv;

implementation

uses
  frmMain;

{$R *.fmx}

procedure TfmInv.ListMod;
var
  Node: TTMSFNCTreeViewNode;
begin
  tlMod.Nodes.Clear;
  fmMain.StartReadTransaction;
  qKat.Active := false;
  qKat.Prepare;
  qKat.ParamByName('IV').AsSmallInt := 0;
  qKat.Active := true;
  if qKat.RecordCount > 0 then
  begin
    qKat.First;
    repeat
      if qKat.FieldByName('SUM_OF_CNT_MOD').AsInteger > 0 then
      begin
        Node := tlMod.AddNode();
        //Node.Values[0] := qKat.FieldByName('NO_KAT').AsInteger;
        Node.Text[0] := qKat.FieldByName('NAZVAN').AsString + ' (' +
          FloatToStr(qKat.FieldByName('SUM_SKID').AsFloat) + ')';
       // Node.HasChildren := true;
       // Node.ImageIndex := 0;
       // Node.SelectedIndex := Node.ImageIndex;
      end;
      qKat.Next;
    until (qKat.Eof);
    //tlMod.FullExpand;
    //tlMod.GotoBOF;
  end;
  //ListActiveZakaz;
end;

procedure TfmInv.LoadINI;
begin
  pnMod.Width := myINI.ReadInteger('Sclad','ModList',300).ToSingle;
  pnZakList.Width := myINI.ReadInteger('Sclad','ZakList',300).ToSingle;
end;

procedure TfmInv.SaveINI;
begin
 myINI.WriteInteger('Sclad','ModList', Trunc(pnMod.Width));
 myINI.WriteInteger('Sclad','ZakList', Trunc(pnZakList.Width));
end;

procedure TfmInv.TMSFNCButton5Click(Sender: TObject);
begin
 fmMain.ClearOldFrame;
end;

end.
