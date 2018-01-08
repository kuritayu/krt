#!/usr/bin/env perl
# chk_fstab.pl
# fstabのマウントオプションをチェックする
use strict;
use warnings;

my $fstab = "/etc/fstab";  # fstabのパス定義

open my $fh, '<', $fstab or die("Can't open $fstab\n");  # ファイルオープン

my $fstab_infos = [];      # fstabエントリーを格納する配列
while (my $line = <$fh>) {  # ファイルがEOFに到達するまでprint
  if ($line =~ /^#/) {  # コメント行は表示しない
    next;
  }
  elsif ($line =~ /^\s+$/) {  # 空行は表示しない
    next;
  }
  chomp $line;  # 改行削除
  my @rec = split(/\s+/, $line);  # 空白で分割
  my $fstab_info = {};
  $fstab_info->{dev}        = $rec[0];  # デバイス名
  $fstab_info->{mountpoint} = $rec[1];  # マウントポイント
  $fstab_info->{filesystem} = $rec[2];  # ファイルシステム
  $fstab_info->{mountopt}   = $rec[3];  # マウントオプション
  $fstab_info->{dumpflg}    = $rec[4];  # dump有無
  $fstab_info->{fsckflg}    = $rec[5];  # fsck有無

  push @$fstab_infos, $fstab_info;  # 配列に取得した情報を格納
}

close $fh;  # ファイルクローズ

print "print configuration start\n";
foreach my $fstab_info (@$fstab_infos) {
  my @rec = (
    $fstab_info->{dev},
    $fstab_info->{mountpoint},
    $fstab_info->{filesystem},
    $fstab_info->{mountopt}
  );
  print join(',', @rec) . "\n";
}
print "print configuration end\n";
