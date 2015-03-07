#!/usr/bin/perl

use Encode qw(encode_utf8 decode encode decode_utf8);

my($val) = 20171;

$ch = pack('U', $val);
$str = encode("gbk", $ch);
print "$str\n";
