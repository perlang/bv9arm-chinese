#!/usr/bin/perl

while(<>) {
  chomp;
  if(/^\\begin\{document\}$/) {
    print <<EOB;

\% Handle the lines with both chinese characters and ASCII.
\\sloppy

\\usepackage{CJK}
\%\\usepackage[dvips,CJKbookmarks]{hyperref}

\\begin{document}

%\\begin{CJK*}{GBK}{fang}
\\begin{CJK*}{GB}{gbsn}
\\CJKtilde

EOB
    next;
  }
  elsif(/^\\end\{document\}$/) {
    print <<EOB;
\\end{CJK*}
\\end{document}
EOB
    next;
  }
  print "$_\n";
}
