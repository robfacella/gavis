#!/bin/bash
IFS=$'\n'
startTime=`date +%s`
folder="/media/pi/38*"
cd $folder
folder="MintPn*"
cd $folder
folder="png"
cd $folder
echo $( pwd )
files=$( ls -d $PWD/* )
i=0
for file in {0..${files}}
do
	#echo "$i - $file"
	#let i++
	#$file
	identify -format "%f %#\n" $file >> fileNameHash.txt
done

endTime=`date +%s`
runtime=$((endTime-startTime))
echo "Total Runtime in seconds: $runtime"

