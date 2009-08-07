#!/usr/bin/perl
# Filename:      unbleach.pl
# Purpose:       for really dirty perl programs
# Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
# Bug-Reports:   see http://grml.org/bugs/
# License:       This file is licensed under the GPL v2.
################################################################################

# This script will replace all the unsighted unprintable characters bleached out of your source file by a:
#   use Acme::Bleach;
# directive with elegant (perhaps) ASCII perl code. 

use strict;
my $washing = pop or carp("Usage: unbleach.pl [file]\n");
open white,"<$washing" or carp("Can't get $washing");
local $/; $_=<white>;
s/(.*)^\s*use\s+Acme::Bleach\s*;\n(?: \t){8}/$1/
or carp("$washing is not bleached!");
open line,">$washing" or carp("Can't dry $washing");
print line out($_);
sub out {s/\n//g;tr/ \t/01/;pack "b*",$_;}
sub carp {print shift and exit}

=head1 NAME

unbleach.pl - For I<really> unclean programs

=head1 SYNOPSIS

unbleach.pl [file]

=head1 DESCRIPTION

This script will replace all the unsighted unprintable
characters bleached out of your source file by a:

    use Acme::Bleach;

directive with elegant (perhaps) ASCII perl code.

It also removes the use bleach line when it rewrites
the source code. The code continues to work exactly
as it did before, but now looks like normal!

=head1 DIAGNOSTICS

=item C<Can't get '%s'>

unbleach.pl could not read the source file.

=item C<'%s' is not bleached!>

unbleach.pl will only process files that have been
previously bleached and have the expected format.

=item C<Can't dry '%s'>

unbleach.pl could not open the source file to modify it.

=head1 SEE ALSO

http://www.cpan.org/authors/id/DCONWAY/Acme-Bleach-1.12.tar.gz
http://www.perlmonks.com

=head1 AUTHOR

not Damian Conway (as if you couldn't guess)

=head1 COPYRIGHT

Copyright (c) 2001, tachyon. All Rights Reserved.
This script is free software. It may be used, redistributed
and/or modified under the terms of the Perl Artistic License
(see http://www.perl.com/perl/misc/Artistic.html)
