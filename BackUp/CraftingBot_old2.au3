#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=The Icons\Sword and Shield.ico
#AutoIt3Wrapper_Outfile=SomaBot.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Fileversion=0.7.1.5
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Add_Constants=n
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#AutoIt3Wrapper_Run_Au3Stripper=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ListBoxConstants.au3>
#include <ListViewConstants.au3>
#include <FileConstants.au3>
#include <StringConstants.au3>
#include <CheckSumVerify.au3>
#include <KDMemory2.au3>; Don't edit any of thee, it will break the bot
#include <Array.au3>
#include <Misc.au3>
#include <WinAPI.au3>
#include <GuiConstants.au3>
#include <file.au3>
#include <MsgBoxConstants.au3>
#include <Math.au3>
#include <ArrayMultiColSort.au3>
#include <String.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <_SelfRename.au3>
Dim $i, $word = ""
For $i = 1 To 10
	;Random letter
	If Random() < 0.5 Then
		;Capitals
		$Letter = Chr(Random(Asc("A"), Asc("Z"), 1))
	Else
		;Lower case
		$Letter = Chr(Random(Asc("a"), Asc("z"), 1))
	EndIf
	$word = $word & $Letter
Next
If @Compiled = 1 And @ScriptName = "SomaBot.exe" Then
	MsgBox(0, "", "SomaBot.exe has been renamed to " & $word & ".exe" & @CRLF & @CRLF & "The application will restart in less than 5 seconds", 5)
	_SelfRename($word & ".exe")
	Exit
Else
EndIf
$processName = "SomaWindow.exe"; Don't edit any of thee, it will break the bot
$processId = ProcessExists($processName); Don't edit any of thee, it will break the bot
$handles = _KDMemory_OpenProcess($processId) ; Opens memory to be called upon
AutoItSetOption("mousecoordmode", 2) ; Don't edit any of thee, it will break the bot
Global $NameOfSomaWindow = IniRead("Settings.ini", "Settings", "NameOfSomaWindow", "Myth of Soma : Molten Meltdown")
WinSetOnTop($NameOfSomaWindow, "", 0)
WinActivate($NameOfSomaWindow)
Opt("GUIOnEventMode", 1)
#Region ################## OffSets #######################################################################
Global $ChecksumPlacement = 183
Global $offsets[1] = [0]
Global $Nameoffsets[2] = [0x58, 0x0]
Global $IDoffsets[1] = [0x220] ; mobid
Global $HPoffsets[1] = [0x240] ;hp
Global $HPmaxoffsets[1] = [0x244] ;hpmax
Global $F2NumberOffset[1] = [0x1232]
Global $F1NumberOffset[1] = [0x11e6]
Global $F3NumberOffset[1] = [0x127e]
Global $F4NumberOffset[1] = [0x12ca]
Global $MPoffsets[1] = [0x248] ;mp
Global $MPmaxoffsets[1] = [0x24c] ;mpmax
Global $Stamoffsets[1] = [0x254] ;stam
Global $StamMaxoffsets[1] = [0x250] ;stamaax
Global $BWoffsets[1] = [0x260] ;bw
Global $BWMaxoffsets[1] = [0x25c] ;bwmax
Global $CoordsXOffsets[1] = [0x1dc] ; 1dc / 1d4
Global $CoordsYOffsets[1] = [0x1e0] ; 1e0 / 1d8
Global $CoordsXOffsets2[1] = [0x1d4] ; 1dc / 1d4
Global $CoordsYOffsets2[1] = [0x1d8] ; 1e0 / 1d8
Global $CursorStatusoffsets[1] = [0x18] ;1=mob attack 2=Pickup item
Global $UniqueID[1] = [0x20c] ; MobUniqueID
Global $entitytooltipoffsets[1] = [0x274] ; cursor change offset
Global $speed[1] = [0x48]
Global $eqippedweapoffset[1] = [0x2b0]
Global $AnimState2[1] = [0x200]
Global $AnimState[1] = [0x34]
Global $staffauraoffset[1] = [0x108]
Global $AuraActiveOffset[1] = [0x124]
Global $stanceoffset[1] = [0x2b8]
Global $NPCorMob[1] = [0x274] ; 0 = NPC 1 = Mob
Global $PlayerLevel[1] = [0x22c] ; Player Level
Global $Blind[1] = [0x1b0] ; Blind
Global $Confuse[1] = [0x1b4] ; Confuse
Global $GreyHPBars[1] = [0x19c] ; Grey Status - Can be used for HP Bars on players
Global $invis[1] = [0x70] ; Invis
Global $weakened[1] = [0xdc] ; weaken- but might just mean "debuffed"
Global $Directionoffset[1] = [0x50]
Global $Weakenoffset[1] = [0xdc]


#EndRegion ################## OffSets #######################################################################



#Region ################## Arrays #######################################################################
Global $EA1[39][30], $EA2[39][30], $EA[40][30]
Global $MaxNodes = 1000
Global $NavNodes[$MaxNodes + 1][2]
$NavNodes[0][0] = 0
Global $NavNodeDistance[$MaxNodes + 1][2]
;~ Global $MERCnavmesh[1000][1000] ; 4 [y][x]
;~ Global $TYTnavmesh[1000][1000] ; 1
;~ Global $ABIASnavmesh[1000][1000] ; 5
Global $TargetMobArray[7][2]
;~ Global $BigArray[193][6] ; first value | second value | offset | First Value | Second Value
Global $EntityDirectionCoordsArray[9][3]
Global $AntiMobstealArray[40][6]
Global $MobDropArray[11][5]
Global $Placement = 100
Global $LicenseArray[500][500]
Global $GhostArray[7][3]
Global $WeakenArray[4]
Global $DeadMobArray[39][4]
Global $MobContestedArray[39][4]
Global $DevModeTimer[2]
Global $InventoryBag[41][5]
Global $WHInventoryBag[51][4]
Global $CraftInventoryBag[11][4]
#EndRegion ################## Arrays #######################################################################

;~ 	_FileWriteFromArray("TYTnavmesh.csv", $TYTnavmesh, Default, Default, ",")
;~ 	_FileWriteFromArray("MERCnavmesh.csv", $MERCnavmesh, Default, Default, ",")
;~ 	_FileWriteFromArray("ABIASnavmesh.csv", $ABIASnavmesh, Default, Default, ",")

#Region ################## HotKeys #######################################################################

HotKeySet("{END}", "Quit") ; Quits the whole bot
HotKeySet("{DELETE}", "botonoff")
HotKeySet("{INSERT}", "SelectEntity")
;~ HotKeySet("!z", "WriteToNavmesh")
HotKeySet("!q", "AddNavNode")
HotKeySet("+!l", "ArrayDisplay")
;~ HotKeySet("!m", "MobSelection")
HotKeySet("!e", "AutoNavNodeSwitch")
;~ HotKeySet("!{F1}", "AutoHPPotsSwitch")
;~ HotKeySet("!{F2}", "AutoMPPotsSwitch")
;~ HotKeySet("!o", "MeleeAuraSwitch")
;~ HotKeySet("!p", "BowModeSwitch")
;~ HotKeySet("!i", "StaffAuraToggle")
;~ HotKeySet("!u", "IntModeToggle")
;~ HotKeySet("!y", "WeakenModeToggle")
HotKeySet("!j", "DevModeToggle")
HotKeySet("!a", "ScanWHInventoryBag")
HotKeySet("!s", "ScanInventoryBag")
HotKeySet("!d", "ScanCraftInventoryBag")

#EndRegion ################## HotKeys #######################################################################



#Region ################## Pre Loop Settings & Variables #######################################################################
Global $Map, $MPCurrent, $MPMax, $HPMax, $HPCurrent, $MyX, $MyY, $NavHuntTileDistance, $Entity, $TargetNode, $NavNodeForward, $TargetNodeDistance, $TargetDistanceFromNode, $InCombat = False, $NavigatingNodes = False, $GoToNearestNode = True, $EngagingNode = False, $boton = 0, $EntityName, $EntityID, $SelectTargetMobLoop, $LastNodePositionX, $LastNodePositionY, $LastNodePositionSet, $LastNodeDistance, $AutoNavNodeSwitch = 0, $AutoMPPots = 0, $AutoHPPots = 0, $MPLast, $HPLast, $F1Number, $F2Number, $F3Number, $F4Number, $SelectEntity = False, $Firstrun = True, $MyID, $MobHasOwner, $EntityCursorTooltip = 4294967295, $DropScanAndPickup = False, $DistanceFromDrop, $NavigatingToDrop = False, $GhostDetect, $IsGhost = False, $CurrentPotentialGhost, $MeleeAuraSwitch = 0, $StaffAuraToggle = 0, $IntModeToggle = 0, $WeakenMode = 0, $NearTargetX, $NearTargetY, $RecentDeadMob
Global $DevMode = False
Global $NavmeshRecording = False
Global $ArrayDisplayWindows = False
Global $MyID = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $UniqueID)
$PreReswidth = _KDMemory_ReadProcessMemory($handles, 0x06dd46c, 'DWORD', $offsets = 0)
$PreResheight = _KDMemory_ReadProcessMemory($handles, 0x06dd470, 'DWORD', $offsets = 0)
Global $XEdge = ($PreReswidth / 2) / 48
Global $YEdge = ($PreResheight / 2) / 24 - 2
Global $Reswidth = ($PreReswidth / 2) + 5
Global $Resheight = $PreResheight / 2
Global $UnalteredResWidth = ($PreReswidth / 2) + 5
Global $UnalteredResHeight = $PreResheight / 2
$cursorrotationwidth = 10
$cursorrotationheight = 35
Global $rotationspeedandsmoothness = -25 ;The rotation speed and smoothness of the rotation the cursor makes when attacking
Global $MoveMPositionX = $Reswidth - 1 ;The starting position MouseMove lands on - Can be adjusted to make sure the cursor starts on the mob -8
Global $MoveMPositionY = $Resheight - 27
Global $NodeDistanceSetting = IniRead("Settings.ini", "Settings", "NodeDistanceSetting", 12)
Global $AutoNavNodeDistanceSetting = IniRead("Settings.ini", "Settings", "AutoNavNodeDistanceSetting", 6)
Global $PlayertoNodeDistsetting = IniRead("Settings.ini", "Settings", "PlayertoNodeDist", 6)
Global $MinDistance = IniRead("Settings.ini", "Settings", "MinClickDistance", 6)
Global $MaxDistance = IniRead("Settings.ini", "Settings", "MaxClickDistance", 12)
Global $DropSleep = IniRead("Settings.ini", "Settings", "DropsScanningDelay", 30)
Global $DropSleep2 = IniRead("Settings.ini", "Settings", "DropPickupDelay", 30)
Global $MobSelectionSwitch = IniRead("Settings.ini", "Settings", "MobSelection", 2)
Global $BowModeSwitch = IniRead("Settings.ini", "Settings", "BowModeSwitch", 0)
Global $AttackDistance = IniRead("Settings.ini", "Settings", "AttackDistance", 12)
Global $HPpotionuse = IniRead("Settings.ini", "Settings", "HPPotionUse", 30) ; If your HP drops below this number then the game will use a HP pot from F1 - Careful using this with a new char, make sure your HP is aboove this number!
Global $MPpotionuse = IniRead("Settings.ini", "Settings", "MPPotionUse", 6) ; If your MP drops below this number then the game will use a MP pot from F2
Global $StaffAuraSlot = IniRead("Settings.ini", "Settings", "StaffAuraSlot", 3) ; 0,1,2,3 for F5 f6 f7 f8 -
Global $AttackSpellSlot = IniRead("Settings.ini", "Settings", "AttackSpellSlot", 0) ; 0,1,2,3 for F5 f6 f7 f8 -
Global $WeakenSpellSlot = IniRead("Settings.ini", "Settings", "WeakenSpellSlot", 1) ; 0,1,2,3 for F5 f6 f7 f8 -
Global $WeakenRange = IniRead("Settings.ini", "Settings", "WeakenRange", 1) ; 0,1,2,3 for F5 f6 f7 f8 -
Global $AuraSpellSlot = IniRead("Settings.ini", "Settings", "AuraSpellSlot", 4) ; 0,1,2,3 for F5 f6 f7 f8 -
Global $PickupDropsSwitch = IniRead("Settings.ini", "Settings", "PickupDrops", 1)
$Map2 = 0
Send("{LCTRL}") ; So that stamina is ready and set
Global $Sleep = IniRead("Settings.ini", "Settings", "BotSpeed", 100)
;~ Global $CPU = "BFEBFBFF000306A9"
;~ Global $MAC = "90:2B:34:37:60:26"
;~ Global $CPU = "1FABFBFF000306A9"
;~ Global $MAC = "00:0C:29:D1:DD:61"
Global $CPU2
Global $MAC2
$Placement += 100
#EndRegion ################## Pre Loop Settings & Variables #######################################################################



#Region ################## GUI & Window Init ##########################################################################################
$Placement += 187
gui()
;~ AntiMobstealGUI()
;~ EntityArrayGUI()
$aTaskbar = WinGetPos("[CLASS:Shell_TrayWnd]", "")
$aWin = WinGetPos($BotSettingsGUI)
WinMove($BotSettingsGUI, "", @DesktopWidth - $aWin[2] - 4, @DesktopHeight - $aWin[3] - $aTaskbar[3] - 4)
Authenticate()

#EndRegion ################## GUI & Window Init ##########################################################################################



#Region ################## Main Loop ##########################################################################################
While 1
	Sleep($Sleep)
	If $DevModeTimer[0] > 0 Then
		$DevModeTimer[1] = TimerDiff($DevModeTimer[0])
;~ 		ToolTip($DevModeTimer[1])
		If $DevModeTimer[1] > 2000 And $DevMode = False Then
			$DevModeTimer[0] = 0
			$DevModeTimer[1] = 0
			HotKeySet("!z")
		EndIf
	EndIf
	$WindowPosition = WinGetPos($NameOfSomaWindow)
;~ 	MapNavMesh()
	If $CPUMAC = $CPUMAC2 Then
		FillEntityArray()
		GuiUpdate()
	EndIf
	AutoNavNode()
	Navigation()
	Stamina()
;~ 	Potions()
;~ 	StaffAura()
	If $DevMode = True Then
		GMDetection()
	EndIf
;~ 		tooltip($MyID)
;~ 		tooltip($RecentDeadMob)
;~ 		Test()
;~ 		$slot = _KDMemory_WriteProcessMemory($handles, 0x05366ac, 'DWORD', $AttackSpellSlot, $offsets = 0)
;~ msgbox(1,"",$AttackSpellSlot)
;~ 		tooltip($AttackSpellSlot)
;~ 	$CursorStatus = _KDMemory_ReadProcessMemory($handles, 0x06d860c, 'DWORD', $Weakenoffset)
;~ 	tooltip($CursorStatus)
;~ 	$CursorStatus = _KDMemory_ReadProcessMemory($handles, 0x06dd468, 'DWORD', $CursorStatusoffsets)
;~ 	$EntityCursorTooltip = _KDMemory_ReadProcessMemory($handles, 0x06d85F8, 'DWORD', $offsets = 0)
;~ 	ToolTip($EntityCursorTooltip & @CRLF & $CursorStatus)
;~ 	ToolTip($F1Number & " : " & $F2Number & " : " & $F3Number & " : " & $F4Number
;~ 	ScanInventoryBag()
WEnd
#EndRegion ################## Main Loop ##########################################################################################


Func ScanCraftInventoryBag()
	Global $CraftinventBagItemIDOffset[2] = [0x0, 0x8]
	Global $CraftinventBagItemNameOffset[3] = [0x0, 0x2c, 0x0]
;~ 	Global $CraftinventBagItemWeightOffset[2] = [0x0,0x14]
	Global $CraftinventBagItemDuraAmountOffset[2] = [0x0, 0x24]
;~ 	Global $WHinventBagItemDuraLastRepairOffset[1] = [0x]
	For $i = 1 To 10 Step 1
		If $i > 1 Then
			$CraftinventBagItemIDOffset[0] += 4
			$CraftinventBagItemNameOffset[0] += 4
;~ 			$CraftinventBagItemWeightOffset[0] += 4
			$CraftinventBagItemDuraAmountOffset[0] += 4
;~ 			$WHinventBagItemDuraLastRepairOffset[0] += 4
;~ 			ToolTip(Hex($inventBagItemIDOffset[0]))
		EndIf
		$CraftInventoryBag[$i][0] = _KDMemory_ReadProcessMemory($handles, 0x05354F8, 'WORD', $CraftinventBagItemIDOffset)
		$CraftInventoryBag[$i][1] = _KDMemory_ReadProcessMemory($handles, 0x05354F8, 'char[30]', $CraftinventBagItemNameOffset)
;~ 			$CraftInventoryBag[$i][2] = _KDMemory_ReadProcessMemory($handles, 0x05354F8, 'WORD', $CraftinventBagItemWeightOffset)
		$CraftInventoryBag[$i][2] = _KDMemory_ReadProcessMemory($handles, 0x05354F8, 'WORD', $CraftinventBagItemDuraAmountOffset)
;~ 			$WHInventoryBag[$i][4] = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'WORD', $WHinventBagItemDuraLastRepairOffset)
	Next
	_ArrayDisplay($CraftInventoryBag, "Craft Inventory Bag")
;~ 	ToolTip($InventoryBag[0][1] & @CRLF & $InventoryBag[0][2] & @CRLF & $InventoryBag[0][3] & @CRLF & $InventoryBag[0][4] & @CRLF & $InventoryBag[0][5])
EndFunc   ;==>ScanCraftInventoryBag



Func ScanWHInventoryBag()
	Global $WHinventBagItemIDOffset[2] = [0x0, 0x8]
	Global $WHinventBagItemNameOffset[3] = [0x0, 0x2c, 0x0]
	Global $WHinventBagItemWeightOffset[2] = [0x0, 0x14]
	Global $WHinventBagItemDuraAmountOffset[2] = [0x0, 0x24]
	For $i = 1 To 50 Step 1
		If $i > 1 Then
			$WHinventBagItemIDOffset[0] += 4
			$WHinventBagItemNameOffset[0] += 4
			$WHinventBagItemWeightOffset[0] += 4
			$WHinventBagItemDuraAmountOffset[0] += 4;~ 			ToolTip(Hex($inventBagItemIDOffset[0]))
		EndIf
		$WHInventoryBag[$i][0] = _KDMemory_ReadProcessMemory($handles, 0x0535980, 'WORD', $WHinventBagItemIDOffset)
		$WHInventoryBag[$i][1] = _KDMemory_ReadProcessMemory($handles, 0x0535980, 'char[30]', $WHinventBagItemNameOffset)
		$WHInventoryBag[$i][2] = _KDMemory_ReadProcessMemory($handles, 0x0535980, 'WORD', $WHinventBagItemWeightOffset)
		$WHInventoryBag[$i][3] = _KDMemory_ReadProcessMemory($handles, 0x0535980, 'WORD', $WHinventBagItemDuraAmountOffset)
;~ 			$WHInventoryBag[$i][4] = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'WORD', $WHinventBagItemDuraLastRepairOffset)
	Next
	_ArrayDisplay($WHInventoryBag, "Warehouse Inventory Bag")
EndFunc   ;==>ScanWHInventoryBag


Func ScanInventoryBag()
	Global $inventBagItemIDOffset[1] = [0x5ee]
	Global $inventBagItemNameOffset[2] = [0x628, 0x0]
	Global $inventBagItemWeightOffset[1] = [0x5f6]
	Global $inventBagItemDuraAmountOffset[1] = [0x606]
	Global $inventBagItemDuraLastRepairOffset[1] = [0x608]
	For $i = 1 To 40 Step 1
		If $i > 1 Then
			$inventBagItemIDOffset[0] += 76
			$inventBagItemNameOffset[0] += 76
			$inventBagItemWeightOffset[0] += 76
			$inventBagItemDuraAmountOffset[0] += 76
			$inventBagItemDuraLastRepairOffset[0] += 76
		EndIf
		$InventoryBag[$i][0] = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'WORD', $inventBagItemIDOffset)
		$InventoryBag[$i][1] = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'char[30]', $inventBagItemNameOffset)
		$InventoryBag[$i][2] = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'WORD', $inventBagItemWeightOffset)
		$InventoryBag[$i][3] = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'WORD', $inventBagItemDuraAmountOffset)
		$InventoryBag[$i][4] = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'WORD', $inventBagItemDuraLastRepairOffset)
	Next
	_ArrayDisplay($InventoryBag, "Inventory Bag")
EndFunc   ;==>ScanInventoryBag





Func Test()
	$x = Abs(283 - $MyX)
	$y = Abs(95 - $MyY)
	$TestDist = $x + $y
	ToolTip($TestDist, (283 - $MyX) * 48 + $Reswidth + $WindowPosition[0], (95 - $MyY) * 24 + $Resheight + $WindowPosition[1])
	CalcNavWithinDistance(283, 95, $AttackDistance / 2)
	If $boton = 1 Then
		MouseMove(($NearTargetX - $MyX) * 48 + $Reswidth, ($NearTargetY - $MyY) * 24 + $Resheight)
	EndIf
EndFunc   ;==>Test

#Region ################## Main Loop Functions #######################################################################################
Func MapNavMesh()
	$Map = _KDMemory_ReadProcessMemory($handles, 0x05316B0, 'DWORD')
	If $NavmeshRecording = True Then
		If $Map <> $Map2 Then
			If $Map2 = 1 Then
				_FileWriteFromArray("NavMesh/TYTnavmesh.csv", $TYTnavmesh, Default, Default, ",")
			ElseIf $Map2 = 5 Then
				_FileWriteFromArray("NavMesh/ABIASnavmesh.csv", $ABIASnavmesh, Default, Default, ",")
			ElseIf $Map2 = 4 Then
				_FileWriteFromArray("NavMesh/MERCnavmesh.csv", $MERCnavmesh, Default, Default, ",")
			EndIf
			If $Map = 1 Then
				_FileReadToArray("NavMesh/TYTnavmesh.csv", $TYTnavmesh, 0, ",")
			ElseIf $Map = 5 Then
				_FileReadToArray("NavMesh/ABIASnavmesh.csv", $ABIASnavmesh, 0, ",")
			ElseIf $Map = 4 Then
				_FileReadToArray("NavMesh/MERCnavmesh.csv", $MERCnavmesh, 0, ",")
			EndIf
		EndIf

	EndIf
	$Map2 = $Map
EndFunc   ;==>MapNavMesh



Func FillEntityArray()
	If $CPUMAC <> $CPUMAC2 Then
		$Sleep = 999999
	EndIf
	If $LicenseArray[$ChecksumPlacement][$ChecksumPlacement] = $Checksum Then
		$F1Number = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $F1NumberOffset)
		$F2Number = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $F2NumberOffset)
		$F3Number = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $F3NumberOffset)
		$F4Number = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $F4NumberOffset)
		$Warping = _KDMemory_ReadProcessMemory($handles, 0x06D9EE0, 'DWORD')
		$MPCurrent = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $MPoffsets)
		$MPMax = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $MPmaxoffsets)
		$HPMax = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $HPmaxoffsets)
		$HPCurrent = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $HPoffsets)
		$MyX = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $CoordsXOffsets)
		$MyY = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $CoordsYOffsets)
		$staffaura = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $staffauraoffset) ; Is there an aura?
		$stance = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $stanceoffset) ; peace/mob/pk
		$eqippedweap = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $eqippedweapoffset) ; What weap? 6 = staff
		$RecentDeadMob = _KDMemory_ReadProcessMemory($handles, 0x06d8dd4, 'DWORD', $UniqueID)
	EndIf
;~ |0 UID|1Dist|2X |3Y |4 MobID|5 Anim|6 NPCorMob|7 Name|8 HP|9 MHP|10 Stam|11 Hex|12 Weap|
;~ |13 Weaken|14 Animstate2|15 Staff Aura|16 Stance|17 Lvl|18 Grey|19 Invis|20 BW|21 MBW|22 MP|23 MMP
;~ |24 Priority|25 Direction|26 id of owner of mob|27 Owners Name|
	For $i = 0 To 38 Step 1
		$PreEntityAddressHex = 0x06d8600 + ($i * 4)
		$EntityAddressHex = "0x0" & Hex($PreEntityAddressHex, 6)
		$EA1[$i][0] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $UniqueID)
		$EA1[$i][2] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $CoordsXOffsets)
		$EA1[$i][3] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $CoordsYOffsets)
		$EA1[$i][4] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $IDoffsets)
		$EA1[$i][5] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $AnimState)
		$EA1[$i][6] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $NPCorMob)
		$EA1[$i][7] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'char[30]', $Nameoffsets)
		$EA1[$i][8] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $HPoffsets)
		$EA1[$i][9] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $HPmaxoffsets)
		$EA1[$i][10] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $Stamoffsets)
;~ 		$EA1[$i][11] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $GreyHPBars)
		$EA1[$i][11] = $EntityAddressHex
		$EA1[$i][12] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $eqippedweapoffset)
		$EA1[$i][13] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $Weakenoffset)
		$EA1[$i][14] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $AnimState2)
		$EA1[$i][15] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $staffauraoffset)
		$EA1[$i][16] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $stanceoffset)
		$EA1[$i][17] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $PlayerLevel)
		$EA1[$i][18] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $GreyHPBars)
		$EA1[$i][19] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $invis)
		$EA1[$i][20] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $BWoffsets)
		$EA1[$i][21] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $BWMaxoffsets)
		$EA1[$i][22] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $MPoffsets)
		$EA1[$i][23] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex, 'DWORD', $MPmaxoffsets)
		$x = Abs($EA1[$i][2] - $MyX)
		$y = Abs($EA1[$i][3] - $MyY)
		$EA1[$i][1] = $x + $y
		For $g = 1 To 6 Step 1
			If $EA1[$i][4] = $TargetMobArray[$g][0] And $EA1[$i][7] = $TargetMobArray[$g][1] And $EA1[$i][4] <> 0 And $EA1[$i][6] = 1 And $EA1[$i][5] <> 15 And $EA1[$i][0] <> $GhostArray[$g][0] Then ; [0] = mobtype and the position of $g in the array signifies the priority
				$EA1[$i][24] = $g
				ExitLoop
			ElseIf $g = 6 And $EA1[$i][4] <> $TargetMobArray[$g][0] Or $EA1[$i][4] = 0 Or $EA1[$i][7] <> $TargetMobArray[$g][1] Then
				$EA1[$i][24] = 7
			EndIf
;~ 				If $EA1[$i][24] <> 7 And $EA1[$i][4] = $TargetMobArray[$g][0] And $EA1[$i][7] <> $TargetMobArray[$g][1] Or $EA1[$i][24] <> 7 And $EA1[$i][4] <> $TargetMobArray[$g][0] And $EA1[$i][7] = $TargetMobArray[$g][1] Then
;~ 					For $d = 0 To 27 Step 1
;~ 						$EA1[$i][$d] = 0
;~ 					Next
;~ 				EndIf
		Next
		If ($EA1[$i][8] = 0 And $EA1[$i][9] = 0) Or ($EA1[$i][8] = 1 And $EA1[$i][9] = 0) Or ($EA1[$i][8] = 1 And $EA1[$i][9] > 0) Or ($EA1[$i][8] = 1 And $EA1[$i][9] = 1) Then
			$EA1[$i][8] = "Unknown"
			$EA1[$i][9] = "Unknown"
		EndIf
	Next
	_ArrayMultiColSort($EA1, $MobSelection)
	For $i = 0 To 38 Step 1
		$PreEntityAddressHex2 = 0x06d8600 + ($i * 4)
		$EntityAddressHex2 = "0x0" & Hex($PreEntityAddressHex2, 6)
		$EA2[$i][0] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $UniqueID)
		$EA2[$i][2] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $CoordsXOffsets)
		$EA2[$i][3] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $CoordsYOffsets)
		$EA2[$i][4] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $IDoffsets)
		$EA2[$i][5] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $AnimState)
		$EA2[$i][6] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $NPCorMob)
		$EA2[$i][7] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'char[30]', $Nameoffsets)
		$EA2[$i][8] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $HPoffsets)
		$EA2[$i][9] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $HPmaxoffsets)
		$EA2[$i][10] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $Stamoffsets)
;~ 		$EA2[$i][11] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $GreyHPBars)
		$EA2[$i][11] = $EntityAddressHex2
		$EA2[$i][12] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $eqippedweapoffset)
		$EA2[$i][13] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $Weakenoffset)
		$EA2[$i][14] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $AnimState2)
		$EA2[$i][15] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $staffauraoffset)
		$EA2[$i][16] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $stanceoffset)
		$EA2[$i][17] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $PlayerLevel)
		$EA2[$i][18] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $GreyHPBars)
		$EA2[$i][19] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $invis)
		$EA2[$i][20] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $BWoffsets)
		$EA2[$i][21] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $BWMaxoffsets)
		$EA2[$i][22] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $MPoffsets)
		$EA2[$i][23] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $MPmaxoffsets)
		$EA2[$i][25] = _KDMemory_ReadProcessMemory($handles, $EntityAddressHex2, 'DWORD', $Directionoffset)
;~ 			$EA2[$i][26] = 0
		$x2 = Abs($EA2[$i][2] - $MyX)
		$y2 = Abs($EA2[$i][3] - $MyY)
		$EA2[$i][1] = $x2 + $y2
		For $g = 1 To 6 Step 1
			If $EA2[$i][4] = $TargetMobArray[$g][0] And $EA2[$i][7] = $TargetMobArray[$g][1] And $EA2[$i][4] <> 0 And $EA2[$i][6] = 1 And $EA2[$i][5] <> 15 And $EA2[$i][0] <> $GhostArray[$g][0] Then ; [0] = mobtype and the position of $g in the array signifies the priority
				$EA2[$i][24] = $g
				ExitLoop
			ElseIf $g = 6 And $EA2[$i][4] <> $TargetMobArray[$g][0] Or $EA2[$i][4] = 0 Or $EA2[$i][7] <> $TargetMobArray[$g][1] Then
				$EA2[$i][24] = 7
			EndIf
;~ 				If $EA2[$i][24] <> 7 And $EA2[$i][4] = $TargetMobArray[$g][0] And $EA2[$i][7] <> $TargetMobArray[$g][1] Or $EA2[$i][24] <> 7 And $EA2[$i][4] <> $TargetMobArray[$g][0] And $EA2[$i][7] = $TargetMobArray[$g][1] Then
;~ 					For $d = 0 To 27 Step 1
;~ 						$EA2[$i][$d] = 0
;~ 					Next
;~ 				EndIf
		Next
		If ($EA2[$i][8] = 0 And $EA2[$i][9] = 0) Or ($EA2[$i][8] = 1 And $EA2[$i][9] = 0) Or ($EA2[$i][8] = 1 And $EA2[$i][9] > 0) Or ($EA2[$i][8] = 1 And $EA2[$i][9] = 1) Then
			$EA2[$i][8] = "Unknown"
			$EA2[$i][9] = "Unknown"
		EndIf
	Next

;~ |0 UID|1Dist|2X |3Y |4 MobID|5 Anim|6 NPCorMob|7 Name|8 HP|9 MHP|10 Stam|11 OX|12 OY|
;~ |13 Speed|14 Animstate2|15 Staff Aura|16 Stance|17 Lvl|18 Grey|19 Invis|20 BW|21 MBW|22 MP|23 MMP
;~ |24 Priority|25 Direction|26 id of owner of mob|27 Owners Name|
	_ArrayMultiColSort($EA2, $MobSelection)
	For $d = 0 To 38 Step 1
;~ 		$EA[$d][24] = ""
		If $EA2[$d][0] = $EA1[$d][0] And _
				$EA2[$d][1] = $EA1[$d][1] And _
				$EA2[$d][2] = $EA1[$d][2] And _
				$EA2[$d][3] = $EA1[$d][3] And _
				$EA2[$d][4] = $EA1[$d][4] And _
				$EA2[$d][5] = $EA1[$d][5] And _
				$EA2[$d][7] = $EA1[$d][7] And _
				$EA2[$d][8] = $EA1[$d][8] And _
				$EA2[$d][9] = $EA1[$d][9] And _
				$EA2[$d][10] = $EA1[$d][10] And _
				$EA2[$d][15] = $EA1[$d][15] And _
				$EA2[$d][16] = $EA1[$d][16] And _
				$EA2[$d][17] = $EA1[$d][17] And _
				$EA2[$d][20] = $EA1[$d][20] And _
				$EA2[$d][21] = $EA1[$d][21] And _
				$EA2[$d][22] = $EA1[$d][22] And _
				$EA2[$d][23] = $EA1[$d][23] Then
			For $f = 0 To 29 Step 1
				If $EA2[$d][0] <> 0 Then
					$EA[$d][$f] = $EA2[$d][$f]
					If $NavmeshRecording = True And $f = 3 And $EA[$d][3] > 0 And $EA[$d][3] < 1000 And $EA[$d][2] > 0 And $EA[$d][2] < 1000 And $Warping = 0 And $SelectTargetMobLoop = 0 Then
						If $Map = 1 Then
							$TYTnavmesh[$EA[$d][3]][$EA[$d][2]] = 1
						ElseIf $Map = 4 Then
							$MERCnavmesh[$EA[$d][3]][$EA[$d][2]] = 1
						ElseIf $Map = 5 Then
							$ABIASnavmesh[$EA[$d][3]][$EA[$d][2]] = 1
						EndIf
					EndIf
;~ 				ElseIf $EA2[$d][0] = 0 Then
;~ 					$EA[$d][$f] = 0
				EndIf
				If $f = 28 And $WeakenArray[0] = $EA[$d][0] And $WeakenArray[0] <> 0 Then
					$EA[$d][28] = 1
				EndIf
			Next


;~ 			; If mobs are moving or showing as dead then update antimobstealarray
;~ 			If $EA[$d][5] = 4 And $EA[$d][6] = 1 Or ($EA[$d][5] = 15 And $EA[$d][6] = 1) Then
;~ 				For $m = 0 To 38 Step 1
;~ 					If $AntiMobstealArray[$m][0] = $EA[$d][0] And $AntiMobstealArray[$m][0] <> 0 And $AntiMobstealArray[$m][1] = $EA[$d][7] Then
;~ 						$AntiMobstealArray[$m][0] = 0 ; Save mobs ID
;~ 						$AntiMobstealArray[$m][1] = 0 ; Save mobs Name
;~ 						$AntiMobstealArray[$m][2] = 0 ; Save Owners ID
;~ 						$AntiMobstealArray[$m][3] = 0 ; Save Owners Name
;~ 						$AntiMobstealArray[$m][4] = "" ; Save mobs direction
;~ 					EndIf
;~ 				Next
;~ 			EndIf
;~ 			;Copy data from antimobstealarray to main entityarray
			For $m = 0 To 38 Step 1
				If $AntiMobstealArray[$m][0] = $EA[$d][0] And $AntiMobstealArray[$m][0] <> 0 And $AntiMobstealArray[$m][1] = $EA[$d][7] Then
					$EA[$d][26] = $AntiMobstealArray[$m][2] ; Save Owners ID
					$EA[$d][27] = $AntiMobstealArray[$m][3] ; Save Owners Name
;~ 			;ExitLoop
				EndIf
			Next
			;0 Save mobs ID | 1 Save mobs Name | 2 Save Owners ID | 3 Save Owners Name | Save mob's direction
			For $i = 0 To 6 Step 1
				If $GhostArray[$i][0] > 0 Then
					$GhostArray[$i][2] = TimerDiff($GhostArray[$i][1])
					If $GhostArray[$i][2] > 30000 Then
						$GhostArray[$i][0] = 0
						$GhostArray[$i][1] = 0
						$GhostArray[$i][2] = 0
;~ 						msgbox(1,"","TimerReset   " & $i)
					EndIf
				EndIf
			Next
		EndIf

	Next
;~ 	DeadMobArray()
	ContestedMob()
	AntiMobsteal()

;~ 	For $e = 0 To 38 Step 1
;~ 		If $EA[$e][1] = 2 Then
;~ 	Global $ee = 3
;~ 			tooltip($ee)
;~ 	ToolTip($EA[$ee][0] & " = " & $EA[$ee][1] & " : " & $EA[$ee][2] & " " & $EA[$ee][3] & " " & $EA[$ee][4] & " " & $EA[$ee][5] & " " & $EA[$ee][6] _
;~ 			 & " " & $EA[$ee][7] & " " & $EA[$ee][8] & " " & $EA[$ee][9] & " " & $EA[$ee][10], ($EA[$ee][2] - $MyX) * 48 + $Reswidth + $WindowPosition[0], ($EA[$ee][3] - $MyY) * 24 + $Resheight + $WindowPosition[1]) ; Nearest Mob Tooltip - overhead

;~ 			ExitLoop
;~ 		EndIf
;~ 	Next


;~ 	ToolTip($MobDropArray[1][0] & " | " & $MobDropArray[1][1] & @CRLF & _
;~ 			$MobDropArray[2][0] & " | " & $MobDropArray[2][1] & @CRLF & _
;~ 			$MobDropArray[3][0] & " | " & $MobDropArray[3][1] & @CRLF & _
;~ 			$MobDropArray[4][0] & " | " & $MobDropArray[4][1] & @CRLF & _
;~ 			$MobDropArray[5][0] & " | " & $MobDropArray[5][1] & @CRLF & _
;~ 			$MobDropArray[6][0] & " | " & $MobDropArray[6][1] & @CRLF & _
;~ 			$MobDropArray[7][0] & " | " & $MobDropArray[7][1] & @CRLF & _
;~ 			$MobDropArray[8][0] & " | " & $MobDropArray[8][1] & @CRLF & _
;~ 			$MobDropArray[9][0] & " | " & $MobDropArray[9][1] & @CRLF & _
;~ 			$MobDropArray[10][0] & " | " & $MobDropArray[0][0], 1000, 700)






;~ 		ToolTip($EA[0][0] & " = " & $EA[0][7] & @CR & _
;~ 				$EA[1][0] & " = " & $EA[1][7] & @CR & _
;~ 				$EA[2][0] & " = " & $EA[2][7] & @CR & _
;~ 				$EA[3][0] & " = " & $EA[3][7] & @CR & _
;~ 				$EA[4][0] & " = " & $EA[4][7] & @CR & _
;~ 				$EA[5][0] & " = " & $EA[5][7] & @CR & _
;~ 				$EA[6][0] & " = " & $EA[6][7] & @CR & _
;~ 				$EA[7][0] & " = " & $EA[7][7] & @CR & _
;~ 				$EA[8][0] & " = " & $EA[8][7] & @CR & _
;~ 				$EA[9][0] & " = " & $EA[9][7] & @CR & _
;~ 				$EA[10][0] & " = " & $EA[10][7] & @CR & _
;~ 				$EA[11][0] & " = " & $EA[11][7] & @CR & _
;~ 				$EA[20][0] & " = " & $EA[20][7] & @CR & _
;~ 				$EA[30][0] & " = " & $EA[30][7] & @CR & _
;~ 				$EA[35][0] & " = " & $EA[35][7])
;~ |0 UID|1Dist|2X |3Y |4 MobID|5 Anim|6 NPCorMob|7 Name|8 HP|9 MHP|10 Stam|11 OX|12 OY|
;~ |13 Speed|14 Animstate2|15 Staff Aura|16 Stance|17 Lvl|18 Grey|19 Invis|20 BW|21 MBW|22 MP|23 MMP|
;~ ======================= Nearest mob
;~ 		ToolTip("Distance: " & $ea[2][1],($ea[2][2] - $MyX) * 48 + $Reswidth + $WindowPosition[0], ($ea[2][3] - $MyY) * 24 + $Resheight + $WindowPosition[1])
	If $SelectEntity = True Then
		For $i = 0 To 38 Step 1
;~ 		 == == == == == == == == == == == == == = If entity is Not dead And entity is inside screen edges
;~ 			If $SelectEntity = True And $Entity = $EA[$i][0] And $EntityName = $EA[$i][7] And $EntityID = $EA[$i][4] And $EA[$i][3] > ($MyY - $YEdge) And $EA[$i][3] < ($MyY + $YEdge) And $EA[$i][2] > ($MyX - $XEdge) And $EA[$i][2] < ($MyX + $XEdge) Then
;~ 				ToolTip($EA[$i][7] & " | " & $EA[$i][0] & " | " & $EA[$i][4] & @CRLF & _
;~ 						"Main X/Y:  " & $EA[$i][2] & " " & "/" & " " & $EA[$i][3] & @CRLF & _
;~ 						"HP :  " & $EA[$i][8] & " " & "/" & " " & $EA[$i][9] & @CRLF & _
;~ 						"MP :  " & $EA[$i][22] & " " & "/" & " " & $EA[$i][23] & @CRLF & _
;~ 						"BW :  " & $EA[$i][20] & " " & "/" & " " & $EA[$i][21] & @CRLF & _
;~ 						"Animstate:  " & $EA[$i][5] & @CRLF & _
;~ 						"Animstate2:  " & $EA[$i][14] & @CRLF & _
;~ 						"StaffAura:  " & $EA[$i][15] & @CRLF & _
;~ 						"Stance:  " & $EA[$i][16] & @CRLF & _
;~ 						"Level:  " & $EA[$i][17] & @CRLF & _
;~ 						"Grey:  " & $EA[$i][18] & @CRLF & _
;~ 						"Invis:  " & $EA[$i][19] & @CRLF & _
;~ 						"NPCorMob:  " & $EA[$i][6] & @CRLF & _
;~ 						"Dist:  " & $EA[$i][1] & @CRLF & _
;~ 						"Weaken:  " & $EA[$i][13] & @CRLF & _
;~ 						"Direction:  " & $EA[$i][25] & @CRLF & _
;~ 						"Mob Aggroed:  " & $EA[$i][26], ($EA[$i][2] - $MyX) * 48 + $Reswidth + $WindowPosition[0] + 80, ($EA[$i][3] - $MyY) * 24 + $Resheight + $WindowPosition[1])
			;MouseMove(($EA[$i][2] - $MyX) * 48 + $UnalteredResWidth, ($EA[$i][3] - $MyY + 2) * 24 + $UnalteredResHeight, 0)
;~ 				ExitLoop
;~ 			EndIf

			If $SelectEntity = True And $Entity = $EA[$i][0] And $EntityName = $EA[$i][7] And $EntityID = $EA[$i][4] And $EA[$i][3] > ($MyY - $YEdge) And $EA[$i][3] < ($MyY + $YEdge) And $EA[$i][2] > ($MyX - $XEdge) And $EA[$i][2] < ($MyX + $XEdge) Then
				ToolTip($EA[$i][7] & " | " & $EA[$i][0] & " | " & $EA[$i][4] & @CRLF & _
						"Main X/Y:  " & $EA[$i][2] & " " & "/" & " " & $EA[$i][3] & @CRLF & _
						"HP :  " & $EA[$i][8] & " " & "/" & " " & $EA[$i][9] & @CRLF & _
						"MP :  " & $EA[$i][22] & " " & "/" & " " & $EA[$i][23] & @CRLF & _
						"BW :  " & $EA[$i][20] & " " & "/" & " " & $EA[$i][21] & @CRLF & _
						"Animstate:  " & $EA[$i][5] & @CRLF & _
						"Animstate2:  " & $EA[$i][14] & @CRLF & _
						"StaffAura:  " & $EA[$i][15] & @CRLF & _
						"Stance:  " & $EA[$i][16] & @CRLF & _
						"Level:  " & $EA[$i][17] & @CRLF & _
						"Grey:  " & $EA[$i][18] & @CRLF & _
						"Invis:  " & $EA[$i][19] & @CRLF & _
						"NPCorMob:  " & $EA[$i][6] & @CRLF & _
						"Dist:  " & $EA[$i][1] & @CRLF & _
						"Weaken:  " & $EA[$i][13] & @CRLF & _
						"Direction:  " & $EA[$i][25] & @CRLF & _
						"Mob Aggroed:  " & $EA[$i][26], ($EA[$i][2] - $MyX) * 48 + $Reswidth + $WindowPosition[0] + 80, ($EA[$i][3] - $MyY) * 24 + $Resheight + $WindowPosition[1])
;~ 			MouseMove(($EA[$i][2] - $MyX) * 48 + $UnalteredResWidth, ($EA[$i][3] - $MyY + 2) * 24 + $UnalteredResHeight, 0)
				ExitLoop
			EndIf
		Next
	EndIf
;~ 	tooltip($SelectEntity)
EndFunc   ;==>FillEntityArray



Func Navigation()
	If $boton = 1 Then
;~ 		============================================= Go To Nearest Node
		If $GoToNearestNode = True Then
			For $i = 1 To $MaxNodes Step 1
				$x = Abs($NavNodes[$i][0] - $MyX)
				$y = Abs($NavNodes[$i][1] - $MyY)
				$NavNodeDistance[$i][0] = $x + $y ; Saves the distance
				$NavNodeDistance[$i][1] = $i ; Keeps track of the NavNode number
			Next
			_ArraySort($NavNodeDistance, 0, 1, 0, 0, 0)
			If $NavNodeDistance[1][0] > $PlayertoNodeDistsetting And $NavNodes[$NavNodeDistance[1][1]][0] <> 0 And $NavNodes[$NavNodeDistance[1][1]][1] <> 0 Then
				NavigateToTarget($NavNodes[$NavNodeDistance[1][1]][0], $NavNodes[$NavNodeDistance[1][1]][1])
			ElseIf $NavNodeDistance[1][0] <= $PlayertoNodeDistsetting Then
				$EngagingNode = True
				$GoToNearestNode = False
				$TargetNode = $NavNodeDistance[1][1]
			EndIf
;~ 			================================================Engage Node
		EndIf

		If $EngagingNode = True Then ; Scan for entities at TargetNode
			If $PickupDropsSwitch = 1 Then
				Sleep(30)
;~ 				PickupDrops()
			EndIf
;~ 			$MobDropArray[10][0] = 0
;~ tooltip($AttackDistance)
			For $i = 0 To 38 Step 1
				$x = Abs($NavNodes[$TargetNode][0] - $EA[$i][2])
				$y = Abs($NavNodes[$TargetNode][1] - $EA[$i][3])
				$TargetDistanceFromNode = $x + $y
				For $h = 0 To 6 Step 1
;~ 					If $GhostArray[$h][0] <> 0 Then
;~ 						ToolTip($GhostArray[$h][0] & @CRLF & $EA[$i][0])
;~ 					EndIf
;~ 					sleep(500)
					If $GhostArray[$h][0] = $EA[$i][0] And $GhostArray[$h][0] <> 0 Then
;~ 						msgbox(1,"","Yo")
						$IsGhost = True
						ExitLoop
					ElseIf $h = 6 And $GhostArray[$h][0] <> $EA[$i][0] Then
						$IsGhost = False
					EndIf
				Next
;~ 				===============================================Target Selection Criteria
				If $TargetDistanceFromNode <= $NodeDistanceSetting And $EA[$i][6] = 1 And $EA[$i][24] > 0 And $EA[$i][24] < 7 And $EA[$i][1] > 0 And ($EA[$i][26] = $MyID Or $EA[$i][26] = 0) And $NavigatingToDrop = False And $IsGhost = False Then
					If $MyID = $EA[$i][26] Then
						$MobDropArray[10][0] = $EA[$i][0]
						$MobDropArray[10][1] = $EA[$i][7]
						$MobDropArray[10][2] = $EA[$i][2]
						$MobDropArray[10][3] = $EA[$i][3]
;~ 						ToolTip($MobDropArray[10][0], ($EA[$i][2] - $MyX) * 48 + 100 + $Reswidth + $WindowPosition[0], ($EA[$i][3] - $MyY) * 24 + $Resheight + $WindowPosition[1])
					EndIf
;~ 					ToolTip($MobDropArray[10][0], ($EA[$i][2] - $MyX) * 48 + 100 + $Reswidth + $WindowPosition[0], ($EA[$i][3] - $MyY) * 24 + $Resheight + $WindowPosition[1])
;~ 					ToolTip($EA[$i][7] & " | " & $EA[$i][0] & " | " & $EA[$i][4] & @CRLF & _
;~ 							"Main X/Y:  " & $EA[$i][2] & " " & "/" & " " & $EA[$i][3] & @CRLF & _
;~ 							"HP :  " & $EA[$i][8] & " " & "/" & " " & $EA[$i][9] & @CRLF & _
;~ 							"MP :  " & $EA[$i][22] & " " & "/" & " " & $EA[$i][23] & @CRLF & _
;~ 							"Animstate:  " & $EA[$i][5] & @CRLF & _
;~ 							"Animstate2:  " & $EA[$i][14] & @CRLF & _
;~ 							"Dist:  " & $EA[$i][1] & @CRLF & _
;~ 							"Speed:  " & $EA[$i][13] & @CRLF & _
;~ 							"Owner:  " & $EA[$i][27] & @CRLF & _
;~ 							"Ghost:  " & $GhostDetect & @CRLF & _
;~ 							"GhostArray:  " & $GhostArray[0][0] &" | " & $GhostArray[0][1] &" | " & $GhostArray[0][2] & @CRLF & _
;~ 							"Mob Drop:  " & $MobDropArray[10][0], ($EA[$i][2] - $MyX) * 48 + 140 + $Reswidth + $WindowPosition[0], ($EA[$i][3] - $MyY) * 24 + $Resheight + $WindowPosition[1])


					;GhostArray
;~ 					ToolTip("0:  " & $GhostArray[0][0] & " | " & $GhostArray[0][1] & " | " & $GhostArray[0][2] & @CRLF & _
;~ 							"1:  " & $GhostArray[1][0] & " | " & $GhostArray[1][1] & " | " & $GhostArray[1][2] & @CRLF & _
;~ 							"2:  " & $GhostArray[2][0] & " | " & $GhostArray[2][1] & " | " & $GhostArray[2][2] & @CRLF & _
;~ 							"3:  " & $GhostArray[3][0] & " | " & $GhostArray[3][1] & " | " & $GhostArray[3][2] & @CRLF & _
;~ 							"4:  " & $GhostArray[4][0] & " | " & $GhostArray[4][1] & " | " & $GhostArray[4][2] & @CRLF & _
;~ 							"5:  " & $GhostArray[5][0] & " | " & $GhostArray[5][1] & " | " & $GhostArray[5][2] & @CRLF & _
;~ 							"6:  " & $GhostArray[6][0] & " | " & $GhostArray[6][1] & " | " & $GhostArray[6][2], ($EA[$i][2] - $MyX) * 48 + 140 + $Reswidth + $WindowPosition[0], ($EA[$i][3] - $MyY) * 24 + $Resheight + $WindowPosition[1])

;~ 					"Speed:  " & $EA[$i][13], ($EA[$i][2] - $MyX) * 48 + 40 + $Reswidth + $WindowPosition[0], ($EA[$i][3] - $MyY) * 24 + $Resheight + $WindowPosition[1])
					;test navstuff
;~ 					ToolTip($i & " | " & $EA[$i][0] & " | " & $TargetNode & " | " & $TargetDistanceFromNode, ($EA[$i][2] - $MyX) * 48 + 120 + $Reswidth + $WindowPosition[0], ($EA[$i][3] - $MyY) * 24 + $Resheight + $WindowPosition[1])
;~ 					ToolTip($EA[$i][1] & " | " & $TargetNode, ($EA[$i][2] - $MyX) * 48 + 100 + $Reswidth + $WindowPosition[0], ($EA[$i][3] - $MyY) * 24 + $Resheight + $WindowPosition[1])
					; mob ownership related
;~ 					ToolTip("MobID:  " & $EA[$i][0] & @CRLF & "MyID:  " & $MyID & @CRLF & "Mob Owner:  " & $EA[$i][26] & @CRLF & "Mob Drop:  " & $MobDropArray[10][0] & @CRLF & "Anim:  " & $EA[$i][5], ($EA[$i][2] - $MyX) * 48 + 100 + $Reswidth + $WindowPosition[0], ($EA[$i][3] - $MyY) * 24 + $Resheight + $WindowPosition[1])
					If $BowModeSwitch = 0 And $IntModeToggle = 0 Then
						If $EA[$i][1] > $AttackDistance Then
							NavigateToTarget($EA[$i][2], $EA[$i][3])
						ElseIf $EA[$i][1] <= $AttackDistance Then
							AttackTarget($i)
						EndIf
					ElseIf $BowModeSwitch = 1 Or $IntModeToggle = 1 Then
						If $EA[$i][1] > $AttackDistance Then
							If $WeakenMode = 1 Then
;~ 								CalcNavWithinDistance($EA[$i][2], $EA[$i][3], $AttackDistance - $WeakenRange)
								CalcNavWithinDistance($EA[$i][2], $EA[$i][3], $WeakenRange / 2 - 1)
							ElseIf $WeakenMode = 0 Then
								CalcNavWithinDistance($EA[$i][2], $EA[$i][3], $AttackDistance / 2 - 1)
;~ 								tooltip($AttackDistance - $NavHuntTileDistance,100,100)
							EndIf
;~ 							tooltip($NearTargetX & " | " & $NearTargetY & @crlf & $EA[$i][2] & " | " & $EA[$i][3],300,300)
							NavigateToTarget($NearTargetX, $NearTargetY)
;~ 							ToolTip("Over:  " & $EA[$i][1] & " | " & $AttackDistance)
						ElseIf $EA[$i][1] <= $AttackDistance Then
							Send('{SHIFTDOWN}')
;~ 							ToolTip("Under:  " & $EA[$i][1] & " | " & $AttackDistance)
							AttackTarget($i)
							Send('{SHIFTUP}')
						EndIf
					EndIf
					ExitLoop
				ElseIf $i = 38 And $TargetDistanceFromNode > $NodeDistanceSetting And $NavigatingToDrop = False Then
					$InCombat = False
					$NavigatingNodes = True
					$EngagingNode = False
					If $NavNodeForward = True And $TargetNode < $NavNodes[0][0] Then
						$TargetNode += 1
					ElseIf $NavNodeForward = True And $TargetNode = $NavNodes[0][0] Then
						$NavNodeForward = False
						$TargetNode -= 1
					ElseIf $NavNodeForward = False And $TargetNode > 1 Then
						$TargetNode -= 1
					ElseIf $NavNodeForward = False And $TargetNode = 1 Then
						$NavNodeForward = True
						$TargetNode += 1
					EndIf
				EndIf
			Next
		EndIf
		If $NavigatingNodes = True Then
			$x = Abs($NavNodes[$TargetNode][0] - $MyX)
			$y = Abs($NavNodes[$TargetNode][1] - $MyY)
			$TargetNodeDistance = $x + $y
			If $TargetNodeDistance <= $PlayertoNodeDistsetting Then
				$NavigatingNodes = False
				$EngagingNode = True
			ElseIf $TargetNodeDistance >= $PlayertoNodeDistsetting And $NavNodes[$TargetNode][0] <> 0 And $NavNodes[$TargetNode][1] <> 0 Then
				NavigateToTarget($NavNodes[$TargetNode][0], $NavNodes[$TargetNode][1]) ; make this false if 0
			EndIf
		EndIf
	EndIf
EndFunc   ;==>Navigation



Func GuiUpdate()
;~ 	$NodeDistanceSetting = GUICtrlRead($NodeDistanceSettingBox)
;~ 	$AutoNavNodeDistanceSetting = GUICtrlRead($AutoNavNodeDistanceSettingBox)
;~ 	$PlayertoNodeDistsetting = GUICtrlRead($PlayertoNodeDistSettingBox)
;~ 	If $WeakenMode = 0 Then
;~ 		$AttackDistance = GUICtrlRead($AttackDistanceSettingBox)
;~ 	EndIf
;~ 	tooltip($AttackDistance)
;~ 	If $ArrayDisplayWindows = True Then
;~ 		GUISetState(@SW_LOCK, $AntiMobstealGUI)
;~ 		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($AntiMobstealListView))
		;_GUICtrlListView_AddArray($AntiMobstealListView, $AntiMobstealArray)
		;_GUICtrlListView_AddArray($AntiMobstealListView, $DeadMobArray)
;~ 		_GUICtrlListView_AddArray($AntiMobstealListView, $MobContestedArray)
;~ 		GUISetState(@SW_UNLOCK, $AntiMobstealGUI)
;~ 		GUISetState(@SW_LOCK, $EntityArrayGUI)
;~ 		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($EntityArrayListView)) ; items added with UDF function can be deleted using UDF function
;~ 		_GUICtrlListView_AddArray($EntityArrayListView, $EA)
;~ 		GUISetState(@SW_UNLOCK, $EntityArrayGUI)
;~ 	EndIf
EndFunc   ;==>GuiUpdate



Func Stamina()
	$staminactrl = _KDMemory_ReadProcessMemory($handles, 0x0536780, 'DWORD', $offsets = 0)
	If $staminactrl = 0 Then
		$stamaddress = _KDMemory_WriteProcessMemory($handles, 0x0536780, 'DWORD', 1, $offsets = 0)
	EndIf
EndFunc   ;==>Stamina
#EndRegion ################## Main Loop Functions #######################################################################################


#Region ################## Core Functions #######################################################################################










Func DevModeToggle()
	If $DevMode = False Then
		HotKeySet("!z", "DevModeToggle2")
		$DevModeTimer[0] = TimerInit()
	ElseIf $DevMode = True Then
		$DevMode = False
		MsgBox(0, "", "Off", 1)
	EndIf
EndFunc   ;==>DevModeToggle

Func DevModeToggle2()
	$DevMode = True
	SoundPlay(@ScriptDir & "\alarm_beep.wav", 0)
	MsgBox(0, "", "On", 1)
	HotKeySet("!z")
	$DevModeTimer[0] = 0
	$DevModeTimer[1] = 0
EndFunc   ;==>DevModeToggle2





Func AttackTarget($TargetEntity)
	$cursorrotationwidth = Random(10, 35, 0)
	$cursorrotationheight = Random(35, 45, 0)
	$InCombat = True
	Sleep(20)
	If WinActive($NameOfSomaWindow) Then
		For $R = 360 To 0 Step $rotationspeedandsmoothness
			$Rad = _Radian($R)
			$clickmobcoordsx = Sin($Rad) * $cursorrotationwidth + ($EA[$TargetEntity][2] - $MyX) * 48 + $MoveMPositionX
			$clickmobcoordsy = Cos($Rad) * $cursorrotationheight + ($EA[$TargetEntity][3] - $MyY) * 24 + $MoveMPositionY
			MouseMove(($clickmobcoordsx), ($clickmobcoordsy), 1)
			$EntityCursorTooltip = _KDMemory_ReadProcessMemory($handles, 0x06d85F8, 'DWORD', 0)
			If $EA[$TargetEntity][0] = $EntityCursorTooltip Then
					MouseClick("Left")
				ExitLoop
			EndIf
		Next
	Else
		WinActivate($NameOfSomaWindow)
		WinWaitActive($NameOfSomaWindow)
	EndIf
EndFunc   ;==>AttackTarget


Func NavigateToTarget($TargetX, $TargetY)
;~ 	msgbox(1,"",$TargetX & "   " & $TargetY)
	$NavHuntTileDistance = Random($MinDistance, $MaxDistance, 0) ; How many tiles away the bot clicks for movement when navigating. (Too high a value will cause clicks outside the window!) - Default 2,4,1
	If WinActive($NameOfSomaWindow) Then
		If $TargetX <= $MyX Then ; if the mob is placed less than chars current X Coords
			Do
				$TargetX += 1
			Until Abs($TargetX - $MyX) <= $NavHuntTileDistance
			If $TargetY > $MyY Then
				Do
					$TargetY -= 1
				Until Abs($TargetY - $MyY) <= $NavHuntTileDistance
			EndIf
			If $TargetY < $MyY Then
				Do
					$TargetY += 1
				Until Abs($TargetY - $MyY) <= $NavHuntTileDistance
			EndIf
			MouseMove(($TargetX - $MyX) * 48 + $Reswidth, ($TargetY - $MyY) * 24 + $Resheight, 0)
			Sleep(30)
			$CursorStatus = _KDMemory_ReadProcessMemory($handles, 0x06dd468, 'DWORD', $CursorStatusoffsets)
			$EntityCursorTooltip = _KDMemory_ReadProcessMemory($handles, 0x06d85F8, 'DWORD', $offsets = 0)
			If $CursorStatus = 0 And $EntityCursorTooltip = 4294967295 Then
				ToolTip("")
				MouseClick("Left")
			Else
				Do
					$TargetX -= 1
					If $TargetY > $MyY Then
						$TargetY += 1
					ElseIf $TargetY < $MyY Then
						$TargetY -= 1
					EndIf
					ToolTip("")
					MouseMove(($TargetX - $MyX) * 48 + $Reswidth, ($TargetY - $MyY) * 24 + $Resheight, 0)
					Sleep(30)
					$CursorStatus = _KDMemory_ReadProcessMemory($handles, 0x06dd468, 'DWORD', $CursorStatusoffsets)
					$EntityCursorTooltip = _KDMemory_ReadProcessMemory($handles, 0x06d85F8, 'DWORD', $offsets = 0)
				Until $CursorStatus = 0 And $EntityCursorTooltip = 4294967295
				MouseClick("Left")
			EndIf
		ElseIf $TargetX > $MyX Then
			Do
				$TargetX -= 1
			Until Abs($TargetX - $MyX) <= $NavHuntTileDistance
			If $TargetY > $MyY Then
				Do
					$TargetY -= 1
				Until Abs($TargetY - $MyY) <= $NavHuntTileDistance
			EndIf
			If $TargetY < $MyY Then
				Do
					$TargetY += 1
				Until Abs($TargetY - $MyY) <= $NavHuntTileDistance
			EndIf
			MouseMove(($TargetX - $MyX) * 48 + $Reswidth, ($TargetY - $MyY) * 24 + $Resheight, 0)
			Sleep(30)
			$CursorStatus = _KDMemory_ReadProcessMemory($handles, 0x06dd468, 'DWORD', $CursorStatusoffsets)
			$EntityCursorTooltip = _KDMemory_ReadProcessMemory($handles, 0x06d85F8, 'DWORD', $offsets = 0)
			If $CursorStatus = 0 And $EntityCursorTooltip = 4294967295 Then
				ToolTip("")
				MouseClick("Left")
			Else
				Do
					$TargetX += 1
					If $TargetY > $MyY Then
						$TargetY += 1
					ElseIf $TargetY < $MyY Then
						$TargetY -= 1
					EndIf
					ToolTip("")
					MouseMove(($TargetX - $MyX) * 48 + $Reswidth, ($TargetY - $MyY) * 24 + $Resheight, 0)
					Sleep(30)
					$CursorStatus = _KDMemory_ReadProcessMemory($handles, 0x06dd468, 'DWORD', $CursorStatusoffsets)
					$EntityCursorTooltip = _KDMemory_ReadProcessMemory($handles, 0x06d85F8, 'DWORD', $offsets = 0)
				Until $CursorStatus = 0 And $EntityCursorTooltip = 4294967295
				MouseClick("Left")
			EndIf
		EndIf
	Else
		WinActivate($NameOfSomaWindow)
		WinWaitActive($NameOfSomaWindow)
	EndIf
;~ 	Sleep(100)
EndFunc   ;==>NavigateToTarget


Func SelectEntity()
	If $SelectEntity = True Then
;~ 		ToolTip("Stopped")
		$SelectEntity = False
		$Firstrun = True
	ElseIf $SelectEntity = False Then

		$SelectEntity = True
;~ 		Global $BigArray[193][6] ; first value | second value | offset | First Value | Second Value
		ToolTip("starting")
		$EntityCursorTooltip = _KDMemory_ReadProcessMemory($handles, 0x06d85F8, 'DWORD', $offsets = 0)
		$Entity = $EntityCursorTooltip ;
		For $i = 0 To 38 Step 1
			If $EA[$i][0] = $Entity Then
				$EntityName = $EA[$i][7]
				$EntityID = $EA[$i][4]
				ExitLoop
			EndIf
		Next
		If $EntityCursorTooltip = 4294967295 Then
			$Entity = ""
			ToolTip("")
		EndIf
	EndIf
EndFunc   ;==>SelectEntity

Func AutoNavNode()
;~ 	tooltip("gffsdfsdf")
	If $AutoNavNodeSwitch = 1 Then
		$x = Abs($LastNodePositionX - $MyX)
		$y = Abs($LastNodePositionY - $MyY)
		$LastNodeDistance = $x + $y ; Saves the distance
		If $LastNodeDistance >= $AutoNavNodeDistanceSetting Then
			AddNavNode()
			$LastNodePositionX = $MyX
			$LastNodePositionY = $MyY
		EndIf
		ToolTip("(*)", ($LastNodePositionX - $MyX) * 48 + $Reswidth + $WindowPosition[0], ($LastNodePositionY - $MyY) * 24 + $Resheight + $WindowPosition[1])
	EndIf
EndFunc   ;==>AutoNavNode


#Region ################## Nav Nodes #######################################################################################


Func AutoNavNodeSwitch()
	If $AutoNavNodeSwitch = 0 Then
		$LastNodePositionX = $MyX
		$LastNodePositionY = $MyY
		$AutoNavNodeSwitch = 1
		GUICtrlSetData($AutoNavNodeLabel, "Auto NavNode(ALT + E): " & $AutoNavNodeSwitch)
	ElseIf $AutoNavNodeSwitch = 1 Then
		$AutoNavNodeSwitch = 0
		GUICtrlSetData($AutoNavNodeLabel, "Auto NavNode(ALT + E): " & $AutoNavNodeSwitch)
		ToolTip("")
	EndIf
EndFunc   ;==>AutoNavNodeSwitch


Func AddNavNode()
	If $NavNodes[0][0] <= $MaxNodes - 1 Then
		$NavNodes[0][0] += 1
		$NavNodes[$NavNodes[0][0]][0] = $MyX
		$NavNodes[$NavNodes[0][0]][1] = $MyY
		If $AutoNavNodeSwitch = 1 Then
			$LastNodePositionX = $MyX
			$LastNodePositionY = $MyY
		EndIf
		GUICtrlSetData($NumOfNavNodesLabel, "No. of Nodes: " & $NavNodes[0][0])
	ElseIf $NavNodes[0][0] = $MaxNodes Then
		MsgBox(0, "", "Max Nodes Reached", 1)
		$AutoNavNodeSwitch = 0
		GUICtrlSetData($NumOfNavNodesLabel, "No. of Nodes: " & $NavNodes[0][0])
		GUICtrlSetData($AutoNavNodeLabel, "Auto NavNode(ALT + E): " & $AutoNavNodeSwitch)
	EndIf

;~ 	ToolTip($NavNodes[0][0] & @CRLF & $NavNodes[$NavNodes[0][0]][0] & " / " & $NavNodes[$NavNodes[0][0]][1])

EndFunc   ;==>AddNavNode

Func ResetNavNode()
	For $i = 1 To $MaxNodes Step 1
		$NavNodes[0][0] = 0
		$NavNodes[$i][0] = 0
		$NavNodes[$i][1] = 0
	Next
	GUICtrlSetData($NumOfNavNodesLabel, "No. of Nodes: " & $NavNodes[0][0])
	ToolTip("Cleared!")
	Sleep(1000)
	ToolTip("")
EndFunc   ;==>ResetNavNode
#EndRegion ################## Nav Nodes #######################################################################################



#Region ################## GUI Main #######################################################################################

Func SelectTargetMob($PickButton) ; Needs linking to gui, array expanding for mob names, hotkey
	WinActivate("Myth of Soma : Molten Meltdown");Switches to window
	MouseMove(4 * 48 + $Reswidth, 14 * 24 + $Resheight, 0)
	$SelectTargetMobLoop = 1
	While $SelectTargetMobLoop = 1
		FillEntityArray()
		$EntityCursorTooltip = _KDMemory_ReadProcessMemory($handles, 0x06d85F8, 'DWORD', $offsets = 0)
		$TargetMob = $EntityCursorTooltip ;
		If $EntityCursorTooltip = 4294967295 Then
			ToolTip("Hover over a Mob to pick it")
		EndIf
		For $i = 0 To 38 Step 1
			If $EA[$i][0] = $TargetMob And $EA[$i][6] = 1 And $EA[$i][4] <> 800 And $EA[$i][0] <> 27206 Then
				$TargetMobArray[$PickButton][0] = $EA[$i][4]
				$TargetMobArray[$PickButton][1] = $EA[$i][7]
				Select
					Case $PickButton = 1
						GUICtrlSetData($TargetMob1Label, $TargetMobArray[1][1])
					Case $PickButton = 2
						GUICtrlSetData($TargetMob2Label, $TargetMobArray[2][1])
					Case $PickButton = 3
						GUICtrlSetData($TargetMob3Label, $TargetMobArray[3][1])
					Case $PickButton = 4
						GUICtrlSetData($TargetMob4Label, $TargetMobArray[4][1])
					Case $PickButton = 5
						GUICtrlSetData($TargetMob5Label, $TargetMobArray[5][1])
					Case $PickButton = 6
						GUICtrlSetData($TargetMob6Label, $TargetMobArray[6][1])
				EndSelect
				ToolTip($EA[$i][7] & " has been picked!")
				Sleep(1000)
				$SelectTargetMobLoop = 0
				ToolTip("")
				ExitLoop
			EndIf
		Next
	WEnd
EndFunc   ;==>SelectTargetMob



Func gui()
	Global $BotSettingsGUI = GUICreate($word, 353, 400, 795, 357)
	Global $Group1 = GUICtrlCreateGroup("Target Mob Priority", 8, 40, 153, 121)
	Global $TargetMob1Label = GUICtrlCreateLabel("Target Mob 1", 16, 56, 92, 17)
	Global $TargetMob2Label = GUICtrlCreateLabel("Target Mob 2", 16, 72, 92, 17)
	Global $TargetMob3Label = GUICtrlCreateLabel("Target Mob 3", 16, 88, 92, 17)
	Global $TargetMob4Label = GUICtrlCreateLabel("Target Mob 4", 16, 104, 92, 17)
	Global $TargetMob5Label = GUICtrlCreateLabel("Target Mob 5", 16, 120, 92, 17)
	Global $TargetMob6Label = GUICtrlCreateLabel("Target Mob 6", 16, 136, 92, 17)
	Global $TargetMobButton1 = GUICtrlCreateButton("Pick", 104, 56, 50, 15)
	Global $TargetMobButton2 = GUICtrlCreateButton("Pick", 104, 72, 50, 15)
	Global $TargetMobButton3 = GUICtrlCreateButton("Pick", 104, 88, 50, 15)
	Global $TargetMobButton4 = GUICtrlCreateButton("Pick", 104, 104, 50, 15)
	Global $TargetMobButton5 = GUICtrlCreateButton("Pick", 104, 120, 50, 15)
	Global $TargetMobButton6 = GUICtrlCreateButton("Pick", 104, 136, 50, 15)
	GUICtrlSetOnEvent($TargetMobButton1, "PickButton1")
	GUICtrlSetOnEvent($TargetMobButton2, "PickButton2")
	GUICtrlSetOnEvent($TargetMobButton3, "PickButton3")
	GUICtrlSetOnEvent($TargetMobButton4, "PickButton4")
	GUICtrlSetOnEvent($TargetMobButton5, "PickButton5")
	GUICtrlSetOnEvent($TargetMobButton6, "PickButton6")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Global $Navigation = GUICtrlCreateGroup("Navigation and Distances", 8, 168, 153, 150)
	Global $NumOfNavNodesLabel = GUICtrlCreateLabel("No. of Nodes: " & $NavNodes[0][0], 16, 192, 110, 17)
	Global $NavNode = GUICtrlCreateLabel("Mob to Node:", 16, 216, 90, 17)
	Global $NodeDistanceSettingBox = GUICtrlCreateInput($NodeDistanceSetting, 112, 208, 21, 21)
	Global $PlayertoNodeDistsettingLabel = GUICtrlCreateLabel("Player to Node:", 16, 240, 90, 17)
	Global $PlayertoNodeDistSettingBox = GUICtrlCreateInput($PlayertoNodeDistsetting, 112, 232, 21, 21)
	Global $AutoNavNodeLabel = GUICtrlCreateLabel("AutoNode Dist:", 16, 264, 90, 17)
	Global $AutoNavNodeDistanceSettingBox = GUICtrlCreateInput($AutoNavNodeDistanceSetting, 112, 256, 21, 21)
	Global $ResetNavNodeButton = GUICtrlCreateButton("Reset", 111, 180, 38, 25)
	Global $AttackDistanceLabel = GUICtrlCreateLabel("Attack Distance:", 16, 288, 90, 17)
	Global $AttackDistanceSettingBox = GUICtrlCreateInput($AttackDistance, 112, 280, 21, 21)
	GUICtrlSetOnEvent($ResetNavNodeButton, "ResetNavNode")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Global $Settings = GUICtrlCreateGroup("Settings", 176, 40, 169, 201)
	Global $StartStopSomaBot = GUICtrlCreateLabel("Start/Stop(DEL): " & $boton, 184, 56, 155, 17)
	Global $AutoHPPotsLabel = GUICtrlCreateLabel("Auto HP Pots(ALT + F1): " & $AutoHPPots, 184, 72, 156, 17)
	Global $AutoMPPotsLabel = GUICtrlCreateLabel("Auto MP Pots(ALT + F2): " & $AutoMPPots, 184, 89, 157, 17)
	Global $MobSelectionLabel = GUICtrlCreateLabel("Mob Selection(ALT + M): " & $MobSelectionSwitch, 184, 106, 157, 17)
	Global $AutoNavNodeLabel = GUICtrlCreateLabel("Auto NavNode(ALT + E): " & $AutoNavNodeSwitch, 184, 123, 157, 17)
	Global $MeleeAuraLabel = GUICtrlCreateLabel("Melee Aura(ALT + O): " & $MeleeAuraSwitch, 184, 140, 157, 17)
	Global $BowModeSwitchLabel = GUICtrlCreateLabel("Bow Mode(ALT + P): " & $BowModeSwitch, 184, 157, 157, 17)
	Global $StaffAuraLabel = GUICtrlCreateLabel("Staff Aura(ALT + I): " & $StaffAuraToggle, 184, 174, 157, 17)
	Global $IntModeLabel = GUICtrlCreateLabel("Int Mode(ALT + U): " & $IntModeToggle, 184, 191, 157, 17)
	Global $WeakenModeLabel = GUICtrlCreateLabel("Weaken Mode(ALT + Y): " & $WeakenMode, 184, 208, 157, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Global $SaveProfileButton = GUICtrlCreateButton("Save Profile", 176, 8, 75, 25)
	Global $LoadProfile = GUICtrlCreateButton("Load Profile", 264, 8, 75, 25)
	Global $ProfileLabel = GUICtrlCreateLabel("Profile: None", 16, 16, 145, 17)
	GUICtrlSetOnEvent($SaveProfileButton, "SaveProfile")
	GUICtrlSetOnEvent($LoadProfile, "LoadProfile")
	GUISetState(@SW_SHOW)
	MobSelection()
	MobSelection()
	MobSelection()
	WinActivate($NameOfSomaWindow);Switches to window
EndFunc   ;==>gui

Func LoadProfile()
	; Display an open dialog to select a list of file(s).
	Local $sFileOpenDialog = FileOpenDialog("Load Profile", @ScriptDir & "\Profiles", "Config files (*.ini)", $FD_FILEMUSTEXIST)
	If @error Then
		; Display the error message.
		MsgBox($MB_SYSTEMMODAL, "", "No file has been selected.", 1)
	Else
		$TargetMobArray[1][1] = IniRead($sFileOpenDialog, "TargetMobs", "TargetMobName1", "TargetMob1")
		$TargetMobArray[1][0] = IniRead($sFileOpenDialog, "TargetMobs", "TargetMobID1", 0)
		GUICtrlSetData($TargetMob1Label, $TargetMobArray[1][1])
		$TargetMobArray[2][1] = IniRead($sFileOpenDialog, "TargetMobs", "TargetMobName2", "TargetMob2")
		$TargetMobArray[2][0] = IniRead($sFileOpenDialog, "TargetMobs", "TargetMobID2", 0)
		GUICtrlSetData($TargetMob2Label, $TargetMobArray[2][1])
		$TargetMobArray[3][1] = IniRead($sFileOpenDialog, "TargetMobs", "TargetMobName3", "TargetMob3")
		$TargetMobArray[3][0] = IniRead($sFileOpenDialog, "TargetMobs", "TargetMobID3", 0)
		GUICtrlSetData($TargetMob3Label, $TargetMobArray[3][1])
		$TargetMobArray[4][1] = IniRead($sFileOpenDialog, "TargetMobs", "TargetMobName4", "TargetMob4")
		$TargetMobArray[4][0] = IniRead($sFileOpenDialog, "TargetMobs", "TargetMobID4", 0)
		GUICtrlSetData($TargetMob4Label, $TargetMobArray[4][1])
		$TargetMobArray[5][1] = IniRead($sFileOpenDialog, "TargetMobs", "TargetMobName5", "TargetMob5")
		$TargetMobArray[5][0] = IniRead($sFileOpenDialog, "TargetMobs", "TargetMobID5", 0)
		GUICtrlSetData($TargetMob5Label, $TargetMobArray[5][1])
		$TargetMobArray[6][1] = IniRead($sFileOpenDialog, "TargetMobs", "TargetMobName6", "TargetMob6")
		$TargetMobArray[6][0] = IniRead($sFileOpenDialog, "TargetMobs", "TargetMobID6", 0)
		GUICtrlSetData($TargetMob6Label, $TargetMobArray[6][1])
		$NavNodes[0][0] = IniRead($sFileOpenDialog, "Navigation", "NumberOfNodes", 0)
		GUICtrlSetData($NumOfNavNodesLabel, "No. of Nodes: " & $NavNodes[0][0])
		For $i = 1 To $NavNodes[0][0] Step 1
			$NavNodes[$i][0] = IniRead($sFileOpenDialog, "NavNodes", "X" & $i, "")
			$NavNodes[$i][1] = IniRead($sFileOpenDialog, "NavNodes", "Y" & $i, "")
		Next

		$NodeDistanceSetting = IniRead($sFileOpenDialog, "Navigation", "NodeDistance", 12)
		GUICtrlSetData($NodeDistanceSettingBox, $NodeDistanceSetting)
		$AutoNavNodeDistanceSetting = IniRead($sFileOpenDialog, "Navigation", "AutoNavNodeDistanceSetting", 4)
		GUICtrlSetData($AutoNavNodeDistanceSettingBox, $AutoNavNodeDistanceSetting)
		$PlayertoNodeDistsetting = IniRead($sFileOpenDialog, "Navigation", "PlayertoNodeDist", 4)
		GUICtrlSetData($PlayertoNodeDistSettingBox, $PlayertoNodeDistsetting)

		$AttackDistance = IniRead($sFileOpenDialog, "Settings", "AttackDistance", 12)
		GUICtrlSetData($AttackDistanceSettingBox, $AttackDistance)

		Local $sFileName = StringTrimLeft($sFileOpenDialog, StringInStr($sFileOpenDialog, "\", $STR_NOCASESENSE, -1))
		GUICtrlSetData($ProfileLabel, "Profile: " & $sFileName)
		MobSelection()
		MobSelection()
		MobSelection()

		; Replace instances of "|" with @CRLF in the string returned by FileOpenDialog.
		$sFileOpenDialog = StringReplace($sFileOpenDialog, "|", @CRLF)

		; Display the list of selected files.
		MsgBox($MB_SYSTEMMODAL, "", "You loaded:" & @CRLF & $sFileOpenDialog, 1)
		WinActivate($NameOfSomaWindow)
	EndIf
EndFunc   ;==>LoadProfile

Func SaveProfile()
	Local $sFileSaveDialog = FileSaveDialog("Save profile as", @ScriptDir & "\Profiles", "Config files (*.ini)", 16)
	If @error Then
		; Display the error message.
		MsgBox($MB_SYSTEMMODAL, "", "No file was saved.", 1)
	Else
		IniWrite($sFileSaveDialog, "TargetMobs", "TargetMobName1", $TargetMobArray[1][1])
		IniWrite($sFileSaveDialog, "TargetMobs", "TargetMobID1", $TargetMobArray[1][0])
		IniWrite($sFileSaveDialog, "TargetMobs", "TargetMobName2", $TargetMobArray[2][1])
		IniWrite($sFileSaveDialog, "TargetMobs", "TargetMobID2", $TargetMobArray[2][0])
		IniWrite($sFileSaveDialog, "TargetMobs", "TargetMobName3", $TargetMobArray[3][1])
		IniWrite($sFileSaveDialog, "TargetMobs", "TargetMobID3", $TargetMobArray[3][0])
		IniWrite($sFileSaveDialog, "TargetMobs", "TargetMobName4", $TargetMobArray[4][1])
		IniWrite($sFileSaveDialog, "TargetMobs", "TargetMobID4", $TargetMobArray[4][0])
		IniWrite($sFileSaveDialog, "TargetMobs", "TargetMobName5", $TargetMobArray[5][1])
		IniWrite($sFileSaveDialog, "TargetMobs", "TargetMobID5", $TargetMobArray[5][0])
		IniWrite($sFileSaveDialog, "TargetMobs", "TargetMobName6", $TargetMobArray[6][1])
		IniWrite($sFileSaveDialog, "TargetMobs", "TargetMobID6", $TargetMobArray[6][0])
		IniWrite($sFileSaveDialog, "Navigation", "NumberOfNodes", $NavNodes[0][0])
		IniWrite($sFileSaveDialog, "Navigation", "NodeDistance", $NodeDistanceSetting)
		IniWrite($sFileSaveDialog, "Navigation", "AutoNavNodeDistanceSetting", $AutoNavNodeDistanceSetting)
		IniWrite($sFileSaveDialog, "Navigation", "PlayertoNodeDist", $PlayertoNodeDistsetting)
		IniWrite($sFileSaveDialog, "Settings", "AttackDistance", $AttackDistance)
		For $i = 1 To $MaxNodes Step 1
			IniWrite($sFileSaveDialog, "NavNodes", "X" & $i, $NavNodes[$i][0])
			IniWrite($sFileSaveDialog, "NavNodes", "Y" & $i, $NavNodes[$i][1])
		Next
		; Retrieve the filename from the filepath e.g. Example.au3.
		Local $sFileName = StringTrimLeft($sFileSaveDialog, StringInStr($sFileSaveDialog, "\", $STR_NOCASESENSE, -1))
		; Check if the extension .au3 is appended to the end of the filename.
		Local $iExtension = StringInStr($sFileName, ".", $STR_NOCASESENSE)
		; If a period (dot) is found then check whether or not the extension is equal to .au3.
		If $iExtension Then
			; If the extension isn't equal to .au3 then append to the end of the filepath.
			If Not (StringTrimLeft($sFileName, $iExtension - 1) = ".ini") Then $sFileSaveDialog &= ".ini"
		Else
			; If no period (dot) was found then append to the end of the file.
			$sFileSaveDialog &= ".ini"
		EndIf
		; Display the saved file.
		MsgBox($MB_SYSTEMMODAL, "", "You saved the following file:" & @CRLF & $sFileSaveDialog, 1)
		WinActivate($NameOfSomaWindow)
	EndIf

EndFunc   ;==>SaveProfile
Func PickButton1()
	$PickButton = 1
	SelectTargetMob($PickButton)
EndFunc   ;==>PickButton1
Func PickButton2()
	$PickButton = 2
	SelectTargetMob($PickButton)
EndFunc   ;==>PickButton2
Func PickButton3()
	$PickButton = 3
	SelectTargetMob($PickButton)
EndFunc   ;==>PickButton3
Func PickButton4()
	$PickButton = 4
	SelectTargetMob($PickButton)
EndFunc   ;==>PickButton4
Func PickButton5()
	$PickButton = 5
	SelectTargetMob($PickButton)
EndFunc   ;==>PickButton5
Func PickButton6()
	$PickButton = 6
	SelectTargetMob($PickButton)
EndFunc   ;==>PickButton6
#EndRegion ################## GUI Main #######################################################################################



#Region ################## Switches #######################################################################################
Func botonoff()
	If $boton = 0 Then
		$boton = 1
		GUICtrlSetData($StartStopSomaBot, "Start/Stop(DEL): " & $boton)
		Authenticate()
		WinSetOnTop($NameOfSomaWindow, "", 1)
		If $CPUMAC <> $CPUMAC2 Then
			$boton = 2
;~ 			msgbox(1,"","   ")
		EndIf
	ElseIf $boton = 1 Then
		WinSetOnTop($NameOfSomaWindow, "", 0)
		$boton = 0
		$NavigatingNodes = False
		$GoToNearestNode = True
		$EngagingNode = False
		GUICtrlSetData($StartStopSomaBot, "Start/Stop(DEL): " & $boton)
	EndIf
EndFunc   ;==>botonoff



Func MeleeAuraSwitch()
	If $MeleeAuraSwitch = 0 Then
		$MeleeAuraSwitch = 1
		GUICtrlSetData($MeleeAuraLabel, "Melee Aura(ALT + O): " & $MeleeAuraSwitch)
	ElseIf $MeleeAuraSwitch = 1 Then
		$MeleeAuraSwitch = 0
		GUICtrlSetData($MeleeAuraLabel, "Melee Aura(ALT + O): " & $MeleeAuraSwitch)
	EndIf
EndFunc   ;==>MeleeAuraSwitch

Func BowModeSwitch()
	If $BowModeSwitch = 0 Then
		$BowModeSwitch = 1
		GUICtrlSetData($BowModeSwitchLabel, "Bow Mode(ALT + P): " & $BowModeSwitch)
		$IntModeToggle = 0
		GUICtrlSetData($IntModeLabel, "Int Mode(ALT + U): " & $IntModeToggle)
	ElseIf $BowModeSwitch = 1 Then
		$BowModeSwitch = 0
		GUICtrlSetData($BowModeSwitchLabel, "Bow Mode(ALT + P): " & $BowModeSwitch)
	EndIf
EndFunc   ;==>BowModeSwitch



Func AutoHPPotsSwitch()
	If $AutoHPPots = 0 Then
		$AutoHPPots = 1
		GUICtrlSetData($AutoHPPotsLabel, "Auto HP Pots(ALT + F1): " & $AutoHPPots)
	ElseIf $AutoHPPots = 1 Then
		$AutoHPPots = 0
		GUICtrlSetData($AutoHPPotsLabel, "Auto HP Pots(ALT + F1): " & $AutoHPPots)
	EndIf
EndFunc   ;==>AutoHPPotsSwitch



Func AutoMPPotsSwitch()
	If $AutoMPPots = 0 Then
		$AutoMPPots = 1
		GUICtrlSetData($AutoMPPotsLabel, "Auto MP Pots(ALT + F2): " & $AutoMPPots)
	ElseIf $AutoMPPots = 1 Then
		$AutoMPPots = 0
		GUICtrlSetData($AutoMPPotsLabel, "Auto MP Pots(ALT + F2): " & $AutoMPPots)
	EndIf
EndFunc   ;==>AutoMPPotsSwitch



Func Quit()
	FileChangeDir(@ScriptDir)
	If $Map = 1 And $NavmeshRecording = True Then
		_FileWriteFromArray("NavMesh/TYTnavmesh.csv", $TYTnavmesh, Default, Default, ",")
	ElseIf $Map = 5 And $NavmeshRecording = True Then
		_FileWriteFromArray("NavMesh/ABIASnavmesh.csv", $ABIASnavmesh, Default, Default, ",")
	ElseIf $Map = 4 And $NavmeshRecording = True Then
		_FileWriteFromArray("NavMesh/MERCnavmesh.csv", $MERCnavmesh, Default, Default, ",")
	EndIf
	ToolTip('')
	MsgBox(0, "", "Exiting", 1)
	Send('{SHIFTUP}')
	WinSetOnTop($NameOfSomaWindow, "", 0)
	WinActivate($NameOfSomaWindow)
	Exit
EndFunc   ;==>Quit
#EndRegion ################## Switches #######################################################################################



#Region ################## NavMesh #######################################################################################
Func WriteToNavmesh()
	FileChangeDir(@ScriptDir)
	If $Map = 1 And $NavmeshRecording = True Then
		_FileWriteFromArray("NavMesh/TYTnavmesh.csv", $TYTnavmesh, Default, Default, ",")
	ElseIf $Map = 5 And $NavmeshRecording = True Then
		_FileWriteFromArray("NavMesh/ABIASnavmesh.csv", $ABIASnavmesh, Default, Default, ",")
	ElseIf $Map = 4 And $NavmeshRecording = True Then
		_FileWriteFromArray("NavMesh/MERCnavmesh.csv", $MERCnavmesh, Default, Default, ",")
	EndIf
;~ 	ToolTip("Saved")
EndFunc   ;==>WriteToNavmesh

Func NavMeshArrayDisplay()
	$LeftEdge = Int($MyX - $XEdge)
	$RightEdge = Int($MyX + $XEdge)
	$TopEdge = ($MyY - $YEdge)
	$BottomEdge = ($MyY + $YEdge)
;~ 	_ArrayDisplay($MERCnavmesh, "", $TopEdge & ":" & $BottomEdge & "|" & $LeftEdge & ":" & $RightEdge)
;~ 	_ArrayDisplay($TYTnavmesh, "", $TopEdge & ":" & $BottomEdge & "|" & $LeftEdge & ":" & $RightEdge)
	_ArrayDisplay($EA, "Entity array")
	_ArrayDisplay($AntiMobstealArray, "Antimobsteal array")
;~ 	_ArrayDisplay($MobContestedArray, "MobContestedArray")

;~ 	_ArrayDisplay($BigArray, "oh bae")
EndFunc   ;==>NavMeshArrayDisplay
#EndRegion ################## NavMesh #######################################################################################



Func Authenticate()
	Global $Checksum = 0
;~ 	Global $LicenseArray[500][500]
	_FileReadToArray(@ScriptDir & "\License.som", $LicenseArray, 0, "|")
;~ 	msgbox(1,"",$LicenseArray[$Placement - 1][0])
;~ _ArrayDisplay($LicenseArray,"")
	$LicenseSize = $LicenseArray[$Placement - 1][0]
	Global $CPUMACArray[$LicenseSize]
	For $i = $Placement To $LicenseSize + $Placement - 1 Step 1
		$CPUMACArray[$i - $Placement] = $LicenseArray[$i][$Placement]
	Next
	$CPUMACArray[5] -= 1
	$CPUMACArray[25] += 1
	Global $CPUMAC = StringFromASCIIArray($CPUMACArray)
;~ 	ToolTip($CPUMAC)
	$strComputer = "localhost"
	$wbemFlagReturnImmediately = 0x10
	$wbemFlagForwardOnly = 0x20
	$colItems = ""
	$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
;~ ================== Processor ID ===========================================================================
	$oWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
	$colItems = $oWMIService.ExecQuery("SELECT * FROM Win32_Processor", _
			"WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If IsObj($colItems) Then
		For $objItem In $colItems
			$CPU2 = $objItem.ProcessorId
		Next
	EndIf

;~ ================== MAC ADDRESS ===========================================================================
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration", "WQL", _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If IsObj($colItems) Then
		For $objItem In $colItems
			If $CPU2 & $objItem.MACAddress = $CPUMAC Then ; check for mac address
				$MAC2 = $objItem.MACAddress
;~ MsgBox(1, "", "MAC Passed")
			EndIf
		Next
	EndIf
	Global $CPUMAC2 = $CPU2 & $MAC2
;~ 			tooltip($CPUMAC & @crlf & $CPUMAC2)
	If $CPUMAC <> $CPUMAC2 Then ; check for mac address
;~ 		MsgBox(1, "", "MAC & CPU Failed")
		$boton = 2
	EndIf
	For $i = 0 To UBound($CPUMACArray, 1) - 1
		$Checksum += $CPUMACArray[$i]
	Next
;~ 			msgbox(1,"",$Checksum)
	If $LicenseArray[$ChecksumPlacement][$ChecksumPlacement] = $Checksum Then
;~ 		MsgBox(1, "", "Checksum Passed")
;~ tooltip("Checksum Failed")
	ElseIf $LicenseArray[$ChecksumPlacement][$ChecksumPlacement] <> $Checksum Then
		$boton = 2
		$Sleep = 9999999
;~ 		MsgBox(1, "", "Checksum Failed")
;~ tooltip("Checksum Passed")
	EndIf

EndFunc   ;==>Authenticate


Func GMDetection()
	If $DevMode = True Then
		For $i = 1 To 38 Step 1
			If $EA[$i][7] == "ISYLVER" Or $EA[$i][7] == "FINITO" Or $EA[$i][7] == "GHOSTLORD" Then
				ToolTip("****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************", 700, 400)
				SoundPlay(@ScriptDir & "\alarm_beep.wav", 1)
				ToolTip("****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************" & @CRLF & _
						"****************************************************", 200, 200)
				If $boton = 1 Then
					Sleep(2000)
					$boton = 0
				EndIf
				ExitLoop
			EndIf
		Next
	EndIf
EndFunc   ;==>GMDetection

























