unit Nesootv;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh, Buttons, ExtCtrls, StdCtrls, Spin, DB,
  IBCustomDataSet, IBQuery, RxIBQuery, FindDlgEh;

type
  TFNesootv = class(TForm)
    DBGridEh1: TDBGridEh;
    Panel1: TPanel;
    printBtn: TSpeedButton;
    saveBtn: TSpeedButton;
    delBtn: TSpeedButton;
    buxNameCombo: TComboBox;
    strkCombo: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    curMonthEdit: TSpinEdit;
    curYearEdit: TSpinEdit;
    ConfigUMC: TRxIBQuery;
    ConfigUMCSTRUK_ID: TSmallintField;
    ConfigUMCSTKOD: TIBStringField;
    ConfigUMCOBOROT_BUX: TSmallintField;
    ConfigUMCSTNAME: TIBStringField;
    DSConfigUMC: TDataSource;
    delAllBtn: TSpeedButton;
    FindDlgEh1: TFindDlgEh;
    procedure printBtnClick(Sender: TObject);
    procedure delBtnClick(Sender: TObject);
    procedure saveBtnClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure strkComboChange(Sender: TObject);
    procedure buxNameComboChange(Sender: TObject);
    procedure curMonthEditChange(Sender: TObject);
    procedure curYearEditChange(Sender: TObject);
    procedure delAllBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure fillStrkCombo;
    function locateConfigUmcIndex(index : integer) : boolean;

  public
    var
      curYear, curMonth, curStrukId : integer;
      buxName : string;

    procedure setCurVars(buxNameIndex, month, year, strukIndex : integer);
  end;

var
  FNesootv: TFNesootv;

implementation

{$R *.dfm}

uses DataM, KartVDbfMain;

procedure TFNesootv.setCurVars(buxNameIndex, month, year, strukIndex : integer);
begin
  buxNameCombo.ItemIndex := buxNameIndex;
  curMonthEdit.Value := month;
  curYearEdit.Value := year;
  strkCombo.ItemIndex := strukIndex + 1;
end;

procedure TFNesootv.fillStrkCombo;
begin
  if (self.ConfigUMC.Active) then
  begin
    self.ConfigUMC.First;
    strkCombo.Items.Clear;
    strkCombo.Items.Add('Все подразделения');
    while (not self.ConfigUMC.Eof) do
    begin
      strkCombo.Items.Add(self.ConfigUMCSTNAME.AsString);
      self.ConfigUMC.Next;
    end;
    strkCombo.ItemIndex := 0;
  end;
end;

procedure TFNesootv.buxNameComboChange(Sender: TObject);
begin
  buxName := buxNameCombo.Text;
  if (self.Showing) then
    dm.openNesootvTbl(buxName, curMonth, curYear, curStrukId);
end;

procedure TFNesootv.curMonthEditChange(Sender: TObject);
begin
  curMonth := curMonthEdit.Value;
  if (self.Showing) then
    dm.openNesootvTbl(buxName, curMonth, curYear, curStrukId);
end;

procedure TFNesootv.curYearEditChange(Sender: TObject);
begin
  curYear := curYearEdit.Value;
  if (self.Showing) then
    dm.openNesootvTbl(buxName, curMonth, curYear, curStrukId);
end;

procedure TFNesootv.delAllBtnClick(Sender: TObject);
begin
  dm.ClearNesootvTbl;
end;

procedure TFNesootv.delBtnClick(Sender: TObject);
begin
  dm.NesootvTbl.Delete;
end;

procedure TFNesootv.FormCreate(Sender: TObject);
begin
  KartVDbfForm.fillMachineList(buxNameCombo);
  self.ConfigUMC.Open;
  fillStrkCombo;
end;

procedure TFNesootv.FormShow(Sender: TObject);
begin
  buxName := buxNameCombo.Text;
  curMonth := curMonthEdit.Value;
  curYear := curYearEdit.Value;
  strkComboChange(Sender);
  dm.openNesootvTbl(buxName, curMonth, curYear, curStrukId);
end;

procedure TFNesootv.printBtnClick(Sender: TObject);
begin
  dm.frxReport1.LoadFromFile('fr_nesTbl.fr3');
  dm.frxReport1.ShowReport;
end;

procedure TFNesootv.saveBtnClick(Sender: TObject);
begin
  dm.saveNesootvTbl;
end;

procedure TFNesootv.SpeedButton1Click(Sender: TObject);
begin
  dm.openNesootvTbl(buxName, curMonth, curYear, curStrukId);
end;

function TFNesootv.locateConfigUmcIndex(index : integer) : boolean;
begin
  result := false;
  self.ConfigUMC.First;
  while (not ConfigUMC.Eof) do
  begin
    if (ConfigUMC.RecNo = index) then
    begin
      result := true;
      break;
    end;
    ConfigUMC.Next;
  end;
end;

procedure TFNesootv.strkComboChange(Sender: TObject);
begin
  if (strkCombo.ItemIndex = 0) then
    curStrukId := -32000
  else
  begin
    self.ConfigUMC.First;
    if (locateConfigUmcIndex(strkCombo.ItemIndex)) then
      curStrukId := self.ConfigUMCSTRUK_ID.AsInteger;
  end;
  if (self.Showing) then
    dm.openNesootvTbl(buxName, curMonth, curYear, curStrukId);
end;

end.
