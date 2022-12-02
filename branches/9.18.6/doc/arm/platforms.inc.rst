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

.. _supported_os:

支持的平台
-------------------

当前不同平台上对BIND 9版本的支持状态可以在ISC的知识库中找到：

https://kb.isc.org/docs/supported-platforms

通常，本版本的BIND可以在任何带有C11兼容的C编译器、RFC兼容的IPv6支持
的BSD风格套接字、POSIX兼容的线程和
:ref:`要求的库 <build_dependencies>` 的POSIX兼容的系统上构建和运行。

下列C11特性用在了BIND 9中：

-  原子操作支持，要么以C11原子的形式，要么是 **__atomic** 内置操作。

-  线程本地存储支持，要么是C11 **_Thread_local**/**thread_local** 的形
   式，要么是 **__thread** GCC扩展。

首选C11变体。

ISC定期在许多操作系统和体系结构上测试BIND，但缺乏测试所有这些系统的资
源。因此，ISC只能为一些平台提供“尽力而为”的支持。

定期测试平台
~~~~~~~~~~~~

截止到2022年7月，当前BIND 9版本在下列系统上是完全支持和经过定期测试的：

-  Debian 10, 11
-  Ubuntu LTS 18.04, 20.04, 22.04
-  Fedora 35
-  Red Hat Enterprise Linux / CentOS / Oracle Linux 7, 8
-  FreeBSD 12.3, 13.0
-  OpenBSD 7.0
-  Alpine Linux 3.16

amd64，i386，armhf和arm64等CPU架构都是完全支持的。

尽力而为
~~~~~~~~~~~

已知在下列平台上，BIND是可以构建和运行的。ISC尽一切努力修复这些平台上的
漏洞，但由于缺乏硬件、工程人员不熟悉以及其它限制因素，可能无法迅速修复。
ISC没有对这些进行定期测试。

-  macOS 10.12+
-  Solaris 11
-  NetBSD
-  仍然被厂商支持的其它Linux发行版，例如：

   -  Ubuntu 20.10+
   -  Gentoo
   -  Arch Linux

-  OpenWRT/LEDE 17.01+
-  其它CPU架构(mips, mipsel, sparc, …)

社区维护
~~~~~~~~~

这些系统可能不具有易于构建BIND所需的全部依赖项，虽然在许多情况下可以直
接从源代码编译这些依赖。社区和感兴趣的团体可能希望帮助维护，我们欢迎贡
献补丁，虽然我们不能保证一定会接受它们。所有贡献将根据对官方支持平台的
不利影响风险进行评估。

-  超过或接近其各自的生存期的平台，例如：

   -  Ubuntu 14.04, 16.04 (不再支持Ubuntu ESM版本)
   -  CentOS 6
   -  Debian 8 Jessie, 9 Stretch
   -  FreeBSD 10.x, 11.x

不支持的平台
---------------------

在这些平台上，当前版本的BIND 9都是 **不能** 构建或运行的：

-  不包含至少OpenSSL 1.0.2的平台
-  Windows
-  Solaris 10及更旧版本
-  不支持IPv6高级套接字API的平台 (RFC 3542)
-  （通过编译器或库）不支持原子操作的平台
-  没有NPTL（原生POSIX线程库）的Linux
-  **libuv** 无法编译的平台

安装BIND 9
----------

:ref:`build_bind` 包含了如何构建BIND 9的完整指令。

ISC `知识库 <https://kb.isc.org/>`_ 包含关于在特定平台上安装
BIND 9的许多有益的文章。
