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

.. _man_pkcs11-destroy:

pkcs11-destroy - 销毁PKCS#11对象

概要
~~~~~~~~

:program:`pkcs11-destroy` [**-m** module] [**-s** slot] [**-i** ID] [**-l** label] [**-p** PIN] [**-w** seconds]

描述
~~~~~~~~~~~

``pkcs11-destroy`` 销毁存储于PKCS#11设备中的密钥，密钥由它们的
``ID`` 或 ``label`` 标识。

在销毁之前显示匹配的密钥。缺省时，有五秒的延迟以允许用户在销毁
发生之前中断这个过程。

参数
~~~~~~~~~

**-m** module
   指定PKCS#11提供者模块。这必须是为设备实现PKCS#11 API的一个
   共享库对象的完整路径。

**-s** slot
   使用给定的PKCS#11槽打开会话。缺省是槽0。

**-i** ID
   销毁所给对象ID的密钥。

**-l** label
   销毁所给标签的密钥。

**-p** PIN
   为设备指定PIN。如果在命令行没有提供PIN， ``pkcs11-destroy``
   将会提示输入。

**-w** seconds
   指定在执行密钥销毁之前暂停的时间，缺省是五秒。如果设置为 ``0`` ，
   销毁将会立即执行。

参见
~~~~~~~~

:manpage:`pkcs11-keygen(8)`, :manpage:`pkcs11-list(8)`, :manpage:`pkcs11-tokens(8)`
