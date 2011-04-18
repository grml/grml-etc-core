#!/bin/sh
# Filename:      suspenduser_gui.sh
# Purpose:       dialog interface for suspend user
# Authors:       grml-team (grml.org), (c) Nico Golde <nico@grml.org>, (c) Michael Prokop <mika@grml.org>
# License:       This file is licensed under the GPL v2.
################################################################################

PATH=${PATH:-'/usr/bin:/usr/sbin'}

if [ "$(whoami)" != "root" ] ; then
  echo "Error. You must be 'root' to run this command." >&2
  exit 1
fi

dialog --stdout --title "Suspend User" --msgbox "Welcome to Suspend User

This script allows you to suspend a user from your system for
an indefinite time." 8 65

GETUSER=$(dialog --stdout --title "Suspend User" --inputbox "User to suspend:" 0 40) || exit 0
SUSPENDUSER=${GETUSER%/*}
suspenduser.sh $SUSPENDUSER

## END OF FILE #################################################################
