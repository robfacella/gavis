#!/bin/bash
IFS=$'\n'
minH=200
minW=200
toPurge=0
toSave=0
# use imagemagick to get png dimensions
#32x32
file="/media/pi/38B62D40724FA264/MintPng_Fri_Oct_15_23_41_32_2021/png/461768368.png"
#256x256
#file="/media/pi/38B62D40724FA264/MintPng_Fri_Oct_15_23_41_32_2021/png/461774106.png"
folder="/media/pi/38B62D40724FA264/MintPng_Fri_Oct_15_23_41_32_2021/png/"
DimensionCheck () {
	width=$(identify -format "%w" "$file")> /dev/null
	height=$(identify -format "%h" "$file")> /dev/null
	#echo "Width: $width ; Height: $height"
	if [ $width -lt $minW ] || [ $height -lt $minH ]
	then
		#echo "at least one of the dimension is below minimum threshold"
		let toPurge++
	else
		#echo "Width: $width ; Height: $height"
		let toSave++
	fi
	echo "To Purge: $toPurge"
	echo "To Save: $toSave"
}
FileInPath () {
	for image in $( find "$folder" -name "*.png"); do
		DimensionCheck
	done
}

FileInPath
