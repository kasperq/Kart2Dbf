unit PrihDbfQForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh;

type
  TFPrihDbfQForm = class(TForm)
    DBGridEh1: TDBGridEh;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPrihDbfQForm: TFPrihDbfQForm;

implementation

{$R *.dfm}

uses DataM;

procedure TFPrihDbfQForm.FormShow(Sender: TObject);
begin
  dbgrideh1.Columns.AddAllColumns(true);
end;

end.
