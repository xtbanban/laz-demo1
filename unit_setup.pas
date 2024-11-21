unit unit_setup;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls;

type

  { TForm_setup }

  TForm_setup = class(TForm)
    Bevel1: TBevel;
    Edit_localhost: TEdit;
    Label6: TLabel;
    Label1: TLabel;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    // 关闭时运行
    procedure NoShowMyself(Sender: TObject);
  private
  public

  end;

var
  Form_setup: TForm_setup;

implementation

{$R *.lfm}

uses
  unit_dm;

procedure TForm_setup.NoShowMyself(Sender: TObject);
begin

end;

procedure TForm_setup.FormCreate(Sender: TObject);
begin
  Edit_localhost.Text := DM.GetLocalIPAddress; // 调用取得ip函数
end;


end.
