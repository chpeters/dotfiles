property ghosttyApp : "/Applications/Ghostty.app"
property editorPath : "/opt/homebrew/bin/nvim"

on run
	display dialog "Set this app as the default opener for Markdown files, or drop Markdown files onto it to open them in Neovim." buttons {"OK"} default button "OK"
end run

on open fileList
	if not my pathExists(ghosttyApp) then
		display alert "Ghostty was not found" message "Expected Ghostty at " & ghosttyApp & "."
		return
	end if

	if not my executableExists(editorPath) then
		display alert "Neovim was not found" message "Expected Neovim at " & editorPath & "."
		return
	end if

	repeat with fileRef in fileList
		set filePath to POSIX path of fileRef
		my openFileInGhostty(filePath)
	end repeat
end open

on openFileInGhostty(filePath)
	set fileDir to do shell script "/usr/bin/dirname " & quoted form of filePath
	set inputPath to do shell script "/usr/bin/mktemp /tmp/open-markdown-in-neovim.XXXXXX"
	set editorCommand to "/bin/rm -f " & quoted form of inputPath & "; exec " & quoted form of editorPath & " " & quoted form of filePath & linefeed
	do shell script "/usr/bin/printf %s " & quoted form of editorCommand & " > " & quoted form of inputPath

	set launchCommand to "/usr/bin/open -na " & quoted form of ghosttyApp & " --args " & quoted form of ("--working-directory=" & fileDir) & " " & quoted form of ("--input=path:" & inputPath)
	do shell script launchCommand
end openFileInGhostty

on pathExists(posixPath)
	try
		do shell script "/bin/test -e " & quoted form of posixPath
		return true
	on error
		return false
	end try
end pathExists

on executableExists(posixPath)
	try
		do shell script "/bin/test -x " & quoted form of posixPath
		return true
	on error
		return false
	end try
end executableExists
