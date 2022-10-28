# Copyright (C) Internet Systems Consortium, Inc. ("ISC")
#
# SPDX-License-Identifier: MPL-2.0
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0.  If a copy of the MPL was not distributed with this
# file, you can obtain one at https://mozilla.org/MPL/2.0/.
#
# See the COPYRIGHT file distributed with this work for additional
# information regarding copyright ownership.

#
# Defining the version in m4 requires a bit of dancing around,
# so the strings are properly concatenated, as you can't use
# a shell variable in AC_INIT
#
m4_define([bind_VERSION_MAJOR], 9)dnl
m4_define([bind_VERSION_MINOR], 18)dnl
m4_define([bind_VERSION_PATCH], 4)dnl
m4_define([bind_VERSION_EXTRA], )dnl
m4_define([bind_DESCRIPTION], [(Stable Release)])dnl
#m4_define([bind_SRCID], [m4_esyscmd_s([git rev-parse --short HEAD | cut -b1-7])])dnl
m4_define([bind_PKG_VERSION], [[bind_VERSION_MAJOR.bind_VERSION_MINOR.bind_VERSION_PATCH]bind_VERSION_EXTRA])dnl

#
# Autoconf initialization
#
AC_INIT([BIND], bind_PKG_VERSION, [https://gitlab.isc.org/isc-projects/bind9/-/issues/new?issuable_template=Bug], [], [https://www.isc.org/downloads/])
AC_PREREQ([2.69])

AC_DEFINE([PACKAGE_VERSION_MAJOR], ["][bind_VERSION_MAJOR]["], [BIND 9 Major part of the version])
AC_DEFINE([PACKAGE_VERSION_MINOR], ["][bind_VERSION_MINOR]["], [BIND 9 Minor part of the version])
AC_DEFINE([PACKAGE_VERSION_PATCH], ["][bind_VERSION_PATCH]["], [BIND 9 Patch part of the version])
AC_DEFINE([PACKAGE_VERSION_EXTRA], ["][bind_VERSION_EXTRA]["], [BIND 9 Extra part of the version])
AC_DEFINE([PACKAGE_DESCRIPTION], [m4_ifnblank(bind_DESCRIPTION, [" ]bind_DESCRIPTION["], [])], [An extra string to print after PACKAGE_STRING])
#AC_DEFINE([PACKAGE_SRCID], ["][bind_SRCID]["], [A short hash from git])

bind_CONFIGARGS="${ac_configure_args:-default}"
AC_DEFINE_UNQUOTED([PACKAGE_CONFIGARGS], ["$bind_CONFIGARGS"], [Either 'defaults' or used ./configure options])

AC_DEFINE([PACKAGE_BUILDER], ["make"], [make or Visual Studio])

#
# Get the Canonical System Type
#
AC_CANONICAL_BUILD
AC_CANONICAL_HOST
AC_CANONICAL_TARGET

#AC_CONFIG_SRCDIR([bin/named/main.c])
AM_INIT_AUTOMAKE([1.14 tar-pax foreign subdir-objects dist-xz no-dist-gzip -Wall -Werror])
AM_SILENT_RULES([yes])
AM_EXTRA_RECURSIVE_TARGETS([test unit doc])

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([m4])

#
# Enable maintainer mode by default only when building from git repository
# and not cross compling
#
#AS_IF([test "$cross_compiling" = no],
#      [AM_MAINTAINER_MODE(m4_ifset([bind_SRCID],[enable],[disable]))],
#      [AM_MAINTAINER_MODE([disable])])

#
# Enable system extensions to C and POSIX
#
AC_USE_SYSTEM_EXTENSIONS

#
# Compiler compatibility flags
#
m4_version_prereq([2.70],
		  [AC_PROG_CC],
		  [AC_PROG_CC_C99])
AC_PROG_CPP_WERROR

#
# Find build compiler when cross compiling
#
AX_PROG_CC_FOR_BUILD

#
# Find the machine's endian flavor.
#
AC_C_BIGENDIAN

# Enable RFC 3542 APIs on macOS
AC_DEFINE([__APPLE_USE_RFC_3542], [1], [Select RFC3542 IPv6 API on macOS])

AC_PROG_MAKE_SET

# Checks for programs.
m4_ifdef([AM_PROG_AR], [AM_PROG_AR]) # call AM_PROG_AR only if available

AC_PROG_INSTALL
AC_PROG_LN_S
AX_POSIX_SHELL
AC_PROG_MKDIR_P

# Initialize libtool
LT_INIT([disable-static dlopen pic-only])

AS_IF([test "$enable_static" != "no" && test "$enable_developer" != "yes"],
      [AC_MSG_ERROR([Static linking is not supported as it disables dlopen() and certain security features (e.g. RELRO, ASLR)])])

#
# Set the default CFLAGS, CPPFLAGS, and LDFLAGS
#
STD_CFLAGS="-Wall -Wextra -Wwrite-strings -Wpointer-arith -Wno-missing-field-initializers -Wformat -Wshadow"

# These should be always errors
STD_CFLAGS="$STD_CFLAGS -Werror=implicit-function-declaration -Werror=missing-prototypes -Werror=format-security -Werror=parentheses -Werror=implicit -Werror=strict-prototypes -Werror=vla"

STD_LDFLAGS=""

# ... except in test code
TEST_CFLAGS="-Wno-vla"

# Fortify the sources by default
STD_CPPFLAGS="-D_FORTIFY_SOURCE=2"

#
# Additional compiler settings.
#
AX_CHECK_COMPILE_FLAG([-fno-strict-aliasing],
		      [STD_CFLAGS="$STD_CFLAGS -fno-strict-aliasing"])
# Clang only issues a warning so use -Werror to force a error.
AX_CHECK_COMPILE_FLAG([-Werror -fno-delete-null-pointer-checks],
		      [STD_CFLAGS="$STD_CFLAGS -fno-delete-null-pointer-checks"])
AX_CHECK_COMPILE_FLAG([-fdiagnostics-show-option],
		      [STD_CFLAGS="$STD_CFLAGS -fdiagnostics-show-option"])

AX_CHECK_LINK_FLAG([-Wl,--export-dynamic],
		   [STD_LDFLAGS="$STD_LDFLAGS -Wl,--export-dynamic"])

host_macos=no
AS_CASE([$host],[*-darwin*],[host_macos=yes])
AM_CONDITIONAL([HOST_MACOS], [test "$host_macos" = "yes"])

#
# Change defaults for developers if not explicity set.
# Needs to be before the option is tested.
#
# [pairwise: --enable-developer, --disable-developer]
AC_ARG_ENABLE([developer],
	      [AS_HELP_STRING([--enable-developer],
			      [enable developer build settings])])

AS_IF([test "$enable_developer" = "yes"],
      [DEVELOPER_MODE=yes
       STD_CPPFLAGS="$STD_CPPFLAGS -DISC_MEM_DEFAULTFILL=1 -DISC_MEM_TRACKLINES=1 -DISC_LIST_CHECKINIT=1"
       test "${enable_fixed_rrset+set}" = set || enable_fixed_rrset=yes
       test "${enable_querytrace+set}" = set || enable_querytrace=yes
       test "${with_cmocka+set}" = set || with_cmocka=yes
       test "${with_zlib+set}" = set || with_zlib=yes
       test "${enable_warn_error+set}" = set || enable_warn_error=yes
       ])

AC_SUBST([DEVELOPER_MODE])
AC_SUBST([STD_CFLAGS])
AC_SUBST([STD_CPPFLAGS])
AC_SUBST([STD_LDFLAGS])
AC_SUBST([TEST_CFLAGS])

# [pairwise: --enable-warn-error, --disable-warn-error]
AC_ARG_ENABLE([warn_error],
	      [AS_HELP_STRING([--enable-warn-error],
			      [turn on -Werror when compiling])],
	      [],[enable_warn_error=no])
AS_IF([test "$enable_warn_error" = "yes"],
      [STD_CFLAGS="$STD_CFLAGS -Werror"])


#
# Perl is optional; it is used only by some of the system test scripts.
#
AC_PATH_PROGS([PERL], [perl5 perl])
AC_SUBST([PERL])
AM_CONDITIONAL([HAVE_PERL], [test -n "$PERL"])

AX_PERL_MODULE([Digest::HMAC])
AM_CONDITIONAL([HAVE_PERLMOD_DIGEST_HMAC],
	       [test "$HAVE_PERLMOD_DIGEST__HMAC" = "yes"])

AX_PERL_MODULE([File::Fetch])
AM_CONDITIONAL([HAVE_PERLMOD_FILE_FETCH],
	       [test "$HAVE_PERLMOD_FILE__FETCH" = "yes"])

AX_PERL_MODULE([Net::DNS])
AM_CONDITIONAL([HAVE_PERLMOD_NET_DNS],
	       [test "$HAVE_PERLMOD_NET__DNS" = "yes"])

AX_PERL_MODULE([Net::DNS::Nameserver])
AM_CONDITIONAL([HAVE_PERLMOD_NET_DNS_NAMESERVER],
	       [test "$HAVE_PERLMOD_NET__DNS__NAMESERVER" = "yes"])

AX_PERL_MODULE([Time::HiRes])
AM_CONDITIONAL([HAVE_PERLMOD_TIME_HIRES],
	       [test "$HAVE_PERLMOD_TIME__HIRES" = "yes"])

#
# Python is optional, it is used only by some of the system test scripts.
#
AM_PATH_PYTHON([3.6], [], [:])
AM_CONDITIONAL([HAVE_PYTHON], [test "$PYTHON" != ":"])

AC_PATH_PROGS([PYTEST], [pytest-3 py.test-3 pytest py.test pytest-pypy], [])
AS_IF([test -z "$PYTEST"],
      [AC_MSG_WARN([pytest not found, some system tests will be skipped])])
AC_SUBST([PYTEST])
AM_CONDITIONAL([HAVE_PYTEST], [test -n "$PYTEST"])

AX_PYTHON_MODULE([dns])
AM_CONDITIONAL([HAVE_PYMOD_DNS], [test "$HAVE_PYMOD_DNS" = "yes"])





#
# The following sections deal with tools used for formatting
# the documentation.  They are all optional, unless you are
# a developer editing the documentation source.
#

#
# Look for sphinx-build
#
AC_ARG_VAR([SPHINX_BUILD], [path to sphinx-build binary used to build the documentation])
AC_PATH_PROG([SPHINX_BUILD], [sphinx-build], [:])
AM_CONDITIONAL([HAVE_SPHINX_BUILD], [test "$SPHINX_BUILD" != ":"])

AC_PATH_PROG([XELATEX], [xelatex], [:])
AC_PATH_PROG([LATEXMK], [latexmk], [:])
AM_CONDITIONAL([HAVE_XELATEX], [test "$XELATEX" != ":" && test "$LATEXMK" != ":"])

#
# Pull release date from CHANGES file last modification date
# for reproducible builds
#
release_date=`date -u -r CHANGES +%Y-%m-%d`
AC_SUBST([RELEASE_DATE], $release_date)




#
# Files to configure.  These are listed here because we used to
# specify them as arguments to AC_OUTPUT.
#

# Top

AC_CONFIG_FILES([Makefile])

# Documentation

AC_CONFIG_FILES([doc/Makefile
		 doc/arm/Makefile
		 doc/manpages/Makefile
		 doc/misc/Makefile])


#
# Do it
#

AC_OUTPUT

# [pairwise: --enable-full-report, --disable-full-report]
AC_ARG_ENABLE(full-report,
	      AS_HELP_STRING([--enable-full-report],
			     [report values of all configure options]))

report() {
    echo "==============================================================================="
    echo "Configuration summary:"
    echo "-------------------------------------------------------------------------------"
    echo "Optional features enabled:"
    if test "yes" = "$with_jemalloc"; then
	echo "    Memory allocator: jemalloc"
    fi
    if test "yes" = "$enable_full_report" -o "standard" = "$with_locktype"; then
	echo "    Mutex lock type: $with_locktype"
    fi
    test "small" = "$with_tuning" && echo "    Small-system tuning (--with-tuning)"
    test "no" = "$enable_dnstap" || \
	    echo "    Allow 'dnstap' packet logging (--enable-dnstap)"
    test -z "$MAXMINDDB_LIBS" || echo "    GeoIP2 access control (--enable-geoip)"
    test -z "$GSSAPI_LIBS" || echo "    GSS-API (--with-gssapi)"

    # these lines are only printed if run with --enable-full-report
    if test "yes" = "$enable_full_report"; then
	test -z "$LIBXML2_LIBS" || echo "    XML statistics (--with-libxml2)"
	test -z "$JSON_C_LIBS" || echo "    JSON statistics (--with-json-c): $JSON_C_CFLAGS $JSON_C_LIBS"
	test -z "$ZLIB_LIBS" || echo "    HTTP zlib compression (--with-zlib)"
	test -z "$LMDB_LIBS" || echo "    LMDB database to store configuration for 'addzone' zones (--with-lmdb)"
	test -z "$LIBIDN2_LIBS" || echo "    IDN support (--with-libidn2)"
    fi

    test "yes" = "$enable_dnsrps" && \
	echo "    DNS Response Policy Service interface (--enable-dnsrps)"
    test "yes" = "$enable_fixed_rrset" && \
	echo "    Allow 'fixed' rrset-order (--enable-fixed-rrset)"
    test "yes" = "$enable_querytrace" && \
	echo "    Very verbose query trace logging (--enable-querytrace)"
    test "yes" = "$enable_singletrace" && \
	echo "    Single-query trace logging (--enable-singletrace)"
    test -z "$HAVE_CMOCKA" || echo "    CMocka Unit Testing Framework (--with-cmocka)"

    test "auto" = "$validation_default" && echo "    DNSSEC validation active by default (--enable-auto-validation)"

    echo "-------------------------------------------------------------------------------"

    echo "Features disabled or unavailable on this platform:"
    if test "no" = "$with_jemalloc"; then
      echo "    Memory allocator: system"
      echo
      echo "    +------------------------------------------+"
      echo "    |             ==== WARNING ====            |"
      echo "    |                                          |"
      echo "    | This is NOT a recommended configuration. |"
      echo "    | Using the system memory allocator causes |"
      echo "    | reduced performance and increased memory |"
      echo "    | fragmentation. Installing the jemalloc   |"
      echo "    | memory allocator (version >= 4.0.0) is   |"
      echo "    | strongly recommended.                    |"
      echo "    +------------------------------------------+"
      echo
    fi
    test "small" = "$with_tuning" || echo "    Small-system tuning (--with-tuning)"

    test "no" = "$enable_dnstap" && \
	    echo "    Allow 'dnstap' packet logging (--enable-dnstap)"
    test -z "$MAXMINDDB_LIBS" && echo "    GeoIP2 access control (--enable-geoip)"
    test -z "$GSSAPI_LIBS" && echo "    GSS-API (--with-gssapi)"

    test "no" = "$enable_dnsrps" && \
	echo "    DNS Response Policy Service interface (--enable-dnsrps)"

    test "yes" = "$enable_fixed_rrset" || \
	echo "    Allow 'fixed' rrset-order (--enable-fixed-rrset)"

    test "yes" = "$validation_default" && echo "    DNSSEC validation requires configuration (--enable-auto-validation)"

    test "yes" = "$enable_querytrace" || \
	echo "    Very verbose query trace logging (--enable-querytrace)"
    test "yes" = "$enable_singletrace" || \
	echo "    Single-query trace logging (--enable-singletrace)"

    test "no" = "$with_cmocka" && echo "    CMocka Unit Testing Framework (--with-cmocka)"

    test -z "$LIBXML2_LIBS" && echo "    XML statistics (--with-libxml2)"
    test -z "$JSON_C_LIBS" && echo "    JSON statistics (--with-json-c)"
    test -z "$ZLIB_LIBS" && echo "    HTTP zlib compression (--with-zlib)"
    test -z "$LMDB_LIBS" && echo "    LMDB database to store configuration for 'addzone' zones (--with-lmdb)"
    test -z "$LIBIDN2_LIBS" && echo "    IDN support (--with-libidn2)"

    echo "-------------------------------------------------------------------------------"
    echo "Configured paths:"
    echo "    prefix: $prefix"
    echo "    sysconfdir: $sysconfdir"
    echo "    localstatedir: $localstatedir"
    echo "-------------------------------------------------------------------------------"
    echo "Compiler: $CC"
    AS_IF([test "$GCC" = "yes"],
	  [$CC --version 2>&1 | sed 's/^/    /'],
	  [AS_CASE([$host],
		   [*-solaris*],[$CC -V 2>&1 | sed 's/^/    /'],
		   [$CC --version 2>&1 | sed 's/^/    /'])])
    echo "CFLAGS: $STD_CFLAGS $CFLAGS"
    echo "CPPFLAGS: $STD_CPPFLAGS $CPPFLAGS"
    echo "LDFLAGS: $LDFLAGS"

    if test "X$ac_unrecognized_opts" != "X"; then
	echo "-------------------------------------------------------------------------------"
	echo "Unrecognized options:"
	echo "    $ac_unrecognized_opts"
    fi

    if test "yes" != "$enable_full_report"; then
	echo "-------------------------------------------------------------------------------"
	echo "For more detail, use --enable-full-report."
    fi
    echo "==============================================================================="
}

if test "yes" != "$silent"; then
	report
fi

# Tell Emacs to edit this file in shell mode.
# Local Variables:
# mode: sh
# End:
