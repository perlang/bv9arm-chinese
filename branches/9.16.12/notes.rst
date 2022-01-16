.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

发行注记
=============

.. contents::

介绍
------------

BIND 9.16是BIND 的一个稳定分支。本文档汇总了此分支上自上一个产
品版本以来的重大变化。关于变化和漏洞修订的一个更详细的清单，请
参见CHANGES文件。

关于版本编号的注释
-------------------------

截止BIND 9.13/9.14，BIND 采用了“奇数-不稳定/偶数-稳定”的版本编
号规范，BIND 9.16包含了在BIND 9.15开发过程中增加的新特性。今后，
9.16 分支将被限制于漏洞修订，而新特性开发将在不稳定的9.17分支
中进行。

支持的平台
-------------------

要在类Unix系统上编译，BIND要求支持POSIX.1c线程
（IEEE Std 1003.1c-1995），关于IPv6的高级套接字API（ :rfc:`3542` ），
和由C编译器提供的标准原子操作。

在目标平台上，libuv异步I/O库和OpenSSL加密库必须是可用的。对于
公共密钥加密（即，DNSSEC签名和验证），可以使用一个PKCS#11提供
者来代替OpenSSL。但是仍然需要OpenSSL进行通常的加密操作，诸如哈
希和随机数生成。

更多信息可以在 ``PLATFORMS.md`` 文件中找到，它被包含在BIND 9的
源码发布中。如果你的编译器和系统库提供了上述特征，BIND 9就应当
能够编译和运行。如果不是这种情况，BIND开发团队通常接受补丁以支
持仍然被各自厂商支持的系统。

下载
--------

最新版本的 BIND 9软件总是可以在 https://www.isc.org/download/
找到。那里，你会发现每个版本的附加信息，源码和为微软Windows操
作系统预编译的版本。

.. include:: ./notes-9.16.12.rst
.. include:: ./notes-9.16.11.rst
.. include:: ./notes-9.16.10.rst
.. include:: ./notes-9.16.9.rst
.. include:: ./notes-9.16.8.rst
.. include:: ./notes-9.16.7.rst
.. include:: ./notes-9.16.6.rst
.. include:: ./notes-9.16.5.rst
.. include:: ./notes-9.16.4.rst
.. include:: ./notes-9.16.3.rst
.. include:: ./notes-9.16.2.rst
.. include:: ./notes-9.16.1.rst
.. include:: ./notes-9.16.0.rst

.. _relnotes_license:

许可证
-------
  
BIND 9是一个遵循 Mozilla公共许可证，版本2.0（参见 ``LICENSE``
文件获得完整文本）的开源软件。

这个许可证要求如果你修改BIND并分发到你的组织之外，这些修改必须
在同样的许可证下公开。它不要求你发布或公开你没有修改的部份。这
个要求对于使用BIND的，无论修不修改，只要没有重分发的人以及对分
发BIND但是没有修改的人没有影响。

那些希望讨论许可证遵守性的人可以在 https://www.isc.org/contact/
联系ISC。

生命周期结束
------------

BIND 9.16的生命结束日期还未决定。在未来的某个时间点BIND 9.16将
被指定为延长支持版本（ESV）。直到那时，当前的ESV是BIND 9.11，
将会至少被支持到2021年12月。参见 https://kb.isc.org/docs/aa-00896
以获取ISC的软件支持策略的详细信息。

谢谢您
---------

感谢每一个帮助我们的您，使得本版本得以发布。
