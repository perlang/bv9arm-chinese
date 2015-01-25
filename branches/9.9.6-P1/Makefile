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
	rm -f *.o *.o *.lo *.la core *.core .depend
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
LATEX =			/usr/local/texlive/2013/bin/x86_64-linux/latex
PDFLATEX =		/usr/local/texlive/2013/bin/x86_64-linux/pdflatex
W3M =			/usr/bin/w3m

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

docbooks=dig-utf8.docbook host-utf8.docbook dnssec-checkds-utf8.docbook \
	dnssec-coverage-utf8.docbook dnssec-keygen-utf8.docbook \
	dnssec-revoke-utf8.docbook dnssec-settime-utf8.docbook \
	dnssec-signzone-utf8.docbook named-checkconf-utf8.docbook \
	dnssec-verify-utf8.docbook \
	named-checkzone-utf8.docbook named-utf8.docbook \
	rndc-utf8.docbook rndc.conf-utf8.docbook rndc-confgen-utf8.docbook \
	dnssec-dsfromkey-utf8.docbook \
	dnssec-keyfromlabel-utf8.docbook \
	nsupdate-utf8.docbook \
	ddns-confgen-utf8.docbook \
	named-journalprint-utf8.docbook \
	arpaname-utf8.docbook \
	genrandom-utf8.docbook \
	isc-hmac-fixup-utf8.docbook \
	nsec3hash-utf8.docbook \
	releaseinfo-utf8.xml \
	pkgversion-utf8.xml

VERSION=9.9.6-P1

MANOBJS = Bv9ARM.html

#PDFOBJS = Bv9ARM.pdf
PDFOBJS = Bv9ARM-gbk.pdf

doc man:: ${MANOBJS} ${PDFOBJS}

clean::
	rm -f Bv9ARM.aux Bv9ARM.brf Bv9ARM.glo Bv9ARM.idx Bv9ARM.toc
	rm -f Bv9ARM.log Bv9ARM.out Bv9ARM.tex Bv9ARM.tex.tmp
	rm -f Bv9ARM-gbk.aux Bv9ARM-gbk.brf Bv9ARM-gbk.glo Bv9ARM-gbk.idx Bv9ARM-gbk.toc
	rm -f Bv9ARM-gbk.log Bv9ARM-gbk.out Bv9ARM-gbk.tex Bv9ARM-gbk.tex.tmp
	rm -f Bv9ARM-book-utf8.xml
	rm -f *utf8.docbook
	rm -f *.tmp01
	rm -f Bv9ARM-unicode.tex
	rm -f Bv9ARM-gbk.out.bak
	rm -f pkcs11-utf8.xml
	rm -f dnssec-utf8.xml
	rm -f managed-keys-utf8.xml
	rm -f libdns-utf8.xml

docclean manclean maintainer-clean:: clean
	rm -f *.html ${PDFOBJS}

docclean manclean maintainer-clean distclean::
	rm -f releaseinfo.xml

Bv9ARM.html: Bv9ARM-book.xml releaseinfo.xml
	expand Bv9ARM-book.xml | \
	${XSLTPROC} --stringparam root.filename Bv9ARM \
		${top_srcdir}/doc/xsl/isc-docbook-chunk.xsl -

Bv9ARM-book-utf8.xml: Bv9ARM-book-gbk.xml
	iconv -f gbk -t utf-8 $^ > $@

dnssec-utf8.xml: dnssec-gbk.xml
	iconv -f gbk -t utf-8 $^ > $@

managed-keys-utf8.xml: managed-keys-gbk.xml
	iconv -f gbk -t utf-8 $^ > $@

pkcs11-utf8.xml: pkcs11-gbk.xml
	iconv -f gbk -t utf-8 $^ > $@

libdns-utf8.xml: libdns-gbk.xml
	iconv -f gbk -t utf-8 $^ > $@

dig-utf8.docbook: dig-gbk.docbook
	iconv -f gbk -t utf-8 dig-gbk.docbook > dig-utf8.docbook

host-utf8.docbook: host-gbk.docbook
	iconv -f gbk -t utf-8 host-gbk.docbook > host-utf8.docbook

dnssec-checkds-utf8.docbook: dnssec-checkds-gbk.docbook
	iconv -f gbk -t utf-8 dnssec-checkds-gbk.docbook > dnssec-checkds-utf8.docbook

dnssec-coverage-utf8.docbook: dnssec-coverage-gbk.docbook
	iconv -f gbk -t utf-8 dnssec-coverage-gbk.docbook > dnssec-coverage-utf8.docbook

dnssec-dsfromkey-utf8.docbook: dnssec-dsfromkey-gbk.docbook
	iconv -f gbk -t utf-8 dnssec-dsfromkey-gbk.docbook > dnssec-dsfromkey-utf8.docbook

dnssec-keyfromlabel-utf8.docbook: dnssec-keyfromlabel-gbk.docbook
	iconv -f gbk -t utf-8 dnssec-keyfromlabel-gbk.docbook > dnssec-keyfromlabel-utf8.docbook

dnssec-keygen-utf8.docbook: dnssec-keygen-gbk.docbook
	iconv -f gbk -t utf-8 dnssec-keygen-gbk.docbook > dnssec-keygen-utf8.docbook

dnssec-revoke-utf8.docbook: dnssec-revoke-gbk.docbook
	iconv -f gbk -t utf-8 dnssec-revoke-gbk.docbook > dnssec-revoke-utf8.docbook

dnssec-settime-utf8.docbook: dnssec-settime-gbk.docbook
	iconv -f gbk -t utf-8 dnssec-settime-gbk.docbook > dnssec-settime-utf8.docbook

dnssec-signzone-utf8.docbook: dnssec-signzone-gbk.docbook
	iconv -f gbk -t utf-8 dnssec-signzone-gbk.docbook > dnssec-signzone-utf8.docbook

dnssec-verify-utf8.docbook: dnssec-verify-gbk.docbook
	iconv -f gbk -t utf-8 dnssec-verify-gbk.docbook > dnssec-verify-utf8.docbook

named-checkconf-utf8.docbook: named-checkconf-gbk.docbook
	iconv -f gbk -t utf-8 named-checkconf-gbk.docbook > named-checkconf-utf8.docbook

named-checkzone-utf8.docbook: named-checkzone-gbk.docbook
	iconv -f gbk -t utf-8 named-checkzone-gbk.docbook > named-checkzone-utf8.docbook

named-utf8.docbook: named-gbk.docbook
	iconv -f gbk -t utf-8 named-gbk.docbook > named-utf8.docbook

named-journalprint-utf8.docbook: named-journalprint-gbk.docbook
	#iconv -f gbk -t utf-8 named-journalprint-gbk.docbook > named-journalprint-utf8.docbook
	iconv -f gbk -t utf-8 $^ > $@

nsupdate-utf8.docbook: nsupdate-gbk.docbook
	iconv -f gbk -t utf-8 nsupdate-gbk.docbook > nsupdate-utf8.docbook

rndc-utf8.docbook: rndc-gbk.docbook
	iconv -f gbk -t utf-8 rndc-gbk.docbook > rndc-utf8.docbook

rndc.conf-utf8.docbook: rndc.conf-gbk.docbook
	iconv -f gbk -t utf-8 rndc.conf-gbk.docbook > rndc.conf-utf8.docbook

rndc-confgen-utf8.docbook: rndc-confgen-gbk.docbook
	iconv -f gbk -t utf-8 rndc-confgen-gbk.docbook > rndc-confgen-utf8.docbook

ddns-confgen-utf8.docbook: ddns-confgen-gbk.docbook
	iconv -f gbk -t utf-8 ddns-confgen-gbk.docbook > ddns-confgen-utf8.docbook

arpaname-utf8.docbook: arpaname-gbk.docbook
	iconv -f gbk -t utf-8 $^ > $@

genrandom-utf8.docbook: genrandom-gbk.docbook
	iconv -f gbk -t utf-8 $^ > $@

isc-hmac-fixup-utf8.docbook: isc-hmac-fixup-gbk.docbook
	iconv -f gbk -t utf-8 $^ > $@

nsec3hash-utf8.docbook: nsec3hash-gbk.docbook
	iconv -f gbk -t utf-8 $^ > $@

releaseinfo-utf8.xml: releaseinfo-gbk.xml
	iconv -f gbk -t utf-8 $^ > $@

pkgversion-utf8.xml: pkgversion-gbk.xml
	iconv -f gbk -t utf-8 $^ > $@

Bv9ARM-gbk.html: Bv9ARM-book-utf8.xml releaseinfo.xml \
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

Bv9ARM-unicode.tex: Bv9ARM-book-utf8.xml releaseinfo.xml ${docbooks} \
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

Bv9ARM-gbk.pdf: Bv9ARM-gbk.tex releaseinfo.xml
	rm -f Bv9ARM-book-gbk.aux Bv9ARM-gbk.pdf Bv9ARM-book-gbk.log ;\
	${PDFLATEX} '\batchmode\input Bv9ARM-gbk.tex' ;\
	${PDFLATEX} '\batchmode\input Bv9ARM-gbk.tex' ;\
	/usr/local/bin/gbk2uni Bv9ARM-gbk.out ;\
	${PDFLATEX} '\batchmode\input Bv9ARM-gbk.tex'

releaseinfo.xml:
	echo >$@ '<releaseinfo>BIND Version ${VERSION}</releaseinfo>'
