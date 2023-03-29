; INITIALIZATION - ENVIROMENT
;{-----------------------------------------------
;
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#SingleInstance force ; Ensures that only the last executed instance of script is running
DetectHiddenWindows, On
;}

Run, %userprofile%/.config/hyperkey.ahk
Run, %userprofile%/.config/colemak_dh_iso.ahk
ExitApp
