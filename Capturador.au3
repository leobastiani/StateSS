#include <ScreenCapture.au3>
#include <MsgBoxConstants.au3>

; Configuração, altere aqui!
Local $windowName = "League of Legends"


WinWait($windowName, "", 10)
Local $hWnd = WinGetHandle($windowName)
; Alert($hWnd)

WinActivate($hWnd)

Local $aClientStatus = WinGetPos($hWnd)
Global $x = $aClientStatus[0]
Global $y = $aClientStatus[1]
Global $w = $aClientStatus[2]
Global $h = $aClientStatus[3]

Global $i = 1

; Local $iColor = PixelGetColor($x+100, $y+100, $hWnd)
; Alert(Hex($iColor, 6))
; WinSetTrans($hWnd, "", 255)





HotKeySet("{+}", "Print")
HotKeySet("{ESC}", "Terminate")
Alert("Aperta SHIFT+= para uma nova SS" & @CRLF & "Aperte ESC para terminar.")

While 1
    Sleep(1000)
WEnd


; WinWait("League of Legends")
; Run('cmdow "Dell Audio" /hid')
; Sleep(3000)
; ControlClick("Dell Audio", "", "[CLASS:Button; INSTANCE:13]")
; Run('cmdow "Dell Audio" /vis')
; WinClose("Dell Audio")
; WinWaitClose("Dell Audio")


Func Alert($msg)
    MsgBox($MB_SYSTEMMODAL, "", $msg)
EndFunc


Func Print($msg)
    ; Captura uma screenshot do programa
    _ScreenCapture_CaptureWnd(@ScriptDir & "\SS.bmp", $hWnd)
    FileMove("SS.bmp", InputBox("Nome do arquivo " & $i, "Digite o nome do arquivo:", $i) & ".bmp")
    $i += 1
EndFunc


Func Terminate()
    Exit
EndFunc   ;==>Terminate