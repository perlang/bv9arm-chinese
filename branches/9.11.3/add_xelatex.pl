#!/usr/bin/perl

while(<>) {
	chomp;
	print "$_\n";
	if(/^\\documentclass\{book\}/) {
		print "\\usepackage\{xeCJK\}\n";
	}
	if(/^\\makeglossary/) {
		print <<EOF

\\setCJKmainfont[BoldFont={文泉驿微米黑},ItalicFont={AR PL UKai CN}]{AR PL UMing CN}
\\setCJKsansfont{文泉驿微米黑}

\\setCJKfamilyfont{zhsong}{AR PL UMing CN}
\\setCJKfamilyfont{zhhei}{Source Han Sans CN}
\\setCJKfamilyfont{zhkai}{AR PL UKai CN}

\\newcommand*{\\songti}{\\CJKfamily{zhsong}} % 宋体
\\newcommand*{\\heiti}{\\CJKfamily{zhhei}}   % 黑体

EOF
	}
	if(/^\\begin\{document\}/) {
		print "\\songti\n\n";
	}
}
