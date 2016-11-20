
Global $NameOfSomaWindow = IniRead("Settings.ini", "Settings", "NameOfSomaWindow", "Myth of Soma : Molten Meltdown")
WinActivate($NameOfSomaWindow)
AutoItSetOption("mousecoordmode", 2) ; Don't edit any of thee, it will break the bot
while 1
tooltip(MouseGetPos ( 0) & " / " & MouseGetPos (1))
wend