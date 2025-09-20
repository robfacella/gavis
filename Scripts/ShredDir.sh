#!/bin/bash

infile="$HOME/Downloads/testFiles"
#ls $infile

# From the deepest point in the directory,
# Shred by Zero'ing, Single-Pass, Unlinking Files Shreded
find $infile -depth -type f -exec shred -fvz -n0 -u {} \;

# Afterwards the directories *should* be empty and thus removable
find $infile -depth -type d -exec rm -dv {} \;

## Remove Root of Traversed Directories last
# rm -Rv $infile
## Actually, that's too many, the find above Covers it.
