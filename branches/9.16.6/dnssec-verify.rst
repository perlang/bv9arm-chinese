.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

..
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")

   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/.

   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.


.. highlight: console

.. _man_dnssec-verify:

dnssec-verify - DNSSEC区验证工具
---------------------------------------------

概要
~~~~~~~~

:program:`dnssec-verify` [**-c** class] [**-E** engine] [**-I** input-format] [**-o** origin] [**-q**] [**-v** level] [**-V**] [**-x**] [**-z**] {zonefile}

描述
~~~~~~~~~~~

``dnssec-verify`` 验证一个区是被区中每个DNSKEY资源记录集中的算法
完整地签名，并且NSEC/NSEC3链是完整的。

选项
~~~~~~~

**-c** class
   指定区的DNS类。

**-E** engine
   如果适用，指定要使用的加密硬件。

   当BIND使用带OpenSSL PKCS#11支持构建时，这个缺省值是字符串“pkcs11”，
   它标识一个可以驱动一个加密加速器或硬件服务模块的OpenSSL引擎，当
   BIND使用带原生PKCS#11加密（--enable-native-pkcs11）构建时，它缺省
   是由“--with-pkcs11”指定的PKCS#11提供者库的路径。

**-I** input-format
   输入区文件的格式。可能的格式为 ``"text"`` （缺省）和 ``"raw"`` 。
   这个选项的主要目的是用于动态签名区，使导出的区文件以一个非文本的
   格式，其中所包含的更新可以被独立地验证。使用这个选项对非动态区没
   有更多的意义。

**-o** origin
   区原点。如果未设置，区文件的名字被当成原点。

**-v** level
   设置调试级别。

**-V**
   打印版本信息。

``-q``
   安静模式：拟制不必要的输出。没有这个选项时，运行 ``dnssec-verify``
   将打印在用的密钥数目，用于验证区是否正确签名的算法，其它状态信息。
   使用这个选项时，所有非错误输出都被拟制，只剩退出码指示是否成功。

**-x**
   只验证使用密钥签名密钥签名的DNSKEY资源记录集。没有这个标志时，假
   定DNSKEY资源记录集被所有活动的密钥签名。当设置了这个标志时，如果
   DNSKEY资源记录集未被区签名密钥签名也不成为一个错误。这对应着
   ``dnssec-signzone`` 中的 ``-x`` 选项。

**-z**
   在决定区是否被正确签名时，忽略密钥中的KSK标志。没有这个标志时，
   假设存在一个为撤销，自签名的DNSKEY，它带有对应于每种算法的KSK标
   志集，并且DNSKEY资源记录集之外的其它资源记录集都被一个没有KSK标
   志集的另一个DNSKEY所签名。

   设置了这个标志时，我们只要求对每种算法，都存在至少一个非活动的，
   自签名的DNSKEY，不管其KSK标志状态，并且其它资源记录集被一个对应
   同样算法的非活动密钥签名，这个算法包含自签名密钥；同一密钥可以
   用于两个目的。这对应着 ``dnssec-signzone`` 中的 ``-z`` 选项。

**zonefile**
   包含被签名区的文件。

参见
~~~~~~~~

:manpage:`dnssec-signzone(8)`, BIND 9 管理员参考手册, :rfc:`4033`.
