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

.. _man_named-journalprint:

named-journalprint - 以人可读的格式打印区日志文件
--------------------------------------------------------------

概要
~~~~~~~~

:program:`named-journalprint` [**-dux**] {journal}

描述
~~~~~~~~~~~

``named-journalprint`` 扫描一个区日志文件的内容，以人可读的格式打印，
或者，可选地，转换成一种不同日志文件公式。

日志文件是在动态区有变化时（例如，通过 ``nsupdate`` ）由 ``named``
自动创建的。它们以二进制格式记录了每一个资源记录的增加和删除，允许
当服务器在宕机或崩溃之后的重启后将改变重新应用到区中。缺省时，日志
文件的名字由相应区文件的名字加上扩展名 ``.jnl`` 组成。

``named-journalprint`` 将一个给定日志文件转换为一个人可读的文本格
式。每行都以 ``add`` 或 ``del`` 开头，以指明记录是否被增加或删除，
并以主区文件格式连续放置资源记录。

``-x`` 选项在输出的开始部分和每次组变化之前打印关于日志文件的附加数据。

``-u`` （升级）和 ``-d`` （降级）选项使用一个修改后的格式版本重新创建
日志文件。现存的日志文件被替代。 ``-d`` 以9.16.11及之前的BIND版本所用
格式写日志文件； ``-u`` 以9.16.13及之后的版本所用格式写。（9.16.12被
省略，因为这个版本的日志格式中有漏洞。）注意当 ``named`` 正在运行时，
**不允许** 使用这些选项。

参见
~~~~~~~~

:manpage:`named(8)`, :manpage:`nsupdate(1)`, BIND 9管理员参考手册。
