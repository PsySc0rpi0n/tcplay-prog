#!/bin/sh

######################### Make the Virtual Volume available #########################
make_available(){
   if [ $# -lt 1 ]; then
      echo "Not enough parameters. Usage: $0 path/to/file/filename.ext"
      exit 1
   fi

   if [[ ! -e $1 || ! -r $1 || ! -f $1 ]]; then
      echo "File $1 not found or not ready!"
      return -1
   fi

   echo "Issuing losetup command:"
   sudo losetup /dev/loop0 "$1"
   if [[ $? -ne 0 ]]; then
      echo "Error with $1!" >&2
      return 1
   fi
   cmd_status=1
   echo "losetup done!"

   echo "Issuing tcplay command:"
   sudo tcplay -m "$1" -d /dev/loop0
   if [[ $? -ne 0 ]]; then
      echo "Error attaching $1 container to /dev/loop0!" >&2
      return 2
   fi
   cmd_status=2
   echo "tcplay done!"

   echo "Issuing mount command:"
   sudo mount /dev/mapper/$1 /media/ISOimgs
   if [[ $? -eq 0  ]]; then
       echo "Error mounting /dev/mapper/$1 into /media/ISOimgs!"
       return 3;
   fi
   cmd_status=3
   echo "mount done!"
}

######################### Make the Virtual Volume unavailable #########################
make_unavailable(){
    case $cmd_status in
        3)
            echo "Undoing mount command:"
            sudo umount /media/ISOimgs
            if [[ $? -eq 0 ]]; then
                echo "Error undoing mount command!"
                return $cmd_status
            fi
            ;&
        2)
            echo "Undoing tcplay command with dmsetup:"
            sudo dmsetup remove "$1"
            if [[  $? -eq 0 ]]; then
                echo "Error undoing tcplay with dmsetup!"
                return $cmd_status
            fi
            ;&
        1)
            echo "Undoing losetup command:"
            sudo losetup -d /dev/loop0
            if [[ $? -eq 0 ]]; then
                echo "Error undoing losetup command!"
                return $cmd_status
            fi
            ;;
        *)  exit 1
            ;;
    esac
   echo "Undone!"
}

show_params(){
    echo "Number of parameters is $#."
    echo "List of parameters is $@."
}

#########################           Main Script               #########################
cmd_status=0
read -ep "Make Available [a] or Make Unavailable [u]: " opt

while [[ $opt -ne 'a' && $opt -ne 'u' && $opt -ne 'x' ]]
do
   echo "Wrong option!"
   echo "Available options are [a], [u] or [x] to quit!"
done

#echo "$opt"

case $opt in
   "a"|"A")
      #show_params "$@"
      make_available "$@" cmd_status
      ;;
   "u"|"U")
      make_unavailable "$@" cmd_status
      ;;
   "x"|"X")
      exit 1
      ;;
   *)
      echo "Unknown error!" >&2
      ;;
esac
