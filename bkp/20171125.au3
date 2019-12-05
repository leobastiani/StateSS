#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <ScreenCapture.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>


; Configuração, altere aqui!
Global $DEBUG = UBound($CmdLine) > 1
Local $windowName = "League of Legends"
Global $chmp = Record("chmp", 'r', "Draven")
Global $banChmp = Record("banChmp", 'r', "Tristana")
Global $pwd = ""
Global $Tolerancy = 10


Global $ANY = 0
Global $TOP = 1
Global $JG  = 2
Global $MID = 3
Global $ADC = 4
Global $SUP = 5

Global $primeiraLane = Int(Record("primeiraLane", 'r', $ADC))
Global $segundaLane  = Int(Record("segundaLane", 'r', $MID))

; posição x e y do mouse para escolha da lane
Global $MouseRelLane[2]

; Para depuração
If $DEBUG Then
    FileDelete('debug.txt')
EndIf

_Singleton("autoLol")
AutoItSetOption("TrayAutoPause", 0)


Global $pwdFile = @ScriptName & ":pwd"
If not FileExists($pwdFile) Then
    If FileExists('pwd.txt') Then
        $newPwd = FileRead('pwd.txt')
    Else
        $newPwd = InputBox('Senha', 'Digite sua senha ou deixe em branco.')
    EndIf
    FileWrite($pwdFile, $newPwd)
EndIf

Global $JanelaOpened = False
HotKeySet("{9}", "Terminate")
Global $Permanent = False
HotKeySet("{+}", "Janela")
HotKeySet("^{+}", "JanelaPermanent")
Global $zeroToggle = False
HotKeySet("{0}", "ToggleWindow")

WinWait($windowName)
SleepDebug(1000)

Global $w = 0
Global $h = 0
While $w <> 1280 and $h <> 720
    Global $hWnd = WinGetHandle($windowName)
    SetClientStatus()
    Sleep(500)
WEnd


If $DEBUG Then
    Alert('DEPURANDO')
Else
    WinActivate($hWnd)
EndIf
SleepDebug(1000)


Global $hideIt = true
ChangeVisible()
HotKeySet("{-}", "ChangeVisible")

While 1
    If not WinExists($hWnd) Then
        Exit
    EndIf

    If WinExists("League of Legends (TM) Client", "") Then
        Terminate()
    EndIF

    If not WinActive($hWnd) Then
        Sleep(1000)
        ContinueLoop
    EndIf

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
        Send($banChmp, 1)
        Sleep(1000)
        Click(376, 142)
        Sleep(1500)
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
        Send($chmp, 1)
        Sleep(1000)
        Click(376, 142)
        Sleep(1500)
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
            Send($pwd, 1)
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

    If $DEBUG Then
        Terminate()
    EndIf

    If $zeroToggle Then
        $zeroToggle = False
        WinSetState($hWnd, "text", @SW_MINIMIZE)
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
    If $JanelaOpened Then
        Return
    EndIf
    $hideIt = true
    ChangeVisible()
    Exit
EndFunc   ;==>Terminate

Func SleepDebug($time)
    If not $DEBUG Then
        Sleep($time)
    EndIf
EndFunc   ;==>Terminate



Func AceitarConvite()
    Debug('AceitarConvite')
    Local $res = True
    $res = ComparePixel($res, $x+1231, $y+150, "779093")
    $res = ComparePixel($res, $x+1231, $y+151, "293035")
    $res = ComparePixel($res, $x+1231, $y+149, "B0D7DA")
    $res = ComparePixel($res, $x+1231, $y+152, "1C2025")
    $res = ComparePixel($res, $x+1231, $y+148, "ABD0D2")
    $res = ComparePixel($res, $x+1231, $y+153, "1D2227")
    $res = ComparePixel($res, $x+1231, $y+147, "64797D")
    $res = ComparePixel($res, $x+1231, $y+154, "1E2328")
    $res = ComparePixel($res, $x+1231, $y+146, "22282D")
    $res = ComparePixel($res, $x+1231, $y+155, "1E2328")
    $res = ComparePixel($res, $x+1231, $y+145, "1C2126")
    $res = ComparePixel($res, $x+1231, $y+156, "1E2328")
    $res = ComparePixel($res, $x+1231, $y+144, "1D2227")
    $res = ComparePixel($res, $x+1231, $y+157, "1E2328")
    $res = ComparePixel($res, $x+1231, $y+143, "1E2328")
    $res = ComparePixel($res, $x+1231, $y+158, "1C2126")
    $res = ComparePixel($res, $x+1231, $y+142, "1E2328")
    $res = ComparePixel($res, $x+1231, $y+159, "12242E")
    $res = ComparePixel($res, $x+1231, $y+141, "1E2328")
    $res = ComparePixel($res, $x+1231, $y+160, "02587B")
    $res = ComparePixel($res, $x+1231, $y+140, "1E2328")
    If $DEBUG Then
        FileWriteLine('debug.txt', $res)
    EndIf
    Return $res
EndFunc ; ==>AceitarConvite


Func AceitarPartida()
    Debug('AceitarPartida')
    Local $res = True
    $res = ComparePixel($res, $x+641, $y+320, "354440")
    $res = ComparePixel($res, $x+641, $y+321, "AD9F72")
    $res = ComparePixel($res, $x+641, $y+319, "15292F")
    $res = ComparePixel($res, $x+641, $y+322, "DBBE80")
    $res = ComparePixel($res, $x+641, $y+318, "152B2F")
    $res = ComparePixel($res, $x+641, $y+323, "839E8C")
    $res = ComparePixel($res, $x+641, $y+317, "15292E")
    $res = ComparePixel($res, $x+641, $y+324, "0E78A5")
    $res = ComparePixel($res, $x+641, $y+316, "374542")
    $res = ComparePixel($res, $x+641, $y+325, "0072A5")
    $res = ComparePixel($res, $x+641, $y+315, "B1A681")
    $res = ComparePixel($res, $x+641, $y+326, "005A81")
    $res = ComparePixel($res, $x+641, $y+314, "E1CA99")
    $res = ComparePixel($res, $x+641, $y+327, "004A69")
    $res = ComparePixel($res, $x+641, $y+313, "89A097")
    $res = ComparePixel($res, $x+641, $y+328, "004B6A")
    $res = ComparePixel($res, $x+641, $y+312, "106390")
    $res = ComparePixel($res, $x+641, $y+329, "004D6B")
    $res = ComparePixel($res, $x+641, $y+311, "005788")
    $res = ComparePixel($res, $x+641, $y+330, "004F6D")
    $res = ComparePixel($res, $x+641, $y+310, "014267")
    If $DEBUG Then
        FileWriteLine('debug.txt', $res)
    EndIf
    Return $res
EndFunc ; ==>AceitarPartida


Func Banir()
    Debug('Banir')
    Local $res = True
    $res = ComparePixel($res, $x+580, $y+17, "612D33")
    $res = ComparePixel($res, $x+581, $y+17, "43121A")
    $res = ComparePixel($res, $x+579, $y+17, "D19C96")
    $res = ComparePixel($res, $x+582, $y+17, "D3A19B")
    $res = ComparePixel($res, $x+578, $y+17, "EEB9B0")
    $res = ComparePixel($res, $x+583, $y+17, "F0BEB5")
    $res = ComparePixel($res, $x+577, $y+17, "B07876")
    $res = ComparePixel($res, $x+584, $y+17, "B1807C")
    $res = ComparePixel($res, $x+576, $y+17, "4B1118")
    $res = ComparePixel($res, $x+585, $y+17, "410F17")
    $res = ComparePixel($res, $x+575, $y+17, "4C1219")
    $res = ComparePixel($res, $x+586, $y+17, "4B181E")
    $res = ComparePixel($res, $x+574, $y+17, "672D32")
    $res = ComparePixel($res, $x+587, $y+17, "D4A49B")
    $res = ComparePixel($res, $x+573, $y+17, "BC817F")
    $res = ComparePixel($res, $x+588, $y+17, "F0C0B6")
    $res = ComparePixel($res, $x+572, $y+17, "EBB1AB")
    $res = ComparePixel($res, $x+589, $y+17, "C89893")
    $res = ComparePixel($res, $x+571, $y+17, "F0B6AE")
    $res = ComparePixel($res, $x+590, $y+17, "502429")
    $res = ComparePixel($res, $x+570, $y+17, "F0B5AC")
    If $DEBUG Then
        FileWriteLine('debug.txt', $res)
    EndIf
    Return $res
EndFunc ; ==>Banir


Func EscolherChampion()
    Debug('EscolherChampion')
    Local $res = True
    $res = ComparePixel($res, $x+580, $y+17, "0C3338")
    $res = ComparePixel($res, $x+581, $y+17, "6F8F88")
    $res = ComparePixel($res, $x+579, $y+17, "8AA99F")
    $res = ComparePixel($res, $x+582, $y+17, "BCD7C6")
    $res = ComparePixel($res, $x+578, $y+17, "8AA9A0")
    $res = ComparePixel($res, $x+583, $y+17, "ACC8BA")
    $res = ComparePixel($res, $x+577, $y+17, "032B32")
    $res = ComparePixel($res, $x+584, $y+17, "3D605F")
    $res = ComparePixel($res, $x+576, $y+17, "2A5153")
    $res = ComparePixel($res, $x+585, $y+17, "022A31")
    $res = ComparePixel($res, $x+575, $y+17, "9EBDB0")
    $res = ComparePixel($res, $x+586, $y+17, "6B8B84")
    $res = ComparePixel($res, $x+574, $y+17, "ACCABD")
    $res = ComparePixel($res, $x+587, $y+17, "BFD8C7")
    $res = ComparePixel($res, $x+573, $y+17, "4C706F")
    $res = ComparePixel($res, $x+588, $y+17, "A8C3B4")
    $res = ComparePixel($res, $x+572, $y+17, "032B34")
    $res = ComparePixel($res, $x+589, $y+17, "224649")
    $res = ComparePixel($res, $x+571, $y+17, "4B706E")
    $res = ComparePixel($res, $x+590, $y+17, "305453")
    $res = ComparePixel($res, $x+570, $y+17, "80A199")
    If $DEBUG Then
        FileWriteLine('debug.txt', $res)
    EndIf
    Return $res
EndFunc ; ==>EscolherChampion


Func Login()
    Debug('Login')
    Local $res = True
    $res = ComparePixel($res, $x+1084, $y+121, "D9A848")
    $res = ComparePixel($res, $x+1085, $y+121, "010A7E")
    $res = ComparePixel($res, $x+1083, $y+121, "F0E6D2")
    $res = ComparePixel($res, $x+1086, $y+121, "CAE6D2")
    $res = ComparePixel($res, $x+1082, $y+121, "F0E6D2")
    $res = ComparePixel($res, $x+1087, $y+121, "F0D190")
    $res = ComparePixel($res, $x+1081, $y+121, "F0DFCC")
    $res = ComparePixel($res, $x+1088, $y+121, "530A13")
    $res = ComparePixel($res, $x+1080, $y+121, "E1E6D2")
    $res = ComparePixel($res, $x+1089, $y+121, "010A13")
    $res = ComparePixel($res, $x+1079, $y+121, "016A9C")
    $res = ComparePixel($res, $x+1090, $y+121, "0193AE")
    $res = ComparePixel($res, $x+1078, $y+121, "010A13")
    $res = ComparePixel($res, $x+1091, $y+121, "F0E6D2")
    $res = ComparePixel($res, $x+1077, $y+121, "010A13")
    $res = ComparePixel($res, $x+1092, $y+121, "F0E6A8")
    $res = ComparePixel($res, $x+1076, $y+121, "D9A842")
    $res = ComparePixel($res, $x+1093, $y+121, "870A13")
    $res = ComparePixel($res, $x+1075, $y+121, "F0E6D2")
    $res = ComparePixel($res, $x+1094, $y+121, "010A13")
    $res = ComparePixel($res, $x+1074, $y+121, "B4D8D2")
    If $DEBUG Then
        FileWriteLine('debug.txt', $res)
    EndIf
    Return $res
EndFunc ; ==>Login


Func PorLane()
    Debug('PorLane')
    Local $res = True
    $res = ComparePixel($res, $x+482, $y+451, "115A66")
    $res = ComparePixel($res, $x+483, $y+451, "115A66")
    $res = ComparePixel($res, $x+481, $y+451, "1D262B")
    $res = ComparePixel($res, $x+484, $y+451, "1D262B")
    $res = ComparePixel($res, $x+480, $y+451, "1E2328")
    $res = ComparePixel($res, $x+485, $y+451, "1E2328")
    $res = ComparePixel($res, $x+479, $y+451, "1E2328")
    $res = ComparePixel($res, $x+486, $y+451, "1E2328")
    $res = ComparePixel($res, $x+478, $y+451, "1E2328")
    $res = ComparePixel($res, $x+487, $y+451, "1E2328")
    $res = ComparePixel($res, $x+477, $y+451, "1E2328")
    $res = ComparePixel($res, $x+488, $y+451, "1E2328")
    $res = ComparePixel($res, $x+476, $y+451, "1E2328")
    $res = ComparePixel($res, $x+489, $y+451, "1E2328")
    $res = ComparePixel($res, $x+475, $y+451, "1E2328")
    $res = ComparePixel($res, $x+490, $y+451, "1E2328")
    $res = ComparePixel($res, $x+474, $y+451, "1E2328")
    $res = ComparePixel($res, $x+491, $y+451, "1E2328")
    $res = ComparePixel($res, $x+473, $y+451, "1E2328")
    $res = ComparePixel($res, $x+492, $y+451, "1E2328")
    $res = ComparePixel($res, $x+472, $y+451, "1E2328")
    If $DEBUG Then
        FileWriteLine('debug.txt', $res)
    EndIf
    Return $res
EndFunc ; ==>PorLane

Func BanErrado()
    Debug('BanErrado')
    Local $res = True
    $res = ComparePixel($res, $x+577, $y+582, "1E2328")
    $res = ComparePixel($res, $x+577, $y+583, "1E2328")
    $res = ComparePixel($res, $x+577, $y+581, "1E2328")
    $res = ComparePixel($res, $x+577, $y+584, "1E2328")
    $res = ComparePixel($res, $x+577, $y+580, "1E2328")
    $res = ComparePixel($res, $x+577, $y+585, "1E2227")
    $res = ComparePixel($res, $x+577, $y+579, "1E2328")
    $res = ComparePixel($res, $x+577, $y+586, "1E2227")
    $res = ComparePixel($res, $x+577, $y+578, "1E2328")
    $res = ComparePixel($res, $x+577, $y+587, "1E2227")
    $res = ComparePixel($res, $x+577, $y+577, "1E2328")
    $res = ComparePixel($res, $x+577, $y+588, "1E2227")
    $res = ComparePixel($res, $x+577, $y+576, "1E2328")
    $res = ComparePixel($res, $x+577, $y+589, "1F2228")
    $res = ComparePixel($res, $x+577, $y+575, "1E2328")
    $res = ComparePixel($res, $x+577, $y+590, "202328")
    $res = ComparePixel($res, $x+577, $y+574, "1E2328")
    $res = ComparePixel($res, $x+577, $y+591, "202328")
    $res = ComparePixel($res, $x+577, $y+573, "1E2328")
    $res = ComparePixel($res, $x+577, $y+592, "212328")
    $res = ComparePixel($res, $x+577, $y+572, "1E2328")
    If $DEBUG Then
        FileWriteLine('debug.txt', $res)
    EndIf
    Return $res
EndFunc ; ==>BanErrado

Func PickErrado()
    Debug('PickErrado')
    Local $res = True
    $res = ComparePixel($res, $x+576, $y+578, "1E2328")
    $res = ComparePixel($res, $x+576, $y+579, "1E2328")
    $res = ComparePixel($res, $x+576, $y+577, "1E2328")
    $res = ComparePixel($res, $x+576, $y+580, "1E2328")
    $res = ComparePixel($res, $x+576, $y+576, "1E2328")
    $res = ComparePixel($res, $x+576, $y+581, "1E2328")
    $res = ComparePixel($res, $x+576, $y+575, "1E2328")
    $res = ComparePixel($res, $x+576, $y+582, "1E2328")
    $res = ComparePixel($res, $x+576, $y+574, "1E2328")
    $res = ComparePixel($res, $x+576, $y+583, "1E2328")
    $res = ComparePixel($res, $x+576, $y+573, "1E2328")
    $res = ComparePixel($res, $x+576, $y+584, "1D2328")
    $res = ComparePixel($res, $x+576, $y+572, "1E2328")
    $res = ComparePixel($res, $x+576, $y+585, "1D2328")
    $res = ComparePixel($res, $x+576, $y+571, "1E2328")
    $res = ComparePixel($res, $x+576, $y+586, "1D2328")
    $res = ComparePixel($res, $x+576, $y+570, "1E2328")
    $res = ComparePixel($res, $x+576, $y+587, "1D2428")
    $res = ComparePixel($res, $x+576, $y+569, "1C2227")
    $res = ComparePixel($res, $x+576, $y+588, "1D2429")
    $res = ComparePixel($res, $x+576, $y+568, "353739")
    If $DEBUG Then
        FileWriteLine('debug.txt', $res)
    EndIf
    Return $res
EndFunc ; ==>PickErrado


Func Debug($fnName)
    FileWriteLine('debug.txt', @CRLF & @CRLF & $fnName)
EndFunc

Func DebugEnd($res)
    SS()
    Alert($res)
    Exit
EndFunc

Func SS()
    _ScreenCapture_CaptureWnd(@ScriptDir & "\SS.bmp", $hWnd)
EndFunc 


Func JanelaRender()
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
    $hex = GetHexPixel($x, $y)
    Return HexToRGB($hex)
EndFunc

Func GetHexPixel($x, $y)
    Return Hex(PixelGetColor($x, $y), 6)
EndFunc

Func HexToRGB($hex)
    ; Os valores estão nos indices 1, 2 e 3
    ; ignorar o indice 0
    $r = Dec(StringLeft($hex, 2)) & "|"
    $g = Dec(StringMid($hex, 3,2)) & "|"
    $b = Dec(StringRight($hex, 2))
    Return StringSplit($r & $g & $b, "|")
EndFunc

Func ComparePixel($res, $x, $y, $CompareVal)
    If not $DEBUG And not $res Then
        Return False
    EndIf

    $CompareArr = HexToRGB($CompareVal)
    $PixelArr = PixelGetRGB($x, $y)
    If $DEBUG Then
        FileWriteLine('debug.txt', '. Esperado: ' & $CompareVal & 'PixelGetColor: ' & GetHexPixel($x, $y))
    EndIf
    For $i = 1 To 3
        If Abs($CompareArr[$i] - $PixelArr[$i]) > $Tolerancy Then
            Return False
        EndIf
    Next
    
    If not $res Then
        Return False
    EndIf
    Return True
EndFunc

Func ToggleWindow()
    $zeroToggle = True
    WinActivate($hWnd)
EndFunc

Func Janela()
    $JanelaOpened = True
    JanelaRender()
    $JanelaOpened = False
EndFunc

Func JanelaPermanent()
    Janela()
    Record("chmp", 'w', $chmp)
    Record("banChmp", 'w', $banChmp)
    Record("primeiraLane", 'w', $primeiraLane)
    Record("segundaLane", 'w', $segundaLane)
EndFunc

Func Record($Name, $Op, $Content)
    $f = @ScriptName & ":" & $Name
    If $Op = 'w' Then
        FileWrite($f, $Content)
        Return $Content
    EndIf
    If not FileExists($f) Then
        Return $Content
    EndIf
    Return FileRead($f)
EndFunc