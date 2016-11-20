#RequireAdmin
#include <ListBoxConstants.au3>
#include <ListViewConstants.au3>
#include <FileConstants.au3>
#include <StringConstants.au3>
#include <CheckSumVerify.au3>
#include <KDMemory2.au3>
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
#include <ComboConstants.au3>
#include <GUIListBox.au3>
;~ #include <MouseOnEvent.au3>

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
If @Compiled = 1 And @ScriptName = "CraftingBot.exe" Then
	MsgBox(0, "", "CraftingBot.exe has been renamed to " & $word & ".exe" & @CRLF & @CRLF & "The application will restart in less than 5 seconds", 5)
	_SelfRename($word & ".exe")
	Exit
Else
EndIf
$processName = "SomaWindow.exe"; Don't edit any of thee, it will break the bot
$processId = ProcessExists($processName); Don't edit any of thee, it will break the bot
$handles = _KDMemory_OpenProcess($processId) ; Opens memory to be called upon
AutoItSetOption("mousecoordmode", 2) ; Don't edit any of thee, it will break the bot
Global $NameOfSomaWindow = IniRead("Settings.ini", "Settings", "NameOfSomaWindow", "Myth of Soma : Molten Meltdown")
If Not WinActive($NameOfSomaWindow) Then
	WinActivate($NameOfSomaWindow)
	WinWaitActive($NameOfSomaWindow)
EndIf
Opt("GUIOnEventMode", 1)
#Region ################## OffSets #######################################################################

; SomaWindow.exe+132850, 00532850 open dialog
;SomaWindow.exe+132830 00532830 selected npc options


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
Global $TargetMobArray[7][2]
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
Global $WHInventoryBag[61][4]
Global $CraftInventoryBag[11][4]
Global $SA[1][1]
#EndRegion ################## Arrays #######################################################################



#Region ################## HotKeys #######################################################################
HotKeySet("{END}", "Quit")
HotKeySet("{DELETE}", "botonoff")
;~ HotKeySet("{INSERT}", "SelectEntity")
HotKeySet("!q", "AddNavNode")
HotKeySet("!e", "ScriptViewListArrayDisplay")
HotKeySet("!j", "DevModeToggle")
HotKeySet("!a", "ScanWHInventoryBagArrayDisplay")
HotKeySet("!s", "ScanInventoryBagArrayDisplay")
HotKeySet("!d", "ScanCraftInventoryBagArrayDisplay")
HotKeySet("!z", "Test")
#EndRegion ################## HotKeys #######################################################################



#Region ################## Pre Loop Settings & Variables #######################################################################
Global $Map, $MPCurrent, $MPMax, $HPMax, $HPCurrent, $MyX, $MyY, $NavHuntTileDistance, $Entity, $TargetNode, $NavNodeForward, $TargetNodeDistance, $TargetDistanceFromNode, $InCombat = False, $NavigatingNodes = False, $GoToNearestNode = True, $EngagingNode = False, $boton = 0, $EntityName, $EntityID, $SelectTargetMobLoop, $LastNodePositionX, $LastNodePositionY, $LastNodePositionSet, $LastNodeDistance, $AutoNavNodeSwitch = 0, $AutoMPPots = 0, $AutoHPPots = 0, $MPLast, $HPLast, $F1Number, $F2Number, $F3Number, $F4Number, $SelectEntity = False, $Firstrun = True, $MyID, $MobHasOwner, $EntityCursorTooltip = 4294967295, $DropScanAndPickup = False, $DistanceFromDrop, $NavigatingToDrop = False, $GhostDetect, $IsGhost = False, $CurrentPotentialGhost, $MeleeAuraSwitch = 0, $StaffAuraToggle = 0, $IntModeToggle = 0, $WeakenMode = 0, $NearTargetX, $NearTargetY, $RecentDeadMob, $TargetMob1Label, $TargetMob2Label, $TargetMob3Label, $TargetMob4Label, $TargetMob5Label, $TargetMob6Label, $CPU, $CPU2, $MAC, $MAC2, $BotSettingsGUI, $CPUMAC2, $CPUMAC, $TYTnavmesh, $ABIASnavmesh, $MERCnavmesh, $Checksum, $MobSelection, $NodeDistanceSettingBox, $AutoNavNodeDistanceSettingBox, $PlayertoNodeDistSettingBox, $AttackDistanceSettingBox, $AntiMobstealGUI, $AntiMobstealListView, $EntityArrayGUI, $EntityArrayListView, $StaffAuraLabel, $IntModeLabel, $BowModeSwitchLabel, $WeakenModeLabel, $MobSelectionLabel, $AutoNavNodeLabel, $NavNodesLabel, $CraftingBotGUI, $Record, $ScriptViewList, $DeleteLast, $AddStop, $Statusc, $AddDelay, $CurrentScript, $CurrentScriptRow = 0, $Navigate = False, $Node = 1, $StartStop, $ScriptConsole, $ScriptFinished = True, $NavCoordsConsole = False, $LastConsoleNavNodeX, $LastConsoleNavNodeY, $LIndex, $ItemsSelectAction, $ItemID1, $ItemID2, $ItemID3, $ItemID4, $Amount1, $Amount2, $Amount3, $Amount4, $GetMousePos, $MouseAdd, $MousePosYLabel, $MousePosXLabel, $GetMousePosSwitch, $SetMousePos, $ArrayDisplay = False, $MaxBagWeight = False, $InventFull = False, $NoMoreMats = False, $InventoryItemCount, $BWCurrent, $BWMax, $MousePosX, $MousePosY, $SelectEntity = False, $SelectedNPCLabel, $SendKeyGUI, $SendKeyGroup, $SendKeyList, $Key, $SendKeyAddButton, $RowFinished = True, $SendSleepGUI, $SendSleep, $SendSleepAddButton, $TargetX, $TargetY
Global $DevMode = False
Global $NavmeshRecording = False
Global $ArrayDisplayWindows = False
Global $MyID = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $UniqueID)
$PreReswidth = _KDMemory_ReadProcessMemory($handles, 0x06dd46c, 'DWORD', $offsets = 0)
$PreResheight = _KDMemory_ReadProcessMemory($handles, 0x06dd470, 'DWORD', $offsets = 0)
Global $DialogX = ($PreReswidth - 800) / 2
Global $DialogY = ($PreResheight - 565)
;~ Global $DialogY = ($PreResheight - 600) / 2
;~ MsgBox(0, "", $DialogX & @CRLF & $DialogY)
;~ mousemove($DialogX,$DialogY)
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
Global $MobSelectionSwitch = IniRead("Settings.ini", "Settings", "MobSelection", 2)
Global $AttackDistance = IniRead("Settings.ini", "Settings", "AttackDistance", 12)
Global $DialogSleep = IniRead("Settings.ini", "Settings", "DialogSleep", 100)
;<<<<<< Crafting
Global $PutWHHsomaX = IniRead("Settings.ini", "DialogCoords", "PutWHDsomaX", 0)
Global $PutWHHsomaY = IniRead("Settings.ini", "DialogCoords", "PutWHDsomaY", 0)
Global $DrawWHHsomaX = IniRead("Settings.ini", "DialogCoords", "DrawWHDsomaX", 0)
Global $DrawWHHsomaY = IniRead("Settings.ini", "DialogCoords", "DrawWHDsomaY", 0)
Global $PutGSHsomaX = IniRead("Settings.ini", "DialogCoords", "PutGSDsomaX", 0)
Global $PutGSHsomaY = IniRead("Settings.ini", "DialogCoords", "PutGSDsomaY", 0)
Global $DrawGSHsomaX = IniRead("Settings.ini", "DialogCoords", "DrawGSDsomaX", 0)
Global $DrawGSHsomaY = IniRead("Settings.ini", "DialogCoords", "DrawGSDsomaY", 0)
Global $SellShopHsomaX = IniRead("Settings.ini", "DialogCoords", "SellShopDsomaX", 0)
Global $SellShopHsomaY = IniRead("Settings.ini", "DialogCoords", "SellShopDsomaY", 0)
Global $BuyShopHsomaX = IniRead("Settings.ini", "DialogCoords", "BuyShopDsomaX", 0)
Global $BuyShopHsomaY = IniRead("Settings.ini", "DialogCoords", "BuyShopDsomaY", 0)

Global $PutWHDsomaX = IniRead("Settings.ini", "DialogCoords", "PutWHDsomaX", 0)
Global $PutWHDsomaY = IniRead("Settings.ini", "DialogCoords", "PutWHDsomaY", 0)
Global $DrawWHDsomaX = IniRead("Settings.ini", "DialogCoords", "DrawWHDsomaX", 0)
Global $DrawWHDsomaY = IniRead("Settings.ini", "DialogCoords", "DrawWHDsomaY", 0)
Global $PutGSDsomaX = IniRead("Settings.ini", "DialogCoords", "PutGSDsomaX", 0)
Global $PutGSDsomaY = IniRead("Settings.ini", "DialogCoords", "PutGSDsomaY", 0)
Global $DrawGSDsomaX = IniRead("Settings.ini", "DialogCoords", "DrawGSDsomaX", 0)
Global $DrawGSDsomaY = IniRead("Settings.ini", "DialogCoords", "DrawGSDsomaY", 0)
Global $SellShopDsomaX = IniRead("Settings.ini", "DialogCoords", "SellShopDsomaX", 0)
Global $SellShopDsomaY = IniRead("Settings.ini", "DialogCoords", "SellShopDsomaY", 0)
Global $BuyShopDsomaX = IniRead("Settings.ini", "DialogCoords", "BuyShopDsomaX", 0)
Global $BuyShopDsomaY = IniRead("Settings.ini", "DialogCoords", "BuyShopDsomaY", 0)
;~ Global $PotionCraftTopLeftBoxX = IniRead("Settings.ini", "DialogCoords", "PotionCraftTopLeftBoxX", 0)
;~ Global $PotionCraftTopLeftBoxY = IniRead("Settings.ini", "DialogCoords", "PotionCraftTopLeftBoxY", 0)
Global $PotionCraftTopLeftBoxX = $DialogX + 110
Global $PotionCraftTopLeftBoxY = $DialogY + 375
Global $WHWithdrawButtonX = $DialogX + 215
Global $WHWithdrawButtonY = $DialogY + 287
;>>>>>> Crafting
$Map2 = 0
Send("{LCTRL}")
Global $Sleep = IniRead("Settings.ini", "Settings", "BotSpeed", 40)
Global $CPU2
Global $MAC2
$Placement += 100
#EndRegion ################## Pre Loop Settings & Variables #######################################################################



#Region ################## GUI & Window Init ##########################################################################################
$Placement += 187
Gui()
;~ AntiMobstealGUI()
;~ EntityArrayGUI()
$aTaskbar = WinGetPos("[CLASS:Shell_TrayWnd]", "")
$aWin = WinGetPos($CraftingBotGUI)
WinMove($CraftingBotGUI, "", @DesktopWidth - $aWin[2] - 4, @DesktopHeight - $aWin[3] - $aTaskbar[3] - 4)
Authenticate()
#EndRegion ################## GUI & Window Init ##########################################################################################



#Region ################## Main Loop ##########################################################################################
While 1
	If $DevModeTimer[0] > 0 Then
		$DevModeTimer[1] = TimerDiff($DevModeTimer[0])
		If $DevModeTimer[1] > 2000 And $DevMode = False Then
			$DevModeTimer[0] = 0
			$DevModeTimer[1] = 0
			HotKeySet("!z")
		EndIf
	EndIf
	$WindowPosition = WinGetPos($NameOfSomaWindow)
	If $CPUMAC = $CPUMAC2 Then
		FillEntityArray()
;~ 		GuiUpdate()
	EndIf
	AutoNavNode()
	Navigation()
	Stamina()
	GetMousePos()
	If $DevMode = True Then
		GMDetection()
	EndIf
	If $RowFinished = True Then
		$RowFinished = False
		ScriptLoop()
	EndIf
WEnd
#EndRegion ################## Main Loop ##########################################################################################
Func ScanCraftInventoryBagArrayDisplay()
	ScanCraftInventoryBag()
	_ArrayDisplay($CraftInventoryBag, "Craft Inventory Bag")
EndFunc   ;==>ScanCraftInventoryBagArrayDisplay

Func ScanWHInventoryBagArrayDisplay()
	ScanWHInventoryBag()
	_ArrayDisplay($WHInventoryBag, "Warehouse Inventory Bag")
EndFunc   ;==>ScanWHInventoryBagArrayDisplay
Func ScanInventoryBagArrayDisplay()
	ScanInventoryBag()
	_ArrayDisplay($InventoryBag, "Inventory Bag")
EndFunc   ;==>ScanInventoryBagArrayDisplay
Func ScanCraftInventoryBag()
	Global $CraftinventBagItemIDOffset[2] = [0x0, 0x8]
	Global $CraftinventBagItemNameOffset[3] = [0x0, 0x2c, 0x0]
	Global $CraftinventBagItemDuraAmountOffset[2] = [0x0, 0x24]
	For $i = 1 To UBound($CraftInventoryBag) - 1 Step 1
		If $i > 1 Then
			$CraftinventBagItemIDOffset[0] += 4
			$CraftinventBagItemNameOffset[0] += 4
			$CraftinventBagItemDuraAmountOffset[0] += 4
		EndIf
		$CraftInventoryBag[$i][0] = _KDMemory_ReadProcessMemory($handles, 0x05354F8, 'WORD', $CraftinventBagItemIDOffset)
		$CraftInventoryBag[$i][1] = _KDMemory_ReadProcessMemory($handles, 0x05354F8, 'char[30]', $CraftinventBagItemNameOffset)
		$CraftInventoryBag[$i][2] = _KDMemory_ReadProcessMemory($handles, 0x05354F8, 'WORD', $CraftinventBagItemDuraAmountOffset)
	Next
EndFunc   ;==>ScanCraftInventoryBag



Func ScanWHInventoryBag()
	Global $WHinventBagItemIDOffset[2] = [0x0, 0x8]
	Global $WHinventBagItemNameOffset[3] = [0x0, 0x2c, 0x0]
	Global $WHinventBagItemWeightOffset[2] = [0x0, 0x14]
	Global $WHinventBagItemDuraAmountOffset[2] = [0x0, 0x24]
	For $i = 1 To UBound($WHInventoryBag) - 1 Step 1
		If $i > 1 Then
			$WHinventBagItemIDOffset[0] += 4
			$WHinventBagItemNameOffset[0] += 4
			$WHinventBagItemWeightOffset[0] += 4
			$WHinventBagItemDuraAmountOffset[0] += 4
		EndIf
		$WHInventoryBag[$i][0] = _KDMemory_ReadProcessMemory($handles, 0x0535980, 'WORD', $WHinventBagItemIDOffset)
		$WHInventoryBag[$i][1] = _KDMemory_ReadProcessMemory($handles, 0x0535980, 'char[30]', $WHinventBagItemNameOffset)
		$WHInventoryBag[$i][2] = _KDMemory_ReadProcessMemory($handles, 0x0535980, 'WORD', $WHinventBagItemWeightOffset)
		$WHInventoryBag[$i][3] = _KDMemory_ReadProcessMemory($handles, 0x0535980, 'WORD', $WHinventBagItemDuraAmountOffset)
	Next




EndFunc   ;==>ScanWHInventoryBag



Func ScanInventoryBag()
	Global $inventBagItemIDOffset[1] = [0x5ee]
	Global $inventBagItemNameOffset[2] = [0x628, 0x0]
	Global $inventBagItemWeightOffset[1] = [0x5f6]
	Global $inventBagItemDuraAmountOffset[1] = [0x606]
	Global $inventBagItemDuraLastRepairOffset[1] = [0x608]
	For $i = 1 To UBound($InventoryBag) - 1 Step 1
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




EndFunc   ;==>ScanInventoryBag


#Region ################## Main Loop Functions #######################################################################################



Func FillEntityArray()
	Sleep($Sleep)
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
		$BWCurrent = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $BWoffsets)
		$BWMax = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $BWMaxoffsets)
		$MyX = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $CoordsXOffsets)
		$MyY = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $CoordsYOffsets)
		$staffaura = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $staffauraoffset) ; Is there an aura?
		$stance = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $stanceoffset) ; peace/mob/pk
		$eqippedweap = _KDMemory_ReadProcessMemory($handles, 0x06d8600, 'DWORD', $eqippedweapoffset) ; What weap? 6 = staff
		$RecentDeadMob = _KDMemory_ReadProcessMemory($handles, 0x06d8dd4, 'DWORD', $UniqueID)
		$InventoryItemCount = _KDMemory_ReadProcessMemory($handles, 0x0535b98, 'DWORD', $UniqueID)
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
			If $EA1[$i][4] = $TargetMobArray[$g][0] And $EA1[$i][7] = $TargetMobArray[$g][1] And $EA1[$i][4] <> 0 And $EA1[$i][6] = 1 And $EA1[$i][5] <> 15 And $EA1[$i][0] <> $GhostArray[$g][0] Then
				$EA1[$i][24] = $g
				ExitLoop
			ElseIf $g = 6 And $EA1[$i][4] <> $TargetMobArray[$g][0] Or $EA1[$i][4] = 0 Or $EA1[$i][7] <> $TargetMobArray[$g][1] Then
				$EA1[$i][24] = 7
			EndIf
		Next
;~ 		If ($EA1[$i][8] = 0 And $EA1[$i][9] = 0) Or ($EA1[$i][8] = 1 And $EA1[$i][9] = 0) Or ($EA1[$i][8] = 1 And $EA1[$i][9] > 0) Or ($EA1[$i][8] = 1 And $EA1[$i][9] = 1) Then
;~ 			$EA1[$i][8] = "Unknown"
;~ 			$EA1[$i][9] = "Unknown"
;~ 		EndIf
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
		Next
;~ 		If ($EA2[$i][8] = 0 And $EA2[$i][9] = 0) Or ($EA2[$i][8] = 1 And $EA2[$i][9] = 0) Or ($EA2[$i][8] = 1 And $EA2[$i][9] > 0) Or ($EA2[$i][8] = 1 And $EA2[$i][9] = 1) Then
;~ 			$EA2[$i][8] = "Unknown"
;~ 			$EA2[$i][9] = "Unknown"
;~ 		EndIf
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
				EndIf
				If $f = 28 And $WeakenArray[0] = $EA[$d][0] And $WeakenArray[0] <> 0 Then
					$EA[$d][28] = 1
				EndIf
			Next
		EndIf
	Next

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
	If $boton = 1 And $Navigate = True Then
;~ 		tooltip($Navigate)
;~ 		============================================= Go To Nearest Node
		$x = Abs($NavNodes[$Node][0] - $MyX)
		$y = Abs($NavNodes[$Node][1] - $MyY)
		$TargetNodeDistance = $x + $y
		If $TargetNodeDistance <= $PlayertoNodeDistsetting Then
			If $Node < $NavNodes[0][0] Then
				$Node += 1
			ElseIf $Node = $NavNodes[0][0] Then
				$Node = 1
				$Navigate = False
				If $CurrentScriptRow < $SA[0][0] Then
					ScriptLoop()
				ElseIf $CurrentScriptRow = $SA[0][0] Then
					$boton = 0
					$LIndex = GUICtrlCreateListViewItem("Script Finished", $ScriptConsole)
					_GUICtrlListView_EnsureVisible($ScriptConsole, $LIndex - 46)
					$ScriptFinished = True
					GUICtrlSetData($StartStop, "Start(DEL)")
				EndIf
			EndIf
			$NavCoordsConsole = False
		ElseIf $TargetNodeDistance >= $PlayertoNodeDistsetting And $NavNodes[$Node][0] <> 0 And $NavNodes[$Node][1] <> 0 Then
			If $NavCoordsConsole = False Then
				$LIndex = GUICtrlCreateListViewItem("Moving to X: " & $NavNodes[$Node][0] & " Y: " & $NavNodes[$Node][1], $ScriptConsole)
				_GUICtrlListView_EnsureVisible($ScriptConsole, $LIndex - 46)
				$LastConsoleNavNodeX = $NavNodes[$Node][0]
				$LastConsoleNavNodeY = $NavNodes[$Node][1]
				$NavCoordsConsole = True
			ElseIf $NavCoordsConsole = True And $LastConsoleNavNodeX <> $NavNodes[$Node][0] And $LastConsoleNavNodeY <> $NavNodes[$Node][1] Then
				$LIndex = GUICtrlCreateListViewItem("Moving to X: " & $NavNodes[$Node][0] & " Y: " & $NavNodes[$Node][1], $ScriptConsole)
				_GUICtrlListView_EnsureVisible($ScriptConsole, $LIndex - 46)
			EndIf
			NavigateToTarget($NavNodes[$Node][0], $NavNodes[$Node][1])
		EndIf
;~ 			================================================Engage Node
	EndIf
EndFunc   ;==>Navigation


Func NotUsed()
	If $EngagingNode = True Then ; Scan for entities at TargetNode
		For $i = 0 To 38 Step 1
			$x = Abs($NavNodes[$TargetNode][0] - $EA[$i][2])
			$y = Abs($NavNodes[$TargetNode][1] - $EA[$i][3])
			$TargetDistanceFromNode = $x + $y
;~ 				===============================================Target Selection Criteria
			If $TargetDistanceFromNode <= $NodeDistanceSetting And $EA[$i][6] = 1 And $EA[$i][24] > 0 And $EA[$i][24] < 7 And $EA[$i][1] > 0 And ($EA[$i][26] = $MyID Or $EA[$i][26] = 0) And $NavigatingToDrop = False And $IsGhost = False Then
				If $EA[$i][1] > $AttackDistance Then
					NavigateToTarget($EA[$i][2], $EA[$i][3])
				ElseIf $EA[$i][1] <= $AttackDistance Then
					AttackTarget($i)
				EndIf
				ExitLoop
			ElseIf $i = 38 And $TargetDistanceFromNode > $NodeDistanceSetting Then
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

EndFunc   ;==>NotUsed



Func Stamina()
	$staminactrl = _KDMemory_ReadProcessMemory($handles, 0x0536780, 'DWORD', $offsets = 0)
	If $staminactrl = 0 Then
		$stamaddress = _KDMemory_WriteProcessMemory($handles, 0x0536780, 'DWORD', 1, $offsets = 0)
	EndIf
EndFunc   ;==>Stamina
#EndRegion ################## Main Loop Functions #######################################################################################



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
	If Not WinActive($NameOfSomaWindow) Then
		WinActivate($NameOfSomaWindow)
		WinWaitActive($NameOfSomaWindow)
	EndIf
	For $R = 360 To 0 Step $rotationspeedandsmoothness
		$Rad = _Radian($R)
		$clickmobcoordsx = Sin($Rad) * $cursorrotationwidth + ($EA[$TargetEntity][2] - $MyX) * 48 + $MoveMPositionX
		$clickmobcoordsy = Cos($Rad) * $cursorrotationheight + ($EA[$TargetEntity][3] - $MyY) * 24 + $MoveMPositionY
		MouseMove(($clickmobcoordsx), ($clickmobcoordsy), 1)
		$EntityCursorTooltip = _KDMemory_ReadProcessMemory($handles, 0x06d85F8, 'DWORD', 0)
		If $EA[$TargetEntity][0] = $EntityCursorTooltip Then
			MouseClick("Left")
			Sleep(1000)
			ExitLoop
		EndIf
	Next

EndFunc   ;==>AttackTarget



Func NavigateToTarget($TargetX, $TargetY)
;~ 	msgbox(1,"",$TargetX & "   " & $TargetY)
	$NavHuntTileDistance = Random($MinDistance, $MaxDistance, 0) ; How many tiles away the bot clicks for movement when navigating. (Too high a value will cause clicks outside the window!) - Default 2,4,1
	If Not WinActive($NameOfSomaWindow) Then
		WinActivate($NameOfSomaWindow)
		WinWaitActive($NameOfSomaWindow)
	EndIf
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
;~ 	Sleep(100)
EndFunc   ;==>NavigateToTarget



Func AutoNavNode()
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
		GUICtrlSetData($Record, "Stop")
	ElseIf $AutoNavNodeSwitch = 1 Then
		$AutoNavNodeSwitch = 0
		GUICtrlSetData($Record, "Record")
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
		GUICtrlSetData($NavNodesLabel, "No. Of NavNodes: " & $NavNodes[0][0])
	ElseIf $NavNodes[0][0] = $MaxNodes Then
		MsgBox(0, "", "Max Nodes Reached", 1)
		$AutoNavNodeSwitch = 0
		GUICtrlSetData($NavNodesLabel, "No. of Nodes: " & $NavNodes[0][0])
		GUICtrlSetData($AutoNavNodeLabel, "Auto NavNode(ALT + E): " & $AutoNavNodeSwitch)
	EndIf
EndFunc   ;==>AddNavNode



Func ResetNavNode()
	For $i = 1 To $MaxNodes Step 1
		$NavNodes[0][0] = 0
		$NavNodes[$i][0] = 0
		$NavNodes[$i][1] = 0
	Next
	GUICtrlSetData($NavNodesLabel, "No. Of NavNodes: " & $NavNodes[0][0])
	ToolTip("Cleared!")
	Sleep(1000)
	ToolTip("")
EndFunc   ;==>ResetNavNode
#EndRegion ################## Nav Nodes #######################################################################################



#Region ################## GUI Main #######################################################################################



Func Gui()
	$SendSleepGUI = GUICreate($word, 243, 346, 787, 316)
	GUISetState(@SW_HIDE, $SendSleepGUI)
	$SendSleep = GUICtrlCreateInput("1000 = 1s", 81, 256, 73, 21)
	$SendSleepAddButton = GUICtrlCreateButton("Add", 81, 283, 75, 25)
	GUICtrlSetOnEvent($SendSleepAddButton, "AddSendSleepToScript")

	$SendKeyGUI = GUICreate($word, 243, 346, 787, 316)
	GUISetState(@SW_HIDE, $SendKeyGUI)
	$SendKeyGroup = GUICtrlCreateGroup("", 8, 1, 225, 337)
	$SendKeyLabel = GUICtrlCreateLabel("Type a single key character in the box and then click Add to make the but press that specific key or if you want something like the *Enter* or *Space* key place the word inside brackets { }. See the Excel file in the Crafting Bot folder for better examples. If you want to do ALT + a key such as ALT + A then type it like this !a.  + = SHIFT ^ = CTRL # = WindowsKey ", 16, 16, 209, 120)
	$Key = GUICtrlCreateInput("Key", 81, 256, 73, 21)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$SendKeyAddButton = GUICtrlCreateButton("Add", 81, 283, 75, 25)
	GUICtrlSetOnEvent($SendKeyAddButton, "AddSendKeyToScript")
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseSendKeyGUI")
	$CraftingBotGUI = GUICreate($word, 442, 592, 624, 231)
	$Settings = GUICtrlCreateMenu("Settings")
	$StopOnFailure = GUICtrlCreateMenuItem("Stop On Failure", $Settings)


	;Items
	$ItemsGroup = GUICtrlCreateGroup("Items", 8, 56, 249, 113)
	$ItemID1 = GUICtrlCreateInput("ItemID", 18, 76, 50, 21)
	$ItemID2 = GUICtrlCreateInput("ItemID", 78, 76, 50, 21)
	$ItemID3 = GUICtrlCreateInput("ItemID", 138, 76, 50, 21)
	$ItemID4 = GUICtrlCreateInput("ItemID", 198, 76, 50, 21)
	$Amount1 = GUICtrlCreateInput("Amount", 18, 107, 50, 21)
	$Amount2 = GUICtrlCreateInput("Amount", 78, 107, 50, 21)
	$Amount3 = GUICtrlCreateInput("Amount", 138, 107, 50, 21)
	$Amount4 = GUICtrlCreateInput("Amount", 198, 107, 50, 21)
	$ItemsSelectAction = GUICtrlCreateCombo("Select Action", 16, 136, 145, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	$ItemAddButton = GUICtrlCreateButton("Add", 172, 136, 75, 25)
	GUICtrlSetData($ItemsSelectAction, "Craft: Potion Table|WH: Withdraw Amount")
	GUICtrlSetOnEvent($ItemAddButton, "ItemAddButton")

	; NPC
	$OpenNPCGroup = GUICtrlCreateGroup("Open NPC", 248, 176, 185, 81)
	$SelectNPCButton = GUICtrlCreateButton("Select NPC", 258, 224, 81, 25)
	$AddNPCButton = GUICtrlCreateButton("Add", 348, 224, 75, 25)
	$SelectedNPCLabel = GUICtrlCreateLabel("Select NPC", 258, 200, 200, 17)
	GUICtrlSetOnEvent($SelectNPCButton, "SelectNPCButton")
	GUICtrlSetOnEvent($AddNPCButton, "AddNPCButton")

	;Save Load
	$CurrentScript = GUICtrlCreateLabel("Script: ", 16, 16, 170, 17)
	$SaveScript = GUICtrlCreateButton("Save Script", 272, 16, 75, 25)
	$LoadScript = GUICtrlCreateButton("Load Script", 352, 16, 75, 25)
	GUICtrlSetOnEvent($SaveScript, "SaveScript")
	GUICtrlSetOnEvent($LoadScript, "LoadScript")

	;MouseClick
	$MouseClickGroup = GUICtrlCreateGroup("MouseClick", 272, 88, 161, 81)
	$MousePosXLabel = GUICtrlCreateLabel("X: ", 280, 112, 60, 17)
	$MousePosYLabel = GUICtrlCreateLabel("Y: ", 280, 136, 60, 17)
	$MouseAdd = GUICtrlCreateButton("Add", 352, 136, 75, 25)
	$GetMousePos = GUICtrlCreateButton("Get Coords", 352, 104, 75, 25)
	GUICtrlSetOnEvent($GetMousePos, "GetMousePosSwitch")
	GUICtrlSetOnEvent($MouseAdd, "AddMousePosToScript")

	;Navigation
	$NavigateGroup = GUICtrlCreateGroup("Navigate", 8, 176, 233, 81)
	$Record = GUICtrlCreateButton("Record", 16, 224, 67, 25)
	$AddNavNodes = GUICtrlCreateButton("Add", 88, 224, 67, 25)
	$NavNodesLabel = GUICtrlCreateLabel("No. Of NavNodes: " & $NavNodes[0][0], 24, 200, 150, 17)
	$CleadNavNodes = GUICtrlCreateButton("Clear", 160, 224, 67, 25)
	GUICtrlSetOnEvent($Record, "AutoNavNodeSwitch")
	GUICtrlSetOnEvent($CleadNavNodes, "ResetNavNode")
	GUICtrlSetOnEvent($AddNavNodes, "AddNavNodesToScript")

	;ScriptViewList
	$ScriptViewList = GUICtrlCreateListView("Oneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", 8, 264, 210, 136, BitOR($GUI_SS_DEFAULT_LISTVIEW, $LVS_NOCOLUMNHEADER))
	$ScriptConsole = GUICtrlCreateListView("Oneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", 223, 264, 210, 136, BitOR($GUI_SS_DEFAULT_LISTVIEW, $LVS_NOCOLUMNHEADER))
	$DeleteLast = GUICtrlCreateButton("Delete Last", 336, 408, 99, 25)
	$AddStop = GUICtrlCreateButton("Add [Stop]", 256, 408, 75, 25)
	$Status = GUICtrlCreateLabel("Status: ", 272, 56, 40, 17)
	$AddDelay = GUICtrlCreateButton("Add [Delay]", 176, 408, 75, 25)
	GUICtrlSetOnEvent($AddDelay, "OpenSendSleepGUI")
	GUICtrlSetOnEvent($DeleteLast, "DeleteLast")

	;Run After
	$RunAfterFinishGroup = GUICtrlCreateGroup("Run After Finish/Failure", 8, 472, 425, 57)
	$SelectScript = GUICtrlCreateButton("Select Script", 264, 488, 75, 25)
	$ClearRunAfter = GUICtrlCreateButton("Clear", 344, 488, 75, 25)
	$RunAfterLabel = GUICtrlCreateLabel("Selected Script:", 16, 496, 79, 17)
	$StartStop = GUICtrlCreateButton("Start [Del]", 8, 536, 115, 25)
	$AddWaitForMapChange = GUICtrlCreateButton("Add [Wait For Map Change]", 8, 408, 163, 25)
	$AddKey = GUICtrlCreateButton("Add [Key]", 8, 440, 75, 25)
	GUICtrlSetOnEvent($AddKey, "OpenSendKeyGUI")
	GUICtrlSetOnEvent($StartStop, "botonoff")
	GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")
	GUISetState(@SW_SHOW, $CraftingBotGUI)
	If Not WinActive($NameOfSomaWindow) Then
		WinActivate($NameOfSomaWindow)
		WinWaitActive($NameOfSomaWindow)
	EndIf
EndFunc   ;==>Gui

Func LoadScript()
	; Display an open dialog to select a list of file(s).
	Local $sFileOpenDialog = FileOpenDialog("Load Script", @ScriptDir & "\Scripts", "Config files (*.ini)", $FD_FILEMUSTEXIST)
	If @error Then
		; Display the error message.
		MsgBox($MB_SYSTEMMODAL, "", "No file has been selected.", 1)
	Else
		$IniSectionNames = IniReadSectionNames($sFileOpenDialog)
		$SA[0][0] = $IniSectionNames[0]
		For $d = 1 To $IniSectionNames[0] Step 1
			If $IniSectionNames[0] > UBound($SA) Then ; Increase size of array to fit all sections
				ReDim $SA[$IniSectionNames[0] + 1][UBound($SA, 2)]
			EndIf
			$Section = IniReadSection($sFileOpenDialog, $d)
			For $i = 0 To $Section[0][0] - 1 Step 1
				If $Section[0][0] > UBound($SA, 2) Then
					ReDim $SA[UBound($SA)][$Section[0][0] + 1]
				EndIf
				$SA[$d][$i] = IniRead($sFileOpenDialog, $d, $i, 0)
			Next
		Next
		$CurrentScriptRow = 0
		$ScriptFinished = True
		GuiUpdate()
		MobSelection()
		MobSelection()
		MobSelection()
		Local $sFileName = StringTrimLeft($sFileOpenDialog, StringInStr($sFileOpenDialog, "\", $STR_NOCASESENSE, -1))
		GUICtrlSetData($CurrentScript, "Script: " & $sFileName)
		; Replace instances of "|" with @CRLF in the string returned by FileOpenDialog.
		$sFileOpenDialog = StringReplace($sFileOpenDialog, "|", @CRLF)
		; Display the list of selected files.
		MsgBox($MB_SYSTEMMODAL, "", "You loaded:" & @CRLF & $sFileOpenDialog, 1)
		If Not WinActive($NameOfSomaWindow) Then
			WinActivate($NameOfSomaWindow)
			WinWaitActive($NameOfSomaWindow)
		EndIf
		ScriptLoop()
	EndIf
EndFunc   ;==>LoadScript

Func SaveScript()
	Local $sFileSaveDialog = FileSaveDialog("Save script as", @ScriptDir & "\Scripts", "Config files (*.ini)", 16)
	If @error Then
		; Display the error message.
		MsgBox($MB_SYSTEMMODAL, "", "No file was saved.", 1)
	Else

		$IniSectionNames = IniReadSectionNames($sFileSaveDialog)
		If IsArray($IniSectionNames) Then
			For $d = 1 To $IniSectionNames[0] Step 1
				IniDelete($sFileSaveDialog, $IniSectionNames[$d])
			Next
		EndIf
		For $i = 1 To $SA[0][0] Step 1 ; Loop through the ScriptArray
;~ 			If StringInStr($SA[$i][0], "Navigate") > 1 Then
			For $n = 0 To UBound($SA, 2) - 1 Step 1
				If $SA[$i][$n] <> "" Then
					IniWrite($sFileSaveDialog, $i, $n, $SA[$i][$n])
				EndIf
			Next
;~ 			ElseIf StringInStr($SA[$CurrentScriptRow][0], "Craft Potions") > 1 Then
;~ 				For $n = 0 To UBound($SA, 2) - 1 Step 1
;~ 					If $SA[$i][$n] <> "" Then
;~ 						IniWrite($sFileSaveDialog, $i, $n, $SA[$i][$n])
;~ 					EndIf
;~ 				Next
;~ 			EndIf
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
		If Not WinActive($NameOfSomaWindow) Then
			WinActivate($NameOfSomaWindow)
			WinWaitActive($NameOfSomaWindow)
		EndIf
	EndIf

EndFunc   ;==>SaveScript
#EndRegion ################## GUI Main #######################################################################################



#Region ################## Switches #######################################################################################
Func botonoff()
;~ 		msgbox(1,"","   ")
	If $boton = 0 And $SA[0][0] > 0 Then
;~ 		msgbox(0,"","Fired")
		_GUICtrlListView_DeleteAllItems($ScriptConsole)
		$boton = 1
		If $ScriptFinished = True Then
			$ScriptFinished = False
			$CurrentScriptRow = 0
			$NavCoordsConsole = False
			ScriptLoop()
		EndIf
		Authenticate()
		GUICtrlSetData($StartStop, "Stop(DEL)")
		If $CPUMAC <> $CPUMAC2 Then
			$boton = 2
;~ 			msgbox(1,"","   ")
		EndIf
;~ 		GuiCtrlSetState (ControlID, $GUI_DISABLE)
	ElseIf $boton = 1 Then
		$boton = 0
		GUICtrlSetData($StartStop, "Start(DEL)")
	EndIf
EndFunc   ;==>botonoff



Func Quit()
	ToolTip('')
	MsgBox(0, "", "Exiting", 1)
	Send('{SHIFTUP}')
;~ 	WinActivate($NameOfSomaWindow)
	Exit
EndFunc   ;==>Quit
#EndRegion ################## Switches #######################################################################################



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

Func MobSelection()
	If $MobSelectionSwitch = 1 Then
		$MobSelectionSwitch = 2
		Global $MobSelection[][] = [[28, 1], [24, 0], [1, 0], [8, 0], [0, 0]] ; Weaken,Priority, Distance, HP,ID
		GUICtrlSetData($MobSelectionLabel, "Mob Selection(ALT + M): " & $MobSelectionSwitch)
	ElseIf $MobSelectionSwitch = 2 Then
		$MobSelectionSwitch = 3
		Global $MobSelection[][] = [[28, 1], [1, 0], [24, 0], [8, 0], [0, 0]] ; Weaken,Distance,Priority,HP,ID
		GUICtrlSetData($MobSelectionLabel, "Mob Selection(ALT + M): " & $MobSelectionSwitch)
	ElseIf $MobSelectionSwitch = 3 Then
		$MobSelectionSwitch = 1
		Global $MobSelection[][] = [[28, 1], [8, 0], [1, 0], [24, 0], [0, 0]] ; Weaken,HP,Distance,Priority,ID
		GUICtrlSetData($MobSelectionLabel, "Mob Selection(ALT + M): " & $MobSelectionSwitch)
	EndIf
EndFunc   ;==>MobSelection

Func DeleteLast()
	If $SA[0][0] > 0 Then
		ReDim $SA[$SA[0][0]][UBound($SA, 2)]
		$SA[0][0] -= 1
		$CurrentScriptRow = 0
		GuiUpdate()
	EndIf
EndFunc   ;==>DeleteLast

Func ScriptViewListArrayDisplay()
	_ArrayDisplay($SA)
EndFunc   ;==>ScriptViewListArrayDisplay

Func GuiUpdate()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ScriptViewList))
	_GUICtrlListView_AddArray($ScriptViewList, $SA)
	_GUICtrlListView_DeleteItem($ScriptViewList, 0)
	_GUICtrlListView_EnsureVisible($ScriptViewList, $SA[0][0] - 1)
EndFunc   ;==>GuiUpdate

Func ItemAddButton()
	If GUICtrlRead($ItemsSelectAction) = "Select Action" Then
		MsgBox(0, "Error", "Please select an action from the dropdown first", 1)
	ElseIf GUICtrlRead($ItemsSelectAction) = "Craft: Potion Table" Then
		AddPotionCraftingToScript()
	ElseIf GUICtrlRead($ItemsSelectAction) = "WH: Withdraw Amount" Then
		AddWHWithdrawAmountToScript()
	EndIf
EndFunc   ;==>ItemAddButton


Func AddNavNodesToScript()
	$SA[0][0] += 1 ; Count of rows in ScriptArray
	If ($NavNodes[0][0] * 2) + 2 > UBound($SA, 2) Then
		ReDim $SA[UBound($SA) + 1][($NavNodes[0][0] * 2) + 2]
	Else
		ReDim $SA[UBound($SA) + 1][UBound($SA, 2)]
	EndIf
	For $i = 1 To $NavNodes[0][0] Step 1 ; Add X Coords to ScriptArray
		$SA[$SA[0][0]][$i + 1] = $NavNodes[$i][0]
	Next
	$SA[$SA[0][0]][1] = $NavNodes[0][0] ; Save a marker for the beginning of the Y Coords
	For $i = 1 To $NavNodes[0][0] Step 1 ; Add Y Coords to ScriptArray
		$SA[$SA[0][0]][$NavNodes[0][0] + $i + 1] = $NavNodes[$i][1]
	Next
	$SA[$SA[0][0]][0] = $SA[0][0] & " | " & "Navigate " & $NavNodes[0][0] & " Nodes"
	GuiUpdate()
	$CurrentScriptRow = 0
	$ScriptFinished = True
	ScriptLoop()
EndFunc   ;==>AddNavNodesToScript

Func AddPotionCraftingToScript()
	$SA[0][0] += 1 ; Count of rows in ScriptArray
	If 9 > UBound($SA, 2) Then ; If data is too big for current size of SA Columns
		ReDim $SA[UBound($SA) + 1][9] ; increases size of rows by one for new data and columns for data size
	Else
		ReDim $SA[UBound($SA) + 1][UBound($SA, 2)] ; else increase rows by one for new data and keep columns the same
	EndIf
	$SA[$SA[0][0]][0] = $SA[0][0] & " | " & "Craft Potions"
	$SA[$SA[0][0]][1] = GUICtrlRead($ItemID1)
	$SA[$SA[0][0]][2] = GUICtrlRead($ItemID2)
	$SA[$SA[0][0]][3] = GUICtrlRead($ItemID3)
	$SA[$SA[0][0]][4] = GUICtrlRead($ItemID4)
	$SA[$SA[0][0]][5] = GUICtrlRead($Amount1)
	$SA[$SA[0][0]][6] = GUICtrlRead($Amount2)
	$SA[$SA[0][0]][7] = GUICtrlRead($Amount3)
	$SA[$SA[0][0]][8] = GUICtrlRead($Amount4)
	GuiUpdate()
	$CurrentScriptRow = 0
	$ScriptFinished = True
	ScriptLoop()
EndFunc   ;==>AddPotionCraftingToScript

Func AddWHWithdrawAmountToScript() ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<=========
	$SA[0][0] += 1 ; Count of rows in ScriptArray
	If 9 > UBound($SA, 2) Then ; If data is too big for current size of SA Columns
		ReDim $SA[UBound($SA) + 1][9] ; increases size of rows by one for new data and columns for data size
	Else
		ReDim $SA[UBound($SA) + 1][UBound($SA, 2)] ; else increase rows by one for new data and keep columns the same
	EndIf
	$SA[$SA[0][0]][0] = $SA[0][0] & " | " & "WH: Withdraw Amount"
	$SA[$SA[0][0]][1] = GUICtrlRead($ItemID1)
	$SA[$SA[0][0]][2] = GUICtrlRead($ItemID2)
	$SA[$SA[0][0]][3] = GUICtrlRead($ItemID3)
	$SA[$SA[0][0]][4] = GUICtrlRead($ItemID4)
	$SA[$SA[0][0]][5] = GUICtrlRead($Amount1)
	$SA[$SA[0][0]][6] = GUICtrlRead($Amount2)
	$SA[$SA[0][0]][7] = GUICtrlRead($Amount3)
	$SA[$SA[0][0]][8] = GUICtrlRead($Amount4)
	GuiUpdate()
	$CurrentScriptRow = 0
	$ScriptFinished = True
	ScriptLoop()
EndFunc   ;==>AddWHWithdrawAmountToScript

Func ScriptLoop()
	If $CurrentScriptRow < $SA[0][0] Then
		$CurrentScriptRow += 1
	ElseIf $CurrentScriptRow = $SA[0][0] And $ScriptFinished = False Then
		$boton = 0
		$LIndex = GUICtrlCreateListViewItem("Script Finished", $ScriptConsole)
		_GUICtrlListView_EnsureVisible($ScriptConsole, $LIndex - 46)
		$ScriptFinished = True
		GUICtrlSetData($StartStop, "Start(DEL)")
	EndIf




	If $ScriptFinished = False And $SA[0][0] > 0 Then
		;=============================WH Withdraw Amount============================================
		If StringInStr($SA[$CurrentScriptRow][0], "WH: Withdraw Amount") > 1 Then
			$LIndex = GUICtrlCreateListViewItem(">>> " & $CurrentScriptRow & " WH: Withdraw Amount", $ScriptConsole)
			_GUICtrlListView_EnsureVisible($ScriptConsole, $LIndex - 46)
			ScanWHInventoryBag()
			For $d = 1 To 4 Step 1 ; loop through SA and compare craft bag invent to our SA data
				For $i = 1 To UBound($WHInventoryBag) - 1 Step 1 ; loop thourgh slots of wh invent bag
;~ 				For $d = 1 To 4 Step 1 ; loop through SA and compare craft bag invent to our SA data
					If $WHInventoryBag[$i][0] = $SA[$CurrentScriptRow][$d] And $WHInventoryBag[$i][0] <> 0 Then
						If Not WinActive($NameOfSomaWindow) Then
							WinActivate($NameOfSomaWindow)
							WinWaitActive($NameOfSomaWindow)
						EndIf
						_KDMemory_WriteProcessMemory($handles, 0x0535990, 'DWORD', $i - 1, $offsets = 0)
						Sleep($DialogSleep)
						If $SA[$CurrentScriptRow][$d + 4] > 1 Then
							If ($WHInventoryBag[$i][2] * $SA[$CurrentScriptRow][$d + 4]) + $BWCurrent <= $BWMax Then
;~ 							$BWCurrent $BWMax
								MouseClick("Left", $WHWithdrawButtonX, $WHWithdrawButtonY, 5)
								Sleep($DialogSleep)
								Send($SA[$CurrentScriptRow][$d + 4])
								Sleep($DialogSleep)
								Send('{ENTER}')
							Else
								$boton = 0
								MsgBox(0, "", "Not enough BW")
								$RowFinished = True
							EndIf
						Else
							MouseClick("Left", $WHWithdrawButtonX, $WHWithdrawButtonY, 5)
							Send('{ENTER}')
							$RowFinished = True
						EndIf
						exitloop
					EndIf
					if $i = UBound($WHInventoryBag) - 1 And $WHInventoryBag[$i][0] <> $SA[$CurrentScriptRow][$d] then
										$boton = 0
								MsgBox(0, "", "Could Not Find Item")
								$RowFinished = True
						endif
				Next
			Next
			;============================= NAVIGATE ============================================
		ElseIf StringInStr($SA[$CurrentScriptRow][0], "Navigate") > 1 Then
			$LIndex = GUICtrlCreateListViewItem(">>> " & $CurrentScriptRow & " Navigate", $ScriptConsole)
			_GUICtrlListView_EnsureVisible($ScriptConsole, $LIndex - 46)
			For $i = 1 To $MaxNodes Step 1 ;Clear NavNodes array for a new set of navnodes
				$NavNodes[0][0] = 0
				$NavNodes[$i][0] = 0
				$NavNodes[$i][1] = 0
			Next
			$NavNodes[0][0] = $SA[$CurrentScriptRow][1] ; Save Number of Nodes
			For $n = 1 To $SA[$CurrentScriptRow][1] Step 1 ; For 1 to Number of NavNodes in SA
				If $SA[$CurrentScriptRow][$n] <> "" Then
					$NavNodes[$n][0] = $SA[$CurrentScriptRow][$n + 1]
					$NavNodes[$n][1] = $SA[$CurrentScriptRow][$n + 1 + $SA[$CurrentScriptRow][1]]
				EndIf
			Next
			$Node = 1
			$Navigate = True
			;=============================CRAFT POTIONS=====================================
		ElseIf StringInStr($SA[$CurrentScriptRow][0], "Craft Potions") > 1 Then
			$LIndex = GUICtrlCreateListViewItem(">>> " & $CurrentScriptRow & " Craft Potions", $ScriptConsole)
			_GUICtrlListView_EnsureVisible($ScriptConsole, $LIndex - 46)
			ScanCraftInventoryBag()
			$MaxBagWeight = False
			$InventFull = False
			$NoMoreMats = False
			For $i = 1 To 10 Step 1 ; loop thourgh slots of craft window invent bag
				For $d = 1 To 4 Step 1 ; loop through SA and compare craft bag invent to our SA data
					If $CraftInventoryBag[$i][0] = $SA[$CurrentScriptRow][$d] And $CraftInventoryBag[$i][0] <> 0 Then
						If Not WinActive($NameOfSomaWindow) Then
							WinActivate($NameOfSomaWindow)
							WinWaitActive($NameOfSomaWindow)
						EndIf
						If $i < 6 Then
							MouseClickDrag("Left", $PotionCraftTopLeftBoxX + (($i - 1) * 55), $PotionCraftTopLeftBoxY, $PotionCraftTopLeftBoxX + 55, $PotionCraftTopLeftBoxY - 197, 4)
							Sleep($DialogSleep)
							If $SA[$CurrentScriptRow][$d + 4] > 1 Then ;amount
								Send($SA[$CurrentScriptRow][$d + 4])
								Sleep($DialogSleep)
								Send('{ENTER}')
							Else
								Send('{ENTER}')
							EndIf
						ElseIf $i >= 6 Then
							MouseClickDrag("Left", $PotionCraftTopLeftBoxX + (($i - 6) * 55), $PotionCraftTopLeftBoxY + 55, $PotionCraftTopLeftBoxX + 55, $PotionCraftTopLeftBoxY - 197, 4)
							Sleep($DialogSleep)
							Send('{ENTER}')
						EndIf
					EndIf

				Next
			Next
			MouseMove($PotionCraftTopLeftBoxX + 217, $PotionCraftTopLeftBoxY - 151, 4)
			MouseDown("Left")
			Do
				MouseMove($PotionCraftTopLeftBoxX + 217, $PotionCraftTopLeftBoxY - 151, 4)
				ScanCraftInventoryBag()
				FillEntityArray()
				If $BWCurrent >= $BWMax - 10 Then
;~ 			$MaxBagWeight = True
				ElseIf $InventoryItemCount = 40 Then
					$InventFull = True
				EndIf
				For $g = 1 To 4 Step 1 ; loop through SA and compare craft bag invent to our SA data
					For $e = 1 To 10 Step 1 ; loop through Craft invent to find our mats again
						If $CraftInventoryBag[$e][0] = $SA[$CurrentScriptRow][$g] And $CraftInventoryBag[$e][0] <> 0 Then ; check if our target mats exist in Craft invent
							If $SA[$CurrentScriptRow][$g + 4] > $CraftInventoryBag[$e][2] Then ; if there are less mats than the amount
;~ 						$NoMoreMats = True
							EndIf
							ExitLoop
						ElseIf $e = 10 And $CraftInventoryBag[$e][0] <> $SA[$CurrentScriptRow][$g] Then
							$NoMoreMats = True
						EndIf
					Next
				Next
			Until $MaxBagWeight = True Or $InventFull = True Or $NoMoreMats = True
			MouseUp("Left")
;~ 	MsgBox(0, "", "Max BW " & $MaxBagWeight & @CRLF & "inventfull " & $InventFull & @CRLF & "Nomoremats " & $NoMoreMats,3)
			Send('{ESC}')
			$RowFinished = True
			;==============================MOUSE CLICK==========================================
		ElseIf StringInStr($SA[$CurrentScriptRow][0], "Mouse Click") > 1 Then
			$LIndex = GUICtrlCreateListViewItem(">>> " & $CurrentScriptRow & " Mouse Click", $ScriptConsole)
			_GUICtrlListView_EnsureVisible($ScriptConsole, $LIndex - 46)
			If Not WinActive($NameOfSomaWindow) Then
				WinActivate($NameOfSomaWindow)
				WinWaitActive($NameOfSomaWindow)
			EndIf
			Sleep($DialogSleep)
			MouseClick("Left", $SA[$CurrentScriptRow][1], $SA[$CurrentScriptRow][2])
			$RowFinished = True
			;==============================CLICK NPC==========================================
		ElseIf StringInStr($SA[$CurrentScriptRow][0], "Click NPC") > 1 Then
			$LIndex = GUICtrlCreateListViewItem(">>> " & $CurrentScriptRow & " Click NPC " & $SA[$CurrentScriptRow][2], $ScriptConsole)
			_GUICtrlListView_EnsureVisible($ScriptConsole, $LIndex - 46)
			If Not WinActive($NameOfSomaWindow) Then
				WinActivate($NameOfSomaWindow)
				WinWaitActive($NameOfSomaWindow)
			EndIf
			For $i = 1 To 38 Step 1 ; work out the distance from the NPC
				If $EA[$i][0] = $SA[$CurrentScriptRow][1] Then
					$XDistanceFromNPC = Abs($EA[$i][2] - $MyX)
					$YDistanceFromNPC = Abs($EA[$i][3] - $MyY)
					$TotalDistanceFromNPC = $XDistanceFromNPC + $YDistanceFromNPC
					$TargetEntity = $i
				EndIf
			Next
			If $TotalDistanceFromNPC > 6 Then
				Do
					FillEntityArray()
					For $i = 1 To 38 Step 1 ; work out the distance from the NPC
						If $EA[$i][0] = $SA[$CurrentScriptRow][1] Then
							$XDistanceFromNPC = Abs($EA[$i][2] - $MyX)
							$YDistanceFromNPC = Abs($EA[$i][3] - $MyY)
							$TotalDistanceFromNPC = $XDistanceFromNPC + $YDistanceFromNPC
							$TargetX = $EA[$i][2]
							$TargetY = $EA[$i][3]
							$TargetEntity = $i
						EndIf
					Next
					NavigateToTarget($TargetX, $TargetY)
					AttackTarget($TargetEntity)
				Until $TotalDistanceFromNPC <= 6
			ElseIf $TotalDistanceFromNPC <= 6 Then
;~ 				sleep(1500)
				AttackTarget($TargetEntity)
			EndIf
			$RowFinished = True
			;==============================SEND KEY==========================================
		ElseIf StringInStr($SA[$CurrentScriptRow][0], "Send Key") > 1 Then
			$LIndex = GUICtrlCreateListViewItem(">>> " & $CurrentScriptRow & " Send Key " & $SA[$CurrentScriptRow][1], $ScriptConsole)
			_GUICtrlListView_EnsureVisible($ScriptConsole, $LIndex - 46)
			If Not WinActive($NameOfSomaWindow) Then
				WinActivate($NameOfSomaWindow)
				WinWaitActive($NameOfSomaWindow)
			EndIf
			Send($SA[$CurrentScriptRow][1])
			$RowFinished = True
			;==============================Sleep==========================================
		ElseIf StringInStr($SA[$CurrentScriptRow][0], "Sleep") > 1 Then
			$LIndex = GUICtrlCreateListViewItem(">>> " & $CurrentScriptRow & " Sleep " & $SA[$CurrentScriptRow][1], $ScriptConsole)
			_GUICtrlListView_EnsureVisible($ScriptConsole, $LIndex - 46)
			If Not WinActive($NameOfSomaWindow) Then
				WinActivate($NameOfSomaWindow)
				WinWaitActive($NameOfSomaWindow)
			EndIf
			Sleep($SA[$CurrentScriptRow][1])
			FillEntityArray()
			$RowFinished = True
		EndIf
	EndIf
EndFunc   ;==>ScriptLoop


;=============================================================================




Func GetMousePosSwitch()
	If $GetMousePosSwitch = False Then
		$GetMousePosSwitch = True
		GUICtrlSetData($GetMousePos, "Stop/Reset")
	ElseIf $GetMousePosSwitch = True Then
		$GetMousePosSwitch = False
		GUICtrlSetData($GetMousePos, "GetCoords")
		ToolTip("")
	EndIf
EndFunc   ;==>GetMousePosSwitch

Func GetMousePos()
	If $GetMousePosSwitch = True Then
		If Not WinActive($NameOfSomaWindow) Then
			WinActivate($NameOfSomaWindow)
			WinWaitActive($NameOfSomaWindow)
		EndIf
		ToolTip("Click to set Coords")
		If _IsPressed("01") Then
			GUICtrlSetData($MousePosXLabel, "X: " & MouseGetPos(0))
			GUICtrlSetData($MousePosYLabel, "Y: " & MouseGetPos(1))
			$MousePosX = MouseGetPos(0)
			$MousePosY = MouseGetPos(1)
			$GetMousePosSwitch = False
			GUICtrlSetData($GetMousePos, "GetCoords")
			ToolTip("")
		EndIf
	EndIf
EndFunc   ;==>GetMousePos

Func AddMousePosToScript()
	$SA[0][0] += 1 ; Count of rows in ScriptArray
	If 9 > UBound($SA, 2) Then ; If data is too big for current size of SA Columns
		ReDim $SA[UBound($SA) + 1][9] ; increases size of rows by one for new data and columns for data size
	Else
		ReDim $SA[UBound($SA) + 1][UBound($SA, 2)] ; else increase rows by one for new data and keep columns the same
	EndIf
	$SA[$SA[0][0]][0] = $SA[0][0] & " | " & "Mouse Click"
	$SA[$SA[0][0]][1] = $MousePosX
	$SA[$SA[0][0]][2] = $MousePosY
	GuiUpdate()
	$CurrentScriptRow = 0
	$ScriptFinished = True
	ScriptLoop()
EndFunc   ;==>AddMousePosToScript

Func OpenSendKeyGUI()
	GUISetState(@SW_SHOW, $SendKeyGUI)
EndFunc   ;==>OpenSendKeyGUI

Func OpenSendSleepGUI()
	GUISetState(@SW_SHOW, $SendSleepGUI)
EndFunc   ;==>OpenSendSleepGUI


Func AddSendSleepToScript()
	$SA[0][0] += 1 ; Count of rows in ScriptArray
	If 9 > UBound($SA, 2) Then ; If data is too big for current size of SA Columns
		ReDim $SA[UBound($SA) + 1][9] ; increases size of rows by one for new data and columns for data size
	Else
		ReDim $SA[UBound($SA) + 1][UBound($SA, 2)] ; else increase rows by one for new data and keep columns the same
	EndIf
	$SA[$SA[0][0]][0] = $SA[0][0] & " | " & "Sleep " & GUICtrlRead($SendSleep)
	$SA[$SA[0][0]][1] = GUICtrlRead($SendSleep)
	GUISetState(@SW_HIDE, $SendSleepGUI)
	GuiUpdate()
	$CurrentScriptRow = 0
	$ScriptFinished = True
	ScriptLoop()
EndFunc   ;==>AddSendSleepToScript

Func AddSendKeyToScript()
	$SA[0][0] += 1 ; Count of rows in ScriptArray
	If 9 > UBound($SA, 2) Then ; If data is too big for current size of SA Columns
		ReDim $SA[UBound($SA) + 1][9] ; increases size of rows by one for new data and columns for data size
	Else
		ReDim $SA[UBound($SA) + 1][UBound($SA, 2)] ; else increase rows by one for new data and keep columns the same
	EndIf
	$SA[$SA[0][0]][0] = $SA[0][0] & " | " & "Send Key " & GUICtrlRead($Key)
	$SA[$SA[0][0]][1] = GUICtrlRead($Key)
	GUISetState(@SW_HIDE, $SendKeyGUI)
	GuiUpdate()
	$CurrentScriptRow = 0
	$ScriptFinished = True
	ScriptLoop()
EndFunc   ;==>AddSendKeyToScript

Func AddNPCButton()
	$SA[0][0] += 1 ; Count of rows in ScriptArray
	If 9 > UBound($SA, 2) Then ; If data is too big for current size of SA Columns
		ReDim $SA[UBound($SA) + 1][9] ; increases size of rows by one for new data and columns for data size
	Else
		ReDim $SA[UBound($SA) + 1][UBound($SA, 2)] ; else increase rows by one for new data and keep columns the same
	EndIf
	$SA[$SA[0][0]][1] = $TargetMobArray[0][0] ; id
	$SA[$SA[0][0]][2] = $TargetMobArray[0][1] ; name
	$SA[$SA[0][0]][0] = $SA[0][0] & " | " & "Click NPC " & $SA[$SA[0][0]][2]
	GuiUpdate()
	$CurrentScriptRow = 0
	$ScriptFinished = True
	ScriptLoop()
EndFunc   ;==>AddNPCButton

Func SelectNPCButton()
	If Not WinActive($NameOfSomaWindow) Then
		WinActivate($NameOfSomaWindow)
		WinWaitActive($NameOfSomaWindow)
	EndIf
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
			If $EA[$i][6] = 0 And $EA[$i][4] <> 0 And $EA[$i][0] <> 27206 And $EA[$i][0] = $TargetMob Then
				$TargetMobArray[0][0] = $EA[$i][0]
				$TargetMobArray[0][1] = $EA[$i][7]
				ToolTip($EA[$i][7] & " has been picked!")
				Sleep(1000)
				$SelectTargetMobLoop = 0
				ToolTip("")
				GUICtrlSetData($SelectedNPCLabel, $TargetMobArray[0][1])
				ExitLoop
			EndIf
		Next
	WEnd
EndFunc   ;==>SelectNPCButton









Func test()
	ScanWHInventoryBag()
;~ 			For $i = 1 To ubound($WHInventoryBag) - 1 Step 1 ; loop thourgh slots of wh invent bag
;~ 				For $d = 1 To 4 Step 1 ; loop through SA and compare craft bag invent to our SA data
;~ 					If $WHInventoryBag[$i][0] = $SA[$CurrentScriptRow][$d] And $WHInventoryBag[$i][0] <> 0 Then
;~ 						If Not WinActive($NameOfSomaWindow) Then
;~ 							WinActivate($NameOfSomaWindow)
;~ 							WinWaitActive($NameOfSomaWindow)
;~ 						EndIf
;~ 	_KDMemory_WriteProcessMemory($handles, 0x0535990, 'DWORD', 1 - 1, $offsets = 0)
;~ mouseclick("Left",$WHWithdrawButtonX,$WHWithdrawButtonY,5)

;~ 					EndIf
;~ 				Next
;~ 			Next
EndFunc   ;==>test




Func Tes()
	ScanCraftInventoryBag()
	For $i = 1 To 10 Step 1 ; loop thourgh slots of craft window invent bag
		For $d = 1 To 4 Step 1 ; loop through SA and compare craft bag invent to our SA data
			If $CraftInventoryBag[$i][0] = $SA[$CurrentScriptRow][$d] And $CraftInventoryBag[$i][0] <> 0 Then
				If Not WinActive($NameOfSomaWindow) Then
					WinActivate($NameOfSomaWindow)
					WinWaitActive($NameOfSomaWindow)
				EndIf
				If $i < 6 Then
					MouseClickDrag("Left", $PotionCraftTopLeftBoxX + (($i - 1) * 55), $PotionCraftTopLeftBoxY, $PotionCraftTopLeftBoxX + 55, $PotionCraftTopLeftBoxY - 197, 4)
					Sleep(100)
					If $SA[$CurrentScriptRow][$d + 4] > 1 Then ;amount
						Send($SA[$CurrentScriptRow][$d + 4])
						Sleep(100)
						Send('{ENTER}')
					Else
						Send('{ENTER}')
					EndIf
				ElseIf $i >= 6 Then
					MouseClickDrag("Left", $PotionCraftTopLeftBoxX + (($i - 6) * 55), $PotionCraftTopLeftBoxY + 55, $PotionCraftTopLeftBoxX + 55, $PotionCraftTopLeftBoxY - 197, 4)
					Sleep(100)
					Send('{ENTER}')
				EndIf
			EndIf

		Next
	Next
	MouseMove($PotionCraftTopLeftBoxX + 217, $PotionCraftTopLeftBoxY - 151, 4)
	MouseDown("Left")
	Do
		MouseMove($PotionCraftTopLeftBoxX + 217, $PotionCraftTopLeftBoxY - 151, 4)
		ScanCraftInventoryBag()
		FillEntityArray()
		If $BWCurrent >= $BWMax - 10 Then
;~ 			$MaxBagWeight = True
		ElseIf $InventoryItemCount = 40 Then
			$InventFull = True
		EndIf
		For $g = 1 To 4 Step 1 ; loop through SA and compare craft bag invent to our SA data
			For $e = 1 To 10 Step 1 ; loop through Craft invent to find our mats again
				If $CraftInventoryBag[$e][0] = $SA[$CurrentScriptRow][$g] And $CraftInventoryBag[$e][0] <> 0 Then ; check if our target mats exist in Craft invent
					If $SA[$CurrentScriptRow][$g + 4] > $CraftInventoryBag[$e][2] Then ; if there are less mats than the amount
;~ 						$NoMoreMats = True
					EndIf
					ExitLoop
				ElseIf $e = 10 And $CraftInventoryBag[$e][0] <> $SA[$CurrentScriptRow][$g] Then
					$NoMoreMats = True
				EndIf
			Next
		Next
	Until $MaxBagWeight = True Or $InventFull = True Or $NoMoreMats = True
	MouseUp("Left")
;~ 	MsgBox(0, "", "Max BW " & $MaxBagWeight & @CRLF & "inventfull " & $InventFull & @CRLF & "Nomoremats " & $NoMoreMats,3)
	Send('{ESC}')
EndFunc   ;==>Tes


Func CloseSendKeyGUI()
	GUISetState(@SW_HIDE, $SendKeyGUI)
EndFunc   ;==>CloseSendKeyGUI

Func CloseSendSleepGUI()
	GUISetState(@SW_HIDE, $SendSleepGUI)
EndFunc   ;==>CloseSendSleepGUI




