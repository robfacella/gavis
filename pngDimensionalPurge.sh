#!/bin/bash
IFS=$'\n'
minH=200
minW=200
toPurge=0
toSave=0
start=`date +%s`
# use imagemagick to get png dimensions
#32x32
file="/media/pi/38B62D40724FA264/MintPng_Fri_Oct_15_23_41_32_2021/png/461768368.png"
#256x256
#file="/media/pi/38B62D40724FA264/MintPng_Fri_Oct_15_23_41_32_2021/png/461774106.png"
folder="/media/pi/38B62D40724FA264/MintPng_Fri_Oct_15_23_41_32_2021/png/"
DimensionCheck () {
	width=$(identify -format "%w" "$image")> /dev/null
	height=$(identify -format "%h" "$image")> /dev/null
	#echo "Width: $width ; Height: $height"
	if [ $width -lt $minW ] || [ $height -lt $minH ]
	then
		#echo "at least one of the dimension is below minimum threshold"
		shred -fz -n0 -u $image
		let toPurge++
		echo "purged"
	else
		echo "Width: $width ; Height: $height"
		let toSave++
	fi
}
FileInPath () {
	for image in $( find "$folder" -name "*.png"); do
		DimensionCheck
	done
	echo "Purged: $toPurge"
	echo " Saved: $toSave"
}

FileInPath
end=`date +%s`
runtime=$((end-start))
echo "Total Runtime in seconds: $runtime"
