{
 主窗口：一般
}
unit unit_main;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons;

type

  { TForm_main }

  TForm_main = class(TForm)
    Bevel1: TBevel;
    Panel1: TPanel;
    StaticText1: TStaticText;
    // 关闭时运行
    procedure NoShowMyself;
  private

  public

  end;

var
  Form_main: TForm_main;

implementation

{$R *.lfm}

procedure TForm_main.NoShowMyself;
begin
  //
end;


end.
