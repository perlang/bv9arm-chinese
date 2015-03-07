#!/usr/bin/perl

undef($/);

$_ = <>;

$count = s/(£¬)/$1/g;

print "$count\n";
