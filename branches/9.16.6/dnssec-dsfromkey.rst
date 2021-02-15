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

``dnssec-dsfromkey`` 命令输出DS（Delegation Signer，授权签名者）资源
记录（RRs），或者带有 ``-C`` 时它输出CDS（子DS）资源记录。

输入密钥可以以数种方式指定：

缺省时， ``dnssec-dsfromkey`` 读取一个名字类似 ``Knnnn.+aaa+iiiii.key``
的密钥文件，这是由 ``dnssec-keygen`` 生成的。

带有 ``-f file`` 选项时， ``dnssec-dsfromkey`` 从一个区文件或部份区
文件（可以只包含DNSKEY记录）中读取密钥。

带有 ``-s`` 选项时， ``dnssec-dsfromkey`` 读一个 ``keyset-`` 文件，
这是由 ``dnssec-keygen`` ``-C`` 生成的。

选项
~~~~~~~

**-1**
   ``-a SHA1`` 的缩写。

**-2**
   ``-a SHA-256`` 的缩写。

**-a** algorithm
   指定一个用于转换DNSKEY记录到DS记录的摘要算法。这个选项可以重复，
   这样就为每个DNSKEY记录生成多个DS记录。

   algorithm的值必须是SHA-1，SHA-256或SHA-384之一。这些值是大小写不
   敏感的，而且连字符可以省略。如果没有指定算法，缺省是SHA-256。

**-A**
   当生成DS记录时包含ZSK。没有这个选项时，只有具有KSK标志的密钥被转
   换为DS记录并打印。仅用于 ``-f`` 区文件模式。

**-c** class
   指定DNS类（缺省是IN），仅用于 ``-s`` 密钥集合中或者 ``-f`` 区文
   件模式。

**-C**
   生成CDS记录而不是DS记录。

**-f** file
   区文件模式： ``dnssec-dsfromkey`` 的最终dnsname参数是一个其主文
   件可以从 ``file`` 中读取的区的DNS域名。如果区名与 ``file`` 相同，
   这个参数可以忽略。

   如果file为 ``"-"`` ，区数据将从标准输入读入。这使得使用 ``dig``
   命令的输出作为输入成为可能，例如：

   ``dig dnskey example.com | dnssec-dsfromkey -f - example.com``

**-h**
   打印用法信息。

**-K** directory
   在 ``directory`` 中查找密钥文件或者 ``keyset-`` 文件。

**-s**
   密钥集合模式： ``dnssec-dsfromkey`` 的最终dnsname参数是DNS域名，
   用于定位一个 ``keyset-`` 文件。

**-T** TTL
   指定DS记录的TTL。缺省时TTL是省略的。

**-v** level
   设置调试级别。

**-V**
   打印版本信息。

例子
~~~~~~~

要从 ``Kexample.com.+003+26160`` 密钥文件（keyfile）名构建SHA-256 DS
资源记录，你可以执行下列命令：

``dnssec-dsfromkey -2 Kexample.com.+003+26160``

命令将输出类似下面的内容：

``example.com. IN DS 26160 5 2 3A1EADA7A74B8D0BA86726B0C227AA85AB8BBD2B2004F41A868A54F0C5EA0B94``

文件
~~~~~

密钥文件可以由密钥标识 ``Knnnn.+aaa+iiiii`` 来指定或者是由
dnssec-keygen8所生成的完整文件名 ``Knnnn.+aaa+iiiii.key`` 。

密钥集合文件名是从 ``directory`` ，字符串 ``keyset-`` 和
``dnsname`` 中构建的。

注意
~~~~~~

即使文件存在，一个密钥文件错误也会给出一个“file not found”消息。

参见
~~~~~~~~

:manpage:`dnssec-keygen(8)`, :manpage:`dnssec-signzone(8)`, BIND 9管理员参考手册,
:rfc:`3658` (DS RRs), :rfc:`4509` (SHA-256 for DS RRs),
:rfc:`6605` (SHA-384 for DS RRs), :rfc:`7344` (CDS and CDNSKEY RRs).
