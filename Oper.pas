unit Oper;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh;

type
  TFOper = class(TForm)
    DBGridEh1: TDBGridEh;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FOper: TFOper;

implementation

{$R *.dfm}

uses DataM;

procedure TFOper.FormShow(Sender: TObject);
begin
  dbgrideh1.Columns.AddAllColumns(true);
end;

end.
