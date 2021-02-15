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

.. _man_named-checkconf:

named-checkconf - named配置文件语法检查工具
---------------------------------------------------------------

概要
~~~~~~~~

:program:`named-checkconf` [**-chjlvz**] [**-p** [**-x** ]] [**-t** directory] {filename}

描述
~~~~~~~~~~~

``named-checkconf`` 检查一个 ``named`` 配置文件的语法，但是不检
查语义。将会分析配置文件及其所有包含的文件并检查语法错误，缺省
是读 ``/etc/named.conf`` 。

注意： ``named`` 在分离的分析器上下文中所读的文件，如 ``rndc.key``
和 ``bind.keys`` ，是不会自动被 ``named-checkconf`` 读取的。即
使 ``named-checkconf`` 成功，这些文件中的错误也可能导致 ``named``
启动失败。然而， ``named-checkconf`` 可以显式地检查这些文件。

选项
~~~~~~~

**-h**
   打印用法摘要并退出。

**-j**
   在装载一个区文件时，如果存在日志文件，就读入。

**-l**
   列出所有配置的区。每行输出包含区名，类（例如，IN），视图，和
   类型（例如，master或者slave）。

**-c**
   只检查“核心”配置。这个禁止装载插件模块，并导致所有针对
   ``plugin`` 语句的参数被忽略。

**-i**
   忽略在已废弃选项上的警告。

**-p**
   如果没有检测到错误，以正规形式打印 ``named.conf`` 和被包含文
   件。参见 ``-x`` 选项。

**-t** directory
   改变根到 ``directory`` ，这样在配置文件中包含的指令就象运行
   在类似的被改变了根的 ``named`` 中一样被处理。

**-v**
   打印 ``named-checkconf`` 程序的版本并退出。

**-x**
   在以规范形式打印配置文件时，通过替代为问号（‘?’）串的方式隐
   藏共享密钥。这允许 ``named.conf`` 的内容和相关的文件被共享
   ------ 例如，当提交错误报告时 ------ 而不损失私密数据。这个
   选项在不用 ``-p`` 时不能使用。

**-z**
   执行 ``named.conf`` 中所有主区的测试装载。

filename
   所要检查的配置文件的名字。如果未指定，缺省为 ``/etc/named.conf`` 。

返回值
~~~~~~~~~~~~~

``named-checkconf`` 返回一个退出状态，如果检测到错误为1，否则为0。

参见
~~~~~~~~

:manpage:`named(8)`, :manpage:`named-checkzone(8)`, BIND 9管理员参考手册。
