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

.. highlight: console

.. _man_dnssec-checkds:

dnssec-checkds - DNSSEC授权一致性检查工具
------------------------------------------------------------

概要
~~~~~~~~

``dnssec-checkds`` [**-d**\ *dig path*] [**-D**\ *dsfromkey path*]
[**-f**\ *file*] [**-l**\ *domain*] [**-s**\ *file*] {zone}

描述
~~~~~~~~~~~

``dnssec-checkds`` 为指定区中的密钥验证授权签名者（DS）资源记录的正
确性。

选项
~~~~~~~

**-a** *algorithm*

   指定在转换区的DNSKEY记录到期待的DS记录时的摘要算法。这个选项可以
   重复，这样，对每个DNSKEY记录，将检查多个记录。

   *algorithm* 必须是SHA-1，SHA-256或SHA-384之一。这些值是大小写不
   敏感的，并且连字符可以忽略。如果未指定算法，缺省是SHA-256。

**-f** *file*

   如果指定了一个 ``file`` ，就从那个文件中读入区以查找DNSKEY记录。
   如果没有，就在DNS中查找区的DNSKEY记录。

**-s** *file*

   指定一个预先准备的dsset文件，例如由 ``dnssec-signzone`` 所生成的，
   用作DS资源记录集的来源而不是请求父域。

**-d** *dig path*

   给一个 ``dig`` 程序指定一个路径。用于测试。

**-D** *dsfromkey path*

   给一个 ``dnssec-dsfromkey`` 程序指定一个路径。用于测试。

参见
~~~~~~~~

``dnssec-dsfromkey``\ (8), ``dnssec-keygen``\ (8),
``dnssec-signzone``\ (8),
