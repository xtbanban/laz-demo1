{
 主界面：负责调用显示其他页面
}
unit unit_docker;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  ActnList, LCLType, ComCtrls, Menus, StdCtrls,
  // 显示闪烁提示控件
  MyFrameControl;

type

  { TForm_docker }

  TForm_docker = class(TForm)
    Action_hideshow: TAction;
    Action_about: TAction;
    Action_quit: TAction;
    Action_main: TAction;
    Action_other: TAction;
    Action_setup: TAction;
    Action_help: TAction;
    ActionList1: TActionList;
    ApplicationProperties1: TApplicationProperties;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem5: TMenuItem;
    Panel_client: TPanel;
    Panel_top: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    SpeedButton_main: TSpeedButton;
    SpeedButton_setup: TSpeedButton;
    SpeedButton_quit: TSpeedButton;
    SpeedButton_help: TSpeedButton;
    SpeedButton_scan: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure Action_aboutExecute(Sender: TObject);
    procedure Action_helpExecute(Sender: TObject);
    procedure Action_hideshowExecute(Sender: TObject);
    procedure Action_mainExecute(Sender: TObject);
    procedure Action_quitExecute(Sender: TObject);
    procedure Action_otherExecute(Sender: TObject);
    procedure Action_setupExecute(Sender: TObject);
    procedure ApplicationProperties1Hint(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    TF_Form: TForm;                     // 上次显示的窗口

    procedure HideShape;                // 隐藏三角显示
  public
    procedure ShowPanel(AForm: TForm; APanel: TPanel);
    procedure ShowMyHint(MyControal: Tcontrol; myfalsh: boolean = True);
    procedure StopMyHint;
  end;

const
  C_title = '我的系统';

var
  Form_docker: TForm_docker;
  AFrameControl: TMyFrameControl;

implementation

{$R *.lfm}

uses unit_main, unit_other, unit_setup, unit_help, unit_about;

procedure TForm_docker.HideShape;
begin
  Shape1.Visible := False;
  Shape2.Visible := False;
  Shape3.Visible := False;
  Shape4.Visible := False;
end;

procedure TForm_docker.ShowPanel(AForm: TForm; APanel: TPanel);
var
  I: integer;
  AControl: TControl;
  m: TMethod;
begin
  APanel.Parent := Panel_client;
  APanel.Left := 0;
  APanel.Top := 0;
  APanel.Visible := True;
  for I := 0 to Panel_client.ControlCount - 1 do
  begin
    AControl := Panel_client.Controls[I];
    if (AControl is TPanel) and (AControl <> APanel) then
    begin
      if AControl.Visible then
      begin
        with (TF_Form as TForm) do
        begin
          m.code := MethodAddress('NoShowMyself');
          if (m.code <> nil) then
          begin
            m.Data := Pointer(nil); // 可不用
            TNotifyEvent(m)(nil);
          end;
        end;
      end;
      AControl.Visible := False;
    end;
  end;
  TF_Form := AForm;
  HideShape;
  // 停止显示闪烁提示框
  StopMyHint;
end;

procedure TForm_docker.ShowMyHint(MyControal: Tcontrol; myfalsh: boolean = True);
begin
  AFrameControl.FrameControl(MyControal, myfalsh);
end;

procedure TForm_docker.StopMyHint;
begin
  AFrameControl.StopFramed;
end;

procedure TForm_docker.ApplicationProperties1Hint(Sender: TObject);
begin
  StatusBar1.Panels.Items[1].Text := Application.Hint;
end;

procedure TForm_docker.FormCreate(Sender: TObject);
begin
  // 初始化红色提示框
  AFrameControl := TMyFrameControl.Create(nil);
  AFrameControl.Parent := Self;
  // 变量初始化
  Self.Caption := C_title;
  Application.Title := C_title;
  TF_Form := Self;
end;

procedure TForm_docker.FormDestroy(Sender: TObject);
begin
  AFrameControl.Free;
end;

procedure TForm_docker.FormResize(Sender: TObject);
begin
  StatusBar1.Panels.Items[1].Width := Self.Width - 100;
end;

procedure TForm_docker.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if QuestionDlg('退出', '确定要退出？', mtInformation,
    [mrYes, '确定', mrNo, '取消', 'IsDefault'], '') = mrNo then
    CloseAction := caNone;

  // 以下也是对话框，但是按键不能修改为中文
  //if MessageDlg('退出', '确定要退出？', mtConfirmation, [mbYes, mbNo], 0) =
  //  mrNo then CloseAction := caNone;
  //if Application.MessageBox('确定要退出？', '退出', MB_ICONQUESTION + MB_YESNO) = IDNO then
  //  CloseAction := caNone;
end;

procedure TForm_docker.Action_quitExecute(Sender: TObject);
begin
  // 退出
  Close;
end;

procedure TForm_docker.Action_aboutExecute(Sender: TObject);
begin
  // 关于...
  Form_about.Label_name.Caption := ApplicationProperties1.Title;
  Form_about.ShowModal;
end;

procedure TForm_docker.Action_hideshowExecute(Sender: TObject);
begin
  if Form_docker.Visible then Form_docker.Hide
  else
  begin
    Form_docker.Show;
  end;
end;

procedure TForm_docker.Action_mainExecute(Sender: TObject);
begin
  // 主页
  SpeedButton_main.Down := True;
  Self.Caption := C_title + ' - (主页)';
  Application.Title := Self.Caption;
  ShowPanel(Form_main, Form_main.Panel1);
  Shape1.Visible := True;
end;

procedure TForm_docker.Action_otherExecute(Sender: TObject);
begin
  // do...
  SpeedButton_scan.Down := True;
  Self.Caption := C_title + ' - (其他)';
  Application.Title := Self.Caption;
  ShowPanel(Form_other, Form_other.Panel1);
  Shape2.Visible := True;
end;

procedure TForm_docker.Action_setupExecute(Sender: TObject);
begin
  // 设置
  SpeedButton_scan.Down := True;
  Self.Caption := C_title + ' - (设置)';
  Application.Title := Self.Caption;
  ShowPanel(Form_setup, Form_setup.Panel1);
  Shape3.Visible := True;
end;

procedure TForm_docker.Action_helpExecute(Sender: TObject);
begin
    // 帮助
    SpeedButton_help.Down := True;
    Self.Caption := C_title + ' - (帮助)';
    Application.Title := Self.Caption;
    ShowPanel(Form_help, Form_help.Panel1);
    Shape4.Visible := True;
end;

end.
