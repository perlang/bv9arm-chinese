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

.. _man_dnssec-revoke:

dnssec-revoke - 设置一个DNSSEC密钥中的REVOKED位
---------------------------------------------------

概要
~~~~~~~~

:program:`dnssec-revoke` [**-hr**] [**-v** level] [**-V**] [**-K** directory] [**-E** engine] [**-f**] [**-R**] {keyfile}

描述
~~~~~~~~~~~

``dnssec-revoke`` 读一个DNSSEC密钥文件，设置在 :rfc:`5011` 中定义的
密钥中的REVOKED位，并创建一对新的密钥文件，其中包含现在已撤销的密钥。

选项
~~~~~~~

``-h``
   本选项输出用法消息并退出。

``-K directory``
   本选项设置存放密钥文件的目录。

``-r``
   本选项在写了新的密钥集合文件之后删去原来的密钥集合文件。

``-v level``
   本选项设置调试级别。

``-V``
   本选项打印版本信息。

``-E engine``
   如果适用，本选项指定要使用的加密硬件。

   当BIND带有OpenSSL构建时，这需要设置成OpenSSL引擎标识符，它驱动加密加
   速器或者硬件服务模块（通常 ``pkcs11`` ）。

``-f``
   本选项指示一项强制覆盖并导致 ``dnssec-revoke`` 输出新的密钥对，即使
   一个与被撤销密钥的算法和密钥ID都匹配的文件已经存在。

``-R``
   本选项打印带有REVOKE位的密钥的密钥标签，但不激活密钥。

参见
~~~~~~~~

:manpage:`dnssec-keygen(8)`, BIND 9管理员参考手册, :rfc:`5011`.
