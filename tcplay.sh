#!/usr/bin/env bash

######################### Make the Virtual Volume available #########################
make_available(){
   if [[ $# -lt 1 ]]; then
      echo "Not enough parameters. Usage: $0 path/to/file/filename.ext"
      exit 1
   fi

   if [[ ! -e "$1" || ! -r "$1" || ! -f "$1" ]]; then
      echo "File $1 not found or not ready!"
      exit 1
   fi

   echo "Issuing losetup command:"
   if ! sudo losetup /dev/loop0 "$1"; then
      echo "Error with $1!" 1>&2
      return 1
   fi
   cmd_status=1
   echo "losetup done!"

   echo "Issuing tcplay command:"
   if ! sudo tcplay -m "$1" -d /dev/loop0; then
      echo "Error attaching $1 container to /dev/loop0!" 1>&2
      return 2
   fi
   cmd_status=2
   echo "tcplay done!"

   echo "Issuing mount command:"
   if ! sudo mount /dev/mapper/"$1" /media/ISOimgs; then
       echo "Error mounting /dev/mapper/$1 into /media/ISOimgs!" 1>&2
       return 3;
   fi
   cmd_status=3
   echo "mount done!"
}

######################### Make the Virtual Volume unavailable #########################
make_unavailable(){
    case $cmd_status in
        3)
            echo "Undoing mount command!"
            if ! sudo umount /media/ISOimgs; then
                echo "Error undoing mount command!" 1>&2
                return $cmd_status
            fi
            ;&
        2)
            echo "Undoing tcplay command with dmsetup!"
            if ! sudo dmsetup remove "$1"; then
                echo "Error undoing tcplay with dmsetup!" 1>&2
                return $cmd_status
            fi
            ;&
        1)
            echo "Undoing losetup command!"
            if ! sudo losetup -d /dev/loop0; then
                echo "Error undoing losetup command!" 1>&2
                return $cmd_status
            fi
            ;&
        0)
            echo "No commans done so no commands undone!" 1>&2
            return $cmd_status
            ;;
        *)  echo "No commands undone or unknown error!" 1>&2
            exit 1
            ;;
    esac
   echo "Undone!"
}

show_params(){
    echo "Number of parameters is $#."
    echo "List of parameters is $*."
}

#########################           Main Script               #########################
cmd_status=0

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 /path/to/container.tc"
    exit 1
fi

while true; do
    echo "Enter an option:"
    echo "[A] or [a] to make Available"
    echo "[U] or [u] to make Unavailable"
    echo "[Q] or [q] to quit"
    while true; do
        read -r -n1 -p "> " opt
        echo
        case $opt in
            "a"|"A")
                make_available "$@" cmd_status
                ;;
            "u"|"U")
                make_unavailable "$@" cmd_status
                ;;
            "q"|"Q")
                exit 1
                ;;
            *)
                echo "Unknown error!" 1>&2
                ;;
        esac
    done
done
