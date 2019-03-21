# Filename:      zshenv
# Purpose:       system-wide .zshenv file for zsh(1)
# Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
# Bug-Reports:   see http://grml.org/bugs/
# License:       This file is licensed under the GPL v2.
################################################################################
# This file is sourced on all invocations of the shell.
# It is the 1st file zsh reads; it's read for every shell,
# even if started with -f (setopt NO_RCS), all other
# initialization files are skipped.
#
# This file should contain commands to set the command
# search path, plus other important environment variables.
# This file should not contain commands that produce
# output or assume the shell is attached to a tty.
#
# Notice: .zshenv is the same, execpt that it's not read
# if zsh is started with -f
#
# Global Order: zshenv, zprofile, zshrc, zlogin
################################################################################

# language settings (read in /etc/environment before /etc/default/locale as
# the latter one is the default on Debian nowadays)
# no xsource() here because it's only created in zshrc! (which is good)
[[ -r /etc/environment ]] && source /etc/environment

# set environment variables (important for autologin on tty)
export HOSTNAME=${HOSTNAME:-$(hostname)}

# make sure /usr/bin/id is available
if [[ -x /usr/bin/id ]] ; then
    [[ -z "$USER" ]]          && export USER=$(/usr/bin/id -un)
    [[ $LOGNAME == LOGIN ]] && LOGNAME=$(/usr/bin/id -un)
fi

# workaround for live-cd mode as $HOME is not set via rungetty
if [[ -f /etc/grml_cd ]] ; then
    if (( EUID == 0 )); then
        export HOME=/root
    else
        export HOME=/home/$USER
    fi
fi

## set $PATH
# gentoo users have to source /etc/profile.env
if [[ -r /etc/gentoo-release ]] ; then
    [[ -r /etc/profile.env ]] && source /etc/profile.env
fi

# support extra scripts/software in special directory outside of squashfs environment in live mode
if [[ -f /etc/grml_cd ]] ; then
  [[ -r /run/live/medium/scripts ]] && ADDONS='/run/live/medium/scripts'
  [[ -r /etc/grml/my_path ]] && ADDONS="$(cat /etc/grml/my_path)"
fi

# Solaris
case $(uname 2>/dev/null) in
  SunOS)
    path=(
      /usr/bin
      /usr/sbin
      /usr/ccs/bin
      /opt/SUNWspro/bin
      /usr/ucb
      /usr/sfw/bin
      /usr/gnu/bin
      /usr/openwin/bin
      /opt/csw/bin
      /sbin
      ~/bin
    )
esac

# generic $PATH handling
if (( EUID != 0 )); then
  path=(
    $HOME/bin
    /usr/local/bin
    /usr/bin
    /bin
    /usr/local/sbin
    /usr/sbin
    /sbin
    /usr/local/games
    /usr/games
    "${ADDONS}"
    "${path[@]}"
  )
else
  path=(
    $HOME/bin
    /usr/local/sbin
    /usr/local/bin
    /sbin
    /bin
    /usr/sbin
    /usr/bin
    "${ADDONS}"
    "${path[@]}"
  )
fi

# remove empty components to avoid '::' ending up + resulting in './' being in $PATH
path=( "${path[@]:#}" )

typeset -U path

# less (:=pager) options:
#  export LESS=C
typeset -a lp; lp=( ${^path}/lesspipe(N) )
if (( $#lp > 0 )) && [[ -x $lp[1] ]] ; then
    export LESSOPEN="|lesspipe %s"
elif [[ -x /usr/bin/lesspipe.sh ]] ; then
    export LESSOPEN="|lesspipe.sh %s"
fi
unset lp

export READNULLCMD=${PAGER:-/usr/bin/pager}

# allow zeroconf for distcc
export DISTCC_HOSTS="+zeroconf"

# MAKEDEV should be usable on udev as well by default:
export WRITE_ON_UDEV=yes

## END OF FILE #################################################################
# vim:filetype=zsh foldmethod=marker autoindent expandtab shiftwidth=4
