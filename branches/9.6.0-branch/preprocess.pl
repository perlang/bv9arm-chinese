#!/usr/bin/perl

# preprocess.pl

undef($/);

$_ = <>;

# comment "\newif\ifpdf" and add \RequirePackage{ifpdf}
s/(\\newif\\ifpdf)\n(\\ifx\\pdfoutput\\undefined)\n(\\pdffalse % we are not running PDFLaTeX)\n(\\else)\n(\\pdfoutput=1 % we are running PDFLaTeX)\n(\\pdftrue)\n(\\fi)\n/%$1\n%$2\n%$3\n%$4\n%$5\n%$6\n%$7\n\\RequirePackage\{ifpdf\}\n/;

# add "CJKbookmarks" parameter to command usepackage{hyperref}
s/(\\ifpdf)\n(\\usepackage\[pdftex,bookmarksnumbered,colorlinks,backref,bookmarks,breaklinks,linktocpage,plainpages=false,pdfstartview=FitH\]\{hyperref\})\n(\\else)\n(\\usepackage\[bookmarksnumbered,colorlinks,backref,bookmarks,breaklinks,linktocpage,plainpages=false,\]\{hyperref\})\n(\\fi)\n/$1\n\\usepackage\[pdftex,CJKbookmarks,bookmarksnumbered,colorlinks,backref,bookmarks,breaklinks,linktocpage,plainpages=false,pdfstartview=FitH\]\{hyperref\}\n$3\n$4\n$5\n/;

# add "Copyright" for chinese version
s/(\\tableofcontents)/\n\n\\begin\{center\}Copyright \\copyright\{\} 2008-2009 ���ĵ����İ�Ȩ��"bbs.chinaunix.net��diancn"����\\end\{center\}\n\\begin\{center\}\n\n�����κθ��ˡ��κ���֯���κ�Ŀ�ġ��κ���ʽʹ�ã��������޸ĺͷַ�\n���ĵ���ǰ������Ҫ�����п����г��������İ�Ȩ�����ͱ����������\n\\end\{center\}\n\n$1/;

# replace 10pt font with 11pt font. line 19/21 in Bv9ARM-gbk.tex
# for ASCII characters, 11pt is too large
# need to enlarge chinese characters only.
#s/,10(pt,twoside,openright,\]\{report\})/,11$1/g;

# handle char 0xd8(216, \330) at A.1.1, "Oivind Kure"
s/\xd8ivind Kure/\{\\O\}ivind Kure/;

# expand bookmark for Appendix B
s/\\section\K\*\{(?!(Name|\\docbook))/\{/g;
s/\\section\*\{\KName/����/g;
s/\\subsection\*\{\KSynopsis/��Ҫ/g;

# handle NOTE/WARNING box
s/\{Note\}/\{ע��\}/g;
s/\{Warning\}/\{����\}/g;

print "$_";
