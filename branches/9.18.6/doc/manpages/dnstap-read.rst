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

.. iscman:: dnstap-read
.. program:: dnstap-read
.. _man_dnstap-read:

dnstap-read - 以人可读的格式输出dnstap数据
------------------------------------------------------

概要
~~~~~~~~

:program:`dnstap-read` [**-m**] [**-p**] [**-x**] [**-y**] {file}

描述
~~~~~~~~~~~

:program:`dnstap-read` 从一个指定文件中读入 ``dnstap`` 数据并以人可读的
格式输出它。缺省时， ``dnstap`` 数据是以简短的概括格式输出，但是
如果指定 :option:`-y` 选项，就使用一个更长并且更详细的YAML格式。

选项
~~~~~~~

.. option:: -m

   本选项指示跟踪内存分配；用于调试内存泄漏。

.. option:: -p

   在输出 ``dnstap`` 数据之后，本选项以文本格式输出封装在 ``dnstap`` 帧
   中的DNS消息。

.. option:: -x

   在打印 ``dnstap`` 数据之后，本选项打印封装在 ``dnstap`` 帧中的DNS消
   息的线上格式的十六进制转码。

.. option:: -y

   本选项以详细YAML格式输出 ``dnstap`` 数据。

参见
~~~~~~~~

:iscman:`named(8) <named>`, :iscman:`rndc(8) <rndc>`, BIND 9管理员参考手册。
