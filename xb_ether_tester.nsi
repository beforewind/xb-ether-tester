; 
; 本软件为免费、开源软件。
; 本软件的版权(包括源码及二进制发布版本)归一切公众所有。
; 您可以自由使用、传播本软件。
; 您也可以以任何形式、任何目的使用本软件(包括源码及二进制发布版本)，而不受任何版权限制。
; =====================
; 作者: 孙明保
; 邮箱: sunmingbao@126.com
; 

; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "小兵以太网测试仪"
!define PRODUCT_VERSION "2.3.0"
!define PRODUCT_PUBLISHER "孙明保"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\xb_ether_tester.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"

SetCompressor lzma

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "COPYING.txt"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Start menu page
var ICONS_GROUP
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "小兵以太网测试仪"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"
!insertmacro MUI_PAGE_STARTMENU Application $ICONS_GROUP
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\xb_ether_tester.exe"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\release_notes.txt"
!define MUI_FINISHPAGE_SHOWREADME_TEXT "版本发布说明"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "SimpChinese"

; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "obj\xb_ether_tester_v${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES\小兵以太网测试仪"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Var WINPCAP_NAME ; DisplayName from WinPcap installation

Section "主程序" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite try
  File "obj\xb_ether_tester.exe"
  File "release_notes.txt"
  File "other_files\WinPcap_4_1_3.exe"
  
  ClearErrors
  ReadRegStr $WINPCAP_NAME HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinPcapInst" "DisplayName"
  IfErrors 0 done ;if RegKey is available, WinPcap is already installed
  
    MessageBox MB_YESNOCANCEL|MB_ICONQUESTION \
    "本软件的运行，需要winpcap的支持.\
    $\n$\n现在安装winpcap？" \
      /SD IDYES \
      IDYES install_winpcap \
      IDNO done
  Abort
  
install_winpcap:
  ExecWait '"$INSTDIR\WinPcap_4_1_3.exe"' $0
  DetailPrint "WinPcap installer returned $0"

done:
  Delete "$INSTDIR\WinPcap_4_1_3.exe"
; Shortcuts
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\小兵以太网测试仪.lnk" "$INSTDIR\xb_ether_tester.exe"
  CreateShortCut "$DESKTOP\小兵以太网测试仪.lnk" "$INSTDIR\xb_ether_tester.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -AdditionalIcons
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk" "$INSTDIR\uninst.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\xb_ether_tester.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\xb_ether_tester.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从你的计算机移除。"
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你确实要完全移除 $(^Name) ，其及所有的组件？" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  !insertmacro MUI_STARTMENU_GETFOLDER "Application" $ICONS_GROUP
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\WinPcap_4_1_3.exe"
  Delete "$INSTDIR\xb_ether_tester.exe"
  Delete "$INSTDIR\v${PRODUCT_VERSION}_release_notes.txt"

  Delete "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk"
  Delete "$DESKTOP\小兵以太网测试仪.lnk"
  Delete "$SMPROGRAMS\$ICONS_GROUP\小兵以太网测试仪.lnk"

  RMDir "$SMPROGRAMS\$ICONS_GROUP"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd


Var UNINSTALL_PROG
Var OLD_VER
Var OLD_PATH
Function .onInit
  ClearErrors
  ReadRegStr $UNINSTALL_PROG ${PRODUCT_UNINST_ROOT_KEY} ${PRODUCT_UNINST_KEY} "UninstallString"
  IfErrors  done
  
  ReadRegStr $OLD_VER ${PRODUCT_UNINST_ROOT_KEY} ${PRODUCT_UNINST_KEY} "DisplayVersion"
  MessageBox MB_YESNOCANCEL|MB_ICONQUESTION \
    "检测到本机已经安装了 ${PRODUCT_NAME} $OLD_VER。\
    $\n$\n是否先卸载已安装的版本？" \
      /SD IDYES \
      IDYES uninstall \
      IDNO done
  Abort
  
uninstall:
  StrCpy $OLD_PATH $UNINSTALL_PROG -10

  ExecWait '"$UNINSTALL_PROG" /S _?=$OLD_PATH' $0
  DetailPrint "uninst.exe returned $0"
  Delete "$UNINSTALL_PROG"
  RMDir $OLD_PATH

done:
FunctionEnd