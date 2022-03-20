.. Copyright (C) Internet Systems Consortium, Inc. ("ISC")
..
.. SPDX-License-Identifier: MPL-2.0
..
.. This Source Code Form is subject to the terms of the Mozilla Public
.. License, v. 2.0.  If a copy of the MPL was not distributed with this
.. file, you can obtain one at https://mozilla.org/MPL/2.0/.
..
.. See the COPYRIGHT file distributed with this work for additional
.. information regarding copyright ownership.

构建BIND 9
---------------

要在一台Unix或Linux系统上构建，使用：

::

    $ autoreconf -fi ### (如果仅从git仓库构建)
    $ ./configure
    $ make

有几个环境变量影响编译，它们可以在运行 ``configure`` 之前设置。最重要
的是：

+--------------------+-------------------------------------------------+
| 变量               | 描述                                            |
+====================+=================================================+
| ``CC``             | 要使用的C编译器。 ``configure`` 试图为受支持的  |
|                    | 系统找到正确的配置。                            |
+--------------------+-------------------------------------------------+
| ``CFLAGS``         | The C编译器标志。对于支持的编译器，缺省包含 -g  |
|                    | 和/或 -O2。如果 ``CFLAGS`` 需要设置，请包含     |
|                    | ``-g`` 。                                       |
+--------------------+-------------------------------------------------+
| ``LDFLAGS``        | 链接器标志。缺省是空白字符串。                  |
+--------------------+-------------------------------------------------+

额外影响构建的环境变量在 ``configure`` 帮助文本的末尾列出，可以通过运行
下列命令而得到：

::

    $ ./configure --help

如果使用Emacs， ``make tags`` 命令可能是有帮助的。

.. _build_dependencies:

要求的库
~~~~~~~~~~~~~~~~~~

要构建BIND 9，必须安装下列的包：

- ``libcrypto``, ``libssl``
- ``libuv``
- ``perl``
- ``pkg-config`` / ``pkgconfig`` / ``pkgconf``

BIND 9.18要求 ``libuv`` 1.x或更高版本。在旧系统上，一个更新的 ``libuv``
包需要从源码安装诸如EPEL，PPA或其它原生源代码。另外的选择是从源代码构建
和安装 ``libuv`` 。

要求OpenSSL 1.0.2e或更新版本。如果OpenSSL库安装在一个非标准位置，在
``configure`` 命令行使用 ``--with-openssl=<PREFIX>`` 指定前缀。要为密码
操作使用一个PKCS#11硬件服务模块，必须编译和使用来自OpenSC项目的
``engine_pkcs11`` 。

要构建来自git仓库的BIND，还必须安装下列工具：

- ``autoconf`` (包括 ``autoreconf``)
- ``automake``
- ``libtool``

可选的特性
~~~~~~~~~~~~~~~~~

要查看配置选项的完整列表，运行 ``configure --help`` 。

要提高性能，强烈建议使用 ``jemalloc`` 库(http://jemalloc.net/)。

要支持 :rfc:`DNS over HTTPS (DoH) <8484>` ，服务器必须链接到
``libnghttp2`` (https://nghttp2.org/)。如果这个库不可用，可以使用
``--disable-doh`` 关闭对DoH的支持。

要支持HTTP统计通道，服务器必须链接到下列库中至少一个： ``libxml2``
(http://xmlsoft.org)或者 ``json-c``
(https://github.com/json-c/json-c)。如果它们安装在一个非标准位置，则：

- 对于 ``libxml2`` ，使用, ``--with-libxml2=/prefix`` 指定前缀，
- 对于 ``json-c`` ，调整 ``PKG_CONFIG_PATH`` 。

要支持在HTTP统计通道上的压缩，服务器必须链接到 ``zlib``
(https://zlib.net/)。如果它安装在一个非标准位置，使用
``--with-zlib=/prefix`` 指定前缀。

要支持将实时增加区的配置数据存储到一个LMDB数据库，服务器必须链接到
``liblmdb`` (https://github.com/LMDB/lmdb)。如果它安装在一个非标准位置
，使用 ``--with-lmdb=/prefix`` 指定前缀。

要支持MaxMind GeoIP2基于位置的ACL，服务器必须链接到 ``libmaxminddb``
(https://maxmind.github.io/libmaxminddb/)。如果发现了这个库，缺省会打开
支持；如果它安装在一个非标准位置，使用 ``--with-maxminddb=/prefix`` 指
定前缀。GeoIP2支持可以使用 ``--disable-geoip`` 关闭。

对于DNSTAP包日志，必须安装 ``libfstrm``
(https://github.com/farsightsec/fstrm) 和 ``libprotobuf-c``
(https://developers.google.com/protocol-buffers)，并且必须使用
``--enable-dnstap`` 配置BIND。

要在 ``dig`` 中支持国际化域名，必须安装 ``libidn2``
(https://www.gnu.org/software/libidn/#libidn2)。如果这个库安装在一个非
标准位置，使用 ``--with-libidn2=/prefix`` 指定前缀或调整
``PKG_CONFIG_PATH`` 。

对于 ``nsupdate`` 和 ``nslookup`` 中的行编辑，必须安装
``readline`` (https://tiswww.case.edu/php/chet/readline/rltop.html)或
``libedit`` 库(https://www.thrysoee.dk/editline/)。如果它们安装在一个非
标准位置，调整 ``PKG_CONFIG_PATH`` 。缺省使用 ``readline`` ，可以使用
``--with-readline=libedit`` 显式要求使用 ``libedit`` 。

某些编译内置的常量和缺省设置可以通过在 ``configure`` 命令行指定
``--with-tuning=small`` 减少到更适合小型机器，例如OpenWRT机器，的值。
这通过使用更小的数据结构减少了内存用量，但是也降低了性能。

在Linux上，使用 ``libcap`` 库
(https://git.kernel.org/pub/scm/libs/libcap/libcap.git/)管理进程功能，
它可以通过 ``libcap-dev`` 或 ``libcap-devel`` 包安装在大多数Linux系统上。
也可以通过配置 ``--disable-linux-caps`` 关闭进程功能支持。

在某些平台，需要显式要求大文件支持以处理超过2GB的文件。这个可以在
``configure`` 命令行使用 ``--enable-largefile`` 来完成。

对“固定的”资源记录集顺序选项的支持可以通过在 ``configure`` 命令行指定
``--enable-fixed-rrset`` 或 ``--disable-fixed-rrset`` 来开启或关闭。缺
省时，固定的资源记录集顺序是关闭的，以减少内存占用。

``--enable-querytrace`` 选项使得 ``named`` 在处理每个请求时记录每一个
步骤。 ``--enable-singletrace`` 选项开启同样的详细跟踪，但是通过将查询
ID设置为0，允许单独跟踪单个查询。这些选项应当只能在调试时开启，因为它
们对请求性能有严重的负面影响。

``make install`` 安装 ``named`` 和各种BIND 9库。缺省安装到/usr/local，
但是这个可以在运行 ``configure`` 时通过 ``--prefix`` 选项来修改。

可以指定 ``--sysconfdir`` 选项来设置配置文件，如 ``named.conf`` ，放置
的目录；可以使用 ``--localstatedir`` 设置 ``run/named.pid`` 的缺省父目
录。 ``--sysconfdir`` 缺省是 ``$prefix/etc`` ，而 ``--localstatedir``
缺省是 ``$prefix/var`` 。

macOS
~~~~~

在macOS上构建，假设已安装了“Command Tools for Xcode”。它们可以从
https://developer.apple.com/download/more/ 下载，或者如果已经安装了
Xcode，只需简单地运行 ``xcode-select --install`` 。（注意，要访问下载页
可能需要提供一个Apple ID。）
