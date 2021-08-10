.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
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

**-h**
   输出用法消息并退出。

**-K** directory
   设置存放密钥文件的目录。

**-r**
   在写了新的密钥集合文件之后删去原来的密钥集合文件。

**-v** level
   设置调试级别。

**-V**
   打印版本信息。

**-E** engine
   如果适用，指定要使用的加密硬件。

   当BIND使用带OpenSSL PKCS#11支持构建时，这个缺省值是字符串“pkcs11”，
   它标识一个可以驱动一个加密加速器或硬件服务模块的OpenSSL引擎，
   当BIND使用带原生PKCS#11加密（--enable-native-pkcs11）构建时，
   它缺省是由“--with-pkcs11”指定的PKCS#11提供者库的路径。

**-f**
   强制覆盖：导致 ``dnssec-revoke`` 输出新的密钥对，即使一个与被撤
   销密钥的算法和密钥ID都匹配的文件已经存在。

**-R**
   打印带有REVOKE位的密钥的密钥标签但不激活密钥。

参见
~~~~~~~~

:manpage:`dnssec-keygen(8)`, BIND 9管理员参考手册, :rfc:`5011`.
