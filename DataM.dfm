object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 868
  Width = 1101
  object Belmed: TIBDatabase
    Connected = True
    DatabaseName = '192.168.13.13:D:\IBData\Belmed.gdb'
    Params.Strings = (
      'user_name=IGOR'
      'password=igor'
      'sql_role_name=SKLAD_TMC'
      'lc_ctype=WIN1251')
    LoginPrompt = False
    DefaultTransaction = RTrans
    ServerType = 'IBServer'
    Left = 32
    Top = 8
  end
  object RTrans: TIBTransaction
    Active = True
    DefaultDatabase = Belmed
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 32
    Top = 56
  end
  object KartPrihQuery: TRxIBQuery
    Database = Belmed
    Transaction = RTrans
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'select document.doc_id, iif(relaStr.stkod is not null, relaStr.s' +
        'tkod, configumc.stkod) sklad,'
      'padleft(TRIM(cast(kart.ksm_id as char(5))),7,'#39'0'#39') numksu,'
      
        'matrop.nmat namepr, matrop.nmats nameprs, matrop.xarkt, matrop.g' +
        'ost,'
      'cast(iif(document.tip_op_id = 6, '#39'9'#39', '#39'1'#39') as char(2)) oper,'
      'document.date_op datetr,'
      'iif(document.tip_dok_id = 195,'
      '    confPost.stkod,'
      '    substring(trim(document.ndok) from 1 for 5)) numndok, '
      'substring(trim(docosn.ndok) from 1 for 10) nsd,'
      'docosn.date_dok datsd,'
      'cast(iif(document.tip_op_id = 1, '
      '            document.klient_id, '
      '            iif(document.tip_dok_id = 195,'
      '                confPost.stkod,'
      '                struk.stkod)) as char(5)) kp,'
      'kart.kol_prih kol, kart.kol_prih kolotg,'
      
        'iif(document.struk_id < 0, cast(kart.kei_id2  as char(4)), cast(' +
        'matrop.kei_id as char(4))) mei,'
      'ediz.neis eiz,'
      'iif(document.tip_op_id = 1, '
      '    substring(sprorg.nam from 1 for 35), '
      '    iif(document.tip_dok_id = 195,'
      '        confPost.stkod,'
      '        struk.stname)) post,'
      
        'substring(kart.stroka_id from char_length(kart.stroka_id)-3 for ' +
        'char_length(kart.stroka_id)) np, '
      
        'coalesce(kart.cena, 0) money,  kart.sum_nds, cast(kart.summa as ' +
        'numeric(15,6)) as summa,'
      'kart.summa_s_nds,'
      
        'document.nds, ostatki.account, tip_oper.nam_op, tipdok.short_nam' +
        'e, tip_oper.tip_op_id,'
      
        'tipdok.tip_dok_id, document.klient_id, struk.stname, struk.stkod' +
        ', confPost.stkod'
      'from document'
      ''
      'inner join kart on document.doc_id = kart.doc_id'
      'inner join matrop on kart.ksm_id = matrop.ksm_id'
      'inner join ediz on matrop.kei_id = ediz.kei_id'
      'left join document docosn on document.dok_osn_id = docosn.doc_id'
      'left join sprorg on document.klient_id = sprorg.kod'
      'left join struk on document.klient_id = struk.struk_id'
      'inner join configumc on document.struk_id = configumc.struk_id'
      'left join ostatki on kart.kart_id = ostatki.kart_id'
      'left join seria on ostatki.seria_id = seria.seria_id'
      
        '--left join document doc_osn on document.dok_osn_id = doc_osn.do' +
        'c_id'
      '--  and doc_osn.tip_op_id = 1 and doc_osn.tip_dok_id = 4'
      'left join tip_oper on tip_oper.tip_op_id = document.tip_op_id '
      '                          and tip_oper.gr_op_id = 1'
      'left join tipdok on tipdok.tip_dok_id = document.tip_dok_id'
      
        'left join struk relaStr on relaStr.struk_id = configumc.rela_str' +
        'uk_id'
      
        'left join configumc confPost on confPost.struk_id = document.kli' +
        'ent_id'
      ''
      'where kart.kol_prih <> 0 and matrop.account <> '#39'01'#39
      'and document.struk_id = :struk_id '
      'and document.priz_id > 1'
      'and extract(month from document.date_op) = :mes'
      'and extract(year from document.date_op) = :god'
      ' and document.tip_op_id = 6'
      'and document.tip_dok_id = 195')
    Macros = <>
    Left = 128
    Top = 8
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'struk_id'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'mes'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'god'
        ParamType = ptUnknown
      end>
    object KartPrihQueryNUMKSU: TIBStringField
      FieldName = 'NUMKSU'
      ProviderFlags = []
      Size = 256
    end
    object KartPrihQueryNAMEPR: TIBStringField
      FieldName = 'NAMEPR'
      Origin = '"MATROP"."NMAT"'
      Size = 60
    end
    object KartPrihQueryOPER: TIBStringField
      FieldName = 'OPER'
      ProviderFlags = []
      FixedChar = True
      Size = 2
    end
    object KartPrihQueryDATETR: TDateField
      FieldName = 'DATETR'
      Origin = '"DOCUMENT"."DATE_OP"'
    end
    object KartPrihQueryNUMNDOK: TIBStringField
      FieldName = 'NUMNDOK'
      ProviderFlags = []
    end
    object KartPrihQueryNSD: TIBStringField
      FieldName = 'NSD'
      ProviderFlags = []
    end
    object KartPrihQueryKP: TIBStringField
      FieldName = 'KP'
      ProviderFlags = []
      FixedChar = True
      Size = 5
    end
    object KartPrihQueryKOL: TFMTBCDField
      FieldName = 'KOL'
      Origin = '"KART"."KOL_PRIH"'
      Precision = 18
      Size = 6
    end
    object KartPrihQueryKOLOTG: TFMTBCDField
      FieldName = 'KOLOTG'
      Origin = '"KART"."KOL_PRIH"'
      Precision = 18
      Size = 6
    end
    object KartPrihQueryPOST: TIBStringField
      FieldName = 'POST'
      ProviderFlags = []
      Size = 100
    end
    object KartPrihQueryMONEY: TIBBCDField
      FieldName = 'MONEY'
      Origin = '"KART"."CENA"'
      Precision = 18
      Size = 4
    end
    object KartPrihQuerySUM_NDS: TIBBCDField
      FieldName = 'SUM_NDS'
      Origin = '"KART"."SUM_NDS"'
      Precision = 18
      Size = 2
    end
    object KartPrihQueryNDS: TIBBCDField
      FieldName = 'NDS'
      Origin = '"DOCUMENT"."NDS"'
      Precision = 9
      Size = 2
    end
    object KartPrihQueryACCOUNT: TIBStringField
      FieldName = 'ACCOUNT'
      Origin = '"OSTATKI"."ACCOUNT"'
      FixedChar = True
      Size = 5
    end
    object KartPrihQueryMEI: TIBStringField
      FieldName = 'MEI'
      ProviderFlags = []
      FixedChar = True
      Size = 4
    end
    object KartPrihQueryEIZ: TIBStringField
      FieldName = 'EIZ'
      Origin = '"EDIZ"."NEIS"'
      FixedChar = True
      Size = 10
    end
    object KartPrihQueryNAM_OP: TIBStringField
      FieldName = 'NAM_OP'
      Origin = '"TIP_OPER"."NAM_OP"'
      Size = 50
    end
    object KartPrihQueryDATSD: TDateField
      FieldName = 'DATSD'
      Origin = '"DOCUMENT"."DATE_DOK"'
    end
    object KartPrihQuerySUMMA_S_NDS: TIBBCDField
      FieldName = 'SUMMA_S_NDS'
      Origin = '"KART"."SUMMA_S_NDS"'
      Precision = 18
      Size = 2
    end
    object KartPrihQueryNAMEPRS: TIBStringField
      FieldName = 'NAMEPRS'
      Origin = '"MATROP"."NMATS"'
      FixedChar = True
      Size = 25
    end
    object KartPrihQueryXARKT: TIBStringField
      FieldName = 'XARKT'
      Origin = '"MATROP"."XARKT"'
      Size = 30
    end
    object KartPrihQueryGOST: TIBStringField
      FieldName = 'GOST'
      Origin = '"MATROP"."GOST"'
      Size = 60
    end
    object KartPrihQuerySKLAD: TIBStringField
      FieldName = 'SKLAD'
      ProviderFlags = []
      FixedChar = True
      Size = 4
    end
    object KartPrihQueryDOC_ID: TIntegerField
      FieldName = 'DOC_ID'
      Origin = '"DOCUMENT"."DOC_ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object KartPrihQuerySHORT_NAME: TIBStringField
      FieldName = 'SHORT_NAME'
      Origin = '"TIPDOK"."SHORT_NAME"'
      FixedChar = True
      Size = 10
    end
    object KartPrihQueryTIP_OP_ID: TSmallintField
      FieldName = 'TIP_OP_ID'
      Origin = '"TIP_OPER"."TIP_OP_ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object KartPrihQueryTIP_DOK_ID: TSmallintField
      FieldName = 'TIP_DOK_ID'
      Origin = '"TIPDOK"."TIP_DOK_ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object KartPrihQueryNP: TIBStringField
      FieldName = 'NP'
      ProviderFlags = []
      Size = 11
    end
    object KartPrihQuerySUMMA: TFMTBCDField
      FieldName = 'SUMMA'
      ProviderFlags = []
      Precision = 18
      Size = 6
    end
    object KartPrihQueryKLIENT_ID: TIntegerField
      FieldName = 'KLIENT_ID'
      Origin = '"DOCUMENT"."KLIENT_ID"'
      Required = True
    end
    object KartPrihQuerySTNAME: TIBStringField
      FieldName = 'STNAME'
      Origin = '"STRUK"."STNAME"'
      FixedChar = True
    end
    object KartPrihQuerySTKOD: TIBStringField
      FieldName = 'STKOD'
      Origin = '"STRUK"."STKOD"'
      FixedChar = True
      Size = 4
    end
    object KartPrihQuerySTKOD1: TIBStringField
      FieldName = 'STKOD1'
      Origin = '"CONFIGUMC"."STKOD"'
      FixedChar = True
      Size = 4
    end
  end
  object DSKartIncomes: TDataSource
    DataSet = KartPrihQuery
    Left = 128
    Top = 56
  end
  object ConfigUMC: TRxIBQuery
    Database = Belmed
    Transaction = RTrans
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'SELECT rtrim(configumc.stkod) || '#39'   -   '#39' || configumc.stname a' +
        's stname, '
      'configumc.struk_id, configumc.stkod, configumc.oborot_bux, '
      'iif(conf.stkod <> '#39#39', conf.stkod, configumc.stkod) stkodrela'
      'FROM configumc'
      
        'left join configumc conf on conf.struk_id = configumc.rela_struk' +
        '_id'
      'WHERE configumc.oborot_bux = 1'
      'Order by configumc.STKOD')
    Macros = <>
    Left = 224
    Top = 8
    object ConfigUMCSTRUK_ID: TSmallintField
      FieldName = 'STRUK_ID'
      Origin = '"CONFIGUMC"."STRUK_ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ConfigUMCSTKOD: TIBStringField
      FieldName = 'STKOD'
      Origin = '"CONFIGUMC"."STKOD"'
      FixedChar = True
      Size = 4
    end
    object ConfigUMCOBOROT_BUX: TSmallintField
      FieldName = 'OBOROT_BUX'
      Origin = '"CONFIGUMC"."OBOROT_BUX"'
    end
    object ConfigUMCSTNAME: TIBStringField
      FieldName = 'STNAME'
      ProviderFlags = []
      Size = 265
    end
    object ConfigUMCSTKODRELA: TIBStringField
      FieldName = 'STKODRELA'
      ProviderFlags = []
      FixedChar = True
      Size = 4
    end
  end
  object DSConfigUMC: TDataSource
    DataSet = ConfigUMC
    Left = 224
    Top = 56
  end
  object DSPrixDbf: TDataSource
    DataSet = PrihDbf
    Left = 192
    Top = 368
  end
  object PrihDbf: TTable
    CachedUpdates = True
    SessionName = 'WorkSession'
    TableName = 'f:\bm444\zerno1\PRIXOD.DBF'
    Left = 192
    Top = 216
  end
  object RashDbf: TTable
    CachedUpdates = True
    SessionName = 'WorkSession'
    TableName = 'f:\bm444\zerno1\RASXOD.DBF'
    Left = 256
    Top = 216
  end
  object DSRashDbf: TDataSource
    DataSet = RashDbf
    Left = 128
    Top = 360
  end
  object KartRashQuery: TRxIBQuery
    Database = Belmed
    Transaction = RTrans
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'select iif(relaStr.stkod is not null, relaStr.stkod, configumc.s' +
        'tkod) sklad,'
      'padleft(TRIM(cast(kart.ksm_id as char(5))), 7, '#39'0'#39') numksu,'
      
        'matrop.nmat namepr, matrop.nmats nameprs, matrop.xarkt, matrop.g' +
        'ost,'
      'cast(iif(document.tip_op_id in (85, 112, 113, 32, 103, 104),'
      '         '#39'p'#39','
      '         iif(document.tip_op_id = 131,'
      '             '#39'2'#39','
      
        '             iif(document.tip_op_id in (8, 9, 110, 140, 11, 147,' +
        ' 78, 10, 105, 93, 135),'
      '                 '#39'9'#39','
      '                 '#39'1'#39'))) as char(2)) oper,'
      'document.date_op datetr,'
      'substring(trim(document.ndok) from 1 for 5)  numndok,'
      
        'cast(iif(document.tip_op_id = 1, document.klient_id, struk.stkod' +
        ') as char(5)) kp,'
      'kart.kol_rash kol,'
      'kart.kol_rash kolotg,'
      
        'iif(document.struk_id < 0,cast(kart.kei_id2 as char(4)), cast(ma' +
        'trop.kei_id as char(4))) eiz,'
      'ediz.neis mei,'
      'iif(document.tip_op_id in (32, 103, 104, 112, 113), '
      '    '#39#39',  '
      '    struk.stkod) cex,'
      'iif(document.struk_id in (163, 87),'
      '    struk.stkod,'
      '    iif(document.tip_op_id in (32, 103, 104, 112, 113),'
      
        '        iif(configumc.struk_id in (542, 543, 544, 545, 546, 708,' +
        ' -540), '
      '            '#39'1600'#39', '
      '            configumc.stkod), '
      '        struk.stname)) post,'
      'kart.cena money,'
      'iif(document.tip_op_id in (32, 103, 104, 112, 113),'
      '    iif(coalesce(kart.sum_nds,0) = 0, '
      '        kart.summa, '
      '        kart.sum_nds),'
      '    iif(coalesce(kart.sum_nds,0) = 0, '
      '        kart.summa, '
      '        kart.sum_nds)) sum_nds,'
      'kart.summa,'
      'document.nds,'
      'ostatki.account,'
      
        'cast(iif((kart.dcode is null)  or (kart.dcode = 1) or (char_leng' +
        'th(rtrim(ltrim(kart.debet))) > 3'
      
        '                                                       and subst' +
        'ring(rtrim(ltrim(kart.debet))'
      
        '                                                                ' +
        '     from iif(char_length(rtrim(ltrim(kart.debet)))>0,'
      
        '                                                                ' +
        '                char_length(rtrim(ltrim(kart.debet))),'
      
        '                                                                ' +
        '                1)'
      
        '                                                                ' +
        '     for  1) <> '#39'/'#39') ,'
      '            rtrim(ltrim(kart.debet)),'
      
        '            iif(substring(rtrim(ltrim(kart.debet)) from iif(char' +
        '_length(rtrim(ltrim(kart.debet)))>0,'
      
        '                                                              ch' +
        'ar_length(rtrim(ltrim(kart.debet))),'
      
        '                                                              1)' +
        ' for  1) <> '#39'/'#39','
      '                 iif(char_length(rtrim(ltrim(kart.debet)))>0,'
      '                       rtrim(ltrim(kart.debet)),'
      '                       '#39'25'#39') || '#39'/'#39' || rtrim(ltrim(kart.dcode)),'
      
        '                 rtrim(ltrim(kart.debet)) || rtrim(ltrim(kart.dc' +
        'ode))'
      '                )'
      '         )'
      '     as varchar(5)) as debet,'
      
        'substring(kart.stroka_id from char_length(kart.stroka_id)-3 for ' +
        'char_length(kart.stroka_id)) np,'
      
        'tip_oper.nam_op, tip_oper.tip_op_id, document.priz_id, document.' +
        'doc_id, document.struk_id,'
      'document.klient_id'
      ''
      'from document'
      ''
      'inner join kart on document.doc_id = kart.doc_id'
      
        '                --and document.tip_op_id in (8, 10, 32, 131, 135' +
        ', 147, 103, 104, 112, 113)'
      'inner join matrop on kart.ksm_id = matrop.ksm_id'
      'inner join ediz on matrop.kei_id = ediz.kei_id'
      'left join sprorg on document.klient_id = sprorg.kod'
      'left join struk on document.klient_id = struk.struk_id'
      'inner join configumc on document.struk_id = configumc.struk_id'
      'left join ostatki on kart.kart_id = ostatki.kart_id'
      'left join seria on ostatki.seria_id = seria.seria_id'
      'left join tip_oper on tip_oper.tip_op_id = document.tip_op_id'
      
        'left join struk relaStr on relaStr.struk_id = configumc.rela_str' +
        'uk_id'
      ''
      'where kart.kol_rash <> 0 and matrop.account <> '#39'01'#39
      'and document.struk_id = :struk_id'
      'and document.priz_id > 1'
      'and extract(month from document.date_op) = :mes'
      'and extract(year from document.date_op) = :god'
      'and document.tip_op_id <> 93'
      'and %usl')
    Macros = <
      item
        DataType = ftString
        Name = 'usl'
        ParamType = ptInput
        Value = '0=0'
      end>
    Left = 320
    Top = 8
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'struk_id'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'mes'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'god'
        ParamType = ptUnknown
      end>
    object KartRashQuerySKLAD: TIBStringField
      FieldName = 'SKLAD'
      ProviderFlags = []
      FixedChar = True
      Size = 4
    end
    object KartRashQueryNUMKSU: TIBStringField
      FieldName = 'NUMKSU'
      ProviderFlags = []
      Size = 256
    end
    object KartRashQueryNAMEPR: TIBStringField
      FieldName = 'NAMEPR'
      Origin = '"MATROP"."NMAT"'
      Size = 60
    end
    object KartRashQueryNAMEPRS: TIBStringField
      FieldName = 'NAMEPRS'
      Origin = '"MATROP"."NMATS"'
      FixedChar = True
      Size = 25
    end
    object KartRashQueryXARKT: TIBStringField
      FieldName = 'XARKT'
      Origin = '"MATROP"."XARKT"'
      Size = 30
    end
    object KartRashQueryGOST: TIBStringField
      FieldName = 'GOST'
      Origin = '"MATROP"."GOST"'
      Size = 60
    end
    object KartRashQueryOPER: TIBStringField
      FieldName = 'OPER'
      ProviderFlags = []
      FixedChar = True
      Size = 2
    end
    object KartRashQueryDATETR: TDateField
      FieldName = 'DATETR'
      Origin = '"DOCUMENT"."DATE_OP"'
    end
    object KartRashQueryNUMNDOK: TIBStringField
      FieldName = 'NUMNDOK'
      ProviderFlags = []
    end
    object KartRashQueryKP: TIBStringField
      FieldName = 'KP'
      ProviderFlags = []
      FixedChar = True
      Size = 5
    end
    object KartRashQueryKOL: TFMTBCDField
      FieldName = 'KOL'
      Origin = '"KART"."KOL_RASH"'
      Precision = 18
      Size = 6
    end
    object KartRashQueryKOLOTG: TFMTBCDField
      FieldName = 'KOLOTG'
      Origin = '"KART"."KOL_RASH"'
      Precision = 18
      Size = 6
    end
    object KartRashQueryEIZ: TIBStringField
      FieldName = 'EIZ'
      ProviderFlags = []
      FixedChar = True
      Size = 4
    end
    object KartRashQueryMEI: TIBStringField
      FieldName = 'MEI'
      Origin = '"EDIZ"."NEIS"'
      FixedChar = True
      Size = 10
    end
    object KartRashQueryCEX: TIBStringField
      FieldName = 'CEX'
      ProviderFlags = []
      FixedChar = True
      Size = 4
    end
    object KartRashQueryPOST: TIBStringField
      FieldName = 'POST'
      ProviderFlags = []
      FixedChar = True
    end
    object KartRashQueryMONEY: TIBBCDField
      FieldName = 'MONEY'
      Origin = '"KART"."CENA"'
      Precision = 18
      Size = 4
    end
    object KartRashQuerySUM_NDS: TIBBCDField
      FieldName = 'SUM_NDS'
      ProviderFlags = []
      Precision = 18
      Size = 2
    end
    object KartRashQuerySUMMA: TIBBCDField
      FieldName = 'SUMMA'
      Origin = '"KART"."SUMMA"'
      Precision = 18
      Size = 2
    end
    object KartRashQueryNDS: TIBBCDField
      FieldName = 'NDS'
      Origin = '"DOCUMENT"."NDS"'
      Precision = 9
      Size = 2
    end
    object KartRashQueryACCOUNT: TIBStringField
      FieldName = 'ACCOUNT'
      Origin = '"OSTATKI"."ACCOUNT"'
      FixedChar = True
      Size = 5
    end
    object KartRashQueryDEBET: TIBStringField
      FieldName = 'DEBET'
      ProviderFlags = []
      Size = 5
    end
    object KartRashQueryNP: TIBStringField
      FieldName = 'NP'
      ProviderFlags = []
      Size = 11
    end
    object KartRashQueryNAM_OP: TIBStringField
      FieldName = 'NAM_OP'
      Origin = '"TIP_OPER"."NAM_OP"'
      Size = 50
    end
    object KartRashQueryTIP_OP_ID: TSmallintField
      FieldName = 'TIP_OP_ID'
      Origin = '"TIP_OPER"."TIP_OP_ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object KartRashQueryPRIZ_ID: TSmallintField
      FieldName = 'PRIZ_ID'
      Origin = '"DOCUMENT"."PRIZ_ID"'
      Required = True
    end
    object KartRashQueryDOC_ID: TIntegerField
      FieldName = 'DOC_ID'
      Origin = '"DOCUMENT"."DOC_ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object KartRashQuerySTRUK_ID: TSmallintField
      FieldName = 'STRUK_ID'
      Origin = '"DOCUMENT"."STRUK_ID"'
      Required = True
    end
    object KartRashQueryKLIENT_ID: TIntegerField
      FieldName = 'KLIENT_ID'
      Origin = '"DOCUMENT"."KLIENT_ID"'
      Required = True
    end
  end
  object DSKartOutlay: TDataSource
    DataSet = KartRashQuery
    Left = 320
    Top = 56
  end
  object Nomen: TTable
    CachedUpdates = True
    SessionName = 'WorkSession'
    TableName = 'f:\bm444\zerno1\NOMEN.DBF'
    Left = 128
    Top = 216
  end
  object DSNesootvTbl: TDataSource
    DataSet = NesootvTbl
    Left = 552
    Top = 112
  end
  object frxReport1: TfrxReport
    Version = '5.2.3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 41591.709345694440000000
    ReportOptions.LastChange = 41591.723512905090000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 608
    Top = 216
    Datasets = <
      item
        DataSet = frxDBDataset1
        DataSetName = 'frxDBDataset1'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      Orientation = poLandscape
      PaperWidth = 297.000000000000000000
      PaperHeight = 210.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        Height = 22.677180000000000000
        Top = 18.897650000000000000
        Width = 1046.929810000000000000
        object Memo1: TfrxMemoView
          Align = baCenter
          Left = 158.740260000000000000
          Width = 729.449290000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            
              #1053#1077#1076#1086#1073#1072#1074#1083#1077#1085#1085#1099#1077' '#1088#1072#1089#1093#1086#1076#1099' '#1080#1079'-'#1079#1072' '#1085#1077#1076#1086#1089#1090#1072#1090#1086#1095#1085#1086#1075#1086' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1085#1072' '#1082#1072#1088#1090#1086#1095#1082 +
              #1077)
          ParentFont = False
        end
      end
      object Header1: TfrxHeader
        FillType = ftBrush
        Height = 18.897650000000000000
        Top = 102.047310000000000000
        Width = 1046.929810000000000000
        object Memo15: TfrxMemoView
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1057#1082#1083#1072#1076)
          ParentFont = False
        end
        object Memo16: TfrxMemoView
          Left = 68.031540000000010000
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            'NUMKSU')
          ParentFont = False
        end
        object Memo17: TfrxMemoView
          Left = 136.063080000000000000
          Width = 257.008040000000000000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077)
          ParentFont = False
        end
        object Memo18: TfrxMemoView
          Left = 393.071120000000000000
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1044#1072#1090#1072)
          ParentFont = False
        end
        object Memo19: TfrxMemoView
          Left = 461.102660000000000000
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1044#1086#1082'-'#1090)
          ParentFont = False
        end
        object Memo20: TfrxMemoView
          Left = 529.134199999999900000
          Width = 49.133890000000000000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1054#1087#1077#1088'.')
          ParentFont = False
        end
        object Memo21: TfrxMemoView
          Left = 578.268090000000000000
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1050#1086#1083'-'#1074#1086)
          ParentFont = False
        end
        object Memo22: TfrxMemoView
          Left = 714.331170000000000000
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1057#1095#1077#1090)
          ParentFont = False
        end
        object Memo23: TfrxMemoView
          Left = 782.362710000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1044#1077#1073#1077#1090)
          ParentFont = False
        end
        object Memo24: TfrxMemoView
          Left = 842.835190000000000000
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1050#1086#1084#1091)
          ParentFont = False
        end
        object Memo25: TfrxMemoView
          Left = 910.866730000000000000
          Width = 136.063080000000000000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1050#1086#1084#1091' '#1085#1072#1080#1084'-'#1077)
          ParentFont = False
        end
        object Memo26: TfrxMemoView
          Left = 646.299630000000000000
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1045#1076'.'#1080#1079#1084'.')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Height = 18.897650000000000000
        Top = 143.622140000000000000
        Width = 1046.929810000000000000
        DataSet = frxDBDataset1
        DataSetName = 'frxDBDataset1'
        RowCount = 0
        Stretched = True
        object Memo3: TfrxMemoView
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataField = 'SKLAD'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[frxDBDataset1."SKLAD"]')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          Left = 68.031540000000010000
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[frxDBDataset1."NUMKSU"]')
          ParentFont = False
        end
        object Memo5: TfrxMemoView
          Left = 136.063080000000000000
          Width = 257.008040000000000000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataField = 'NAMEPR'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[frxDBDataset1."NAMEPR"]')
          ParentFont = False
        end
        object Memo6: TfrxMemoView
          Left = 393.071120000000000000
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[frxDBDataset1."DATETR"]')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          Left = 461.102660000000000000
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[frxDBDataset1."NUMNDOK"]')
          ParentFont = False
        end
        object Memo8: TfrxMemoView
          Left = 529.134199999999900000
          Width = 49.133890000000000000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataField = 'OPER'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[frxDBDataset1."OPER"]')
          ParentFont = False
        end
        object Memo9: TfrxMemoView
          Left = 578.268090000000000000
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataField = 'KOL'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[frxDBDataset1."KOL"]')
          ParentFont = False
        end
        object Memo10: TfrxMemoView
          Left = 714.331170000000000000
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataField = 'ACCOUNT'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[frxDBDataset1."ACCOUNT"]')
          ParentFont = False
        end
        object Memo11: TfrxMemoView
          Left = 782.362710000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataField = 'DEBET'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[frxDBDataset1."DEBET"]')
          ParentFont = False
        end
        object Memo12: TfrxMemoView
          Left = 842.835190000000000000
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataField = 'CEX'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[frxDBDataset1."CEX"]')
          ParentFont = False
        end
        object Memo13: TfrxMemoView
          Left = 910.866730000000000000
          Width = 136.063080000000000000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataField = 'POST'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[frxDBDataset1."POST"]')
          ParentFont = False
        end
        object Memo14: TfrxMemoView
          Left = 646.299630000000000000
          Width = 68.031540000000010000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DataField = 'MEI'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[frxDBDataset1."MEI"]')
          ParentFont = False
        end
      end
      object PageFooter1: TfrxPageFooter
        FillType = ftBrush
        Height = 22.677180000000000000
        Top = 222.992270000000000000
        Width = 1046.929810000000000000
        object Memo2: TfrxMemoView
          Align = baRight
          Left = 952.441560000000100000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            '[Page#]')
          ParentFont = False
        end
      end
    end
  end
  object frxDBDataset1: TfrxDBDataset
    UserName = 'frxDBDataset1'
    CloseDataSource = False
    FieldAliases.Strings = (
      'DATETR=DATETR'
      'SKLAD=SKLAD'
      'NUMKSU=NUMKSU'
      'NAMEPR=NAMEPR'
      'OPER=OPER'
      'NUMNDOK=NUMNDOK'
      'KOL=KOL'
      'MEI=MEI'
      'CEX=CEX'
      'POST=POST'
      'ACCOUNT=ACCOUNT'
      'DEBET=DEBET')
    DataSet = NesootvTbl
    BCDToCurrency = False
    Left = 608
    Top = 272
  end
  object frxDialogControls1: TfrxDialogControls
    Left = 608
    Top = 320
  end
  object frxXLSExport1: TfrxXLSExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    ExportEMF = True
    AsText = False
    Background = True
    FastExport = True
    PageBreaks = True
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 696
    Top = 272
  end
  object frxXMLExport1: TfrxXMLExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    Background = True
    Creator = 'FastReport'
    EmptyLines = True
    SuppressPageHeadersFooters = False
    RowsCount = 0
    Split = ssNotSplit
    Left = 696
    Top = 320
  end
  object frxPDFExport1: TfrxPDFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Quality = 95
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    Left = 696
    Top = 368
  end
  object NomenOld: TTable
    CachedUpdates = True
    SessionName = 'BlockSession'
    TableName = 'f:\bm444\zerno1\NOMEN.DBF'
    Left = 128
    Top = 160
  end
  object PrihOld: TTable
    CachedUpdates = True
    SessionName = 'BlockSession'
    TableName = 'f:\bm444\zerno1\PRIXOD.DBF'
    Left = 192
    Top = 160
  end
  object RashOld: TTable
    CachedUpdates = True
    SessionName = 'BlockSession'
    TableName = 'f:\bm444\zerno1\RASXOD.DBF'
    Left = 256
    Top = 160
  end
  object NesootvTbl: TRxIBQuery
    Database = Belmed
    Transaction = RTrans
    BufferChunks = 1000
    CachedUpdates = True
    ParamCheck = True
    SQL.Strings = (
      'select *'
      'from k2d_nedobav_rash'
      'where k2d_nedobav_rash.mes = :mes'
      'and k2d_nedobav_rash.god = :god'
      'and k2d_nedobav_rash.machine = :machine'
      'and %struk_id_usl')
    UpdateObject = NesootvTblUpd
    Macros = <
      item
        DataType = ftString
        Name = 'struk_id_usl'
        ParamType = ptInput
        Value = '0=0'
      end>
    Left = 552
    Top = 8
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'mes'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'god'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'machine'
        ParamType = ptUnknown
      end>
    object NesootvTblNEDOBAVRASH_ID: TIntegerField
      FieldName = 'NEDOBAVRASH_ID'
      Origin = '"K2D_NEDOBAV_RASH"."NEDOBAVRASH_ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object NesootvTblSKLAD: TIBStringField
      FieldName = 'SKLAD'
      Origin = '"K2D_NEDOBAV_RASH"."SKLAD"'
      Size = 4
    end
    object NesootvTblACCOUNT: TIBStringField
      FieldName = 'ACCOUNT'
      Origin = '"K2D_NEDOBAV_RASH"."ACCOUNT"'
      Size = 5
    end
    object NesootvTblDEBET: TIBStringField
      FieldName = 'DEBET'
      Origin = '"K2D_NEDOBAV_RASH"."DEBET"'
      Size = 5
    end
    object NesootvTblMES: TSmallintField
      FieldName = 'MES'
      Origin = '"K2D_NEDOBAV_RASH"."MES"'
    end
    object NesootvTblGOD: TIntegerField
      FieldName = 'GOD'
      Origin = '"K2D_NEDOBAV_RASH"."GOD"'
    end
    object NesootvTblSTRUK_ID: TIntegerField
      FieldName = 'STRUK_ID'
      Origin = '"K2D_NEDOBAV_RASH"."STRUK_ID"'
    end
    object NesootvTblNUMKSU: TIBStringField
      FieldName = 'NUMKSU'
      Origin = '"K2D_NEDOBAV_RASH"."NUMKSU"'
      Size = 7
    end
    object NesootvTblNAMEPR: TIBStringField
      FieldName = 'NAMEPR'
      Origin = '"K2D_NEDOBAV_RASH"."NAMEPR"'
      Size = 60
    end
    object NesootvTblOPER: TIBStringField
      FieldName = 'OPER'
      Origin = '"K2D_NEDOBAV_RASH"."OPER"'
      Size = 2
    end
    object NesootvTblDATETR: TDateField
      FieldName = 'DATETR'
      Origin = '"K2D_NEDOBAV_RASH"."DATETR"'
    end
    object NesootvTblNUMNDOK: TIBStringField
      FieldName = 'NUMNDOK'
      Origin = '"K2D_NEDOBAV_RASH"."NUMNDOK"'
    end
    object NesootvTblKOL: TFMTBCDField
      FieldName = 'KOL'
      Origin = '"K2D_NEDOBAV_RASH"."KOL"'
      Precision = 18
      Size = 6
    end
    object NesootvTblMEI: TIBStringField
      FieldName = 'MEI'
      Origin = '"K2D_NEDOBAV_RASH"."MEI"'
      Size = 10
    end
    object NesootvTblCEX: TIBStringField
      FieldName = 'CEX'
      Origin = '"K2D_NEDOBAV_RASH"."CEX"'
      Size = 10
    end
    object NesootvTblPOST: TIBStringField
      FieldName = 'POST'
      Origin = '"K2D_NEDOBAV_RASH"."POST"'
      Size = 50
    end
    object NesootvTblNP: TIntegerField
      FieldName = 'NP'
      Origin = '"K2D_NEDOBAV_RASH"."NP"'
    end
    object NesootvTblMONEY: TFMTBCDField
      FieldName = 'MONEY'
      Origin = '"K2D_NEDOBAV_RASH"."MONEY"'
      Precision = 18
      Size = 6
    end
    object NesootvTblMACHINE: TIBStringField
      FieldName = 'MACHINE'
      Origin = '"K2D_NEDOBAV_RASH"."MACHINE"'
      Size = 5
    end
  end
  object NesootvTblUpd: TIBUpdateSQLW
    RefreshSQL.Strings = (
      'Select '
      '  NEDOBAVRASH_ID,'
      '  SKLAD,'
      '  ACCOUNT,'
      '  DEBET,'
      '  MES,'
      '  GOD,'
      '  STRUK_ID,'
      '  NUMKSU,'
      '  NAMEPR,'
      '  OPER,'
      '  DATETR,'
      '  NUMNDOK,'
      '  KOL,'
      '  MEI,'
      '  CEX,'
      '  POST,'
      '  NP,'
      '  MONEY,'
      '  MACHINE'
      'from k2d_nedobav_rash'
      'where'
      '  NEDOBAVRASH_ID = :NEDOBAVRASH_ID')
    ModifySQL.Strings = (
      'update k2d_nedobav_rash'
      'set'
      '  ACCOUNT = :ACCOUNT,'
      '  CEX = :CEX,'
      '  DATETR = :DATETR,'
      '  DEBET = :DEBET,'
      '  GOD = :GOD,'
      '  KOL = :KOL,'
      '  MACHINE = :MACHINE,'
      '  MEI = :MEI,'
      '  MES = :MES,'
      '  MONEY = :MONEY,'
      '  NAMEPR = :NAMEPR,'
      '  NP = :NP,'
      '  NUMKSU = :NUMKSU,'
      '  NUMNDOK = :NUMNDOK,'
      '  OPER = :OPER,'
      '  POST = :POST,'
      '  SKLAD = :SKLAD,'
      '  STRUK_ID = :STRUK_ID,'
      '  NEDOBAVRASH_ID = :NEDOBAVRASH_ID'
      'where'
      '  NEDOBAVRASH_ID = :OLD_NEDOBAVRASH_ID')
    InsertSQL.Strings = (
      'insert into k2d_nedobav_rash'
      
        '  (NEDOBAVRASH_ID, ACCOUNT, CEX, DATETR, DEBET, GOD, KOL, MACHIN' +
        'E, MEI, MES, MONEY, NAMEPR, '
      '   NP, NUMKSU, NUMNDOK, OPER, POST, SKLAD, STRUK_ID)'
      'values'
      
        '  (:NEDOBAVRASH_ID, :ACCOUNT, :CEX, :DATETR, :DEBET, :GOD, :KOL,' +
        ' :MACHINE, :MEI, :MES, :MONEY, '
      
        '   :NAMEPR, :NP, :NUMKSU, :NUMNDOK, :OPER, :POST, :SKLAD, :STRUK' +
        '_ID)')
    DeleteSQL.Strings = (
      'delete from k2d_nedobav_rash'
      'where'
      '  NEDOBAVRASH_ID = :OLD_NEDOBAVRASH_ID')
    AutoCommit = False
    UpdateTransaction = WTrans
    Left = 552
    Top = 64
  end
  object WTrans: TIBTransaction
    DefaultDatabase = Belmed
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 32
    Top = 112
  end
  object BlockSession: TSession
    SessionName = 'BlockSession'
    Left = 32
    Top = 160
  end
  object Rash: TERxQuery
    CachedUpdates = True
    SessionName = 'WorkSession'
    ParamCheck = False
    SQL.Strings = (
      'select *'
      'from "f:\bm444\zerno1\rasxod.dbf" rasxod'
      'where rasxod.doc_id <> 0')
    UpdateObject = UpdRash
    EhSQL.Strings = (
      'select *'
      'from "f:\bm444\zerno1\rasxod.dbf" rasxod'
      'where rasxod.doc_id <> 0')
    EhMacros = <>
    Left = 128
    Top = 264
    object RashDEBET: TStringField
      FieldName = 'DEBET'
      Size = 8
    end
    object RashBALS: TStringField
      FieldName = 'BALS'
      Size = 5
    end
    object RashNUMKCU: TStringField
      FieldName = 'NUMKCU'
      Size = 7
    end
    object RashNAMEPR: TStringField
      FieldName = 'NAMEPR'
      Size = 30
    end
    object RashKEI: TStringField
      FieldName = 'KEI'
      Size = 4
    end
    object RashEIZ: TStringField
      FieldName = 'EIZ'
      Size = 3
    end
    object RashOPER: TStringField
      FieldName = 'OPER'
      Size = 1
    end
    object RashDATETR: TDateField
      FieldName = 'DATETR'
    end
    object RashNUMDOK: TStringField
      FieldName = 'NUMDOK'
      Size = 6
    end
    object RashCEX: TStringField
      FieldName = 'CEX'
      Size = 4
    end
    object RashPOST: TStringField
      FieldName = 'POST'
      Size = 25
    end
    object RashMOL: TStringField
      FieldName = 'MOL'
      Size = 2
    end
    object RashKOL: TFloatField
      FieldName = 'KOL'
    end
    object RashMONEY: TFloatField
      FieldName = 'MONEY'
    end
    object RashSUM: TFloatField
      FieldName = 'SUM'
    end
    object RashKPZ: TStringField
      FieldName = 'KPZ'
      Size = 8
    end
    object RashSKLAD: TStringField
      FieldName = 'SKLAD'
      Size = 4
    end
    object RashNACEN: TFloatField
      FieldName = 'NACEN'
    end
    object RashDT1: TStringField
      FieldName = 'DT1'
      Size = 4
    end
    object RashKT1: TStringField
      FieldName = 'KT1'
      Size = 4
    end
    object RashSUM1: TFloatField
      FieldName = 'SUM1'
    end
    object RashDT2: TStringField
      FieldName = 'DT2'
      Size = 4
    end
    object RashKT2: TStringField
      FieldName = 'KT2'
      Size = 4
    end
    object RashPRIZN: TStringField
      FieldName = 'PRIZN'
      Size = 1
    end
    object RashPRIZNVX: TStringField
      FieldName = 'PRIZNVX'
      Size = 1
    end
    object RashOTK: TFloatField
      FieldName = 'OTK'
    end
    object RashKT: TStringField
      FieldName = 'KT'
      Size = 1
    end
    object RashNMASH: TStringField
      FieldName = 'NMASH'
      Size = 8
    end
    object RashNP: TFloatField
      FieldName = 'NP'
    end
    object RashKORR: TStringField
      FieldName = 'KORR'
      Size = 1
    end
    object RashSUMD: TFloatField
      FieldName = 'SUMD'
    end
    object RashDOC_ID: TFloatField
      FieldName = 'DOC_ID'
    end
    object RashSTRUK_ID: TSmallintField
      FieldName = 'STRUK_ID'
    end
  end
  object UpdRash: TUpdateSQL
    ModifySQL.Strings = (
      'update "f:\bm444\zerno1\rasxod.dbf"'
      'set'
      '  DEBET = :DEBET,'
      '  BALS = :BALS,'
      '  NUMKCU = :NUMKCU,'
      '  NAMEPR = :NAMEPR,'
      '  KEI = :KEI,'
      '  EIZ = :EIZ,'
      '  OPER = :OPER,'
      '  DATETR = :DATETR,'
      '  NUMDOK = :NUMDOK,'
      '  CEX = :CEX,'
      '  POST = :POST,'
      '  MOL = :MOL,'
      '  KOL = :KOL,'
      '  "f:\bm444\zerno1\rasxod.dbf"."MONEY" = :MONEY,'
      '  "f:\bm444\zerno1\rasxod.dbf"."SUM" = :SUM,'
      '  KPZ = :KPZ,'
      '  SKLAD = :SKLAD,'
      '  NACEN = :NACEN,'
      '  DT1 = :DT1,'
      '  KT1 = :KT1,'
      '  SUM1 = :SUM1,'
      '  DT2 = :DT2,'
      '  KT2 = :KT2,'
      '  PRIZN = :PRIZN,'
      '  PRIZNVX = :PRIZNVX,'
      '  OTK = :OTK,'
      '  KT = :KT,'
      '  NMASH = :NMASH,'
      '  NP = :NP,'
      '  KORR = :KORR,'
      '  SUMD = :SUMD,'
      '  DOC_ID = :DOC_ID'
      'where'
      '  BALS = :OLD_BALS and'
      '  NUMKCU = :OLD_NUMKCU and'
      '  NP = :OLD_NP and'
      '  DOC_ID = :OLD_DOC_ID')
    InsertSQL.Strings = (
      'insert into "f:\bm444\zerno1\rasxod.dbf"'
      
        '  (DEBET, BALS, NUMKCU, NAMEPR, KEI, EIZ, OPER, DATETR, NUMDOK, ' +
        'CEX, '
      'POST, '
      '   MOL, KOL, "f:\bm444\zerno1\rasxod.dbf"."MONEY", '
      
        '"f:\bm444\zerno1\rasxod.dbf"."SUM", KPZ, SKLAD, NACEN, DT1, KT1,' +
        ' SUM1, DT2, '
      'KT2, PRIZN, '
      '   PRIZNVX, OTK, KT, NMASH, NP, KORR, SUMD, DOC_ID)'
      'values'
      
        '  (:DEBET, :BALS, :NUMKCU, :NAMEPR, :KEI, :EIZ, :OPER, :DATETR, ' +
        ':NUMDOK, '
      
        '   :CEX, :POST, :MOL, :KOL, :MONEY, :SUM, :KPZ, :SKLAD, :NACEN, ' +
        ':DT1, :KT1, '
      
        '   :SUM1, :DT2, :KT2, :PRIZN, :PRIZNVX, :OTK, :KT, :NMASH, :NP, ' +
        ':KORR, '
      '   :SUMD, :DOC_ID)')
    DeleteSQL.Strings = (
      'delete from "f:\bm444\zerno1\rasxod.dbf"'
      'where'
      '  BALS = :OLD_BALS and'
      '  NUMKCU = :OLD_NUMKCU and'
      '  NP = :OLD_NP and'
      '  DOC_ID = :OLD_DOC_ID')
    Left = 128
    Top = 312
  end
  object addNedobavProc: TIBStoredProc
    Database = Belmed
    Transaction = RTrans
    StoredProcName = 'ADD_K2D_NEDOBAV_RASH'
    Left = 32
    Top = 312
  end
  object Prih: TERxQuery
    CachedUpdates = True
    SessionName = 'WorkSession'
    SQL.Strings = (
      'select *'
      'from "f:\bm444\zerno1\prixod.dbf" prixod'
      'where prixod.doc_id <> 0'
      'and prixod.sklad = :stkod')
    UpdateObject = UpdPrih
    EhSQL.Strings = (
      'select *'
      'from "f:\bm444\zerno1\prixod.dbf" prixod'
      'where prixod.doc_id <> 0'
      'and prixod.sklad = :stkod')
    EhMacros = <>
    Left = 192
    Top = 264
    ParamData = <
      item
        DataType = ftString
        Name = 'stkod'
        ParamType = ptInput
      end>
    object PrihBALS: TStringField
      FieldName = 'BALS'
      Size = 5
    end
    object PrihNUMKCU: TStringField
      FieldName = 'NUMKCU'
      Size = 7
    end
    object PrihNAMEPR: TStringField
      FieldName = 'NAMEPR'
      Size = 25
    end
    object PrihMEI: TStringField
      FieldName = 'MEI'
      Size = 4
    end
    object PrihEIZ: TStringField
      FieldName = 'EIZ'
      Size = 3
    end
    object PrihOPER: TStringField
      FieldName = 'OPER'
      Size = 1
    end
    object PrihDATETR: TDateField
      FieldName = 'DATETR'
    end
    object PrihNUMDOK: TStringField
      FieldName = 'NUMDOK'
      Size = 5
    end
    object PrihNSD: TStringField
      FieldName = 'NSD'
      Size = 10
    end
    object PrihDATSD: TDateField
      FieldName = 'DATSD'
    end
    object PrihKP: TStringField
      FieldName = 'KP'
      Size = 5
    end
    object PrihPOST: TStringField
      FieldName = 'POST'
      Size = 40
    end
    object PrihKOL: TFloatField
      FieldName = 'KOL'
    end
    object PrihKOLOTG: TFloatField
      FieldName = 'KOLOTG'
    end
    object PrihMONEY: TFloatField
      FieldName = 'MONEY'
    end
    object PrihSUM: TFloatField
      FieldName = 'SUM'
    end
    object PrihKPZ: TStringField
      FieldName = 'KPZ'
      Size = 8
    end
    object PrihREGNSF: TFloatField
      FieldName = 'REGNSF'
    end
    object PrihKOLNEDN: TFloatField
      FieldName = 'KOLNEDN'
    end
    object PrihKOLNEDS: TFloatField
      FieldName = 'KOLNEDS'
    end
    object PrihKOLMATPUT: TFloatField
      FieldName = 'KOLMATPUT'
    end
    object PrihSUMNEDN: TFloatField
      FieldName = 'SUMNEDN'
    end
    object PrihSUMNEDS: TFloatField
      FieldName = 'SUMNEDS'
    end
    object PrihSUMMATP: TFloatField
      FieldName = 'SUMMATP'
    end
    object PrihSKLAD: TStringField
      FieldName = 'SKLAD'
      Size = 4
    end
    object PrihDEBDOP: TStringField
      FieldName = 'DEBDOP'
      Size = 4
    end
    object PrihKRDOP: TStringField
      FieldName = 'KRDOP'
      Size = 4
    end
    object PrihPRIZVX: TStringField
      FieldName = 'PRIZVX'
      Size = 1
    end
    object PrihPRIZN: TStringField
      FieldName = 'PRIZN'
      Size = 1
    end
    object PrihKREG: TSmallintField
      FieldName = 'KREG'
    end
    object PrihNP: TFloatField
      FieldName = 'NP'
    end
    object PrihKORR: TStringField
      FieldName = 'KORR'
      Size = 1
    end
    object PrihWW1: TStringField
      FieldName = 'WW1'
      Size = 1
    end
    object PrihSUMD: TFloatField
      FieldName = 'SUMD'
    end
    object PrihDOC_ID: TFloatField
      FieldName = 'DOC_ID'
    end
  end
  object UpdPrih: TUpdateSQL
    ModifySQL.Strings = (
      'update "f:\bm444\zerno1\prixod.dbf"'
      'set'
      '  BALS = :BALS,'
      '  NUMKCU = :NUMKCU,'
      '  NAMEPR = :NAMEPR,'
      '  MEI = :MEI,'
      '  EIZ = :EIZ,'
      '  OPER = :OPER,'
      '  DATETR = :DATETR,'
      '  NUMDOK = :NUMDOK,'
      '  NSD = :NSD,'
      '  DATSD = :DATSD,'
      '  KP = :KP,'
      '  POST = :POST,'
      '  KOL = :KOL,'
      '  KOLOTG = :KOLOTG,'
      '  "f:\bm444\zerno1\prixod.dbf"."MONEY" = :MONEY,'
      '  "f:\bm444\zerno1\prixod.dbf"."SUM" = :SUM,'
      '  KPZ = :KPZ,'
      '  REGNSF = :REGNSF,'
      '  KOLNEDN = :KOLNEDN,'
      '  KOLNEDS = :KOLNEDS,'
      '  KOLMATPUT = :KOLMATPUT,'
      '  SUMNEDN = :SUMNEDN,'
      '  SUMNEDS = :SUMNEDS,'
      '  SUMMATP = :SUMMATP,'
      '  SKLAD = :SKLAD,'
      '  DEBDOP = :DEBDOP,'
      '  KRDOP = :KRDOP,'
      '  PRIZVX = :PRIZVX,'
      '  PRIZN = :PRIZN,'
      '  KREG = :KREG,'
      '  NP = :NP,'
      '  KORR = :KORR,'
      '  WW1 = :WW1,'
      '  SUMD = :SUMD,'
      '  SUMNDS = :SUMNDS,'
      '  DOC_ID = :DOC_ID'
      'where'
      '  BALS = :OLD_BALS and'
      '  NUMKCU = :OLD_NUMKCU and'
      '  NP = :OLD_NP and'
      '  DOC_ID = :OLD_DOC_ID')
    InsertSQL.Strings = (
      'insert into "f:\bm444\zerno1\prixod.dbf"'
      
        '  (BALS, NUMKCU, NAMEPR, MEI, EIZ, OPER, DATETR, NUMDOK, NSD, DA' +
        'TSD, KP, '
      
        '   POST, KOL, KOLOTG, "f:\bm444\zerno1\prixod.dbf"."MONEY", "f:\' +
        'bm444\zerno1\prixod.dbf"."SUM", '
      '   KPZ, REGNSF, KOLNEDN, KOLNEDS, KOLMATPUT, '
      
        '   SUMNEDN, SUMNEDS, SUMMATP, SKLAD, DEBDOP, KRDOP, PRIZVX, PRIZ' +
        'N, KREG, '
      '   NP, KORR, WW1, SUMD, SUMNDS, DOC_ID)'
      'values'
      
        '  (:BALS, :NUMKCU, :NAMEPR, :MEI, :EIZ, :OPER, :DATETR, :NUMDOK,' +
        ' :NSD, '
      
        '   :DATSD, :KP, :POST, :KOL, :KOLOTG, :MONEY, :SUM, :KPZ, :REGNS' +
        'F, :KOLNEDN, '
      
        '   :KOLNEDS, :KOLMATPUT, :SUMNEDN, :SUMNEDS, :SUMMATP, :SKLAD, :' +
        'DEBDOP, '
      
        '   :KRDOP, :PRIZVX, :PRIZN, :KREG, :NP, :KORR, :WW1, :SUMD, :SUM' +
        'NDS, :DOC_ID)')
    DeleteSQL.Strings = (
      'delete from "f:\bm444\zerno1\prixod.dbf"'
      'where'
      '  BALS = :OLD_BALS and'
      '  NUMKCU = :OLD_NUMKCU and'
      '  NP = :OLD_NP and'
      '  DOC_ID = :OLD_DOC_ID')
    Left = 192
    Top = 312
  end
  object WorkSession: TSession
    NetFileDir = 'C:\WORK'
    PrivateDir = 'C:\WORK'
    SessionName = 'WorkSession'
    Left = 32
    Top = 216
  end
  object LogQuery: TRxIBQuery
    Database = Belmed
    Transaction = RTrans
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'select *'
      'from k2d_log'
      'where k2d_log.copy_id = :copy_id')
    UpdateObject = UpdLogQuery
    Macros = <>
    Left = 640
    Top = 8
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'copy_id'
        ParamType = ptUnknown
      end>
    object LogQueryPROGRAM_LOG_ID: TIntegerField
      FieldName = 'PROGRAM_LOG_ID'
      Origin = '"K2D_LOG"."PROGRAM_LOG_ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object LogQueryCOPY_ID: TIntegerField
      FieldName = 'COPY_ID'
      Origin = '"K2D_LOG"."COPY_ID"'
    end
    object LogQueryUSER_NAME: TIBStringField
      FieldName = 'USER_NAME'
      Origin = '"K2D_LOG"."USER_NAME"'
    end
    object LogQueryTO_MACHINE: TIBStringField
      FieldName = 'TO_MACHINE'
      Origin = '"K2D_LOG"."TO_MACHINE"'
      Size = 5
    end
    object LogQuerySTRUK_ID: TIntegerField
      FieldName = 'STRUK_ID'
      Origin = '"K2D_LOG"."STRUK_ID"'
    end
    object LogQueryCUR_MONTH: TSmallintField
      FieldName = 'CUR_MONTH'
      Origin = '"K2D_LOG"."CUR_MONTH"'
    end
    object LogQueryCUR_YEAR: TIntegerField
      FieldName = 'CUR_YEAR'
      Origin = '"K2D_LOG"."CUR_YEAR"'
    end
    object LogQueryMESSAGE: TIBStringField
      FieldName = 'MESSAGE'
      Origin = '"K2D_LOG"."MESSAGE"'
      Size = 300
    end
    object LogQuerySENDER: TIBStringField
      FieldName = 'SENDER'
      Origin = '"K2D_LOG"."SENDER"'
      Size = 30
    end
    object LogQuerySTKOD: TIBStringField
      FieldName = 'STKOD'
      Origin = '"K2D_LOG"."STKOD"'
      Size = 4
    end
  end
  object UpdLogQuery: TIBUpdateSQLW
    RefreshSQL.Strings = (
      'Select '
      '  PROGRAM_LOG_ID,'
      '  COPY_ID,'
      '  USER_NAME,'
      '  TO_MACHINE,'
      '  STRUK_ID,'
      '  CUR_MONTH,'
      '  CUR_YEAR,'
      '  MESSAGE,'
      '  SENDER,'
      '  STKOD'
      'from k2d_log '
      'where'
      '  PROGRAM_LOG_ID = :PROGRAM_LOG_ID')
    ModifySQL.Strings = (
      'update k2d_log'
      'set'
      '  COPY_ID = :COPY_ID,'
      '  CUR_MONTH = :CUR_MONTH,'
      '  CUR_YEAR = :CUR_YEAR,'
      '  MESSAGE = :MESSAGE,'
      '  PROGRAM_LOG_ID = :PROGRAM_LOG_ID,'
      '  STRUK_ID = :STRUK_ID,'
      '  TO_MACHINE = :TO_MACHINE,'
      '  SENDER = :SENDER,'
      '  STKOD = :STKOD'
      'where'
      '  PROGRAM_LOG_ID = :OLD_PROGRAM_LOG_ID')
    InsertSQL.Strings = (
      'insert into k2d_log'
      
        '  (COPY_ID, CUR_MONTH, CUR_YEAR, MESSAGE, PROGRAM_LOG_ID, STRUK_' +
        'ID, '
      '   TO_MACHINE, SENDER, STKOD)'
      'values'
      
        '  (:COPY_ID, :CUR_MONTH, :CUR_YEAR, :MESSAGE, :PROGRAM_LOG_ID, :' +
        'STRUK_ID, '
      '   :TO_MACHINE, :SENDER, :STKOD)')
    DeleteSQL.Strings = (
      'delete from k2d_log'
      'where'
      '  PROGRAM_LOG_ID = :OLD_PROGRAM_LOG_ID')
    AutoCommit = True
    UpdateTransaction = WTrans
    Left = 640
    Top = 64
  end
  object DSLogQuery: TDataSource
    DataSet = LogQuery
    Left = 640
    Top = 112
  end
  object AddProgrLog: TIBStoredProc
    Database = Belmed
    Transaction = RTrans
    StoredProcName = 'ADD_K2D_PROGRAM_LOG'
    Left = 712
    Top = 8
  end
  object AddCopyId: TIBStoredProc
    Database = Belmed
    Transaction = RTrans
    StoredProcName = 'ADD_K2D_PROGRAM_LOG_COPY_ID'
    Left = 712
    Top = 64
  end
  object maxPrihRegnsf: TERxQuery
    SessionName = 'WorkSession'
    SQL.Strings = (
      'select max(prixod.regnsf) maxRegnsf'
      'from "f:\bm444\zerno1\prixod.dbf" prixod')
    EhSQL.Strings = (
      'select max(prixod.regnsf) maxRegnsf'
      'from "f:\bm444\zerno1\prixod.dbf" prixod')
    EhMacros = <>
    Left = 256
    Top = 264
    object maxPrihRegnsfMAXREGNSF: TFloatField
      FieldName = 'MAXREGNSF'
    end
  end
  object Bmomts: TERxQuery
    SessionName = 'BMOMTSSess'
    SQL.Strings = (
      'select bmomts.bmg, bmomts.struk_id'
      'from '#39'f:\bmomts\bmomts.dbf'#39' bmomts'
      'where bmomts.struk_id = :struk_id'
      'and bmomts.bmg = :buxName')
    EhSQL.Strings = (
      'select bmomts.bmg, bmomts.struk_id'
      'from '#39'f:\bmomts\bmomts.dbf'#39' bmomts'
      'where bmomts.struk_id = :struk_id'
      'and bmomts.bmg = :buxName')
    EhMacros = <>
    Left = 352
    Top = 264
    ParamData = <
      item
        DataType = ftInteger
        Name = 'struk_id'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'buxName'
        ParamType = ptInput
      end>
    object BmomtsBMG: TStringField
      FieldName = 'BMG'
      Size = 3
    end
    object BmomtsSTRUK_ID: TFloatField
      FieldName = 'STRUK_ID'
    end
  end
  object BMOMTSSess: TSession
    NetFileDir = 'F:\BMOMTS'
    PrivateDir = 'F:\BMOMTS'
    SessionName = 'BMOMTSSess'
    Left = 432
    Top = 264
  end
  object NomenMem: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '7.64.00 Standard Edition'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 200
    Top = 112
    object NomenMemBALS: TStringField
      FieldName = 'BALS'
      Size = 5
    end
    object NomenMemNUMKCU: TStringField
      FieldName = 'NUMKCU'
      Size = 7
    end
    object NomenMemNAMEPR: TStringField
      FieldName = 'NAMEPR'
      Size = 40
    end
    object NomenMemNAMEPRS: TStringField
      FieldName = 'NAMEPRS'
      Size = 25
    end
    object NomenMemXARKT: TStringField
      FieldName = 'XARKT'
      Size = 10
    end
    object NomenMemGOST: TStringField
      FieldName = 'GOST'
    end
    object NomenMemMONEY: TFloatField
      FieldName = 'MONEY'
    end
    object NomenMemKEI: TStringField
      FieldName = 'KEI'
      Size = 4
    end
    object NomenMemEIP: TStringField
      FieldName = 'EIP'
      Size = 10
    end
    object NomenMemDATEIN: TDateField
      FieldName = 'DATEIN'
    end
    object NomenMemNZ: TFloatField
      FieldName = 'NZ'
    end
    object NomenMemTPR: TStringField
      FieldName = 'TPR'
      Size = 1
    end
    object NomenMemKOL: TFloatField
      FieldName = 'KOL'
    end
    object NomenMemSUM: TFloatField
      FieldName = 'SUM'
    end
    object NomenMemPRIXODM: TFloatField
      FieldName = 'PRIXODM'
    end
    object NomenMemRASXODM: TFloatField
      FieldName = 'RASXODM'
    end
    object NomenMemSRASXM: TFloatField
      FieldName = 'SRASXM'
    end
    object NomenMemSPRIXM: TFloatField
      FieldName = 'SPRIXM'
    end
    object NomenMemDATETR: TDateField
      FieldName = 'DATETR'
    end
    object NomenMemSKLAD: TStringField
      FieldName = 'SKLAD'
      Size = 4
    end
    object NomenMemEDNOR: TSmallintField
      FieldName = 'EDNOR'
    end
    object NomenMemSSUM: TFloatField
      FieldName = 'SSUM'
    end
    object NomenMemNSUM: TFloatField
      FieldName = 'NSUM'
    end
    object NomenMemSKOL: TFloatField
      FieldName = 'SKOL'
    end
    object NomenMemCENAD: TFloatField
      FieldName = 'CENAD'
    end
    object NomenMemSUMD: TFloatField
      FieldName = 'SUMD'
    end
    object NomenMemSSUMD: TFloatField
      FieldName = 'SSUMD'
    end
    object NomenMemSPRIXMD: TFloatField
      FieldName = 'SPRIXMD'
    end
    object NomenMemSUMNDS: TFloatField
      FieldName = 'SUMNDS'
    end
    object NomenMemSRASXMD: TFloatField
      FieldName = 'SRASXMD'
    end
  end
end
