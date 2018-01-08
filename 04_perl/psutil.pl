#!/usr/bin/env perl
# psutil.pl
use strict;
use warnings;
use File::Spec;

if ($#ARGV +1 != 1) {
  print "Usage: $0 PID\n";
  exit(1);
}

my $pid = $ARGV[0];
my $procpath = File::Spec->catfile('/', 'proc', $pid);
# print "$procpath\n";
my $procstat = File::Spec->catfile("$procpath", 'stat');

sub check_pid {
  my $procpath = shift;
  # print "$procpath\n";

  if (!(-d $procpath)) {
    print("PID $pid is not found. abort.\n");
    exit(1);
  }
}

check_pid $procpath;

my $p_infs = [];
# print "$procstat\n";
open my $fh, '<', $procstat or die("Can't open $procstat\n");
while (my $line = <$fh>) {
  chomp $line;
  my @rec = split(/\s+/, $line);
  my $p_inf = {};
  $p_inf->{pid}   = $rec[0];
  $p_inf->{comm}  = $rec[1];
  $p_inf->{utime} = $rec[13];
  $p_inf->{stime} = $rec[14];
  $p_inf->{vsize} = $rec[22];
  $p_inf->{rss}   = $rec[23];
  push @$p_infs, $p_inf;
}

print "pid comm CPU(USER)[SEC] CPU(SYS)[SEC] vsize[BYTE] rss[PAGE]\n";
foreach my $p_inf (@$p_infs) {
  my @rec = (
    $p_inf->{pid},
    $p_inf->{comm},
    $p_inf->{utime},
    $p_inf->{stime},
    $p_inf->{vsize},
    $p_inf->{rss}
  );
  print join(' ', @rec) . "\n";
}
