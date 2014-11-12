unit RxMemDSUtil;

// ---------------------------------------------------------------------------------------
// Дополнительные инструменты для работы с TRxMemoryData
// ---------------------------------------------------------------------------------------

interface

uses Classes, SysUtils, RxMemDS;

type
  // Прикладные исключения записи и чтения (сообщения на русском)
  ERxMemoryDataWriteError = class(Exception);
  ERxMemoryDataReadError  = class(Exception);
  // Обратная связь при чтении-записи
  TReadWriteRxMemoryDataCallback = procedure(ACurrent, ATotal : Integer; var ACancel : Boolean) of object;

  // Запись в поток. При ошибках генерируются исключения.
  procedure WriteRxMemoryDataToStream(AObject : TRxMemoryData; AStream : TStream; ABufSize : Integer = 32768; ACallback : TReadWriteRxMemoryDataCallback = nil);
  // Чтение из потока (структура и данные будут загружены из потока "как есть" - без учета текущей структуры).
  // При ошибках генерируются исключения.
  procedure ReadRxMemoryDataFromStream(AObject : TRxMemoryData; AStream : TStream; ABufSize : Integer = 32768; ACallback : TReadWriteRxMemoryDataCallback = nil);

  // Запись в файл. При ошибках генерируются исключения.
  procedure WriteRxMemoryDataToFile(AObject : TRxMemoryData; AFileName : String; AFileMode : Word = (fmCreate or fmOpenWrite or fmShareDenyWrite); ABufSize : Integer = 32768; ACallback : TReadWriteRxMemoryDataCallback = nil);
  // Чтение из файла. При ошибках генерируются исключения.
  procedure ReadRxMemoryDataFromFile(AObject : TRxMemoryData; AFileName : String; AFileMode : Word = (fmOpenRead or fmShareDenyWrite); ABufSize : Integer = 32768; ACallback : TReadWriteRxMemoryDataCallback = nil);

implementation

uses DB, TypInfo;

// ---------------------------------------------------------------------------------------
// Внутрение типы и константы
// ---------------------------------------------------------------------------------------

const
  // Поддерживаемые типы полей (запись, чтение)
  DefProcessableFields : set of TFieldType = [
    ftString, ftSmallint, ftInteger, ftWord, ftBoolean, ftFloat, ftCurrency, ftDate, ftTime, ftDateTime, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo, ftBytes
  ];

// ---------------------------------------------------------------------------------------
// Внутрение вызовы
// ---------------------------------------------------------------------------------------

procedure _WriteFieldValueToStream(AField : TField; AWriter : TWriter);
var tmpBool : Boolean;
begin
  with AField, AWriter do begin
    // Отслеживаем NULL-значение
    tmpBool := (IsNull and (not (DataType in [ftBlob, ftMemo, ftGraphic, ftFmtMemo])));
    WriteBoolean(tmpBool);
    if(tmpBool) then
      exit;
    // Строка или бинарные данные
    if((DataType in [ftString, ftBlob, ftMemo, ftGraphic, ftFmtMemo, ftBytes]) or IsBlob) then
      WriteString(AsString)
    else begin
      case(DataType) of
        // Целое
        ftSmallint, ftInteger, ftWord, ftAutoInc : WriteInteger(AsInteger);
        // Логическое
        ftBoolean : WriteBoolean(AsBoolean);
        // Вещественное
        ftFloat : WriteFloat(AsFloat);
        // Валюта
        ftCurrency : WriteCurrency(AsCurrency);
        // Дата и время
        ftDate, ftTime, ftDateTime : WriteDate(AsDateTime);
      else
        raise ERxMemoryDataWriteError.Create('Неожиданная ошибка записи (неизвестный тип поля).');
      end;
    end;
  end;
end;

procedure _ReadFieldValueFromStream(AField : TField; AReader : TReader);
begin
  with AField, AReader do begin
    // Отслеживаем NULL-значение
    if(ReadBoolean) then begin
      Value := 0;
      exit;
    end;
    // Строка или бинарные данные
    if((DataType in [ftString, ftBlob, ftMemo, ftGraphic, ftFmtMemo, ftBytes]) or IsBlob) then
      AsString := ReadString
    else begin
      case(DataType) of
        // Целое
        ftSmallint, ftInteger, ftWord, ftAutoInc : AsInteger := ReadInteger;
        // Логическое
        ftBoolean : AsBoolean := ReadBoolean;
        // Вещественное
        ftFloat : AsFloat := ReadFloat;
        // Валюта
        ftCurrency : AsCurrency := ReadCurrency;
        // Дата и время
        ftDate, ftTime, ftDateTime : AsDateTime := ReadDate;
      else
        raise ERxMemoryDataReadError.Create('Неожиданная ошибка записи (неизвестный тип поля).');
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
        tmp := ' записи ';
      if(AExceptionClass = ERxMemoryDataReadError) then
        tmp := ' чтения ';
      raise AExceptionClass.Create('Процесс' + tmp + 'прерван.');
    end;
  finally
    tmp := '';
  end;
end;

// ---------------------------------------------------------------------------------------
// Внешние вызовы
// ---------------------------------------------------------------------------------------

// Запись в поток. При ошибках генерируются исключения.

procedure WriteRxMemoryDataToStream(AObject : TRxMemoryData; AStream : TStream; ABufSize : Integer; ACallback : TReadWriteRxMemoryDataCallback);
var tmpWriter : TWriter;
    tmpRecNo  : Integer;
    i, n : Integer;
begin
  // Проверка параметров
  if(not Assigned(AObject)) then
    raise ERxMemoryDataWriteError.Create('Неверный параметр (AObject).');
  if(not Assigned(AStream)) then
    raise ERxMemoryDataWriteError.Create('Неверный параметр (AStream).');
  if(ABufSize <= 0) then
    raise ERxMemoryDataWriteError.Create('Неверный параметр (ABufSize).');
  with AObject do begin
    // Получаем текущую позицию (заодно проверям активность таблицы)
    tmpRecNo := RecNo;
    // Проверяем типы полей
    for i := 0 to Fields.Count - 1 do begin
      if(not (Fields[i].DataType in DefProcessableFields)) then
        raise ERxMemoryDataWriteError.Create('Поля данного типа не поддерживаются (поле ' + Fields[i].FieldName + ', тип ' + GetEnumName(TypeInfo(TFieldType), Integer(Fields[i].DataType)) + ').');
    end;
  end;
  // Далее
  AObject.DisableControls;
  tmpWriter := TWriter.Create(AStream, ABufSize);
  try
    with tmpWriter, AObject do begin
      // Вызываем callback
      _Callback(ACallback, 0, RecordCount, ERxMemoryDataWriteError);
      // Пишем сигнатуру и тип класса
      WriteSignature;
      WriteString(ClassName);
      // Пишем структуру
      WriteCollection(FieldDefs);
      // Пишем данные
      WriteInteger(RecordCount);
      WriteListBegin;
      First;
      n := 0;
      while(not EOF) do begin
        for i := 0 to Fields.Count - 1 do
          _WriteFieldValueToStream(Fields[i], tmpWriter);
        Inc(n);
        // Вызываем callback
        _Callback(ACallback, n, RecordCount, ERxMemoryDataWriteError);
        // Далее
        Next;
      end;
      WriteListEnd;
      if(n <> RecordCount) then
        raise ERxMemoryDataWriteError.Create('Неожиданная ошибка (несовпадение количества записей).');
      // Все
      FlushBuffer;
    end;
  finally
    tmpWriter.Free;
    AObject.RecNo := tmpRecNo;
    AObject.EnableControls;
  end;
end;

// Чтение из потока (структура и данные будут загружены из потока "как есть" - без учета текущей структуры).
// При ошибках генерируются исключения.

procedure ReadRxMemoryDataFromStream(AObject : TRxMemoryData; AStream : TStream; ABufSize : Integer; ACallback : TReadWriteRxMemoryDataCallback);
var tmpReader : TReader;
    i, j, n : Integer;
begin
  // Проверка параметров
  if(not Assigned(AObject)) then
    raise ERxMemoryDataReadError.Create('Неверный параметр (AObject).');
  if(not Assigned(AStream)) then
    raise ERxMemoryDataReadError.Create('Неверный параметр (AStream).');
  if(ABufSize <= 0) then
    raise ERxMemoryDataWriteError.Create('Неверный параметр (ABufSize).');
  // Проверяем - открыта ли таблица ? (и на чтении, и на записи - должна быть открыта)
  // AObject.Next;
  // Далее
  AObject.DisableControls;
  tmpReader := TReader.Create(AStream, ABufSize);
  try
    with tmpReader, AObject do begin
      // Чистим таблицу
      Open;
      EmptyTable;
      Close;
      FieldDefs.Clear;
      Fields.Clear;
      // Вызываем callback
      _Callback(ACallback, 0, 0, ERxMemoryDataReadError);
      // Читаем сигнатуру и тип класса
      ReadSignature;
      if(ReadString <> AObject.ClassName) then
        raise ERxMemoryDataReadError.Create('Несоответствие типов сохраненного объекта и объекта назначения.');
      // Читаем структуру
      ReadValue;
      ReadCollection(AObject.FieldDefs);
      // Открываем
      Open;
      // Проверяем типы полей
      for i := 0 to Fields.Count - 1 do begin
        if(not (Fields[i].DataType in DefProcessableFields)) then
          raise ERxMemoryDataReadError.Create('Поля данного типа не поддерживаются (поле ' + Fields[i].FieldName + ', тип ' + GetEnumName(TypeInfo(TFieldType), Integer(Fields[i].DataType)) + ').');
      end;
      // Читаем данные
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
        raise ERxMemoryDataReadError.Create('Неожиданная ошибка (несовпадение количества записей).');
      First;
      // Все
    end;
  finally
    tmpReader.Free;
    AObject.EnableControls;
  end;
end;

// Запись в файл. При ошибках генерируются исключения.

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

// Чтение из файла. При ошибках генерируются исключения.

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
