#!/usr/bin/perl

undef($/);

$_ = <>;

$count = s/(£¬) */$1~/g;

print "$_";

print STDERR "$count\n";
