unit Logger;

interface

type
  TLogger = class
    private
      var
        curCopyId, strukId, month, year : integer;
        toMachine, sender, stkod: string;

    public
      constructor Create;
      destructor Destroy; override;

      function startLogging(toMachine, sender, stkod: string; strukId, month, year : integer) : boolean;
      function stopLogging() : boolean;
      function appendMsg(msg : string) : boolean;
  end;

implementation

uses DataM, SysUtils, Dialogs, DB;

constructor TLogger.Create;
begin
  inherited Create;
  curCopyId := 0;
end;

destructor TLogger.Destroy;
begin
  curCopyId := 0;
  inherited;
end;

function TLogger.startLogging(toMachine, sender, stkod: string; strukId, month, year : integer) : boolean;
begin
  self.toMachine := toMachine;
  self.strukId := strukId;
  self.month := month;
  self.year := year;
  self.sender := sender;
  self.stkod := stkod;
  try
    dm.AddCopyId.StoredProcName := 'ADD_K2D_PROGRAM_LOG_COPY_ID';
    dm.AddCopyId.ExecProc;
    curCopyId := dm.AddCopyId.Params.Items[0].AsInteger;
    dm.LogQuery.Close;
    dm.LogQuery.ParamByName('COPY_ID').AsInteger := curCopyId;
    dm.LogQuery.Open;
    appendMsg('Лог открыт...');
    result := true;
  except
    on e : exception do
    begin
      ShowMessage('Не удалось начать логгирование! ' + e.Message);
      result := false;
    end;
  end;
end;

function TLogger.stopLogging() : boolean;
begin
  appendMsg('Лог закрыт');
  dm.LogQuery.Close;
  result := false;
end;

function TLogger.appendMsg(msg : string) : boolean;
begin
  result := false;
  try
    if (dm.LogQuery.Active) then
    begin
      dm.AddProgrLog.StoredProcName := 'ADD_K2D_PROGRAM_LOG';
      dm.AddProgrLog.ExecProc;
      dm.LogQuery.Append;
      dm.LogQueryPROGRAM_LOG_ID.AsInteger := dm.AddProgrLog.Params.Items[0].AsInteger;
      dm.LogQueryCOPY_ID.AsInteger := curCopyId;
      dm.LogQueryTO_MACHINE.AsString := toMachine;
      dm.LogQuerySENDER.AsString := sender;
      dm.LogQuerySTRUK_ID.AsInteger := strukId;
      dm.LogQueryCUR_MONTH.AsInteger := month;
      dm.LogQueryCUR_YEAR.AsInteger := year;
      dm.LogQueryMESSAGE.AsString := msg;
      dm.LogQuerySTKOD.AsString := stkod;
      dm.LogQuery.Post;
      result := true;
    end;
  except
    on e : exception do
    begin
      ShowMessage('Не добавили запись в лог! ' + e.Message);
      if (dm.LogQuery.Active) then
        stopLogging();
      result := false;
    end;
  end;
end;

end.
