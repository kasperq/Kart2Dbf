object FRasxDbfForm: TFRasxDbfForm
  Left = 0
  Top = 0
  Caption = #1056#1072#1089#1093#1086#1076#1099' DBF'
  ClientHeight = 627
  ClientWidth = 979
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
    Top = 25
    Width = 979
    Height = 602
    Align = alClient
    DataSource = DM.DSRashDbf
    DynProps = <>
    FooterParams.Color = clWindow
    IndicatorOptions = [gioShowRowIndicatorEh]
    TabOrder = 0
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 979
    Height = 25
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 6
      Width = 42
      Height = 16
      Margins.Bottom = 0
      Caption = 'Label1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
