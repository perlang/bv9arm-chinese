#!/usr/bin/perl -pi.org

s/(\\protected\\def\\sphinxstylestrong\s+#1\{)\\textbf\{#1\}(\})/$1\{\\heiti\{#1\}\}$2/;

=c
*** _build/sphinxlatexstyletext.sty	2021-09-22 19:59:59.000000000 +0800
--- sphinxlatexstyletext.sty	2022-01-24 21:02:13.935875611 +0800
***************
*** 42,48 ****
  \protected\def\sphinxstyletheadfamily    {\sffamily}
  \protected\def\sphinxstyleemphasis     #1{\emph{#1}}
  \protected\def\sphinxstyleliteralemphasis#1{\emph{\sphinxcode{#1}}}
! \protected\def\sphinxstylestrong       #1{\textbf{#1}}
  \protected\def\sphinxstyleliteralstrong#1{\sphinxbfcode{#1}}
  \protected\def\sphinxstyleabbreviation #1{\textsc{#1}}
  \protected\def\sphinxstyleliteralintitle#1{\sphinxcode{#1}}
--- 42,48 ----
  \protected\def\sphinxstyletheadfamily    {\sffamily}
  \protected\def\sphinxstyleemphasis     #1{\emph{#1}}
  \protected\def\sphinxstyleliteralemphasis#1{\emph{\sphinxcode{#1}}}
! \protected\def\sphinxstylestrong       #1{{\heiti{#1}}}
  \protected\def\sphinxstyleliteralstrong#1{\sphinxbfcode{#1}}
  \protected\def\sphinxstyleabbreviation #1{\textsc{#1}}
  \protected\def\sphinxstyleliteralintitle#1{\sphinxcode{#1}}
=cut
