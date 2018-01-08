#!/usr/bin/env perl
# calclock.pl
# yyyymmdd or HHMMSS or yyyymmddHHMMSSで与えられた時刻データをエポック時間に変換
use strict;
use warnings;
use Time::Local;

sub usage {
  print "Usage: $0 (yyyymmdd|HHMMSS|yyyymmddHHMMSS)\n";
  exit(1);
}

my ($sec, $min, $hour, $day, $month, $year) = localtime;  # 初期値として現在時刻
$year += 1900;
$month++;

if (($#ARGV + 1) != 1) {
  usage;
}

my $input = $ARGV[0];
if (length($input) == 8) {
  $input =~ s/(....)(..)(..)/$1 $2 $3/g;
  ($year, $month, $day) = split(/\s+/, $input);
  $year -= 1900;
  $month--;

} elsif (length($input) == 6) {
  $input =~ s/(..)(..)(..)/$1 $2 $3/g;
  ($hour, $min, $sec) = split(/\s+/, $input);
  $year -= 1900;
  $month--;

} elsif (length($input) == 14) {
  $input =~ s/(....)(..)(..)(..)(..)(..)/$1 $2 $3 $4 $5 $6/g;
  ($year, $month, $day, $hour, $min, $sec) = split(/\s+/, $input);
  $year -= 1900;
  $month--;

} else {
  usage;
}

my $epoch = timelocal($sec, $min, $hour, $day, $month, $year);
print "$epoch\n";
