#ifndef BundleDir
  #error BundleDir is required. Point it to the unpacked Windows x64 build.
#endif
#ifndef ProductVersion
  #error ProductVersion is required. Pass the bundled application version.
#endif
#ifndef SetupOutput
  #define SetupOutput AddBackslash(SourcePath) + "output"
#endif

[Setup]
AppId=LanScreenStudio.Mickey1013
AppName=岚屏工作台
AppVersion={#ProductVersion}
AppPublisher=Mickey1013
AppPublisherURL=https://github.com/Mickey1013/LanScreenStudio
AppSupportURL=https://github.com/Mickey1013/LanScreenStudio/issues
AppUpdatesURL=https://github.com/Mickey1013/LanScreenStudio/releases
DefaultDirName={localappdata}\Programs\LanScreenStudio
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\LanScreenStudio.exe
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest
CloseApplications=yes
RestartApplications=no
LicenseFile={#BundleDir}\LICENSE-app.txt
SetupIconFile={#BundleDir}\resources\app\ui\icon.ico
OutputDir={#SetupOutput}
OutputBaseFilename=LanScreenStudio-{#ProductVersion}-Windows-x64-Setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern

[Files]
Source: "{#BundleDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\岚屏工作台"; Filename: "{app}\LanScreenStudio.exe"; WorkingDir: "{app}"

[Run]
Filename: "{app}\LanScreenStudio.exe"; WorkingDir: "{app}"; Description: "打开岚屏工作台"; Flags: nowait postinstall skipifsilent
