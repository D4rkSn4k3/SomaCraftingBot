#include-once
#include <FileConstants.au3>
#include <StringConstants.au3>

; #FUNCTION# ====================================================================================================================
; Name ..........: __SelfRename
; Description ...: Rename the running executable to a different filename.
; Syntax ........: _SelfRename($sFileName[, $fRestart = Default[, $iDelay = 5[, $fUsePID = Default]]])
; Parameters ....: $sFileName           - Filename the executable should be called e.g. Example.exe or Example
;                  $fRestart            - [optional] Restart the application (True) or to not restart (False) after overwriting. Default is False.
;                  $iDelay              - [optional] An integer value for the delay to wait (in seconds) before stopping the process and deleting the executable.
;                                         If 0 is specified then the batch will wait indefinitely until the process no longer exits. Default is 5 (seconds).
;                  $fUsePID             - [optional] Use the process name (False) or PID (True). Default is False.
; Return values .: Success - Returns the PID of the batch file.
;                  Failure - Returns 0 & sets @error to non-zero
; Author ........: guinness
; Example .......: Yes
; ===============================================================================================================================
Func _SelfRename($sFileName, $fRestart = Default, $iDelay = 5, $fUsePID = Default)
    If @Compiled = 0 Then
        Return SetError(1, 0, 0)
    EndIf

    Local Const $iPosition = StringInStr($sFileName, '.', $STR_NOCASESENSEBASIC, -1) - 1
    If $iPosition Then
        $sFileName = StringLeft($sFileName, $iPosition)
    EndIf
    Local $sAppID = @ScriptName
    If $sFileName & '.exe' = $sAppID Then
        Return SetError(3, 0, 0)
    EndIf
    $sFileName = @ScriptDir & '\' & $sFileName & '.exe'

    Local $sTempFileName = @ScriptName
    $sTempFileName = StringLeft($sTempFileName, StringInStr($sTempFileName, '.', $STR_NOCASESENSEBASIC, -1) - 1)
    While FileExists(@TempDir & '\' & $sTempFileName & '.bat')
        $sTempFileName &= Chr(Random(65, 122, 1))
    WEnd
    $sTempFileName = @TempDir & '\' & $sTempFileName & '.bat'

    If $iDelay = Default Then
        $iDelay = 5
    EndIf

    Local $sDelay = ''
    $iDelay = Int($iDelay)
    If $iDelay > 0 Then
        $sDelay = 'IF %TIMER% GTR ' & $iDelay & ' GOTO DELETE'
    EndIf

    Local $sImageName = 'IMAGENAME'
    If $fUsePID Then
        $sAppID = @AutoItPID
        $sImageName = 'PID'
    EndIf

    Local $sCmdLineRaw = ''
    If $CmdLineRaw <> '' Then
        $sCmdLineRaw = ' ' & $CmdLineRaw
    EndIf

    Local $sRestart = ''
    If $fRestart Or $fRestart = Default Then
        $sRestart = 'START "" "' & $sFileName & '"' & $sCmdLineRaw
    EndIf
    $sCmdLineRaw = ''

    Local Const $iInternalDelay = 2, _
            $sScriptPath = @ScriptFullPath
    Local Const $sData = 'SET TIMER=0' & @CRLF _
             & ':START' & @CRLF _
             & 'PING -n ' & $iInternalDelay & ' 127.0.0.1 > nul' & @CRLF _
             & $sDelay & @CRLF _
             & 'SET /A TIMER+=1' & @CRLF _
             & @CRLF _
             & 'TASKLIST /NH /FI "' & $sImageName & ' EQ ' & $sAppID & '" | FIND /I "' & $sAppID & '" >nul && GOTO START' & @CRLF _
             & 'GOTO MOVE' & @CRLF _
             & @CRLF _
             & ':MOVE' & @CRLF _
             & 'TASKKILL /F /FI "' & $sImageName & ' EQ ' & $sAppID & '"' & @CRLF _
             & 'MOVE /Y ' & '"' & $sScriptPath & '"' & ' "' & $sFileName & '"' & @CRLF _
             & 'IF EXIST "' & $sScriptPath & '" GOTO MOVE' & @CRLF _
             & @CRLF _
             & ':END' & @CRLF _
             & $sRestart & @CRLF _
             & 'DEL "' & $sTempFileName & '"'

    Local Const $hFileOpen = FileOpen($sTempFileName, $FO_OVERWRITE)
    If $hFileOpen = -1 Then
        Return SetError(2, 0, 0)
    EndIf
    FileWrite($hFileOpen, $sData)
    FileClose($hFileOpen)
    Return Run($sTempFileName, @TempDir, @SW_HIDE)
EndFunc   ;==>_SelfRename