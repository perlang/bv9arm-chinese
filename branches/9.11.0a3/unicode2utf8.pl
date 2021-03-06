#!/usr/bin/perl

use Encode;
use Text::Iconv;

=c
print hex_to_utf8('4ecb'), "\n";
print hex_to_utf8('7ecd'), "\n";
exit(0);
=cut

=c
print dec_to_utf8(20171), "\n";
print dec_to_utf8(32461), "\n";
exit(0);
=cut

while(<>) {
	chomp;

	# change code format from "&#xxxx;" to GBK
	# example:
	# &#20171; -> �
	# &#32461; -> �
	s/\&\#(\d+);/dec_to_utf8($1)/eg;

	# change code format from "\&\#xXXXX;" to GBK
	# example:
	# \&\#x4ecb; -> �
	# \&\#x7ecd; -> �
	s/\\\&\\\#x([a-fA-F0-9]+);/hex_to_utf8($1)/eg;

	print "$_\n";
}

sub dec_to_utf8 {
	my($val) = @_;
	my($ch);

	$ch = encode("gbk", pack('U', $val));
	$converter = Text::Iconv->new("gbk", "utf8");
	$converted = $converter->convert($ch);
	return($converted);
};

sub hex_to_utf8 {
	my($val) = @_;
	my($ch);

	my($hex) = '0x' . $val;
	#print STDERR hex($hex), "\n";
	$ch = encode("gbk", pack('U', hex($hex)));
	$converter = Text::Iconv->new("gbk", "utf8");
	$converted = $converter->convert($ch);
	return($converted);
};

1;
