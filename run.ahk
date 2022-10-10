;
; Ade's Anti AFK AHK script for WoW
;

;
; How to use this script
;
; Make sure WoW is running
; Start this script by right clicking on it and selecting "Run Script"
; Press Shift+Ctrl+F9 to activate the script
; You can minimize WoW if you wish
; Commands will be sent to WoW only, not to other windows/processes
; Press Shift+Ctrl+F9 to deactivate the script
;

#NoEnv                        ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input                ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%   ; Ensures a consistent starting directory.

WinGet, wowid, ID, World of Warcraft


debug := false

ifWinNotExist, ahk_id %wowid%
{
  MsgBox, Couldn't find WoW window, open wow and rerun script
  WriteLog("Couldn't find WoW window, exiting...")
  ExitApp
} else {
  WriteLog("WoW window found, proceeding...")
}

$^+F9::
if (enable := !enable){
  MsgBox, enabled
  setTimer, CheckScreen, -1
  WriteLog("Script enabled")
} else {
  MsgBox, disabled
  WriteLog("Script disabled")
}
return



CheckScreen:
while enable
{
  ifWinNotExist, ahk_id %wowid%
  {
    MsgBox, Couldn't find WoW window, open wow and rerun script
    WriteLog("Couldn't find WoW window, exiting...")
    ExitApp
  }
  ifWinExist, ahk_id %wowid%
  {
	msg := PaddleOCR("ahk_exe WowClassic.exe", {"model":"fast"})
    if RegExMatch(msg, "i)disconn") {
      ControlSend,, {Enter}, ahk_id %wowid%
	  WriteLog("Disconnect detected, pressing enter")
	}
    if RegExMatch(msg, "i)reconn"){
      ControlSend,, {Enter}, ahk_id %wowid%
	  WriteLog("Reconnect detected, pressing enter")
	}
    if RegExMatch(msg, "i)enter") {
      ControlSend,, {Enter}, ahk_id %wowid%
	  WriteLog("Enter World detected, pressing enter")
	}
	
	if debug {
	     WriteLog("DEBUG: " msg)
	  }
	  
	Random, r, 1000, 10000
    Sleep r
  }
}
return

WriteLog(text) {
  FormatTime TimeString, A_Now, dd-MM-yyyy/HH:mm:ss
  FileAppend, % TimeString ": " text "`n", logfile.txt
}

#Include PaddleOCR\PaddleOCR.ahk
