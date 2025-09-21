#!/bin/bash

# Worked with:
# bash Scripts/ShredDir.sh $HOME/Downloads/testFiles/
# which is 'Good-Enough' for current use case

# Uses first command line argument (after the script name)
# As the 'Input String for the Directory to Shred'
infile="$1"
#ls $infile

# From the 'deepest point' in the directory tree,
# 'Shred' by '[z]ero-ing', 'Si[n]gle-Pass', '[u]nlinking Files' Shreded with '[v]erbose' output
find $infile -depth -type f -exec shred -fvz -n0 -u {} \;

# Afterwards the [d]irectories *should* be empty and thus removable
find $infile -depth -type d -exec rm -dv {} \;

## Remove Root of Traversed Directories last
# rm -Rv $infile
## Actually, that's too many, the find above Covers it.
