use strict;
use warnings;
use DDP;

my $patterns = [
	'\A(?:\d+\s+)?(?:.*?\()(.*?)(?:\).*?)?\Z', # ()の中身をファイルに書き出す
	];

open my $fh, '<', 'bases.txt' or die "Cannot open: $!";

my $hash;

while (<$fh>) {
  chomp;
  for my $p ( @$patterns ) {
	  if ( $_ =~ /$p/ ) {

		my ( $base, $fact );
		$fact = $1;
		$base = $_;

		my $m = eval {
			grep /$fact/, $base; # eval しないと正規表現にマッチしない文字列がきたときにエラーになる
		};

		unless($@) { # evalしてエラーがなければ実行。特定の行でエラーがでたのでトラップする必要がある。
			$base =~ s/$fact/<#>/i;
			$hash->{$_}++;
			$hash->{$_} = [$_, $base, $fact];
		}
  	}
  }
}
close($fh);

open my $fh2, '>', 'bases_proccesed.txt' or die $!;

## 原文を以下のように、原文ママ、変数部を除いた原文、変数に分解してセパレーターを入れる
## Check station (stopper 10)|Check station (<#>)|stopper 10
for my $key (keys %$hash) {
	my $line = "$hash->{$key}[0]|$hash->{$key}[1]|$hash->{$key}[2]";
	print $fh2 $line,"\n";
}
close($fh2);