unit frmCalc;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.TMSFNCEdit,
  FMX.TMSFNCButton, FMX.NumberBox;

type
  TfmCalc = class(TForm)
    btCancel: TButton;
    btOk: TButton;
    eRes: TTMSFNCEdit;
    TMSFNCButton1: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    TMSFNCButton3: TTMSFNCButton;
    TMSFNCButton4: TTMSFNCButton;
    TMSFNCButton5: TTMSFNCButton;
    TMSFNCButton6: TTMSFNCButton;
    TMSFNCButton7: TTMSFNCButton;
    TMSFNCButton8: TTMSFNCButton;
    TMSFNCButton9: TTMSFNCButton;
    TMSFNCButton10: TTMSFNCButton;
    TMSFNCButton11: TTMSFNCButton;
    TMSFNCButton12: TTMSFNCButton;
    TMSFNCButton13: TTMSFNCButton;
    TMSFNCButton14: TTMSFNCButton;
    TMSFNCButton15: TTMSFNCButton;
    TMSFNCButton16: TTMSFNCButton;
    TMSFNCButton17: TTMSFNCButton;
    TMSFNCButton18: TTMSFNCButton;
    Panel1: TPanel;
    TMSFNCButton19: TTMSFNCButton;
    StatusBar1: TStatusBar;
    lbAkum: TLabel;
    Panel2: TPanel;
    lbOper: TLabel;
    procedure TMSFNCButton9Click(Sender: TObject);
    procedure TMSFNCButton11Click(Sender: TObject);
    procedure TMSFNCButton12Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCButton13Click(Sender: TObject);
    procedure TMSFNCButton17Click(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure TMSFNCButton18Click(Sender: TObject);
    procedure eResChange(Sender: TObject);
    procedure TMSFNCButton19Click(Sender: TObject);
  private
    { Private declarations }
    FAkum:Double;
    FOper:Integer; // 1=+;2=-;3=/;4=*;
    procedure setAkum(myAkum:Double);
    procedure setOper(Value:Integer);
    procedure Exec;
  public
    { Public declarations }
    property Akum: Double read FAkum write SetAkum;
    property Oper: Integer read FOper write setOper;
  end;

var
  fmCalc: TfmCalc;

procedure showCalc(var Owner:TEdit); overload;
procedure showCalc(var Owner:TNumberBox); overload;

implementation

uses
  frmMain;

{$R *.fmx}

var FOwner:TEdit;
    FNumOwner:TNumberBox;


procedure showCalc(var Owner:TNumberBox); overload;
var S:Double;
    r:tRectF;
    mc:tPointF;
begin
  FNumOwner:=Owner;
  r:=Owner.LocalRect;
  mc:=r.TopLeft;
  mc:=Owner.LocalToScreen(mc);
  S:=Owner.Value;
  fmCalc:=TfmCalc.Create(Owner);
   if ((mc.Y+40)+fmCalc.Height)>Screen.WorkAreaHeight  then
    mc.Y:=mc.Y-20-fmCalc.Height;
  fmCalc.Top:= round(mc.Y +20);
  fmCalc.Left:=Round(mc.X);
  fmCalc.eRes.Text:='0';
  fmCalc.setAkum(Owner.Text.ToDouble);  // devexpress  ведет себя так
  fmCalc.ShowModal(procedure (Result:TModalResult)
  begin
   if result = mrOk then
   begin
    S:=fmCalc.eRes.Text.ToDouble;
   end;
  end);
  Owner.Value:=S;
  fmCalc.Free;
end;

procedure showCalc(var Owner:TEdit);
var S:Double;
    r:tRectF;
    mc:tPointF;
begin
  FOwner:=Owner;
  r:=Owner.LocalRect;
  mc:=r.TopLeft;
  mc:=Owner.LocalToScreen(mc);
  S:=Owner.Text.ToDouble;
  fmCalc:=TfmCalc.Create(Owner);
   if ((mc.Y+40)+fmCalc.Height)>Screen.WorkAreaHeight  then
    mc.Y:=mc.Y-20-fmCalc.Height;
  fmCalc.Top:= round(mc.Y +20);
  fmCalc.Left:=Round(mc.X);
  fmCalc.eRes.Text:='0';
  fmCalc.setAkum(Owner.Text.ToDouble);  // devexpress  ведет себя так
  fmCalc.ShowModal(procedure (Result:TModalResult)
  begin
   if result = mrOk then
   begin
    S:=fmCalc.eRes.Text.ToDouble;
   end;
  end);
  Owner.Text:=S.ToString;
  fmCalc.Free;
end;

procedure TfmCalc.btOkClick(Sender: TObject);
begin
  FAkum:=0;
  Exec;
end;

procedure TfmCalc.eResChange(Sender: TObject);
var S:string;
begin
 S:=eRes.Text.Trim;
 if Length(S)>1 then
  if Pos('0',S)=1 then
   if Pos(',', S)<>2 then
   begin
    Delete(S,1,1);
    eRes.Text:=S;
   end;
end;

procedure TfmCalc.Exec;
var T:Double;
begin
 if Akum<>0 then
 begin
  if Oper<>0 then
  begin
   T:=eRes.Text.ToDouble;
   case Oper of
    1:
    begin
     T := T+Akum;
    end;
    2:
    begin
     T := Akum-T;
    end;
    3:
    begin
     T := Akum/T;
    end;
    4:
    begin
     T := Akum*T;
    end;
   end;
   eRes.Text := T.ToString;
   Akum:=T;
   Oper:=0;
  end else
  begin
    eRes.Text:=Akum.ToString;
  end;
 end;
end;

procedure TfmCalc.FormCreate(Sender: TObject);
begin
 Akum := 0;
 Oper := 0;
end;

procedure TfmCalc.setAkum(myAkum: Double);
begin
 if ((myAkum<>FAkum)) then
  begin
    FAkum := myAkum;
    lbAkum.Text := FAkum.ToString;
  end;
end;

procedure TfmCalc.setOper(Value: Integer);
begin
 if FOper <> Value then
  begin
    FOper := Value;
    case FOper of
    0:
    begin
      lbOper.Text := '';
    end;
    1:
    begin
     lbOper.Text := '+';
    end;
    2:
    begin
     lbOper.Text := '-';
    end;
    3:
    begin
     lbOper.Text := '/';
    end;
    4:
    begin
     lbOper.Text := '*';
    end;
   end;
  end;
end;

procedure TfmCalc.TMSFNCButton11Click(Sender: TObject);
begin
 if Pos(',',eRes.Text)=0 then
  eRes.Text :=eRes.Text+',';
end;

procedure TfmCalc.TMSFNCButton12Click(Sender: TObject);
var S:string;
begin
 S:=eRes.Text;
 Delete(S,(Length(S)),1);
 if S='' then
  S:='0';
 eRes.Text:=S;
end;

procedure TfmCalc.TMSFNCButton13Click(Sender: TObject);
begin
if Akum=0 then
begin
 Akum:=eRes.Text.ToDouble;
 Oper:= tTMSFNCButton(Sender).Tag;
 eRes.Text:='0';
end else
begin
 Exec;
 Akum:=eRes.Text.ToDouble;
 Oper:= tTMSFNCButton(Sender).Tag;
 eRes.Text:='0';
end;
end;

procedure TfmCalc.TMSFNCButton17Click(Sender: TObject);
begin
  Exec;
end;

procedure TfmCalc.TMSFNCButton18Click(Sender: TObject);
begin
 Akum:=0;
 eRes.Text:='0';
 eRes.SetFocus;
end;

procedure TfmCalc.TMSFNCButton19Click(Sender: TObject);
begin
 eRes.Text:= FloatToStr(eRes.Text.ToDouble*-1);
end;

procedure TfmCalc.TMSFNCButton9Click(Sender: TObject);
begin
 eRes.Text :=eRes.Text+tTMSFNCButton(Sender).Tag.ToString;
end;

end.
