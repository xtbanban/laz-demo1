{
 DM： 数据模式窗口，放置一些不可见控件，或全局使用的函数
}

unit unit_dm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Dialogs,
  FileUtil, Forms, Controls, ExtCtrls,
  winsock, sockets;

type

  { TDM }

  TDM = class(TDataModule)
  private
  public
    function GetLocalIPAddress: string;
  end;

var
  DM: TDM;

implementation

{$R *.lfm}

  { TDM }

// 取得本机ip地址
function TDM.GetLocalIPAddress: string;
var
  wsaData: TWSAData;
  hostent: PHostEnt;
  namen: array[0..255] of char;
begin
  Result := '';
  WSAStartup($0202, wsaData); // Initialize Winsock
  try
    if gethostname(namen, sizeof(namen)) = 0 then
    begin
      hostent := gethostbyname(namen);
      if hostent <> nil then
      begin
        Result := Format('%d.%d.%d.%d', [byte(hostent^.h_addr^[0]),
          byte(hostent^.h_addr^[1]), byte(hostent^.h_addr^[2]),
          byte(hostent^.h_addr^[3])]);
      end;
    end;
  finally
    WSACleanup; // Clean up Winsock
  end;
end;


end.
