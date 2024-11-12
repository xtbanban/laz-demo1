{
  FrameControl for Delphi & Lazarus
  Author: xtbanban
  e-mail: 88185785@qq.com
  Version 2024.10.12

  ��飺һ�����ڿؼ���Χ��˸��ʾ��ɫ�ֿ�Ŀؼ�

  ʹ��˵�����������������������ֻ��Ҫһ�Σ�������FormCreate�¼��У�
  �������AFrameControl: TMyFrameControl;
  ��������AFrameControl := TMyFrameControl.Create(nil);
  �������ԣ�AFrameControl.Parent := Self;

  ��˸��ʾ��AFrameControl.FrameControl(XXControl); ����Ϊ��ʾ�Ŀؼ�
  ֹͣ��ʾ��AFrameControl.StopFramed;
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
    procedure UpdateFrameControlPos;              // ˢ����ʾ
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // ��ʾ������Ϊ��ʾ�Ŀؼ���Ĭ����˸
    procedure FrameControl(AControl: TControl; myfalsh: Boolean = True);
    procedure StopFramed;                         // ֹͣ��ʾ
  end;

implementation

{ TMyFrameControl }

procedure TMyFrameControl.FrameTimeOut(Sender: TObject);
begin
  Visible := not Visible;                         // �����ؼ�
  if I_falsh < 7 then
    I_falsh := I_falsh + 1
  else
    StopFramed;
end;

constructor TMyFrameControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Color := clRed;                                 // ��ɫ
  I_falsh := 1;
  if not Assigned(MyTimer1) then                  // ������ʱ��
  begin
    MyTimer1 := TTimer.Create(nil);
    MyTimer1.OnTimer := @FrameTimeOut;            // ��@��lazarus�﷨
    MyTimer1.Interval := 250;
    MyTimer1.Enabled := False;
  end;
end;

destructor TMyFrameControl.Destroy;
begin
  MyTimer1.Destroy;                               // �˳�
  inherited Destroy;
end;

procedure TMyFrameControl.Resize;
const
  AElipsWidth = 0;                                // ��Բ���ȣ�0
var
  ARgn1, ARgn2: HRGN;
  ARect: TRect;
begin
  if Parent <> nil then
  begin
    ARect := Classes.Rect(0, 0, Width, Height);   // ָ�� Classes ��Ԫ
    ARgn1 := CreateRoundRectRgn(ARect.Left, ARect.Top, ARect.Right,
      ARect.Bottom, AElipsWidth, AElipsWidth);
    InflateRect(ARect, -2, -2);                   // �߿��ȣ�2
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
  StopFramed;                                     // ��ֹͣ��˸
  FFramedControl := AControl;
  if not Assigned(FFramedControl) then Exit;
  MyTimer1.Enabled := myfalsh;                    // ����ʱ��
  UpdateFrameControlPos;
  Visible := True;                                // ��ʾ
end;

procedure TMyFrameControl.StopFramed;
begin
  MyTimer1.Enabled := False;                      // ֹͣ��˸
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
