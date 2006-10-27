#!/bin/sh
# Filename:      cpu-screen
# Purpose:       script for use inside GNU screen
# Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
# Bug-Reports:   see http://grml.org/bugs/
# License:       This file is licensed under the GPL v2.
# Latest change: Mit Apr 20 00:06:21 CEST 2005 [mika]
################################################################################

if [ -r /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq ] ; then
  TMP=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq` && \
  CUR="`echo "scale=0; $TMP/1000" | bc -l` / "
else
  [ -z "$CUR" ] && CUR=''
fi

if ! [ -d /proc ] ; then
  echo "no /proc" && exit
else
  if [ -r /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq ] ; then
    TMP=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq` && \
    MHZ=`echo "scale=0; $TMP/1000" | bc -l`
  else
    MHZ=$(grep 'cpu MHz' /proc/cpuinfo | sed 's/.*: // ; s/\..*//')
  fi
  MULT=$(echo "$MHZ" | wc -l)
  if [ $MULT -gt 1 ] ; then
    RESULT=$(echo "$MHZ" | head -1)
    echo "$CUR${RESULT}*${MULT}"
  else
    echo "$CUR$MHZ"
  fi
fi

## END OF FILE #################################################################
