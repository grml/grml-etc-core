#!/bin/bash
# Filename:      ndiswrapper.sh
# Purpose:       NdisWrapper configuration script
# Authors:       (c) Martin Oehler 2004, (c) Michael Prokop <mika@grml.org>
# Bug-Reports:   see http://grml.org/bugs/
# License:       This file is licensed under the GPL v2.
################################################################################

PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin"
export PATH

# Get root
if [ $UID != 0 ] ; then
   echo Error: become root before starting $0 >& 2
   exit 100
fi
unset SUDO_COMMAND

# XDIALOG_HIGH_DIALOG_COMPAT=1
# export XDIALOG_HIGH_DIALOG_COMPAT
# XDIALOG_FORCE_AUTOSIZE=1
# export XDIALOG_FORCE_AUTOSIZE

TMP=$(mktemp)

DIALOG="dialog"
# [ -n "$DISPLAY" ] && [ -x /usr/bin/Xdialog ] && DIALOG="Xdialog"

BACKTITLE="GRML NDISWRAPPER TOOL"

# this error is displayed when something is wrong eith the
# inf file
inf_error() {
  $DIALOG --title "$BACKTITLE" --backtitle "ERROR" --msgbox "The selected file is no *.inf file or the *.inf file is invalid, exiting." 12 75;
}


# at first we show the usual disclaimer that the usage of this
# script could simply destroy everything

# dialog doesn't knows --center
if [ "$DIALOG" = "dialog" ]; then
  $DIALOG --title "$BACKTITLE" --backtitle "DISCLAIMER" --msgbox "This is the configuration tool for the ndiswrapper utilities. \n
Be aware that loading a windows driver file for your wlan \n
card using this tool could freeze your system. \n
\n
You need matching driver.inf and driver.sys files residing on \n
a mounted data medium. After the windows drivers have been \n
successfully loaded via the ndiswrapper, you have to configure \n
your wlan settings via iwconfig. Future releases of this script \n
will include this. \n
\n
Please send your feedback to <oehler@knopper.net>" 16 75;
else
  $DIALOG --center --title "$BACKTITLE" --backtitle "DISCLAIMER" --msgbox "This is the configuration tool for the ndiswrapper utilities. \n
Be aware that loading a windows driver file for your \n
wlan card using this tool could freeze your system. \n
\n
You need matching driver.inf and driver.sys files residing on \n
a mounted data medium. After the windows drivers have been \n
successfully loaded via the ndiswrapper, you have to configure \n
your wlan settings via iwconfig. Future releases of this script \n
will include this. \n
\n
Please send your feedback to \n
<oehler@knopper.net>" 12 75;
fi

$DIALOG --title "$BACKTITLE" --backtitle "SELECT <DRIVER>.INF FILE" --fselect "/home/grml" 12 75 2>"$TMP"; read DRIVER_PATH <"$TMP"; rm -f "$TMP";

test -x "/usr/sbin/ndiswrapper" || { echo "NdisWrapper not found, exiting." >&2; exit 1; }
test -x "/sbin/modprobe" || { echo "modprobe not found, exiting." >&2; exit 1; }
test -e $DRIVER_PATH || { echo "$DRIVER_PATH does not exist, exiting." >&2; exit 1; }
case "$DRIVER_PATH" in
  *\.inf*) NUM=`grep -c "sys" "$DRIVER_PATH"`
           if [ "$NUM" -lt 1 ]; then
	     inf_error; exit 1;
	   fi;;
  *) inf_error; exit 1;
esac

# how much lines are in /proc/net/wireless
LINES1=`cat /proc/net/wireless | wc -l`

ndiswrapper -i $DRIVER_PATH
modprobe ndiswrapper
ndiswrapper -m

# have we got a new device?
LINES2=`cat /proc/net/wireless | wc -l`

if [ "$LINES2" -gt "$LINES1" ]; then
  $DIALOG --title "$BACKTITLE" --backtitle "RESULT" --msgbox "The ndiswrapper module has been loaded. You may configure your wlan card with iwconfig now." 12 75 2>"$TMP"; [ "$?" != "0" ] && return 1; rm -f "$TMP";
else
  $DIALOG --title "$BACKTITLE" --backtitle "RESULT" --msgbox "The ndiswrapper module has been loaded but there is no new device. Perhaps NdisWrapper is not working with your driver file." 12 75 2>"$TMP"; [ "$?" != "0" ] && return 1; rm -f "$TMP";
fi

## END OF FILE #################################################################
