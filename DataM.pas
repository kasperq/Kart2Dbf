unit DataM;

interface

uses
  SysUtils, Classes, IBDatabase, DB, IBCustomDataSet, IBQuery, RxIBQuery,
  DBTables, RxQuery, ERxQuery, RxMemDS, frxDCtrl, frxClass, frxDBSet, FR_Class,
  frOLEExl, frxExportPDF, frxExportXML, frxExportXLS, IBUpdateSQL, Dialogs,
  ADODB, Variants, DBFilter, IBUpdSQLW, IBStoredProc, UtilR,
  Logger;

type
  TDM = class(TDataModule)
    Belmed: TIBDatabase;
    RTrans: TIBTransaction;
    KartPrihQuery: TRxIBQuery;
    DSKartIncomes: TDataSource;
    KartPrihQueryNUMKSU: TIBStringField;
    KartPrihQueryNAMEPR: TIBStringField;
    KartPrihQueryOPER: TIBStringField;
    KartPrihQueryDATETR: TDateField;
    KartPrihQueryNUMNDOK: TIBStringField;
    KartPrihQueryNSD: TIBStringField;
    KartPrihQueryKP: TIBStringField;
    KartPrihQueryKOL: TFMTBCDField;
    KartPrihQueryKOLOTG: TFMTBCDField;
    KartPrihQueryPOST: TIBStringField;
    KartPrihQueryMONEY: TIBBCDField;
    KartPrihQuerySUM_NDS: TIBBCDField;
    KartPrihQueryNDS: TIBBCDField;
    KartPrihQueryACCOUNT: TIBStringField;
    ConfigUMC: TRxIBQuery;
    DSConfigUMC: TDataSource;
    DSPrixDbf: TDataSource;
    KartPrihQueryMEI: TIBStringField;
    KartPrihQueryEIZ: TIBStringField;
    PrihDbf: TTable;
    RashDbf: TTable;
    DSRashDbf: TDataSource;
    KartRashQuery: TRxIBQuery;
    DSKartOutlay: TDataSource;
    KartPrihQueryNAM_OP: TIBStringField;
    KartPrihQueryDATSD: TDateField;
    KartPrihQuerySUMMA_S_NDS: TIBBCDField;
    ConfigUMCSTRUK_ID: TSmallintField;
    ConfigUMCSTKOD: TIBStringField;
    ConfigUMCOBOROT_BUX: TSmallintField;
    Nomen: TTable;
    ConfigUMCSTNAME: TIBStringField;
    DSNesootvTbl: TDataSource;
    KartPrihQueryNAMEPRS: TIBStringField;
    KartPrihQueryXARKT: TIBStringField;
    KartPrihQueryGOST: TIBStringField;
    KartPrihQuerySKLAD: TIBStringField;
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    frxDialogControls1: TfrxDialogControls;
    frxXLSExport1: TfrxXLSExport;
    frxXMLExport1: TfrxXMLExport;
    frxPDFExport1: TfrxPDFExport;
    NomenMem: TRxMemoryData;
    NomenMemBALS: TStringField;
    NomenMemNUMKCU: TStringField;
    NomenMemNAMEPR: TStringField;
    NomenMemNAMEPRS: TStringField;
    NomenMemXARKT: TStringField;
    NomenMemGOST: TStringField;
    NomenMemMONEY: TFloatField;
    NomenMemKEI: TStringField;
    NomenMemEIP: TStringField;
    NomenMemDATEIN: TDateField;
    NomenMemNZ: TFloatField;
    NomenMemTPR: TStringField;
    NomenMemKOL: TFloatField;
    NomenMemSUM: TFloatField;
    NomenMemPRIXODM: TFloatField;
    NomenMemRASXODM: TFloatField;
    NomenMemSRASXM: TFloatField;
    NomenMemSPRIXM: TFloatField;
    NomenMemDATETR: TDateField;
    NomenMemSKLAD: TStringField;
    NomenMemEDNOR: TSmallintField;
    NomenMemSSUM: TFloatField;
    NomenMemNSUM: TFloatField;
    NomenMemSKOL: TFloatField;
    NomenMemCENAD: TFloatField;
    NomenMemSUMD: TFloatField;
    NomenMemSSUMD: TFloatField;
    NomenMemSPRIXMD: TFloatField;
    NomenMemSRASXMD: TFloatField;
    NomenMemSUMNDS: TFloatField;
    NomenOld: TTable;
    PrihOld: TTable;
    RashOld: TTable;
    NesootvTbl: TRxIBQuery;
    NesootvTblUpd: TIBUpdateSQLW;
    WTrans: TIBTransaction;
    NesootvTblNEDOBAVRASH_ID: TIntegerField;
    NesootvTblSKLAD: TIBStringField;
    NesootvTblACCOUNT: TIBStringField;
    NesootvTblDEBET: TIBStringField;
    NesootvTblMES: TSmallintField;
    NesootvTblGOD: TIntegerField;
    NesootvTblSTRUK_ID: TIntegerField;
    NesootvTblNUMKSU: TIBStringField;
    NesootvTblNAMEPR: TIBStringField;
    NesootvTblOPER: TIBStringField;
    NesootvTblDATETR: TDateField;
    NesootvTblNUMNDOK: TIBStringField;
    NesootvTblKOL: TFMTBCDField;
    NesootvTblMEI: TIBStringField;
    NesootvTblCEX: TIBStringField;
    NesootvTblPOST: TIBStringField;
    NesootvTblNP: TIntegerField;
    NesootvTblMONEY: TFMTBCDField;
    NesootvTblMACHINE: TIBStringField;
    BlockSession: TSession;
    Rash: TERxQuery;
    UpdRash: TUpdateSQL;
    RashDEBET: TStringField;
    RashBALS: TStringField;
    RashNUMKCU: TStringField;
    RashNAMEPR: TStringField;
    RashKEI: TStringField;
    RashEIZ: TStringField;
    RashOPER: TStringField;
    RashDATETR: TDateField;
    RashNUMDOK: TStringField;
    RashCEX: TStringField;
    RashPOST: TStringField;
    RashMOL: TStringField;
    RashKOL: TFloatField;
    RashMONEY: TFloatField;
    RashSUM: TFloatField;
    RashKPZ: TStringField;
    RashSKLAD: TStringField;
    RashNACEN: TFloatField;
    RashDT1: TStringField;
    RashKT1: TStringField;
    RashSUM1: TFloatField;
    RashDT2: TStringField;
    RashKT2: TStringField;
    RashPRIZN: TStringField;
    RashPRIZNVX: TStringField;
    RashOTK: TFloatField;
    RashKT: TStringField;
    RashNMASH: TStringField;
    RashNP: TFloatField;
    RashKORR: TStringField;
    RashSUMD: TFloatField;
    RashDOC_ID: TFloatField;
    addNedobavProc: TIBStoredProc;
    KartPrihQueryDOC_ID: TIntegerField;
    KartPrihQuerySHORT_NAME: TIBStringField;
    KartPrihQueryTIP_OP_ID: TSmallintField;
    KartPrihQueryTIP_DOK_ID: TSmallintField;
    Prih: TERxQuery;
    UpdPrih: TUpdateSQL;
    PrihBALS: TStringField;
    PrihNUMKCU: TStringField;
    PrihNAMEPR: TStringField;
    PrihMEI: TStringField;
    PrihEIZ: TStringField;
    PrihOPER: TStringField;
    PrihDATETR: TDateField;
    PrihNUMDOK: TStringField;
    PrihNSD: TStringField;
    PrihDATSD: TDateField;
    PrihKP: TStringField;
    PrihPOST: TStringField;
    PrihKOL: TFloatField;
    PrihKOLOTG: TFloatField;
    PrihMONEY: TFloatField;
    PrihSUM: TFloatField;
    PrihKPZ: TStringField;
    PrihREGNSF: TFloatField;
    PrihKOLNEDN: TFloatField;
    PrihKOLNEDS: TFloatField;
    PrihKOLMATPUT: TFloatField;
    PrihSUMNEDN: TFloatField;
    PrihSUMNEDS: TFloatField;
    PrihSUMMATP: TFloatField;
    PrihSKLAD: TStringField;
    PrihDEBDOP: TStringField;
    PrihKRDOP: TStringField;
    PrihPRIZVX: TStringField;
    PrihPRIZN: TStringField;
    PrihKREG: TSmallintField;
    PrihNP: TFloatField;
    PrihKORR: TStringField;
    PrihWW1: TStringField;
    PrihSUMD: TFloatField;
    PrihDOC_ID: TFloatField;
    WorkSession: TSession;
    LogQuery: TRxIBQuery;
    UpdLogQuery: TIBUpdateSQLW;
    DSLogQuery: TDataSource;
    AddProgrLog: TIBStoredProc;
    AddCopyId: TIBStoredProc;
    maxPrihRegnsf: TERxQuery;
    maxPrihRegnsfMAXREGNSF: TFloatField;
    KartPrihQueryNP: TIBStringField;
    LogQueryPROGRAM_LOG_ID: TIntegerField;
    LogQueryCOPY_ID: TIntegerField;
    LogQueryUSER_NAME: TIBStringField;
    LogQueryTO_MACHINE: TIBStringField;
    LogQuerySTRUK_ID: TIntegerField;
    LogQueryCUR_MONTH: TSmallintField;
    LogQueryCUR_YEAR: TIntegerField;
    LogQueryMESSAGE: TIBStringField;
    LogQuerySENDER: TIBStringField;
    KartRashQuerySKLAD: TIBStringField;
    KartRashQueryNUMKSU: TIBStringField;
    KartRashQueryNAMEPR: TIBStringField;
    KartRashQueryNAMEPRS: TIBStringField;
    KartRashQueryXARKT: TIBStringField;
    KartRashQueryGOST: TIBStringField;
    KartRashQueryOPER: TIBStringField;
    KartRashQueryDATETR: TDateField;
    KartRashQueryNUMNDOK: TIBStringField;
    KartRashQueryKP: TIBStringField;
    KartRashQueryKOL: TFMTBCDField;
    KartRashQueryKOLOTG: TFMTBCDField;
    KartRashQueryEIZ: TIBStringField;
    KartRashQueryMEI: TIBStringField;
    KartRashQueryCEX: TIBStringField;
    KartRashQueryPOST: TIBStringField;
    KartRashQueryMONEY: TIBBCDField;
    KartRashQuerySUM_NDS: TIBBCDField;
    KartRashQuerySUMMA: TIBBCDField;
    KartRashQueryNDS: TIBBCDField;
    KartRashQueryACCOUNT: TIBStringField;
    KartRashQueryDEBET: TIBStringField;
    KartRashQueryNP: TIBStringField;
    KartRashQueryNAM_OP: TIBStringField;
    KartRashQueryTIP_OP_ID: TSmallintField;
    KartRashQueryPRIZ_ID: TSmallintField;
    KartRashQueryDOC_ID: TIntegerField;
    LogQuerySTKOD: TIBStringField;
    Bmomts: TERxQuery;
    BmomtsBMG: TStringField;
    BmomtsSTRUK_ID: TFloatField;
    BMOMTSSess: TSession;
    ConfigUMCSTKODRELA: TIBStringField;
    RashSTRUK_ID: TSmallintField;
    KartRashQuerySTRUK_ID: TSmallintField;
    KartRashQueryKLIENT_ID: TIntegerField;
    KartPrihQuerySUMMA: TFMTBCDField;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);

  private
    procedure fillNomenMem();
    procedure appendNomenMemRecToNomenRec;
    procedure NomenMemEditNewRecord;

    procedure openBlockSession(path : string);
    procedure openWorkSession;

    var
      m_diskPath : string;
      log : ^TLogger;

  public
    procedure openNesootvTbl(buxName : string; month, year, strukId : integer);
    procedure saveNesootvTbl;
    procedure clearNesootvTbl;
    procedure addValues2NesootvTbl(sklad, numkcu, namepr, oper, datetr, numndok,
                                   kol, mei, cex, post, bals, debet, mes, god, money,
                                   np, strukId, buxName : string);

    function editNomenRec(kartType, mes, god, buxName: string; kol, summa, sumSNds : double) : boolean;
    function appendNomen(bals, numkcu, namepr, nameprs, xarkt, gost, eip,
                         sklad, kei : string; dateTr : TDateTime) : boolean;
    procedure activateNomenDbf(localPath, stkod : string; exclusive : boolean);
    procedure openNomenOldDbf(localPath : string; exclusive : boolean);

    procedure activatePrihDbf(localPath, stkod : string; exclusive : boolean);
    procedure openPrihOldDbf(localPath : string; exclusive : boolean);
    procedure openPrihDbfQuery(localPath, stkod : string);
    procedure activateKartPrihQuery(curMonth : integer; curYear : integer);
    procedure restoreNomenForPrih(curMonth, curYear : integer; buxName : string);
    procedure clearPrih;
    procedure openMaxRegnsfPrih(localPath, stkod : string);

    procedure openRashOldDbf(localPath : string; exclusive : boolean);
    procedure openRashDbfQuery(localPath, stkod, strukId : string);
    procedure activateRashDbf(localPath, stkod : string; exclusive : boolean);
    procedure activateKartRashQuery(curMonth : integer; curYear : integer);
    procedure clearRash;
    procedure restoreNomenForRash(curMonth, curYear : integer; buxName : string);

    procedure setDiskLetter(driveLetter : string);
    function getDiskPath() : string;
    function saveNomenMemToNomen() : boolean;
    function NomenMemLocate(numkcu, sklad, bals: string) : boolean;
    procedure setLogger(var log : TLogger);
    function checkBuxStruks(strukId : integer; buxName : string) : boolean;
    procedure setVxodControlRashQuery(setVxContr : boolean);

    property diskPath : string read getDiskPath write setDiskLetter;

    var
      filterMonth, filterGod, filterStrukId : integer;
      userName : string;
      showPrih : boolean;

  end;

var
  DM: TDM;

  newBals, newNumkcu, newNamepr, newNameprs, newXarkt, newGost, newKei : string;
  newEip : string;
  newDateTr : TDateTime;
  newSklad : string;

implementation

{$R *.dfm}

function TDM.checkBuxStruks(strukId : integer; buxName : string) : boolean;
begin
  BMOMTSSess.Open;
  bmomts.Close;
  bmomts.ParamByName('struk_id').AsInteger := strukId;
  bmomts.ParamByName('buxName').AsString := buxName;
  bmomts.Open;
  if (bmomts.RecordCount > 0) then
    result := true
  else
    result := false;
  bmomts.Close;
  BMOMTSSess.Close;
end;

procedure TDM.setLogger(var log : TLogger);
begin
  self.log := @log;
end;

function TDM.appendNomen(bals, numkcu, namepr, nameprs, xarkt, gost, eip,
                         sklad, kei : string; dateTr : TDateTime) : boolean;
begin
  newBals := bals;
  newNumkcu := numkcu;
  newNamepr := namepr;
  newNameprs := nameprs;
  newXarkt := xarkt;
  newGost := gost;
  newKei := kei;
  newEip := eip;
  newSklad := sklad;
  newDateTr := dateTr;
  dm.NomenMem.Append;
  NomenMemEditNewRecord;
  result := true;
end;

procedure TDM.addValues2NesootvTbl(sklad, numkcu, namepr, oper, datetr, numndok,
                                   kol, mei, cex, post, bals, debet, mes, god,
                                   money, np, strukId, buxName : string);
begin
  addNedobavProc.StoredProcName := 'ADD_K2D_NEDOBAV_RASH';
  addNedobavProc.ExecProc;
  NesootvTbl.Append;
  NesootvTbl.Edit;
  NesootvTblNEDOBAVRASH_ID.AsInteger := addNedobavProc.Params.Items[0].AsInteger;
  NesootvTblSKLAD.AsString := sklad;
  NesootvTblNUMKSU.AsString := numkcu;
  NesootvTblNAMEPR.AsString := namepr;
  NesootvTblOPER.AsString := oper;
  NesootvTblDATETR.AsString := datetr;
  NesootvTblNUMNDOK.AsString := numndok;
  NesootvTblKOL.AsString := kol;
  NesootvTblMEI.AsString := mei;
  NesootvTblCEX.AsString := cex;
  NesootvTblPOST.AsString := post;
  NesootvTblACCOUNT.AsString := bals;
  NesootvTblDEBET.AsString := debet;
  NesootvTblMES.AsString := mes;
  NesootvTblGOD.AsString := god;
  NesootvTblNP.AsString := np;
  NesootvTblMONEY.AsString := money;
  NesootvTblSTRUK_ID.AsString := strukId;
  NesootvTblMACHINE.AsString := buxName;
  NesootvTbl.Post;
end;

procedure TDM.restoreNomenForPrih(curMonth, curYear : integer; buxName : string);
begin
  if (Prih.Active) and (Prih.RecordCount > 0) then
  begin
    Prih.First;
    while (not Prih.Eof) do
    begin
      if (NomenMemLocate(PrihNUMKCU.AsString, PrihSKLAD.AsString, PrihBALS.AsString)) then
      begin
        editNomenRec('PRIXR', IntToStr(curMonth), IntToStr(curYear), buxName,
                     Prih.FieldByName('KOL').AsFloat, Prih.FieldByName('SUM').AsFloat,
                     Prih.FieldByName('SUMD').AsFloat);
      end;
      Prih.Next;
    end;
    log^.appendMsg('¬осстановили картотеку ''restoreNomenForPrih''.');
  end;
end;

procedure TDM.restoreNomenForRash(curMonth, curYear : integer; buxName : string);
begin
  if (Rash.Active) and (Rash.RecordCount > 0) then
  begin
    Rash.First;
    while (not Rash.Eof) do
    begin
      if (NomenMemLocate(RashNUMKCU.AsString, RashSKLAD.AsString, RashBALS.AsString)) then
      begin
        editNomenRec('RASXR', IntToStr(curMonth), IntToStr(curYear), buxName,
                     Rash.FieldByName('KOL').AsFloat, Rash.FieldByName('SUM').AsFloat,
                     Rash.FieldByName('SUMD').AsFloat);
      end;
      Rash.Next;
    end;
    log^.appendMsg('¬осстановили картотеку ''restoreNomenForRash''.');
  end;
end;

function TDM.editNomenRec(kartType, mes, god, buxName: string; kol, summa, sumSNds : double) : boolean;
var
  znak, znakVosst : integer;
begin
  result := false;
  if (NomenMem.Active) then
  begin
    znak := 0;
    znakVosst := 1;
    if (kartType = 'RASX') then    // если добавл€ем расходы в номен
      znak := -1;               // чтобы знак был -
    if (kartType = 'PRIX') then    // если добавл€ем приходы в номен
      znak := 1;              // чтобы знак был с +
    if (kartType = 'RASXR') then
    begin
      kartType := 'RASX';
      znak := 1;
      znakVosst := -1;
    end;
    if (kartType = 'PRIXR') then
    begin
      kartType := 'PRIX';
      znak := -1;
      znakVosst := -1;
    end;

    try
      if (NomenMem.FieldByName('KOL').AsFloat + znak * kol >= 0) then     // если достаточно количества на карточке
      begin
        NomenMem.Edit;
        NomenMem.FieldByName('KOL').AsFloat := StrToFloat(NomenMem.FieldByName('KOL').AsString)
                                               + StrToFloat(FloatToStr(znak * kol));
        NomenMem.FieldByName('SUM').AsFloat := NomenMem.FieldByName('SUM').AsFloat        // текуща€ сумма
                                               + znak * summa;
        NomenMem.FieldByName('SUMD').AsFloat := NomenMem.FieldByName('SUMD').AsFloat        // сумма с ндс
                                                + znak * sumSNds;

        NomenMem.FieldByName(kartType + 'ODM').AsFloat := NomenMem.FieldByName(kartType + 'ODM').AsFloat  // кол-во приходов/расходов PRIXODM/RASXODM за мес€ц
                                                          + kol * znakVosst;
        NomenMem.FieldByName('S' + kartType + 'M').AsFloat := NomenMem.FieldByName('S' + kartType + 'M').AsFloat    // сумма расходов за мес€ц
                                                              + summa * znakVosst;
        NomenMem.FieldByName('S' + kartType + 'MD').AsFloat := NomenMem.FieldByName('S' + kartType + 'MD').AsFloat    // сумма расходов с ндс
                                                               + sumSNds * znakVosst;

        if (NomenMem.FieldByName('KOL').AsFloat <> 0) then
        begin
          NomenMem.FieldByName('MONEY').AsFloat := dm.NomenMem.FieldByName('SUM').AsFloat         // средневзвешенна€ цена
                                                   / dm.NomenMem.FieldByName('KOL').AsFloat;
          NomenMem.FieldByName('CENAD').AsFloat := dm.NomenMem.FieldByName('SUMD').AsFloat         // средневзвешенна€ цена с ндс
                                                   / dm.NomenMem.FieldByName('KOL').AsFloat;
        end;
        dm.NomenMem.Post;
        result := true;
      end
      else
      begin
        addValues2NesootvTbl(NomenMem.FieldByName('SKLAD').AsString, NomenMem.FieldByName('NUMKCU').AsString,
                             NomenMem.FieldByName('NAMEPR').AsString, KartRashQueryOPER.AsString,
                             KartRashQueryDATETR.AsString, KartRashQueryNUMNDOK.AsString,
                             KartRashQueryKOL.AsString, KartRashQueryMEI.AsString,
                             KartRashQueryCEX.AsString, KartRashQueryPOST.AsString,
                             NomenMem.FieldByName('BALS').AsString, KartRashQueryDEBET.AsString, mes, god,
                             KartRashQueryMONEY.AsString, KartRashQueryNP.AsString,
                             ConfigUMCSTRUK_ID.AsString, buxName);
      end;
    except
      on e : exception do
      begin
        ShowMessage('ќшибка: ' + e.message + 'numksu: ' + NomenMem.FieldByName('NUMKSU').AsString
                    + '; kol: ' + NomenMem.FieldByName('kol').AsString + '; sum: '
                    + NomenMem.FieldByName('sum').AsString);
      end;
    end;
  end;
end;

procedure TDM.NomenMemEditNewRecord;
begin
  NomenMem.Edit;
  NomenMem.FieldByName('NAMEPR').AsString := newNamepr;
  NomenMem.FieldByName('NAMEPRS').AsString := newNameprs;
  NomenMem.FieldByName('BALS').AsString := newBals;
  NomenMem.FieldByName('numkcu').AsString := newNumkcu;
  NomenMem.FieldByName('xarkt').AsString := newXarkt;
  NomenMem.FieldByName('gost').AsString := newGost;
  NomenMem.FieldByName('kei').AsString := newKei;
  NomenMem.FieldByName('eip').AsString := newEip;
  NomenMem.FieldByName('datein').AsDateTime := Date;
  NomenMem.FieldByName('sklad').AsString := newSklad;
  NomenMem.FieldByName('dateTr').AsDateTime := newDateTr;
  NomenMem.FieldByName('money').AsFloat := 0;
  NomenMem.FieldByName('nz').AsInteger := 0;
  NomenMem.FieldByName('kol').AsFloat := 0;
  NomenMem.FieldByName('sum').AsFloat := 0;
  NomenMem.FieldByName('prixodm').AsFloat := 0;
  NomenMem.FieldByName('rasxodm').AsFloat := 0;
  NomenMem.FieldByName('srasxm').AsFloat := 0;
  NomenMem.FieldByName('sprixm').AsFloat := 0;
  NomenMem.FieldByName('ednor').AsInteger := 1;
  NomenMem.FieldByName('ssum').AsFloat := 0;
  NomenMem.FieldByName('nsum').AsFloat := 0;
  NomenMem.FieldByName('skol').AsFloat := 0;
  NomenMem.FieldByName('cenad').AsFloat := 0;
  NomenMem.FieldByName('sumd').AsFloat := 0;
  NomenMem.FieldByName('ssumd').AsFloat := 0;
  NomenMem.FieldByName('sprixmd').AsFloat := 0;
  NomenMem.FieldByName('srasxmd').AsFloat := 0;
//  if (NomenMem.FindField('sumnds') <> nil) then
//    NomenMem.FieldByName('sumnds').AsFloat := 0;
  NomenMem.Post;
end;

procedure TDM.activatePrihDbf(localPath, stkod : string; exclusive : boolean);
begin
  openWorkSession;
  PrihDbf.Close;
  PrihDbf.Exclusive := exclusive;
  PrihDbf.TableName := AnsiLowerCase(localPath) + '\prixod.dbf';
  PrihDbf.Open;
  PrihDbf.Filtered := false;
  PrihDbf.Filter := 'SKLAD = ' + stkod;
  PrihDbf.Filtered := true;
  PrihDbf.Last;
end;

procedure TDM.openMaxRegnsfPrih(localPath, stkod : string);
begin
  dm.maxPrihRegnsf.Close;
  dm.maxPrihRegnsf.EhSQL.Text := 'select max(prixod.regnsf) maxRegnsf '
                                 + 'from "' + AnsiLowerCase(localPath) + 'prixod.dbf" prixod '
                                 + 'where prixod.sklad <> "' + AnsiLowerCase(stkod) + '" ';
  dm.maxPrihRegnsf.Open;
end;

procedure TDM.openPrihDbfQuery(localPath, stkod : string);
begin
  openWorkSession;
  Prih.Close;
  Prih.EhSQL.Text := 'select * from "' + AnsiLowerCase(localPath) + 'prixod.dbf" prixod '
                        + 'where prixod.doc_id <> 0 and prixod.sklad = "' + stkod + '" ';
  UpdPrih.InsertSQL.Text := 'insert into "' + AnsiLowerCase(localPath) + 'prixod.dbf" '
                            + '(BALS, NUMKCU, NAMEPR, MEI, EIZ, OPER, DATETR, NUMDOK, '
                            + 'NSD, DATSD, KP, POST, KOL, KOLOTG, "' + AnsiLowerCase(localPath)
                            + 'prixod.dbf"."MONEY", "' + AnsiLowerCase(localPath)
                            + 'prixod.dbf"."SUM", KPZ, REGNSF, KOLNEDN, KOLNEDS, '
                            + 'KOLMATPUT, SUMNEDN, SUMNEDS, SUMMATP, SKLAD, DEBDOP, '
                            + 'KRDOP, PRIZVX, PRIZN, KREG, NP, KORR, WW1, SUMD, '
                            + 'DOC_ID) values '
                            + '(:BALS, :NUMKCU, :NAMEPR, :MEI, :EIZ, :OPER, :DATETR, '
                            + ':NUMDOK, :NSD, :DATSD, :KP, :POST, :KOL, :KOLOTG, '
                            + ':MONEY, :SUM, :KPZ, :REGNSF, :KOLNEDN, :KOLNEDS, '
                            + ':KOLMATPUT, :SUMNEDN, :SUMNEDS, :SUMMATP, :SKLAD, '
                            + ':DEBDOP, :KRDOP, :PRIZVX, :PRIZN, :KREG, :NP, :KORR, '
                            + ':WW1, :SUMD, :DOC_ID) ';
  UpdPrih.DeleteSQL.Text := 'delete from "' + AnsiLowerCase(localPath) + 'prixod.dbf" '
                            + 'where BALS = :OLD_BALS and NUMKCU = :OLD_NUMKCU and '
                            + 'NP = :OLD_NP and DOC_ID = :OLD_DOC_ID ';
  UpdPrih.ModifySQL.Text := 'update "' +AnsiLowerCase(localPath) + 'prixod.dbf" '
                            + 'set BALS = :BALS, NUMKCU = :NUMKCU, NAMEPR = :NAMEPR, '
                            + 'MEI = :MEI, EIZ = :EIZ, OPER = :OPER, DATETR = :DATETR, '
                            + 'NUMDOK = :NUMDOK, NSD = :NSD, DATSD = :DATSD, KP = :KP, '
                            + 'POST = :POST, KOL = :KOL, KOLOTG = :KOLOTG, '
                            + '"' + AnsiLowerCase(localPath) + 'prixod.dbf"."MONEY" = :MONEY, '
                            + '"' + AnsiLowerCase(localPath) + 'prixod.dbf"."SUM" = :SUM, '
                            + 'KPZ = :KPZ, REGNSF = :REGNSF, KOLNEDN = :KOLNEDN, '
                            + 'KOLNEDS = :KOLNEDS, KOLMATPUT = :KOLMATPUT, '
                            + 'SUMNEDN = :SUMNEDN, SUMNEDS = :SUMNEDS, SUMMATP = :SUMMATP, '
                            + 'SKLAD = :SKLAD, DEBDOP = :DEBDOP, KRDOP = :KRDOP, '
                            + 'PRIZVX = :PRIZVX, PRIZN = :PRIZN, KREG = :KREG, NP = :NP, '
                            + 'KORR = :KORR, WW1 = :WW1, SUMD = :SUMD,  '
                            + 'DOC_ID = :DOC_ID where BALS = :OLD_BALS and '
                            + 'NUMKCU = :OLD_NUMKCU and NP = :OLD_NP and DOC_ID = :OLD_DOC_ID';
  Prih.Open;
  log^.appendMsg('¬ыбрали данные из приходов PRIXOD.dbf: ' + IntToStr(Prih.RecordCount));
end;

procedure TDM.activateRashDbf(localPath, stkod : string; exclusive : boolean);
begin
  openWorkSession;
  RashDbf.Close;
  RashDbf.Exclusive := exclusive;
  RashDbf.DatabaseName := '';
  RashDbf.TableName := AnsiLowerCase(localPath) + 'rasxod.dbf';
  RashDbf.Open;
  RashDbf.Filtered := false;
  RashDbf.Filter := 'SKLAD = ' + stkod;
  RashDbf.Filtered := true;
  RashDbf.Last;
end;

procedure TDM.openRashDbfQuery(localPath, stkod, strukId : string);
begin
  openWorkSession;
  Rash.Close;
  Rash.EhSQL.Text := 'select * from "' + AnsiLowerCase(localPath) + 'rasxod.dbf" rasxod '
                        + 'where rasxod.doc_id <> 0 and rasxod.sklad = "' + stkod + '" ';
  if (stkod = '1600') then
  	Rash.EhSQL.Text := Rash.EhSQL.Text + ' and rasxod.struk_id = "' + strukId + '" ';
  UpdRash.InsertSQL.Text := 'insert into "' + AnsiLowerCase(localPath) + 'rasxod.dbf" '
                            + '(DEBET, BALS, NUMKCU, NAMEPR, KEI, EIZ, OPER, DATETR, '
                            + 'NUMDOK, CEX, POST, MOL, KOL, "' + AnsiLowerCase(localPath)
                            + 'rasxod.dbf"."MONEY", "' + AnsiLowerCase(localPath)
                            + 'rasxod.dbf"."SUM", KPZ, SKLAD, NACEN, DT1, KT1, SUM1, DT2, '
                            + 'KT2, PRIZN, PRIZNVX, OTK, KT, NMASH, NP, KORR, SUMD, DOC_ID, STRUK_ID) '
                            + 'values (:DEBET, :BALS, :NUMKCU, :NAMEPR, :KEI, :EIZ, '
                            + ':OPER, :DATETR, :NUMDOK, :CEX, :POST, :MOL, :KOL, '
                            + ':MONEY, :SUM, :KPZ, :SKLAD, :NACEN, :DT1, :KT1, :SUM1, '
                            + ':DT2, :KT2, :PRIZN, :PRIZNVX, :OTK, :KT, :NMASH, :NP, '
                            + ':KORR, :SUMD, :DOC_ID, :STRUK_ID) ';
  UpdRash.DeleteSQL.Text := 'delete from "' + AnsiLowerCase(localPath) + 'rasxod.dbf" '
                            + 'where BALS = :OLD_BALS and NUMKCU = :OLD_NUMKCU and '
                            + 'NP = :OLD_NP and DOC_ID = :OLD_DOC_ID ';
  UpdRash.ModifySQL.Text := 'update "' +AnsiLowerCase(localPath) + 'rasxod.dbf" '
                            + 'set DEBET = :DEBET, BALS = :BALS, NUMKCU = :NUMKCU, '
                            + 'NAMEPR = :NAMEPR, KEI = :KEI, EIZ = :EIZ, OPER = :OPER, '
                            + 'DATETR = :DATETR, NUMDOK = :NUMDOK, CEX = :CEX, '
                            + 'POST = :POST, MOL = :MOL, KOL = :KOL, "'
                            + AnsiLowerCase(localPath) + 'rasxod.dbf"."MONEY" = :MONEY, "'
                            + AnsiLowerCase(localPath) + 'rasxod.dbf"."SUM" = :SUM, '
                            + 'KPZ = :KPZ, SKLAD = :SKLAD, NACEN = :NACEN, DT1 = :DT1, '
                            + 'KT1 = :KT1, SUM1 = :SUM1, DT2 = :DT2, KT2 = :KT2, '
                            + 'PRIZN = :PRIZN, PRIZNVX = :PRIZNVX, OTK = :OTK, '
                            + 'KT = :KT, NMASH = :NMASH, NP = :NP, KORR = :KORR, '
                            + 'SUMD = :SUMD, DOC_ID = :DOC_ID, STRUK_ID = :STRUK_ID where '
                            + 'BALS = :OLD_BALS and NUMKCU = :OLD_NUMKCU and '
                            + 'NP = :OLD_NP and DOC_ID = :OLD_DOC_ID ';
  Rash.Open;
  log^.appendMsg('¬ыбрали данные из расходов RASXOD.dbf: ' + IntToStr(Rash.RecordCount));
end;

procedure TDM.activateNomenDbf(localPath, stkod : string; exclusive : boolean);
begin
  openWorkSession;
  Nomen.Close;
  Nomen.Exclusive := exclusive;
  Nomen.DatabaseName := '';
  Nomen.TableName := AnsiLowerCase(localPath) + '\nomen.dbf';
  Nomen.Open;
  Nomen.Filtered := false;
  Nomen.Filter := 'SKLAD = ' + stkod;
  Nomen.Filtered := true;
  Nomen.Last;
  fillNomenMem();
  log^.appendMsg('¬ыбрали данные из картотеки NOMEN.dbf.');
end;

procedure TDM.openPrihOldDbf(localPath : string; exclusive : boolean);
begin
  openBlockSession(localPath);
  PrihOld.Close;
  PrihOld.Exclusive := exclusive;
  PrihOld.DatabaseName := '';
  PrihOld.TableName := AnsiLowerCase(localPath) + '\prixod.dbf';
  PrihOld.Open;
end;

procedure TDM.openRashOldDbf(localPath : string; exclusive : boolean);
begin
  openBlockSession(localPath);
  dm.RashOld.Close;
  dm.RashOld.Exclusive := exclusive;
  dm.RashOld.DatabaseName := '';
  dm.RashOld.TableName := AnsiLowerCase(localPath) + '\rasxod.dbf';
  dm.RashOld.Open;
end;

procedure TDM.openWorkSession;
begin
  if (not WorkSession.Active) then
  begin
    WorkSession.NetFileDir := 'C:\WORK';
    WorkSession.PrivateDir := 'C:\WORK';
    WorkSession.Active := true;
  end;
end;

procedure TDM.openBlockSession(path : string);
begin
  if (not BlockSession.Active) and (BlockSession.NetFileDir <> path) then
  begin
    BlockSession.NetFileDir := path;
    BlockSession.PrivateDir := path;
    BlockSession.Active := true;
  end;
end;

procedure TDM.openNomenOldDbf(localPath : string; exclusive : boolean);
begin
  openBlockSession(localPath);
  dm.NomenOld.Close;
  dm.NomenOld.Exclusive := exclusive;
  dm.NomenOld.DatabaseName := '';
  dm.NomenOld.TableName := AnsiLowerCase(localPath) + '\nomen.dbf';
  dm.NomenOld.Open;
end;

procedure TDM.activateKartPrihQuery(curMonth : integer; curYear : integer);
begin
  dm.KartPrihQuery.Close;
  dm.KartPrihQuery.ParamByName('struk_id').AsInteger := dm.ConfigUMCSTRUK_ID.AsInteger;
  dm.KartPrihQuery.ParamByName('mes').AsInteger := curMonth;
  dm.KartPrihQuery.ParamByName('god').AsInteger := curYear;
  dm.KartPrihQuery.Open;
  dm.KartPrihQuery.FetchAll;
  log^.appendMsg('¬ыбрали данные по приходам из IB kartPrihQuery: ' + IntToStr(KartPrihQuery.RecordCount));
end;

procedure TDM.activateKartRashQuery(curMonth : integer; curYear : integer);
begin
  dm.KartRashQuery.Close;
  dm.KartRashQuery.ParamByName('struk_id').AsInteger := dm.ConfigUMCSTRUK_ID.AsInteger;
  dm.KartRashQuery.ParamByName('mes').AsInteger := curMonth;
  dm.KartRashQuery.ParamByName('god').AsInteger := curYear;
  dm.KartRashQuery.Open;
  dm.KartRashQuery.FetchAll;
  log^.appendMsg('¬ыбрали данные по расходам из IB kartRashQuery: ' + IntToStr(KartRashQuery.RecordCount));
end;

procedure TDM.setDiskLetter(driveLetter: string);
begin
  m_diskPath := AnsiLowerCase(driveLetter) + ':\';
end;

function TDM.getDiskPath() : string;
begin
  result := m_diskPath;
end;

procedure TDM.fillNomenMem();
begin
  NomenMem.Close;
  NomenMem.EmptyTable;
  NomenMem.Open;
  if (Nomen.Active) and (Nomen.RecordCount > 0) then
    NomenMem.LoadFromDataSet(Nomen, 0, lmAppend);
end;

function TDM.saveNomenMemToNomen() : boolean;
begin
  if (Nomen.Active){ and (Nomen.RecordCount > 0)} then
  begin
    Nomen.First;
    while (not Nomen.Eof) do
      Nomen.Delete;
    NomenMem.First;
    while (not NomenMem.Eof) do
    begin
      appendNomenMemRecToNomenRec;
      NomenMem.Next;
    end;
    result := true;
  end
  else
    result := false;
end;

procedure TDM.appendNomenMemRecToNomenRec;
begin
  Nomen.Append;
  Nomen.FieldByName('NAMEPR').AsString := NomenMem.FieldByName('NAMEPR').AsString;
  Nomen.FieldByName('NAMEPRS').AsString := NomenMem.FieldByName('NAMEPRS').AsString;
  Nomen.FieldByName('BALS').AsString := NomenMem.FieldByName('BALS').AsString;
  Nomen.FieldByName('numkcu').AsString := NomenMem.FieldByName('numkcu').AsString;
  Nomen.FieldByName('xarkt').AsString := NomenMem.FieldByName('xarkt').AsString;
  Nomen.FieldByName('gost').AsString := NomenMem.FieldByName('gost').AsString;
  Nomen.FieldByName('kei').AsString := NomenMem.FieldByName('kei').AsString;
  Nomen.FieldByName('eip').AsString := NomenMem.FieldByName('eip').AsString;
  Nomen.FieldByName('datein').AsDateTime := NomenMem.FieldByName('datein').AsDateTime;
  Nomen.FieldByName('sklad').AsString := NomenMem.FieldByName('sklad').AsString;
  Nomen.FieldByName('dateTr').AsDateTime := NomenMem.FieldByName('dateTr').AsDateTime;
  Nomen.FieldByName('money').AsFloat := NomenMem.FieldByName('money').AsFloat;
  Nomen.FieldByName('nz').AsInteger := NomenMem.FieldByName('nz').AsInteger;
  Nomen.FieldByName('kol').AsFloat := NomenMem.FieldByName('kol').AsFloat;
  Nomen.FieldByName('sum').AsFloat := NomenMem.FieldByName('sum').AsFloat;
  Nomen.FieldByName('prixodm').AsFloat := NomenMem.FieldByName('prixodm').AsFloat;
  Nomen.FieldByName('rasxodm').AsFloat := NomenMem.FieldByName('rasxodm').AsFloat;
  Nomen.FieldByName('srasxm').AsFloat := NomenMem.FieldByName('srasxm').AsFloat;
  Nomen.FieldByName('sprixm').AsFloat := NomenMem.FieldByName('sprixm').AsFloat;
  Nomen.FieldByName('ednor').AsInteger := NomenMem.FieldByName('ednor').AsInteger;
  Nomen.FieldByName('ssum').AsFloat := NomenMem.FieldByName('ssum').AsFloat;
  Nomen.FieldByName('nsum').AsFloat := NomenMem.FieldByName('nsum').AsFloat;
  Nomen.FieldByName('skol').AsFloat := NomenMem.FieldByName('skol').AsFloat;
  Nomen.FieldByName('cenad').AsFloat := NomenMem.FieldByName('cenad').AsFloat;
  Nomen.FieldByName('sumd').AsFloat := NomenMem.FieldByName('sumd').AsFloat;
  Nomen.FieldByName('ssumd').AsFloat := NomenMem.FieldByName('ssumd').AsFloat;
  Nomen.FieldByName('sprixmd').AsFloat := NomenMem.FieldByName('sprixmd').AsFloat;
  Nomen.FieldByName('srasxmd').AsFloat := NomenMem.FieldByName('srasxmd').AsFloat;
  if (Nomen.FindField('sumnds') <> nil) then
    Nomen.FieldByName('sumnds').AsFloat := NomenMem.FieldByName('sumnds').AsFloat;
  Nomen.Post;
end;

procedure TDM.clearPrih;
begin
  if (Prih.Active) and (Prih.RecordCount > 0) then
  begin
    Prih.First;
    while (not Prih.Eof) do
      Prih.Delete;
    log^.appendMsg('”далили старые приходы из PRIXOD.dbf.');
  end;
end;

procedure TDM.clearRash;
begin
  if (Rash.Active) and (Rash.RecordCount > 0) then
  begin
    Rash.First;
    while (not Rash.Eof) do
      Rash.Delete;
    log^.appendMsg('”далили старые расходы из RASXOD.dbf.');
  end;
end;

function TDM.NomenMemLocate(numkcu, sklad, bals: string) : boolean;
begin
  result := false;
  if (NomenMem.RecordCount > 0) then
  begin
    NomenMem.First;
    while (not NomenMem.Eof) do
    begin
      if (trim(NomenMemBALS.AsString) = trim(bals))
         and (trim(NomenMemNUMKCU.AsString) = trim(numkcu))
         and (trim(NomenMemSKLAD.AsString) = trim(sklad)) then
      begin
        if (numkcu = '32367') then
          ShowMessage(trim(NomenMemBALS.AsString) + '_' + trim(bals));
        result := true;
        break;
      end;
      NomenMem.Next;
    end;
  end;
end;

procedure TDM.openNesootvTbl(buxName : string; month, year, strukId : integer);
begin
  NesootvTbl.Close;
  NesootvTbl.ParamByName('machine').AsString := buxName;
  NesootvTbl.ParamByName('mes').AsInteger := month;
  NesootvTbl.ParamByName('god').AsInteger := year;
  if (strukId = -32000) then
    NesootvTbl.MacroByName('struk_id_usl').AsString := '0=0'
  else
    NesootvTbl.MacroByName('struk_id_usl').AsString := 'k2d_nedobav_rash.struk_id = ' + IntToStr(strukId);
  NesootvTbl.Open;
end;

procedure TDM.saveNesootvTbl;
begin
  if (NesootvTbl.Active) then
  begin
    if (NesootvTbl.Modified) or (NesootvTbl.State = dsInsert)
       or (NesootvTbl.State = dsEdit) then
       NesootvTbl.Post;
    if (NesootvTbl.UpdatesPending) then
      NesootvTbl.ApplyUpdates;
    if (not RTrans.Active) then
      RTrans.StartTransaction;
    RTrans.CommitRetaining;
    if (not WTrans.Active) then
      WTrans.StartTransaction;
    WTrans.CommitRetaining;
    log^.appendMsg('—охранили таблицу недобавленных расходов.');
  end;
end;

procedure TDM.clearNesootvTbl;
begin
  if (dm.NesootvTbl.RecordCount > 0) then
  begin
    dm.NesootvTbl.First;
    while (not dm.NesootvTbl.Eof) do
      dm.NesootvTbl.Delete;
  end;
  log^.appendMsg('ќчистили таблицу недобавленных расходов.');
end;

procedure TDM.DataModuleCreate(Sender: TObject);
var
  userName3Char : string;
begin
  userName := GetCurrentUserName;
  userName3Char := copy(AnsiLowerCase(userName), 1, 3);
  BELMED.Close;
  BELMED.Params.Clear;
  BELMED.Params.Add('lc_ctype=WIN1251');
  BELMED.Params.Add('sql_role_name=SKLAD_BUX');
  BELMED.Params.Add('user_name=' + UpperCase(userName));
  BELMED.Params.Add('password=' + AnsiLowerCase(userName));
  try
    BELMED.Connected := True;
  except
    BELMED.LoginPrompt := True;
    try
      BELMED.Params.Values['password'] := '';
      BELMED.Connected := True;
    except
      userName := BELMED.Params.Values['user_name'];
      ShowMessage('” пользовател€ ' + UserName + ' нет доступа к базе данных');
    end;
  end;
  if (userName3Char = 'igo') or (userName3Char = 'bm5') or (userName3Char = 'bmg') then
    showPrih := true
  else
    showPrih := false;
  new(log);
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  BlockSession.Active := false;
  WorkSession.Active := false;
end;

procedure TDM.setVxodControlRashQuery(setVxContr : boolean);
begin
  KartRashQuery.Close;
  if (setVxContr) then
  begin
    KartRashQuery.MacroByName('usl').AsString := 'document.tip_op_id = 135 '
                                                 + 'and document.tip_dok_id = 125 ' ;
//    KartRashQuery.SQL.Text := 'select iif(relaStr.stkod is not null, relaStr.stkod, '
//                              + 'configumc.stkod) sklad, padleft(TRIM(cast(kart.ksm_id as char(5))), 7, ''0'') numksu, '
//                              + 'matrop.nmat namepr, matrop.nmats nameprs, matrop.xarkt, '
//                              + 'matrop.gost, '
//                              + 'cast(iif(document.tip_op_id in (85, 112, 113, 32, 103, 104), '
//                              + '''p'', iif(document.tip_op_id = 131, ''2'', '
//                              + 'iif(document.tip_op_id in (8, 9, 110, 140, 11, 147, 78, 10, 105, 93, 135), '
//                              + '''9'', ''1''))) as char(2)) oper, '
//                              + 'document.date_op datetr, substring(trim(document.ndok) from 1 for 5)  numndok, '
//                              + 'cast(iif(document.tip_op_id = 1, document.klient_id, struk.stkod) as char(5)) kp, '
//                              + 'kart.kol_rash kol, kart.kol_rash kolotg, '
//                              + 'iif(document.struk_id < 0,cast(kart.kei_id2 as char(4)), cast(matrop.kei_id as char(4))) eiz, '
//                              + 'ediz.neis mei, iif(document.tip_op_id in (32, 103, 104, 112, 113), '', struk.stkod) cex, '
//                              + 'iif(document.struk_id in (163, 87), struk.stkod, '
//                              + 'iif(document.tip_op_id in (32, 103, 104, 112, 113), '
//                              + 'iif(configumc.struk_id in (542, 543, 544, 545, 546, 708, -540), '
//                              + '''1600'', configumc.stkod), struk.stname)) post, '
//                              + 'kart.cena money, iif(document.tip_op_id in (32, 103, 104, 112, 113), '
//                              + 'iif(kart.sum_nds = 0, kart.summa, kart.sum_nds), '
//                              + 'kart.sum_nds) sum_nds, kart.summa, document.nds, '
//                              + 'ostatki.account, '
//                              + 'cast(iif((kart.dcode is null)  or (kart.dcode = 1) or '
//                              + '(char_length(rtrim(ltrim(kart.debet))) > 3 '
//                              + 'and substring(rtrim(ltrim(kart.debet)) from char_length(rtrim(ltrim(kart.debet))) for  1) <> ''/'') , '
//                              + 'rtrim(ltrim(kart.debet)), '
//                              + 'iif(substring(rtrim(ltrim(kart.debet)) from char_length(rtrim(ltrim(kart.debet))) for  1) <> ''/'', '
//                              + 'rtrim(ltrim(kart.debet)) || ''/'' || rtrim(ltrim(kart.dcode)), '
//                              + 'rtrim(ltrim(kart.debet)) || rtrim(ltrim(kart.dcode)) )) as varchar(5)) as debet, '
//                              + 'substring(kart.stroka_id from char_length(kart.stroka_id)-3 for char_length(kart.stroka_id)) np, '
//                              + 'tip_oper.nam_op, tip_oper.tip_op_id, document.priz_id, '
//                              + 'document.doc_id, document.struk_id, document.klient_id '
//
//                              + 'from document '
//
//                              + 'inner join kart on document.doc_id = kart.doc_id '
//                              + 'inner join matrop on kart.ksm_id = matrop.ksm_id '
//                              + 'inner join ediz on matrop.kei_id = ediz.kei_id '
//                              + 'left join sprorg on document.klient_id = sprorg.kod '
//                              + 'left join struk on document.klient_id = struk.struk_id '
//                              + 'inner join configumc on document.struk_id = configumc.struk_id '
//                              + 'left join ostatki on kart.kart_id = ostatki.kart_id '
//                              + 'left join seria on ostatki.seria_id = seria.seria_id '
//                              + 'left join tip_oper on tip_oper.tip_op_id = document.tip_op_id '
//                              + 'left join struk relaStr on relaStr.struk_id = configumc.rela_struk_id '
//
//                              + 'where kart.kol_rash <> 0 and matrop.account <> ''01'' '
//                              + 'and document.struk_id = :struk_id '
//                              + 'and document.tip_op_id = 135 '
//                              + 'and document.tip_dok_id = 125 '
//                              + 'and extract(month from document.date_op) = :mes '
//                              + 'and extract(year from document.date_op) = :god '
//                              + 'and document.tip_op_id <> 93 ';
  end
  else
  begin
    KartRashQuery.MacroByName('usl').AsString := 'tip_oper.gr_op_id = 2 ';
//    KartRashQuery.SQL.Text := 'select iif(relaStr.stkod is not null, relaStr.stkod, '
//                              + 'configumc.stkod) sklad, padleft(TRIM(cast(kart.ksm_id as char(5))), 7, ''0'') numksu, '
//                              + 'matrop.nmat namepr, matrop.nmats nameprs, matrop.xarkt, '
//                              + 'matrop.gost, '
//                              + 'cast(iif(document.tip_op_id in (85, 112, 113, 32, 103, 104), '
//                              + '''p'', iif(document.tip_op_id = 131, ''2'', '
//                              + 'iif(document.tip_op_id in (8, 9, 110, 140, 11, 147, 78, 10, 105, 93, 135), '
//                              + '''9'', ''1''))) as char(2)) oper, '
//                              + 'document.date_op datetr, substring(trim(document.ndok) from 1 for 5)  numndok, '
//                              + 'cast(iif(document.tip_op_id = 1, document.klient_id, struk.stkod) as char(5)) kp, '
//                              + 'kart.kol_rash kol, kart.kol_rash kolotg, '
//                              + 'iif(document.struk_id < 0,cast(kart.kei_id2 as char(4)), cast(matrop.kei_id as char(4))) eiz, '
//                              + 'ediz.neis mei, iif(document.tip_op_id in (32, 103, 104, 112, 113), '', struk.stkod) cex, '
//                              + 'iif(document.struk_id in (163, 87), struk.stkod, '
//                              + 'iif(document.tip_op_id in (32, 103, 104, 112, 113), '
//                              + 'iif(configumc.struk_id in (542, 543, 544, 545, 546, 708, -540), '
//                              + '''1600'', configumc.stkod), struk.stname)) post, '
//                              + 'kart.cena money, iif(document.tip_op_id in (32, 103, 104, 112, 113), '
//                              + 'iif(kart.sum_nds = 0, kart.summa, kart.sum_nds), '
//                              + 'kart.sum_nds) sum_nds, kart.summa, document.nds, '
//                              + 'ostatki.account, '
//                              + 'cast(iif((kart.dcode is null)  or (kart.dcode = 1) or '
//                              + '(char_length(rtrim(ltrim(kart.debet))) > 3 '
//                              + 'and substring(rtrim(ltrim(kart.debet)) from char_length(rtrim(ltrim(kart.debet))) for  1) <> ''/'') , '
//                              + 'rtrim(ltrim(kart.debet)), '
//                              + 'iif(substring(rtrim(ltrim(kart.debet)) from char_length(rtrim(ltrim(kart.debet))) for  1) <> ''/'', '
//                              + 'rtrim(ltrim(kart.debet)) || ''/'' || rtrim(ltrim(kart.dcode)), '
//                              + 'rtrim(ltrim(kart.debet)) || rtrim(ltrim(kart.dcode)) )) as varchar(5)) as debet, '
//                              + 'substring(kart.stroka_id from char_length(kart.stroka_id)-3 for char_length(kart.stroka_id)) np, '
//                              + 'tip_oper.nam_op, tip_oper.tip_op_id, document.priz_id, '
//                              + 'document.doc_id, document.struk_id, document.klient_id '
//
//                              + 'from document '
//
//                              + 'inner join kart on document.doc_id = kart.doc_id '
//                              + 'inner join matrop on kart.ksm_id = matrop.ksm_id '
//                              + 'inner join ediz on matrop.kei_id = ediz.kei_id '
//                              + 'left join sprorg on document.klient_id = sprorg.kod '
//                              + 'left join struk on document.klient_id = struk.struk_id '
//                              + 'inner join configumc on document.struk_id = configumc.struk_id '
//                              + 'left join ostatki on kart.kart_id = ostatki.kart_id '
//                              + 'left join seria on ostatki.seria_id = seria.seria_id '
//                              + 'left join tip_oper on tip_oper.tip_op_id = document.tip_op_id and tip_oper.gr_op_id = 2 '
//                              + 'left join struk relaStr on relaStr.struk_id = configumc.rela_struk_id '
//
//                              + 'where kart.kol_rash <> 0 and matrop.account <> ''01'' '
//                              + 'and document.struk_id = :struk_id '
//
//                              + 'and extract(month from document.date_op) = :mes '
//                              + 'and extract(year from document.date_op) = :god '
//                              + 'and document.tip_op_id <> 93 ';
  end;
end;

end.
