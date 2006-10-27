#!/usr/bin/perl
# Filename:      bincompare.pl
# Purpose:       Binary File Similarity Checking
# Authors:       (C) Copyright 2004 Diomidis Spinellis
# Bug-Reports:   see http://grml.org/bugs/
# License:       See notes by author (Diomidis Spinellis).
# Latest change: Sam Okt 16 22:54:03 CEST 2004 [mika]
################################################################################
# See http://www.dmst.aueb.gr/dds/blog/20040319/index.html
#
# Original notes:
# 
# (C) Copyright 2004 Diomidis Spinellis
#
# Permission to use, copy, and distribute this software and its
# documentation for any purpose and without fee is hereby granted,
# provided that the above copyright notice appear in all copies and that
# both that copyright notice and this permission notice appear in
# supporting documentation.
#
# THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
# MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

# Return the entropy of the file passed as the argument
sub
entropy
{
        my($file) = @_;
        my($i, $l);

        # File length
        $l = `wc -c $file`;
        # File information (approximation)
        $i = `bzip2 -c $file | wc -c`;
        print STDERR "$0: warning file size exceeds bzip2 block size\n" if ($l > 900 * 1024);
        return ($i / $l);
}


# Return the entropy of the two files passed as arguments
sub
entropy2
{
        my($file1, $file2) = @_;
        my($oldrs) = ($/);
        my($tmp) = ("/tmp/entropy.$$");

        undef($/);
        open(IN, $file1) || die "read from $file1: $!\n";
        binmode(IN);
        open(OUT, ">$tmp") || die "write to $tmp: $!\n";
        print OUT <IN>;
        open(IN, $file2) || die "read from $file2: $!\n";
        binmode(IN);
        print OUT <IN>;
        close(IN);
        close(OUT);
        my($e) = (entropy($tmp));
        unlink($tmp);
        return ($e);
}

$#ARGV == 1 || die "Usage $0: file1 file2\n";

printf("%.3g - Entropy of $ARGV[0]\n", $e0 = entropy($ARGV[0]));
printf("%.3g - Entropy of $ARGV[1]\n", $e1 = entropy($ARGV[1]));
printf("%.3g - Combined predicted entropy\n", ($e0 + $e1) / 2);
printf("%.3g - Combined actual entropy\n", entropy2($ARGV[0], $ARGV[1]));
