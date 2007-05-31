# Filename:      .zshrc
# Purpose:       config file for zsh
# Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
# Bug-Reports:   see http://grml.org/bugs/
# License:       This file is licensed under the GPL v2.
# Latest change: Don Mai 31 17:19:00 CEST 2007 [mika]
################################################################################

# source ~/.zshrc.global {{{
# see /etc/zsh/zshrc for some general settings
# If you don't have write permissions to /etc/zsh/zshrc on your own
# copy the file to your $HOME as /.zshrc.global and we source it:
  if [ -r ~/.zshrc.global ] ; then
     . ~/.zshrc.global
  fi
# }}}

# check whether global file has been read {{{
  if [ -z "$ZSHRC_GLOBAL_HAS_BEEN_READ" ] ; then
     print 'Warning: global zsh config has not been read'>&2
  fi
# }}}

# autoloading stuff {{{
# associate types and extensions (be aware with perl scripts and anwanted behaviour!)
#  type zsh-mime-setup &>/dev/null || { autoload zsh-mime-setup && zsh-mime-setup }
# }}}

# completion system {{{
# just make sure it is loaded in this file too
  type compinit &>/dev/null || { autoload -U compinit && compinit }
# }}}

# make sure isgrmlsmall is defined {{{
  type isgrmlsmall &>/dev/null || function isgrmlsmall () { return 1 }
# }}}

## variables {{{

# do you want grmlsmall-specific adjustments?
  GRMLSMALL_SPECIFIC=1

# set terminal property (used e.g. by msgid-chooser)
  export COLORTERM="yes"

# set default browser
  if [ -z "$BROWSER" ] ; then
     if [ -n "$DISPLAY" ] ; then
        [ -x $(which firefox) ] && export BROWSER=firefox
     else
        [ -x $(which w3m) ] && export BROWSER=w3m
     fi
  fi
  (( ${+PAGER} ))   || export PAGER="less"

# export qtdir
  [ -d /usr/share/qt3 ] && export QTDIR=/usr/share/qt3
  [ -d /usr/share/qt4 ] && export QTDIR=/usr/share/qt4

# support running 'jikes *.java && jamvm HelloWorld' OOTB:
  [ -f /usr/share/classpath/glibj.zip ] && export JIKESPATH=/usr/share/classpath/glibj.zip
# }}}

## set options {{{

# Allow comments even in interactive shells i. e.
# $ uname # This command prints system informations
# zsh: bad pattern: #
# $ setopt interactivecomments
# $ uname # This command prints system informations
# Linux
#  setopt interactivecomments

# ctrl-s will no longer freeze the terminal.
#  stty erase "^?"

# }}}

# {{{ global aliases
# These do not have to be at the beginning of the command line.
# Avoid typing cd ../../ for going two dirs down and so on
# Usage, e.g.: "$ cd ...' or just '$ ...' with 'setopt auto_cd'
# Notice: deactivated by 061112 by default, we use another approach
# known as "power completion / abbreviation expansion"
#  alias -g '...'='../..'
#  alias -g '....'='../../..'
#  alias -g BG='& exit'
#  alias -g C='|wc -l'
#  alias -g G='|grep'
#  alias -g H='|head'
#  alias -g Hl=' --help |& less -r'
#  alias -g K='|keep'
#  alias -g L='|less'
#  alias -g LL='|& less -r'
#  alias -g M='|most'
#  alias -g N='&>/dev/null'
#  alias -g R='| tr A-z N-za-m'
#  alias -g SL='| sort | less'
#  alias -g S='| sort'
#  alias -g T='|tail'
#  alias -g V='| vim -'
# }}}

## aliases {{{

# Xterm resizing-fu.
# Based on http://svn.kitenet.net/trunk/home-full/.zshrc?rev=11710&view=log (by Joey Hess)
  alias hide='echo -en "\033]50;nil2\007"'
  alias tiny='echo -en "\033]50;-misc-fixed-medium-r-normal-*-*-80-*-*-c-*-iso8859-15\007"'
  alias small='echo -en "\033]50;6x10\007"'
  alias medium='echo -en "\033]50;-misc-fixed-medium-r-normal--13-120-75-75-c-80-iso8859-15\007"'
  alias default='echo -e "\033]50;-misc-fixed-medium-r-normal-*-*-140-*-*-c-*-iso8859-15\007"'
  alias large='echo -en "\033]50;-misc-fixed-medium-r-normal-*-*-150-*-*-c-*-iso8859-15\007"'
  alias huge='echo -en "\033]50;-misc-fixed-medium-r-normal-*-*-210-*-*-c-*-iso8859-15\007"'
  alias smartfont='echo -en "\033]50;-artwiz-smoothansi-*-*-*-*-*-*-*-*-*-*-*-*\007"'
  alias semifont='echo -en "\033]50;-misc-fixed-medium-r-semicondensed-*-*-120-*-*-*-*-iso8859-15\007"'
#  if [ "$TERM" = "xterm" ] && [ "$LINES" -ge 50 ] && [ "$COLUMNS" -ge 100 ] && [ -z "$SSH_CONNECTION" ]; then
#          large
#  fi

# general
  alias da='du -sch'
  alias j='jobs -l'
#  alias u='translate -i'          # translate

# compile stuff
  alias CO="./configure"
  alias CH="./configure --help"

# http://conkeror.mozdev.org/
  alias conkeror='firefox -chrome chrome://conkeror/content'

# arch/tla stuff
  if type -p tla &>/dev/null ; then
     alias tdi='tla what-changed --diffs | less'
     alias tbp='tla-buildpackage'
     alias tmi='tla archive-mirror'
     alias tco='tla commit'
     alias tme='tla star-merge'
  fi

# listing stuff
  alias dir="ls -lSrah"
  alias lad='ls -d .*(/)'                # only show dot-directories
  alias lsa='ls -a .*(.)'                # only show dot-files
  alias lss='ls -l *(s,S,t)'             # only files with setgid/setuid/sticky flag
  alias lsl='ls -l *(@[1,10])'           # only symlinks
  alias lsx='ls -l *(*[1,10])'           # only executables
  alias lsw='ls -ld *(R,W,X.^ND/)'       # world-{readable,writable,executable} files
  alias lsbig="ls -flh *(.OL[1,10])"     # display the biggest files
  alias lsd='ls -d *(/)'                 # only show directories
  alias lse='ls -d *(/^F)'               # only show empty directories
  alias lsnew="ls -rl *(D.om[1,10])"     # display the newest files
  alias lsold="ls -rtlh *(D.om[1,10])"   # display the oldest files
  alias lssmall="ls -Srl *(.oL[1,10])"   # display the smallest files

# chmod
  alias rw-='chmod 600'
  alias rwx='chmod 700'
  alias r--='chmod 644'
  alias r-x='chmod 755'

# some useful aliases
  alias md='mkdir -p'

  [ -x $(which ipython) ] && alias ips='ipython -p sh'

# console stuff
  alias cmplayer='mplayer -vo fbdev'
  alias fbmplayer='mplayer -vo fbdev -fs -zoom'
  alias fblinks='links2 -driver fb'

# ignore ~/.ssh/known_hosts entries
#  alias insecssh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" -o "PreferredAuthentications=keyboard-interactive"'
  alias insecssh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
  alias insecscp='scp -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'

# use colors when browsing man pages (if not using pinfo or PAGER=most)
  [ -d ~/.terminfo/ ] && alias man='TERMINFO=~/.terminfo/ LESS=C TERM=mostlike PAGER=less man'

# check whether Debian's package management (dpkg) is running
  type salias &>/dev/null && salias check_dpkg_running="dpkg_running"

# work around non utf8 capable software in utf environment
  if type isutfenv &>/dev/null ; then
     if [ -x $(which mrxvt) ] ; then
        isutfenv && [ -n "$LANG" ] && alias mrxvt="LANG=${LANG/(#b)(*)[.@]*/$match[1].iso885915} mrxvt"
     fi
   
     if [ -x $(which aterm) ] ; then
        isutfenv && [ -n "$LANG" ] && alias aterm="LANG=${LANG/(#b)(*)[.@]*/$match[1].iso885915} aterm"
     fi
   
     if [ -x $(which centericq) ] ; then
        isutfenv && [ -n "$LANG" ] && alias centericq="LANG=${LANG/(#b)(*)[.@]*/$match[1].iso885915} centericq"
     fi
  fi
# }}}

## useful functions {{{

# functions without detailed explanation:
  agoogle() { ${=BROWSER} "http://groups.google.com/groups?as_uauthors=$*" ; }
  bk()      { cp -b ${1} ${1}_`date --iso-8601=m` }
  cdiff()   { diff -crd "$*" | egrep -v "^Only in |^Binary files " }
  cl()      { cd $1 && ls -a }        # cd && ls
  cvsa()    { cvs add $* && cvs com -m 'initial checkin' $* }
  cvsd()    { cvs diff -N $* |& $PAGER }
  cvsl()    { cvs log $* |& $PAGER }
  cvsq()    { cvs -nq update }
  cvsr()    { rcs2log $* | $PAGER }
  cvss()    { cvs status -v $* }
  debbug()  { ${=BROWSER} "http://bugs.debian.org/$*" }
  debbugm() { bts show --mbox $1 } # provide bugnummer as "$1"
  disassemble(){ gcc -pipe -S -o - -O -g $* | as -aldh -o /dev/null }
  dmoz()    { ${=BROWSER} http://search.dmoz.org/cgi-bin/search\?search=${1// /_} }
  dwicti()  { ${=BROWSER} http://de.wiktionary.org/wiki/${(C)1// /_} }
  ewicti()  { ${=BROWSER} http://en.wiktionary.org/wiki/${(C)1// /_} }
  fir()     { firefox -a firefox -remote "openURL($1)" }
  ggogle()  { ${=BROWSER} "http://groups.google.com/groups?q=$*" }
  google()  { ${=BROWSER} "http://www.google.com/search?&num=100&q=$*" }
  mcd()     { mkdir -p "$@"; cd "$@" } # mkdir && cd
  mdiff()   { diff -udrP "$1" "$2" > diff.`date "+%Y-%m-%d"`."$1" }
  memusage(){ ps aux | awk '{if (NR > 1) print $5; if (NR > 2) print "+"} END { print "p" }' | dc }
  mggogle() { ${=BROWSER} "http://groups.google.com/groups?selm=$*" }
  netcraft(){ ${=BROWSER} "http://toolbar.netcraft.com/site_report?url=$1" }
  oleo()    { ${=BROWSER} "http://dict.leo.org/?search=$*" }
  shtar()   { gunzip -c $1 | tar -tf - -- | $PAGER }
  shtgz()   { tar -ztf $1 | $PAGER }
  shzip()   { unzip -l $1 | $PAGER }
  sig()     { agrep -d '^-- $' "$*" ~/.Signature }
  swiki()   { ${=BROWSER} http://de.wikipedia.org/wiki/Spezial:Search/${(C)1} }
  udiff()   { diff -urd $* | egrep -v "^Only in |^Binary files " }
  viless()  { vim --cmd 'let no_plugin_maps = 1' -c "so \$VIMRUNTIME/macros/less.vim" "${@:--}" }
  wikide () { ${=BROWSER} http://de.wikipedia.org/wiki/"${(C)*}" }
  wikien()  { ${=BROWSER} http://en.wikipedia.org/wiki/"$*" }
  wodeb ()  { ${=BROWSER} "http://packages.debian.org/cgi-bin/search_contents.pl?word=$1&version=${2:-unstable}" }

  which google &>/dev/null && gex () { google "\"[ $1]\" $*" } # exact search at google

  # download video from youtube
  ytdl() {
    if ! [ -n "$2" ] ; then
       print "Usage: ydtl http://youtube.com/watch?v=.... outputfile.flv">&2
       return 1
    else
       wget -O${2} "http://youtube.com/get_video?"${${${"$(wget -o/dev/null -O- "${1}" | grep -e watch_fullscreen)"}##*watch_fullscreen\?}%%\&fs=*}
    fi
  }


# Function Usage: doc packagename
  doc() { cd /usr/share/doc/$1 && ls }
  _doc() { _files -W /usr/share/doc -/ }
  type compdef &>/dev/null && compdef _doc doc

# make screenshot of current desktop (use 'import' from ImageMagic)
  sshot() {
        [[ ! -d ~/shots  ]] && mkdir ~/shots
        #cd ~/shots ; sleep 5 ; import -window root -depth 8 -quality 80 `date "+%Y-%m-%d--%H:%M:%S"`.png
        cd ~/shots ; sleep 5; import -window root shot_`date --iso-8601=m`.jpg
  }

# list images only
  limg() {
    local -a images
    images=( *.{jpg,gif,png}(.N) )
    if [[ $#images -eq 0 ]] ; then
      print "No image files found"
    else
      ls "$@" "$images[@]"
    fi
  }

# create pdf file from source code
  makereadable() {
     output=$1
     shift
     a2ps --medium A4dj -E -o $output $*
     ps2pdf $output
  }

# zsh with perl-regex - use it e.g. via:
# regcheck '\s\d\.\d{3}\.\d{3} Euro' ' 1.000.000 Euro'
  regcheck() {
    zmodload -i zsh/pcre
    pcre_compile $1 && \
    pcre_match $2 && echo "regex matches" || echo "regex does not match"
  }

# list files which have been modified within the last x days
  new() { print -l *(m-$1) }

# grep the history
  greph () { history 0 | grep $1 }
  (grep --help 2>/dev/null |grep -- --color) >/dev/null && \
    alias grep='grep --color=auto' # use colors when GNU grep with color-support
  alias GREP='grep -i --color=auto'

# one blank line between each line
  if [ -r ~/.terminfo/m/mostlike ] ; then
#     alias man2='MANPAGER="sed -e G |less" TERMINFO=~/.terminfo TERM=mostlike /usr/bin/man'
     man2() { PAGER='dash -c "sed G | /usr/bin/less"' TERM=mostlike /usr/bin/man "$@" ; }
  fi

# jump between directories
# Copyright 2005 Nikolai Weibull <nikolai@bitwi.se>
# notice: option AUTO_PUSHD has to be set
  d(){
    emulate -L zsh
    autoload -U colors
    local color=$fg_bold[blue]
    integer i=0
    dirs -p | while read dir; do
      local num="${$(printf "%-4d " $i)/ /.}"
      printf " %s  $color%s$reset_color\n" $num $dir
      (( i++ ))
    done
    integer dir=-1
    read -r 'dir?Jump to directory: ' || return
    (( dir == -1 )) && return
    if (( dir < 0 || dir >= i )); then
      echo d: no such directory stack entry: $dir
      return 1
    fi
    cd ~$dir
  }

# find out which libs define a symbol
# usage example: 'lcheck strcpy'
  lcheck() {
     if [ -n "$1" ] ; then
        nm -go /usr/lib/lib*.a 2>/dev/null | grep ":[[:xdigit:]]\{8\} . .*$1"
      else
        echo "Usage: lcheck <function>" >&2
     fi
  }

# clean up directory
  purge() {
        FILES=(*~(N) .*~(N) \#*\#(N) *.o(N) a.out(N) *.core(N) *.cmo(N) *.cmi(N) .*.swp(N))
        NBFILES=${#FILES}
        if [[ $NBFILES > 0 ]]; then
                print $FILES
                local ans
                echo -n "Remove these files? [y/n] "
                read -q ans
                if [[ $ans == "y" ]]
                then
                        rm ${FILES}
                        echo ">> $PWD purged, $NBFILES files removed"
                else
                        echo "Ok. .. than not.."
                fi
        fi
   }

# Translate DE<=>EN
# 'translate' looks up fot a word in a file with language-to-language
# translations (field separator should be " : "). A typical wordlist looks
# like at follows:
#  | english-word : german-transmission
# It's also only possible to translate english to german but not reciprocal.
# Use the following oneliner to turn back the sort order:
#  $ awk -F ':' '{ print $2" : "$1" "$3 }' \
#    /usr/local/lib/words/en-de.ISO-8859-1.vok > ~/.translate/de-en.ISO-8859-1.vok
  trans() {
        case "$1" in
                -[dD]*) translate -l de-en $2
                ;;
                -[eE]*) translate -l en-de $2
                ;;
                *)
                echo "Usage: $0 { -D | -E }"
                echo "         -D == German to English"
                echo "         -E == English to German"
        esac
  }

# Some quick Perl-hacks aka /useful/ oneliner
#  bew() { perl -le 'print unpack "B*","'$1'"' }
#  web() { perl -le 'print pack "B*","'$1'"' }
#  hew() { perl -le 'print unpack "H*","'$1'"' }
#  weh() { perl -le 'print pack "H*","'$1'"' }
#  pversion()    { perl -M$1 -le "print $1->VERSION" } # i. e."pversion LWP -> 5.79"
#  getlinks ()   { perl -ne 'while ( m/"((www|ftp|http):\/\/.*?)"/gc ) { print $1, "\n"; }' $* }
#  gethrefs ()   { perl -ne 'while ( m/href="([^"]*)"/gc ) { print $1, "\n"; }' $* }
#  getanames ()  { perl -ne 'while ( m/a name="([^"]*)"/gc ) { print $1, "\n"; }' $* }
#  getforms ()   { perl -ne 'while ( m:(\</?(input|form|select|option).*?\>):gic ) { print $1, "\n"; }' $* }
#  getstrings () { perl -ne 'while ( m/"(.*?)"/gc ) { print $1, "\n"; }' $*}
#  getanchors () { perl -ne 'while ( m/«([^«»\n]+)»/gc ) { print $1, "\n"; }' $* }
#  showINC ()    { perl -e 'for (@INC) { printf "%d %s\n", $i++, $_ }' }
#  vimpm ()      { vim `perldoc -l $1 | sed -e 's/pod$/pm/'` }
#  vimhelp ()    { vim -c "help $1" -c on -c "au! VimEnter *" }

# plap foo -- list all occurrences of program in the current PATH
  plap() {
        if [[ $# = 0 ]]
        then
                echo "Usage:    $0 program"
                echo "Example:  $0 zsh"
                echo "Lists all occurrences of program in the current PATH."
        else
                ls -l ${^path}/*$1*(*N)
        fi
  }

# Found in the mailinglistarchive from Zsh (IIRC ~1996)
  selhist() {
        emulate -L zsh
        local TAB=$'\t';
        (( $# < 1 )) && {
                echo "Usage: $0 command"
                return 1
        };
        cmd=(${(f)"$(grep -w $1 $HISTFILE | sort | uniq | pr -tn)"})
        print -l $cmd | less -F
        echo -n "enter number of desired command [1 - $(( ${#cmd[@]} - 1 ))]: "
        local answer
        read answer
        print -z "${cmd[$answer]#*$TAB}"
  }

# Use vim to convert plaintext to HTML
  2html() { vim -u NONE -n -c ':syntax on' -c ':so $VIMRUNTIME/syntax/2html.vim' -c ':wqa' $1 &>/dev/null }

# Usage: simple-extract <file>
# Description: extracts archived files (maybe)
  simple-extract () {
        if [[ -f $1 ]]
        then
                case $1 in
                        *.tar.bz2)  bzip2 -v -d $1      ;;
                        *.tar.gz)   tar -xvzf $1        ;;
                        *.rar)      unrar $1            ;;
                        *.deb)      ar -x $1            ;;
                        *.bz2)      bzip2 -d $1         ;;
                        *.lzh)      lha x $1            ;;
                        *.gz)       gunzip -d $1        ;;
                        *.tar)      tar -xvf $1         ;;
                        *.tgz)      gunzip -d $1        ;;
                        *.tbz2)     tar -jxvf $1        ;;
                        *.zip)      unzip $1            ;;
                        *.Z)        uncompress $1       ;;
                        *)          echo "'$1' Error. Please go away" ;;
                esac
        else
                echo "'$1' is not a valid file"
        fi
  }

# Usage: smartcompress <file> (<type>)
# Description: compresses files or a directory.  Defaults to tar.gz
  smartcompress() {
        if [ $2 ]; then
                case $2 in
                        tgz | tar.gz)   tar -zcvf$1.$2 $1 ;;
                        tbz2 | tar.bz2) tar -jcvf$1.$2 $1 ;;
                        tar.Z)          tar -Zcvf$1.$2 $1 ;;
                        tar)            tar -cvf$1.$2  $1 ;;
                        gz | gzip)      gzip           $1 ;;
                        bz2 | bzip2)    bzip2          $1 ;;
                        *)
                        echo "Error: $2 is not a valid compression type"
                        ;;
                esac
        else
                smartcompress $1 tar.gz
        fi
  }

# Usage: show-archive <archive>
# Description: view archive without unpack
  show-archive() {
        if [[ -f $1 ]]
        then
                case $1 in
                        *.tar.gz)      gunzip -c $1 | tar -tf - -- ;;
                        *.tar)         tar -tf $1 ;;
                        *.tgz)         tar -ztf $1 ;;
                        *.zip)         unzip -l $1 ;;
                        *.bz2)         bzless $1 ;;
                        *)             echo "'$1' Error. Please go away" ;;
                esac
        else
                echo "'$1' is not a valid archive"
        fi
  }

# follow symlinks
  folsym() {
    if [[ -e $1 || -h $1 ]]; then
        file=$1
    else
        file=`which $1`
    fi
    if [[ -e $file || -L $file ]]; then
        if [[ -L $file ]]; then
            echo `ls -ld $file | perl -ane 'print $F[7]'` '->'
            folsym `perl -le '$file = $ARGV[0];
                              $dest = readlink $file;
                              if ($dest !~ m{^/}) {
                                  $file =~ s{(/?)[^/]*$}{$1$dest};
                              } else {
                                  $file = $dest;
                              }
                              $file =~ s{/{2,}}{/}g;
                              while ($file =~ s{[^/]+/\.\./}{}) {
                                  ;
                              }
                              $file =~ s{^(/\.\.)+}{};
                              print $file' $file`
        else
            ls -d $file
        fi
    else
        echo $file
    fi
  }

# Use 'view' to read manpages, if u want colors, regex - search, ...
# like vi(m).
# It's shameless stolen from <http://www.vim.org/tips/tip.php?tip_id=167>
  vman() { man $* | col -b | view -c 'set ft=man nomod nolist' - }

# search for various types or README file in dir and display them in $PAGER
# function readme() { $PAGER -- (#ia3)readme* }
  readme() {
        local files
        files=(./(#i)*(read*me|lue*m(in|)ut)*(ND))
        if (($#files))
        then $PAGER $files
        else
                print 'No README files.'
        fi
  }

# find all suid files in $PATH
# suidfind() { ls -latg $path | grep '^...s' }
  suidfind() { ls -latg $path/*(sN) }

# See above but this is /better/ ... anywise ..
  findsuid() {
    print 'Output will be written to ~/suid_* ...'
    $SUDO find / -type f \( -perm -4000 -o -perm -2000 \) -ls > ~/suid_suidfiles.`date "+%Y-%m-%d"`.out 2>&1
    $SUDO find / -type d \( -perm -4000 -o -perm -2000 \) -ls > ~/suid_suiddirs.`date "+%Y-%m-%d"`.out 2>&1
    $SUDO find / -type f \( -perm -2 -o -perm -20 \) -ls > ~/suid_writefiles.`date "+%Y-%m-%d"`.out 2>&1
    $SUDO find / -type d \( -perm -2 -o -perm -20 \) -ls > ~/suid_writedirs.`date "+%Y-%m-%d"`.out 2>&1
    print 'Finished'
  }

# Reload functions.
  refunc() {
        for func in $argv
        do
                unfunction $func
                autoload $func
        done
  }

# a small check to see which DIR is located on which server/partition.
# stolen and modified from Sven's zshrc.forall
  dirspace() {
    if [ -n "$1" ] ; then
       for dir in $* ; do
          if [ -d "$dir" ] ; then
             ( cd $dir; echo "-<$dir>"; du -shx .; echo);
          else
             echo "warning: $dir does not exist" >&2
          fi
       done
    else
        for dir in $path; do
          if [ -d "$dir" ] ; then
             ( cd $dir; echo "-<$dir>"; du -shx .; echo);
          else
             echo "warning: $dir does not exist" >&2
          fi
        done
    fi
  }

# % slow_print `cat /etc/passwd`
  slow_print() {
        for argument in "${@}"
        do
                for ((i = 1; i <= ${#1} ;i++)) {
                        print -n "${argument[i]}"
                        sleep 0.08
                }
                print -n " "
        done
        print ""
  }

# display system state
  status() {
        print ""
        print "Date..: "$(date "+%Y-%m-%d %H:%M:%S")""
        print "Shell.: Zsh $ZSH_VERSION (PID = $$, $SHLVL nests)"
        print "Term..: $TTY ($TERM), $BAUD bauds, $COLUMNS x $LINES cars"
        print "Login.: $LOGNAME (UID = $EUID) on $HOST"
        print "System: $(cat /etc/[A-Za-z]*[_-][rv]e[lr]*)"
        print "Uptime:$(uptime)"
        print ""
  }

# Rip an audio CD
  audiorip() {
        mkdir -p ~/ripps
        cd ~/ripps
        cdrdao read-cd --device $DEVICE --driver generic-mmc audiocd.toc
        cdrdao read-cddb --device $DEVICE --driver generic-mmc audiocd.toc
        echo " * Would you like to burn the cd now? (yes/no)"
        read input
        if
                [ "$input" = "yes" ]; then
                echo " ! Burning Audio CD"
                audioburn
                echo " * done."
        else
                echo " ! Invalid response."
        fi
  }

# and burn it
  audioburn() {
        cd ~/ripps
        cdrdao write --device $DEVICE --driver generic-mmc audiocd.toc
        echo " * Should I remove the temporary files? (yes/no)"
        read input
        if [ "$input" = "yes" ]; then
                echo " ! Removing Temporary Files."
                cd ~
                rm -rf ~/ripps
                echo " * done."
        else
                echo " ! Invalid response."
        fi
  }

# Make an audio CD from all mp3 files
  mkaudiocd() {
        cd ~/ripps
        for i in *.[Mm][Pp]3; do mv "$i" `echo $i | tr '[A-Z]' '[a-z]'`; done
        for i in *.mp3; do mv "$i" `echo $i | tr ' ' '_'`; done
        for i in *.mp3; do mpg123 -w `basename $i .mp3`.wav $i; done
        normalize -m *.wav
        for i in *.wav; do sox $i.wav -r 44100 $i.wav resample; done
  }

# Create an ISO image. You are prompted for volume name, filename and directory
  mkiso() {
        echo " * Volume name "
        read volume
        echo " * ISO Name (ie. tmp.iso)"
        read iso
        echo " * Directory or File"
        read files
        mkisofs -o ~/$iso -A $volume -allow-multidot -J -R -iso-level 3 -V $volume -R $files
  }

# simple thumbnails generator
  genthumbs () {
    rm -rf thumb-* index.html
    echo "
<html>
  <head>
    <title>Images</title>
  </head>
  <body>" > index.html
    for f in *.(gif|jpeg|jpg|png)
    do
        convert -size 100x200 "$f" -resize 100x200 thumb-"$f"
        echo "    <a href=\"$f\"><img src=\"thumb-$f\"></a>" >> index.html
    done
    echo "
  </body>
</html>" >> index.html
  }

# unset all limits (see zshbuiltins(1) /ulimit for details)
  allulimit() {
    ulimit -c unlimited
    ulimit -d unlimited
    ulimit -f unlimited
    ulimit -l unlimited
    ulimit -n unlimited
    ulimit -s unlimited
    ulimit -t unlimited
  }

# ogg2mp3 with bitrate of 192
  ogg2mp3_192() {
    oggdec -o - ${1} | lame -b 192 - ${1:r}.mp3
  }

# RFC 2396 URL encoding in Z-Shell
  urlencode() {
   setopt localoptions extendedglob
   input=( ${(s::)1} )
   print ${(j::)input/(#b)([^A-Za-z0-9_.!~*\'\(\)-])/%$(([##16]#match))}
  }

# get x-lite voip software
  getxlite() {
    setopt local_options
    setopt errreturn
    [ -d ~/tmp ] || mkdir ~/tmp
    cd ~/tmp
    echo "Downloading http://www.counterpath.com/download/X-Lite_Install.tar.gz and storing it in ~/tmp:"
    if wget http://www.counterpath.com/download/X-Lite_Install.tar.gz ; then
       unp X-Lite_Install.tar.gz && echo done || echo failed
    else
       echo "Error while downloading." ; return 1
    fi
    if [ -x xten-xlite/xtensoftphone ] ; then
       echo "Execute xten-xlite/xtensoftphone to start xlite."
    fi
   }

# get skype
  getskype() {
    setopt local_options
    setopt errreturn
    echo "Downloading debian package of skype."
    echo "Notice: If you want to use a more recent skype version run 'getskypebeta'."
    wget http://www.skype.com/go/getskype-linux-deb
    $SUDO dpkg -i skype_debian-*.deb && echo "skype installed."
  }

# get beta-version of skype
  getskypebeta() {
    setopt local_options
    setopt errreturn
    echo "Downloading debian package of skype (beta version)."
    wget http://www.skype.com/go/getskype-linux-beta-deb
    $SUDO dpkg -i skype-beta*.deb && echo "skype installed."
  }

# get gzimo (VoIP software)
  getgizmo() {
    setopt local_options
    setopt errreturn
    echo "gconf2-common and libgconf2-4 have to be available. Installing therefor."
    $SUDO apt-get update
    $SUDO apt-get install gconf2-common libgconf2-4
    wget $(lynx --dump http://www.gizmoproject.com/download-linux.html | awk '/\.deb/ {print $2" "}' | tr -d '\n')
    $SUDO dpkg -i libsipphoneapi*.deb bonjour_*.deb gizmo-*.deb && echo "gizmo installed."
  }

# get AIR - Automated Image and Restore
  getair() {
    setopt local_options
    setopt errreturn
    [ -w . ] || { echo 'Error: you do not have write permissions in this directory. Exiting.' ; return 1 }
    local VER='1.2.8'
    wget http://puzzle.dl.sourceforge.net/sourceforge/air-imager/air-$VER.tar.gz
    tar zxf air-$VER.tar.gz
    cd air-$VER
    INTERACTIVE=no $SUDO ./install-air-1.2.8
    [ -x /usr/local/bin/air ] && [ -n "$DISPLAY" ] && $SUDO air
  }

# get specific git commitdiff
  git-get-diff() {
    if [ -z $GITTREE ] ; then
      GITTREE='linux/kernel/git/torvalds/linux-2.6.git'
    fi
    if ! [ -z $1 ] ; then
     ${=BROWSER} "http://kernel.org/git/?p=$GITTREE;a=commitdiff;h=$1"
    else
      echo "Usage: git-get-diff <commit>"
    fi
  }

# get specific git commit
  git-get-commit() {
    if [ -z $GITTREE ] ; then
      GITTREE='linux/kernel/git/torvalds/linux-2.6.git'
    fi
    if ! [ -z $1 ] ; then
     ${=BROWSER} "http://kernel.org/git/?p=$GITTREE;a=commit;h=$1"
    else
      echo "Usage: git-get-commit <commit>"
    fi
  }

# get specific git diff
  git-get-plaindiff() {
    if [ -z $GITTREE ] ; then
      GITTREE='linux/kernel/git/torvalds/linux-2.6.git'
    fi
    if ! [ -z $1 ] ; then
      wget "http://kernel.org/git/?p=$GITTREE;a=commitdiff_plain;h=$1" -O $1.diff
    else
      echo 'Usage: git-get-plaindiff '
    fi
  }

# log 'make install' output
# http://strcat.de/blog/index.php?/archives/335-Software-sauber-deinstallieren...html
  mmake() {
    [[ ! -d ~/.errorlogs ]] && mkdir ~/.errorlogs
    =make -n install > ~/.errorlogs/${PWD##*/}-makelog
  }

# indent source code
  smart-indent() {
    indent -npro -kr -i8 -ts8 -sob -l80 -ss -ncs $*
  }

# highlight important stuff in diff output, usage example: hg diff | hidiff
  [ -x $(which histring) ] && \
  alias hidiff="histring -fE '^Comparing files .*|^diff .*' | histring -c yellow -fE '^\-.*' | histring -c green -fE '^\+.*'"

# rename pictures based on information found in exif headers
  exirename() {
    if [ $# -lt 1 ] ; then
       echo 'Usage: jpgrename $FILES' >& 2
       return 1
    else
       echo -n 'Checking for jhead with version newer than 1.9: '
       jhead_version=`jhead -h | grep 'used by most Digital Cameras.  v.*' | awk '{print $6}' | tr -d v`
       if [[ $jhead_version > '1.9' ]]; then
          echo 'success - now running jhead.'
          jhead -n%Y-%m-%d_%Hh%M_%f $*
       else
          echo 'failed - exiting.'
       fi
    fi
  }

# open file in vim and jump to line
# http://www.downgra.de/archives/2007/05/08/T19_21_11/
  j2v() {
    local -a params
    params=(${*//(#m):[0-9]*:/\\n+${MATCH//:/}}) # replace ':23:' to '\n+23'
    params=(${(s|\n|)${(j|\n|)params}}) # join array using '\n', then split on all '\n'
    vim ${params}
  }

# get_ic() - queries imap servers for capabilities; real simple. no imaps
  ic_get() {
    local port
    if [[ ! -z $1 ]]; then
      port=${2:-143}
      print "querying imap server on $1:${port}...\n";
      print "a1 capability\na2 logout\n" | nc $1 ${port}
    else
      print "usage:\n  $0 <imap-server> [port]"
    fi
  }

# creates a Maildir/ with its {new,cur,tmp} subdirs
  mkmaildir() {
    local root subdir
    root=${MAILDIR_ROOT:-${HOME}/Mail}
    if [[ -z ${1} ]] ; then print "Usage\n $0 <dirname>" ; fi
    subdir=${1}
    mkdir -p ${root}/${subdir}/{cur,new,tmp}
  }

# xtrename() rename xterm from within GNU-screen
  xtrename() {
    if [[ -z ${DISPLAY} ]] ; then
      printf 'xtrename only makes sense in X11.\n'
      return 1
    fi
    if [[ -z ${1} ]] ; then
      printf 'usage: xtrename() "title for xterm"\n'
      printf '  renames the title of xterm from _within_ screen.\n'
      printf '  Also works without screen.\n'
      return 0
    fi
    print -n "\eP\e]0;${1}\C-G\e\\"
    return 0
  }

# hl() highlighted less
# http://ft.bewatermyfriend.org/comp/data/zsh/zfunct.html
  if [ -x $(which highlight) ] ; then
    function hl() {
      local theme lang
      theme=${HL_THEME:-""}
      case ${1} in
        (-l|--list)
          ( printf 'available languages (syntax parameter):\n\n' ;
            highlight --list-langs ; ) | less -SMr
          ;;
        (-t|--themes)
          ( printf 'available themes (style parameter):\n\n' ;
            highlight --list-themes ; ) | less -SMr
          ;;
        (-h|--help)
          printf 'usage: hl <syntax[:theme]> <file>\n'
          printf '    available options: --list (-l), --themes (-t), --help (-h)\n\n'
          printf '  Example: hl c main.c\n'
          ;;
        (*)
          if [[ -z ${2} ]] || (( ${#argv} > 2 )) ; then
            printf 'usage: hl <syntax[:theme]> <file>\n'
            printf '    available options: --list (-l), --themes (-t), --help (-h)\n'
            (( ${#argv} > 2 )) && printf '  Too many arguments.\n'
            return 1
          fi
          lang=${1%:*}
          [[ ${1} == *:* ]] && [[ -n ${1#*:} ]] && theme=${1#*:}
          if [[ -n ${theme} ]] ; then
            highlight --xterm256 --syntax ${lang} --style ${theme} ${2} | less -SMr
          else
            highlight --ansi --syntax ${lang} ${2} | less -SMr
          fi
          ;;
      esac
      return 0
    }
    # ... and a proper completion for hl()
    # needs 'highlight' as well, so it fits fine in here.
    function _hl_genarg()  {
      local expl
      if [[ -prefix 1 *: ]] ; then
        local themes
        themes=(${${${(f)"$(LC_ALL=C highlight --list-themes)"}/ #/}:#*(Installed|Use name)*})
        compset -P 1 '*:'
        _wanted -C list themes expl theme compadd ${themes}
      else
        local langs
        langs=(${${${(f)"$(LC_ALL=C highlight --list-langs)"}/ #/}:#*(Installed|Use name)*})
        _wanted -C list languages expl languages compadd -S ':' -q ${langs}
      fi
    }
    function _hl_complete() {
      _arguments -s '1: :_hl_genarg' '2:files:_path_files'
    }
    compdef _hl_complete hl
  fi

# create small urls via tinyurl.com using wget, grep and sed
  zurl() {
  [[ -z ${1} ]] && print "please give an url to shrink." && return 1
  local url=${1}
  local tiny="http://tinyurl.com/create.php?url="
  #print "${tiny}${url}" ; return
  wget  -O-             \
        -o/dev/null     \
        "${tiny}${url}" \
    | grep -Eio 'value="(http://tinyurl.com/.*)"' \
    | sed 's/value=//;s/"//g'
}

# change fluxbox keys from 'Alt-#' to 'Alt-F#' and vice versa
  fluxkey-change() {
    [ -n "$FLUXKEYS" ] || local FLUXKEYS="$HOME/.fluxbox/keys"
    if ! [ -r "$FLUXKEYS" ] ; then
       echo "Sorry, \$FLUXKEYS file $FLUXKEYS could not be read - nothing to be done."
       return 1
    else
       if grep -q 'Mod1 F[0-9] :Workspace [0-9]' $FLUXKEYS ; then
          echo -n 'Switching to Alt-# mode in ~/.fluxbox/keys: '
          sed -i -e 's|^\(Mod[0-9]\+[: space :]\+\)F\([0-9]\+[: space :]\+:Workspace.*\)|\1\2|' $FLUXKEYS && echo done || echo failed
       elif grep -q 'Mod1 [0-9] :Workspace [0-9]' $FLUXKEYS ; then
          echo -n 'Switching to Alt-F# mode in ~/.fluxbox/keys: '
          sed -i -e 's|^\(Mod[0-9]\+[: space :]\+\)\([0-9]\+[: space :]\+:Workspace.*\)|\1F\2|' $FLUXKEYS && echo done || echo failed
       else
          echo 'Sorry, do not know what to do.'
          return 1
       fi
    fi
  }

# }}}

# mercurial related stuff {{{
  if type -p hg &>/dev/null ; then
  # gnu like diff for mercurial
  # http://www.selenic.com/mercurial/wiki/index.cgi/TipsAndTricks
    hgdi() {
      for i in `hg status -marn "$@"` ; diff -ubwd <(hg cat "$i") "$i"
    }

  # build debian package
    alias hbp='hg-buildpackage'

  # execute commands on the versioned patch-queue from the current repos
    alias mq='hg -R $(readlink -f $(hg root)/.hg/patches)'

  # diffstat for specific version of a mercurial repository
  #   hgstat      => display diffstat between last revision and tip
  #   hgstat 1234 => display diffstat between revision 1234 and tip
    hgstat() {
      [ -n "$1" ] && hg diff -r $1 -r tip | diffstat || hg export tip | diffstat
    }

  # get current mercurial tip via hg itself
    gethgclone() {
      setopt local_options
      setopt errreturn
      if [ -f mercurial-tree/.hg ] ; then
        cd mercurial-tree
        echo "Running hg pull for retreiving latest version..."
        hg pull
        echo "Finished update. Building mercurial"
        make local
        echo "Setting \$PATH to $PWD:\$PATH..."
        export PATH="$PWD:$PATH"
      else
        echo "Downloading mercurial via hg"
        hg clone http://selenic.com/repo/hg mercurial-tree
        cd mercurial-tree
        echo "Building mercurial"
        make local
        echo "Setting \$PATH to $PWD:\$PATH..."
        export PATH="$PWD:$PATH"
        echo "make sure you set it permanent via ~/.zshrc if you plan to use it permanently."
        # echo "Setting \$PYTHONPATH to PYTHONPATH=\${HOME}/lib/python,"
        # export PYTHONPATH=${HOME}/lib/python
      fi
    }

  fi # end of check whether we have the 'hg'-executable

  # get current mercurial snapshot
    gethgsnap() {
      setopt local_options
      setopt errreturn
      if [ -f mercurial-snapshot.tar.gz ] ; then
         echo "mercurial-snapshot.tar.gz exists already, skipping download."
      else
        echo "Downloading mercurial snapshot"
        wget http://www.selenic.com/mercurial/mercurial-snapshot.tar.gz
      fi
      echo "Unpacking mercurial-snapshot.tar.gz"
      tar zxf mercurial-snapshot.tar.gz
      cd mercurial-snapshot/
      echo "Installing required build-dependencies"
      $SUDO apt-get update
      $SUDO apt-get install python2.4-dev
      echo "Building mercurial"
      make local
      echo "Setting \$PATH to $PWD:\$PATH..."
      export PATH="$PWD:$PATH"
      echo "make sure you set it permanent via ~/.zshrc if you plan to use it permanently."
    }
# }}}

# some useful commands often hard to remember - let's grep for them {{{

# Work around ion/xterm resize bug.
#if [ "$SHLVL" = 1 ]; then
#       if [ -x $(which resize) ]; then
#               eval `resize </dev/null`
#       fi
#fi

# enable jackd:
#  /usr/bin/jackd -dalsa -dhw:0 -r48000 -p1024 -n2
# now play audio file:
#  alsaplayer -o jack foobar.mp3

# send files via netcat
# on sending side:
#  send() {j=$*; tar cpz ${j/%${!#}/}|nc -w 1 ${!#} 51330;}
#  send dir* $HOST
#  alias receive='nc -vlp 51330 | tar xzvp'

# debian stuff:
# dh_make -e foo@localhost -f $1
# dpkg-buildpackage -rfakeroot
# lintian *.deb
# dpkg-scanpackages ./ /dev/null | gzip > Packages.gz
# dpkg-scansources . | gzip > Sources.gz
# grep-dctrl --field Maintainer $* /var/lib/apt/lists/*

# other stuff:
# convert -geometry 200x200 -interlace LINE -verbose
# ldapsearch -x -b "OU=Bedienstete,O=tug" -h ldap.tugraz.at sn=$1
# ps -ao user,pcpu,start,command
# gpg --keyserver blackhole.pca.dfn.de --recv-keys
# xterm -bg black -fg yellow -fn -misc-fixed-medium-r-normal--14-140-75-75-c-90-iso8859-15 -ah
# nc -vz $1 1-1024   # portscan via netcat
# wget --mirror --no-parent --convert-links
# pal -d `date +%d`
# autoload -U tetris; zle -N tetris; bindkey '...' ; echo "press ... for playing tennis"
#
# modify console cursor
# see http://www.tldp.org/HOWTO/Framebuffer-HOWTO-5.html
# print $'\e[?96;0;64c'
# }}}

# finally source a local zshrc and grmlsmall-specific configuration {{{

# The following file is used to remove zsh-config-items that do not work
# in grml-small by default.
# If you do not want these adjustments (for whatever reason),
# there are three ways to accomplish that:
#  a) at the beginning of this file (variables section), set
#     $GRMLSMALL_SPECIFIC to 0 or comment out the variable definition.
#  b) remove/rename .zshrc.grmlsmall
#  c) comment out the following line
  (( GRMLSMALL_SPECIFIC > 0 )) && isgrmlsmall && source ~/.zshrc.grmlsmall

# this allows us to stay in sync with /etc/skel/.zshrc
# through 'ln -s /etc/skel/.zshrc ~/.zshrc' and put own
# modifications in ~/.zshrc.local
  if [ -r ~/.zshrc.local ] ; then
     . ~/.zshrc.local
  fi
# }}}

## END OF FILE #################################################################
# vim:foldmethod=marker
