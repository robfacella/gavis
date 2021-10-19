#!/bin/bash
# use imagemagick to get png dimensions
file="/media/pi/38B62D40724FA264/MintPng_Fri_Oct_15_23_41_32_2021/png/461768368.png"
width=$(identify -format "%w" "$file")> /dev/null
height=$(identify -format "%h" "$file")> /dev/null
echo "Width: $width ; Height: $height"
