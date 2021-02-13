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

.. _man_pkcs11-keygen:

pkcs11-keygen - 在一个PKCS#11设备上生成密钥
-------------------------------------------------

概要
~~~~~~~~

:program:`pkcs11-keygen` [**-a** algorithm] [**-b** keysize] [**-e**] [**-i** id] [**-m** module] [**-P**] [**-p** PIN] [**-q**] [**-S**] [**-s** slot] label

描述
~~~~~~~~~~~

``pkcs11-keygen`` 使PKCS#11设备用给定的 ``label`` （必须唯一）和
``keysize`` 位素数生成一个新的密钥对。

参数
~~~~~~~~~

**-a** algorithm
   指定密钥的算法类：支持的类是RSA，DSA，DH，ECC和ECX。除了这些
   字符串， ``algorithm`` 也可被指定为一个DNSSEC签名算法；例如，
   NSEC3RSASHA1映射到RSA，ECDSAP256SHA256到ECC，ED25519到ECX。缺
   省类是“RSA”。

**-b** keysize
   使用 ``keysize`` 位的素数建立密钥对。对ECC密钥，仅有的有效值
   是256和384，缺省是256。对ECX密钥，仅有的有效值是256和456，缺
   省是256。

**-e**
   仅对RSA密钥，使用一个大的指数。

**-i** id
   使用id创建密钥对象。id是一个无符号2字节短整数或一个无符号4字
   节长整数之一。

**-m** module
   指定PKCS#11提供者模块。这必须是为设备实现PKCS#11 API的一个共
   享库对象的完整路径。

**-P**
   设置新的私钥为不敏感和可提取的。这允许私钥数据可以被PKCS#11设
   备读取。缺省对私钥是敏感和不可提取的。

**-p** PIN
   为设备指定PIN。如果在命令行没有提供PIN， ``pkcs11-keygen`` 将
   会提示输入。

**-q**
   安静模式：阻止不必要的输出。

**-S**
   仅对Diffie-Hellman(DH)密钥，使用一个特定的768位，1024位或者
   1536位素数和基数（也称为生成器）2。如果未指定，缺省大小为1024
   位。

**-s** slot
   使用给定的PKCS#11槽打开会话。缺省是槽0。

参见
~~~~~~~~

:manpage:`pkcs11-destroy(8)`, :manpage:`pkcs11-list(8)`, :manpage:`pkcs11-tokens(8)`, :manpage:`dnssec-keyfromlabel(8)`
