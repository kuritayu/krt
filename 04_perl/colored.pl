#!/usr/bin/env perl
# colored.pl
# 標準出力に出力された文字に色付けするツール
$| = 1; #

if ($#ARGV > 5) {
  print "please use within 6 keywords. abort.\n";
  exit(1);
}

while (<STDIN>) {
  for (my $i = 0; $i <= $#ARGV; $i++) {
    my $color = sprintf("%dm", $i + 31);
    s/$ARGV[$i]/\033\[1;$color$&\033\[0m/gi
  }
} continue {
  print $_;
}
exit(0);
