unit KartVDbfMain;

interface

uses Windows, Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ImgList, StdActns,
  ActnList, ToolWin, Mask, DBCtrlsEh, DBGridEh, DBLookupEh, Spin, RXCtrls,
  SysUtils, Variants, BDE, SplshWnd, DB, Logger, UtilR;

type
  TKartVDbfForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    buxNameCombo: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    curMonthCombo: TComboBox;
    SpinButton1: TSpinButton;
    curMonthEdit: TSpinEdit;
    curYearEdit: TSpinEdit;
    Button1: TButton;
    allCopyBtn: TRxSpeedButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    lastNeobrRashBtn: TButton;
    rashCopyBtn: TRxSpeedButton;
    prihCopyBtn: TRxSpeedButton;
    strkCombo: TComboBox;
    neobrRashBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure curMonthComboChange(Sender: TObject);
    procedure curMonthEditChange(Sender: TObject);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure allCopyBtnClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lastNeobrRashBtnClick(Sender: TObject);
    procedure rashCopyBtnClick(Sender: TObject);
    procedure prihCopyBtnClick(Sender: TObject);
    procedure strkComboChange(Sender: TObject);
    procedure neobrRashBtnClick(Sender: TObject);
    procedure buxNameComboChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    procedure copyKartVDbf(copyObjects : word; sender : string);   // 0 - all; 1 - prih; 2 - rash
    procedure fillStrkCombo;
    procedure freeSplash;
    procedure copyingSucceded;
    function copyDbfToLocalDir() : boolean;
    function copyDbfToNetDir() : boolean;
    function getCurrentDateTimeString() : string;
    procedure setPathStrings;
    procedure copyPrih(copyObjects : integer);
    procedure copyRash(copyObjects : integer);

    var
      newFilePath, oldFilePath, localDirPath : string;
      Splash: TForm;
      AniBmp1: TBitmap;
      log : TLogger;
      tF : TextFile;

  public
    function addKartRec2NomenDbf(kartType: string; numkcu, sklad, bals: string) : boolean;

    function setMaxRegnsf() : boolean;
    function addKartPrih2PrihAndNomenDbf() : boolean;
    procedure appendKartPrihRec2PrihDbfRec;
    function savePrihAndNomen(copyObjects : integer) : boolean;

    function addKartRashRecs2RashAndNomenDbf() : boolean;
    procedure appendKartRashRec2RashDbfRec;
    function saveOldFiles() : boolean;
    procedure fillMachineList(combo : TComboBox);

  end;

var
  KartVDbfForm: TKartVDbfForm;

  curMonth, curYear : integer;
  delDoubleRecs, deleting, rashRecAdded2Nomen : boolean;

implementation

uses DataM, PrihForm, PrihDbfForm, RasxDbfForm, RashForm, PrihDbfQForm, Nesootv,
      CopyFiles, ShellAPI;

{$R *.dfm}

procedure TKartVDbfForm.fillMachineList(combo : TComboBox);
begin
  combo.Items.Add('BM1');
  combo.Items.Add('BM2');
  combo.Items.Add('BM3');
  combo.Items.Add('BM4');
  combo.Items.Add('BM5');
  combo.Items.Add('BM6');
  combo.Items.Add('BM7');
  combo.Items.Add('BM8');
  combo.Items.Add('BMG');
  if (AnsiLowerCase(dm.userName) = 'bm1') or (AnsiLowerCase(dm.userName) = 'bm-1') then
    combo.ItemIndex := 0;
  if (AnsiLowerCase(dm.userName) = 'bm2') or (AnsiLowerCase(dm.userName) = 'bm-2') then
    combo.ItemIndex := 1;
  if (AnsiLowerCase(dm.userName) = 'bm3') or (AnsiLowerCase(dm.userName) = 'bm-3') then
    combo.ItemIndex := 2;
  if (AnsiLowerCase(dm.userName) = 'bm4') or (AnsiLowerCase(dm.userName) = 'bm-4') then
    combo.ItemIndex := 3;
  if (AnsiLowerCase(dm.userName) = 'bm5') or (AnsiLowerCase(dm.userName) = 'bm-5') then
    combo.ItemIndex := 4;
  if (AnsiLowerCase(dm.userName) = 'bm6') or (AnsiLowerCase(dm.userName) = 'bm-6') then
    combo.ItemIndex := 5;
  if (AnsiLowerCase(dm.userName) = 'bm7') or (AnsiLowerCase(dm.userName) = 'bm-7') then
    combo.ItemIndex := 6;
  if (AnsiLowerCase(dm.userName) = 'bm8') or (AnsiLowerCase(dm.userName) = 'bm-8') then
    combo.ItemIndex := 7;
  if (AnsiLowerCase(dm.userName) = 'bmg') or (AnsiLowerCase(dm.userName) = 'bmg-pc') then
    combo.ItemIndex := 8;
  if (AnsiLowerCase(dm.userName) = 'igor')  then
  begin
    combo.Items.Add('BM444');
    combo.ItemIndex := 9;
  end;
//  combo.ItemIndex := 8;
end;

function TKartVDbfForm.getCurrentDateTimeString() : string;
var
  hour, min, sec, msec : word;
  curDate : TDateTime;
begin
  curDate := Now;
  DecodeTime(curDate, hour, min, sec, msec);
  result := DateToStr(curDate) + '_' + IntToStr(hour) + '.' + IntToStr(min) + '.' + IntToStr(sec);
end;

procedure TKartVDbfForm.setPathStrings;
begin
  localDirPath := 'c:\work\' + buxNameCombo.Text + '_' + dm.ConfigUMCSTKOD.AsString
                  + '_' + curMonthEdit.Text + '_' + getCurrentDateTimeString() + '\';
  oldFilePath := dm.diskPath + buxNameCombo.Text + '\zerno1\';
  newFilePath := dm.diskPath + buxNameCombo.Text + '\zerno1\' + getCurrentDateTimeString() + '\';
end;

function TKartVDbfForm.copyDbfToLocalDir() : boolean;
begin
  log.appendMsg('Копируем файлы в локальную папку.');
  Splash := ShowSplashWindow(AniBmp1,
                             'Копирование файлов в локальную папку. Подождите, пожалуйста...', True, nil);
  result := false;
  try
    if (DirectoryExists('c:\work\')) then
    begin
      if (ForceDirectories(localDirPath)) then
      begin
        log.appendMsg('Создали локальную папку.');
        fileCopy(oldFilePath + 'nomen.dbf', localDirPath + 'nomen.dbf');
        fileCopy(oldFilePath + 'prixod.dbf', localDirPath + 'prixod.dbf');
        fileCopy(oldFilePath + 'rasxod.dbf', localDirPath + 'rasxod.dbf');
        if (FileExists(localDirPath + 'nomen.dbf'))
           and (FileExists(localDirPath + 'rasxod.dbf'))
           and (FileExists(localDirPath + 'prixod.dbf')) then
        begin
          log.appendMsg('Скопировали файлы в локальную папку.');
          dm.openNomenOldDbf(oldFilePath, true);
          dm.openPrihOldDbf(oldFilePath, true);
          dm.openRashOldDbf(oldFilePath, true);
          log.appendMsg('Открыли старые файлы на сетевом диске для их блокировки.');
          result := true;
        end;
      end
      else
        log.appendMsg('Не создали локальную папку.');
    end;
  except
    on e : exception do
    begin
      Splash.Free;
      log.appendMsg('Не удалось скопировать файлы в локальную папку. ' + e.Message);
      MessageDlg('Не удалось скопировать файлы в локальную папку. ' + e.Message, mtWarning, [mbOK], 0);
      SysUtils.Abort;
    end;
  end;
  Splash.Free;
end;

function TKartVDbfForm.copyDbfToNetDir() : boolean;
begin
  result := false;
  try
    log.appendMsg('Копирование NOMEN, PRIXOD, RASXOD.dbf в сетевую папку');
    dm.NomenOld.Close;
    fileCopy(localDirPath + 'nomen.dbf', oldFilePath + 'nomen.dbf');
    dm.PrihOld.Close;
    fileCopy(localDirPath + 'prixod.dbf', oldFilePath + 'prixod.dbf');
    dm.RashOld.Close;
    dm.BlockSession.Active := false;
    fileCopy(localDirPath + 'rasxod.dbf', oldFilePath + 'rasxod.dbf');
    log.appendMsg('Копирование NOMEN, PRIXOD, RASXOD.dbf в резервную папку: ' + newFilePath);
    fileCopy(localDirPath + 'nomen.dbf', newFilePath + 'nomen_new.dbf');
    fileCopy(localDirPath + 'prixod.dbf', newFilePath + 'prixod_new.dbf');
    fileCopy(localDirPath + 'rasxod.dbf', newFilePath + 'rasxod_new.dbf');
    dm.WorkSession.Close;
    if (FileExists(oldFilePath + 'nomen.dbf'))
       and (FileExists(oldFilePath + 'rasxod.dbf'))
       and (FileExists(oldFilePath + 'prixod.dbf')) then
    begin
      log.appendMsg('Удаление NOMEN, PRIXOD, RASXOD.dbf из локальной папки');
      DeleteFileA(PChar(localDirPath + 'nomen.dbf'));
      DeleteFileA(PChar(localDirPath + 'prixod.dbf'));
      DeleteFileA(PChar(localDirPath + 'rasxod.dbf'));
      log.appendMsg('Удаление локальной папки: ' + localDirPath);
      RemoveDir(localDirPath);
      log.appendMsg('Удалили');
      result := true;
    end;
  except
    on e : exception do
    begin
      log.appendMsg(e.message);
      MessageDlg('Не удалось скопировать обновленные файлы на сетевой диск. #10#13 '
                 + ' Обратитесь к программисту! ', mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure TKartVDbfForm.neobrRashBtnClick(Sender: TObject);
begin
  FNesootv.setCurVars(buxNameCombo.ItemIndex, curMonth, curYear, -1);
  FNesootv.Show;
end;

function TKartVDbfForm.saveOldFiles() : boolean;
begin
  Splash := ShowSplashWindow(AniBmp1,
                             'Создание резервной копии файлов. Подождите, пожалуйста...', True, nil);
  if (ForceDirectories(newFilePath)) then
  begin
    log.appendMsg('Создали папку для резервных файлов: ' + newFilePath);
    fileCopy(oldFilePath + 'nomen.dbf', newFilePath + 'nomen.dbf');
    fileCopy(oldFilePath + 'prixod.dbf', newFilePath + 'prixod.dbf');
    fileCopy(oldFilePath + 'rasxod.dbf', newFilePath + 'rasxod.dbf');
    assignFile(tF, newFilePath + 'Parameters.txt');
    rewrite(tF);
    writeln(tF, 'stkod: ' + dm.ConfigUMCSTKOD.AsString);
    writeln(tF, 'struk_id: ' + dm.ConfigUMCSTRUK_ID.AsString);
    writeln(tF, 'stname: ' + dm.ConfigUMCSTNAME.AsString);
    writeln(tF, 'mes: ' + curMonthEdit.Text);
    writeln(tF, 'god: ' + curYearEdit.Text);
    closeFile(tF);
    if (FileExists(newFilePath + 'nomen.dbf'))
        and (FileExists(newFilePath + 'rasxod.dbf'))
        and (FileExists(newFilePath + 'prixod.dbf')) then
    begin
      result := true;
      log.appendMsg('Создали резервную копию файлов...');
    end
    else
    begin
      log.appendMsg('Не создали резервную копию файлов. Не скопировали в резервную папку.');
      result := false;
    end;
  end
  else
  begin
    log.appendMsg('Не создали резервную копию файлов. Не создали резервную папку.');
    result := false;
  end;
  Splash.Free;
end;

function TKartVDbfForm.addKartRec2NomenDbf(kartType: string;
                                            numkcu, sklad, bals: string) : boolean;
begin
  result := false;
  if (dm.NomenMemLocate(numkcu, sklad, bals)) then
  begin
    if (kartType = 'PRIX') then
      result := dm.editNomenRec(kartType, IntToStr(curMonth), IntToStr(curYear), buxNameCombo.Text,
                                dm.KartPrihQueryKOL.AsFloat,
                                dm.KartPrihQuerySUMMA.AsFloat,
                                dm.KartPrihQuerySUMMA_S_NDS.AsFloat);
    if (kartType = 'RASX') then
      result := dm.editNomenRec(kartType, IntToStr(curMonth), IntToStr(curYear), buxNameCombo.Text,
                                dm.KartRashQueryKOL.AsFloat,
                                dm.KartRashQuerySUMMA.AsFloat,
                                dm.KartRashQuerySUM_NDS.AsFloat);
  end
  else
  begin
    if (kartType = 'PRIX') then
      if (dm.appendNomen(dm.KartPrihQueryACCOUNT.AsString, dm.KartPrihQueryNUMKSU.AsString,
                         dm.KartPrihQueryNAMEPR.AsString, dm.KartPrihQueryNAMEPRS.AsString,
                         dm.KartPrihQueryXARKT.AsString, dm.KartPrihQueryGOST.AsString,
                         dm.KartPrihQueryEIZ.AsString, dm.KartPrihQuerySKLAD.AsString,
                         dm.KartPrihQueryMEI.AsString, dm.KartPrihQueryDATETR.AsDateTime)) then
        addKartRec2NomenDbf := addKartRec2NomenDbf(kartType, numkcu, sklad, bals);
    if (kartType = 'RASX') then
      if (dm.appendNomen(dm.KartRashQueryACCOUNT.AsString, dm.KartRashQueryNUMKSU.AsString,
                         dm.KartRashQueryNAMEPR.AsString, dm.KartRashQueryNAMEPRS.AsString,
                         dm.KartRashQueryXARKT.AsString, dm.KartRashQueryGOST.AsString,
                         dm.KartRashQueryMEI.AsString, dm.KartRashQuerySKLAD.AsString,
                         dm.KartRashQueryEIZ.AsString, dm.KartRashQueryDATETR.AsDateTime)) then
        addKartRec2NomenDbf := addKartRec2NomenDbf(kartType, numkcu, sklad, bals);
  end;
end;

function TKartVDbfForm.setMaxRegnsf() : boolean;
var
  curRegnsf : integer;
begin
  result := false;
  if (dm.Prih.Active) and (dm.Prih.RecordCount > 0) then
  begin
    log.appendMsg('Изменение порядковых номеров в PRIXOD.dbf');
    dm.openMaxRegnsfPrih(localDirPath, dm.ConfigUMCSTKOD.AsString);
    curRegnsf := dm.maxPrihRegnsfMAXREGNSF.AsInteger;
    dm.Prih.First;
    while (not dm.Prih.Eof) do
    begin
      dm.Prih.Edit;
      dm.PrihREGNSF.AsString := IntToStr(curRegnsf);
      dm.Prih.Post;
      dm.Prih.Next;
      curRegnsf := curRegnsf + 1;
    end;
    dm.maxPrihRegnsf.Close;
    log.appendMsg('Изменение завершено.');
    result := true;
  end;
end;

procedure TKartVDbfForm.prihCopyBtnClick(Sender: TObject);
begin
  if (dm.checkBuxStruks(dm.ConfigUMCSTRUK_ID.AsInteger, AnsiLowerCase(buxNameCombo.Text))) then
    copyKartVDbf(1, 'prihCopyBtn')
  else
  begin
    if (MessageDlg('Выбранный бухгалтер не ведет данное подразделение. Все равно продолжить?',
        mtWarning, [mbYes, mbNo], 0) = mrYes) then
      copyKartVDbf(1, 'prihCopyBtn');
  end;
end;

procedure TKartVDbfForm.rashCopyBtnClick(Sender: TObject);
begin
  if (dm.checkBuxStruks(dm.ConfigUMCSTRUK_ID.AsInteger, AnsiLowerCase(buxNameCombo.Text))) then
    copyKartVDbf(2, 'rashCopyBtn')
  else
  begin
    if (MessageDlg('Выбранный бухгалтер не ведет данное подразделение. Все равно продолжить?',
        mtWarning, [mbYes, mbNo], 0) = mrYes) then
      copyKartVDbf(2, 'rashCopyBtn');
  end;
end;

function TKartVDbfForm.addKartPrih2PrihAndNomenDbf() : boolean;
begin
  result := false;
  if (dm.KartPrihQuery.Active) and (dm.KartPrihQuery.RecordCount > 0) then
  begin
    log.appendMsg('Начинаем добавление приходов.');
    dm.KartPrihQuery.First;
    while (not dm.KartPrihQuery.Eof) do
    begin
      if (addKartRec2NomenDbf('PRIX',
                              dm.KartPrihQueryNUMKSU.AsString,
                              dm.KartPrihQuerySKLAD.AsString,
                              dm.KartPrihQueryACCOUNT.AsString)) then
      begin
        appendKartPrihRec2PrihDbfRec;
        result := true;
      end;
      dm.KartPrihQuery.Next;
    end;
    log.appendMsg('Добавление завершено');
  end
  else
  begin
    freeSplash;
    ShowMessage('Нет данных по приходам для добавления.');
  end;
end;

function TKartVDbfForm.savePrihAndNomen(copyObjects : integer) : boolean;
begin
  result := false;
  log.appendMsg('Сохранение NOMEN.dbf');
  if (dm.saveNomenMemToNomen()) then
  begin
    dm.Nomen.ApplyUpdates;
    dm.Nomen.CommitUpdates;
    DbiPackTable(dm.Nomen.dbhandle, dm.Nomen.Handle, nil, nil, false);
    dm.Nomen.Close
  end;
  log.appendMsg('Сохранение PRIXOD.dbf');
  dm.Prih.ApplyUpdates;
  dm.Prih.CommitUpdates;
  dm.Prih.Close;
  dm.WorkSession.Active := false;
  dm.WorkSession.Active := true;
  dm.activatePrihDbf(localDirPath, dm.ConfigUMCSTKOD.AsString, true);
  DbiPackTable(dm.PrihDbf.dbhandle, dm.PrihDbf.Handle, nil, nil, false);
  dm.PrihDbf.Close;
  log.appendMsg('Сохранено.');
  if (copyObjects = 1) then
    if (copyDbfToNetDir()) then
      result := true;
end;

function TKartVDbfForm.addKartRashRecs2RashAndNomenDbf() : boolean;
var
  somethingAdded : boolean;
begin
  result := false;
  somethingAdded := false;
  if (dm.KartRashQuery.Active) and (dm.KartRashQuery.RecordCount > 0) then
  begin
    log.appendMsg('Начинаем добавление расходов.');
    dm.KartRashQuery.First;
    while (not dm.KartRashQuery.Eof) do
    begin
      if (addKartRec2NomenDbf('RASX',
                              dm.KartRashQueryNUMKSU.AsString,
                              dm.KartRashQuerySKLAD.AsString,
                              dm.KartRashQueryACCOUNT.AsString)) then
      begin
        appendKartRashRec2RashDbfRec;
        somethingAdded := true;
      end;
      dm.KartRashQuery.Next;
    end;
    log.appendMsg('Добавление завершено');
    if (somethingAdded) then
    begin
      log.appendMsg('Сохранение NOMEN.dbf');
      if (dm.saveNomenMemToNomen()) then
      begin
        dm.Nomen.ApplyUpdates;
        dm.Nomen.CommitUpdates;
        DbiPackTable(dm.Nomen.dbhandle, dm.Nomen.Handle, nil, nil, false);
        dm.Nomen.Close
      end;
      log.appendMsg('Сохранение RASXOD.dbf');
      dm.Rash.ApplyUpdates;
      dm.Rash.CommitUpdates;
      dm.Rash.Close;
      dm.WorkSession.Active := false;
      dm.WorkSession.Active := true;
      dm.activateRashDbf(localDirPath, dm.ConfigUMCSTKODRELA.AsString, true);
      DbiPackTable(dm.RashDbf.dbhandle, dm.RashDbf.Handle, nil, nil, false);
      dm.RashDbf.Close;
      log.appendMsg('Сохранено.');
      if (copyDbfToNetDir()) then
        result := true;
    end
    else
    begin
      freeSplash;
      if (dm.NesootvTbl.RecordCount > 0) then
      begin
        log.appendMsg('Недобавленные расходы: ' + IntToStr(dm.NesootvTbl.RecordCount));
        dm.saveNesootvTbl;
      end;
      ShowMessage('Ни один расход не добавлен, т.к. не хватает количества на карточках.');
    end;
  end
  else
  begin
    freeSplash;
    ShowMessage('Нет данных по расходам для добавления.');
  end;
end;

procedure TKartVDbfForm.appendKartPrihRec2PrihDbfRec;
begin
  dm.Prih.Append;
  dm.PrihBALS.AsString := dm.KartPrihQueryACCOUNT.AsString;
  dm.PrihNUMKCU.AsString := dm.KartPrihQueryNUMKSU.AsString;
  dm.PrihNAMEPR.AsString := dm.KartPrihQueryNAMEPR.AsString;
  dm.PrihMEI.AsString := dm.KartPrihQueryMEI.AsString;
  dm.PrihOPER.AsString := dm.KartPrihQueryOPER.AsString;
  dm.PrihDATETR.AsString := dm.KartPrihQueryDATETR.AsString;
  dm.PrihEIZ.AsString := dm.KartPrihQueryEIZ.AsString;
  dm.PrihNUMDOK.AsString := dm.KartPrihQueryNUMNDOK.AsString;
  dm.PrihSKLAD.AsString := dm.KartPrihQuerySKLAD.AsString;
  dm.PrihNSD.AsString := dm.KartPrihQueryNSD.AsString;
  dm.PrihDATSD.AsString := dm.KartPrihQueryDATSD.AsString;
  dm.PrihKP.AsString := dm.KartPrihQueryKP.AsString;
  dm.PrihKOL.AsString := dm.KartPrihQueryKOL.AsString;
  dm.PrihKOLOTG.AsString := dm.KartPrihQueryKOLOTG.AsString;
  dm.PrihPOST.AsString := dm.KartPrihQueryPOST.AsString;
  dm.PrihNP.AsString := dm.KartPrihQueryNP.AsString;
  dm.PrihMONEY.AsString := dm.KartPrihQueryMONEY.AsString;
//  dm.PrihSUMNDS.AsString := dm.KartPrihQuerySUM_NDS.AsString;
  dm.PrihSUM.AsString := dm.KartPrihQuerySUMMA.AsString;
  dm.PrihKPZ.AsString := '';
  dm.PrihREGNSF.AsString := '1';
  dm.PrihPRIZN.AsString := 'n';
  dm.PrihSUMD.AsString := dm.KartPrihQuerySUMMA_S_NDS.AsString;
  dm.PrihDOC_ID.AsString := dm.KartPrihQueryDOC_ID.AsString;
  dm.Prih.Post;
end;

procedure TKartVDbfForm.appendKartRashRec2RashDbfRec;
begin
  dm.Rash.Append;
  dm.RashBALS.AsString := dm.KartRashQueryACCOUNT.AsString;
  dm.RashDEBET.AsString := dm.KartRashQueryDEBET.AsString;
  dm.RashNUMKCU.AsString := dm.KartRashQueryNUMKSU.AsString;
  dm.RashNAMEPR.AsString := dm.KartRashQueryNAMEPR.AsString;
  dm.RashKEI.AsString := dm.KartRashQueryEIZ.AsString;
  dm.RashOPER.AsString := dm.KartRashQueryOPER.AsString;
  dm.RashDATETR.AsString := dm.KartRashQueryDATETR.AsString;
  dm.RashEIZ.AsString := dm.KartRashQueryMEI.AsString;
  dm.RashNUMDOK.AsString := dm.KartRashQueryNUMNDOK.AsString;
  dm.RashSKLAD.AsString := dm.KartRashQuerySKLAD.AsString;
  dm.RashKOL.AsString := dm.KartRashQueryKOL.AsString;
  dm.RashPOST.AsString := dm.KartRashQueryPOST.AsString;
  dm.RashNP.AsString := dm.KartRashQueryNP.AsString;
  dm.RashMONEY.AsString := dm.KartRashQueryMONEY.AsString;
  dm.RashSUMD.AsString := dm.KartRashQuerySUM_NDS.AsString;
  dm.RashSUM.AsString := dm.KartRashQuerySUMMA.AsString;
  dm.RashCEX.AsString := dm.KartRashQueryCEX.AsString;
  dm.RashDOC_ID.AsString := dm.KartRashQueryDOC_ID.AsString;
  if (dm.ConfigUMCSTKODRELA.AsString = '1600') then  
	  dm.RashSTRUK_ID.AsString := dm.KartRashQuerySTRUK_ID.AsString;
  dm.Rash.Post;
end;

procedure TKartVDbfForm.allCopyBtnClick(Sender: TObject);
begin
  copyKartVDbf(0, 'allCopyBtnClick');
end;

procedure TKartVDbfForm.copyKartVDbf(copyObjects : word; sender : string);   // 0 - all; 1 - prih; 2 - rash
begin
  dm.setLogger(log);
  log.startLogging(buxNameCombo.Text, sender, dm.ConfigUMCSTKOD.AsString,
                   dm.ConfigUMCSTRUK_ID.AsInteger, curMonthEdit.Value, curYearEdit.Value);
  if (strkCombo.Text = '') then
  begin
    log.appendMsg('не выбрано подразделение');
    ShowMessage('Выберите дозаписываемое подразделение!');
    SysUtils.Abort;
  end;
  delDoubleRecs := false;
  deleting := false;
  AniBmp1 := TBitmap.Create;
//  AniBmp1.LoadFromResourceName(HInstance, 'booka');
  try
    setPathStrings;
    if (saveOldFiles()) and (copyDbfToLocalDir()) then
    begin
      Splash := ShowSplashWindow(AniBmp1,
                                 'Сохранение данных. Подождите, пожалуйста...', True, nil);
      dm.openNesootvTbl(buxNameCombo.Text, curMonth, curYear, dm.ConfigUMCSTRUK_ID.AsInteger);
      dm.clearNesootvTbl;
      dm.saveNesootvTbl;
      if (copyObjects = 0) or (copyObjects = 1) then
        copyPrih(copyObjects);

      if (copyObjects = 0) or (copyObjects = 2) then
        copyRash(copyObjects);
    end;
  except
    on e : exception do
    begin
      freeSplash;
      if (copyObjects = 0) or (copyObjects = 1) then
      begin
        dm.Prih.CancelUpdates;
        dm.KartPrihQuery.Close;
        dm.Prih.Close;
      end;
      if (copyObjects = 0) or (copyObjects = 2) then
      begin
        dm.Rash.CancelUpdates;
        dm.KartRashQuery.Close;
        dm.Rash.Close;
      end;
      dm.Nomen.CancelUpdates;
      dm.Nomen.Close;
      dm.NomenOld.Close;
      dm.RashOld.Close;
      dm.PrihOld.Close;
      log.appendMsg('Ошибка при дозаписи: ' + e.Message);
      MessageDlg('Произошла ошибка при дозаписи данных! ' + e.Message, mtWarning, [mbOK], 0);
    end;
  end;
  log.stopLogging();
end;

procedure TKartVDbfForm.copyPrih(copyObjects : integer);
begin
  log.appendMsg('Начинаем копирование приходов.');
  dm.openPrihDbfQuery(localDirPath, dm.ConfigUMCSTKODRELA.AsString);
  dm.activateNomenDbf(localDirPath, dm.ConfigUMCSTKODRELA.AsString, true);
  dm.restoreNomenForPrih(curMonth, curYear, buxNameCombo.Text);
  dm.clearPrih;
  dm.activateKartPrihQuery(curMonthEdit.Value, curYearEdit.Value);
  if (addKartPrih2PrihAndNomenDbf()) then
  begin
    if (setMaxRegnsf()) then
      if (savePrihAndNomen(copyObjects)) and (copyObjects = 1) then
        copyingSucceded;
  end
  else
  begin
    freeSplash;
    log.appendMsg('Данные по приходам были уже ранее добавлены.');
    ShowMessage('Данные по приходам были уже ранее добавлены.');
  end;
  log.appendMsg('Копирование приходов закончено.');
  dm.Prih.Close;
end;

procedure TKartVDbfForm.copyRash(copyObjects : integer);
begin
  log.appendMsg('Начинаем копирование расходов.');
  dm.openRashDbfQuery(localDirPath, dm.ConfigUMCSTKODRELA.AsString, dm.ConfigUMCSTRUK_ID.AsString);
  dm.activateNomenDbf(localDirPath, dm.ConfigUMCSTKODRELA.AsString, true);
  dm.restoreNomenForRash(curMonth, curYear, buxNameCombo.Text);
  dm.clearRash;
  dm.activateKartRashQuery(curMonthEdit.Value, curYearEdit.Value);
  if (addKartRashRecs2RashAndNomenDbf()) then
    copyingSucceded;
  dm.Rash.Close;
end;

procedure TKartVDbfForm.freeSplash;
begin
  if (Splash.Active) then
    Splash.Free;
end;

procedure TKartVDbfForm.copyingSucceded;
begin
  log.appendMsg('Копирование завершено успешно.');
  dm.Nomen.Close;
  dm.Rash.Close;
  dm.Prih.Close;
  dm.NomenOld.Close;
  dm.RashOld.Close;
  dm.PrihOld.Close;
  log.appendMsg('Добавляем дату окончания в имени резервной папки: ' + newFilePath);
  RenameFile(newFilePath, Copy(newFilePath, 0, length(newFilePath) - 1)
             + '__' + getCurrentDateTimeString() + '\');
  freeSplash;
  ShowMessage('Дозаписали!');
  if (dm.NesootvTbl.RecordCount > 0) then
  begin
    log.appendMsg('Недобавленные расходы: ' + IntToStr(dm.NesootvTbl.RecordCount));
    dm.saveNesootvTbl;
    ShowMessage('Не все расходы были обработаны, т.к. не хватает количества '
                + 'на карточке!');
  end;
end;

procedure TKartVDbfForm.Button2Click(Sender: TObject);
begin
  dm.activateKartPrihQuery(curMonthEdit.Value, curYearEdit.Value);
  FPrihForm.Show;
  dm.WorkSession.Active := false;
end;

procedure TKartVDbfForm.Button3Click(Sender: TObject);
begin
  dm.activatePrihDbf(buxNameCombo.Text, buxNameCombo.Text, false);
  FPrihDbfForm.Show;
end;

procedure TKartVDbfForm.Button4Click(Sender: TObject);
begin
  dm.activateRashDbf(oldFilePath, dm.ConfigUMCSTKODRELA.AsString, false);
  FRasxDbfForm.Show;
end;

procedure TKartVDbfForm.Button5Click(Sender: TObject);
begin
  dm.activateKartRashQuery(curMonthEdit.Value, curYearEdit.Value);
  FRashForm.Show;
  dm.WorkSession.Active := false;
end;

procedure TKartVDbfForm.buxNameComboChange(Sender: TObject);
begin
  setPathStrings;
end;

procedure TKartVDbfForm.lastNeobrRashBtnClick(Sender: TObject);
begin
  FNesootv.setCurVars(buxNameCombo.ItemIndex, curMonth, curYear, strkCombo.ItemIndex);
  FNesootv.Show;
end;

procedure TKartVDbfForm.curMonthComboChange(Sender: TObject);
begin
  curMonthEdit.OnChange := nil;
  curMonthEdit.Value := curMonthCombo.ItemIndex + 1;
  curMonth := curMonthEdit.Value;
  curMonthEdit.OnChange := curMonthEditChange;
end;

procedure TKartVDbfForm.curMonthEditChange(Sender: TObject);
begin
  if (curMonthEdit.Text = '1') or (curMonthEdit.Text = '2') or
     (curMonthEdit.Text = '3') or (curMonthEdit.Text = '4') or
     (curMonthEdit.Text = '5') or (curMonthEdit.Text = '6') or
     (curMonthEdit.Text = '7') or (curMonthEdit.Text = '7') or
     (curMonthEdit.Text = '9') or (curMonthEdit.Text = '8') or
     (curMonthEdit.Text = '11') or (curMonthEdit.Text = '12') then
    curMonthCombo.ItemIndex := curMonthEdit.Value - 1;
end;

procedure TKartVDbfForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dm.Prih.Close;
  dm.Rash.Close;
  dm.Nomen.Close;
  dm.KartPrihQuery.Close;
  dm.KartRashQuery.Close;
  dm.NesootvTbl.Close;
  FreeAndNil(log);
end;

procedure TKartVDbfForm.FormCreate(Sender: TObject);
begin
  fillMachineList(buxNameCombo);
  log := TLogger.Create;
end;

procedure TKartVDbfForm.FormShow(Sender: TObject);
var
  year, month, day : word;
begin
  prihCopyBtn.Visible := DM.showPrih;  
  DecodeDate(Now, year, month, day);
  if (month = 1) then
  begin
    month := 13;
    year := year - 1;
  end;
  curMonthEdit.Value := month - 1;
  curMonth := month - 1;
  curMonthCombo.ItemIndex := month - 2;
  curYearEdit.Value := year;
  curYear := year;
  dm.ConfigUMC.Open;
  dm.ConfigUMC.FetchAll;
//  dm.ConfigUMC.Locate('struk_id', '500', []);
//  strkCombo.KeyValue := dm.ConfigUMCSTRUK_ID.AsInteger;
  fillStrkCombo;
//  dm.diskPath := 'd';
  dm.diskPath := 'f';
  setPathStrings;
end;

procedure TKartVDbfForm.fillStrkCombo;
begin
  if (dm.ConfigUMC.Active) then
  begin
    dm.ConfigUMC.First;
    strkCombo.Items.Clear;
    while (not dm.ConfigUMC.Eof) do
    begin
      strkCombo.Items.Add(dm.ConfigUMCSTNAME.AsString);
      dm.ConfigUMC.Next;
    end;
    strkCombo.ItemIndex := 0;
  end;
end;

procedure TKartVDbfForm.SpinButton1DownClick(Sender: TObject);
begin
  if (curMonthCombo.ItemIndex > 0) then
  begin
    curMonthCombo.ItemIndex := curMonthCombo.ItemIndex - 1;
    curMonthComboChange(sender);
  end;
end;

procedure TKartVDbfForm.SpinButton1UpClick(Sender: TObject);
begin
  if (curMonthCombo.ItemIndex < 11) then
  begin
    curMonthCombo.ItemIndex := curMonthCombo.ItemIndex + 1;
    curMonthComboChange(sender);
  end;
end;

procedure TKartVDbfForm.strkComboChange(Sender: TObject);
begin
  dm.ConfigUMC.First;
  dm.ConfigUMC.Locate('stname', VarArrayOf([strkCombo.Text]), []);
end;

end.
