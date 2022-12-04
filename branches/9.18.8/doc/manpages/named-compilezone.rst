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

.. BEWARE: Do not forget to edit also named-checkzone.rst!

.. iscman:: named-compilezone
.. program:: named-compilezone
.. _man_named-compilezone:

named-compilezone - 区文件转换工具
----------------------------------

概要
~~~~

:program:`named-compilezone` [**-d**] [**-h**] [**-j**] [**-q**] [**-v**] [**-c** class] [**-f** format] [**-F** format] [**-J** filename] [**-i** mode] [**-k** mode] [**-m** mode] [**-M** mode] [**-n** mode] [**-l** ttl] [**-L** serial] [**-r** mode] [**-s** style] [**-S** mode] [**-t** directory] [**-T** mode] [**-w** directory] [**-D**] [**-W** mode] {**-o** filename} {zonename} {filename}

描述
~~~~~~~~~~~

:program:`named-compilezone` 检查一个区文件的语法和完整性，并且导出区
内容到一个指定格式的指定文件。它缺省应用严格的检查级别，因为导出的输出
用作一个由 :iscman:`named` 装载的实际的区文件。当手动指定其它情况时，
检查必须至少与 :iscman:`named` 配置文件中所指定的一样严格。

选项
~~~~~~~

.. option:: -d

   本选项打开调试。

.. option:: -h

   本选项打印用法摘要并退出。

.. option:: -q

   本选项设置安静模式，只设置一个退出码以指示成功或失败的结束。

.. option:: -v

   本选项打印 :iscman:`named-checkzone` 程序的版本并退出。

.. option:: -j

   本选项告诉 :iscman:`named` 在装载区文件时读日志，如果日志存在。日志文件名
   是由区文件名后加上字符串 ``.jnl`` 。

.. option:: -J filename

   本选项告诉 :iscman:`named` 在装载区文件时从给定的文件读日志，如果给定的日
   志存在。隐含 :option:`-j` 。

.. option:: -c class

   本选项指定区的类。如果未指定，就假设为 ``IN`` 。

.. option:: -i mode

   本选项对已装载区执行完整性检查。可能的模式为 ``full`` （缺省），
   ``full-sibling`` ， ``local`` ， ``local-sibling`` 和 ``none`` 。

   模式 ``full`` 检查指向A或AAAA记录的MX记录（包括区内和区外主
   机名）。模式 ``local`` 仅仅检查指向区内主机名的MX记录。

   模式 ``full`` 检查指向A或AAAA记录的SRV记录（包括区内和区外主
   机名）。模式 ``local`` 仅仅检查指向区内主机名的SRV记录。

   模式 ``full`` 检查指向A或AAAA记录的授权NS记录（包括区内和区
   外主机名）。它也检查在区内与子域所广播记录匹配的粘着地址记录。
   模式 ``local`` 仅仅检查指向区内主机名的NS记录，或者验证那些要求
   粘着记录存在，即名字服务器在一个子区中，的NS记录。

   模式 ``full-sibling`` 和 ``local-sibling`` 关闭兄弟粘着记录检查，但
   是其它方面分别与 ``full`` 和 ``local`` 相同。

   模式 ``none`` 关闭检查。

.. option:: -f format

   本选项指定区文件格式。可能的格式为 ``text`` （缺省）和 ``raw`` 。

.. option:: -F format

   本选项指定输出文件的格式。对 :iscman:`named-checkzone` ，这个不会有任何效
   果，除非它转储区的内容。

   可能的格式为 ``text`` （缺省），这是区的标准文本表示形式，和
   ``raw`` 及 ``raw=N`` ，将会以二进制格式存放区以使 :iscman:`named` 快速装载
   它。 ``raw=N`` 指定raw区文件的格式版本：如果 ``N`` 是0，raw文件可以
   被任何版本的 :iscman:`named` 读取；如果N是1，则文件只能被9.9.0或更高版本读
   取。缺省为1。

.. option:: -k mode

   本选项使用指定的失败模式执行 ``check-names`` 检查。可能的模式为
   ``fail`` （缺省）， ``warn`` 和 ``ignore`` 。

.. option:: -l ttl

   本选项为输入文件设定一个允许的最大TTL。任何一个TTL大于这个值的记录
   都会导致区被拒绝。这类似于在 :iscman:`named.conf` 中使用 ``max-zone-ttl``
   选项。

.. option:: -L serial

   当将一个区编译成 ``raw`` 格式时，本选项将头部中的"source serial"
   值设置为指定的序列号。预期这个功能主要被用于测试目的。

.. option:: -m mode

   本选项指定是否检查MX记录以查看其是否为地址。可能的模式为 ``fail`` ，
   ``warn`` （缺省）和 ``ignore`` 。

.. option:: -M mode

   本选项检查一个MX记录是否指向一个CNAME记录。可能的模式为 ``fail`` ，
   ``warn`` （缺省）和 ``ignore`` 。

.. option:: -n mode

   本选项指定是否检查NS记录以查看其是否为地址。可能的模式为 ``fail``
   （缺省）， ``warn`` 和 ``ignore`` 。

.. option:: -o filename

   本选项写区的输出到 ``filename`` 。如果 ``filename`` 是 ``-`` ，区输
   出就写到标准输出。这对 :program:`named-compilezone` 是必须的。

.. option:: -r mode

   本选项检查在DNSSEC中被当作不同的，但是在普通DNS语义上却是相等的记录。
   可能的模式为 ``fail`` ， ``warn`` （缺省）和 ``ignore`` 。

.. option:: -s style

   本选项指定导出的区文件的风格。可能的模式为 ``full`` （缺省）和
   ``relative`` 。 ``full`` 格式最适合用一个单独的脚本自动进行处理。
   relative格式对人来说更易读，因而适合手工编辑。

.. option:: -S mode

   本选项检查一个SRV记录是否指向一个CNAME记录。可能的模式为 ``fail`` ，
   ``warn`` （缺省）和 ``ignore`` 。

.. option:: -t directory

   本选项告诉 :iscman:`named` 改变根到 ``directory`` ，这样在配置文件中的
   ``include`` 指令就象运行在类似的被改变了根的 :iscman:`named` 中一样被处理。

.. option:: -T mode

   本选项检查发送方策略框架（SPF，Sender Policy Framework）记录是否存
   在并在不存在一个SPF格式的TXT记录时发出一个警告。可能的模式为
   ``warn`` （缺省）， ``ignore`` 。

.. option:: -w directory

   本选项指示 :iscman:`named` 改变目录为 ``directory`` ，这样在主文件
   ``$INCLUDE`` 指令中的相对文件名就可以工作。这与 :iscman:`named.conf` 中的
   directory子句相似。

.. option:: -D

   本选项以正式格式转储区文件。对于 :program:`named-compilezone` ，这总
   是开启的。

.. option:: -W mode

   本选项指定是否检查非终结通配符。非终结通配符几乎总是对通配符匹配算法
   （ :rfc:`4592` ）理解失败的结果。可能的模式为 ``warn`` （缺省）和
   ``ignore`` 。

.. option:: zonename

   这指示要检查的区的域名。

.. option:: filename

   这是区文件名。

返回值
~~~~~~~~~~~~~

:program:`named-compilezone` 返回一个退出状态，如果检测到错误为1，否则为0。

参见
~~~~~~~~

:iscman:`named(8) <named>`, :iscman:`named-checkconf(8) <named-checkconf>`, :iscman:`named-checkzone(8) <named-checkzone>`, :rfc:`1035`,
BIND 9管理员参考手册。
