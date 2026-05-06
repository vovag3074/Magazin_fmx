unit frmAddProdaga;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData,
  FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView, FMX.Edit, FMX.TMSFNCButton,
  System.ImageList, FMX.ImgList, FMX.SVGIconImageList;

type
  TfmAddProdAgn = class(TForm)
    Panel1: TPanel;
    ListBox1: TListBox;
    tlList: TTMSFNCTreeView;
    eAgn: TEdit;
    EditButton1: TEditButton;
    eTxt: TEdit;
    eCena: TEdit;
    TMSFNCButton1: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    eType: TComboBox;
    SVGIconImageList1: TSVGIconImageList;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    EditButton2: TEditButton;
    procedure FormCreate(Sender: TObject);
    procedure eTypeChange(Sender: TObject);
    procedure TMSFNCButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAddProdAgn: TfmAddProdAgn;

implementation

uses
  frmMain, frmCalc;

{$R *.fmx}

procedure TfmAddProdAgn.eTypeChange(Sender: TObject);
begin
 eCena.Enabled := eType.ItemIndex > 0;
end;

procedure TfmAddProdAgn.FormCreate(Sender: TObject);
begin
 tlList.AdaptToStyle:=True;
end;

procedure TfmAddProdAgn.TMSFNCButton1Click(Sender: TObject);
begin
 showCalc(eCena);
end;

end.
