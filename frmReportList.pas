unit frmReportList;

interface

uses
  System.SysUtils, System.IOUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, FMX.Objects,
  FMX.ExtCtrls, fs_XML, FMX.TMSFNCButton;

type
  TfmRepList = class(TForm)
    Panel1: TPanel;
    lbListRep: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ImageViewer1: TImageViewer;
    Label1: TLabel;
    Label2: TLabel;
    Line1: TLine;
    Label3: TLabel;
    btOK: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    Layout1: TLayout;
    procedure btOKClick(Sender: TObject);
    procedure lbListRepDblClick(Sender: TObject);
  private
    { Private declarations }
    FRep: string;
    procedure AddReport(MyReport: string);
  public
    { Public declarations }
    procedure ListReport(RepCard: string);
    property ReportName: string read FRep;
  end;

var
  fmRepList: TfmRepList;

implementation

uses
  frmMain, frmReport;

{$R *.fmx}
{ TfmRepList }

procedure TfmRepList.AddReport(MyReport: string);
var
  Xml: TfsXMLDocument;
  Root: TfsXMLItem;
  item: TListBoxItem;
begin
  Xml := TfsXMLDocument.Create;
  try
    Xml.LoadFromFile(MyReport);
    Root := Xml.Root;
    item := TListBoxItem.Create(lbListRep);
    item.StyleLookup := 'FastReportList';
    item.TextSettings.Font.Size := 20;
    item.TextSettings.Font.Style := [TFontStyle.fsBold];
    item.StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor];
    item.Height := 85;
    item.Text := Root.Prop['ReportOptions.Name'];
    item.StylesData['Opisan'] := Root.Prop['ReportOptions.Description.Text'];
    item.StylesData['repName'] := MyReport;
    lbListRep.AddObject(item);
  finally
    Xml.Free;
  end;
end;

procedure TfmRepList.ListReport(RepCard: string);
var
  S: string;
begin
  lbListRep.BeginUpdate;
  lbListRep.Items.Clear;
  lbListRep.DefaultItemStyles.ItemStyle := 'FastReportList';
  for S in TDirectory.GetFiles(getReportPatch, RepCard) do
  begin
    AddReport(S);
    btOK.Enabled := lbListRep.Count > 0;
  end;
  lbListRep.EndUpdate;
  lbListRep.ItemIndex := 0;
end;

procedure TfmRepList.btOKClick(Sender: TObject);
var
  item: TListBoxItem;
begin
  if lbListRep.Count > 0 then
  begin
    item := lbListRep.Selected;
    FRep := item.StylesData['repName'].AsString;
    ModalResult := mrOK;
  end;
end;

procedure TfmRepList.lbListRepDblClick(Sender: TObject);
begin
  btOKClick(Sender);
end;

end.

