#!/bin/sh

echo "Enter Virtual Volume filename and path:"
read filename
expfilename=$filename
echo "$expfilename"

if [ -s $expfilename ]; then
    echo "$expfilename exists!"

    if [ -r $expfilename ]; then
        echo "$expfilename is readable!"
    fi

    if [ -f $expfilename ]; then
        echo "$expfilename is accessible!"
    fi
else
    echo "$expfilename not found!"
fi
