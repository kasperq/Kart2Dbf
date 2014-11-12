unit RashForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh, FindDlgEh;

type
  TFRashForm = class(TForm)
    DBGridEh1: TDBGridEh;
    FindDlgEh1: TFindDlgEh;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRashForm: TFRashForm;

implementation

{$R *.dfm}

uses DataM;

procedure TFRashForm.FormShow(Sender: TObject);
begin
  dbgrideh1.Columns.AddAllColumns(true);
end;

end.
