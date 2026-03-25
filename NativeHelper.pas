unit NativeHelper;

interface

uses NativeXML, Classes;

type
 TXMLNode_ = class helper for TXMLNode
 private
   function GetNameUnicode: string;
   procedure SetNodeUnicode(const aName: string);
   function GetAttributeUnicodeValue(index:integer): string;
   procedure SetAttributeUnicodeValue(index:integer; const aValue:string);
   function GetAttributeUnicodeName(index:integer):string;
   procedure SetAttributeUnicodeName(index:integer; aValue:string);
   function GetAttributeByUnicodeName(const aName: string):string;
   procedure SetAttributeByUnicodeName(const aName,aValue: string);
 public
   function  NodeNew(const AName: String): TXmlNode;overload;
   function  FindNode(const NodeName: String): TXmlNode;overload;
   function  ReadAttributeString(const AName: String; const ADefault: String = ''): String; overload;
   procedure AttributeAdd(const AName, AValue: String); overload;
   procedure WriteAttributeString(const AName: String; const AValue: String; const ADefault: String = ''); overload;
   procedure NodesByName(const AName: string; AList: TList);overload;
   property  NameUnicode: string read GetNameUnicode write SetNodeUnicode;
   property  AttributeUnicodeValue[Index: integer]: String read GetAttributeUnicodeValue write SetAttributeUnicodeValue;
   property  AttributeUnicodeName[Index: integer]: String read GetAttributeUnicodeName write SetAttributeUnicodeName;
   property AttributeByUnicodeName[const AName: String]: String read GetAttributeByUnicodeName
            write SetAttributeByUnicodeName;
end;


implementation

{ TXMLNode_ }

procedure TXMLNode_.AttributeAdd(const AName, AValue: String);
begin
  AttributeAdd(UTF8String(AName),UTF8String(AValue));
end;

function TXMLNode_.FindNode(const NodeName: String): TXmlNode;
begin
  Result:=FindNode(UTF8String(NodeName))
end;

function TXMLNode_.GetAttributeByUnicodeName(const aName: string): string;
begin
  Result:=string(AttributeByName[UTF8String(aName)]);
end;

function TXMLNode_.GetAttributeUnicodeName(index: integer): string;
begin
  Result:=string(AttributeName[index])
end;

function TXMLNode_.GetAttributeUnicodeValue(index:integer): string;
begin
  Result:=string(AttributeValue[index])
end;

function TXMLNode_.GetNameUnicode: string;
begin
  Result:=string(Name);
end;

function TXMLNode_.NodeNew(const AName: String): TXmlNode;
begin
  Result:=NodeNew(UTF8String(AName));
end;

procedure TXMLNode_.NodesByName(const AName: string; AList: TList);
begin
  if AList = nil then
    AList:=TsdNodeList.Create;
  AList.Clear;
  NodesByName(UTF8String(AName),AList);
end;


function TXMLNode_.ReadAttributeString(const AName,
  ADefault: String): String;
begin
  Result:=string(ReadAttributeString(UTF8String(AName),UTF8String(ADefault)))
end;

procedure TXMLNode_.SetAttributeByUnicodeName(const aName, aValue: string);
begin
  AttributeValueByName[UTF8String(aName)]:=UTF8String(aValue);
end;

procedure TXMLNode_.SetAttributeUnicodeName(index: integer; aValue: string);
begin
  AttributeName[index]:=UTF8String(aValue);
end;

procedure TXMLNode_.SetAttributeUnicodeValue(index:integer;const aValue: string);
begin
  AttributeValue[index]:=UTF8String(aValue);
end;

procedure TXMLNode_.SetNodeUnicode(const aName: string);
begin
  Name:=UTF8String(aName);
end;

procedure TXMLNode_.WriteAttributeString(const AName, AValue, ADefault: String);
begin
  WriteAttributeString(UTF8String(AName),UTF8String(AValue),UTF8String(ADefault));
end;

end.
