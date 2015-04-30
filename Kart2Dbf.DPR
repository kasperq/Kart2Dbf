program Kart2Dbf;

uses
  Forms,
  KartVDbfMain in 'KartVDbfMain.pas' {KartVDbfForm},
  DataM in 'DataM.pas' {DM: TDataModule},
  PrihForm in 'PrihForm.pas' {FPrihForm},
  PrihDbfForm in 'PrihDbfForm.pas' {FPrihDbfForm},
  RasxDbfForm in 'RasxDbfForm.pas' {FRasxDbfForm},
  RashForm in 'RashForm.pas' {FRashForm},
  PrihDbfQForm in 'PrihDbfQForm.pas' {FPrihDbfQForm},
  Nesootv in 'Nesootv.pas' {FNesootv},
  Logger in 'Logger.pas',
  CopyFiles in 'CopyFiles.pas',
  Splash in 'Splash.pas' {FSplash};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Kart2Dbf';
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TKartVDbfForm, KartVDbfForm);
  Application.CreateForm(TFPrihForm, FPrihForm);
  Application.CreateForm(TFPrihDbfForm, FPrihDbfForm);
  Application.CreateForm(TFRasxDbfForm, FRasxDbfForm);
  Application.CreateForm(TFRashForm, FRashForm);
  Application.CreateForm(TFPrihDbfQForm, FPrihDbfQForm);
  Application.CreateForm(TFNesootv, FNesootv);
  Application.Run;
end.
 
