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

.. _man_named-rrchecker:

named-rrchecker - 针对单个DNS资源记录的语法检查器
--------------------------------------------------------------------

概要
~~~~~~~~

:program:`named-rrchecker` [**-h**] [**-o** origin] [**-p**] [**-u**] [**-C**] [**-T**] [**-P**]

描述
~~~~~~~~~~~

``named-rrchecker`` 从标准输入读取单个DNS资源记录并检查其在语句
构成上是否正确。

``-h`` 打印输出标准菜单。

``-o origin`` 选项指定一个用于解释记录时的原点。

``-p`` 以正规形式打印输出结果记录。如果不存在正规形式的定义，就
以未知记录格式打印记录。

``-u`` 以未知记录形式打印输出结果记录。

``-C`` ， ``-T`` 和 ``-P`` 分别打印输出已知的类，标准类型和私有
类型助记符。

参见
~~~~~~~~

:rfc:`1034`, :rfc:`1035`, :manpage:`named(8)`.
