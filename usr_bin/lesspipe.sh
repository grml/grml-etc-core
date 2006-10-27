#!/bin/bash
# lesspipe.sh, a preprocessor for less (version 1.53)
#===============================================================================
### THIS FILE IS GENERATED FROM lesspipe.sh.in, PLEASE GET THE TAR FILE
### ftp://ftp.ifh.de/pub/unix/utility/lesspipe.tar.gz
### AND RUN configure TO GENERATE A lesspipe.sh THAT WORKS IN YOUR ENVIRONMENT
#===============================================================================
#
# Usage:   lesspipe.sh is called when the environment variable LESSOPEN is set:
#	   LESSOPEN="|lesspipe.sh %s"; export LESSOPEN	(sh like shells)
#	   setenv LESSOPEN "|lesspipe.sh %s"		(csh, tcsh)
#	   Use the fully qualified path if lesspipe.sh is not in the search path
#	   View files in multifile archives:
#			less archive_file:contained_file
#	   This can be used to extract ASCII files from a multifile archive:
#			less archive_file:contained_file>extracted_file
#          As less is not good for extracting binary data use instead:
#			lesspipe.sh archive_file:contained_file>extracted_file
#          Even a file in a multifile archive that itself is contained in yet
#          another archive can be viewed this way:
#			less super_archive:archive_file:contained_file
#	   Display the last file in the file1:..:fileN chain in raw format:
#	   Suppress input filtering:	less file1:..:fileN:   (append a colon)
#	   Suppress decompression:	less file1:..:fileN::  (append 2 colons)
# Required programs:
#	   see the separate file README
# Supported formats:
#	   gzip, compress, bzip2, zip, rar, tar, nroff, ar archive, pdf, ps,
#	   dvi, shared library, executable, directory, RPM, Microsoft Word,
#	   Openoffice 1.x and OASIS (Opendocument) formats, Debian, mp3 files,
#	   image formats (png, gif, jpeg, tiff, ...), utf-16 text,
#	   iso images and filesystems on removable media via /dev/xxx
#
# License: GPL (see file LICENSE)
#
# History: see separate file ChangeLog or
# 	   http://www.desy.de/zeuthen/~friebel/unix/lesspipe.html
#
# Author:  Wolfgang Friebel DESY Zeuthen (Wolfgang.Friebel AT desy.de)
#
#===============================================================================
#setopt KSH_ARRAYS SH_WORD_SPLIT
tarcmd=gtar
if [[ `tar --version 2>&1` = *GNU* ]]; then
  tarcmd=tar
fi
filecmd='file -L -s';
sep=:						# file name separator
altsep==					# alternate separator character
if [[ -f "$1" && "$1" = *$sep* || "$1" = *$altsep ]]; then
  sep=$altsep
fi
tmp=/tmp/.lesspipe.$$				# temp file name
trap 'rm -f $tmp $tmp.dvi $tmp. $tmp.. $tmp... $tmp.1' 0
trap - PIPE

show () {
#  if [[ "$1" = *.pod || "$1" = *.pm ]]; then
#    pod=1
#  fi
  file1="${1%%$sep*}"
  rest1="${1#$file1}"
  while [[ "$rest1" = ::* ]]; do
    if [[ "$rest1" = "::" ]]; then
      break
    else
      rest1="${rest1#$sep$sep}"
      file1="${rest1%%$sep*}"
      rest1="${rest1#$file1}"
      file1="${1%$rest1}"
    fi
  done
  rest11="${rest1#$sep}"
  file2="${rest11%%$sep*}"
  rest2="${rest11#$file2}"
  while [[ "$rest2" = ::* ]]; do
    if [[ "$rest2" = "::" ]]; then
      break
    else
      rest2="${rest2#$sep$sep}"
      file2="${rest2%%$sep*}"
      rest2="${rest2#$file2}"
      file2="${rest11%$rest2}"
    fi
  done
  if [[ "$file2" != "" ]]; then
    in_file="-i$file2"
  fi
  rest2="${rest11#$file2}"
  rest11="$rest1"
  if [[ "$cmd" = "" ]]; then
    type=`$filecmd "$file1" | cut -d : -f 2-`
    if [[ ! -f "$file1" ]]; then
      if [[ "$type" = *directory* ]]; then
	if [[ "$file1" = *.pkg ]]; then
	  if [[ -f "$file1/Contents/Archive.bom" ]]; then
	    type="bill of materials"
	    file1="$file1/Contents/Archive.bom"
	    echo "==> This is a Mac OS X archive directory, showing its contents (bom file)"
	  fi
	fi
      fi
    fi
    get_cmd "$type" "$file1" "$rest1"
    if [[ "$cmd" != "" ]]; then
      show "-$rest1"
    else
      isfinal "$type" "$file1" "$rest11"
    fi
  elif [[ "$c1" = "" ]]; then
    c1[0]=${cmd[0]};c1[1]=${cmd[1]};c1[2]=${cmd[2]}
    if [[ "${cmd[3]}" != "" ]]; then
      c1[3]=${cmd[3]};
    fi
    type=`"${c1[@]}" | dd bs=40000 count=1 2>/dev/null | filepipe | cut -d : -f 2-`
    get_cmd "$type" "$file1" "$rest1"
    if [[ "$cmd" != "" ]]; then
      show "-$rest1"
    else
      "${c1[@]}" | isfinal "$type" - "$rest11"
    fi
  elif [[ "$c2" = "" ]]; then
    c2[0]=${cmd[0]};c2[1]=${cmd[1]};c2[2]=${cmd[2]}
    if [[ "${cmd[3]}" != "" ]]; then
      c2[3]=${cmd[3]};
    fi
    type=`"${c1[@]}" | "${c2[@]}" | dd bs=40000 count=1 2>/dev/null | filepipe | cut -d : -f 2-`
    get_cmd "$type" "$file1" "$rest1"
    if [[ "$cmd" != "" ]]; then
      show "-$rest1"
    else
      "${c1[@]}" | "${c2[@]}" | isfinal "$type" - "$rest11"
    fi
  elif [[ "$c3" = "" ]]; then
    c3[0]=${cmd[0]};c3[1]=${cmd[1]};c3[2]=${cmd[2]}
    if [[ "${cmd[3]}" != "" ]]; then
      c3[3]=${cmd[3]};
    fi
    type=`"${c1[@]}" | "${c2[@]}" | "${c3[@]}" | dd bs=40000 count=1 2>/dev/null | filepipe | cut -d : -f 2-`
    get_cmd "$type" "$file1" "$rest1"
    if [[ "$cmd" != "" ]]; then
      show "-$rest1"
    else
      "${c1[@]}" | "${c2[@]}" | "${c3[@]}" | isfinal "$type" - "$rest11"
    fi
  elif [[ "$c4" = "" ]]; then
    c4[0]=${cmd[0]};c4[1]=${cmd[1]};c4[2]=${cmd[2]}
    if [[ "${cmd[3]}" != "" ]]; then
      c4[3]=${cmd[3]};
    fi
    type=`"${c1[@]}" | "${c2[@]}" | "${c3[@]}" | "${c4[@]}" | dd bs=40000 count=1 2>/dev/null | filepipe | cut -d : -f 2-`
    get_cmd "$type" "$file1" "$rest1"
    if [[ "$cmd" != "" ]]; then
      show "-$rest1"
    else
      "${c1[@]}" | "${c2[@]}" | "${c3[@]}" | "${c4[@]}" | isfinal "$type" - "$rest11"
    fi
  elif [[ "$c5" = "" ]]; then
    c5[0]=${cmd[0]};c5[1]=${cmd[1]};c5[2]=${cmd[2]}
    if [[ "${cmd[3]}" != "" ]]; then
      c5[3]=${cmd[3]};
    fi
    type=`"${c1[@]}" | "${c2[@]}" | "${c3[@]}" | "${c4[@]}" | "${c5[@]}" | dd bs=40000 count=1 2>/dev/null | filepipe | cut -d : -f 2-`
    get_cmd "$type" "$file1" "$rest1"
    if [[ "$cmd" != "" ]]; then
      echo "$0: Too many levels of encapsulation"
    else
      "${c1[@]}" | "${c2[@]}" | "${c3[@]}" | "${c4[@]}" | "${c5[@]}" | isfinal "$type" - "$rest11"
    fi
  fi
}

get_cmd () {
  cmd=
  if [[ "$2" = /*\ * ]]; then
    ln -s "$2" $tmp..
    set "$1" $tmp..
  elif [[ "$2" = *\ * ]]; then
    ln -s "$PWD"/"$2" $tmp..
    set "$1" $tmp..
  fi

  if [[ "$1" = *bzip*compress* || "$1" = *compress[\'e]d\ * || "$1" = *packed\ data* ]]; then
    if [[ "$3" = $sep$sep ]]; then
      return
    elif [[ "$1" = *bzip*compress* ]]; then
      cmd=(bzip2 -cd "$2")
    else
      cmd=(gzip -cd "$2")
    fi
    return
  fi
    
  rest1="$rest2"
  if [[ "$file2" != "" ]]; then
    if [[ "$1" = *\ tar* ]]; then
      cmd=($tarcmd Oxf "$2" "$file2")
    elif [[ "$1" = *Debian* ]]; then
      istemp "ar p" "$2" data.tar.gz | gzip -dc - > $tmp.
      cmd=($tarcmd Oxf $tmp. "$file2")
    elif [[ "$1" = *RPM* ]]; then
      cmd=(isrpm "$2" "$file2")
    elif [[ "$1" = *Zip* ]]; then
      cmd=(istemp "unzip -avp" "$2" "$file2")
    elif [[ "$1" = *\ RAR\ archive* ]]; then
      cmd=(istemp "unrar p -inul" "$2" "$file2")
    elif [[ "$1" = *\ 7-zip\ archive* ]]; then
      if [[ "$2" = - ]]; then
        cmd=(iscmd2 "7za e -so" - "$file2")
      else
        cmd=(iscmd "7za e -so" "$2" "$file2")
      fi
    elif [[ "$1" = *[Cc]abinet* ]]; then
      cmd=(iscab "$2" "$file2")
    elif [[ "$1" = *\ ar\ archive* ]]; then
      cmd=(istemp "ar p" "$2" "$file2")
    elif [[ "$1" = *x86\ boot\ sector* ]]; then
      cmd=(isfloppy "$2" "$file2")
    elif [[ "$1" = *ISO\ 9660* ]]; then
      cmd=(isoinfo "-i$2" "-x$file2")
    fi
  else
    if [[ "$1" = *\ 7-zip\ archive* ]]; then
      if [[ "$2" != - ]]; then
        if [[ `7za l "$2" | tail -1` = *\ 1\ file ]]; then
          cmd=("7za e -so" "$2")
        fi
      fi
    fi
  fi
}

filepipe () {
  rm -f $tmp...
  cat > $tmp...
  $filecmd $tmp...
}

iscab () {
  if [[ "$1" = - ]]; then
    rm -f $tmp
    cat > $tmp
    set $tmp "$2"
  fi
  cabextract -pF "$2" "$1"
}

isdvi () {
  if [[ "$1" = - ]]; then
    set $1 ""
  fi
  if [[ "$1" != *.dvi ]]; then
    rm -f $tmp.dvi
    cat $1 > $tmp.dvi
    set $tmp.dvi "$1"
  fi
  dvi2tty "$1"
}

iscmd () {
  $1 "$2" "$3" 2>/dev/null
}

iscmd2 () {
  cat > $tmp.
  $1 $tmp. "$3" 2>/dev/null
}

istemp () {
  if [[ "$2" = - ]]; then
    rm -f $tmp
    cat > $tmp
    set $1 $tmp "$3"
  fi
  $1 "$2" "$3"
}

isrpm () {
  if [[ "$1" = - ]]; then
    rm -f $tmp
    cat > $tmp
    set $tmp "$2"
  fi
  echo $tmp.1 > $tmp.
# GNU cpio has an undocumented but most useful --rename-batch-file switch
  rm -f $tmp.1
  rpm2cpio "$1"|cpio -i --quiet --rename-batch-file $tmp. "${2##/}"
  cat $tmp.1
}


isfloppy () {
# get the device to drive mapping
  mtoolstest |
  while read i1 i2
  do
    if [[ "$i1" = *$1* ]]; then
      if [[ "$2" = "" ]]; then
	mdir $drive
      else
	mtype $drive"$2"
      fi
      return
    elif [[ "$i1" = drive ]]; then
      drive=$i2
    fi
  done
}


isfinal() {

  if [[ "$3" = $sep$sep ]]; then
    cat "$2"
    return
  elif [[ "$3" = $sep* ]]; then
    if [[ "$3" = $sep ]]; then
      echo "==> append :. or :<filetype> to activate syntax highlighting"
    else
      lang=${3#$sep}
      lang="-l ${lang#.}"
      lang=${lang%%-l }
      dir=${LESSOPEN#\|}
      dir=${dir%%lesspipe.sh*\%s}
      ${dir}code2color $PPID ${in_file:+"$in_file"} $lang "$2"
      if [[ $? = 0 ]]; then
        return
      fi
    fi
    cat "$2"
    return
  elif [[ "$2" = - ]]; then
    case "$1" in 
    *RPM*|*\ ar\ archive*|*shared*|*Zip*|*\ RAR\ archive*)
      cat > $tmp.dvi
      set "$1" $tmp.dvi
    esac
  fi
  if [[ "$1" = *No\ such* ]]; then
    return
  elif [[ "$1" = *directory* ]]; then
    echo "==> This is a directory, showing the output of ls -lAL"
    ls -lAL "$2"
  elif [[ "$1" = *\ tar* ]]; then
    echo "==> use tar_file${sep}contained_file to view a file in the archive"
    $tarcmd tvf "$2"
  elif [[ "$1" = *RPM* ]]; then
    echo "==> use RPM_file${sep}contained_file to view a file in the RPM"
    rpm -qivp "$2"
    echo "================================= Content ======================================"
    rpm2cpio "$2"|cpio -i -tv --quiet
  elif [[ "$1" = *roff* ]]; then
    DEV=latin1
    if [[ "$LANG" = ja* ]]; then
      DEV=nippon
    fi
    MACRO=andoc
    if [[ "$2" = *.me ]]; then
      MACRO=e
    elif [[ "$2" = *.ms ]]; then
      MACRO=s
    fi
    echo "==> append $sep to filename to view the nroff source"
    groff -s -p -t -e -T$DEV -m$MACRO "$2"
  elif [[ "$1" = *Debian* ]]; then
    echo "==> use Deb_file${sep}contained_file to view a file in the Deb"
    dpkg -I "${2#-}"
    istemp "ar p" "$2" data.tar.gz | gzip -dc - | $tarcmd tvf -
#  elif [[ "$1" = *perl\ *script\ text* || "$pod" = 1 ]]; then
#      pod2text "$2" > $tmp.dvi
#      if [[ -s $tmp.dvi ]]; then
#	echo "==> append $sep to filename to view the Perl source"
#	cat $tmp.dvi
#      fi
  elif [[ "$1" = *\ script* ]]; then
    set "plain text" "$2"
  elif [[ "$1" = *text\ executable* ]]; then
    set "plain text" "$2"
  elif [[ "$1" = *PostScript* ]]; then
    echo "==> append $sep to filename to view the postscript file"
    which pstotext >/dev/null 2>&1
    if [[ $? = 0 ]]; then
      pstotext "${2#-}"
    else
      ps2ascii "$2"
    fi
  elif [[ "$1" = *executable* ]]; then
    echo "==> append $sep to filename to view the binary file"
    if [[ "$2" = "-" ]]; then
      strings
    else
      strings "$2"
    fi
  elif [[ "$1" = *\ ar\ archive* ]]; then
    echo "==> use library${sep}contained_file to view a file in the archive"
    ar vt "$2"
  elif [[ "$1" = *shared* ]]; then
    echo "==> This is a dynamic library, showing the output of nm"
    nm "$2"
  elif [[ "$1" = *Zip* ]]; then
    echo "==> use zip_file${sep}contained_file to view a file in the archive"
    unzip -lv "$2"
  elif [[ "$1" = *\ RAR\ archive* ]]; then
    echo "==> use rar_file${sep}contained_file to view a file in the archive"
    unrar v "$2"
  elif [[ "$1" = *\ 7-zip\ archive* ]]; then
    echo "==> use 7-zip_file${sep}contained_file to view a file in the archive"
    if [[ "$2" = - ]]; then
      istemp "7za l" -
    else
      7za l "$2"
    fi
  elif [[ "$1" = *[Cc]abinet* ]]; then
    echo "==> use cab_file${sep}contained_file to view a file in the cabinet"
    cabextract -l "$2"
  elif [[ "$1" = *x86\ boot\ sector* ]]; then
    echo "==> use $2${sep}contained_file to view a file on the floppy"
    isfloppy "$2"
  elif [[ "$1" = *\ DVI* ]]; then
    echo "==> append $sep to filename to view the binary DVI file"
    isdvi "$2"
  elif [[ "$1" = *HTML* ]]; then
    echo "==> append $sep to filename to view the HTML source"
    html2text -style pretty "$2"
  elif [[ "$1" = *PDF* ]]; then
    echo "==> append $sep to filename to view the PDF source"
    istemp pdftotext "$2" -
  elif [[ "$1" = *Microsoft\ Word* || "$1" = *Microsoft\ Office* ]]; then
    antiword "$2"
  elif [[ "$1" = *Rich\ Text\ Format* ]]; then
    echo "==> append $sep to filename to view the RTF source"
    unrtf --html "$2" 2>/dev/null | html2text -style pretty
  elif [[ "$1" = *OpenDocument\ [CHMPST]* || "$1" = *OpenOffice\.org\ 1\.x\ [CIWdgpst]* ]]; then
    conv="utf8tolatin1"
    if [[ "$LANG" = *UTF-8 ]]; then
      conv="cat"
    fi
    echo "==> append $sep to filename to view the OpenOffice or OpenDocument source"
    istemp "unzip -avp" "$2" content.xml | o3tohtml | $conv | html2text -style pretty
  elif [[ "$1" = *ISO\ 9660* ]]; then
    if [[ "$2" != - ]]; then
      isoinfo -d -i "$2"
      joliet=`isoinfo -d -i "$2" | egrep '^Joliet'|cut -c1`
      echo "================================= Content ======================================"
      isoinfo -lR$joliet -i "$2"
    fi
  elif [[ "$1" = *image\ data*  || "$1" = *image\ text* || "$1" = *JPEG\ file* || "$1" = *JPG\ file* ]]; then
    identify -verbose "$2"
##ifdef jpeg2ascii,convert
## get jpeg2ascii (CVS) from http://dyne.org/cgi-bin/cvsweb.cgi/jpeg2ascii/
# very experimental attempt to display images using ASCII art (do not use)
#  elif [[ "$1" = *image\ data*  || "$1" = *image\ text* || "$1" = *JPEG\ file* || "$1" = *JPG\ file* ]]; then
#    convert -colorspace gray -geometry 100%x50% -contrast -geometry 320x1024 "$2" /tmp/.lesspipe1$$.jpg
#    jpeg2ascii < /tmp/.lesspipe$$.jpg 2> /dev/null
#    rm  /tmp/.lesspipe$$.jpg /tmp/.lesspipe1$$.jpg
##elif pbmtoascii,convert
# ASCII Art conversion using netbpm
# elif [[ "$1" = *image\ data*  || "$1" = *image\ text* || "$1" = *JPEG\ file*  || "$1" = *JPG\ file* ]]; then
#    convert -contrast -geometry 80x2048 "$2" /tmp/.lesspipe$$.pbm
#    pbmtoascii  /tmp/.lesspipe$$.pbm 2> /dev/null
#    rm  /tmp/.lesspipe$$.pbm
##endif
##ifdef mplayer
#  elif [[ "$1" = *MPEG\ system\ stream*  || "$1" = *RIFF* || "$1" = *AVI* ]]; then
#    mplayer -vo aa -aadriver slang -aanodim -aanobold -aacontrast 50 -aabright 1  "$2" 2> /dev/null
##endif
  elif [[ "$1" = *MPEG\ *layer\ 3\ audio* || "$1" = *mp3\ file* || "$1" = *MP3* ]]; then
    mp3info "$2"
  elif [[ "$1" = *bill\ of\ materials* ]]; then
    lsbom -p MUGsf "$2"
  elif [[ "$1" = *perl\ Storable* ]]; then
    perl -MStorable=retrieve -MData::Dumper -e '$Data::Dumper::Indent=1;print Dumper retrieve shift' "$2"
  elif [[ "$1" = *UTF-16* ]]; then
      iconv -f utf-16 "$2"
  elif [[ "$1" = *data* ]]; then
    echo "==> append $sep to filename to view the $1 source"
    if [[ "$2" = "-" ]]; then
      strings
    else
      strings "$2"
    fi
  else
    set "plain text" "$2"
  fi
  if [[ "$1" = *plain\ text* ]]; then
    dir=${LESSOPEN#\|}
    dir=${dir%%lesspipe.sh*\%s}
    ${dir}code2color $PPID ${in_file:+"$in_file"} "$2"
    if [[ $? = 0 ]]; then
      return
    fi
  fi
  if [[ "$2" = - ]]; then
    cat
  fi  
}

# calling show with arg1 arg2 ... is equivalent to calling with arg1:arg2:...
IFS=$sep a="$@"
IFS=' '
if [[ "$a" = "" ]]; then
  if [[ "$SHELL" = *csh ]]; then
    echo "setenv LESSOPEN \"|$0 %s\""
  else
    echo "LESSOPEN=\"|$0 %s\""
    echo "export LESSOPEN"
  fi
else
  show "$a"
fi
