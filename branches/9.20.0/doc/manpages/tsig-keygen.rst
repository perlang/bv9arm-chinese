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


.. BEWARE: Do not forget to edit also ddns-confgen.rst!

.. iscman:: tsig-keygen
.. program:: tsig-keygen
.. _man_tsig-keygen:

tsig-keygen - TSIG密钥生成工具
-------------------------------

概要
~~~~~~~~
:program:`tsig-keygen` [**-a** algorithm] [**-h**] [name]

描述
~~~~~~~~~~~

:program:`tsig-keygen` 是一个应用程序，它为使用在 :rfc:`2845` 中定义的
TSIG(Transaction Signatures)生成密钥。例如，作为结果的密钥可以被用于加
固对一个区的动态DNS更新，或者用于 :iscman:`rndc` 命令通道。

可以在命令行指定一个域名，它将被用
作所生成密钥的名字。如果未指定名字，缺省为 ``tsig-key`` 。

选项
~~~~~~~

.. option:: -a algorithm

   本选项指定用于TSIG密钥的算法。可用的选择为：hmac-md5，hmac-sha1，
   hmac-sha224，hmac-sha256，hmac-sha384和hmac-sha512。缺省为
   hmac-sha256。选项是大小写无关的，前缀“hmac-”可以被忽略。

.. option:: -h

   本选项打印选项和参数的一个简短摘要。

参见
~~~~~~~~

:iscman:`nsupdate(1) <nsupdate>`, :iscman:`named.conf(5) <named.conf>`, :iscman:`named(8) <named>`, BIND 9管理员参考手册。
