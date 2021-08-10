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

.. _man_pkcs11-tokens:

pkcs11-tokens - 列出PKCS#11的可用符号
---------------------------------------------

概要
~~~~~~~~

:program:`pkcs11-tokens` [**-m** module] [**-v**]

描述
~~~~~~~~~~~

``pkcs11-tokens`` 列出PKCS#11可用符号，缺省来自应用初始化时所执行
的槽/符号扫描。

参数
~~~~~~~~~

**-m** module
   指定PKCS#11提供者模块。这必须是为设备实现PKCS#11 API的一个共享
   库对象的完整路径。

**-v**
   使PKCS#11 libisc初始化可见。

参见
~~~~~~~~

:manpage:`pkcs11-destroy(8)`, :manpage:`pkcs11-keygen(8)`, :manpage:`pkcs11-list(8)`
