object FPrihDbfForm: TFPrihDbfForm
  Left = 0
  Top = 0
  Caption = #1055#1088#1080#1093#1086#1076#1099' DBF'
  ClientHeight = 481
  ClientWidth = 1136
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
    Width = 1136
    Height = 481
    Align = alClient
    AutoFitColWidths = True
    DataSource = DM.DSPrixDbf
    DynProps = <>
    FooterParams.Color = clWindow
    IndicatorOptions = [gioShowRowIndicatorEh]
    TabOrder = 0
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
end
