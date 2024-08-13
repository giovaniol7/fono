; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "FonoCare"
#define MyAppVersion "2.0"
#define MyAppPublisher "SoftGol"
#define MyAppExeName "fonocare.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{A29183BA-61D0-4779-B8BC-0E73FF02B58B}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\Installers
OutputBaseFilename=fonocarepc
SetupIconFile=D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\windows\runner\resources\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\build\windows\x64\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\build\windows\x64\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\build\windows\x64\runner\Release\cloud_firestore_plugin.lib"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\build\windows\x64\runner\Release\file_selector_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\build\windows\x64\runner\Release\firebase_auth_plugin.lib"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\build\windows\x64\runner\Release\firebase_core_plugin.lib"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\build\windows\x64\runner\Release\firebase_storage_plugin.lib"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\build\windows\x64\runner\Release\flutter_localization_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\build\windows\x64\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\build\windows\x64\runner\Release\fonocare.exp"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\build\windows\x64\runner\Release\fonocare.lib"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\build\windows\x64\runner\Release\screen_retriever_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\build\windows\x64\runner\Release\url_launcher_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Users\gihol\Documents\AndroidStudioProjects\fonocare\build\windows\x64\runner\Release\window_manager_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
