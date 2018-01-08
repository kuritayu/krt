#!/usr/bin/env perl
use strict;
use warnings;


my $file = shift;  # 処理対象ファイル
my $cpu_infos = [];  # 複数CPUの情報を格納する配列のリファレンス
my $cpu_info = {};  # CPUの情報を格納するハッシュ


die "Usage: $0 FILE" unless $file;  # 引数がない場合はusageを表示して終了

# ファイルオープン
open my $fh, '<', $file or die qq{Can't open file "$file": $!};


while (my $line = <$fh>) {  # 1行ずつ読み込む
  next if $. == 1;  # 1行目skip
  chomp $line;  # 改行削除
  my @rec = split(/\s+/, $line);  # 行情報を配列に変換(空白文字で分割)

  $cpu_info->{time} = $rec[0];
  $cpu_info->{user} = $rec[2];
  $cpu_info->{system} = $rec[4];

  push @$cpu_infos, $cpu_info;  # 配列に取得した情報を格納

}

close $fh;  # ファイルのクローズ

my @headers = qw{time %user %system};  # ヘッダ文字
print join(',', @headers) . "\n";  # ヘッダ出力

foreach my $cpu_info (@$cpu_infos) {
  my @rec = (
    $cpu_info->{time},
    $cpu_info->{user},
    $cpu_info->{system}
  );
  print join(',', @rec) . "\n";  # カンマ連結
}
