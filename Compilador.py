#!python3
#encoding=utf-8

# config
prjPath = 'D:\\dev\\StateSS\\Projects\\LoLPicker';
windowName = 'League of Legends'
interval = 5

import glob
import re
import sys
import os
from pathlib import Path

fns = []
fnNames = []

def hexStr(b):
    h = hex(b)[2:]
    return '0'*(2-len(h))+h.upper()

for txt in glob.glob(prjPath+'\\*.txt'):
    with open(txt, 'r', encoding='utf-8') as file:
        content = file.read()

    pixels = re.split('[\r\n]+', content)
    # remove o último se vazio
    pixels.remove('')
    path = Path(txt)
    basename = os.path.basename(txt)
    fnName = os.path.splitext(basename)[0]
    fnNames.append(fnName)
    fn = ['Func '+fnName+'()', '    Local $res = True']
    for pixelStr in pixels:
        pixel = [int(x) for x in pixelStr.split(' ')]
        x = pixel[0]
        y = pixel[1]
        r = hexStr(pixel[2])
        g = hexStr(pixel[3])
        b = hexStr(pixel[4])
        rgb = r+g+b
        fn.append('    $res = $res And (Hex(PixelGetColor($x+'+str(x)+', $y+'+str(y)+', $hWnd), 6) = "'+rgb+'")')

    fn.append('    Return $res')
    fn.append('EndFunc ; ==>'+fnName)

    fn = '\n'.join(fn)
    fns.append(fn)

content = '''#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <ScreenCapture.au3>

; Configuração, altere aqui!
Local $windowName = "League of Legends"


HotKeySet("{ESC}", "Terminate")

WinWait($windowName, "", 100)
Global $hWnd = WinGetHandle($windowName)


WinActivate($hWnd)
Local $aClientStatus = WinGetPos($hWnd)
Global $x = $aClientStatus[0]
Global $y = $aClientStatus[1]
Global $w = $aClientStatus[2]
Global $h = $aClientStatus[3]

While 1
    WinActivate($hWnd)

    ; Código Aqui!
    If '''+fnNames[0]+'''() Then
        Alert("'''+fnNames[0]+'''")
'''+'\n'.join(['    ElseIf '+x+'() Then\n        Alert("'+x+'")' for x in fnNames[1:]])+'''
    EndIf

    Sleep('''+str(interval)+'''000)
WEnd



Func Alert($msg)
    MsgBox($MB_SYSTEMMODAL, "", $msg)
EndFunc   ;==>Alert

Func Click($wndX, $wndY)
    MouseClick($MOUSE_CLICK_LEFT, $x+$wndX, $y+$wndY)
EndFunc   ;==>Click

Func Drag($startX, $startY, $finishX, $finishY)
    MouseClickDrag($MOUSE_CLICK_LEFT, $x+$startX, $y+$startY, $x+$finishX, $y+$finishY)
EndFunc   ;==>Drag

Func Terminate()
    Exit
EndFunc   ;==>Terminate
'''+'\n\n\n'.join(fns)

with open('a.au3', 'w', encoding='utf-8') as file:
    file.write(content)