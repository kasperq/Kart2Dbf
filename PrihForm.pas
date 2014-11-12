unit PrihForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh;

type
  TFPrihForm = class(TForm)
    DBGridEh1: TDBGridEh;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPrihForm: TFPrihForm;

implementation

{$R *.dfm}
uses DataM;

procedure TFPrihForm.FormShow(Sender: TObject);
begin
  dbgrideh1.Columns.AddAllColumns(true);
end;

end.
