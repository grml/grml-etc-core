#!/usr/bin/perl
# Filename:      gsuggest.pl
# Purpose:       google suggest - ask google for keyword suggestions
# Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
# Bug-Reports:   see http://grml.org/bugs/
# License:       This file is licensed under the GPL v2.
################################################################################

use strict;
use warnings;
use WebService::Google::Suggest;

unless (@ARGV) {
  print "usage: gsuggest <keyword[s]>\n";
  exit(1);
}

my $suggest = WebService::Google::Suggest->new();

while (@ARGV) {
   my @suggestions = $suggest->complete(shift);
   for my $suggestion (@suggestions) {
     print "$suggestion->{query}: $suggestion->{results} results\n";
   }
}

## END OF FILE #################################################################
