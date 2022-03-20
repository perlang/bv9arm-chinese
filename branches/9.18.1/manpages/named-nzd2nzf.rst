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

.. _man_named-nzd2nzf:

named-nzd2nzf - 转换一个NZD数据库到NZF文本格式
----------------------------------------------------------

概要
~~~~~~~~

:program:`named-nzd2nzf` {filename}

描述
~~~~~~~~~~~

``named-nzd2nzf`` 转换一个NZD数据库到NZF格式并输出到标准输出。这可
以用于复查由 ``rndc addzone`` 添加到 ``named`` 中的区的配置。也可
用于在从一个新版本的BIND回滚到一个旧版本时恢复旧文件格式。

参数
~~~~~~~~~

``filename``
   这是将要输出其内容的 ``.nzd`` 文件的名字。

参见
~~~~~~~~

BIND 9管理员参考手册。
