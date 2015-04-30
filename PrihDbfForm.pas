unit PrihDbfForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh;

type
  TFPrihDbfForm = class(TForm)
    DBGridEh1: TDBGridEh;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPrihDbfForm: TFPrihDbfForm;

implementation

{$R *.dfm}

uses DataM;

procedure TFPrihDbfForm.FormShow(Sender: TObject);
begin
  dbgrideh1.Columns.AddAllColumns(true);
end;

end.
