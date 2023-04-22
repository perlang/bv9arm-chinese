#!/usr/bin/perl

my($v1) = shift;
my($v2) = shift;
print "$v1, $v2\n";

my($norm1) = norm($v1);
my($norm2) = norm($v2);
print "$norm1, $norm2\n";

my($file0) = join('_', 'di', $norm1, $norm2, '00');
print "$file0\n";

`diff -C 6 -r $v1 $v2 > $file0`;

my($file1) = join('_', 'di', $norm1, $norm2, '01');
print "$file1\n";

open(FRD, "<$file0");
open(FWR, ">$file1");
while(<FRD>) {
	chomp;
	#if(/^diff / and (/\.(docbook|ac|xml|conf\.py|Makefile.am|rst|xsl(\.in)*|sty(\.in)*)$/)) {
	if(/^diff /) {
		next if(/\.(c|h)$/);
		next if(/(ChangeLog|CHANGES|NEWS|README\.md|srcid|configure)$/);
		next if(/\.in$/ and !/config\.h\.in$/);
		next if(/\.\din$/);
		next if(/\/bin\/tests\//);
		print FWR "$_\n";
	}
}
close(FRD);
close(FWR);

chmod(0755, $file1);

my($file2) = join('_', 'di', $norm1, $norm2, '02');
print "$file2\n";
`./$file1 > $file2`;

sub norm {
	my($name) = @_;
	$name =~ s/^bind\-//;
	$name =~ s/(\.|\-)//g;
	$name =~ tr/A-Z/a-z/;
	return($name);
}
