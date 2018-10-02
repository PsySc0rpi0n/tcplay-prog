#!/bin/sh

echo "Enter Virtual Volume filename and path:"
read filename
expfilename=$filename
echo "$expfilename"

if [ -s $filename ]; then
    echo "$filename exists!"

    if [ -r $filename ]; then
        echo "$filename is readable!"
    fi

    if [ -f $filename ]; then
        echo "$filename is accessible!"
    fi
else
    echo "$filename not found!"
fi
