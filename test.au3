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



AutoItSetOption("mousecoordmode", 2) ; Don't edit any of thee, it will break the bot
Global $DialogX = ($PreReswidth - 800) / 2
Global $DialogY = ($PreResheight - 565)


mousemove($DialogX,$DialogY)


