unit frmFullInfoPokup;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfmUserInfo = class(TForm)
    pnUserInfo: TPanel;
    tbAgn: TTabControl;
    tiDolg: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    TabItem5: TTabItem;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowInfoUser(NoUser:Integer);
  end;

var
  fmUserInfo: TfmUserInfo;

implementation

uses
  frmMain;

{$R *.fmx}

{ TfmUserInfo }

procedure TfmUserInfo.ShowInfoUser(NoUser: Integer);
begin
 tbAgn.ActiveTab:=tiDolg;
end;

end.
