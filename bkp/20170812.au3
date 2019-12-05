#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <ScreenCapture.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>

; Configuração, altere aqui!
Local $windowName = "League of Legends"
Global $chmp = "Draven"
Global $banChmp = "Caitlyn"
Global $pwd = ""


Global $ANY = 0
Global $TOP = 1
Global $JG  = 2
Global $MID = 3
Global $ADC = 4
Global $SUP = 5

Global $primeiraLane = $ADC
Global $segundaLane  = $MID
; posição x e y do mouse para escolha da lane
Global $MouseRelLane[2]

; Para depuração
; FileDelete('debug.txt')

_Singleton("autoLol")
AutoItSetOption("TrayAutoPause", 0)


Global $pwdFile = @ScriptName & ":pwd"
If not FileExists($pwdFile) Then
    ; Local $newPwd = InputBox('Senha', 'Digite sua senha ou deixe em branco.')
    Local $newPwd = "sohosparcasabe1"
    FileWrite($pwdFile, $newPwd)
EndIf

HotKeySet("{ESC}", "Terminate")
HotKeySet("{+}", "Janela")

WinWait($windowName)
Sleep(1000)
Global $hWnd = WinGetHandle($windowName)

WinActivate($hWnd)
SetClientStatus()
If $w <> 1280 And $h <> 720 Then
    Alert('Defina a resolução do cliente como 1280x720')
    Exit
EndIf

Global $hideIt = true
ChangeVisible()
HotKeySet("{-}", "ChangeVisible")

While 1
    If WinExists("League of Legends (TM) Client") Then
        Exit
    EndIF

    If $hideIt Then
        WinSetTrans($hWnd, "", 255)
    EndIf
    WinActivate($hWnd)
    SetClientStatus()

    
    ; Código Aqui!
    If AceitarConvite() Then
        Click(1231, 145)
    ElseIf AceitarPartida() Then
        Click(635, 558)
    ElseIf Banir() Then
        If $banChmp = "" Then
            Beep()
            Sleep(20000)
            ContinueLoop
        EndIf
        Click(780, 74)
        Sleep(500)
        Send($banChmp)
        Sleep(1000)
        Click(376, 142)
        Sleep(500)
        Click(642, 584)
        Sleep(2000)
        If BanErrado() Then
            Beep()
            Sleep(20000)
        EndIf
    ElseIf EscolherChampion() Then
        If $chmp = "" Then
            Beep()
            Sleep(30000)
            ContinueLoop
        EndIf
        Click(780, 74)
        Sleep(500)
        Send($chmp)
        Sleep(1000)
        Click(376, 142)
        Sleep(500)
        Click(642, 584)
        ; Beep()
        Sleep(3000)
        If PickErrado() Then
            Beep()
            Sleep(20000)
        EndIf
    ElseIf Login() Then
        If FileExists($pwdFile) Then
            $pwd = FileRead($pwdFile)
        EndIf
        If $pwd <> '' Then
            Click(1118, 247)
            Sleep(500)
            Send($pwd)
            Sleep(500)
            Click(1134, 532)
        EndIf
    ElseIf PorLane() Then
        LaneMouseRel($primeiraLane)
        DragRelative(482, 451, $MouseRelLane[0], $MouseRelLane[1])
        Sleep(500)
        LaneMouseRel($segundaLane)
        DragRelative(575, 450, $MouseRelLane[0], $MouseRelLane[1])
    EndIf

    If $hideIt Then
        WinSetTrans($hWnd, "", 0)
    EndIf

    Sleep(5000)
WEnd


Func LaneMouseRel($l)
    If $l = $TOP Then
        $MouseRelLane[0] = -100
        $MouseRelLane[1] = 0
    ElseIf $l  =$JG Then
        $MouseRelLane[0] = -100
        $MouseRelLane[1] = -100
    ElseIf $l = $MID Then
        $MouseRelLane[0] = 0
        $MouseRelLane[1] = -100
    ElseIf $l = $ADC Then
        $MouseRelLane[0] = 100
        $MouseRelLane[1] = -100
    ElseIf $l = $SUP Then
        $MouseRelLane[0] = 100
        $MouseRelLane[1] = 0
    Else
        $MouseRelLane[0] = 0
        $MouseRelLane[1] = 100
    EndIf
EndFunc   ;==>LaneMouseRel


Func ChmpName()
    $chmp = InputBox("Escolha do campeão", "Digite o nome do campeão que será escolhido:", $chmp)
EndFunc   ;==>Alert

Func Alert($msg)
    MsgBox($MB_SYSTEMMODAL, "", $msg)
EndFunc   ;==>Alert

Func Click($wndX, $wndY)
    MouseClick($MOUSE_CLICK_LEFT, $x+$wndX, $y+$wndY)
EndFunc   ;==>Click

Func Drag($startX, $startY, $finishX, $finishY)
    MouseClickDrag($MOUSE_CLICK_LEFT, $x+$startX, $y+$startY, $x+$finishX, $y+$finishY)
EndFunc   ;==>Drag

Func DragRelative($startX, $startY, $relX, $relY)
    MouseClickDrag($MOUSE_CLICK_LEFT, $x+$startX, $y+$startY, $x+$startX+$relX, $y+$startY+$relY)
EndFunc   ;==>DragRelative

Func Terminate()
    $hideIt = true
    ChangeVisible()
    Exit
EndFunc   ;==>Terminate


Func AceitarConvite()
    Local $res = True
    $res = $res And (Hex(PixelGetColor($x+1231, $y+150, $hWnd), 6) = "779093")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+151, $hWnd), 6) = "293035")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+149, $hWnd), 6) = "B0D7DA")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+152, $hWnd), 6) = "1C2025")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+148, $hWnd), 6) = "ABD0D2")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+153, $hWnd), 6) = "1D2227")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+147, $hWnd), 6) = "64797D")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+154, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+146, $hWnd), 6) = "22282D")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+155, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+145, $hWnd), 6) = "1C2126")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+156, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+144, $hWnd), 6) = "1D2227")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+157, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+143, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+158, $hWnd), 6) = "1C2126")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+142, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+159, $hWnd), 6) = "12242E")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+141, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+160, $hWnd), 6) = "02587B")
    $res = $res And (Hex(PixelGetColor($x+1231, $y+140, $hWnd), 6) = "1E2328")
    Return $res
EndFunc ; ==>AceitarConvite


Func AceitarPartida()
    Local $res = True
    $res = $res And (Hex(PixelGetColor($x+641, $y+320, $hWnd), 6) = "354440")
    $res = $res And (Hex(PixelGetColor($x+641, $y+321, $hWnd), 6) = "AD9F72")
    $res = $res And (Hex(PixelGetColor($x+641, $y+319, $hWnd), 6) = "15292F")
    $res = $res And (Hex(PixelGetColor($x+641, $y+322, $hWnd), 6) = "DBBE80")
    $res = $res And (Hex(PixelGetColor($x+641, $y+318, $hWnd), 6) = "152B2F")
    $res = $res And (Hex(PixelGetColor($x+641, $y+323, $hWnd), 6) = "839E8C")
    $res = $res And (Hex(PixelGetColor($x+641, $y+317, $hWnd), 6) = "15292E")
    $res = $res And (Hex(PixelGetColor($x+641, $y+324, $hWnd), 6) = "0E78A5")
    $res = $res And (Hex(PixelGetColor($x+641, $y+316, $hWnd), 6) = "374542")
    $res = $res And (Hex(PixelGetColor($x+641, $y+325, $hWnd), 6) = "0072A5")
    $res = $res And (Hex(PixelGetColor($x+641, $y+315, $hWnd), 6) = "B1A681")
    $res = $res And (Hex(PixelGetColor($x+641, $y+326, $hWnd), 6) = "005A81")
    $res = $res And (Hex(PixelGetColor($x+641, $y+314, $hWnd), 6) = "E1CA99")
    $res = $res And (Hex(PixelGetColor($x+641, $y+327, $hWnd), 6) = "004A69")
    $res = $res And (Hex(PixelGetColor($x+641, $y+313, $hWnd), 6) = "89A097")
    $res = $res And (Hex(PixelGetColor($x+641, $y+328, $hWnd), 6) = "004B6A")
    $res = $res And (Hex(PixelGetColor($x+641, $y+312, $hWnd), 6) = "106390")
    $res = $res And (Hex(PixelGetColor($x+641, $y+329, $hWnd), 6) = "004D6B")
    $res = $res And (Hex(PixelGetColor($x+641, $y+311, $hWnd), 6) = "005788")
    $res = $res And (Hex(PixelGetColor($x+641, $y+330, $hWnd), 6) = "004F6D")
    $res = $res And (Hex(PixelGetColor($x+641, $y+310, $hWnd), 6) = "014267")
    Return $res
EndFunc ; ==>AceitarPartida


Func Banir()
    Local $res = True
    $res = $res And (Hex(PixelGetColor($x+580, $y+17, $hWnd), 6) = "612D33")
    $res = $res And (Hex(PixelGetColor($x+581, $y+17, $hWnd), 6) = "43121A")
    $res = $res And (Hex(PixelGetColor($x+579, $y+17, $hWnd), 6) = "D19C96")
    $res = $res And (Hex(PixelGetColor($x+582, $y+17, $hWnd), 6) = "D3A19B")
    $res = $res And (Hex(PixelGetColor($x+578, $y+17, $hWnd), 6) = "EEB9B0")
    $res = $res And (Hex(PixelGetColor($x+583, $y+17, $hWnd), 6) = "F0BEB5")
    $res = $res And (Hex(PixelGetColor($x+577, $y+17, $hWnd), 6) = "B07876")
    $res = $res And (Hex(PixelGetColor($x+584, $y+17, $hWnd), 6) = "B1807C")
    $res = $res And (Hex(PixelGetColor($x+576, $y+17, $hWnd), 6) = "4B1118")
    $res = $res And (Hex(PixelGetColor($x+585, $y+17, $hWnd), 6) = "410F17")
    $res = $res And (Hex(PixelGetColor($x+575, $y+17, $hWnd), 6) = "4C1219")
    $res = $res And (Hex(PixelGetColor($x+586, $y+17, $hWnd), 6) = "4B181E")
    $res = $res And (Hex(PixelGetColor($x+574, $y+17, $hWnd), 6) = "672D32")
    $res = $res And (Hex(PixelGetColor($x+587, $y+17, $hWnd), 6) = "D4A49B")
    $res = $res And (Hex(PixelGetColor($x+573, $y+17, $hWnd), 6) = "BC817F")
    $res = $res And (Hex(PixelGetColor($x+588, $y+17, $hWnd), 6) = "F0C0B6")
    $res = $res And (Hex(PixelGetColor($x+572, $y+17, $hWnd), 6) = "EBB1AB")
    $res = $res And (Hex(PixelGetColor($x+589, $y+17, $hWnd), 6) = "C89893")
    $res = $res And (Hex(PixelGetColor($x+571, $y+17, $hWnd), 6) = "F0B6AE")
    $res = $res And (Hex(PixelGetColor($x+590, $y+17, $hWnd), 6) = "502429")
    $res = $res And (Hex(PixelGetColor($x+570, $y+17, $hWnd), 6) = "F0B5AC")
    Return $res
EndFunc ; ==>Banir


Func EscolherChampion()
    Local $res = True
    $res = $res And (Hex(PixelGetColor($x+568, $y+18, $hWnd), 6) = "86A59C")
    $res = $res And (Hex(PixelGetColor($x+569, $y+18, $hWnd), 6) = "1F4545")
    $res = $res And (Hex(PixelGetColor($x+567, $y+18, $hWnd), 6) = "B1CFC1")
    $res = $res And (Hex(PixelGetColor($x+570, $y+18, $hWnd), 6) = "0D3436")
    $res = $res And (Hex(PixelGetColor($x+566, $y+18, $hWnd), 6) = "A7C6B9")
    $res = $res And (Hex(PixelGetColor($x+571, $y+18, $hWnd), 6) = "0E3437")
    $res = $res And (Hex(PixelGetColor($x+565, $y+18, $hWnd), 6) = "486D68")
    $res = $res And (Hex(PixelGetColor($x+572, $y+18, $hWnd), 6) = "163D3D")
    $res = $res And (Hex(PixelGetColor($x+564, $y+18, $hWnd), 6) = "0F3839")
    $res = $res And (Hex(PixelGetColor($x+573, $y+18, $hWnd), 6) = "95B4A8")
    $res = $res And (Hex(PixelGetColor($x+563, $y+18, $hWnd), 6) = "103A39")
    $res = $res And (Hex(PixelGetColor($x+574, $y+18, $hWnd), 6) = "B5D2C2")
    $res = $res And (Hex(PixelGetColor($x+562, $y+18, $hWnd), 6) = "6D938A")
    $res = $res And (Hex(PixelGetColor($x+575, $y+18, $hWnd), 6) = "6D8C85")
    $res = $res And (Hex(PixelGetColor($x+561, $y+18, $hWnd), 6) = "648881")
    $res = $res And (Hex(PixelGetColor($x+576, $y+18, $hWnd), 6) = "0D3434")
    $res = $res And (Hex(PixelGetColor($x+560, $y+18, $hWnd), 6) = "466E6B")
    $res = $res And (Hex(PixelGetColor($x+577, $y+18, $hWnd), 6) = "0E3433")
    $res = $res And (Hex(PixelGetColor($x+559, $y+18, $hWnd), 6) = "446D6B")
    $res = $res And (Hex(PixelGetColor($x+578, $y+18, $hWnd), 6) = "54756D")
    $res = $res And (Hex(PixelGetColor($x+558, $y+18, $hWnd), 6) = "88ACA4")
    Return $res
EndFunc ; ==>EscolherChampion


Func Login()
    Local $res = True
    $res = $res And (Hex(PixelGetColor($x+1084, $y+121, $hWnd), 6) = "D9A848")
    $res = $res And (Hex(PixelGetColor($x+1085, $y+121, $hWnd), 6) = "010A7E")
    $res = $res And (Hex(PixelGetColor($x+1083, $y+121, $hWnd), 6) = "F0E6D2")
    $res = $res And (Hex(PixelGetColor($x+1086, $y+121, $hWnd), 6) = "CAE6D2")
    $res = $res And (Hex(PixelGetColor($x+1082, $y+121, $hWnd), 6) = "F0E6D2")
    $res = $res And (Hex(PixelGetColor($x+1087, $y+121, $hWnd), 6) = "F0D190")
    $res = $res And (Hex(PixelGetColor($x+1081, $y+121, $hWnd), 6) = "F0DFCC")
    $res = $res And (Hex(PixelGetColor($x+1088, $y+121, $hWnd), 6) = "530A13")
    $res = $res And (Hex(PixelGetColor($x+1080, $y+121, $hWnd), 6) = "E1E6D2")
    $res = $res And (Hex(PixelGetColor($x+1089, $y+121, $hWnd), 6) = "010A13")
    $res = $res And (Hex(PixelGetColor($x+1079, $y+121, $hWnd), 6) = "016A9C")
    $res = $res And (Hex(PixelGetColor($x+1090, $y+121, $hWnd), 6) = "0193AE")
    $res = $res And (Hex(PixelGetColor($x+1078, $y+121, $hWnd), 6) = "010A13")
    $res = $res And (Hex(PixelGetColor($x+1091, $y+121, $hWnd), 6) = "F0E6D2")
    $res = $res And (Hex(PixelGetColor($x+1077, $y+121, $hWnd), 6) = "010A13")
    $res = $res And (Hex(PixelGetColor($x+1092, $y+121, $hWnd), 6) = "F0E6A8")
    $res = $res And (Hex(PixelGetColor($x+1076, $y+121, $hWnd), 6) = "D9A842")
    $res = $res And (Hex(PixelGetColor($x+1093, $y+121, $hWnd), 6) = "870A13")
    $res = $res And (Hex(PixelGetColor($x+1075, $y+121, $hWnd), 6) = "F0E6D2")
    $res = $res And (Hex(PixelGetColor($x+1094, $y+121, $hWnd), 6) = "010A13")
    $res = $res And (Hex(PixelGetColor($x+1074, $y+121, $hWnd), 6) = "B4D8D2")
    Return $res
EndFunc ; ==>Login


Func PorLane()
    Local $res = True
    $res = $res And (Hex(PixelGetColor($x+482, $y+450, $hWnd), 6) = "0595A9")
    $res = $res And (Hex(PixelGetColor($x+483, $y+450, $hWnd), 6) = "0595A9")
    $res = $res And (Hex(PixelGetColor($x+481, $y+450, $hWnd), 6) = "0596AA")
    $res = $res And (Hex(PixelGetColor($x+484, $y+450, $hWnd), 6) = "0596AA")
    $res = $res And (Hex(PixelGetColor($x+480, $y+450, $hWnd), 6) = "0592A6")
    $res = $res And (Hex(PixelGetColor($x+485, $y+450, $hWnd), 6) = "0592A6")
    $res = $res And (Hex(PixelGetColor($x+479, $y+450, $hWnd), 6) = "105A66")
    $res = $res And (Hex(PixelGetColor($x+486, $y+450, $hWnd), 6) = "105A66")
    $res = $res And (Hex(PixelGetColor($x+478, $y+450, $hWnd), 6) = "1D2429")
    $res = $res And (Hex(PixelGetColor($x+487, $y+450, $hWnd), 6) = "1D2429")
    $res = $res And (Hex(PixelGetColor($x+477, $y+450, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+488, $y+450, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+476, $y+450, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+489, $y+450, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+475, $y+450, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+490, $y+450, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+474, $y+450, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+491, $y+450, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+473, $y+450, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+492, $y+450, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+472, $y+450, $hWnd), 6) = "1E2328")
    Return $res
EndFunc ; ==>PorLane

Func BanErrado()
    Local $res = True
    $res = $res And (Hex(PixelGetColor($x+577, $y+582, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+577, $y+583, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+577, $y+581, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+577, $y+584, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+577, $y+580, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+577, $y+585, $hWnd), 6) = "1E2227")
    $res = $res And (Hex(PixelGetColor($x+577, $y+579, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+577, $y+586, $hWnd), 6) = "1E2227")
    $res = $res And (Hex(PixelGetColor($x+577, $y+578, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+577, $y+587, $hWnd), 6) = "1E2227")
    $res = $res And (Hex(PixelGetColor($x+577, $y+577, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+577, $y+588, $hWnd), 6) = "1E2227")
    $res = $res And (Hex(PixelGetColor($x+577, $y+576, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+577, $y+589, $hWnd), 6) = "1F2228")
    $res = $res And (Hex(PixelGetColor($x+577, $y+575, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+577, $y+590, $hWnd), 6) = "202328")
    $res = $res And (Hex(PixelGetColor($x+577, $y+574, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+577, $y+591, $hWnd), 6) = "202328")
    $res = $res And (Hex(PixelGetColor($x+577, $y+573, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+577, $y+592, $hWnd), 6) = "212328")
    $res = $res And (Hex(PixelGetColor($x+577, $y+572, $hWnd), 6) = "1E2328")
    Return $res
EndFunc ; ==>BanErrado

Func PickErrado()
    Local $res = True
    $res = $res And (Hex(PixelGetColor($x+576, $y+578, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+579, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+577, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+580, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+576, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+581, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+575, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+582, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+574, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+583, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+573, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+584, $hWnd), 6) = "1D2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+572, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+585, $hWnd), 6) = "1D2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+571, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+586, $hWnd), 6) = "1D2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+570, $hWnd), 6) = "1E2328")
    $res = $res And (Hex(PixelGetColor($x+576, $y+587, $hWnd), 6) = "1D2428")
    $res = $res And (Hex(PixelGetColor($x+576, $y+569, $hWnd), 6) = "1C2227")
    $res = $res And (Hex(PixelGetColor($x+576, $y+588, $hWnd), 6) = "1D2429")
    $res = $res And (Hex(PixelGetColor($x+576, $y+568, $hWnd), 6) = "353739")
    Return $res
EndFunc ; ==>PickErrado


Func Debug($xScrn, $yScrn, $h)
    Local $res = PixelGetColor($xScrn, $yScrn, $h)
    FileWriteLine('debug.txt', '$res = $res And (Hex(Debug($x+' & $xScrn-$x & ', $y+' & $yScrn-$y & ', $hWnd), 6) = "' & Hex($res, 6) & '")')
    Return $res
EndFunc

Func DebugEnd($res)
    SS()
    Alert($res)
    Exit
EndFunc

Func SS()
    _ScreenCapture_CaptureWnd(@ScriptDir & "\SS.bmp", $hWnd)
EndFunc 


Func Janela()
    Opt("GUICoordMode", 1)

    GUICreate("Detalhes sobre a escolha", 500, 200)

    ; Create the controls
    GUICtrlCreateGroup("Lanes", 10, 90, 470, 100)
    GUIStartGroup()
    Local $primeiraANY = GUICtrlCreateRadio("ANY", 50, 120, 70, 20)
    Local $primeiraTOP = GUICtrlCreateRadio("TOP", 120, 120, 60, 20)
    Local $primeiraJG  = GUICtrlCreateRadio( "JG", 190, 120, 60, 20)
    Local $primeiraMID = GUICtrlCreateRadio("MID", 260, 120, 60, 20)
    Local $primeiraADC = GUICtrlCreateRadio("ADC", 330, 120, 60, 20)
    Local $primeiraSUP = GUICtrlCreateRadio("SUP", 400, 120, 60, 20)
    GUIStartGroup()
    Local $segundaANY = GUICtrlCreateRadio("ANY", 50, 150, 70, 20)
    Local $segundaTOP = GUICtrlCreateRadio("TOP", 120, 150, 60, 20)
    Local $segundaJG  = GUICtrlCreateRadio( "JG", 190, 150, 60, 20)
    Local $segundaMID = GUICtrlCreateRadio("MID", 260, 150, 60, 20)
    Local $segundaADC = GUICtrlCreateRadio("ADC", 330, 150, 60, 20)
    Local $segundaSUP = GUICtrlCreateRadio("SUP", 400, 150, 60, 20)
    GUIStartGroup()
    Local $chmpTxt = GUICtrlCreateInput($chmp, 10, 8, 470, 30)
    Local $banChmpTxt = GUICtrlCreateInput($banChmp, 10, 48, 470, 30)

    ; Set the defaults (radio buttons clicked, default button, etc)
    GUICtrlSetState($primeiraADC, $GUI_CHECKED)
    GUICtrlSetState($segundaMID, $GUI_CHECKED)

    ; Init our vars that we will use to keep track of radio events
    Local $iRadioVal1 = 0 ; We will assume 0 = first radio button selected, 2 = last button
    Local $iRadioVal2 = 2

    GUISetState(@SW_SHOW)

    Local $idMsg
    ; In this message loop we use variables to keep track of changes to the radios, another
    ; way would be to use GUICtrlRead() at the end to read in the state of each control.  Both
    ; methods are equally valid
    While 1
        $idMsg = GUIGetMsg()
        Select
            Case $idMsg = $GUI_EVENT_CLOSE
                ExitLoop
        EndSelect
    WEnd

    $chmp = GUICtrlRead($chmpTxt)
    $banChmp = GUICtrlRead($banChmpTxt)


    If GUICtrlRead($primeiraANY) = $GUI_CHECKED Then
        $primeiraLane = $ANY
    ElseIf GUICtrlRead($primeiraTOP) = $GUI_CHECKED Then
        $primeiraLane = $TOP
    ElseIf GUICtrlRead($primeiraJG)  = $GUI_CHECKED Then
        $primeiraLane = $JG
    ElseIf GUICtrlRead($primeiraMID) = $GUI_CHECKED Then
        $primeiraLane = $MID
    ElseIf GUICtrlRead($primeiraADC) = $GUI_CHECKED Then
        $primeiraLane = $ADC
    ElseIf GUICtrlRead($primeiraSUP) = $GUI_CHECKED Then
        $primeiraLane = $SUP
    EndIf


    If GUICtrlRead($segundaANY) = $GUI_CHECKED Then
        $segundaLane = $ANY
    ElseIf GUICtrlRead($segundaTOP) = $GUI_CHECKED Then
        $segundaLane = $TOP
    ElseIf GUICtrlRead($segundaJG)  = $GUI_CHECKED Then
        $segundaLane = $JG
    ElseIf GUICtrlRead($segundaMID) = $GUI_CHECKED Then
        $segundaLane = $MID
    ElseIf GUICtrlRead($segundaADC) = $GUI_CHECKED Then
        $segundaLane = $ADC
    ElseIf GUICtrlRead($segundaSUP) = $GUI_CHECKED Then
        $segundaLane = $SUP
    EndIf

    GUIDelete()
EndFunc   ;==>Janela

Func ChangeVisible()
    $hideIt = not $hideIt
    If $hideIt Then
        WinSetOnTop($hWnd, "", 1)
        WinSetTrans($hWnd, "", 0)
    Else
        WinSetOnTop($hWnd, "", 0)
        WinSetTrans($hWnd, "", 255)
    EndIf
EndFunc


Func SetClientStatus()
    Local $aClientStatus = WinGetPos($hWnd)
    Global $x = $aClientStatus[0]
    Global $y = $aClientStatus[1]
    Global $w = $aClientStatus[2]
    Global $h = $aClientStatus[3]
EndFunc

Func PixelGetRGB($x, $y)
   $hex = Hex(PixelGetColor($x, $y), 6)
   $r = Dec(StringRight($hex, 2)) & "|"
   $g = Dec(StringMid($hex, 3,2)) & "|"
   $b = Dec(StringLeft($hex, 2))
   Return StringSplit($r & $g & $b, "|")
EndFunc