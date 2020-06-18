#!/bin/bash
#Set IFS to new line. (Used to suppress WHITE-SPACES in filenames from splitting $file into a list, instead of being handled as a single STRING unit.)
IFS=$'\n'

MainMenu () {
   GetPath
   CalcDU
   startSize=$thisSize
   echo "Starting Size: $startSize k"
   fileInPath
}
fileInPath () {
   for file in $( find "$folder" -name "*.*" ); do
	echo ""
	echo "$file"
	echo "1) Open with xviewer"
	echo "q) to quit "
        read fileChoice
	if [ $fileChoice == "q" ]
	then
		exit 0
	fi
	if [ $fileChoice == "1" ]
	then
		ViewImageFile
		#Opens BUT focus on new Window. I want cursor to remain in terminal.

		sleep 1s
		#Pause, giving xviewer a chance to open.
		#Then shift control back to a window with the script name in the title
		wmctrl -a gavis
		#Does not seem to be case sensitive, will need work around for MULTIPLE windows with regex matching... blehh
	fi
   done
}
ViewImageFile () {
	##Opens file location in a new window with the XVIEWER program.
	##-w makes xviewer use a single window, will replace an old instance of itself INSTEAD of just opening a new instance. (Should help reduce acidental/negligent RAM leaks.)
	## & causes this to run as a separate process from this terminal/script, keeping the script from hanging until the newly opened process is killed.
	xviewer -w $file &
	##Stores the Process ID of the & generated process. in this case an xviewer window
	viewerPID=$!
}
CalcDU () {
   thisSize=0
   for file in $( find "$folder" -name "*.*" ); do
      	#Calculate starting Size of Files.
        #echo "$file"
	val=$( du "$file" | awk '{print $1}' )
	#du|awk statement gets just size of files; stores in val
	thisSize=`expr $thisSize + $val`
   done
   #echo "Starting size of File(s) within $folder: $thisSize k "
   ##This outputs 72 k total file size for the files within the testFiles directory
   ##HOWEVER, right clicking on testFiles and observing the directory's properties shows only 46.5 kB of disk usage.
}
EntryMsg () {
   echo "Iterates over image files with xviewer"
   echo "In a directory and all of its subdirectories."
   echo ""
}
GetPath () {
	echo "Enter a path(--h for more info): "
	#folder="testFiles"
	read folder
	##Using "../" within a path Throws:
        #expr: syntax error
	##BUT the CalcDu still runs and outputs the same final number
}


EntryMsg
MainMenu
#echo "$folder"

##Opens file location in a new window with the XVIEWER program.
##-w makes xviewer use a single window, will replace an old instance of itself INSTEAD of just opening a new instance. (Should help reduce acidental/negligent RAM leaks.)
## & causes this to run as a separate process from this terminal/script, keeping the script from hanging until the newly opened process is killed.
#xviewer -w testFiles/lobster.jpg &

##Stores the Process ID of the & generated process. in this case an xviewer window
#viewerPID=$!

##Wait for 5 seconds. (Test purposes. Can choose to kill by other conditions later.)
#sleep 5s

##Kill the Process of the xviewer window using the PID generated and stored into viewerPID at runtime.
#kill $viewerPID
