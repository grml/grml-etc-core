#!/bin/zsh
# Filename:      hgrep.sh
# Purpose:       highlight grep
# Authors:       Oliver Kiddle (<URL:http://www.zsh.org/mla/workers/2001/msg00390.html>)
# Bug-Reports:   see http://grml.org/bugs/
# License:       This file is licensed under the GPL v2.
# Latest change: Sam Mai 27 15:12:27 CEST 2006 [mika]
################################################################################

if (( ! $# )); then
  echo "Usage: $0:t [-e pattern...] [file...]" >&2
  return 1
fi

local -a regex
local htext=`echotc so` ntext=`echotc se`

while [[ "$1" = -e ]]; do
  regex=( $regex "$2" )
  shift 2
done

if (( ! $#regex )); then
  regex=( "$1" )
  shift
fi

regex=( "-e
s/${^regex[@]}/$htext&$ntext/g" )
sed ${(Ff)regex[@]} "$@"

## END OF FILE #################################################################
