unit DataM;

interface

uses
  SysUtils, Classes, IBDatabase, DB, IBCustomDataSet, IBQuery, RxIBQuery,
  DBTables, RxQuery, ERxQuery, RxMemDS, frxDCtrl, frxClass, frxDBSet,
  frxExportPDF, frxExportXML, frxExportXLS, IBUpdateSQL, Dialogs,
  ADODB, Variants, IBUpdSQLW, IBStoredProc, UtilR,
  Logger, kbmMemTable;

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
    NomenOld: TTable;
    PrihOld: TTable;
    RashOld: TTable;
    NesootvTbl: TRxIBQuery;
    NesootvTblUpd: TIBUpdateSQLW;
    WTrans: TIBTransaction;
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
    NomenMem: TkbmMemTable;
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
    NomenMemSUMNDS: TFloatField;
    NomenMemSRASXMD: TFloatField;
    KartPrihQueryKLIENT_ID: TIntegerField;
    KartPrihQuerySTNAME: TIBStringField;
    KartPrihQuerySTKOD: TIBStringField;
    KartPrihQuerySTKOD1: TIBStringField;
    PrihPRIXOD_ID: TFloatField;
    PrihSTRUK_ID: TSmallintField;
    KartPrihQuerySTRUK_ID: TSmallintField;
    KartRashQueryNAME: TIBStringField;
    KartRashQueryTIP_DOK_ID: TSmallintField;
    q_iznos: TRxIBQuery;
    q_iznosNUMKSU: TIBStringField;
    q_iznosNAMEPR: TIBStringField;
    q_iznosKEI: TSmallintField;
    q_iznosEIZ: TIBStringField;
    q_iznosOPER: TIBStringField;
    q_iznosDATETR: TDateField;
    q_iznosNUMNDOK: TIBStringField;
    q_iznosCEX: TIBStringField;
    q_iznosPOST: TIBStringField;
    q_iznosKOL: TFMTBCDField;
    q_iznosSUMMA: TIBBCDField;
    q_iznosSKLAD: TIBStringField;
    q_iznosDOC_ID: TIntegerField;
    q_iznosSTRUK_ID: TIntegerField;
    q_iznosBALS: TIBStringField;
    q_iznosDEBET: TIBStringField;
    q_iznosNAMEPRS: TIBStringField;
    q_iznosXARKT: TIBStringField;
    q_iznosGOST: TIBStringField;
    RashRASXOD_ID: TFloatField;
    RashInd: TTable;
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
    NesootvTblDATE_TIME_UPDATE: TDateTimeField;
    NesootvTblUSER_NAME: TIBStringField;
    NesootvTblSUMMA: TFMTBCDField;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);

  private
    procedure fillNomenMem();
    procedure appendNomenMemRecToNomenRec;
    procedure NomenMemEditNewRecord;

    procedure openBlockSession(path : string);

    var
      m_diskPath : string;
      log : ^TLogger;

  public
    procedure openWorkSession;
    procedure openNesootvTbl(buxName : string; month, year, strukId : integer);
    procedure saveNesootvTbl;
    procedure clearNesootvTbl;
    procedure addValues2NesootvTbl(sklad, numkcu, namepr, oper, datetr, numndok,
                                   kol, mei, cex, post, bals, debet, mes, god, money,
                                   np, strukId, buxName, summa : string);

    function editNomenRec(kartType, mes, god, buxName: string; kol, summa, sumSNds : double) : boolean;
    function appendNomen(bals, numkcu, namepr, nameprs, xarkt, gost, eip,
                         sklad, kei : string; dateTr : TDateTime) : boolean;
    procedure activateNomenDbf(localPath, stkod : string; exclusive : boolean; iznos : boolean);
    procedure openNomenOldDbf(localPath : string; exclusive : boolean);

    procedure activatePrihDbf(localPath, stkod : string; exclusive : boolean);
    procedure openPrihOldDbf(localPath : string; exclusive : boolean);
    procedure openPrihDbfQuery(localPath, stkodRela, strukId, stkod : string);
    procedure activateKartPrihQuery(curMonth : integer; curYear : integer);
    procedure restoreNomenForPrih(curMonth, curYear : integer; buxName : string);
    procedure clearPrih;
    procedure openMaxRegnsfPrih(localPath, stkod : string);

    procedure openRashOldDbf(localPath : string; exclusive : boolean);
    procedure openRashDbfQuery(localPath, stkodRela, strukId, stkod : string; iznos : boolean);
    procedure activateRashDbf(localPath, stkod : string; exclusive : boolean);
    procedure activateRashInd(localPath : string);
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
    procedure setKartRashQueryUsl;
    procedure setSpecOdezh(setSpecOdezh : boolean);
    procedure setBuxName(value : string);
    procedure setPrixodId;
    procedure setRasxodId;

    procedure openIznos(month, year, strukId : integer);

    property diskPath : string read getDiskPath write setDiskLetter;

    var
      filterMonth, filterGod, filterStrukId, maxPrId, maxRId : integer;
      userName, buxName, specBm : string;
      showPrih, vxControl : boolean;

  end;

var
  DM: TDM;

  newBals, newNumkcu, newNamepr, newNameprs, newXarkt, newGost, newKei : string;
  newEip : string;
  newDateTr : TDateTime;
  newSklad : string;

implementation

{$R *.dfm}

procedure TDM.setBuxName(value : string);
begin
  self.buxName := value;
end;

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
                                   money, np, strukId, buxName, summa : string);
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
  NesootvTblSUMMA.AsString := summa;
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
    log^.appendMsg('������������ ��������� ''restoreNomenForPrih''.');
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
    log^.appendMsg('������������ ��������� ''restoreNomenForRash''.');
  end;
end;

function TDM.editNomenRec(kartType, mes, god, buxName: string; kol, summa, sumSNds : double) : boolean;
var
  znak, znakVosst : integer;
  iznos : boolean;
begin
  result := false;
  iznos := false;
  if (NomenMem.Active) then
  begin
    znak := 0;
    znakVosst := 1;
    if (kartType = 'RASX') or (kartType = 'IZNOS') then    // ���� ��������� ������� � �����
    begin
      znak := -1;               // ����� ���� ��� -
      if (kartType = 'IZNOS') then
      begin
        iznos := true;
        kartType := 'RASX';
      end;
    end;
    if (kartType = 'PRIX') then    // ���� ��������� ������� � �����
      znak := 1;              // ����� ���� ��� � +
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
      if ((NomenMem.FieldByName('KOL').AsFloat + znak * kol >= 0)
         or (iznos)) or (kartType = 'PRIX') then     // ���� ���������� ���������� �� ��������
      begin
        NomenMem.Edit;
        NomenMem.FieldByName('KOL').AsFloat := StrToFloat(NomenMem.FieldByName('KOL').AsString)
                                               + StrToFloat(FloatToStr(znak * kol));
        NomenMem.FieldByName('SUM').AsFloat := NomenMem.FieldByName('SUM').AsFloat        // ������� �����
                                               + znak * summa;
        NomenMem.FieldByName('SUMD').AsFloat := NomenMem.FieldByName('SUMD').AsFloat        // ����� � ���
                                                + znak * sumSNds;

        NomenMem.FieldByName(kartType + 'ODM').AsFloat := NomenMem.FieldByName(kartType + 'ODM').AsFloat  // ���-�� ��������/�������� PRIXODM/RASXODM �� �����
                                                          + kol * znakVosst;
        NomenMem.FieldByName('S' + kartType + 'M').AsFloat := NomenMem.FieldByName('S' + kartType + 'M').AsFloat    // ����� �������� �� �����
                                                              + summa * znakVosst;
        NomenMem.FieldByName('S' + kartType + 'MD').AsFloat := NomenMem.FieldByName('S' + kartType + 'MD').AsFloat    // ����� �������� � ���
                                                               + sumSNds * znakVosst;

        if (NomenMem.FieldByName('KOL').AsFloat <> 0) then
        begin
          NomenMem.FieldByName('MONEY').AsFloat := dm.NomenMem.FieldByName('SUM').AsFloat         // ���������������� ����
                                                   / dm.NomenMem.FieldByName('KOL').AsFloat;
          NomenMem.FieldByName('CENAD').AsFloat := dm.NomenMem.FieldByName('SUMD').AsFloat         // ���������������� ���� � ���
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
                             ConfigUMCSTRUK_ID.AsString, buxName, FloatToStr(summa));
      end;
    except
      on e : exception do
      begin
        ShowMessage('������: ' + e.message + 'numksu: ' + NomenMem.FieldByName('NUMKSU').AsString
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
  PrihDbf.Close;
  PrihDbf.Exclusive := exclusive;
  PrihDbf.TableName := AnsiLowerCase(localPath) + '\prixod.dbf';
  PrihDbf.Open;
  if (stkod <> '') then
  begin
    PrihDbf.Filtered := false;
    PrihDbf.Filter := 'SKLAD = ' + stkod;
    PrihDbf.Filtered := true;
  end;
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

procedure TDM.openPrihDbfQuery(localPath, stkodRela, strukId, stkod : string);
begin
  Prih.Close;
  Prih.EhSQL.Text := 'select * from "' + AnsiLowerCase(localPath) + 'prixod.dbf" prixod ';
  if (stkodRela = '1600') or (stkodRela = '4300') then
    Prih.EhSQL.Text := Prih.EhSQL.Text + 'where prixod.doc_id <> 0 and prixod.sklad = "' + stkod + '" '
  else
    Prih.EhSQL.Text := Prih.EhSQL.Text + 'where prixod.doc_id <> 0 and prixod.sklad = "' + stkodRela + '" ';
  if (stkodRela <> stkod) or (stkod = '1600') or (stkod = '4300') then
  	Prih.EhSQL.Text := Prih.EhSQL.Text + ' and prixod.struk_id = "' + strukId + '" ';
  UpdPrih.InsertSQL.Text := 'insert into "' + AnsiLowerCase(localPath) + 'prixod.dbf" '
                            + '(BALS, NUMKCU, NAMEPR, MEI, EIZ, OPER, DATETR, NUMDOK, '
                            + 'NSD, DATSD, KP, POST, KOL, KOLOTG, "' + AnsiLowerCase(localPath)
                            + 'prixod.dbf"."MONEY", "' + AnsiLowerCase(localPath)
                            + 'prixod.dbf"."SUM", KPZ, REGNSF, KOLNEDN, KOLNEDS, '
                            + 'KOLMATPUT, SUMNEDN, SUMNEDS, SUMMATP, SKLAD, DEBDOP, '
                            + 'KRDOP, PRIZVX, PRIZN, KREG, NP, KORR, SUMD, '
                            + 'DOC_ID, STRUK_ID, PRIXOD_ID) values '
                            + '(:BALS, :NUMKCU, :NAMEPR, :MEI, :EIZ, :OPER, :DATETR, '
                            + ':NUMDOK, :NSD, :DATSD, :KP, :POST, :KOL, :KOLOTG, '
                            + ':MONEY, :SUM, :KPZ, :REGNSF, :KOLNEDN, :KOLNEDS, '
                            + ':KOLMATPUT, :SUMNEDN, :SUMNEDS, :SUMMATP, :SKLAD, '
                            + ':DEBDOP, :KRDOP, :PRIZVX, :PRIZN, :KREG, :NP, :KORR, '
                            + ':SUMD, :DOC_ID, :STRUK_ID, :PRIXOD_ID) ';
  UpdPrih.DeleteSQL.Text := 'delete from "' + AnsiLowerCase(localPath) + 'prixod.dbf" '
                            + 'where PRIXOD_ID = :OLD_PRIXOD_ID ';
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
                            + 'KORR = :KORR, SUMD = :SUMD,  '
                            + 'DOC_ID = :DOC_ID, STRUK_ID = :STRUK_ID where PRIXOD_ID = :OLD_PRIXOD_ID ';
  Prih.Open;
  log^.appendMsg('������� ������ �� �������� PRIXOD.dbf: ' + IntToStr(Prih.RecordCount));
end;

procedure TDM.activateRashDbf(localPath, stkod : string; exclusive : boolean);
begin
  RashDbf.Close;
  RashDbf.Exclusive := exclusive;
  RashDbf.DatabaseName := '';
  RashDbf.TableName := AnsiLowerCase(localPath) + 'rasxod.dbf';
  RashDbf.Open;
  if (stkod <> '') then
  begin
    RashDbf.Filtered := false;
    RashDbf.Filter := 'SKLAD = ' + stkod;
    RashDbf.Filtered := true;
  end;
  RashDbf.Last;
end;

procedure TDM.activateRashInd(localPath : string);
begin
  RashInd.Close;
  RashInd.Exclusive := false;
  RashInd.DatabaseName := '';
  RashInd.TableName := AnsiLowerCase(localPath) + 'rasxod.dbf';
  RashInd.Open;
  RashInd.Last;
end;

procedure TDM.openRashDbfQuery(localPath, stkodRela, strukId, stkod : string; iznos : boolean);
begin
  Rash.Close;
  if (iznos) then
    Rash.EhSQL.Text := 'select * from "' + AnsiLowerCase(localPath) + 'rasxod.dbf" rasxod '
                       + 'where rasxod.doc_id = -3 '
  else
  begin
    if (buxName = specBm) then
    begin
      if (stkodRela = '1600') or (stkodRela = '4300') then
        Rash.EhSQL.Text := 'select * from "' + AnsiLowerCase(localPath) + 'rasxod.dbf" rasxod '
                       + 'where rasxod.doc_id > 0 and rasxod.sklad = "' + stkod + '" '
      else
        Rash.EhSQL.Text := 'select * from "' + AnsiLowerCase(localPath) + 'rasxod.dbf" rasxod '
                       + 'where rasxod.doc_id > 0 and rasxod.sklad = "' + stkodRela + '" ';
    end
    else
      Rash.EhSQL.Text := 'select * from "' + AnsiLowerCase(localPath) + 'rasxod.dbf" rasxod '
                         + 'where rasxod.doc_id > 0 and rasxod.sklad = "' + stkodRela + '" ';
  end;
  if (stkodRela <> stkod) or (stkod = '1600') or (stkod = '4300') then
  	Rash.EhSQL.Text := Rash.EhSQL.Text + ' and rasxod.struk_id = "' + strukId + '" ';
  UpdRash.InsertSQL.Text := 'insert into "' + AnsiLowerCase(localPath) + 'rasxod.dbf" '
                            + '(DEBET, BALS, NUMKCU, NAMEPR, KEI, EIZ, OPER, DATETR, '
                            + 'NUMDOK, CEX, POST, MOL, KOL, "' + AnsiLowerCase(localPath)
                            + 'rasxod.dbf"."MONEY", "' + AnsiLowerCase(localPath)
                            + 'rasxod.dbf"."SUM", KPZ, SKLAD, NACEN, DT1, KT1, SUM1, DT2, '
                            + 'KT2, PRIZN, PRIZNVX, OTK, KT, NMASH, NP, KORR, SUMD, DOC_ID, STRUK_ID, RASXOD_ID) '
                            + 'values (:DEBET, :BALS, :NUMKCU, :NAMEPR, :KEI, :EIZ, '
                            + ':OPER, :DATETR, :NUMDOK, :CEX, :POST, :MOL, :KOL, '
                            + ':MONEY, :SUM, :KPZ, :SKLAD, :NACEN, :DT1, :KT1, :SUM1, '
                            + ':DT2, :KT2, :PRIZN, :PRIZNVX, :OTK, :KT, :NMASH, :NP, '
                            + ':KORR, :SUMD, :DOC_ID, :STRUK_ID, :RASXOD_ID) ';
  UpdRash.DeleteSQL.Text := 'delete from "' + AnsiLowerCase(localPath) + 'rasxod.dbf" '
                            + 'where RASXOD_ID = :OLD_RASXOD_ID ';
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
                            + 'SUMD = :SUMD, DOC_ID = :DOC_ID, STRUK_ID = :STRUK_ID, RASXOD_ID = :RASXOD_ID where '
                            + 'RASXOD_ID = :OLD_RASXOD_ID ';
  Rash.Open;
  log^.appendMsg('������� ������ �� �������� RASXOD.dbf: ' + IntToStr(Rash.RecordCount));
end;

procedure TDM.activateNomenDbf(localPath, stkod : string; exclusive : boolean; iznos : boolean);
begin
  Nomen.Close;
  Nomen.Exclusive := exclusive;
  Nomen.DatabaseName := '';
  Nomen.TableName := AnsiLowerCase(localPath) + '\nomen.dbf';
  Nomen.Open;
  if (not iznos) then
  begin
    Nomen.Filtered := false;
    Nomen.Filter := 'SKLAD = ' + stkod;
    Nomen.Filtered := true;
  end;
  Nomen.Last;
  fillNomenMem();
  log^.appendMsg('������� ������ �� ��������� NOMEN.dbf.');
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
var
  StrLangDriver : TStringList;
begin
  WorkSession.NetFileDir := 'C:\WORK';
  WorkSession.PrivateDir := 'C:\WORK';
  StrLangDriver := TStringList.Create;
  StrLangDriver.Add('LANGDRIVER=db866ru0');
  StrLangDriver.Add('LEVEL=4');
  WorkSession.ModifyDriver('DBASE', StrLangDriver);
  StrLangDriver.Free;
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
  log^.appendMsg('������� ������ �� �������� �� IB kartPrihQuery: ' + IntToStr(KartPrihQuery.RecordCount));
end;

procedure TDM.activateKartRashQuery(curMonth : integer; curYear : integer);
begin
  dm.KartRashQuery.Close;
  dm.KartRashQuery.ParamByName('struk_id').AsInteger := dm.ConfigUMCSTRUK_ID.AsInteger;
  dm.KartRashQuery.ParamByName('mes').AsInteger := curMonth;
  dm.KartRashQuery.ParamByName('god').AsInteger := curYear;
  if (not vxControl) then
    setKartRashQueryUsl;
  dm.KartRashQuery.Open;
  dm.KartRashQuery.FetchAll;
  log^.appendMsg('������� ������ �� �������� �� IB kartRashQuery: ' + IntToStr(KartRashQuery.RecordCount));
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
    NomenMem.LoadFromDataSet(Nomen, [mtcpoAppend]);
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
    log^.appendMsg('������� ������ ������� �� PRIXOD.dbf.');
  end;
end;

procedure TDM.clearRash;
begin
  if (Rash.Active) and (Rash.RecordCount > 0) then
  begin
    Rash.First;
    while (not Rash.Eof) do
      Rash.Delete;
    log^.appendMsg('������� ������ ������� �� RASXOD.dbf.');
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
    log^.appendMsg('��������� ������� ������������� ��������.');
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
  log^.appendMsg('�������� ������� ������������� ��������.');
end;

procedure TDM.DataModuleCreate(Sender: TObject);
var
  userName3Char : string;
begin
  userName := GetCurrentUserNameWindows;
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
      ShowMessage('� ������������ ' + UserName + ' ��� ������� � ���� ������');
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
  vxControl := setVxContr;
  if (setVxContr) then
    KartRashQuery.MacroByName('usl').AsString := 'document.tip_op_id = 135 '
                                                 + 'and document.tip_dok_id = 125 '
  else
    setKartRashQueryUsl;
end;

procedure TDM.setKartRashQueryUsl;
begin
  KartRashQuery.Close;
  if (buxName = specBm) then
    KartRashQuery.MacroByName('usl').AsString := '(document.tip_dok_id in (173, 198) '
                                                 + ' or (document.tip_op_id = 8 '
                                                 + ' and document.tip_dok_id in (5, 183)'
                                                 + ' and ostatki.account in (''10/10'', ''10/11''))) '
  else
    KartRashQuery.MacroByName('usl').AsString := 'tip_oper.gr_op_id = 2 and tip_oper.tip_op_id <> 135 '
                                                 + ' and tip_oper.tip_op_id <> 153 '
                                                 + ' and tip_oper.tip_op_id <> 30 '
                                                 + ' and document.tip_dok_id <> 198 '
                                                 + ' and document.tip_dok_id <> 173 '
                                                 + ' and (ostatki.account <> ''10/10'' '
                                                 + ' and ostatki.account <> ''10/11'') ';
end;

procedure TDM.setSpecOdezh(setSpecOdezh : boolean);
begin
  KartPrihQuery.Close;
  if (setSpecOdezh) then
  begin
    KartPrihQuery.MacroByName('usl').AsString := ' (tip_oper.gr_op_id = 1 and '
                                                 + ' document.tip_dok_id <> 187 '
                                                 + ' and confPost.stkod like ''70%'''
                                                 + ' or (tip_oper.tip_op_id = 153 '
                                                 + ' and tipdok.tip_dok_id = 173)) '
                                                 + ' and (ostatki.account = ''10/10'' '
                                                 + ' or ostatki.account = ''10/11'') ';
    KartPrihQuery.MacroByName('usl_doc').AsString := ' docosn.priz_id > 1 ';
  end
  else
    KartPrihQuery.MacroByName('usl').AsString := ' tip_oper.gr_op_id = 1 '
                                                 + 'and document.tip_op_id = 6 '
                                                 + 'and document.tip_dok_id = 195 ';
end;

procedure TDM.setPrixodId;
var
  curId : integer;
begin
  curId := 0;
  PrihDbf.First;
  while (not PrihDbf.Eof) do
  begin
    Inc(curId);
    PrihDbf.Edit;
    PrihDbf.FieldByName('PRIXOD_ID').AsInteger := curId;
    PrihDbf.Post;
    PrihDbf.Next;
  end;
  maxPrId := curId;
  PrihDbf.ApplyUpdates;
  PrihDbf.CommitUpdates;
end;

procedure TDM.setRasxodId;
var
  curId : integer;
begin
  curId := 0;
  RashInd.First;
  while (not RashInd.Eof) do
  begin
    Inc(curId);
    RashInd.Edit;
    RashInd.FieldByName('RASXOD_ID').AsInteger := curId;
    RashInd.Post;
    RashInd.Next;
  end;
  log.appendMsg('�������������� Rash.dbf ���������');
  maxRId := curId;
  RashInd.ApplyUpdates;
  RashInd.CommitUpdates;
  log.appendMsg('��������� Rash.dbf');
end;

procedure TDM.openIznos(month, year, strukId : integer);
begin
  q_iznos.Close;
  q_iznos.ParamByName('mes').AsInteger := month;
  q_iznos.ParamByName('god').AsInteger := year;
//  q_iznos.ParamByName('struk_id').AsInteger := strukId;
  q_iznos.Open;
end;

end.
