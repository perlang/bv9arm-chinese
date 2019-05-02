#!/usr/bin/perl

while(<>) {
	chomp;
	if(/^\\begin\{document\}$/) {
		print <<EOB;

\% Handle the lines with both chinese characters and ASCII.
\%\\sloppy

\\begin{document}

EOB
		next;
	}
	print "$_\n";
}
