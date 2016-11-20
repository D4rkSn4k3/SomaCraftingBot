#include-once

#Region Constants
; http://msdn.microsoft.com/en-us/library/aa379607.aspx
Global Const $__DELETE = 0x00010000
Global Const $__READ_CONTROL = 0x00020000
Global Const $__WRITE_DAC = 0x00040000
Global Const $__WRITE_OWNER = 0x00080000
Global Const $__SYNCHRONIZE = 0x00100000

Global Const $__STANDARD_RIGHTS_READ = 0x00020000
Global Const $__STANDARD_RIGHTS_WRITE = $__STANDARD_RIGHTS_READ
Global Const $__STANDARD_RIGHTS_EXECUTE = $__STANDARD_RIGHTS_READ
Global Const $__STANDARD_RIGHTS_REQUIRED = BitOR($__DELETE, $__READ_CONTROL, $__WRITE_DAC, $__WRITE_OWNER) ; = 0x000F0000
Global Const $__STANDARD_RIGHTS_ALL = BitOR($__STANDARD_RIGHTS_REQUIRED, $__SYNCHRONIZE) ; = 0x001F0000

; http://msdn.microsoft.com/en-us/library/aa379321.aspx
Global Const $__ACCESS_SYSTEM_SECURITY = 0x01000000

; http://msdn.microsoft.com/en-us/library/ms684880.aspx
Global Const $__PROCESS_TERMINATE = 0x0001
Global Const $__PROCESS_CREATE_THREAD = 0x0002
Global Const $__PROCESS_VM_OPERATION = 0x0008
Global Const $__PROCESS_VM_READ = 0x0010
Global Const $__PROCESS_VM_WRITE = 0x0020
Global Const $__PROCESS_DUP_HANDLE = 0x0040
Global Const $__PROCESS_CREATE_PROCESS = 0x0080
Global Const $__PROCESS_SET_QUOTA = 0x0100
Global Const $__PROCESS_SET_INFORMATION = 0x0200
Global Const $__PROCESS_QUERY_INFORMATION = 0x0400
Global Const $__PROCESS_SUSPEND_RESUME = 0x0800
Global Const $__PROCESS_QUERY_LIMITED_INFORMATION = 0x1000 ;Windows Server 2003 and Windows XP:  This access right is not supported.
;~ Global    $__PROCESS_ALL_ACCESS                    = BitOR($__STANDARD_RIGHTS_ALL, 0xFFFF) ; = 0x001FFFFF
Global Const $__PROCESS_ALL_ACCESS = BitOR($__STANDARD_RIGHTS_REQUIRED, $__SYNCHRONIZE, 0xFFFF) ; = 0x001FFFFF

; http://msdn.microsoft.com/en-us/library/aa374905.aspx
Global Const $__TOKEN_ASSIGN_PRIMARY = 0x0001
Global Const $__TOKEN_DUPLICATE = 0x0002
Global Const $__TOKEN_IMPERSONATE = 0x0004
Global Const $__TOKEN_QUERY = 0x0008
Global Const $__TOKEN_QUERY_SOURCE = 0x0010
Global Const $__TOKEN_ADJUST_PRIVILEGES = 0x0020
Global Const $__TOKEN_ADJUST_GROUPS = 0x0040
Global Const $__TOKEN_ADJUST_DEFAULT = 0x0080
Global Const $__TOKEN_ADJUST_SESSIONID = 0x0100
Global Const $__TOKEN_EXECUTE = $__STANDARD_RIGHTS_EXECUTE
Global Const $__TOKEN_READ = BitOR($__STANDARD_RIGHTS_READ, $__TOKEN_QUERY) ; = 0x00020008
Global Const $__TOKEN_WRITE = BitOR($__STANDARD_RIGHTS_WRITE, $__TOKEN_ADJUST_PRIVILEGES, $__TOKEN_ADJUST_GROUPS, $__TOKEN_ADJUST_DEFAULT) ; = 0x000200E0
Global Const $__TOKEN_ALL_ACCESS_P = BitOR($__STANDARD_RIGHTS_REQUIRED, $__TOKEN_ASSIGN_PRIMARY, $__TOKEN_DUPLICATE, $__TOKEN_IMPERSONATE, $__TOKEN_QUERY, $__TOKEN_QUERY_SOURCE, $__TOKEN_ADJUST_PRIVILEGES, $__TOKEN_ADJUST_GROUPS, $__TOKEN_ADJUST_DEFAULT) ; = 0x001100FF
Global Const $__TOKEN_ALL_ACCESS = BitOR($__TOKEN_ALL_ACCESS_P, $__TOKEN_ADJUST_SESSIONID) ; = 0x001101FF
#EndRegion Constants


#Region KDMemory
;=================================================================================================
; Function:			_KDMemory_OpenProcess ( $processId [, $inheritHandle [, $desiredAccess]] )
; Author(s):		KDeluxe ( http://www.elitepvpers.com/forum/members/1219971-kdeluxe.html )
;=================================================================================================
Func _KDMemory_OpenProcess($processId, $inheritHandle = 0, $desiredAccess = $__PROCESS_ALL_ACCESS)
	Local $handles[2], $callResult

	If Not ProcessExists($processId) Then Return SetError(1, 0, False)

	$handles[0] = DllOpen('Kernel32.dll')
	If $handles[0] == -1 Then Return SetError(2, 0, False)

	$callResult = DllCall($handles[0], 'ptr', 'OpenProcess', 'DWORD', $desiredAccess, 'BOOL', $inheritHandle, 'DWORD', $processId)
	If @error Then
		DllClose($handles[0])
		Return SetError(@error + 2, 0, False)
	ElseIf $callResult[0] == 0 Then
		DllClose($handles[0])
		Return SetError(8, 0, False)
	EndIf

	$handles[1] = $callResult[0]
	Return $handles
EndFunc   ;==>_KDMemory_OpenProcess

;=================================================================================================
; Function:			_KDMemory_CloseHandles ( $handles )
; Author(s):		KDeluxe ( http://www.elitepvpers.com/forum/members/1219971-kdeluxe.html )
;=================================================================================================
Func _KDMemory_CloseHandles($handles)
	Local $callResult

	If Not IsArray($handles) Then Return SetError(1, 0, False)

	$callResult = DllCall($handles[0], 'BOOL', 'CloseHandle', 'ptr', $handles[1])
	If @error Then
		Return SetError(@error + 1, 0, False)
	ElseIf $callResult[0] == 0 Then
		Return SetError(7, 0, False)
	EndIf

	DllClose($handles[0])
	Return True
EndFunc   ;==>_KDMemory_CloseHandles

;=================================================================================================
; Function:			_KDMemory_ReadProcessMemory ( $handles, $baseAddress, $type [, $offsets] )
; Author(s):		KDeluxe ( http://www.elitepvpers.com/forum/members/1219971-kdeluxe.html )
;=================================================================================================
Func _KDMemory_ReadProcessMemory($handles, $baseAddress, $type, $offsets = 0)
	Local $addressBuffer, $valueBuffer, $offsetsSize, $i, $callResult, $memoryData[2]

	If Not IsArray($handles) Then Return SetError(1, 0, False)

	$addressBuffer = DllStructCreate('ptr')
	If @error Then Return SetError(@error + 1, 0, False)
	DllStructSetData($addressBuffer, 1, $baseAddress)

	$valueBuffer = DllStructCreate($type)
	If @error Then Return SetError(@error + 5, 0, False)

	If IsArray($offsets) Then
		$offsetsSize = UBound($offsets)
	Else
		$offsetsSize = 0
	EndIf

	For $i = 0 To $offsetsSize
		If $i == $offsetsSize Then
			$callResult = DllCall($handles[0], 'BOOL', 'ReadProcessMemory', 'ptr', $handles[1], 'ptr', DllStructGetData($addressBuffer, 1), 'ptr', DllStructGetPtr($valueBuffer), 'ULONG_PTR', DllStructGetSize($valueBuffer), 'ULONG_PTR', 0)
			If @error Then
				Return SetError(@error + 20, $i, False)
			ElseIf $callResult == 0 Then
				Return SetError(26, $i, False)
			EndIf
		Else
			$callResult = DllCall($handles[0], 'BOOL', 'ReadProcessMemory', 'ptr', $handles[1], 'ptr', DllStructGetData($addressBuffer, 1), 'ptr', DllStructGetPtr($addressBuffer), 'ULONG_PTR', DllStructGetSize($addressBuffer), 'ULONG_PTR', 0)
			If @error Then
				Return SetError(@error + 9, $i, False)
			ElseIf $callResult[0] == 0 Then
				Return SetError(15, $i, False)
			EndIf
		EndIf

		If $i < $offsetsSize Then
			DllStructSetData($addressBuffer, 1, DllStructGetData($addressBuffer, 1) + $offsets[$i])
			If @error Then Return SetError(@error + 15, $i, False)
		EndIf
	Next

;~ 	$memoryData[0] = DllStructGetData($addressBuffer, 1)
	$memoryData = DllStructGetData($valueBuffer, 1)
	Return $memoryData
EndFunc   ;==>_KDMemory_ReadProcessMemory

;=================================================================================================
; Function:			_KDMemory_WriteProcessMemory ( $handles, $baseAddress, $type, $value [, $offsets] )
; Author(s):		KDeluxe ( http://www.elitepvpers.com/forum/members/1219971-kdeluxe.html )
;=================================================================================================
Func _KDMemory_WriteProcessMemory($handles, $baseAddress, $type, $value, $offsets = 0)
	Local $addressBuffer, $valueBuffer, $offsetsSize, $i, $callResult

	If Not IsArray($handles) Then Return SetError(1, 0, False)

	$addressBuffer = DllStructCreate('ptr')
	If @error Then Return SetError(@error + 1, 0, False)
	DllStructSetData($addressBuffer, 1, $baseAddress)

	$valueBuffer = DllStructCreate($type)
	If @error Then Return SetError(@error + 5, 0, False)

	DllStructSetData($valueBuffer, 1, $value)
	If @error Then Return SetError(@error + 9, 0, False)

	If IsArray($offsets) Then
		$offsetsSize = UBound($offsets)
	Else
		$offsetsSize = 0
	EndIf

	For $i = 0 To $offsetsSize
		If $i == $offsetsSize Then
			$callResult = DllCall($handles[0], 'BOOL', 'WriteProcessMemory', 'ptr', $handles[1], 'ptr', DllStructGetData($addressBuffer, 1), 'ptr', DllStructGetPtr($valueBuffer), 'ULONG_PTR', DllStructGetSize($valueBuffer), 'ULONG_PTR*', 0)
			If @error Then
				Return SetError(@error + 25, $i, False)
			ElseIf $callResult[0] == 0 Then
				Return SetError(31, $i, False)
			EndIf
		Else
			$callResult = DllCall($handles[0], 'BOOL', 'ReadProcessMemory', 'ptr', $handles[1], 'ptr', DllStructGetData($addressBuffer, 1), 'ptr', DllStructGetPtr($addressBuffer), 'ULONG_PTR', DllStructGetSize($addressBuffer), 'ULONG_PTR*', 0)
			If @error Then
				Return SetError(@error + 14, $i, False)
			ElseIf $callResult[0] == 0 Then
				Return SetError(20, $i, False)
			EndIf
		EndIf

		If $i < $offsetsSize Then
			DllStructSetData($addressBuffer, 1, DllStructGetData($addressBuffer, 1) + $offsets[$i])
			If @error Then Return SetError(@error + 20, $i, False)
		EndIf
	Next

	Return DllStructGetData($addressBuffer, 1)
EndFunc   ;==>_KDMemory_WriteProcessMemory

;=================================================================================================
; Function:			_KDMemory_GetModuleBaseAddress ( $handles, $moduleName [, $caseSensitive [, $unicode]] )
; Author(s):		KDeluxe ( http://www.elitepvpers.com/forum/members/1219971-kdeluxe.html )
;=================================================================================================
Func _KDMemory_GetModuleBaseAddress($handles, $moduleName, $caseSensitive = 0, $unicode = 0)
	Local $psapiDll, $modules, $bytesNeeded, $type, $suffix, $baseName, $callResult, $moduleBaseAddress

	If Not IsArray($handles) Then Return SetError(1, 0, False)
	If StringLen($moduleName) == 0 Then Return SetError(2, 0, False)

	Local $psapiDll = DllOpen('Psapi.dll')
	If $psapiDll == -1 Then Return SetError(3, 0, False)

	$modules = DllStructCreate('ptr[1024]')
	If @error Then Return SetError(@error + 3, 0, False)

	$bytesNeeded = DllStructCreate('DWORD')
	If @error Then Return SetError(@error + 7, 0, False)

	If $unicode <> 1 Then
		$type = 'CHAR'
		$suffix = 'A'
	Else
		$type = 'WCHAR'
		$suffix = 'W'
	EndIf

	$baseName = DllStructCreate($type & '[256]')
	If @error Then Return SetError(@error + 11, 0, False)

	$callResult = DllCall($psapiDll, 'BOOL', 'EnumProcessModules', 'ptr', $handles[1], 'ptr', DllStructGetPtr($modules), 'DWORD', DllStructGetSize($modules), 'ptr', DllStructGetPtr($bytesNeeded))
	If @error Then
		Return SetError(@error + 15, 0, False)
	ElseIf $callResult[0] == 0 Then
		Return SetError(21, 0, False)
	Else
		For $i = 1 To DllStructGetData($bytesNeeded, 1)
			$moduleBaseAddress = DllStructGetData($modules, 1, $i)
			$callResult = DllCall($psapiDll, 'DWORD', 'GetModuleBaseName' & $suffix, 'ptr', $handles[1], 'ptr', $moduleBaseAddress, 'ptr', DllStructGetPtr($baseName), 'DWORD', 255)
			If @error Then
				Return SetError(@error + 21, $i, False)
			ElseIf $callResult[0] == 0 Then
				Return SetError(27, $i, False)
			Else
				If StringCompare(DllStructGetData($baseName, 1), $moduleName, $caseSensitive) == 0 Then
					DllClose($psapiDll)
					Return $moduleBaseAddress
				EndIf
			EndIf
		Next
	EndIf

	DllClose($psapiDll)
	Return SetError(28, 0, False)
EndFunc   ;==>_KDMemory_GetModuleBaseAddress


;=================================================================================================
; Function:			_KDMemory_FindAddress ( $handles, $pattern, $startAddress, $endAddress, ByRef $errors [, $getAll] )
; Author(s):		KDeluxe ( http://www.elitepvpers.com/forum/members/1219971-kdeluxe.html )
;=================================================================================================
Func _KDMemory_FindAddress($handles, $pattern, $startAddress, $endAddress, ByRef $errors, $getAll = 0)
	Local $size, $bytes, $errorListCount, $errorList[1][2], $addressListCount, $addressList[1], $memoryData, $offset

	If Not IsArray($handles) Then Return SetError(1, 0, False)
	If Mod($pattern, 2) <> 0 Then Return SetError(2, 0, False)
	If $endAddress - $startAddress <= 0 Then Return SetError(3, 0, False)

	$size = StringLen($pattern) / 2
	$bytes = $size * 4

	$errorListCount = 0
	$errorList[0][0] = 0

	$addressListCount = 0
	$addressList[0] = 0

	For $address = $startAddress To $endAddress Step $size + 1
		$memoryData = _KDMemory_ReadProcessMemory($handles, $address, 'BYTE[' & $bytes & ']')
		If @error Then
			$errorListCount += 1
			ReDim $errorList[$errorListCount + 1][2]
			$errorList[$errorListCount][0] = $address
			$errorList[$errorListCount][1] = @error
			$errorList[0][0] = $errorListCount
		Else
			If StringLeft($memoryData[1], 2) == "0x" Then
				$memoryData[1] = StringTrimLeft($memoryData[1], 2)
			EndIf

			StringRegExp($memoryData[1], $pattern, 1)
			If Not @error Then
				$offset = Round((@extended - StringLen($pattern) - 2) / 2, 0)

				$addressListCount += 1
				ReDim $addressList[$addressListCount + 1]
				$addressList[$addressListCount] = $address + $offset
				$addressList[0] = $addressListCount

				If $getAll <> 1 Then ExitLoop
			EndIf
		EndIf
	Next

	$errors = $errorList
	If $errorListCount > 0 Then SetExtended(1)

	Return $addressList
EndFunc   ;==>_KDMemory_FindAddress
#EndRegion KDMemory
