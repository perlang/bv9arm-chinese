#!/usr/bin/perl

# preprocess.pl

undef($/);

$_ = <>;

# comment "\newif\ifpdf" and add \RequirePackage{ifpdf}
s/(\\newif\\ifpdf)\n(\\ifx\\pdfoutput\\undefined)\n(\\pdffalse % we are not running PDFLaTeX)\n(\\else)\n(\\pdfoutput=1 % we are running PDFLaTeX)\n(\\pdftrue)\n(\\fi)\n/%$1\n%$2\n%$3\n%$4\n%$5\n%$6\n%$7\n\\RequirePackage\{ifpdf\}\n/;

# add "CJKbookmarks" parameter to command usepackage{hyperref}
s/(\\ifpdf)\n(\\usepackage\[pdftex,bookmarksnumbered,colorlinks,backref,bookmarks,breaklinks,linktocpage,plainpages=false,pdfstartview=FitH\]\{hyperref\})\n(\\else)\n(\\usepackage\[bookmarksnumbered,colorlinks,backref,bookmarks,breaklinks,linktocpage,plainpages=false,\]\{hyperref\})\n(\\fi)\n/$1\n\\usepackage\[pdftex,CJKbookmarks,bookmarksnumbered,colorlinks,backref,bookmarks,breaklinks,linktocpage,plainpages=false,pdfstartview=FitH\]\{hyperref\}\n$3\n$4\n$5\n/;

# add "Copyright" for chinese version
s/(\\tableofcontents)/\n\n\\begin\{center\}Copyright \\copyright\{\} 2008-2012 本文档中文版权归sunguonian\@gmail.com（"bbs.chinaunix.net的diancn"）所有\\end\{center\}\n\\begin\{center\}\n\n允许任何个人、任何组织以任何目的、任何形式付费或免费使用，拷贝，修改和分发\n本文档，前提是需要在所有拷贝中出现上述的版权声明和本许可声明。\n\\end\{center\}\n\n$1/;

# replace 10pt font with 11pt font. line 19/21 in Bv9ARM-gbk.tex
# for ASCII characters, 11pt is too large
# need to enlarge chinese characters only.
#s/,10(pt,twoside,openright,\]\{report\})/,11$1/g;

# handle char 0xd8(216, \330) at A.1.1, "Oivind Kure"
s/\xd8ivind Kure/\{\\O\}ivind Kure/;

# expand bookmark for Appendix B
s/\\section\K\*\{(?!(Name|\\docbook))/\{/g;
s/\\section\*\{\KName/名字/g;
s/\\subsection\*\{\KSynopsis/概要/g;

# handle NOTE/WARNING box
s/\{Note\}/\{注意\}/g;
s/\{Warning\}/\{警告\}/g;

print "$_";
