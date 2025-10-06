#!/usr/bin/env bash

#ProjectRoot="/media/rob/38B62D40724FA264/OBS_Openshot/" # Just testing in production...
# [Openshot] Dir named 'thumbnail' rename for other programs maybe... or add as 2nd Argsv
AutoGen_Thumbnail_Dir_Name="thumbnail"
# Uses 1st arg after script name as a Top Level of Directory Tree
ProjectRoot=$1

# Iterate over that folder. ie: '/root/path/folder/*'
for directory in "$ProjectRoot"* ; do
  # Only work on Directory Files
  if [ -d "$directory" ]; then
     justDir=$(echo $(basename "$directory"))
     #echo "$directory"	#Fullish Path
     #echo "$justDir"	#Just the immediate directory
     # If Directory name matches the expected thumbnail folder created by [Openshot].
     if [ "$justDir" == "$AutoGen_Thumbnail_Dir_Name" ]; then
	#echo "Thumbnail Dir Found!"
        # Need to add the '/' after Directory seen below.
        echo "Removing: $directory/"
        rm -rf "$directory/"
     # For other Folders, recurse deeper.
     else
        #echo "Recursing through..."
	bash $0 "$directory/"
     fi
  fi
done
exit
