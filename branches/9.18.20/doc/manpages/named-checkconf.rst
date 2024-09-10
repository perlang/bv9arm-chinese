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

.. iscman:: named-checkconf
.. program:: named-checkconf
.. _man_named-checkconf:

named-checkconf - named配置文件语法检查工具
---------------------------------------------------------------

概要
~~~~~~~~

:program:`named-checkconf` [**-chjlvz**] [**-p** [**-x** ]] [**-t** directory] {filename}

描述
~~~~~~~~~~~

:program:`named-checkconf` 检查一个 :iscman:`named` 配置文件的语法，但是不检
查语义。将会分析配置文件及其包含的所有文件并检查语法错误。如果未
指定文件，缺省是读 |named_conf| 。

注意： :iscman:`named` 在分离的分析器上下文中所读的文件，如 ``rndc.key``
和 ``bind.keys`` ，是不会自动被 :program:`named-checkconf` 读取的。即
使 :program:`named-checkconf` 成功，这些文件中的错误也可能导致 :iscman:`named`
启动失败。然而， :program:`named-checkconf` 可以显式地检查这些文件。

选项
~~~~~~~

.. option:: -h

   本选项打印用法摘要并退出。

.. option:: -j

   在装载一个区文件时，本选项指示 :iscman:`named` 如果存在日志文件，就读入。

.. option:: -l

   本选项列出所有配置的区。每行输出包含区名，类（例如，IN），视图，和
   类型（例如，primary或者secondary）。

.. option:: -c

   本选项指定只检查“核心”配置。这个禁止装载插件模块，并导致所有针对
   ``plugin`` 语句的参数被忽略。

.. option:: -i

   本选项忽略在已废弃选项上的警告。

.. option:: -p

   如果没有检测到错误，本选项以正规形式打印 :iscman:`named.conf` 和被包含文
   件。参见 :option:`-x` 选项。

.. option:: -t directory

   本选项指示 :iscman:`named` 改变根到 ``directory`` ，这样在配置文件中的
   ``include`` 指令就象运行在类似的被改变了根的 :iscman:`named` 中一样被处理。

.. option:: -v

   本选项打印 :program:`named-checkconf` 程序的版本并退出。

.. option:: -x

   在以规范形式打印配置文件时，本选项通过替代为问号（ ``?`` ）串的方式
   隐藏共享密钥。这允许 :iscman:`named.conf` 的内容和相关的文件被共享
   ------ 例如，当提交错误报告时 ------ 而不损失私密数据。这个
   选项在不用 :option:`-p` 时不能使用。

.. option:: -z

   本选项执行在 :iscman:`named.conf` 中所有 ``primary`` 区的测试装载。

.. option:: filename

   这指示要检查的配置文件的名字。如果未指定，缺省为 |named_conf| 。

返回值
~~~~~~~~~~~~~

:program:`named-checkconf` 返回一个退出状态，如果检测到错误为1，否则为0。

参见
~~~~~~~~

:iscman:`named(8) <named>`, :iscman:`named-checkzone(8) <named-checkzone>`, BIND 9管理员参考手册。
