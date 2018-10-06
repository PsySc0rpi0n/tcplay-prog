#!/bin/sh

if [ $# -lt 1 ]; then
   echo "Not enough parameters. Usage: $0 path/to/file/filename.ext"
   exit 1
fi

if [[ ! -e $1 || ! -r $1 || ! -f $1 ]]; then
   echo "File $1 not found or not ready!"
   exit 1
fi

sudo losetup /dev/loop0 $1
if [[ $? -ne 0 ]]; then
   echo "Error with $1!" >&2
   exit 1
fi

sudo tcplay -m $1 -d /dev/loop0
if [[ $? -ne 0]]; then
   echo "Error attaching $1 container to /dev/loop0!" >&2
   exit 1
fi

sudo losetup -d /dev/loop0
echo "Undone!"
