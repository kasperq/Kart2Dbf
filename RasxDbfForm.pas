unit RasxDbfForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh, StdCtrls, ExtCtrls, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh;

type
  TFRasxDbfForm = class(TForm)
    DBGridEh1: TDBGridEh;
    Panel1: TPanel;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRasxDbfForm: TFRasxDbfForm;

implementation

{$R *.dfm}
uses DataM;


procedure TFRasxDbfForm.FormShow(Sender: TObject);
begin
  dbgrideh1.Columns.AddAllColumns(true);
//  Label1.Caption := IntToStr(dm.RashMem.RecordCount);
end;

end.
