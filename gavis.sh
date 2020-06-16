#!/bin/bash
#Set IFS to new line.
#IFS=$'\n'

echo "Iterates over image files with xviewer"
echo "In a directory and all of its subdirectories."
echo ""
echo "Enter a path(--h for more info): "
folder="testFiles"
#read folder

startSize=0
for file in $( find "$folder" -name '*.*' ); do
	#Calculate starting Size of Files.
        #echo "$file"
	val=$( du "$file" | awk '{print $1}' ) 
	#du|awk statement gets just size of files; stores in val
	startSize=`expr $startSize + $val`
done
echo "Starting size of File(s) within $folder: $startSize k "
##This outputs 72 k total file size for the files within the testFiles directory
##HOWEVER, right clicking on testFiles and observing the directory's properties shows only 46.5 kB of disk usage.

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
