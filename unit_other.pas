unit unit_other;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons;

type

  { TForm_other }

  TForm_other = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    // 进入页面时运行
    procedure ShowMyself;
    // 关闭时运行
    procedure NoShowMyself;
  private

  public

  end;

var
  Form_other: TForm_other;

implementation

{$R *.lfm}

uses
  Unit_docker;

  { TForm_other }

procedure TForm_other.ShowMyself;
begin
  Form_docker.ShowMyHint(BitBtn1)
end;

procedure TForm_other.NoShowMyself;
begin

end;

procedure TForm_other.BitBtn1Click(Sender: TObject);
var
  k1, k2, k3: integer;
begin
  k1 := StrToIntDef(Edit1.Text, 0);
  k2 := StrToIntDef(Edit2.Text, 0);
  Edit3.Text := IntToStr(k1 + k2);
  Form_docker.ShowMyHint(Edit3); // 闪烁提示一下
end;

end.
