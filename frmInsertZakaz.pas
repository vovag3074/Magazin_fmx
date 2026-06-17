unit frmInsertZakaz;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.DateTimeCtrls,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TfmInsZak = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    eAgn: TEdit;
    Panel3: TPanel;
    eData: TDateEdit;
    eDop: TEdit;
    EllipsesEditButton1: TEllipsesEditButton;
    SearchEditButton1: TSearchEditButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmInsZak: TfmInsZak;

implementation

uses
  frmMain, frmZakazy;

{$R *.fmx}

procedure TfmInsZak.FormCreate(Sender: TObject);
begin
 eData.Date := StrToDate(fmZak.eData.Text);
end;

end.
