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

.. iscman:: named.conf

.. highlight: console

named.conf - **named** 的配置文件
-------------------------------------

概要
~~~~~~

:program:`named.conf`

描述
~~~~~~

:file:`named.conf` 是 :iscman:`named` 的配置文件。语句用大括号括起来，并以分号结束。
语句中的子句也以分号结尾。支持常用的注释样式：

关于配置语句的完整文档，请参考BIND 9管理员参考手册的配置参考部份。

C风格: /\* \*/

C++风格: // 到行尾

Unix风格: # 到行尾

.. literalinclude:: ../misc/options

所有的这些区语句也可以设置在视图语句中。

.. literalinclude:: ../misc/primary.zoneopt
.. literalinclude:: ../misc/secondary.zoneopt
.. literalinclude:: ../misc/mirror.zoneopt
.. literalinclude:: ../misc/forward.zoneopt
.. literalinclude:: ../misc/hint.zoneopt
.. literalinclude:: ../misc/redirect.zoneopt
.. literalinclude:: ../misc/static-stub.zoneopt
.. literalinclude:: ../misc/stub.zoneopt
.. literalinclude:: ../misc/delegation-only.zoneopt
.. literalinclude:: ../misc/in-view.zoneopt

文件
~~~~~

|named_conf|

参见
~~~~~~~~

:iscman:`named(8) <named>`, :iscman:`named-checkconf(8) <named-checkconf>`, :iscman:`rndc(8) <rndc>`, :iscman:`rndc-confgen(8) <rndc-confgen>`, :iscman:`tsig-keygen(8) <tsig-keygen>`, BIND 9管理员参考手册。

