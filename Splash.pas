unit Splash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFSplash = class(TForm)
    lbl_message: TLabel;
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    procedure setMessage(msg : string);
    procedure showSplash(message : string);
    procedure hideSplash;
  end;

implementation
{$R *.dfm}

procedure TFSplash.setMessage(msg : string);
var
  newWidth, newHeight : integer;
begin
  lbl_message.Caption := msg;
  lbl_message.Left := 0;
  lbl_message.Top := 0;

  newWidth := lbl_message.Canvas.TextWidth(msg) + 50;
  newHeight := 46;
  if (newWidth > 900) then
  begin
    self.Width := 900;
    lbl_message.Width := 900;
    newHeight := lbl_message.Height;
  end
  else
  begin
    self.Width := newWidth;
    lbl_message.Width := newWidth;
    lbl_message.Height := newHeight;
  end;
  self.Height := newHeight;
end;

procedure TFSplash.showSplash(message : string);
begin
  setMessage(message);
  self.Position := poDefault;
  self.Position := poOwnerFormCenter;
  self.Show;
  self.Update;
end;

procedure TFSplash.FormCreate(Sender: TObject);
begin
//  self.Close;
end;

procedure TFSplash.hideSplash;
begin
  self.Close;
end;

end.
