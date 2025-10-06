#!/bin/bash

#ProjectRoot="/media/rob/38B62D40724FA264/OBS_Openshot/UraniumVersion/"
ProjectRoot=$1
#ls -lah $ProjectRoot

for directory in "$ProjectRoot"* ; do
  if [ -d "$directory" ]; then
     justDir=$(echo $(basename "$directory"))
     #echo "$directory"	#Fullish Path
     #echo "$justDir"	#Just the immediate directory
     if [ "$justDir" == "thumbnail" ]; then
	echo "Thumbnail Dir Found!"
        echo "Removing: $directory/"
        rm -rf "$directory/"
     else
        #echo "Recursing through..."
	#echo $0 $directory/
	bash $0 "$directory/"
     fi
  fi
done
exit
