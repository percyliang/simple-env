#!/bin/bash

SRC=$PWD
DEST=$HOME

# Link all dot files (or directories)
for f in $SRC/.[a-zA-Z]*; do
  ln -sfv $f $DEST || exit 1
done
