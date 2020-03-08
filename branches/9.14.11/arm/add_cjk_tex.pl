#!/usr/bin/perl

while(<>) {
	chomp;
	if(/^\\begin\{document\}$/) {
		print <<EOB;

\% Handle the lines with both chinese characters and ASCII.
\\sloppy

\\begin{document}

EOB
		next;
	}
	print "$_\n";
}

=c
https://blog.csdn.net/God_68/article/details/81660294

LaTex总是尽可能产生最好的断行效果。如果断行无法达到 LaTex 的高标准，
就让这一行在段落的右侧溢出。然后在处理输入文件的同时，报告溢出的
消息（“overfull hbox”）。这最可能发生在 LaTex找不到合适的地方断字时候。
(注)你可以使用 \sloppy 命令，告诉 LaTex降低一点儿标准。虽然最终的输出
结果不是最优的，它通过增加单词之间的间隔，以防止出现过长的行。在这种
情况下给出警告（“underfull hbox”）。在大多数情况下得到的结果看起来不会
非常好。\fussy 命令把 LaTex恢复为缺省状态。
=cut

