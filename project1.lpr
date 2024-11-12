program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads, // 如果使用多线程
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms, SysUtils, MyFrameControl,
  unit_docker,  unit_main,
  unit_setup,  unit_about, unit_dm, unit_help, unit_other;

  {$R *.res}

begin
  Application.Title:='';
  Application.Scaled:=True;
  RequireDerivedFormResource := True;
  Application.Initialize;

  Application.CreateForm(TDM, DM);
  Application.CreateForm(TForm_docker, Form_docker);
  Application.CreateForm(TForm_main, Form_main);
  Application.CreateForm(TForm_other, Form_other);
  Application.CreateForm(TForm_setup, Form_setup);
  Application.CreateForm(TForm_help, Form_help);
  Application.CreateForm(TForm_about, Form_about);

  Form_docker.Action_mainExecute(nil); // 显示主页
  Application.Run;
end.
