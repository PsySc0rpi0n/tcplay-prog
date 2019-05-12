#!/bin/sh
make_available(){
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
   if [[ $? -ne 0 ]]; then
      echo "Error attaching $1 container to /dev/loop0!" >&2
      exit 1
   fi
}

make_unavailable(){
   sudo dmsetup remove $1
   sudo losetup -d /dev/loop0
   echo "Undone!"
}

show_params(){
    echo "Number of parameters is $#."
    echo "List of parameters is $@."
}
####################### Main Script ############################
read -ep "Make Available [a] or Make Unavailable [u]: " opt

while [[ $opt -ne 'a' && $opt -ne 'u' && $opt -ne 'x' ]]
do
   echo "Wrong option!"
   echo "Available options are [a], [u] or [x] to quit!"
done

echo $opt

case $opt in
   "a"|"A")
      show_params
      make_available
      ;;
   "u"|"U")
      make_unavailable
      ;;
   "x"|"X")
      exit 1
      ;;
   *)
      echo "Unknown error!" >&2
      ;;
esac


