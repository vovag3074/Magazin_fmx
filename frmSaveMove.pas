unit frmSaveMove;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.Edit, FMX.TMSFNCEdit,
  FMX.TMSFNCImage, NativeXml, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfmSMove = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    TMSFNCHTMLText1: TTMSFNCHTMLText;
    TMSFNCButton1: TTMSFNCButton;
    btOK: TTMSFNCButton;
    eSave: TTMSFNCEdit;
    TMSFNCButton3: TTMSFNCButton;
    SD: TSaveDialog;
    TMSFNCImage1: TTMSFNCImage;
    qMod: TFDQuery;
    qMod2: TFDQuery;
    qExp: TFDQuery;
    qExpZak: TFDQuery;
    qExpZalList: TFDQuery;
    Label1: TLabel;
    qTypeKat: TFDQuery;
    qExpKat: TFDQuery;
    qExpUser: TFDQuery;
    procedure TMSFNCButton3Click(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
     /// <summary>
    /// Основная процедура экспорта в XML файл
    /// </summary>
    procedure ExportLogMove;
    /// <summary>
    /// Экспорт заказов
    /// </summary>
    procedure ExportZakaz;
    /// <summary>
    /// Экспорт списка категорий
    /// </summary>
    /// <exception cref="Старая версия">
    /// Нет списка категорий
    /// </exception>
    /// <remarks>
    /// Добавлено 10,10,2016. Позволяет избежать ситуации на магазине, если в
    /// цеху переименовали категорию.
    /// </remarks>
    procedure ExportKatList;
      /// <summary>
    /// Экспортируем список клиентов вместе с заказами
    /// </summary>
    /// <remarks>
    /// 21.04.2017 начало
    /// </remarks>
    procedure ExportUserList;
  public
    { Public declarations }
    XMLDoc: TNativeXml;
    Node: TXmlNode;
  end;

var
  fmSMove: TfmSMove;

implementation

uses
  frmMain;

{$R *.fmx}

procedure TfmSMove.btOKClick(Sender: TObject);
begin
  ExportLogMove;
  ModalResult := mrOk;
end;

procedure TfmSMove.ExportKatList;
var
  I: Integer;
begin
  // Вначале сохраняем список типов категорий
  qTypeKat.Close;
  qTypeKat.Prepare;
  qTypeKat.Active := True;
  if qTypeKat.RecordCount > 0 then
  begin
    qTypeKat.First;
    repeat
      Node := XMLDoc.Root.NodeNew('Type_Kat');
      Node.AttributeAdd('TypeCode', qTypeKat.FieldByName('CODE_TYPE').AsString);
      Node.AttributeAdd('TypeName', qTypeKat.FieldByName('NAME_TYPE').AsString);
      qTypeKat.Next;
    until (qTypeKat.Eof);
  end;
  qTypeKat.Close;
  // Теперь сохраняем список категорий
  qExpKat.Close;
  qExpKat.Prepare;
  qExpKat.Active := True;
  if qExpKat.RecordCount > 0 then
  begin
    qExpKat.First;
    repeat
      Node := XMLDoc.Root.NodeNew('Kat_List');
      Node.AttributeAdd('Name_Kat', qExpKat.FieldByName('NAZVAN').AsString);
      Node.AttributeAdd('Sum_Skid', FloatToStr(qExpKat.FieldByName('SUM_SKID').AsFloat));
      Node.AttributeAdd('Kode_Kat', qExpKat.FieldByName('UIN_KAT').AsString);
      Node.AttributeAdd('TypeCode', qExpKat.FieldByName('CODE_TYPE').AsString);
      qExpKat.Next;
    until (qExpKat.Eof);
  end;
  qExpKat.Close;
end;

procedure TfmSMove.ExportLogMove;
var
  S: string;
begin
  XMLDoc := TNativeXml.Create(Self);
  XMLDoc.CreateName('MoveTovar'); // создали корневой узел
  // 19.07.2013 добавил UID для предотвращения двойной загрузки
  Node := XMLDoc.Root.NodeNew('UUID_Move');
  myCreateGUID(S);
  Node.Value := S;
  // Пишем список моделей с размерами
  fmMain.StartReadTransaction;
  qMod.Close;
  qMod.Prepare;
  qMod.Active := True;
  if qMod.RecordCount > 0 then
  begin
    qMod.First;
    repeat
      Node := XMLDoc.Root.NodeNew('Model');
      Node.AttributeAdd('ModCode', qMod.FieldByName('UN_CODE').AsString);
      Node.AttributeAdd('ModName', qMod.FieldByName('M_NAZVAN').AsString);
      Node.AttributeAdd('KatName', qMod.FieldByName('K_NAZVAN').AsString);
      Node.AttributeAdd('Mod_Barcode', qMod.FieldByName('BARCODE').AsString);
      Node.AttributeAdd('ModCena', FloatToStr(qMod.FieldByName('M_CENA').AsFloat));
      Node.AttributeAdd('ModSize', IntToStr(qMod.FieldByName('NO_SIZE').AsInteger));
      qMod.Next;
    until qMod.Eof;
  end;
  // Пишем список моделей с размерами из заказов. Защита от дурака
  qMod2.Close;
  qMod2.Prepare;
  qMod2.Active := True;
  if qMod2.RecordCount > 0 then
  begin
    qMod2.First;
    repeat
      Node := XMLDoc.Root.NodeNew('Model');
      Node.AttributeAdd('ModCode', qMod2.FieldByName('UN_CODE').AsString);
      Node.AttributeAdd('ModName', qMod2.FieldByName('M_NAZVAN').AsString);
      Node.AttributeAdd('KatName', qMod2.FieldByName('K_NAZVAN').AsString);
      Node.AttributeAdd('Mod_Barcode', qMod2.FieldByName('BARCODE').AsString);
      Node.AttributeAdd('ModCena', FloatToStr(qMod2.FieldByName('M_CENA').AsFloat));
      Node.AttributeAdd('ModSize', IntToStr(qMod2.FieldByName('NO_SIZE').AsInteger));
      qMod2.Next;
    until qMod2.Eof;
  end;
  // Пишем сам журнал переноса
  qExp.Close;
  qExp.Prepare;
  qExp.Active := True;
  if qExp.RecordCount > 0 then
  begin
    qExp.First;
    repeat
      // создаем дочерний узел
      Node := XMLDoc.Root.NodeNew('Tovar');
      Node.AttributeAdd('ModNo', qExp.FieldByName('UN_CODE').AsString);
      Node.AttributeAdd('Data_Move', DateToStr(qExp.FieldByName('DATA_TIME_MOVE').AsDateTime));
      qExp.Next;
    until qExp.Eof;
    ExportZakaz;
    ExportKatList;
    ExportUserList;
    XMLDoc.BinaryMethod := bmZlib;
    XMLDoc.SaveToBinaryFile(eSave.Text);
    //XMLDoc.SaveToFile(eSave.Text);
  end;
  FreeAndNil(XMLDoc);
end;

procedure TfmSMove.ExportUserList;
begin
  // -------------------------------------------------------------
  // Пишем список людей с городами
  // -------------------------------------------------------------
  try
    qExpUser.Close;
    qExpUser.Prepare;
    qExpUser.Active := True;
    if qExpUser.RecordCount > 0 then
    begin
      qExpUser.First;
      repeat
        Node := XMLDoc.Root.NodeNew('AgentList');
        Node.AttributeAdd('SityCode', qExpUser.FieldByName('SITY_CODE').AsString);
        Node.AttributeAdd('SityName', qExpUser.FieldByName('ST_NAME').AsString);
        Node.AttributeAdd('AgentCode', qExpUser.FieldByName('AG_CODE').AsString);
        Node.AttributeAdd('AgentName', qExpUser.FieldByName('AG_NAME').AsString);
        Node.AttributeAdd('AgentOpis', qExpUser.FieldByName('AG_DOP').AsString);
        Node.AttributeAdd('isSkidka', BoolToStr(qExpUser.FieldByName('IS_SKIDKA').AsInteger=1, True));
        Node.AttributeAdd('ValName', qExpUser.FieldByName('NAZVAN').AsString);
        qExpUser.Next;
      until (qExpUser.Eof);
    end;
  except
    on E: Exception do
    begin
      ShowError(E.Message);
    end;
  end;
end;

procedure TfmSMove.ExportZakaz;
begin
// ----------------------------------------------------------
  // Пишем список заказов
  // ----------------------------------------------------------
  qExpZak.Close;
  qExpZak.Prepare;
  qExpZak.Active := True;
  if qExpZak.RecordCount > 0 then
  begin
    qExpZak.First;
    repeat
      Node := XMLDoc.Root.NodeNew('Zakaz');
      Node.AttributeAdd('ZakCode', qExpZak.FieldByName('CODE_ZAK').AsString);
      Node.AttributeAdd('AgentCode', qExpZak.FieldByName('BAR_CODE').AsString);
      Node.AttributeAdd('CountMod', FloatToStr(qExpZak.FieldByName('CNT_MOD').AsFloat));
      qExpZak.Next;
    until (qExpZak.Eof);
  end;
  // ----------------------------------------------------------
  // Пишем список моделей с заказом
  // ----------------------------------------------------------
  qExpZalList.Close;
  qExpZalList.Prepare;
  qExpZalList.Active := True;
  if qExpZalList.RecordCount > 0 then
  begin
    repeat
      Node := XMLDoc.Root.NodeNew('ZakDetail');
      Node.AttributeAdd('ZakCode', qExpZalList.FieldByName('CODE_ZAK').AsString);
      Node.AttributeAdd('ModelCode', qExpZalList.FieldByName('UN_CODE').AsString);
      Node.AttributeAdd('CountModel', FloatToStr(qExpZalList.FieldByName('CNT_MOD').AsFloat));
      qExpZalList.Next;
    until (qExpZalList.Eof);
  end;
end;

procedure TfmSMove.TMSFNCButton3Click(Sender: TObject);
var
  S: string;
begin
  S := FormatDateTime('dd_mmm_yyyy_hh_mm', now);
  SD.FileName := S;
  if SD.Execute then
  begin
    eSave.Text := SD.FileName;
    btOK.Enabled := trim(eSave.Text) <> '';
  end;
end;

end.

