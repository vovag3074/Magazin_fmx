unit frmExportZakaz;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, NativeXml,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.TMSFNCButton,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TfmExpZak = class(TForm)
    Panel1: TPanel;
    eName: TEdit;
    EllipsesEditButton1: TEllipsesEditButton;
    dxAll: TCheckBox;
    Label1: TLabel;
    OD: TSaveDialog;
    TMSFNCButton2: TTMSFNCButton;
    btOK: TTMSFNCButton;
    qExpAgn: TFDQuery;
    qExp: TFDQuery;
    qExpMod: TFDQuery;
    qSize: TFDQuery;
    qZak: TFDQuery;
    qComt: TFDCommand;
    eInfo: TLabel;
    procedure EllipsesEditButton1Click(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure StartExport;
    procedure ShowWaitP(isVisible:Boolean;InfoText:string = '');
  public
    { Public declarations }
  end;

var
  fmExpZak: TfmExpZak;

implementation

uses
  frmMain, frmZakazy;

{$R *.fmx}

procedure TfmExpZak.btOKClick(Sender: TObject);
begin
  StartExport;
  ModalResult := mrOk;
end;

procedure TfmExpZak.EllipsesEditButton1Click(Sender: TObject);
var
  S: string;
begin
  S := FormatDateTime('dd_mmm_yyyy', StrToDate(fmZak.eData.Text));
  // S := S + '.zak';
  OD.FileName := S;
  if OD.Execute then
  begin
    eName.Text := OD.FileName;
    btOK.Enabled := eName.Text.Length > 0;
  end;
end;

procedure TfmExpZak.ShowWaitP(isVisible: Boolean; InfoText: string);
begin
 eInfo.Visible:=isVisible;
 eInfo.Text:=InfoText;
 Application.ProcessMessages;
end;

procedure TfmExpZak.StartExport;
var
  XMLDoc: TNativeXml;
  Node: TXmlNode;
const
  S_Sel = 'select distinct MST.UN_CODE, '+
          '      SZD.CNT_MOD, '+
          '      SZD.DOG_SUM, '+
          '      SZD.IS_DOG, '+
          '      SZ.CODE_ZAKAZA, '+
          '      SZ.DATA_PRIN, '+
          '      SZ.PRIM_ZAK, '+
          '      SZ.IS_OK, '+
          '      AG.BAR_CODE '+
' from AGENTS AG              '+
' inner join SET_ZAKAZ SZ on (AG.NO_AGN = SZ.NO_AGN) '+
' inner join SET_ZAKAZ_DETAIL SZD on (SZ.NO_SZ = SZD.NO_SET_ZAK) '+
' inner join MODEL_SIZE_TABLE MST on (SZD.NO_MSIS = MST.NO_MST)';
  S_on = ' where ((SZ.DATA_OTP = :DE) and (SZ.IS_EXP = 0)) ';
  S_Off = ' where ((SZ.DATA_OTP = :DE)) ';
  S_Ord = ' order by SZ.CODE_ZAKAZA, MST.UN_CODE ';
begin
  fmMain.StartReadTransaction;
  qZak.Prepare;
  qZak.SQL.Clear;
  if dxAll.isChecked then
  begin
    qZak.Sql.Add(S_Sel+S_on+S_Ord);
  end
  else
  begin
    qZak.SQL.Add(S_Sel + S_Off + S_Ord);
  end;
  qZak.Prepare;
  XMLDoc := TNativeXml.Create(Self);
  XMLDoc.CreateName('SetZakaz'); // создали корневой узел
  // 04/11/2013 добавили заголовок с датой сохраняемого заказа
  Node := XMLDoc.Root.NodeNew('Data_Otp_Zakaz');
  Node.Value := (fmZak.eData.Text);
  // --------------------------------------------------------------------------
  // пишем агентов и города кот участвуют в заказах
  // ---------------------------------------------------------------------------
  ShowWaitP(true, 'Пишем участников');
  qExpAgn.Close;
  qExpAgn.Prepare;
  qExpAgn.ParamByName('DE').AsDate := StrToDate(fmZak.eData.Text);
  qExpAgn.Active := true;
  if qExpAgn.RecordCount > 0 then
  begin
    qExpAgn.First;
    repeat
      Node := XMLDoc.Root.NodeNew('Set_Zakaz_Agent');
      Node.AttributeAdd('Agent_Code', qExpAgn.FieldByName('AG_CODE').AsString);
      Node.AttributeAdd('Agent_Valut', qExpAgn.FieldByName('V_NAZVAN')
        .AsString);
      Node.AttributeAdd('Agent_Name', qExpAgn.FieldByName('AG_NAME').AsString);
      Node.AttributeAdd('Agent_Skidka',
        IntToStr(qExpAgn.FieldByName('IS_SKIDKA').AsInteger));
      Node.AttributeAdd('Sity_Code', qExpAgn.FieldByName('ST_CODE').AsString);
      Node.AttributeAdd('Sity_Name', qExpAgn.FieldByName('ST_NAME').AsString);
      qExpAgn.Next;
    until (qExpAgn.Eof);
  end;
  // --------------------------------------------------------------------------
  // Сверяем модели и размеры по заказу
  // ---------------------------------------------------------------------------
  // 1 - этап - проверяем и копируем модели
  ShowWaitP(true, 'Пишем модели');
  qExpMod.Close;
  qExpMod.Prepare;
  qExpMod.ParamByName('DE').AsDate := StrToDate(fmZak.eData.Text);
  qExpMod.Active := true;
  if qExpMod.RecordCount > 0 then
  begin
    qExpMod.First;
    repeat
      Node := XMLDoc.Root.NodeNew('Set_Zakaz_Model');
      Node.AttributeAdd('Kat_Name', qExpMod.FieldByName('K_NAZVAN').AsString);
      Node.AttributeAdd('Model_Name', qExpMod.FieldByName('M_NAZVAN').AsString);
      Node.AttributeAdd('Model_Code', qExpMod.FieldByName('BARCODE').AsString);
      Node.AttributeAdd('Model_Cena',
        FloatToStr(qExpMod.FieldByName('M_CENA').AsFloat));
      qExpMod.Next;
    until (qExpMod.Eof);
  end;
  // 2 - этап - проверяем и копируем размеры
  ShowWaitP(true, 'Пишем размеры');
  qSize.Close;
  qSize.Prepare;
  qSize.ParamByName('DE').AsDate := StrToDate(fmZak.eData.Text);
  qSize.Active := true;
  if qSize.RecordCount > 0 then
  begin
    qSize.First;
    repeat
      Node := XMLDoc.Root.NodeNew('Set_Size_Model');
      Node.AttributeAdd('Model_Code', qSize.FieldByName('BARCODE').AsString);
      Node.AttributeAdd('Size_Code', qSize.FieldByName('UN_CODE').AsString);
      Node.AttributeAdd('Size_Model',
        IntToStr(qSize.FieldByName('NO_SIZE').AsInteger));
      qSize.Next;
    until (qSize.Eof);
  end;
  // ---------------------------------------------------------------------------
  // Пишем заказы
  // 28.02.2018 добавил экспорт договорной суммы
  // ---------------------------------------------------------------------------
  ShowWaitP(true, 'Пишем заказы');
  qZak.Close;
  qZak.Prepare;
  qZak.ParamByName('DE').AsDate := StrToDate(fmZak.eData.Text);
  qZak.Active := true;
  if qZak.RecordCount > 0 then
  begin
    qZak.First;
    repeat
      Node := XMLDoc.Root.NodeNew('Zakaz_List_Detail');
      Node.AttributeAdd('Cod_Zakaza', qZak.FieldByName('CODE_ZAKAZA').AsString);
      Node.AttributeAdd('Data_Register',
        DateToStr(qZak.FieldByName('DATA_PRIN').AsDateTime));
      Node.AttributeAdd('Data_Send', (fmZak.eData.Text));
      Node.AttributeAdd('Dop_Zakaz', qZak.FieldByName('PRIM_ZAK').AsString);
      Node.AttributeAdd('Agent_Code', qZak.FieldByName('BAR_CODE').AsString);
      Node.AttributeAdd('Zak_OK',
        IntToStr(qZak.FieldByName('IS_OK').AsInteger));
      Node.AttributeAdd('Model_S_Code', qZak.FieldByName('UN_CODE').AsString);
      Node.AttributeAdd('Count_Model',
        FloatToStr(qZak.FieldByName('CNT_MOD').AsFloat));
      if qZak.FieldByName('DOG_SUM').IsNull then
      begin
        Node.AttributeAdd('Dog_Zena', '-1');
      end
      else
      begin
        Node.AttributeAdd('Dog_Zena',
          FloatToStr(qZak.FieldByName('DOG_SUM').AsFloat));
      end;
      Node.AttributeAdd('IS_Dog_Zena',
        booltostr(qZak.FieldByName('IS_DOG').AsBoolean, true));
      qZak.Next;
    until (qZak.Eof);
  end;
  // --------------------------------------------------------------------------
  XMLDoc.ExternalCodepage := 1251;
  XMLDoc.BinaryMethod := bmZlib;
  XMLDoc.SaveToBinaryFile(eName.Text);
  fmMain.EndReadTransaction;
  // XMLDoc.XmlFormat := xfReadable;
  // XMLDoc.SaveToFile(eName.Text);
  ShowWaitP(false, '');
  ShowInfo('Заказ на выбранную дату экспортирован');
  fmMain.StartMainTransaction;
  qComt.Prepare;
  qComt.Execute;
  fmMain.EndMainTransaction;
end;

end.

