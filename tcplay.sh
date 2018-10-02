#!/bin/sh

if [ $# -lt 1 ]; then
   echo "Not enough parameters. Usage: $0 path/to/file/filename.ext"
fi

if [[ ! -e $1 || ! -r $1 || ! -f $1 ]]; then
   echo "File $1 not found or ready!"
fi
