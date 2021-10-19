#!/bin/bash
minH=200
minW=200
# use imagemagick to get png dimensions
file="/media/pi/38B62D40724FA264/MintPng_Fri_Oct_15_23_41_32_2021/png/461768368.png"
width=$(identify -format "%w" "$file")> /dev/null
height=$(identify -format "%h" "$file")> /dev/null
#echo "Width: $width ; Height: $height"
if [ $width -lt $minW ] || [ $height -lt $minH ]
then
	echo "at least one of the dimension is below minimum threshold"
fi
