#!/usr/bin/env perl
# devscan.pl
# RHEL デバイススキャンツール
# 各種デバイス情報表示コマンドのラッパースクリプト
# Version: 1.00 / Y.Kurita
use strict;
use warnings;
use File::Basename;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);
my ($dvp, $blk, $mnt, $pci, $usb, $cpu);
GetOptions(
  'dvp'     => \$dvp,
  'blk'     => \$blk,
  'mnt'     => \$mnt,
  'pci'     => \$pci,
  'usb'     => \$usb,
  'cpu'     => \$cpu
);

sub colored_msg {
  my ($msg, $out) = @_;
  if ($out eq "STDOUT") {
    print STDOUT "\033\[1;31m${msg}\033\[0m\n";
  } else {
    print STDERR "\033\[1;31m${msg}\033\[0m\n";
  }
}

sub usage {
  my $script = basename($0);
  # print STDERR "usage: $script -dvp|-blk|-mnt|-pci|-usb|-cpu\n";
  my $msg = "usage: $script (-dvp|-blk|-mnt|-pci|-usb|-cpu)";
  colored_msg($msg, "STDERR");
  exit(1);
}

sub check_user {
  my $user = getpwuid($>);  # 実行ユーザ名取得
  if ($user ne "root") {    # rootユーザでない場合はエラー終了
    my $msg = "This script can't be executed only in the root user.";
    colored_msg($msg, "STDERR");
    usage();
  }
}

sub check_cmdpath {
  my $cmd = shift;            # 引数(コマンドパス)取得
  if (!(-x $cmd)) {           # コマンドに実行権限がない場合はエラー終了
    my $msg = "$cmd can't be executed.(Is it installed?)";
    colored_msg($msg, "STDERR");
    exit(2);
  }
}

sub exec_cmd {
  my $cmd = shift;          # 引数(コマンドパス)取得
  colored_msg("#----------- $cmd EXEC START!!!!! -----------#", "STDOUT");
  print `$cmd`;             # コマンド実行結果を返却
  colored_msg("#----------- $cmd EXEC  END !!!!! -----------#", "STDOUT");
}


# Main
check_user;
my $cmd;
if ($dvp) {
  $cmd = "/usr/bin/lsblk";
} elsif ($blk) {
  $cmd = "/usr/sbin/blkid";
} elsif ($mnt) {
  $cmd = "/usr/bin/findmnt";
} elsif ($pci) {
  $cmd = "/usr/sbin/lspci";
} elsif ($usb) {
  $cmd = "/usr/bin/lsusb";
} elsif ($cpu) {
  $cmd = "/usr/bin/lscpu";
} else {
  usage();
}
check_cmdpath($cmd);
exec_cmd($cmd);
