object FRashForm: TFRashForm
  Left = 0
  Top = 0
  Caption = #1056#1072#1089#1093#1086#1076#1099' '#1073#1072#1079#1072
  ClientHeight = 588
  ClientWidth = 948
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGridEh1: TDBGridEh
    Left = 0
    Top = 0
    Width = 948
    Height = 588
    Align = alClient
    DataSource = DM.DSKartOutlay
    DynProps = <>
    FooterParams.Color = clWindow
    IndicatorOptions = [gioShowRowIndicatorEh]
    STFilter.Visible = True
    TabOrder = 0
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object FindDlgEh1: TFindDlgEh
    DBGrid = DBGridEh1
    FindFont.Charset = DEFAULT_CHARSET
    FindFont.Color = clWindowText
    FindFont.Height = -11
    FindFont.Name = 'Tahoma'
    FindFont.Style = []
    ShowFilterPanel = True
    SimpleSeek = True
    Left = 384
    Top = 320
  end
end
