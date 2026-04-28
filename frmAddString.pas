unit frmAddString;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.TMSFNCButton;

type
  TfmGetStr = class(TForm)
    Panel1: TPanel;
    eString: TEdit;
    eLabel: TLabel;
    TMSFNCButton1: TTMSFNCButton;
    btOK: TTMSFNCButton;
    procedure eStringTyping(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function GetString(var myStr:String; eTitle:String='Введите строку'; eNamе:String='Строка'):Integer;

var
  fmGetStr: TfmGetStr;

implementation

uses
  frmMain;

{$R *.fmx}

function GetString(var myStr:String; eTitle:String='Введите строку'; eNamе:String='Строка'):Integer;
begin
  fmGetStr := TfmGetStr.Create(fmMain);
  fmGetStr.Caption:=eTitle;
  fmGetStr.eLabel.Text:=eNamе;
  fmGetStr.eString.Text := myStr.Trim;
  Result := fmGetStr.ShowModal;
  myStr :=  fmGetStr.eString.Text.Trim;
  fmGetStr.free;
  fmGetStr:=nil;
end;

procedure TfmGetStr.eStringTyping(Sender: TObject);
begin
 btOK.Enabled := eString.Text.Trim <> '';
end;

end.
