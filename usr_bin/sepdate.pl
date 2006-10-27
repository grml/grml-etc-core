#!/usr/bin/perl
# sepdate utility
# usage: sepdate [month date year]
# where day month year are date of interest -- default is today

# Adapted and updated from a version attributed to Rich Holmes

use Time::Local;
use POSIX qw(strftime);

if ($#ARGV == 2) {
         $todmon = $ARGV[0]-1;
         $todday = $ARGV[1];
         $todyr = $ARGV[2];
         $todti = timelocal(0, 0, 0, $todday, $todmon, $todyr);
} elsif ($#ARGV == -1) {      $todti = time;
} else {      die;
}

$septime = timelocal(0, 0, 0, 31, 7, 93);

$tdiff = $todti - $septime;
$days = int ($tdiff / (60 * 60 * 24));

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

# this seems like overkill
$tzstr = strftime("%Z", $sec, $min, $hour, $mday, $mon, $year);
printf ("%3s Sep %2d %2.2d:%2.2d:%2.2d %3s 1993\n",
                (Sun,Mon,Tue,Wed,Thu,Fri,Sat)[$wday],
                $days,$hour,$min,$sec,$tzstr);
