unit RxMemDSUtil;

// ---------------------------------------------------------------------------------------
// �������������� ����������� ��� ������ � TRxMemoryData
// ---------------------------------------------------------------------------------------

interface

uses Classes, SysUtils, RxMemDS;

type
  // ���������� ���������� ������ � ������ (��������� �� �������)
  ERxMemoryDataWriteError = class(Exception);
  ERxMemoryDataReadError  = class(Exception);
  // �������� ����� ��� ������-������
  TReadWriteRxMemoryDataCallback = procedure(ACurrent, ATotal : Integer; var ACancel : Boolean) of object;

  // ������ � �����. ��� ������� ������������ ����������.
  procedure WriteRxMemoryDataToStream(AObject : TRxMemoryData; AStream : TStream; ABufSize : Integer = 32768; ACallback : TReadWriteRxMemoryDataCallback = nil);
  // ������ �� ������ (��������� � ������ ����� ��������� �� ������ "��� ����" - ��� ����� ������� ���������).
  // ��� ������� ������������ ����������.
  procedure ReadRxMemoryDataFromStream(AObject : TRxMemoryData; AStream : TStream; ABufSize : Integer = 32768; ACallback : TReadWriteRxMemoryDataCallback = nil);

  // ������ � ����. ��� ������� ������������ ����������.
  procedure WriteRxMemoryDataToFile(AObject : TRxMemoryData; AFileName : String; AFileMode : Word = (fmCreate or fmOpenWrite or fmShareDenyWrite); ABufSize : Integer = 32768; ACallback : TReadWriteRxMemoryDataCallback = nil);
  // ������ �� �����. ��� ������� ������������ ����������.
  procedure ReadRxMemoryDataFromFile(AObject : TRxMemoryData; AFileName : String; AFileMode : Word = (fmOpenRead or fmShareDenyWrite); ABufSize : Integer = 32768; ACallback : TReadWriteRxMemoryDataCallback = nil);

implementation

uses DB, TypInfo;

// ---------------------------------------------------------------------------------------
// ��������� ���� � ���������
// ---------------------------------------------------------------------------------------

const
  // �������������� ���� ����� (������, ������)
  DefProcessableFields : set of TFieldType = [
    ftString, ftSmallint, ftInteger, ftWord, ftBoolean, ftFloat, ftCurrency, ftDate, ftTime, ftDateTime, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo, ftBytes
  ];

// ---------------------------------------------------------------------------------------
// ��������� ������
// ---------------------------------------------------------------------------------------

procedure _WriteFieldValueToStream(AField : TField; AWriter : TWriter);
var tmpBool : Boolean;
begin
  with AField, AWriter do begin
    // ����������� NULL-��������
    tmpBool := (IsNull and (not (DataType in [ftBlob, ftMemo, ftGraphic, ftFmtMemo])));
    WriteBoolean(tmpBool);
    if(tmpBool) then
      exit;
    // ������ ��� �������� ������
    if((DataType in [ftString, ftBlob, ftMemo, ftGraphic, ftFmtMemo, ftBytes]) or IsBlob) then
      WriteString(AsString)
    else begin
      case(DataType) of
        // �����
        ftSmallint, ftInteger, ftWord, ftAutoInc : WriteInteger(AsInteger);
        // ����������
        ftBoolean : WriteBoolean(AsBoolean);
        // ������������
        ftFloat : WriteFloat(AsFloat);
        // ������
        ftCurrency : WriteCurrency(AsCurrency);
        // ���� � �����
        ftDate, ftTime, ftDateTime : WriteDate(AsDateTime);
      else
        raise ERxMemoryDataWriteError.Create('����������� ������ ������ (����������� ��� ����).');
      end;
    end;
  end;
end;

procedure _ReadFieldValueFromStream(AField : TField; AReader : TReader);
begin
  with AField, AReader do begin
    // ����������� NULL-��������
    if(ReadBoolean) then begin
      Value := 0;
      exit;
    end;
    // ������ ��� �������� ������
    if((DataType in [ftString, ftBlob, ftMemo, ftGraphic, ftFmtMemo, ftBytes]) or IsBlob) then
      AsString := ReadString
    else begin
      case(DataType) of
        // �����
        ftSmallint, ftInteger, ftWord, ftAutoInc : AsInteger := ReadInteger;
        // ����������
        ftBoolean : AsBoolean := ReadBoolean;
        // ������������
        ftFloat : AsFloat := ReadFloat;
        // ������
        ftCurrency : AsCurrency := ReadCurrency;
        // ���� � �����
        ftDate, ftTime, ftDateTime : AsDateTime := ReadDate;
      else
        raise ERxMemoryDataReadError.Create('����������� ������ ������ (����������� ��� ����).');
      end;
    end;
  end;
end;

procedure _Callback(ACallback : TReadWriteRxMemoryDataCallback; ACurrent, ATotal : Integer; AExceptionClass : ExceptClass);
var tmpCancel : Boolean;
    tmp : String;
begin
  if(not Assigned(ACallback)) then
    exit;
  tmpCancel := False;
  try
    ACallback(ACurrent, ATotal, tmpCancel);
    if(tmpCancel) then begin
      tmp := ' ';
      if(AExceptionClass = ERxMemoryDataWriteError) then
        tmp := ' ������ ';
      if(AExceptionClass = ERxMemoryDataReadError) then
        tmp := ' ������ ';
      raise AExceptionClass.Create('�������' + tmp + '�������.');
    end;
  finally
    tmp := '';
  end;
end;

// ---------------------------------------------------------------------------------------
// ������� ������
// ---------------------------------------------------------------------------------------

// ������ � �����. ��� ������� ������������ ����������.

procedure WriteRxMemoryDataToStream(AObject : TRxMemoryData; AStream : TStream; ABufSize : Integer; ACallback : TReadWriteRxMemoryDataCallback);
var tmpWriter : TWriter;
    tmpRecNo  : Integer;
    i, n : Integer;
begin
  // �������� ����������
  if(not Assigned(AObject)) then
    raise ERxMemoryDataWriteError.Create('�������� �������� (AObject).');
  if(not Assigned(AStream)) then
    raise ERxMemoryDataWriteError.Create('�������� �������� (AStream).');
  if(ABufSize <= 0) then
    raise ERxMemoryDataWriteError.Create('�������� �������� (ABufSize).');
  with AObject do begin
    // �������� ������� ������� (������ �������� ���������� �������)
    tmpRecNo := RecNo;
    // ��������� ���� �����
    for i := 0 to Fields.Count - 1 do begin
      if(not (Fields[i].DataType in DefProcessableFields)) then
        raise ERxMemoryDataWriteError.Create('���� ������� ���� �� �������������� (���� ' + Fields[i].FieldName + ', ��� ' + GetEnumName(TypeInfo(TFieldType), Integer(Fields[i].DataType)) + ').');
    end;
  end;
  // �����
  AObject.DisableControls;
  tmpWriter := TWriter.Create(AStream, ABufSize);
  try
    with tmpWriter, AObject do begin
      // �������� callback
      _Callback(ACallback, 0, RecordCount, ERxMemoryDataWriteError);
      // ����� ��������� � ��� ������
      WriteSignature;
      WriteString(ClassName);
      // ����� ���������
      WriteCollection(FieldDefs);
      // ����� ������
      WriteInteger(RecordCount);
      WriteListBegin;
      First;
      n := 0;
      while(not EOF) do begin
        for i := 0 to Fields.Count - 1 do
          _WriteFieldValueToStream(Fields[i], tmpWriter);
        Inc(n);
        // �������� callback
        _Callback(ACallback, n, RecordCount, ERxMemoryDataWriteError);
        // �����
        Next;
      end;
      WriteListEnd;
      if(n <> RecordCount) then
        raise ERxMemoryDataWriteError.Create('����������� ������ (������������ ���������� �������).');
      // ���
      FlushBuffer;
    end;
  finally
    tmpWriter.Free;
    AObject.RecNo := tmpRecNo;
    AObject.EnableControls;
  end;
end;

// ������ �� ������ (��������� � ������ ����� ��������� �� ������ "��� ����" - ��� ����� ������� ���������).
// ��� ������� ������������ ����������.

procedure ReadRxMemoryDataFromStream(AObject : TRxMemoryData; AStream : TStream; ABufSize : Integer; ACallback : TReadWriteRxMemoryDataCallback);
var tmpReader : TReader;
    i, j, n : Integer;
begin
  // �������� ����������
  if(not Assigned(AObject)) then
    raise ERxMemoryDataReadError.Create('�������� �������� (AObject).');
  if(not Assigned(AStream)) then
    raise ERxMemoryDataReadError.Create('�������� �������� (AStream).');
  if(ABufSize <= 0) then
    raise ERxMemoryDataWriteError.Create('�������� �������� (ABufSize).');
  // ��������� - ������� �� ������� ? (� �� ������, � �� ������ - ������ ���� �������)
  // AObject.Next;
  // �����
  AObject.DisableControls;
  tmpReader := TReader.Create(AStream, ABufSize);
  try
    with tmpReader, AObject do begin
      // ������ �������
      Open;
      EmptyTable;
      Close;
      FieldDefs.Clear;
      Fields.Clear;
      // �������� callback
      _Callback(ACallback, 0, 0, ERxMemoryDataReadError);
      // ������ ��������� � ��� ������
      ReadSignature;
      if(ReadString <> AObject.ClassName) then
        raise ERxMemoryDataReadError.Create('�������������� ����� ������������ ������� � ������� ����������.');
      // ������ ���������
      ReadValue;
      ReadCollection(AObject.FieldDefs);
      // ���������
      Open;
      // ��������� ���� �����
      for i := 0 to Fields.Count - 1 do begin
        if(not (Fields[i].DataType in DefProcessableFields)) then
          raise ERxMemoryDataReadError.Create('���� ������� ���� �� �������������� (���� ' + Fields[i].FieldName + ', ��� ' + GetEnumName(TypeInfo(TFieldType), Integer(Fields[i].DataType)) + ').');
      end;
      // ������ ������
      n := ReadInteger;
      ReadListBegin;
      j := 0;
      while(j <> n) do begin
        Append;
        for i := 0 to Fields.Count - 1 do
          _ReadFieldValueFromStream(Fields[i], tmpReader);
        Post;
        Inc(j);
        _Callback(ACallback, j, n, ERxMemoryDataReadError);
      end;
      ReadListEnd;
      if((j <> n) or (n <> RecordCount)) then
        raise ERxMemoryDataReadError.Create('����������� ������ (������������ ���������� �������).');
      First;
      // ���
    end;
  finally
    tmpReader.Free;
    AObject.EnableControls;
  end;
end;

// ������ � ����. ��� ������� ������������ ����������.

procedure WriteRxMemoryDataToFile(AObject : TRxMemoryData; AFileName : String; AFileMode : Word; ABufSize : Integer; ACallback : TReadWriteRxMemoryDataCallback);
var tmpStream : TFileStream;
begin
  tmpStream := TFileStream.Create(AFileName, AFileMode);
  try
    WriteRxMemoryDataToStream(AObject, tmpStream, ABufSize, ACallback);
  finally
    tmpStream.Free;
  end;
end;

// ������ �� �����. ��� ������� ������������ ����������.

procedure ReadRxMemoryDataFromFile(AObject : TRxMemoryData; AFileName : String; AFileMode : Word; ABufSize : Integer; ACallback : TReadWriteRxMemoryDataCallback);
var tmpStream : TFileStream;
begin
  tmpStream := TFileStream.Create(AFileName, AFileMode);
  try
    ReadRxMemoryDataFromStream(AObject, tmpStream, ABufSize, ACallback);
  finally
    tmpStream.Free;
  end;
end;

// ---------------------------------------------------------------------------------------

end.
