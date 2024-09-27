!include "MUI2.nsh"
Name "elpAudio"
Icon "ico.ico"
RequestExecutionLevel admin

InstallDir "C:\Program Files\elpAudio"
InstallDirRegKey HKLM "Software\NSIS_EA" "Install_Dir"

Unicode True


  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "img.bmp"
  !define MUI_ABORTWARNING

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "License.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH
  
  !insertmacro MUI_LANGUAGE "English"
  

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles



;--------------------------------

;--------------------------------
;Version Information

  VIProductVersion "1.0.0.0"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "elpAudio for old PCs"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" ""
  VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "elpAudio community"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" ""
  VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" ""
  VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "elpAudio Setup Wizard"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "1.0.0.0"

;--------------------------------

; The stuff to install
Section "elpAudio" Installer

  SectionIn RO
  
  ; close elpAudio
  ExecWait "taskkill /f /im elpAudio.exe"
  ExecWait "taskkill /f /im elpAudio-nochromakey.exe"
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "7z.exe"
  File "elpAudio-nochromakey.zip"
  File "associate-nochromakey.bat"
  
  ; extract files
  nsExec::Exec '"$INSTDIR\7z.exe" -y x elpAudio-nochromakey.zip' 
  Delete "$INSTDIR\elpAudio-nochromakey.zip"

  nsExec::Exec '"$INSTDIR\associate-nochromakey.bat"'
  Delete "$INSTDIR\associate-nochromakey.bat"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\NSIS_EA "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\elpAudio" "DisplayName" "elpAudio"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\elpAudio" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\elpAudio" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\elpAudio" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"  
  
SectionEnd



; mandatory visual c runtime install
Section "Visual C Runtime (32 bits)" VisualC

  SectionIn RO
  SetOutPath $INSTDIR
  File "vcredist_x86.exe"
  ExecWait "$INSTDIR\vcredist_x86.exe /passive"
  Delete "$INSTDIR\vcredist_x86.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts" SMShortucts

  SetOutPath $INSTDIR
  CreateDirectory "$SMPROGRAMS\elpAudio"
  CreateShortcut "$SMPROGRAMS\elpAudio\elpAudio.lnk" "$INSTDIR\elpAudio-nochromakey.exe"
  CreateShortcut "$SMPROGRAMS\elpAudio\Uninstall elpAudio.lnk" "$INSTDIR\uninstall.exe"

SectionEnd


; Optional section (can be disabled by the user)
Section "Desktop Shortcuts" DShortcuts

  CreateShortcut "$DESKTOP\elpAudio.lnk" "$INSTDIR\elpAudio-nochromakey.exe"
  
SectionEnd


Section "-installer cleanup"

  Delete "$INSTDIR\7z.exe"

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\elpAudio"
  DeleteRegKey HKLM "SOFTWARE\NSIS_EA"

  ; Remove files and uninstaller  
  Delete "$INSTDIR\*.exe"
  Delete "$INSTDIR\*.dll"
  Delete "$INSTDIR\*.log"
  Delete "$INSTDIR\*.ini"
  RMDir "$INSTDIR\themes"
  RMDir "$INSTDIR\data"
  RMDir "$INSTDIR\plugins"
  RMDir "$INSTDIR\visualisers"
  RMDir "$INSTDIR\music_examples"
  RMDir "$INSTDIR"

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\elpAudio\*.lnk"
  Delete "$DESKTOP\elpAudio.lnk"

SectionEnd

  ;Language strings
  LangString DESC_Installer ${LANG_ENGLISH} "Installs elpAudio to your PC."
  LangString DESC_VisualC ${LANG_ENGLISH} "Install Microsoft Visual C 2010 x86 for proper work."
  LangString DESC_SMShortucts ${LANG_ENGLISH} "Creates Start Menu shortcuts (optional)."
  LangString DESC_DShortcuts ${LANG_ENGLISH} "Creates desktop shortcuts (optional)."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${Installer} $(DESC_Installer)
	!insertmacro MUI_DESCRIPTION_TEXT ${DShortcuts} $(DESC_DShortcuts)
	!insertmacro MUI_DESCRIPTION_TEXT ${SMShortucts} $(DESC_SMShortucts)
	!insertmacro MUI_DESCRIPTION_TEXT ${VisualC} $(DESC_VisualC)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END