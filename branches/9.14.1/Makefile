# Copyright (C) 2004-2007  Internet Systems Consortium, Inc. ("ISC")
# Copyright (C) 2001, 2002  Internet Software Consortium.
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND ISC DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS.  IN NO EVENT SHALL ISC BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
# OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

# $Id: Makefile.in,v 1.12.18.8 2007/08/28 07:20:03 tbox Exp $

srcdir =	.

top_srcdir =	../..

# Copyright (C) 2004-2008  Internet Systems Consortium, Inc. ("ISC")
# Copyright (C) 1998-2003  Internet Software Consortium.
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND ISC DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS.  IN NO EVENT SHALL ISC BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
# OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

# $Id: rules.in,v 1.47.18.15 2008/02/18 23:46:01 tbox Exp $

###
### Common Makefile rules for BIND 9.
###

###
### Paths
###
### Note: paths that vary by Makefile MUST NOT be listed
### here, or they won't get expanded correctly.

prefix =	/usr/local
exec_prefix =	${prefix}
bindir =	${exec_prefix}/bin
sbindir =	${exec_prefix}/sbin
includedir =	${prefix}/include
libdir =	${exec_prefix}/lib
sysconfdir =	/etc
localstatedir =	/var
mandir =	${prefix}/share/man

DESTDIR =



top_builddir =	/home/sun/bind-9.6.1

###
### All
###
### Makefile may define:
###	TARGETS

all: subdirs ${TARGETS}

###
### Subdirectories
###
### Makefile may define:
###	SUBDIRS

ALL_SUBDIRS = ${SUBDIRS} nulldir

#
# We use a single-colon rule so that additional dependencies of
# subdirectories can be specified after the inclusion of this file.
# The "depend" target is treated the same way.
#
subdirs:
	@for i in ${ALL_SUBDIRS}; do \
		if [ "$$i" != "nulldir" -a -d $$i ]; then \
			echo "making all in `pwd`/$$i"; \
			(cd $$i; ${MAKE} ${MAKEDEFS} DESTDIR="${DESTDIR}" all) || exit 1; \
		fi; \
	done

install:: all

install clean distclean maintainer-clean doc docclean man manclean::
	@for i in ${ALL_SUBDIRS}; do \
		if [ "$$i" != "nulldir" -a -d $$i ]; then \
			echo "making $@ in `pwd`/$$i"; \
			(cd $$i; ${MAKE} ${MAKEDEFS} DESTDIR="${DESTDIR}" $@) || exit 1; \
		fi; \
	done

###
### C Programs
###
### Makefile must define
###	CC
### Makefile may define
###	CFLAGS
###	LDFLAGS
###	CINCLUDES
###	CDEFINES
###	CWARNINGS
### User may define externally
###     EXT_CFLAGS

CC = 		gcc
CFLAGS =	-g -O2
LDFLAGS =	
STD_CINCLUDES =	
STD_CDEFINES =	 -D_GNU_SOURCE
STD_CWARNINGS =	 -W -Wall -Wmissing-prototypes -Wcast-qual -Wwrite-strings -Wformat -Wpointer-arith -fno-strict-aliasing

BUILD_CC = gcc
BUILD_CFLAGS = -g -O2
BUILD_CPPFLAGS =  -D_GNU_SOURCE 
BUILD_LDFLAGS = 
BUILD_LIBS = -lnsl 

.SUFFIXES:
.SUFFIXES: .c .o

ALWAYS_INCLUDES = -I${top_builddir}
ALWAYS_DEFINES = 
ALWAYS_WARNINGS =

ALL_CPPFLAGS = \
	${ALWAYS_INCLUDES} ${CINCLUDES} ${STD_CINCLUDES} \
	${ALWAYS_DEFINES} ${CDEFINES} ${STD_CDEFINES}

ALL_CFLAGS = ${EXT_CFLAGS} ${ALL_CPPFLAGS} ${CFLAGS} \
	${ALWAYS_WARNINGS} ${STD_CWARNINGS} ${CWARNINGS}

.c.o:
	${LIBTOOL_MODE_COMPILE} ${CC} ${ALL_CFLAGS} -c $<

SHELL = /bin/sh
LIBTOOL = 
LIBTOOL_MODE_COMPILE = ${LIBTOOL} 
LIBTOOL_MODE_INSTALL = ${LIBTOOL} 
LIBTOOL_MODE_LINK = ${LIBTOOL} 
PURIFY = 

MKDEP = ${SHELL} ${top_builddir}/make/mkdep

cleandir: distclean
superclean: maintainer-clean

clean distclean maintainer-clean::
	rm -f *.o *.o *.lo *.la core *.core .depend *.aux *.cb *.cb2 *.idx *.glo *.toc *.log *.bbl *.unicode
	rm -rf .libs

distclean maintainer-clean::
#	rm -f Makefile

depend:
	@for i in ${ALL_SUBDIRS}; do \
		if [ "$$i" != "nulldir" -a -d $$i ]; then \
			echo "making depend in `pwd`/$$i"; \
			(cd $$i; ${MAKE} ${MAKEDEFS} DESTDIR="${DESTDIR}" $@) || exit 1; \
		fi; \
	done
	@if [ X"${SRCS}" != X -a X"${PSRCS}" != X ] ; then \
		echo ${MKDEP} ${ALL_CPPFLAGS} ${SRCS}; \
		${MKDEP} ${ALL_CPPFLAGS} ${SRCS}; \
		echo ${MKDEP} -ap ${ALL_CPPFLAGS} ${PSRCS}; \
		${MKDEP} -ap ${ALL_CPPFLAGS} ${PSRCS}; \
		${DEPENDEXTRA} \
	elif [ X"${SRCS}" != X ] ; then \
		echo ${MKDEP} ${ALL_CPPFLAGS} ${SRCS}; \
		${MKDEP} ${ALL_CPPFLAGS} ${SRCS}; \
		${DEPENDEXTRA} \
	elif [ X"${PSRCS}" != X ] ; then \
		echo ${MKDEP} ${ALL_CPPFLAGS} ${PSRCS}; \
		${MKDEP} -p ${ALL_CPPFLAGS} ${PSRCS}; \
		${DEPENDEXTRA} \
	fi

FORCE:

###
### Libraries
###

AR =		/usr/bin/ar
ARFLAGS =	cruv
RANLIB =	ranlib

###
### Installation
###

INSTALL =		/usr/bin/install -c
INSTALL_PROGRAM =	${INSTALL}
LINK_PROGRAM =		ln -s
INSTALL_SCRIPT =	${INSTALL}
INSTALL_DATA =		${INSTALL} -m 644

###
### Programs used when generating documentation.  It's ok for these
### not to exist when not generating documentation.
###

XSLTPROC =		/usr/bin/xsltproc --novalid --xinclude --nonet
PERL =			/usr/bin/perl
LATEX =			/usr/local/texlive/2015/bin/x86_64-linux/latex
#PDFLATEX =		/usr/local/texlive/2015/bin/x86_64-linux/pdflatex
PDFLATEX =		/Library/TeX/texbin/pdflatex
DBLATEX =		/usr/bin/dblatex
W3M =			/usr/bin/w3m
XELATEX =		/usr/bin/xelatex

GBKFILE=dig host
UTF8FILE = dig host

###
### DocBook -> HTML
### DocBook -> man page
###

.SUFFIXES: .docbook .html .1 .2 .3 .4 .5 .6 .7 .8

.docbook.html:
	${XSLTPROC} -o $@ ${top_srcdir}/doc/xsl/isc-docbook-html.xsl $<

.docbook.1:
	${XSLTPROC} -o $@ ${top_srcdir}/doc/xsl/isc-manpage.xsl $<

.docbook.2:
	${XSLTPROC} -o $@ ${top_srcdir}/doc/xsl/isc-manpage.xsl $<

.docbook.3:
	${XSLTPROC} -o $@ ${top_srcdir}/doc/xsl/isc-manpage.xsl $<

.docbook.4:
	${XSLTPROC} -o $@ ${top_srcdir}/doc/xsl/isc-manpage.xsl $<

.docbook.5:
	${XSLTPROC} -o $@ ${top_srcdir}/doc/xsl/isc-manpage.xsl $<

.docbook.6:
	${XSLTPROC} -o $@ ${top_srcdir}/doc/xsl/isc-manpage.xsl $<

.docbook.7:
	${XSLTPROC} -o $@ ${top_srcdir}/doc/xsl/isc-manpage.xsl $<

.docbook.8:
	${XSLTPROC} -o $@ ${top_srcdir}/doc/xsl/isc-manpage.xsl $<

docbooks=dig-utf8.docbook host-utf8.docbook delv-utf8.docbook \
	dnssec-checkds-utf8.docbook \
	dnssec-coverage-utf8.docbook dnssec-keygen-utf8.docbook \
	dnssec-revoke-utf8.docbook dnssec-settime-utf8.docbook \
	dnssec-signzone-utf8.docbook named-checkconf-utf8.docbook \
	dnssec-verify-utf8.docbook \
	dnssec-importkey-utf8.docbook \
	named-checkzone-utf8.docbook named-utf8.docbook \
	rndc-utf8.docbook rndc.conf-utf8.docbook rndc-confgen-utf8.docbook \
	dnssec-dsfromkey-utf8.docbook \
	dnssec-keyfromlabel-utf8.docbook \
	nsupdate-utf8.docbook \
	ddns-confgen-utf8.docbook \
	named-journalprint-utf8.docbook \
	named-rrchecker-utf8.docbook \
	named-rrchecker-utf8.docbook \
	named.conf-utf8.docbook \
	lwresd-utf8.docbook \
	arpaname-utf8.docbook \
	genrandom-utf8.docbook \
	isc-hmac-fixup-utf8.docbook \
	nsec3hash-utf8.docbook \
	releaseinfo-utf8.xml \
	pkgversion-utf8.xml \
	dlz-utf8.xml \
	notes-utf8.xml \
	noteversion-utf8.xml \
	logging-categories-utf8.xml

VERSION=9.14.1

MANOBJS = Bv9ARM.html

#PDFOBJS = Bv9ARM.pdf
PDFOBJS = Bv9ARM-gbk.pdf

doc man:: ${MANOBJS} ${PDFOBJS}

clean::
	rm -f Bv9ARM.aux Bv9ARM.brf Bv9ARM.glo Bv9ARM.idx Bv9ARM.toc
	rm -f Bv9ARM.log Bv9ARM.out Bv9ARM.tex Bv9ARM.tex.tmp
	rm -f Bv9ARM-gbk.aux Bv9ARM-gbk.brf Bv9ARM-gbk.glo Bv9ARM-gbk.idx Bv9ARM-gbk.toc
	rm -f Bv9ARM-gbk.log Bv9ARM-gbk.out Bv9ARM-gbk.tex Bv9ARM-gbk.tex.tmp
	rm -f *.tmp01
	rm -f Bv9ARM-unicode.tex
	rm -f Bv9ARM-gbk.out.bak
	rm -f Bv9ARM-book-utf8.unicode.tex*
	rm -f Bv9ARM-book-utf8.utf8.tex*
	rm -f Bv9ARM-zh_CN.tex
	rm -f tmplst-idm*.tex

docclean manclean maintainer-clean:: clean
	rm -f *.html ${PDFOBJS}

docclean manclean maintainer-clean distclean::
#	rm -f releaseinfo-utf8.xml
#	rm -f noteversion-utf8.xml

Bv9ARM.html: Bv9ARM-book.xml releaseinfo.xml
	expand Bv9ARM-book.xml | \
	${XSLTPROC} --stringparam root.filename Bv9ARM \
		${top_srcdir}/doc/xsl/isc-docbook-chunk.xsl -

Bv9ARM-gbk.html: Bv9ARM-book-utf8.xml releaseinfo-utf8.xml \
	${docbooks} dnssec-utf8.xml managed-keys-utf8.xml pkcs11-utf8.xml
	expand Bv9ARM-book-utf8.xml | \
	${XSLTPROC} --stringparam root.filename Bv9ARM-cn \
		isc-docbook-chunk.xsl -

Bv9ARM.tex: Bv9ARM-book.xml releaseinfo.xml
	expand Bv9ARM-book.xml | \
	${XSLTPROC} ${top_srcdir}/doc/xsl/pre-latex.xsl - | \
	${XSLTPROC} ${top_srcdir}/doc/xsl/isc-docbook-latex.xsl - | \
	/usr/bin/perl latex-fixup.pl >$@.tmp 
	if test -s $@.tmp; then mv $@.tmp $@; else rm -f $@.tmp; exit 1; fi

Bv9ARM-unicode.tex: Bv9ARM-book-utf8.xml releaseinfo-utf8.xml ${docbooks} \
	dnssec-utf8.xml managed-keys-utf8.xml pkcs11-utf8.xml libdns-utf8.xml
	expand Bv9ARM-book-utf8.xml | \
	${XSLTPROC} pre-latex.xsl - | \
	${XSLTPROC} isc-docbook-latex.xsl - | \
	/usr/bin/perl latex-fixup.pl >$@.tmp 
	if test -s $@.tmp; then mv $@.tmp $@; else rm -f $@.tmp; exit 1; fi

Bv9ARM.dvi: Bv9ARM.tex releaseinfo.xml
	rm -f Bv9ARM-book.aux Bv9ARM-book.dvi Bv9ARM-book.log
	${LATEX} '\batchmode\input Bv9ARM.tex' || (rm -f $@ ; exit 1)
	${LATEX} '\batchmode\input Bv9ARM.tex' || (rm -f $@ ; exit 1)
	${LATEX} '\batchmode\input Bv9ARM.tex' || (rm -f $@ ; exit 1)

Bv9ARM.pdf: Bv9ARM.tex releaseinfo.xml
	rm -f Bv9ARM-book.aux Bv9ARM-book.pdf Bv9ARM-book.log
	${PDFLATEX} '\batchmode\input Bv9ARM.tex' || (rm -f $@ ; exit 1)
	${PDFLATEX} '\batchmode\input Bv9ARM.tex' || (rm -f $@ ; exit 1)
	${PDFLATEX} '\batchmode\input Bv9ARM.tex' || (rm -f $@ ; exit 1)

Bv9ARM-gbk.tex: Bv9ARM-unicode.tex add_cjk_tex.pl foo.pl preprocess.pl
	./add_cjk_tex.pl Bv9ARM-unicode.tex > Bv9ARM-unicode.tex.tmp01
	./foo.pl Bv9ARM-unicode.tex.tmp01> Bv9ARM-gbk.tex.tmp01
	./preprocess.pl Bv9ARM-gbk.tex.tmp01> Bv9ARM-gbk.tex

#Bv9ARM-gbk.pdf: Bv9ARM-gbk.tex releaseinfo.xml 
#	rm -f Bv9ARM-book-gbk.aux Bv9ARM-gbk.pdf Bv9ARM-book-gbk.log ;\
#	${PDFLATEX} '\batchmode\input Bv9ARM-gbk.tex' ;\
#	${PDFLATEX} '\batchmode\input Bv9ARM-gbk.tex' ;\
#	/usr/local/bin/gbk2uni Bv9ARM-gbk.out ;\
#	${PDFLATEX} '\batchmode\input Bv9ARM-gbk.tex'

Bv9ARM-book-utf8.unicode.tex: Bv9ARM-book-utf8.xml releaseinfo-utf8.xml pkgversion-utf8.xml dnssec-utf8.xml managed-keys-utf8.xml pkcs11-utf8.xml dlz-utf8.xml logging-categories-utf8.xml notes-utf8.xml libdns-utf8.xml dig-utf8.docbook host-utf8.docbook delv-utf8.docbook dnssec-checkds-utf8.docbook dnssec-coverage-utf8.docbook dnssec-dsfromkey-utf8.docbook dnssec-importkey-utf8.docbook dnssec-keyfromlabel-utf8.docbook dnssec-keygen-utf8.docbook dnssec-revoke-utf8.docbook dnssec-settime-utf8.docbook dnssec-signzone-utf8.docbook dnssec-verify-utf8.docbook named-checkconf-utf8.docbook named-checkzone-utf8.docbook named-utf8.docbook named.conf-utf8.docbook lwresd-utf8.docbook named-journalprint-utf8.docbook named-rrchecker-utf8.docbook nsupdate-utf8.docbook rndc-utf8.docbook rndc.conf-utf8.docbook rndc-confgen-utf8.docbook ddns-confgen-utf8.docbook arpaname-utf8.docbook genrandom-utf8.docbook isc-hmac-fixup-utf8.docbook nsec3hash-utf8.docbook noteversion-utf8.xml
	expand $< | \
	${XSLTPROC} pre-latex.xsl - | \
	${DBLATEX} -c Bv9ARM-CN.conf -t tex -o $@ -

Bv9ARM-book-utf8.unicode.tex.01: Bv9ARM-book-utf8.unicode.tex
	./add_cjk_tex.pl $< > $@

Bv9ARM-book-utf8.utf8.tex: Bv9ARM-book-utf8.unicode.tex.01
	./unicode2utf8.pl $< > $@

Bv9ARM-book-utf8.utf8.tex.01: Bv9ARM-book-utf8.utf8.tex version
	./preprocess_utf8.pl $< > $@

Bv9ARM-zh_CN.tex: Bv9ARM-book-utf8.utf8.tex.01
	./add_xelatex.pl $< > $@

Bv9ARM-zh_CN.pdf: Bv9ARM-zh_CN.tex
	${XELATEX} '\batchmode\input $<'; \
	${XELATEX} '\batchmode\input $<'

FORCE:

#releaseinfo.xml: FORCE
#	echo >$@ '<releaseinfo>BIND Version ${VERSION}</releaseinfo>'

#noteversion-gbk.xml: FORCE
#	echo >$@ '<title>BIND版本${VERSION}的发行注记</title>'

