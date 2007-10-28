#!/usr/bin/perl
use warnings;
use strict;

use Getopt::Std;
use File::Basename;
use File::Copy;
use MP3::Tag;
use Ogg::Vorbis::Header;

# documentation {{{
=head1 NAME

arename.pl - automatically rename audio files by tagging information

=head1 SYNOPSIS

arename.pl [OPTION(s)] FILE(s)...

=head1 OPTIONS AND ARGUMENTS

=over 8

=item B<-d>

Go into dryrun mode.

=item B<-f>

Overwrite files if needed.

=item B<-h>

Display a short help text.

=item B<-V>

Display version infomation.

=item B<-v>

Enable verbose output.

=item B<-p> E<lt>prefixE<gt>

Define a prefix for destination files.

=item B<-T> E<lt>templateE<gt>

Define a compilation template.

=item B<-t> E<lt>templateE<gt>

Define a generic template.

=item I<FILE(s)...>

Input files, that are subject for renaming.

=back

=head1 DESCRIPTION

B<arename.pl> is a tool that is able to rename audio files by looking at
a file's tagging information, from which it will assemble a consistent
destination file name. The format of that filename is configurable for the
user by the use of template strings.

B<arename.pl> currently supports two widely used audio formats, namely
MPEG Layer3 and ogg vorbis. The format, that B<arename.pl> will assume
for each input file is determined by the file's filename-extension
(I<.mp3> vs. I<.ogg>). The extension check is case-insensitive.

By default, B<arename.pl> will refuse to overwrite destination files,
if the file in question already exists. You can force overwriting by
supplying the B<-f> option.

=head1 FILES

B<arename.pl> uses up to two configuration files. As for most programs,
the script will try to read a configuration file, that is located in the
user's I<home directory>. In addition to that, it will try to load I<local>
configuration files, if it finds appropriately named files in the
I<current directory>.

=over 8

=item B<~/.arenamerc>

per-user global configuration file.

=item B<./.arename.local>

per-directory local configuration file.

=back

=head2 File format

The format of the aforementioned files is pretty simple.
It is parsed line by line. Empty lines, lines only containing whitespace
and lines, whose first non whitespace character is a hash character (I<#>)
are ignored.

Each line consists of one or two parts. If there are two parts,
they are separated by whitespace. The first part of the line will be used
as the identifier of a setting (eg. I<verbose>). The second part (read: the
rest of the line) is used as the value of the setting. (No quoting, or whatsoever
is required.)

If a line consists of only one part, that means the setting is switched on.

=head2 Configuration file example

  # switch on verbosity
  verbose

  # the author is crazy! use a sane template by default. :-)
  template &artist - &album (&year) - &tracknumber. &tracktitle

=head1 SETTINGS

The following settings are supported in all configuration files:

=over 8

=item B<comp_template>

Defines a template to use with files that provide a compilation tag
(for 'various artist' CDs, for example). This setting can still be
overwritten by the B<-T> command line option. (default value:
I<va/&album/&tracknumber - &artist - &tracktitle>)

=item B<default_year>

Defines a default year, for files, that lack this information.
(default value: I<undefined>)

=item B<prefix>

Defines a prefix for destination files. This setting can still be
overwritten by the B<-p> command line option. (default value: I<.>)

=item B<sepreplace>

Tagging information strings may contain slashes, which is a pretty bad
idea on most filesystems. Therefore, you can define a string, that replaces
slashes with the value of this setting. (default value: I<_>)

=item B<template>

Defines a template to use with files that do not provide a compilation tag
(or where the compilation tag and the artist tag are exactly the same).
This setting can still be overwritten by the B<-T> command line option.
(default value: I<&artist[1]/&artist/&album/&tracknumber - &tracktitle>)

=item B<tnpad>

This defines the width, to which the tracknumber field is padded with zeros
on the left. (default value: I<2>)

=item B<verbose>

Switches on verbosity by default. (default value: I<off>)

=back

=head1 TEMPLATE FORMAT

B<arename.pl>'s templates are quite simple, yet powerful.

At simplest, a template is just a fixes character string. However, that would
not be exactly useful. So, the script is able to expand certain expressions
with information gathered from the file's tagging information.

The expressions can have two slightly different forms:

=over 8

=item B<&>I<identifier>

The simple form.

=item B<&>I<identifier>B<[>I<length>B<]>

The "complex" form. The I<length> argument in square brackets defines the
maximum length, to which the expression should be expanded.

=back

=head2 Available expression identifiers

The data, that is expanded is derived from tagging information in
the audio files. For I<.ogg> files, the tag checking B<arename.pl> does
is case insensitive and the first matching tag will be used.

=over 8

=item B<album>

Guess.

=item B<artist>

Guess again.

=item B<compilation>

For I<.ogg> this is filled with information found in the 'albumartist' tag.
For I<.mp3> this is filled with information from the id3v2 TPE2 frame.
If the mp3 file only provides a id3v1 tag, this is not supported.

=item B<tracknumber>

The number of the position of the track on the disc. Obviously. However, this
can be in the form of '12' or '12/23'. In the second form, only the part left
of the slash is used. The tracknumber is a little special, as you can defined
to what width it should be padded with zeros on the left (see I<tnpad> setting
in L<arename(1)/SETTINGS>).

=item B<tracktitle>

Well...

=item B<year>

Year (id3v1), TYER (id3v2) or DATE tag (.ogg).

=back

=head1 SEE ALSO

L<Ogg::Vorbis::Header(3)> and L<MP3::Tag(3)>.

=head1 AUTHOR

Frank Terbeck E<lt>ft@bewatermyfriend.orgE<gt>,

Please report bugs.

=head1 LICENSE

 Copyright 2007
 Frank Terbeck <ft@bewatermyfriend.org>, All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

   1. Redistributions of source code must retain the above
      copyright notice, this list of conditions and the following
      disclaimer.
   2. Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials
      provided with the distribution.

  THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS OF THE
  PROJECT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut
#}}}
# variables {{{
my (
    %defaults, %methods, %opts,
    $dryrun, $comp_template, $force, $prefix,
    $sepreplace, $template, $tnpad, $verbose
);
my ($NAME, $VERSION) = ( 'arename.pl', 'v0.3' );
#}}}
sub apply_defaults { #{{{
    my ($datref) = @_;

    foreach my $key (keys %defaults) {
        if (!defined $datref->{$key}) {
            if ($verbose) {
                print "  -!- Setting ($key) to \"$defaults{$key}\".\n";
            }
            $datref->{$key} = $defaults{$key};
        }
    }
}
#}}}
sub arename { #{{{
    my ($file, $datref, $ext) = @_;
    my ($t, $newname);

    apply_defaults($datref);

    if ($verbose) { #{{{
        print "  -!- Artist     : \"" .
            (defined $datref->{artist}      ? $datref->{artist}      : "-.-")
            . "\"\n";
        print "  -!- Compilation: \"" .
            (defined $datref->{compilation} ? $datref->{compilation} : "-.-")
            . "\"\n";
        print "  -!- Album      : \"" .
            (defined $datref->{album}       ? $datref->{album}       : "-.-")
            . "\"\n";
        print "  -!- Tracktitle : \"" .
            (defined $datref->{tracktitle}  ? $datref->{tracktitle}  : "-.-")
            . "\"\n";
        print "  -!- Tracknumber: \"" .
            (defined $datref->{tracknumber} ? $datref->{tracknumber} : "-.-")
            . "\"\n";
        print "  -!- Year       : \"" .
            (defined $datref->{year}        ? $datref->{year}        : "-.-")
            . "\"\n";
    } #}}}

    if (defined $datref->{compilation}
        && $datref->{compilation} ne $datref->{artist}) {

        $t = $comp_template;
    } else {
        $t = $template;
    }

    $newname = expand_template($t, $datref);
    if (!defined $newname) {
        return;
    }

    $newname = $prefix . '/' . $newname . '.' . $ext;

    if (file_eq($newname, $file)) {
        print "  -!- ($file)\n      would stay the way it is, skipping.\n";
        return;
    }

    if (-e $newname && !$force) {
        print "  -!- ($newname) exists.\n      use '-f' to force overwriting.\n";
        return;
    }

    ensure_dir(dirname($newname));

    print "  -!- mv '$file' \\\n" . 
          "         '$newname'\n";

    if (!$dryrun) {
        xrename($file, $newname);
    }
}
#}}}
sub ensure_dir { #{{{
    # think: mkdir -p /foo/bar/baz
    my ($wantdir) = @_;
    my (@parts, $sofar);

    if (-d $wantdir) {
        return;
    }

    if ($wantdir =~ '^/') {
        $sofar = '/';
    } else {
        $sofar = '';
    }

    @parts = split(/\//, $wantdir);
    foreach my $part (@parts) {
        if ($part eq '') {
            next;
        }
        $sofar = (
                  $sofar eq ''
                    ? $part
                    : (
                        $sofar eq '/'
                          ? '/' . $part
                          : $sofar . "/" . $part
                      )
                 );

        if (!-d $sofar) {
            if ($dryrun || $verbose) {
                print "  -!- mkdir \"$sofar\"\n";
            }
            if (!$dryrun) {
                mkdir($sofar) or die "  -!- Could not mkdir($sofar).\n" .
                                     "  -!- Reason: $!\n";
            }
        }
    }
}
#}}}
sub expand_template { #{{{
    my ($template, $datref) = @_;
    my @tags = (
        'album',
        'artist',
        'compilation',
        'tracknumber',
        'tracktitle',
        'year'
    );

    foreach my $tag (@tags) {
        my ($len, $token);

        while ($template =~ m/&$tag(\[(\d+)\]|)/) {
            $len = 0;
            if (defined $2) { $len = $2; }

            if (!defined $datref->{$tag} || $datref->{$tag} eq '') {
                warn "  -!- $tag not defined, but required by template. Giving up.\n";
                return undef;
            }

            if ($len > 0) {
                $token = substr($datref->{$tag}, 0, $len);
            } else {
                if ($tag eq 'tracknumber') {
                    my $val;
                    if ($datref->{$tag} =~ m/^([^\/]*)\/.*$/) {
                        $val = $1;
                    } else {
                        $val = $datref->{$tag};
                    }
                    $token = sprintf "%0" . $tnpad . "d", $val;
                } else {
                    $token = $datref->{$tag};
                }
            }
            if ($token =~ m!/!) {
                if ($verbose) {
                    print "  -!- Found directory seperator in token.\n";
                    print "  -!- Replacing with \"$sepreplace\".\n";
                }
                $token =~ s!/!$sepreplace!g;
            }
            $template =~ s/&$tag(\[(\d+)\]|)/$token/;
        }
    }

    return $template;
}
#}}}
sub file_eq { #{{{
    my ($f0, $f1) = @_;
    my (@stat0, @stat1);

    if (!-e $f0 || !-e $f1) {
        # one of the two doesn't even exist, can't be the same then.
        return 0;
    }

    @stat0 = stat $f0 or die "Could not stat($f0): $!\n";
    @stat1 = stat $f1 or die "Could not stat($f1): $!\n";

    if ($stat0[0] == $stat1[0] && $stat0[1] == $stat1[1]) {
        # device and inode are the same. same file.
        return 1;
    }

    return 0;
}
#}}}
sub process_mp3 { #{{{
    my ($file) = @_;
    my ($mp3, %data, $info);

    $mp3 = MP3::Tag->new($file);

    if (!defined $mp3) {
        print "  -!- Failed to open \"$file\".\n  -!- Reason: $!\n";
        return;
    }

    $mp3->get_tags;

    if (!exists $mp3->{ID3v1} && !exists $mp3->{ID3v2}) {
        print "  -!- No tag found. Ignoring.\n";
        $mp3->close();
        return;
    }

    if (exists $mp3->{ID3v2}) {
        ($data{artist},      $info) = $mp3->{ID3v2}->get_frame("TPE1");
        ($data{compilation}, $info) = $mp3->{ID3v2}->get_frame("TPE2");
        ($data{album},       $info) = $mp3->{ID3v2}->get_frame("TALB");
        ($data{tracktitle},  $info) = $mp3->{ID3v2}->get_frame("TIT2");
        ($data{tracknumber}, $info) = $mp3->{ID3v2}->get_frame("TRCK");
        ($data{year},        $info) = $mp3->{ID3v2}->get_frame("TYER");
    } elsif (exists $mp3->{ID3v1}) {
        print "  -!- Only found ID3v1 tag.\n";
        $data{artist}      = $mp3->{ID3v1}->artist;
        $data{album}       = $mp3->{ID3v1}->album;
        $data{tracktitle}  = $mp3->{ID3v1}->title;
        $data{tracknumber} = $mp3->{ID3v1}->track;
        $data{year}        = $mp3->{ID3v1}->year;
    }

    $mp3->close();

    arename($file, \%data, 'mp3');
}
#}}}
sub process_ogg { #{{{
    my ($file) = @_;
    my ($ogg, %data, @tags);

    $ogg = Ogg::Vorbis::Header->load($file);

    if (!defined $ogg) {
        print "  -!- Failed to open \"$file\".\n  -!- Reason: $!\n";
        return;
    }

    @tags = $ogg->comment_tags;

    foreach my $tag (@tags) {
        my ($realtag, $value);
        if (!(
                $tag =~ m/^ALBUM$/i         ||
                $tag =~ m/^ARTIST$/i        ||
                $tag =~ m/^TITLE$/i         ||
                $tag =~ m/^TRACKNUMBER$/i   ||
                $tag =~ m/^DATE$/i          ||
                $tag =~ m/^ALBUMARTIST$/i
            )) { next; }

        $value = join(' ', $ogg->comment($tag));
        if ($tag =~ m/^ALBUM$/i) {
            $realtag = 'album';
        } elsif ($tag =~ m/^ARTIST$/i) {
            $realtag = 'artist';
        } elsif ($tag =~ m/^TITLE$/i) {
            $realtag = 'tracktitle';
        } elsif ($tag =~ m/^TRACKNUMBER$/i) {
            $realtag = 'tracknumber';
        } elsif ($tag =~ m/^DATE$/i) {
            $realtag = 'year';
        } elsif ($tag =~ m/^ALBUMARTIST$/i) {
            $realtag = 'compilation';
        } else {
            die "This should not happen. Report this BUG. ($tag, $value)";
        }

        if (!defined $data{$realtag}) {
            $data{$realtag} = $value;
        }
    }

    arename($file, \%data, 'ogg');
}
#}}}
sub process_warn { #{{{
    my ($file) = @_;

    warn "  -!- No method for handling \"$file\".\n";
}
#}}}
sub rcload { #{{{
    my ($file, $desc) = @_;
    my ($fh, $retval);
    my $count = 0;
    my $lnum  = 0;

    if (!open($fh, "<$file")) {
        warn "Failed to read $desc ($file).\n  -!- Reason: $!\n";
        return 1;
    }

    print "Reading \"$file\"...\n";

    while (my $line = <$fh>) {
        chomp($line);
        $lnum++;

        if ($line =~ m/^\s*#/ || $line =~ m/^\s*$/) {
            next;
        }

        $line =~ s/^\s*//;
        my ($key,$val) = split(/\s+/, $line, 2);

        if ($key eq 'template') {
            $template = $val;
        } elsif ($key eq 'comp_template') {
            $comp_template = $val;
        } elsif ($key eq 'default_year') {
            $defaults{year} = $val;
        } elsif ($key eq 'sepreplace') {
            $sepreplace = (defined $val ? $val : "");
        } elsif ($key eq 'tnpad') {
            $tnpad = $val;
        } elsif ($key eq 'verbose') {
            $verbose = 1;
        } elsif ($key eq 'prefix') {
            $prefix = $val;
        } else {
            warn "$file,$lnum: invalid line '$line'.\n";
            return -1;
        }

        $count++;
    }
    close $fh;

    print "  -!- Read $desc.\n  -!- $count valid items.\n";
    return 0;
}
#}}}
sub xrename { #{{{
    # a rename() replacement, that implements renames across
    # filesystems via File::copy() + unlink().
    # This assumes, that source and destination directory are
    # there, because it stat()s them, to check if it can use
    # rename().
    my ($src, $dest) = @_;
    my (@stat0, @stat1, $d0, $d1, $cause);

    $d0 = dirname($src);
    $d1 = dirname($dest);
    @stat0 = stat $d0 or die "Could not stat($d0): $!\n";
    @stat1 = stat $d1 or die "Could not stat($d1): $!\n";

    if ($stat0[0] == $stat1[0]) {
        $cause = 'rename';
        rename $src, $dest or goto err;
    } else {
        $cause = 'copy';
        copy($src, $dest) or goto err;
        $cause = 'unlink';
        unlink $src or goto dir;
    }

    return 0;

err:
    die "  -!- Could not rename($src, $dest);\n" .
        "  -!- Reason: $cause(): $!\n";
}
#}}}
# handle options {{{

if ($#ARGV == -1) {
    $opts{h} = 1;
} else {
    if (!getopts('dfhVvp:T:t:', \%opts)) {
        if (exists $opts{t} && !defined $opts{t}) {
            die " -t *requires* a string argument!\n";
        } elsif (exists $opts{T} && !defined $opts{T}) {
            die " -T *requires* a string argument!\n";
        } elsif (exists $opts{p} && !defined $opts{p}) {
            die " -p *requires* a string argument!\n";
        } else {
            die "    Try $NAME -h\n";
        }
    }
}

if (defined $opts{h}) {
    print " Usage:\n  $NAME [-d,-f,-h,-V,-v,-p <prefix>,-[Tt] <template>] FILE(s)...\n\n";
    print "    -d                Go into dryrun mode.\n";
    print "    -f                Overwrite files if needed.\n";
    print "    -h                Display this help text.\n";
    print "    -V                Display version infomation.\n";
    print "    -v                Enable verbose output.\n";
    print "    -p <prefix>       Define a prefix for destination files.\n";
    print "    -T <template>     Define a compilation template.\n";
    print "    -t <template>     Define a generic template.\n";
    print "\n";
    exit 0;
}

if (defined $opts{V}) {
    print " $NAME $VERSION\n";
    exit 0;
}

#}}}
# set defaults {{{

$dryrun        = 0;
$force         = 0;
$prefix        = '.';
$sepreplace    = '_';
$tnpad         = 2;
$verbose       = 0;
$comp_template = "va/&album/&tracknumber - &artist - &tracktitle";
$template      = "&artist[1]/&artist/&album/&tracknumber - &tracktitle";

#}}}
# reading config file(s) {{{

my $rc = $ENV{HOME} . "/.arenamerc";
my $retval = rcload($rc, "arename.pl configuration");
if ($retval < 0) {
    die "Error(s) in \"$rc\". Aborting.\n";
} elsif ($retval > 0) {
    warn "Error opening configuration; using defaults.\n";
}

if (-r "./.arename.local") {
    $rc = "./.arename.local";
    $retval = rcload($rc, "local configuration");
    if ($retval < 0) {
        die "Error(s) in \"$rc\". Aborting.\n";
    } elsif ($retval > 0) {
        warn "Error opening local configuration.\n";
    }
}

print "\n";

#}}}
# let cmd line options overwrite {{{

if ($#ARGV == -1) {
    die "No input files. See: $NAME -h\n";
}

if (defined $opts{f}) {
    $force = $opts{f};
}

if (defined $opts{p}) {
    $prefix = $opts{p};
}

if (defined $opts{t}) {
    $template = $opts{t};
}

if (defined $opts{T}) {
    $comp_template = $opts{T};
}

if (defined $opts{d}) {
    $dryrun = $opts{d};
}

if (defined $opts{v}) {
    $verbose = $opts{v};
}

undef %opts;

#}}}
# process what's left on the commandline aka. main() {{{
%methods = (
    '.mp3$' => \&process_mp3,
    '.ogg$' => \&process_ogg
);

if ($dryrun) {
    print "+++ We are on a dry run!\n";
}

if ($verbose) {
    print "+++ Running verbose.\n";
}

if ($dryrun || $verbose) {
    print "\n";
}

foreach my $file (@ARGV) {
    my $done = 0;
    print "Processing: $file\n";
    if (-l $file) {
        warn "  -!- Refusing to handle symbolic links ($file).\n";
        next;
    }
    if (! -r $file) {
        warn "  -!- Can't read \"$file\": $!\n";
        next;
    }

    foreach my $method (sort keys %methods) {
        if ($file =~ m!$method!i) {
            $methods{$method}->($file);
            $done = 1;
        }
    }

    if (!$done) {
        process_warn($file);
    }
}
#}}}
