#!/usr/bin/awk -f

# /* 24.12.2004
# urlgrep[.awk] v1 - print http|ftp|rstp|mms:// text entries in text
# urlgrep [-v dup=[01]] [[+] regex] [! regex] [file|-] [files..]
# no files specified = read from stdin
# w/o files, read stdin

# todo: doing hpfetch with v2 of this
# todo: v2: multiple positive/negative regex support
# todo: v2: recognition: http://blah.com/path) text

# by xmb<xmb@skilled.ch> - localhack

# 24.12.2004, 26.12.2004, 02.01.2005, 26.01.2005(rstp support)
# 28.01.2005(grep like syntax and ! <notmatch>)
# 09.02.2005(fixed args, others, renamed from httpgrep to urlgrep)
# 12.02.2005(mms support), 28.02.2005(robustness update)
# 07.03.2005(conf enhansements)
# 24.03.2005(regex/gsub enh's, more cmd examples)
# 01.05.2005(-- stop arg)
# */

# $ cp urlgrep.awk /usr/local/bin/urlgrep

# $ urlgrep regex ! regex files
# $ urlgrep '' file
# $ urlgrep . file
# $ curl -s www.blah.ch | urlgrep
# $ wget -qO- www.microsoft.com | urlgrep [| xargs curl -sD-]
# $ curl -s www.apple.com | urlgrep ! 200[25] +[^m]/$

# $ curl -s http://e2e.serveftp.net/wee/ | urlgrep wmv$ | xargs -n1 mplayer
# $ 

## MMMM! example site aightgenossen.ch, play media files with max 3 mplayers@1p
# $ wget xmb.ath.cx/threads.sh
# $ . threads.sh ; threads_max=3
# $ getwhile() { [[ ! $1 ]] && echo $last && return 1; last=$( curl -s $@ |
# > urlgrep ) match=$( grep -E '(wm[av]|rm|mov|avi)$|^rtsp' ) && getwhile }
# # v2 signal todo
# curl -s aightgenossen.ch/index.php/m=multimedia
# .. unfinished

BEGIN {
	if (! dup && dup != "0") dup = 1 # filter duplicates, by default on
	if (! dup_domain && dup_domain != "0") dup_domain = 0 # filter duplicates
	#     ^ by domain but show whole url matching first
	if (! show_dom_only && show_dom_only != "0") show_dom_only = 0 # show only
	#     ^ the domain/host of the url

	# map env variables, accessable with URLGREP_ prefix
	# eg, NODUP is the env variable URLGREP_NODUP
	narg = split("\
		NODUP dup 0 \
		GREP grep . \
		NOGREP nogrep . \
		URL url . \
		DEBUG DEBUG .\
		DUP_DOMAIN dup_domain . \
		DOMAIN_ONLY domain_only .\
	", Args)
	
	for (arg = 1; arg <= narg; arg++)
		if (ENVIRON[ Args[i] ]) {
			if (Args[i+2] == ".") CONF[ Args[i+1] ] = ENVIRON[ Args[i] ]
			else CONF[ Args[i+1] ] = Args[i+2]
			
			i += 2
		}
	
	# argument parsing, this uses quite some CPU, gah, fixed
	while (ARGV[++i]) {
		#if (i == 1 || ARGV[i] ~ /^\+/) grep = get_arg(i)
		#if (ARGV[i] ~ /^!/) nogrep = get_arg(i)
		
		if (ARGV[i] ~ /^!/) CONF["nogrep"] = get_arg(i)
		else CONF["grep"] = get_arg(i)
		
		if (skip) { skip = 0; delete ARGV[i]; delete ARGV[++i] }
		else delete ARGV[i]

		if (ARGV[i + 1] !~ /^[+!-]/) break # stop after having enough regexes
	}
	
	if (CONF["grep"])	grep = CONF["grep"]
	if (CONF["nogrep"])	nogrep = CONF["grep"]
	if (CONF["url"])	url = CONF["url"]
	if (CONF["DEBUG"])	DEBUG = CONF["DEBUG"]
	
	#if (ENVIRON["URLGREP_NODUP"]) dup = 0
	#if (ENVIRON["URLGREP_GREP"]) grep = ENVIRON["URLGREP_GREP"]
	#if (ENVIRON["URLGREP_NOGREP"]) nogrep = ENVIRON["URLGREP_NOGREP"]
	#if (ENVIRON["URLGREP_URL"]) url = ENVIRON["URLGREP_URL"]
	#if (ENVIRON["URLGREP_DEBUG"]) DEBUG = ENVIRON["URLGREP_DEBUG"]
	#if (ENVIRON["URLGREP_QUOT"]) quote = ENVIRON["URLGREP_QUOT"]
	#if (ENVIRON["URLGREP_DUP_DOMAIN]) dup_domain = ENVIRON["URLGREP_DUP_DOMAIN"]

	err = "/dev/stderr"
	r_h = "(https?|ftp|rtsp|mms)://" # head(er)
	#r_h = "[a-zA-Z]+://"
	#r_m = r_h " ?['\"]?[^ \t'\"<>]+"
	r_m = r_h " *['\"]?[^ \t'\"<>]+\\.[^ \t'\"<>]+" # match
	
	if (DEBUG) printf "url = %s, match '%s', dont match '%s'\n",
		(url) ? url : "none", grep, nogrep >err
}

#DEBUG > 2 # small slowdown

$0 ~ r_h {
	if (DEBUG > 1) print "LINE:", $0
	#while ($0 ~ r_h "[^\"'\t<][ \t]*[^ \t]+\\.") { # original way uses r_h
	while ($0 ~ r_m) {
		s = substr($0, match($0, r_m), RLENGTH)
		total++
		if (dup && ! Seen[s]++)
			_p(s)
		else if (! dup)
			_p(s)
		else
			found_dup++
		sub(r_m, "")
	}
}

END {
	fflush()
	if (! count) exit 3
	printf "urlgrep: %d total", total >err
	if (found_dup)
		printf ", %d printed, %d duplicates", count, found_dup >err
	if (found_dup + count < total)
		printf ", %d not matched", total - (found_dup + count) >err
	printf "\n" >err
	fflush()
}

# get either current or next arg
function get_arg(p	,tmp) {
	if (ARGV[p] ~ /^[+!-]/) {
		if (length(ARGV[p]) > 1) {
			tmp = substr(ARGV[p], 2)
			sub(/^ */, "", tmp)
			return tmp
		} else {
			skip = 1
			return ARGV[p + 1]
		}
	} else
		return ARGV[p]
}

# main match/nomatch check & print function
function _p(s) {
	if ((grep && s !~ grep) || nogrep && s ~ nogrep) return 1
	
	gsub(/[ \t'"]*/, "", s) # :;, are newly added # ;,
	if (quote) print "'" s "'" # small slowdown
	else
		print s
	count++
}
