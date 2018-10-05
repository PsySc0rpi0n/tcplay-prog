#!/bin/sh

if [ $# -lt 1 ]; then
   echo "Not enough parameters. Usage: $0 path/to/file/filename.ext"
fi

if [[ ! -e $1 || ! -r $1 || ! -f $1 ]]; then
   echo "File $1 not found or not ready!"
fi

export MOUNT=/dev/loop0
if grep -qs $MOUNT /proc/mounts ; then
   echo "loop0 device is ready! Command status: $?"
else
   echo "$MOUNT is not ready!"
fi
