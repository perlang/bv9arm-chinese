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

.. _man_dnstap-read:

dnstap-read - 以人可读的格式输出dnstap数据
------------------------------------------------------

概要
~~~~~~~~

:program:`dnstap-read` [**-m**] [**-p**] [**-x**] [**-y**] {file}

描述
~~~~~~~~~~~

``dnstap-read`` 从一个指定文件中读入 ``dnstap`` 数据并以人可读的
格式输出它。缺省时， ``dnstap`` 数据是以简短的概括格式输出，但是
如果指定 ``-y`` 选项，就会是以一个较长并且更详细的YAML格式替代。

选项
~~~~~~~

**-m**
   跟踪内存分配；用于调试内存泄漏。

**-p**
   在输出 ``dnstap`` 数据之后，以文本格式输出封装在 ``dnstap`` 帧
   中的DNS消息。

**-x**
   在打印 ``dnstap`` 数据之后，打印封装在 ``dnstap`` 帧中的DNS消
   息的线上格式的十六进制转码。

**-y**
   以详细YAML格式输出 ``dnstap`` 数据。

参见
~~~~~~~~

:manpage:`named(8)`, :manpage:`rndc(8)`, BIND 9管理员参考手册。
