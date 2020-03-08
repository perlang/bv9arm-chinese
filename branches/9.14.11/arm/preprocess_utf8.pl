#!/usr/bin/perl

# preprocess.pl

use FileHandle;

undef($/);

$_ = <>;

# comment "\newif\ifpdf" and add \RequirePackage{ifpdf}
s/(\\newif\\ifpdf)\n(\\ifx\\pdfoutput\\undefined)\n(\\pdffalse % we are not running PDFLaTeX)\n(\\else)\n(\\pdfoutput=1 % we are running PDFLaTeX)\n(\\pdftrue)\n(\\fi)\n/%$1\n%$2\n%$3\n%$4\n%$5\n%$6\n%$7\n\\RequirePackage\{ifpdf\}\n/;

# add "CJKbookmarks" parameter to command usepackage{hyperref}
s/(\\ifpdf)\n(\\usepackage\[pdftex,bookmarksnumbered,colorlinks,backref,bookmarks,breaklinks,linktocpage,plainpages=false,pdfstartview=FitH\]\{hyperref\})\n(\\else)\n(\\usepackage\[bookmarksnumbered,colorlinks,backref,bookmarks,breaklinks,linktocpage,plainpages=false,\]\{hyperref\})\n(\\fi)\n/$1\n\\usepackage\[pdftex,CJKbookmarks,bookmarksnumbered,colorlinks,backref,bookmarks,breaklinks,linktocpage,plainpages=false,pdfstartview=FitH\]\{hyperref\}\n$3\n$4\n$5\n/;

my($ver) = readfile('docversion');
# add "Copyright" for chinese version
s/(\\tableofcontents)/\n\n\\begin\{center\}Copyright \\copyright\{\} 2008-2020 本文档中文版权归sunguonian\@gmail.com所有\\end\{center\}\n\\begin\{center\}\n\n允许任何个人、任何组织以任何目的、任何形式付费或免费使用，拷贝，修改和分发\n本文档，前提是需要在所有拷贝中出现上述的版权声明和本许可声明。\n\n版本号：$ver\\end\{center\}\n\n$1/;

# replace 10pt font with 11pt font. line 19/21 in Bv9ARM-gbk.tex
# for ASCII characters, 11pt is too large
# need to enlarge chinese characters only.
#s/,10(pt,twoside,openright,\]\{report\})/,11$1/g;

# handle char 0xd8(216, \330) at A.1.1, "Oivind Kure"
s/\xd8ivind Kure/\{\\O\}ivind Kure/;

# handle reference to xxx Section
s/Section\~(\\ref\{[\d\w\_\-]+})/第$1节/g;

# expand bookmark for Appendix B
s/\\section\K\*\{(?!(Name|\\docbook))/\{/g;
s/\\section\*\{\KName/名字/g;
s/\\subsection\*\{\KSynopsis/概要/g;

# replace \emph{<string_with_chinese_character>} with
#   {\heiti <string_with_chinese_character>}
# <string_with_chinese_character> is 3 bytes UTF-8 1110xxxx 10xxxxxx 10xxxxxx
# TODO: it is needed to handle more than 3bytes character.
#
#s/\\emph\{((([\xe0-\xef][\x80-\xbf]{2})|[\w\d .\-_\n])+)}/\{\\heiti $1}/mg;
#s/\\emph\{((([\xe0-\xef][\x80-\xbf]{2})|[\w\d .\\\#\-_\n\{\}\(\)])+)}/\{\\heiti $1}/mg;
#s/\\emph\{((([\xe0-\xef][\x80-\xbf]{2})|[\w\d .\\\#\-_\n\()])+)}/\{\\heiti $1}/mg;
s/\\emph\{((([\xe0-\xef][\x80-\xbf]{2})|[\w\d .\\\#\-_\n\()]|(\{\}))+)}/\{\\heiti $1}/mg;
# need to handle 
#  \emph{PKCS\#11 URI方案 (draft-{}pechanec-{}pkcs11uri-{}13)}。

# fix the 'note' icon disappear,
# from version 9.10.4, while use docbook 5.0 and <simpara>
s/\\begin\{DBKadmonition\}\{\}\{Note\}/\\begin\{DBKadmonition\}\{note\}\{Note\}/g;

# handle NOTE/WARNING box
s/\{Note\}/\{注意\}/g;
s/\{Warning\}/\{警告\}/g;
s/\{SEE ALSO\}/\{参见\}/g;
s/\{DESCRIPTION\}/\{描述\}/g;

print "$_";

sub readfile {
	my($file) = @_;
	my($fh) = FileHandle->new("<$file");
	my($ver) = <$fh>;
	chomp($ver);
	$fh->close();
	return($ver);
}
