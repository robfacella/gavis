#!/bin/bash
#Set IFS to new line. (Used to suppress WHITE-SPACES in filenames from splitting $file into a list, instead of being handled as a single STRING unit.)
IFS=$'\n'

MainMenu () {
#Top Level Menu
   mainM="Life has Many Doors, Ed Boy."
   while [ $mainM != "q" ]
   do
	#ViewShred
	TarPack
	TarUPack
   done
}
###Tar Block#####
#Pack
#Get a Path to a $DIRECTORY, put the Recursive contents of that directory into $DIRECTORY.tar
TarPack () {
	echo "Enter a Directory to Tar. (Recursively): "
        SetInFile
	echo "Enter an output file: "
	SetOutFile
	## Also leaves behind a "." directory
	#tar -czvf $outfile.tar -C $infile .
	##Still leaves behind a top level directory named "." ...
	#cd $infile/ && tar -zcvf ../$outfile.tar . && cd -

	##Creates and appends to a tarball named test.tar : all files found within test files.
	find $infile -name "*.*" -exec tar -rvf $outfile {} \; && find $infile -depth -type f -exec shred -fvz -n1 -u {} \; && 	rm -Rv $infile
	##If the first action succeeds: shred and remove everything from infile recursively.
	##Does not remove folders, need to go back over with rm -R
}
#Unpack
#Get a Path to a $NAME.tar file and extract its contents to a directory named $NAME
TarUPack () {
	echo "Enter Tarball to Unpack: "
	SetInFile
	echo "Enter location to extract to (blank works for HERE): "
	SetOutFile

	tar -xvf $infile $outfile && shred -fvz -n1 -u $infile

}
#$IFILE / $OFILE format, like dd, for future command line use...
SetInFile () {
	GetPath #Sets Value of $infile from $folder
	infile="$folder"
}
SetOutFile () {
	GetPath #Sets Value of $outfile from $folder
	outfile="$folder"
}

####Main View/Shred Block###
ViewShred () {
   GetPath
   CalcDU
   startSize=$thisSize
   startFiles=$fileCount
   echo "Starting Size: $startSize k"
   fileInPath

}
handleFileChoice () {
	echo ""
	fileChoice="razzleDazzle"
	OpenInXviewer
	while [ $fileChoice != "0" ]
	do
		echo "$file"
		echo "0) Next File in List"
		echo "1) ReOpen with xviewer" #Could do this by default, even unsupported file types TRY to open successfully.
		#OpenInXviewer #Doing, just that.
		echo "4) Shred File"
		echo "6) Shred & remove File (Auto NEXT file in list.)"
		echo "9) Prompt number of files to skip over."
		echo "q) to quit "
		read fileChoice
		#Throws "unary operator expected" if left blank (ie, just hit enter) and counts as a 0?{moves to next file} but ALSO as invalid input{displays the else case message}???
		if [ $fileChoice == "q" ]
		then
			#Try to kill xviewer opened by script; exit afterward regardless 
			KillXview
			exit 0 #DO exit anyway if killing xviewer worked
		elif [ $fileChoice == "1" ]
		then
			OpenInXviewer
		elif [ $fileChoice == "4" ]
		then
			#KillXview #Don't actually seem to need to.
			#Shred File Randomly. (Single Pass)
			echo "Overwrite $file with random data:"
			shred -fv -n 1 $file
		elif [ $fileChoice == "6" ]
		then
			#KillXview #Don't seem to need to
			#Shred File to 0s. (Single Pass) && Remove
			echo "Zeroing $file and removing completely:"
			shred -fvz -n 0 -u $file
			fileChoice="0"
		elif [ $fileChoice == "9" ]
		then
			echo "How many files would you like to skip? (Include THIS one.)"
			read skipCounter
			while ! [[ "$skipCounter" =~ ^[0-9]+$ ]]
    			do
        			echo "Sorry integers only"
				read skipCounter
			done
			skipCounter=`expr $skipCounter - 1`
			if [ $skipCounter -ge 0 ]
			then
				fileChoice="0"
				echo "moving ahead $skipCounter files. (Plus this one.)"
			fi
			#Else they chose skip by mistake and entered 0 or less
		elif [ $fileChoice == "0" ]
		then
			echo " "
		else
			echo "Invalid Input"
		fi
	done
}
fileInPath () {
   skipCounter=0 #Number of Files to Skip Over in the File Queue. #Useful in large file queues, especially if a break is needed for some reason, or to go back a few entries by restarting and jumping by <place in queue> - <how far back you need to go>.
   for file in $( find "$folder" -name "*.*" ); do
	if [ $skipCounter -le 0 ]
	then
		handleFileChoice
	else
		skipCounter=`expr $skipCounter - 1`
		echo "Skipped $file"
	fi
	#Moved File Counter here.
	fileCount=`expr $fileCount - 1`
	echo "Files Remaining: $fileCount / $startFiles"
   done
   KillXview #Close when Done with File Set
}
OpenInXviewer () {
	ViewImageFile
	#Opens BUT focus on new Window. I want cursor to remain in terminal.
	sleep 1s
	#Pause, giving xviewer a chance to open.
	#Then shift control back to a window with the script name in the title
	wmctrl -a gavis ##ONLY WORKS WHEN SCRIPT IS RUN FROM WITHIN GAVIS Directory
	#Does not seem to be case sensitive, will need work around for MULTIPLE windows with regex matching... blehh
##ONLY WORKS WHEN SCRIPT IS RUN FROM WITHIN GAVIS
}
ViewImageFile () {
	##Opens file location in a new window with the XVIEWER program.
	##-w makes xviewer use a single window, will replace an old instance of itself INSTEAD of just opening a new instance. (Should help reduce acidental/negligent RAM leaks.)
	## & causes this to run as a separate process from this terminal/script, keeping the script from hanging until the newly opened process is killed.
	xviewer -w $file &
	##Stores the Process ID of the & generated process. in this case an xviewer window
	viewerPID=$!
	#echo "$viewerPID"
}
CalcDU () {
   thisSize=0  #Size of Files found. (~ kb)
   fileCount=0 #Number of Files found.
   for file in $( find "$folder" -name "*.*" ); do
      	#Calculate starting Size of Files.
        #echo "$file"
	val=$( du "$file" | awk '{print $1}' )
	#du|awk statement gets just size of files; stores in val
	thisSize=`expr $thisSize + $val`
	fileCount=`expr $fileCount + 1`
   done
   #echo "Starting size of File(s) within $folder: $thisSize k "
   echo "Files Found: $fileCount"
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
KillXview () {
	#Close xviewer window if found, else print the debug msg.
	pkill xviewer  || echo "xviewer window not found"
}

##Run
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
