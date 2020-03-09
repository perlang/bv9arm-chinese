# Copyright (C) Internet Systems Consortium, Inc. ("ISC")
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# See the COPYRIGHT file distributed with this work for additional
# information regarding copyright ownership.

AC_INIT(BIND, [9.14], [info@isc.org], [], [https://www.isc.org/downloads/BIND/])
AC_PREREQ([2.60])

#AM_INIT_AUTOMAKE([foreign -Wall -Werror])

#AC_CONFIG_HEADER(config.h)
#AC_CONFIG_MACRO_DIR([m4])

AC_CANONICAL_HOST
AC_USE_SYSTEM_EXTENSIONS

LFS_CFLAGS=`getconf LFS_CFLAGS 2>/dev/null`
LFS_LDFLAGS=`getconf LFS_LDFLAGS 2>/dev/null`
LFS_LIBS=`getconf LFS_LIBS 2>/dev/null`

AC_SUBST([LFS_CFLAGS])
AC_SUBST([LFS_LDFLAGS])
AC_SUBST([LFS_LIBS])


AC_PROG_MAKE_SET



#
# Make very sure that these are the first files processed by
# config.status, since we use the processed output as the input for
# AC_SUBST_FILE() substitutions in other files.
#
#AC_CONFIG_FILES([make/rules make/includes])

AC_PATH_PROG(AR, ar)
ARFLAGS="cruv"
AC_SUBST(AR)
AC_SUBST(ARFLAGS)



#
# Perl is optional; it is used only by some of the system test scripts.
# Note: the backtrace feature (see below) uses perl to build the symbol table,
# but it still compiles without perl, in which case an empty table will be used.
#
AC_PATH_PROGS(PERL, perl5 perl)
AC_SUBST(PERL)

AX_PROG_PERL_MODULES(YAML, , AC_MSG_WARN(Need Perl modules))


#
# File name extension for static archive files, for those few places
# where they are treated differently from dynamic ones.
#
#SA=a

#AC_SUBST(O)
#AC_SUBST(A)
#AC_SUBST(SA)
#AC_SUBST(LIBTOOL_MKDEP_SED)
#AC_SUBST(LIBTOOL_MODE_COMPILE)
#AC_SUBST(LIBTOOL_MODE_INSTALL)
#AC_SUBST(LIBTOOL_MODE_LINK)
#AC_SUBST(LIBTOOL_MODE_UNINSTALL)

#BIND9_CO_RULE=".c.$O:"
#AC_SUBST(BIND9_CO_RULE)

#
# The following sections deal with tools used for formatting
# the documentation.  They are all optional, unless you are
# a developer editing the documentation source.
#

#
# Look for TeX.
#

AC_PATH_PROGS(LATEX, latex, latex)
AC_SUBST(LATEX)

AC_PATH_PROGS(XELATEX, xelatex, xelatex)
AC_SUBST(XELATEX)

AC_PATH_PROGS(PDFLATEX, pdflatex, pdflatex)
AC_SUBST(PDFLATEX)

AC_PATH_PROGS(DBLATEX, dblatex, dblatex)
AC_SUBST(DBLATEX)

#
# Look for w3m
#

AC_PATH_PROGS(W3M, w3m, w3m)
AC_SUBST(W3M)

#
# Look for pandoc
#
AC_PATH_PROG(PANDOC, pandoc, pandoc)
AC_SUBST(PANDOC)


#
# Look for xsltproc (libxslt)
#

AC_PATH_PROG(XSLTPROC, xsltproc, xsltproc)
AC_SUBST(XSLTPROC)

#
# Look for xmllint (libxml2)
#

AC_PATH_PROG(XMLLINT, xmllint, xmllint)
AC_SUBST(XMLLINT)

#
# Look for Doxygen
#

AC_PATH_PROG(DOXYGEN, doxygen, doxygen)
AC_SUBST(DOXYGEN)

#
# Look for curl
#

AC_PATH_PROG(CURL, curl, curl)
AC_SUBST(CURL)

#
# Subroutine for searching for an ordinary file (e.g., a stylesheet)
# in a number of directories:
#
#   NOM_PATH_FILE(VARIABLE, FILENAME, DIRECTORIES)
#
# If the file FILENAME is found in one of the DIRECTORIES, the shell
# variable VARIABLE is defined to its absolute pathname.  Otherwise,
# it is set to FILENAME, with no directory prefix (that's not terribly
# useful, but looks less confusing in substitutions than leaving it
# empty).  The variable VARIABLE will be substituted into output files.
#

AC_DEFUN([NOM_PATH_FILE], [
$1=""
AC_MSG_CHECKING(for $2)
for d in $3
do
	f=$d/$2
	if test -f $f
	then
		$1=$f
		AC_MSG_RESULT($f)
		break
	fi
done
if test "X[$]$1" = "X"
then
	AC_MSG_RESULT("not found");
	$1=$2
fi
AC_SUBST($1)
])

#
# Look for Docbook-XSL stylesheets.  Location probably varies by system.
# If it's not explicitly specified, guess where it might be found, based on
# where SGML stuff lives on some systems (FreeBSD is the only one we're sure
# of at the moment).
#
AC_MSG_CHECKING(for Docbook-XSL path)
AC_ARG_WITH(docbook-xsl,
	    AS_HELP_STRING([--with-docbook-xsl[=PATH]],
			   [specify path for Docbook-XSL stylesheets]),
   docbook_path="$withval", docbook_path="auto")
case "$docbook_path" in
auto)
	AC_MSG_RESULT(auto)
	docbook_xsl_trees="/usr/pkg/share/xsl/docbook /usr/local/share/xsl/docbook-ns /usr/local/share/xsl/docbook /usr/share/xsl/docbook /usr/share/sgml/docbook/xsl-stylesheets /opt/local/share/xsl/docbook-xsl /opt/local/share/xsl/docbook-xsl-nons /usr/share/xml/docbook/stylesheet/docbook-xsl"
	;;
*)
	docbook_xsl_trees="$withval"
	AC_MSG_RESULT($docbook_xsl_trees)
	;;
esac

#
# Look for stylesheets we need.
#

NOM_PATH_FILE(XSLT_DOCBOOK_STYLE_HTML, html/docbook.xsl, $docbook_xsl_trees)
NOM_PATH_FILE(XSLT_DOCBOOK_STYLE_XHTML, xhtml/docbook.xsl, $docbook_xsl_trees)
NOM_PATH_FILE(XSLT_DOCBOOK_STYLE_MAN, manpages/docbook.xsl, $docbook_xsl_trees)
NOM_PATH_FILE(XSLT_DOCBOOK_CHUNK_HTML, html/chunk.xsl, $docbook_xsl_trees)
NOM_PATH_FILE(XSLT_DOCBOOK_CHUNK_XHTML, xhtml/chunk.xsl, $docbook_xsl_trees)
NOM_PATH_FILE(XSLT_DOCBOOK_CHUNKTOC_HTML, html/chunktoc.xsl, $docbook_xsl_trees)
NOM_PATH_FILE(XSLT_DOCBOOK_CHUNKTOC_XHTML, xhtml/chunktoc.xsl, $docbook_xsl_trees)
NOM_PATH_FILE(XSLT_DOCBOOK_MAKETOC_HTML, html/maketoc.xsl, $docbook_xsl_trees)
NOM_PATH_FILE(XSLT_DOCBOOK_MAKETOC_XHTML, xhtml/maketoc.xsl, $docbook_xsl_trees)



#
# Substitutions
#
#AC_SUBST(BIND9_TOP_BUILDDIR)
#BIND9_TOP_BUILDDIR=`pwd`

#AC_SUBST(BIND9_ISC_BUILDINCLUDE)
#AC_SUBST(BIND9_ISCCC_BUILDINCLUDE)
#AC_SUBST(BIND9_ISCCFG_BUILDINCLUDE)
#AC_SUBST(BIND9_DNS_BUILDINCLUDE)
#AC_SUBST(BIND9_NS_BUILDINCLUDE)
#AC_SUBST(BIND9_BIND9_BUILDINCLUDE)
#AC_SUBST(BIND9_IRS_BUILDINCLUDE)
#if test "X$srcdir" != "X"; then
#	BIND9_ISC_BUILDINCLUDE="-I${BIND9_TOP_BUILDDIR}/lib/isc/include"
#	BIND9_ISCCC_BUILDINCLUDE="-I${BIND9_TOP_BUILDDIR}/lib/isccc/include"
#	BIND9_ISCCFG_BUILDINCLUDE="-I${BIND9_TOP_BUILDDIR}/lib/isccfg/include"
#	BIND9_DNS_BUILDINCLUDE="-I${BIND9_TOP_BUILDDIR}/lib/dns/include"
#	BIND9_NS_BUILDINCLUDE="-I${BIND9_TOP_BUILDDIR}/lib/ns/include"
#	BIND9_BIND9_BUILDINCLUDE="-I${BIND9_TOP_BUILDDIR}/lib/bind9/include"
#	BIND9_IRS_BUILDINCLUDE="-I${BIND9_TOP_BUILDDIR}/lib/irs/include"
#else
#	BIND9_ISC_BUILDINCLUDE=""
#	BIND9_ISCCC_BUILDINCLUDE=""
#	BIND9_ISCCFG_BUILDINCLUDE=""
#	BIND9_DNS_BUILDINCLUDE=""
#	BIND9_NS_BUILDINCLUDE=""
#	BIND9_BIND9_BUILDINCLUDE=""
#	BIND9_IRS_BUILDINCLUDE=""
#fi

#AC_SUBST_FILE(BIND9_MAKE_INCLUDES)
#BIND9_MAKE_INCLUDES=$BIND9_TOP_BUILDDIR/make/includes

#AC_SUBST_FILE(BIND9_MAKE_RULES)
#BIND9_MAKE_RULES=$BIND9_TOP_BUILDDIR/make/rules

. "./version-zh_CN"
BIND9_PRODUCT="PRODUCT=\"${PRODUCT}\""
AC_SUBST(BIND9_PRODUCT)
BIND9_DESCRIPTION="DESCRIPTION=\"${DESCRIPTION}\""
AC_SUBST(BIND9_DESCRIPTION)
BIND9_VERSION="${MAJORVER}.${MINORVER}${PATCHVER:+.}${PATCHVER}${RELEASETYPE}${RELEASEVER}${EXTENSIONS}"
AC_SUBST(BIND9_VERSION)
BIND9_MAJOR="MAJOR=${MAJORVER}.${MINORVER}"
AC_SUBST(BIND9_MAJOR)
BIND9_VERSIONSTRING="${PRODUCT} ${MAJORVER}.${MINORVER}${PATCHVER:+.}${PATCHVER}${RELEASETYPE}${RELEASEVER}${EXTENSIONS}${DESCRIPTION:+ }${DESCRIPTION}"
AC_SUBST(BIND9_VERSIONSTRING)
BIND9_VERSIONSHORT="${PRODUCT} ${MAJORVER}.${MINORVER}${PATCHVER:+.}${PATCHVER}${RELEASETYPE}${RELEASEVER}${EXTENSIONS}"
AC_SUBST(BIND9_VERSIONSHORT)
BIND9_DOCVERSION="${DOCVERSION}"
AC_SUBST(BIND9_DOCVERSION)

BIND9_SRCID="SRCID=unset_id"
if test -f "${srcdir}/srcid"; then
	. "${srcdir}/srcid"
	BIND9_SRCID="SRCID=$SRCID"
elif test -d "${srcdir}/.git"; then
	BIND9_SRCID="SRCID="`(cd "${srcdir}";git rev-parse --short HEAD)`
fi

AC_SUBST(BIND9_SRCID)

if test -z "$ac_configure_args"; then
	BIND9_CONFIGARGS="defaults"
else
	for a in $ac_configure_args
	do
		BIND9_CONFIGARGS="$BIND9_CONFIGARGS $a"
	done
fi
BIND9_CONFIGARGS="`echo $BIND9_CONFIGARGS | sed 's/^ //'`"
BIND9_CONFIGARGS="CONFIGARGS=${BIND9_CONFIGARGS}"
AC_SUBST(BIND9_CONFIGARGS)



#
# Commands to run at the end of config.status.
# Don't just put these into configure, it won't work right if somebody
# runs config.status directly (which autoconf allows).
#

#AC_CONFIG_COMMANDS(
#	[chmod],
#	[chmod a+x isc-config.sh doc/doxygen/doxygen-input-filter])
AC_CONFIG_COMMANDS(
	[chmod],
	[chmod a+x arm/*.pl])

#
# Files to configure.  These are listed here because we used to
# specify them as arguments to AC_OUTPUT.  It's (now) ok to move these
# elsewhere if there's a good reason for doing so.
#

AC_CONFIG_FILES([
	Makefile
	arm/Makefile
	arm/noteversion-zh_CN.xml
	arm/pkgversion-zh_CN.xml
	arm/releaseinfo-zh_CN.xml
	arm/docversion
	arm/unicode2utf8.pl
	arm/add_xelatex.pl
	arm/add_cjk_tex.pl
	arm/preprocess_utf8.pl
	tex/Makefile
	tex/armstyle.sty
	xsl/Makefile
	xsl/isc-docbook-chunk.xsl
	xsl/isc-docbook-html.xsl
	xsl/isc-manpage.xsl
	xsl/isc-notes-html.xsl
])

#
# Do it
#

AC_OUTPUT

#
# Now that the Makefiles exist we can ensure that everything is rebuilt.
#
AC_ARG_WITH(make-clean,
	    AS_HELP_STRING([--with-make-clean],
			   [run "make clean" at end of configure [yes|no]]),
    make_clean="$withval", make_clean="yes")
case "$make_clean" in
yes)
	if test "yes" != "$no_create"
	then
		if test "yes" = "$silent"
		then
			make clean > /dev/null
		else
			make clean
		fi
	fi
	;;
esac
