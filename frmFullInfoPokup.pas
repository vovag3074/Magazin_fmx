unit frmFullInfoPokup;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCTreeView, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer,
  FMX.Edit, FMX.TMSFNCButton, fmx.Objects;

type
  TfmUserInfo = class(TForm)
    pnUserInfo: TPanel;
    tbAgn: TTabControl;
    tiDolg: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    TabItem5: TTabItem;
    tlLog: TTMSFNCTreeView;
    qLogAg: TFDQuery;
    tlOpl: TTMSFNCTreeView;
    qLOpl: TFDQuery;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    qReadUsr: TFDQuery;
    TMSFNCButton1: TTMSFNCButton;
    TMSFNCButton2: TTMSFNCButton;
    TMSFNCButton3: TTMSFNCButton;
    Panel1: TPanel;
    TMSFNCButton4: TTMSFNCButton;
    HintPanel: TCalloutPanel;
    HintLabel: TLabel;
    TMSFNCButton5: TTMSFNCButton;
    procedure TabItem3Click(Sender: TObject);
    procedure tlLogGetNodeTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
    procedure TabItem4Click(Sender: TObject);
    procedure TMSFNCButton4Click(Sender: TObject);
    procedure TMSFNCButton4MouseEnter(Sender: TObject);
    procedure TMSFNCButton4MouseLeave(Sender: TObject);
  private
    { Private declarations }
    FActiveProd: Integer;
    procedure ShowLog;
    procedure ShowOpl;
    procedure ShowUser;
  public
    { Public declarations }
    procedure ShowInfoUser(NoUser: Integer);
  end;

var
  fmUserInfo: TfmUserInfo;

implementation

uses
  frmMain, frmOplata;

{$R *.fmx}

{ TfmUserInfo }

procedure TfmUserInfo.ShowInfoUser(NoUser: Integer);
begin
  FActiveProd := NoUser;
  HintPanel.Visible := false;
  tbAgn.ActiveTab := tiDolg;
  tlOpl.AdaptToStyle := True;
  tlLog.AdaptToStyle := True;
  tlOpl.Nodes.Clear;
  tlLog.Nodes.Clear;
  tlLog.NodesAppearance.ExtendedFontColor := TAlphaColors.Khaki;
  tlLog.NodesAppearance.ExtendedFont.Size := 14;
  tlLog.NodesAppearance.ShowLines := True;
  ShowLog;
end;

procedure TfmUserInfo.ShowLog;
var
  Node, ANode: TTMSFNCTreeViewNode;
begin
  try
    tlLog.Nodes.Clear;
    qLogAg.Close;
    qLogAg.Prepare;
    qLogAg.ParamByName('NG').AsInteger := FActiveProd;
    qLogAg.Active := True;
    if qLogAg.RecordCount > 0 then
    begin
      qLogAg.First;
      repeat
        Node := tlLog.AddNode;
        Node.DataInteger := qLogAg.FieldByName('TYPE_OP').AsInteger;
        Node.Text[0] := DateToStr(qLogAg.FieldByName('DATA_PROD').AsDateTime);
        Node.Text[1] := qLogAg.FieldByName('OPERATION').AsString;
        Node.Text[2] := qLogAg.FieldByName('COUNT_OF_NO_MOD_SIZE').AsInteger.ToString;
        Node.Text[3] := qLogAg.FieldByName('SUM_OF_CENA_PROD').AsFloat.ToString;
        if qLogAg.FieldByName('LOG_DOP').AsString.Trim <> '' then
        begin
          ANode := tlLog.AddNode(Node);
          ANode.Text[0] := qLogAg.FieldByName('LOG_DOP').AsString;
          ANode.Extended := True;
        end;
        Node.Values[0].CollapsedIconName := 'Item2';
        Node.Values[0].ExpandedIconName := 'Item2';
        var I: Integer;
        I := qLogAg.FieldByName('TYPE_OP').AsInteger;
        case I of
          1:
            begin
              Node.Values[0].CollapsedIconName := 'Item3';
              Node.Values[0].ExpandedIconName := 'Item3';
            end;
          2:
            begin
              Node.Values[0].CollapsedIconName := 'Item4';
              Node.Values[0].ExpandedIconName := 'Item4';
            end;
          5:
            begin
              Node.Values[0].CollapsedIconName := 'Item5';
              Node.Values[0].ExpandedIconName := 'Item5';
            end;
          6:
            begin
              Node.Values[0].CollapsedIconName := 'Item6';
              Node.Values[0].ExpandedIconName := 'Item6';
            end;
          7:
            begin
              Node.Values[0].CollapsedIconName := 'Item7';
              Node.Values[0].ExpandedIconName := 'Item7';
            end;
        end;
        qLogAg.Next;
      until (qLogAg.Eof);
    end;
    tlLog.ExpandAll;
  except
  end;
end;

procedure TfmUserInfo.ShowOpl;
var
  Node: TTMSFNCTreeViewNode;
begin
     // 05.08.2020 ----- состояние оплат
  try
    tlOpl.Nodes.Clear;
    qLOpl.Close;
    qLOpl.Prepare;
    qLOpl.ParamByName('NG').AsInteger := FActiveProd;
    qLOpl.Active := True;
    if qLOpl.RecordCount > 0 then
    begin
      qLOpl.First;
      repeat
        Node := tlOpl.AddNode();
        Node.Text[0] := qLOpl.FieldByName('NAZVAN').AsString;
        Node.Text[1] := DateToStr(qLOpl.FieldByName('DATA_PROD').AsDateTime);
        Node.Text[2] := DateToStr(qLOpl.FieldByName('DATA_OPL').AsDateTime);
        Node.Text[3] := qLOpl.FieldByName('CENA_PROD').AsFloat.ToString;
        Node.Text[4] := qLOpl.FieldByName('OPLATA').AsFloat.ToString;
        qLOpl.Next;
      until qLOpl.Eof;
    end;
  finally
  end;
end;

procedure TfmUserInfo.ShowUser;
begin
  qReadUsr.Prepare;
  qReadUsr.ParamByName('NG').AsInteger := FActiveProd;
  qReadUsr.Active := True;
//  eName.Text := qReadUsr.FieldByName('AG_NAME').AsString;
//  eVal.EditValue := qReadUsr.FieldByName('PRED_VAL').AsInteger;
//  cbSkid.Checked := qReadUsr.FieldByName('IS_SKIDKA').AsInteger = 1;
//  eDolg.EditValue := qReadUsr.FieldByName('AG_DOLG').AsFloat;
//  ePred.EditValue := qReadUsr.FieldByName('AG_PRED').AsFloat;
//  eSum.EditValue := qReadUsr.FieldByName('SUM_SKIDKA').AsFloat;
//  eStat.EditValue := qReadUsr.FieldByName('STATUS').AsInteger;
  qReadUsr.Close;
end;

procedure TfmUserInfo.TabItem3Click(Sender: TObject);
begin
  ShowOpl;
end;

procedure TfmUserInfo.TabItem4Click(Sender: TObject);
begin
 ShowUser;
end;

procedure TfmUserInfo.tlLogGetNodeTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
begin
  if ANode.Node.DataInteger = 1 then
  begin
    ATextColor := TAlphaColors.Lightgreen;
  end
  else if ANode.Node.DataInteger = 2 then
  begin
    ATextColor := TAlphaColors.Yellow;
  end;
end;

procedure TfmUserInfo.TMSFNCButton4Click(Sender: TObject);
begin
  try
    fmOpl := TfmOpl.Create(fmMain);
    fmOpl.dxRet.Visible := False;
    fmOpl.ReadAgent(FActiveProd, 0, now);
    if fmOpl.ShowModal = mrOk then
    begin
     // ReadProd;
    end;
  finally
    fmOpl.Free;
    fmOpl := nil;
  end;
end;

procedure TfmUserInfo.TMSFNCButton4MouseEnter(Sender: TObject);
var
  p, r: TRectF;
  s: string;
begin
  if (Sender is TControl) then
  begin

    if Sender is TTMSFNCButton then
      s := TTMSFNCButton(Sender).Text
    else
      s := TControl(Sender).TagString;
    p := TControl(Sender).AbsoluteRect;

    r := RectF(0, 0, 400, 1000);
    if HintLabel.Canvas <> nil then
    begin
      HintLabel.Canvas.Font.Size := 16;
      HintLabel.Canvas.MeasureText(r, s, true, [], TTextAlign.Center, TTextAlign.Center);
      HintPanel.Width := r.Width + 22;
      HintPanel.Height := r.Height + HintPanel.CalloutLength + 30;
    end;
    if (p.Left + TControl(Sender).Width / 2 > HintPanel.Width / 2) then
    begin
      HintPanel.CalloutPosition := TCalloutPosition.Bottom;
      HintPanel.Position.X := p.Left + TControl(Sender).Width / 2 - HintPanel.Width / 2;
      HintPanel.Position.Y := p.Top - TControl(Sender).Height - 15;
      HintLabel.Padding.Left := 0;
      HintLabel.Padding.Top := 0;
    end
    else
    begin
      HintPanel.CalloutPosition := TCalloutPosition.Left;
      HintPanel.Position.X := p.Left + TControl(Sender).Width;
      HintPanel.Position.Y := p.Top - HintPanel.Height / 2 - TControl(Sender).Height / 2;
      HintPanel.Width := HintPanel.Width + HintPanel.CalloutLength;
      HintLabel.Padding.Left := HintPanel.CalloutLength;
      HintLabel.Padding.Top := -HintPanel.CalloutLength;
    end;
    HintPanel.BringToFront;
    HintPanel.Visible := True;
    HintLabel.Text := s;
  end;
end;

procedure TfmUserInfo.TMSFNCButton4MouseLeave(Sender: TObject);
begin
 HintPanel.Visible := false;
end;

end.

