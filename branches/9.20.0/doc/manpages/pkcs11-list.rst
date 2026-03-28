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

.. _man_pkcs11-list:

pkcs11-list - 列出PKCS#11对象
----------------------------------

:program:`pkcs11-list` [**-P**] [**-m** module] [**-s** slot] [**-i** ID **] [-l** label] [**-p** PIN]

描述
~~~~~~~~~~~

``pkcs11-list`` 列出带有 ``ID`` 或 ``label`` 的PKCS#11对象，或者
缺省的所有对象。对所有密钥，显示对象类，标签和ID。对私钥，也显示
可提取性属性，即 ``true`` 、 ``false`` 或 ``never`` 。

选项
~~~~~~~~~

``-P``
   本选项仅列出公共对象。（注意在某些PKCS#11设备上，所有的对象都是私有
   的。）

``-m module``
   本选项指定PKCS#11提供者模块。这必须是为设备实现PKCS#11 API的一个共
   享库对象的完整路径。

``-s slot``
   本选项使用给定的PKCS#11槽打开会话。缺省是槽0。

``-i ID``
   本选项仅列出带有给定对象ID的密钥对象。

``-l label``
   本选项仅列出带有给定标签的密钥对象。

``-p PIN``
   本选项为设备指定 ``PIN`` 。如果在命令行没有提供 ``PIN`` ，
   ``pkcs11-list`` 将会提示输入。

参见
~~~~~~~~

:manpage:`pkcs11-destroy(8)`, :manpage:`pkcs11-keygen(8)`, :manpage:`pkcs11-tokens(8)`
