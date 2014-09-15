#!/usr/bin/perl

use Encode;

=c
print to_gbk(20171), "\n";
print to_gbk(32461), "\n";
exit(0);
=cut

while(<>) {
  chomp;

  # change code format from "&#xxxx;" to GBK
  # example:
  # &#20171; -> 介
  # &#32461; -> 绍
  s/\&\#(\d+);/to_gbk($1)/eg;

  # replace reference format from "Section X.Y.Z" to "第X.Y.Z节"
  s/Section\xa0\{(\\ref\{[^}]+\})\}/第$1节/g;
  #s/Section(\xa0\{\\ref\{[^}]+\}\})/第$1节/g;
  print "$_\n";
}

sub to_gbk {
  my($val) = @_;
  my($ch);

  $ch = encode("gbk", pack('U', $val));
  return($ch);
};
