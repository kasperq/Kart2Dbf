unit CopyFiles;

interface
uses
  Windows, Messages, SysUtils;

  Procedure FileCopy(Const SourceFileName, TargetFileName: String);
  function WindowsCopyFile(FromFile, ToDir : string) : boolean;
  function DeleteFile() : boolean;
  function KolZnakovPosleZap(value : extended) : integer;
  function SumToString(x: Integer): string;
  function MesName(Mes: integer): string;

implementation

uses ShellApi, classes;

{
 Чтобы пользователь не занимал *.ехе файл и была возможность его заменить
 необходимо:
  1. подключить к главной форме проекта файл CopyFiles.pas и ShellApi
        uses CopyFiles, ShellApi;
  2. в событие OnShow главной формы добавить слюдующий код
        if paramstr(0) = 'C:\MyProg\restored\OTK.exe' then
          Close
        else
        begin
          тут основной код
        end;
  3. в событие OnCreate добавить
        if paramstr(0) = 'C:\MyProg\restored\OTK.exe' then
          if not WindowsCopyFile('C:\MyProg\restored\OTK.EXE', 'c:\') then
            ShowMessage('Copy Failed')
          else
          begin
            WindowsCopyFile('C:\MyProg\restored\Otchet.fr3', 'c:\');    путь к файлу, который будем копировать, и путь, куда будем копировать
            WindowsCopyFile('C:\MyProg\restored\OtchetKriw.fr3', 'c:\');
            ShellExecute(Handle, 'Open', PChar('C:\OTK.exe'), nil, nil, sw_normal);
          end;
  4. в событие OnDestroy добавить
        var
          f: textFile;
          FileName: string;
        begin
          if paramstr(0) = 'C:\OTK.exe' then
          begin
            FileName := changefileext(paramstr(0), '.bat');
            assignFile(f, FileName);
            rewrite(f);
            writeln(f, ':1');
            writeln(f, format('Erase "%s"', [paramstr(0)]));
            writeln(f, format('If exist "%s" Goto 1', [paramstr(0)]));
            writeln(f, 'Erase "c:\settings.ini"');                           тут перечислить все файлы которые надо удалить
            writeln(f, 'Erase "C:\Otchet.fr3"');
            writeln(f, 'Erase "C:\OtchetKriw.fr3"');
            writeln(f, format('Erase "%s"', [FileName]));
            closefile(f);
            ShellExecute(Handle, 'Open', PChar(FileName), nil, nil, sw_hide);
          end;
}

Procedure FileCopy(Const SourceFileName, TargetFileName: String);
Var
  S,T : TFileStream;
Begin
  S := TFileStream.Create(sourcefilename, fmOpenRead );
  try
    T := TFileStream.Create(targetfilename, fmOpenWrite or fmCreate);
    try
      T.CopyFrom(S, S.Size ) ;
      FileSetDate(T.Handle, FileGetDate(S.Handle));
    finally
      T.Free;
    end;
  finally
    S.Free;
  end;
end;

function WindowsCopyFile(FromFile, ToDir : string) : boolean;
var F : TShFileOpStruct;
begin  
  F.Wnd := 0; F.wFunc := FO_COPY;
  FromFile:=FromFile+#0; F.pFrom:=pchar(FromFile);   
  ToDir:=ToDir+#0; F.pTo:=pchar(ToDir);   
  F.fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION;   
  result:=ShFileOperation(F) = 0;   
end;

function DeleteFile() : boolean;
var f: textFile;
  FileName: string;
begin
  FileName := changefileext(paramstr(0), '.bat');
  assignFile(f, FileName);
  rewrite(f);
  writeln(f, ':1');
  writeln(f, format('Erase "%s"', [paramstr(0)]));
  writeln(f, format('If exist "%s" Goto 1', [paramstr(0)]));
  writeln(f, format('Erase "%s"', [FileName]));
  closefile(f);
//  ShellExecute(Handle, 'Open', PChar(FileName), nil, nil, sw_hide);
  result := true;
end;

function KolZnakovPosleZap(value : extended) : integer;
var
  s : string;
  i : Integer;
  kolZn : integer;
begin
  kolZn := 0;
  s := floattostr(value);
  for i := length(s) downto 0 do
  begin
    if s[i] = ',' then
      break;
    if i > 0 then
    begin
      if s[i] = '0' then
      begin
        if kolZn > 0 then
          kolZn := kolZn + 1;
      end
      else
        kolZn := kolZn + 1;
    end
    else
      kolZn := 0;
  end;
  result := kolZn;
end;

//Выдает значение числа прописью
function SumToString(x: Integer): string;
  label 1;
  Var ed: array[0..12] of  string;
  Var dec1: array[0..10] of  string;
  Var dec: array[0..8] of  string;
  Var cot: array[0..10] of  string;
  Var ts: array[0..4] of  string;
  Var ts1: array[0..4] of  string;
  Var ts2: array[0..4] of  string;
  Var x_n1,x_n3,n,x_f,x_f1,x_r1,x_r2,x_r3,x_pr: Integer;
    s,x_nf:string;
    i:integer;
begin
  s := '';
  ed[1]:='ОДИН'; ed[2]:= 'ДВА'; ed[3]:='ТРИ'; ed[4]:='ЧЕТЫРЕ'; ed[5]:='ПЯТЬ';
  ed[6]:='ШЕСТЬ'; ed[7]:='СЕМЬ'; ed[8]:='ВОСЕМЬ'; ed[9]:='ДЕВЯТЬ'; ed[10]:='ОДНА';
  ed[11]:='ДВЕ'; ed[12]:='';
  dec1[1]:='ДЕСЯТЬ';dec1[2]:='ОДИННАДЦАТЬ';dec1[3]:='ДВЕНАДЦАТЬ';dec1[4]:='ТРИНАДЦАТЬ';
  dec1[5]:='ЧЕТЫРНАДЦАТЬ';dec1[6]:='ПЯТНАДЦАТЬ';dec1[7]:='ШЕСТНАДЦАТЬ';
  dec1[8]:='СЕМНАДЦАТЬ';dec1[9]:='ВОСЕМНАДЦАТЬ';dec1[10]:='ДЕВЯТНАДЦАТЬ';
  dec[1]:='ДВАДЦАТЬ';dec[2]:='ТРИДЦАТЬ';dec[3]:='СОРОК';dec[4]:='ПЯТЬДЕСЯТ';
  dec[5]:='ШЕСТЬДЕСЯТ';dec[6]:='СЕМЬДЕСЯТ';dec[7]:='ВОСЕМЬДЕСЯТ';dec[8]:='ДЕВЯНОСТО';
  cot[1]:='СТО';cot[2]:='ДВЕСТИ';cot[3]:='ТРИСТА';cot[4]:='ЧЕТЫРЕСТА';cot[5]:='ПЯТЬСОТ';
  cot[6]:='ШЕСТЬСОТ';cot[7]:='СЕМЬСОТ';cot[8]:='ВОСЕМЬСОТ';cot[9]:='ДЕВЯТЬСОТ';
  cot[10]:='СТО';
  ts[1]:=' ';ts[2]:='ТЫСЯЧ';ts[3]:='МИЛЛИОНОВ';ts[4]:='МИЛЛИАРДОВ';
  ts1[1]:=' ';ts1[2]:='ТЫСЯЧИ';ts1[3]:='МИЛЛИОНА';ts1[4]:='МИЛЛИАРДА';
  ts2[1]:=' ';ts2[2]:='ТЫСЯЧА';ts2[3]:='МИЛЛИОН';ts2[4]:='МИЛЛИАРД';
  s:='';
  x_f1:=0; //x_n1:=0; x_n3:=0;  n:=0;
  n:=x;
  x_f:=length(trim(IntToStr(n)));
  if n=0 then
  begin
    Result:='0';
    Exit;
  end;
  if n<1000000000000000 then x_f1:=5;
  if n<1000000000000 then x_f1:=4;
  if n<1000000000 then x_f1:=3;
  if n<1000000 then x_f1:=2;
  if n<1000 then x_f1:=1;
  i:=1;
  case x_f of
    12: x_nf:=IntToStr(n);
    11: x_nf:='0'+IntToStr(n);
    10: x_nf:='00'+IntToStr(n);
    9: x_nf:=IntToStr(n);
    8: x_nf:='0'+IntToStr(n);
    7: x_nf:='00'+IntToStr(n);
    6: x_nf:=IntToStr(n);
    5: x_nf:='0'+IntToStr(n);
    4: x_nf:='00'+IntToStr(n);
    3: x_nf:=IntToStr(n);
    2: x_nf:='0'+IntToStr(n);
    1: x_nf:='00'+IntToStr(n);
    else
    begin
      s:=IntToStr(x);
      Result:=Trim(s);
      Exit;
    end;
  end;

  while x_f1>0 do
  begin
    x_r1:=i*3-2;
    x_r2:=i*3-1;
    x_r3:=i*3;
    x_pr:=0;
    x_n3:=0;
    x_n1:=StrToInt(copy(x_nf,x_r1,1));
    if x_n1<>0 then
    begin
      s:=s+cot[x_n1]+' ';
      x_pr:=1;
    end;
    x_n1:=StrToInt(copy(x_nf,x_r2,1));
    case x_n1 of
      2..99:
      begin   //
        s:=s+dec[x_n1-1]+' ';
        x_pr:=1;
        x_n1:=StrToInt(copy(x_nf,x_r3,1));
        if x_n1<>0 then
        begin
          if x_f1=2 then
          begin
            if x_n1=1 then s:=s+ed[10]+' ';
            if x_n1=2 then s:=s+ed[11]+' ';
            if x_n1>2 then s:=s+ed[x_n1]+' ';
          end
          else s:=s+ed[x_n1]+' ';
            x_pr:=1;
          end;
      end;  //
      1:
      begin
        x_pr:=1;
        x_n1:=StrToInt(copy(x_nf,x_r3,1));
        s:=s+dec1[x_n1+1]+' ';
        x_n3:=x_n1;
      end;
      0:
      begin //
        x_n1:=StrToInt(copy(x_nf,x_r3,1));
        if x_n1<>0 then
        begin
          if x_f1=2 then
          begin
            if x_n1=1 then s:=s+ed[10]+' ';
            if x_n1=2 then s:=s+ed[11]+' ';
            if x_n1>2 then s:=s+ed[x_n1]+' ';
          end
          else
            s:=s+ed[x_n1]+' ';
          x_pr:=1;
        end;
      end;
    end;
    if x_pr=1 then
    begin
      if x_n3<>0 then
      begin
        s:=s+ts[x_f1]+' ';
        goto 1;
      end;
      if (x_n1=3)or(x_n1=2)or(x_n1=4) then
      begin
        s:=s+ts1[x_f1]+' ';
        goto 1;
      end;
      if x_n1=1 then
      begin
        s:=s+ts2[x_f1]+' ';
        goto 1;
      end;
      s:=s+ts[x_f1]+' ';
    end;
    1: x_f1:=x_f1-1;
       i:=i+1;
  end;
  Result:=Trim(s);
end;

function MesName(Mes: integer): string;
begin
  case Mes of
    1: Result:='Января';
    2: Result:='Февраля';
    3: Result:='Марта';
    4: Result:='Апреля';
    5: Result:='Мая';
    6: Result:='Июня';
    7: Result:='Июля';
    8: Result:='Августа';
    9: Result:='Сентября';
    10: Result:='Октября';
    11: Result:='Ноября';
    12: Result:='Декабря';
  end;
end;



end.
