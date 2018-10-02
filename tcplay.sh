#!/bin/sh

echo $#
if [ $# -lt 2 ]; then
   echo "Not enough parameters. Usage: " $0 "path/to/file/filename.ext"
else
   echo "File" $1 "found!"
fi
