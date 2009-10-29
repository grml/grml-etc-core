#!/bin/zsh
# Filename:      prepare_tmpfs.sh
# Purpose:       set up a tmpfs of a selected directory
# Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
# Bug-Reports:   see http://grml.org/bugs/
# License:       This file is licensed under the GPL v2.
################################################################################

if [ $(id -u) != 0 ] ; then
  echo "Error: $0 requires root permissions. Exiting."
  exit 1
fi

setopt nonomatch

usage(){
  echo "Usage: $0 <directory> <start|stop>"
}

if ! [ -n "$1" -a -n "$2" ] ; then
  usage
  exit 1
fi

DIRECTORY="$1"

prepare_start () {
  if ! mount | grep -q "tmpfs on ${DIRECTORY}" ; then
   if [ -d $DIRECTORY ] ; then
    if ! [ -d $DIRECTORY.tmpfile ] ; then
     echo -n "Setting up tmpfs ${DIRECTORY}: "
     mv $DIRECTORY/ $DIRECTORY.tmpfile && \
     mkdir $DIRECTORY && \
     if mount $TMPFS -t tmpfs tmpfs $DIRECTORY ; then
       cp -a $DIRECTORY.tmpfile/*  $DIRECTORY  &>/dev/null
       cp -a $DIRECTORY.tmpfile/.* $DIRECTORY  &>/dev/null
       echo done
     else
       echo failed
     fi
    else
     echo "Erorr: tmpdir $DIRECTORY.tmpfile exists already. Exiting."
     exit 1
    fi
   else
    echo "Error: $DIRECTORY does not exist. Exiting."
    exit 1
   fi
  else
    echo "Error: $DIRECTORY already mounted. Exiting."
    exit 1
  fi
}

prepare_stop () {
  if mount | grep -q $DIRECTORY ; then
    echo -n "Unmounting tmpfs ${DIRECTORY}: "
    umount ${DIRECTORY} && \
    rmdir $DIRECTORY && \
    mv $DIRECTORY.tmpfile $DIRECTORY && echo done || echo failed
  else
    echo "Error: ${DIRECTORY} not mounted."
    exit 1
  fi
}

case "$2" in
  start)
     prepare_start || exit 1
     ;;
  stop)
     prepare_stop || exit 1
     ;;
  *)
     usage
     exit 1
esac

exit 0

## END OF FILE #################################################################
