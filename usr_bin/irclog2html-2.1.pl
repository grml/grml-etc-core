#!/usr/bin/perl

# irclog2html.pl Version 2.1 - 27th July, 2001
# Copyright (C) 2000, Jeffrey W. Waugh

# Author:
#   Jeff Waugh <jdub@perkypants.org>

# Contributors:
#   Rick Welykochy <rick@praxis.com.au>
#   Alexander Else <aelse@uu.net>

# Released under the terms of the GNU GPL
# http://www.gnu.org/copyleft/gpl.html

# Usage: irclog2html filename

# irclog2html will write out a colourised irc log, appending a .html
# extension to the output file.


####################################################################################
# Perl Configuration

use strict;
#$^W = 1;	#RW# turn on warnings

my $VERSION = "2.1";
my $RELEASE = "27th July, 2001";


# Colouring stuff
my $a = 0.95;			# tune these for the starting and ending concentrations of R,G,B
my $b = 0.5;
my $rgb = [ [$a,$b,$b], [$b,$a,$b], [$b,$b,$a], [$a,$a,$b], [$a,$b,$a], [$b,$a,$a] ];

my $rgbmax = 125;		# tune these two for the outmost ranges of colour depth
my $rgbmin = 240;


####################################################################################
# Preferences

# Comment out the "table" assignment to use the plain version

my %prefs_colours = (
	"part"			=>	"#000099",
	"join"			=>	"#009900",
	"server"		=>	"#009900",
	"nickchange"	=>	"#009900",
	"action"		=>	"#CC00CC",
);

my %prefs_colour_nick = (
	"jdub"			=>	"#993333",
	"cantanker"		=>	"#006600",
	"chuckd"		=>	"#339999",
);

my %prefs_styles = (
	"simplett"		=>	"Text style with little use of colour",
	"tt"			=>	"Text style using colours for each nick",
	"simpletable"	=>	"Table style, without heavy use of colour",
	"table"			=>	"Default style, using a table with bold colours",
);

my $STYLE = "table";


####################################################################################
# Utility Functions & Variables

sub output_nicktext {
	my ($nick, $text, $htmlcolour) = @_;

	if ($STYLE eq "table") {
		print OUTPUT "<tr><th bgcolor=\"$htmlcolour\"><font color=\"#ffffff\"><tt>$nick</tt></font></th>";
		print OUTPUT "<td width=\"100%\" bgcolor=\"#eeeeee\"><tt><font color=\"$htmlcolour\">$text<\/font></tt></td></tr>\n";
	} elsif ($STYLE eq "simpletable") {
		print OUTPUT "<tr bgcolor=\"#eeeeee\"><th><font color=\"$htmlcolour\"><tt>$nick</tt></font></th>";
		print OUTPUT "<td width=\"100%\"><tt>$text</tt></td></tr>\n";
	} elsif ($STYLE eq "simplett") {
		print OUTPUT "&lt\;$nick&gt\; $text<br>\n";
	} else {
		print OUTPUT "<font color=\"$htmlcolour\">&lt\;$nick&gt\;<\/font> <font color=\"#000000\">$text<\/font><br>\n";
	}
}

sub output_servermsg {
	my ($line) = @_;

	if ($STYLE =~ /table/) {
		print OUTPUT "<tr><td colspan=2><tt>$line</tt></td></tr>\n";
	} else {
		print OUTPUT "$line<br>\n";
	}
}

sub html_rgb
{
	my ($i,$ncolours) = @_;
	$ncolours = 1 if $ncolours == 0;

	my $n = $i % @$rgb;
	my $m = $rgbmin + ($rgbmax - $rgbmin) * ($ncolours - $i) / $ncolours;

	my $r = $rgb->[$n][0] * $m;
	my $g = $rgb->[$n][1] * $m;
	my $b = $rgb->[$n][2] * $m;
	sprintf("#%02x%02x%02x",$r,$g,$b);
}

my $msg_usage = "Usage: irclog2html.pl [OPTION]... [FILE]
Colourises and converts IRC logs to HTML format for easy web reading.

  -s, --style=[STYLE]     format log according to specific style. style formats
                          described using irclog2html [-s|--style]
						  
  --colour-<attribute>=[COLOUR]     format output colour scheme. attributes
                                    described using irclog2html [--colour]

Report bugs to Jeff Waugh <jdub\@perkypants.org>.
";

my $msg_styles = "The following styles are available for use with irclog2html.pl:

  simplett
    Text style with little use of colour

  tt
    Text style using colours for each nick

  simpletable
    Table style, without heavy use of colour

  table
    Default style, using a table with bold colours
";

my $msg_colours = "The following attributes may be customized using the --colour
parameter:

  join, part, action, server, nickchange
";


################################################################################
# Main

sub main {

	my $inputfile;

	my $nick;
	my $time;
	my $line;
	my $text;

	my $htmlcolour;
	my $nickcount = 0;
	my $NICKMAX = 30;

	my %colours = %prefs_colours;
	my %colour_nick = %prefs_colour_nick;
	my %styles = %prefs_styles;


	# Quit if there is no filename specified on the command line #
	if ($#ARGV == -1) {
		die "Required parameter missing\n\n$msg_usage";
	}


	# Loop through parameters, bringing filenames into $files #
	my $count = 0;
	
	while ($ARGV[$count]) {
	
		if ($ARGV[$count] =~ /-s|--style.*/) {
			$STYLE = $ARGV[$count];
			
			if ($STYLE =~ /--style=.*/) {
				$STYLE =~ s/--style=(.*)/$1/;
				
			} else {
				$count++;
				$STYLE = $ARGV[$count];
			}
			
			if ($STYLE eq "") {
				print $msg_styles;
				return 0;
				
			} elsif (!defined($styles{$STYLE})) {
				die "irclog2html.pl: invalid style: `$STYLE'\n\n$msg_styles";
			}
			
		} elsif ($ARGV[$count] =~ /--colou?r.*/) {
			my $colour_pref = $ARGV[$count];
			my $colour = $colour_pref;

			if ($colour_pref =~ /--colou?r$/) {
				print $msg_colours;
				return 0;
			
			} else {
				$colour_pref =~ s/--colou?r-(.*)?=.*/$1/;
				$colour =~ s/--colou?r-.*?=(.*)/$1/;

				$colours{$colour_pref} = $colour;
			}
			
		} else {
			$inputfile = $ARGV[$count];
		}
		$count++;
	}

	# Open input and output files #
	if (!$inputfile) {
		# no file to open, print appropriate usage information
		die "\n$msg_usage";
	
	} elsif (!open(INPUT, $inputfile)) {
		# not a vaild file to open, spew error and usage information
		die "irclog2html.pl: cannot open $inputfile for reading\n\n$msg_usage";
	}
	if (!open(OUTPUT, ">$inputfile.html")) {
		# can't open file for output, spew error
		die "irclog2html.pl: cannot open $inputfile.html for writing\n";
	}


	# Begin output #
	print OUTPUT qq{<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>$inputfile</title>
	<meta name="generator" content="irclog2html.pl $VERSION by Jeff Waugh">
	<meta name="version" content="$VERSION - $RELEASE">
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body text="#000000" bgcolor="#ffffff"><tt>
};

	if ($STYLE =~ /table/) {
		print OUTPUT "<table cellspacing=3 cellpadding=2 border=0>\n";
	}

	while ($line = <INPUT>) {

		chomp $line;

		if ($line ne "") {

			# Replace ampersands, pointies, control characters #
			$line =~ s/&/&amp\;/g;
			$line =~ s/</&lt\;/g;
			$line =~ s/>/&gt\;/g;
			$line =~ s/[\x00-\x1f]+//g;

			# Replace possible URLs with links #
			$line =~ s/((http|https|ftp|gopher|news):\/\/\S*)/<a href="$1">$1<\/a>/g;

			# Rip out the time #
			if ($line =~ /^\[?\d\d:\d\d(:\d\d)?\]? .*$/) {
				$time = $line;
				$time =~ s/^\[?(\d\d:\d\d(:\d\d)?)\]? .*$/$1/;
				$line =~ s/^\[?\d\d:\d\d(:\d\d)?\]? (.*)$/$2/;
				print $time;
			}

			# Colourise the comments
			if ($line =~ /^&lt\;.*?&gt\;\s.*/) {

				# Split $nick and $line
				$nick = $line;
				$nick =~ s/^&lt\;(.*?)&gt\;\s.*$/$1/;

				# $nick =~ tr/[A-Z]/[a-z]/;
				# <======= move this into another function when getting nick colour

				$text = $line;
				$text =~ s/^&lt\;.*?&gt\;\s(.*)$/$1/;
				$text =~ s/  /&nbsp\;&nbsp\;/g;

				$htmlcolour = $colour_nick{$nick};
				if (!defined($htmlcolour)) {
					# new nick
					$nickcount++;

					# if we've exceeded our estimate of the number of nicks, double it
					$NICKMAX *= 2 if $nickcount >= $NICKMAX;

					$htmlcolour = $colour_nick{$nick} = html_rgb($nickcount, $NICKMAX);
				}
				output_nicktext($nick, $text, $htmlcolour);
				
			} else {
				# Colourise the /me's #
				if ($line =~ /^\* .*$/) {
					$line =~ s/^(\*.*)$/<font color=\"$colours{"action"}\">$1<\/font>/;
				}

				# Colourise joined/left messages #
				elsif ($line =~ /^(\*\*\*|--&gt;) .*joined/) {
					$line =~ s/(^(\*\*\*|--&gt;) .*)/<font color=\"$colours{"join"}\">$1<\/font>/;
				}
				elsif ($line =~ /^(\*\*\*|&lt;--) .*left|quit/) {
					$line =~ s/(^(\*\*\*|&lt;--) .*)/<font color=\"$colours{"part"}\">$1<\/font>/;
				}
				
				# Process changed nick results, and remember colours accordingly #
				elsif ($line =~ /^(\*\*\*|---) (.*?) are|is now known as (.*)/) {
					my $nick_old;
					my $nick_new;
					
					$nick_old = $line;
					$nick_old =~ s/^(\*\*\*|---) (.*?) (are|is) now known as .*/$1/;

					$nick_new = $line;
					$nick_new =~ s/^(\*\*\*|---) .*? (are|is) now known as (.*)/$2/;

					$colour_nick{$nick_new} = $colour_nick{$nick_old};
					$colour_nick{$nick_old} = undef;

					$line =~ s/^((\*\*\*|---) .*)/<font color=\"$colours{"nickchange"}\">$1<\/font>/
				}
				# server messages
				elsif ($line =~ /^(\*\*\*|---) /) {
					$line =~ s/^((\*\*\*|---) .*)$/<font color=\"$colours{"server"}\">$1<\/font>/;
				}

				output_servermsg($line);
			}
		}
	}

	if ($STYLE =~ /table/) {
		print OUTPUT "</table>\n";
	}

	print OUTPUT qq{
<br>Generated by irclog2html.pl $VERSION by <a href="mailto:jdub\@NOSPAMperkypants.org">Jeff Waugh</a>
 - find it at <a href="http://freshmeat.net/projects/irclog2html.pl/">freshmeat.net</a>!
</tt></body></html>};

	close INPUT;
	close OUTPUT;

	return 0;
}

exit main;
