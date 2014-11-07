;/******************************************************************************
;**
;* FILE: 	digraphs.ahk
;* PRODUCT:	Tools
;* AUTHOR: 	Ingo Karkat <ingo@karkat.de>
;* DATE CREATED:14-Apr-2010
;*
;*******************************************************************************
;* DESCRIPTION: 
;   The Vi Improved editor (Vim) allows to enter special characters through the
;   digraph submode: Press Ctrl-K followed by two keys, and a special character
;   is inserted in its place, e.g. <Ctrl-K> A t => @). This is useful to enter
;   characters (like umlauts, currency and typographical symbols) that are not
;   represented on the current keyboard layout. It is often faster than
;   completely switching to a different keyboard layout (if configured at all). 
;
;* USAGE: 
;   Press Ctrl-K, followed by two keys. 
;   If an unknown digraph is entered, the last character is used. 
;
;   The hotkey is not active for applications that handle the digraphs
;   themselves (or host / embed such applications).
;
;* CONFIGURATION:
;   Additional digraphs can be added by modifying this script. See below for
;   "Enter additional digraphs here." 
;
;* REMARKS: 

;* TODO: 
;   - Implement escaping = pass through of CTRL-K (e.g. via CTRL-K CTRL-K). 
;       	
;* Copyright: (C) 2010 Ingo Karkat
;   This program is free software; you can redistribute it and/or modify it
;   under the terms of the GNU General Public License.
;   See http://www.gnu.org/copyleft/gpl.txt 
;
;* REVISION	DATE		REMARKS 
;   1.01.004	21-Dec-2010	Added exception for Vim within Windows console
;				and Console2. 
;   1.00.003	17-Jun-2010	Added Remote Desktop Connection for Windows
;				XP/Vista. 
;				Published script. 
;	002	15-Apr-2010	Supporting GTK applications through sending
;				CTRL-SHIFT-U + hex code, as the default send
;				doesn't work for non-ASCII characters. 
;				Using SendInput instead of the (for the GTK
;				combo) noticeably slower Send.  
;	001	14-Apr-2010	file creation
;******************************************************************************/

; Do not install the hotkey for applications that handle the digraphs themselves
; (or host / embed such applications). 
SetTitleMatchMode 2 ; The "VIM" typically appears at the end of the window title, depending on Vim's 'titlestring' setting. 
GroupAdd NativeDigraphApps, VIM ahk_class ConsoleWindowClass ; Vim within the Windows console
GroupAdd NativeDigraphApps, VIM ahk_class Console_2_Main ; Vim within Console2
GroupAdd NativeDigraphApps, ahk_class PuTTY
GroupAdd NativeDigraphApps, ahk_class TSSHELLWND ; Remote Desktop Connection, Windows XP/Vista
GroupAdd NativeDigraphApps, ahk_class TscShellContainerClass ; Remote Desktop Connection, Windows 7
GroupAdd NativeDigraphApps, ahk_class Vim
GroupAdd NativeDigraphApps, ahk_class Xming X

#IfWinNotActive ahk_group NativeDigraphApps
^k::
{
    ; Case sensitive, Ignore script-generated input, Limit length to 2 keys, Recognize CTRL-modified keystrokes. 
    Input, Digraph, C I L2 M

    if ErrorLevel != Max
	return
    else if ErrorLevel = Timeout
    {
	Send, %Digraph%
	return
    }
    else if ErrorLevel = NewInput
	return

    ; MsgBox, You entered "%Digraph%" here.

    Code =
    ; Digraph definitions
    if (Digraph == "ae") {
	Char = ä
	Code = 00e4
    } else if (Digraph == "oe") {
	Char = ö
	Code = 00f6
    } else if (Digraph == "ue") {
	Char = ü
	Code = 00fc
    } else if (Digraph == "Ae") {
	Char = Ä
	Code = 00c4
    } else if (Digraph == "Oe") {
	Char = Ö
	Code = 00d6
    } else if (Digraph == "Ue") {
	Char = Ü
	Code = 00dc
    } else if (Digraph == "ss") {
	Char = ß
	Code = 00df
    } else if (Digraph == "<<") {
	Char = «
	Code = 00ab
    } else if (Digraph == ">>") {
	Char = »
	Code = 00bb
    } else if (Digraph == "DG") {
	Char = °
	Code = 00b0
    } else if (Digraph == "--") {
	Char = ­
	Code = 00ad
    } else if (Digraph == "1S") {
	Char = ¹
	Code = 00b9
    } else if (Digraph == "2S") {
	Char = ²
	Code = 00b2
    } else if (Digraph == "3S") {
	Char = ³
	Code = 00b3
    } else if (Digraph == "14") {
	Char = ¼
	Code = 00bc
    } else if (Digraph == "12") {
	Char = ½
	Code = 00bd
    } else if (Digraph == "34") {
	Char = ¾
	Code = 00be
; Enter additional digraphs here. 
; Define both the UTF-8 character (Char) and the hexadecimal code (Code)
;    } else if (Digraph == "XY") {
;	Char = X
;	Code = 00ab
    } else {
	; Unknown digraph, use the last key only. 
	StringRight, LastChar, Digraph, 1
	Char = %LastChar%
    }

    ; GTK application windows (e.g. Pidgin) do not accept non-ASCII characters
    ; when sent this way; neither does ALT+code (e.g. ALT+0228 = ä) work. 
    ; Cp. https://bugzilla.gnome.org/show_bug.cgi?id=371371
    ; The way to input non-ASCII characters is via CTRL-SHIFT-U, followed by the
    ; (2/4-digit) hexadecimal code, concluded with <Space> or <CR>. 
    ; Source: http://www.theworldofstuff.com/characters/
    IfWinActive ahk_class gdkWindowToplevel
    {
	if (Code == "")
	    SendInput, %Char%
	else
	    SendInput, ^U%Code%{Space}
    }
    else
    {
	SendInput, %Char%
    }
    return
}

