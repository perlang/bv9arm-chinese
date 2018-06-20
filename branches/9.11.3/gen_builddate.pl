#!/usr/bin/perl

use strict;
use FileHandle;
use Time::Local;

sub read_verfile {
	my($filename) = @_;
	my($date);
	if(-e $filename) {
		my($fh) = FileHandle->new("<$filename");
		$date = <$fh>;
		chomp($date);
		$fh->close();
	}
	else {
		$date = '';
	}
	return($date);
}

sub write_verfile {
	my($filename, $verstr) = @_;
	my($fh) = FileHandle->new(">$filename");
	print $fh "$verstr\n";
	$fh->close();
}

sub read_gitlog {
	my($curcommit);
	open(FCUR, "git log | ");
	while(<FCUR>) {
		chomp;
		if(/^Date:   / and / \+0800$/) {
			s/^Date:   //;
			s/ \+0800$//;
			$curcommit = $_;
			last;
		}
	}
	close(FCUR);
	return($curcommit);
}

my($ver) = read_verfile('version');
my($gver) = str_ver(read_gitlog());
#print "$ver, $gver\n";

if($ver eq '') {
	write_verfile('version', $gver);
}
else {
	if(compare($gver, $ver) > 0) {
		write_verfile('version', $gver);
	}
}

#Fri Jun 15 14:29:57 2018

sub compare {
	my($ver1, $ver2) = @_;
	if(ver_time($ver1) > ver_time($ver2)) {
		return(1);
	}
	elsif(ver_time($ver1) < ver_time($ver2)) {
		return(-1);
	}
	return(0);
}

sub ver_time {
	my($ver) = @_;
	my($year, $mon, $mday, $hour, $min, $sec);
	$year = substr($ver, 0, 4);
	$mon = substr($ver, 4, 2);
	$mday = substr($ver, 6, 2);
	$hour = substr($ver, 8, 2);
	$min = substr($ver, 10, 2);
	$sec = substr($ver, 12, 2);
	my($time) = timelocal($sec, $min, $hour, $mday, $mon - 1, $year);
	return($time);
}

sub str_ver {
	my($str) = @_;
	my(@arr) = split(/ /, $str);
	my($hour, $min, $sec) = split(/:/, $arr[3]);
	return(sprintf("%4d%02d%02d%02d%02d%02d", $arr[4], name2mon($arr[1]), $arr[2], $hour, $min, $sec));
}

sub name2mon {
	my($monname) = @_;
	my(%hash) = (
		'Jan' => 1,
		'Feb' => 2,
		'Mar' => 3,
		'Apr' => 4,
		'May' => 5,
		'Jun' => 6,
		'Jul' => 7,
		'Aug' => 8,
		'Sep' => 9,
		'Oct' => 10,
		'Nov' => 11,
		'Dec' => 12,
	);
	return($hash{$monname});
}

1;
