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

.. iscman:: dnssec-dsfromkey
.. program:: dnssec-dsfromkey
.. _man_dnssec-dsfromkey:

dnssec-dsfromkey - DNSSEC DS资源记录生成工具
-----------------------------------------------

概要
~~~~~~~~

:program:`dnssec-dsfromkey` [ **-1** | **-2** | **-a** alg ] [ **-C** ] [**-T** TTL] [**-v** level] [**-K** directory] {keyfile}

:program:`dnssec-dsfromkey` [ **-1** | **-2** | **-a** alg ] [ **-C** ] [**-T** TTL] [**-v** level] [**-c** class] [**-A**] {**-f** file} [dnsname]

:program:`dnssec-dsfromkey` [ **-1** | **-2** | **-a** alg ] [ **-C** ] [**-T** TTL] [**-v** level] [**-c** class] [**-K** directory] {**-s**} {dnsname}

:program:`dnssec-dsfromkey` [ **-h** | **-V** ]

描述
~~~~~~~~~~~

:program:`dnssec-dsfromkey` 命令输出DS（Delegation Signer，授权签名者）资源
记录（RRs），或者带有 :option:`-C` 时它输出CDS（子DS）资源记录。

缺省时，只转换KSK（带有标志 = 257的密钥）。 :option:`-A` 选项包含ZSK
（标志 = 256）。撤销的密钥不会被包含。

输入密钥可以以数种方式指定：

缺省时， :program:`dnssec-dsfromkey` 读取一个名字格式为
``Knnnn.+aaa+iiiii.key`` 的密钥文件，这是由 :iscman:`dnssec-keygen` 生成的。

带有 :option:`-f file <-f>` 选项时， :program:`dnssec-dsfromkey` 从一个区文件或部份区
文件（可以只包含DNSKEY记录）中读取密钥。

带有 :option:`-s` 选项时， :program:`dnssec-dsfromkey` 读一个 ``keyset-`` 文件，
这是由 :iscman:`dnssec-keygen` :option:`-C` 生成的。

选项
~~~~~~~

.. option:: -1

   本选项是 :option:`-a SHA1 <-a>` 的缩写。

.. option:: -2
   本选项是 :option:`-a SHA-256 <-a>` 的缩写。

.. option:: -a algorithm

   本选项指定一个用于转换DNSKEY记录到DS记录的摘要算法。这个选项可以重复，
   这样就为每个DNSKEY记录生成多个DS记录。

   algorithm的值必须是SHA-1，SHA-256或SHA-384之一。这些值是大小写不
   敏感的，而且连字符可以省略。如果没有指定算法，缺省是SHA-256。

.. option:: -A

   本选项指示当生成DS记录时要包含ZSK。没有这个选项时，只有具有KSK标志集
   的密钥被转换为DS记录并打印。本选项仅用于 :option:`-f` 区文件模式。

.. option:: -c class

   本选项指定DNS类；缺省是IN。本选项仅用于 :option:`-s` 密钥集合中或者 :option:`-f`
   区文件模式。

.. option:: -C

   本选项生成CDS记录而不是DS记录。

.. option:: -f file

   本选项设置区文件模式，在这个模式中 :program:`dnssec-dsfromkey` 的最终
   dnsname参数是一个区的DNS域名，该区主文件可以从 ``file`` 中读取。
   如果区名与 ``file`` 相同，这个参数可以忽略。

   如果 ``file`` 为 ``-`` ，区数据将从标准输入读入。这使得使用 :iscman:`dig`
   命令的输出作为输入成为可能，例如：

   ``dig dnskey example.com | dnssec-dsfromkey -f - example.com``

.. option:: -h

   本选项打印用法信息。

.. option:: -K directory

   本选项告诉BIND 9在 ``directory`` 中查找密钥文件或者 ``keyset-`` 文件。

.. option:: -s

   本选项开启密钥集合模式，在这个模式中 :program:`dnssec-dsfromkey` 的最终
   dnsname参数是DNS域名，用于定位一个 ``keyset-`` 文件。

.. option:: -T TTL

   本选项指定DS记录的TTL。缺省时TTL是省略的。

.. option:: -v level

   本选项设置调试级别。

.. option:: -V

   本选项打印版本信息。

例子
~~~~~~~

要从 ``Kexample.com.+003+26160`` 密钥文件构建SHA-256 DS
资源记录，可以发出下列命令：

.. option:: dnssec-dsfromkey -2 Kexample.com.+003+26160

命令将返回类似下面的内容：

.. option:: example.com. IN DS 26160 5 2 3A1EADA7A74B8D0BA86726B0C227AA85AB8BBD2B2004F41A868A54F0C5EA0B94

文件
~~~~~

密钥文件可以由密钥标识 ``Knnnn.+aaa+iiiii`` 来指定或者是由
:iscman:`dnssec-keygen` 所生成的完整文件名 ``Knnnn.+aaa+iiiii.key`` 。

密钥集合文件名是从 ``directory`` ，字符串 ``keyset-`` 和
``dnsname`` 中构建的。

注意
~~~~~~

即使文件存在，一个密钥文件错误也会给出一个“file not found”消息。

参见
~~~~~~~~

:iscman:`dnssec-keygen(8) <dnssec-keygen>`, :iscman:`dnssec-signzone(8) <dnssec-signzone>`, BIND 9管理员参考手册,
:rfc:`3658` (DS RRs), :rfc:`4509` (SHA-256 for DS RRs),
:rfc:`6605` (SHA-384 for DS RRs), :rfc:`7344` (CDS and CDNSKEY RRs).
