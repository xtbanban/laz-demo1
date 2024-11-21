unit unit_about;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons
  // FPC 3.0 fileinfo reads exe resources as long as you register the appropriate units
  , fileinfo
  , winpeimagereader {need this for reading exe info}
  , elfreader {needed for reading ELF executables}
  , machoreader {needed for reading MACH-O executables};

type

  { TForm_about }

  TForm_about = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label_name: TLabel;
    Label_product: TLabel;
    Label_version: TLabel;
    Label_version1: TLabel;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form_about: TForm_about;

implementation

{$R *.lfm}

  { TForm_about }

uses
  Unit_DM;

procedure TForm_about.FormCreate(Sender: TObject);
var
  FileVerInfo: TFileVersionInfo;
begin
  FileVerInfo := TFileVersionInfo.Create(nil);
  try
    FileVerInfo.ReadFileInfo;
    // ['CompanyName']['FileDescription']['FileVersion']['InternalName']
    // ['LegalCopyright']['OriginalFilename']['ProductName']['ProductVersion']
    Label_product.Caption := FileVerInfo.VersionStrings.Values['ProductName'];
    Label_version.Caption := FileVerInfo.VersionStrings.Values['FileVersion'];

    DM.S_version :=Label_product.Caption; // 赋值全局变量：版本号码
  finally
    FileVerInfo.Free;
  end;
end;

end.
