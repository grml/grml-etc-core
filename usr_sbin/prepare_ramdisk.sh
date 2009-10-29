#!/bin/zsh
# Filename:      prepare_ramdisk.sh
# Purpose:       set up a ramdisk of a selected directory
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
FILENAME=$(echo $DIRECTORY | sed 's#/#_#g')
CACHE_FILE="/ramdisk_cache/$FILENAME"
CACHE_FILE_SIZE=64

prepare_start () {
  if ! mount | grep -q "tmpfs on /ramdisk_cache" ; then
    echo -n "Setting up ramdisk /ramdisk_cache: "
    [ -d /ramdisk_cache ] || mkdir /ramdisk_cache
    mount -t tmpfs tmpfs /ramdisk_cache && echo "done"
  fi

  if ! mount | grep -q "${DIRECTORY}.*loop" ; then
   if [ -d "$DIRECTORY" ] ; then
    if ! mount | grep -q "loop.*${DIRECTORY}" ; then
      mv $DIRECTORY/ $DIRECTORY.tmpfile && \
      mkdir $DIRECTORY

      echo -n "Setting up cachefile $CACHE_FILE for $DIRECTORY: "
      dd if=/dev/zero of=${CACHE_FILE} bs=1M count=${CACHE_FILE_SIZE} \
      seek=${CACHE_FILE_SIZE} &>/dev/null && \
      mkfs.ext2 -F ${CACHE_FILE} &>/dev/null && \
      mount -o loop ${CACHE_FILE} $DIRECTORY && \
      cp -a $DIRECTORY.tmpfile/*  $DIRECTORY  &>/dev/null
      cp -a $DIRECTORY.tmpfile/.* $DIRECTORY  &>/dev/null
      echo "done" || echo "failed."
    else
      echo "Error: $DIRECTORY already mounted as loopback device. Exiting."
    fi
   else
    echo "Error: $DIRECTORY does not exist. Exiting."
    exit 1
   fi
  else
   echo "Error: $DIRECTORY already mounted loop back."
  fi
}

prepare_stop () {
  if mount | grep -q $DIRECTORY ; then
    echo -n "Unmounting cachefile ${CACHE_FILE}: "
    cp -a $DIRECTORY/*  $DIRECTORY.tmpfile/  &>/dev/null
    cp -a $DIRECTORY/.* $DIRECTORY.tmpfile/  &>/dev/null
    if umount $DIRECTORY ; then
      rmdir $DIRECTORY
      mv $DIRECTORY.tmpfile/ $DIRECTORY
      echo done
    else
      echo "error [while unmounting ${DIRECTORY}]"
    fi
  else
    echo "Error: $DIRECTORY not mounted."
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
