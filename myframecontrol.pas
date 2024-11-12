{
  FrameControl for Delphi & Lazarus
  Author: xtbanban
  e-mail: 88185785@qq.com
  Version 2024.10.12

  简介：一个可在控件周围闪烁显示红色粗框的控件

  使用说明：（创建对象和设置属性只需要一次，建议在FormCreate事件中）
  定义对象：AFrameControl: TMyFrameControl;
  创建对象：AFrameControl := TMyFrameControl.Create(nil);
  设置属性：AFrameControl.Parent := Self;

  闪烁显示：AFrameControl.FrameControl(XXControl); 参数为显示的控件
  停止显示：AFrameControl.StopFramed;
}
unit MyFrameControl;

interface

uses
  Controls, Classes, ExtCtrls, Windows, Graphics;

type
  TMyFrameControl = class(TWinControl)
  private
    I_falsh: integer;
    MyTimer1: TTimer;
    FFramedControl: TControl;
  protected
    procedure Resize; override;
    procedure FrameTimeOut(Sender: TObject);
    procedure UpdateFrameControlPos;              // 刷新显示
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // 显示，参数为显示的控件，默认闪烁
    procedure FrameControl(AControl: TControl; myfalsh: Boolean = True);
    procedure StopFramed;                         // 停止显示
  end;

implementation

{ TMyFrameControl }

procedure TMyFrameControl.FrameTimeOut(Sender: TObject);
begin
  Visible := not Visible;                         // 闪动控件
  if I_falsh < 7 then
    I_falsh := I_falsh + 1
  else
    StopFramed;
end;

constructor TMyFrameControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Color := clRed;                                 // 红色
  I_falsh := 1;
  if not Assigned(MyTimer1) then                  // 创建定时器
  begin
    MyTimer1 := TTimer.Create(nil);
    MyTimer1.OnTimer := @FrameTimeOut;            // 加@是lazarus语法
    MyTimer1.Interval := 250;
    MyTimer1.Enabled := False;
  end;
end;

destructor TMyFrameControl.Destroy;
begin
  MyTimer1.Destroy;                               // 退出
  inherited Destroy;
end;

procedure TMyFrameControl.Resize;
const
  AElipsWidth = 0;                                // 椭圆曲度＝0
var
  ARgn1, ARgn2: HRGN;
  ARect: TRect;
begin
  if Parent <> nil then
  begin
    ARect := Classes.Rect(0, 0, Width, Height);   // 指定 Classes 单元
    ARgn1 := CreateRoundRectRgn(ARect.Left, ARect.Top, ARect.Right,
      ARect.Bottom, AElipsWidth, AElipsWidth);
    InflateRect(ARect, -2, -2);                   // 边框宽度＝2
    ARgn2 := CreateRoundRectRgn(ARect.Left, ARect.Top, ARect.Right,
      ARect.Bottom, AElipsWidth, AElipsWidth);
    CombineRgn(ARgn1, ARgn2, ARgn1, RGN_XOR);
    SetWindowRgn(Handle, ARgn1, True);
    DeleteObject(ARgn1);
    DeleteObject(ARgn2);
  end;
  inherited;
end;

procedure TMyFrameControl.FrameControl(AControl: TControl; myfalsh: Boolean = True);
begin
  StopFramed;                                     // 先停止闪烁
  FFramedControl := AControl;
  if not Assigned(FFramedControl) then Exit;
  MyTimer1.Enabled := myfalsh;                    // 开定时器
  UpdateFrameControlPos;
  Visible := True;                                // 显示
end;

procedure TMyFrameControl.StopFramed;
begin
  MyTimer1.Enabled := False;                      // 停止闪烁
  Visible := False;
  I_falsh := 1;
end;

procedure TMyFrameControl.UpdateFrameControlPos;
var
  ARect, ADestRect: TRect;
begin
  if not Assigned(FFramedControl) then Exit;
  ARect := FFramedControl.Parent.ClientRect;
  if FFramedControl.Left < 0 then
    ADestRect.Left := 0
  else
    ADestRect.Left := FFramedControl.Left;
  if FFramedControl.Top < 0 then
    ADestRect.Top := 0
  else
    ADestRect.Top := FFramedControl.Top;
  if (FFramedControl.Left + FFramedControl.Width) >= ARect.Right then
    ADestRect.Right := ARect.Right - ADestRect.Left
  else
    ADestRect.Right := FFramedControl.Width;
  if (FFramedControl.Top + FFramedControl.Height) >= ARect.Bottom then
    ADestRect.Bottom := ARect.Bottom - ADestRect.Top
  else
    ADestRect.Bottom := FFramedControl.Height;
  ADestRect.TopLeft := FFramedControl.Parent.ClientToScreen(ADestRect.TopLeft);
  ADestRect.TopLeft := Parent.ScreenToClient(ADestRect.TopLeft);
  ADestRect.Right := ADestRect.Right + ADestRect.Left;
  ADestRect.Bottom := ADestRect.Bottom + ADestRect.Top;
  BoundsRect := ADestRect;
  BringToFront;
end;

end.
