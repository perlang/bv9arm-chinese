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

named-checkzone, named-compilezone - 区文件正确性检查和转换工具
-----------------------------------------------------------------------------------

概要
~~~~~~~~

:program:`named-checkzone` [**-d**] [**-h**] [**-j**] [**-q**] [**-v**] [**-c** class] [**-f** format] [**-F** format] [**-J** filename] [**-i** mode] [**-k** mode] [**-m** mode] [**-M** mode] [**-n** mode] [**-l** ttl] [**-L** serial] [**-o** filename] [**-r** mode] [**-s** style] [**-S** mode] [**-t** directory] [**-T** mode] [**-w** directory] [**-D**] [**-W** mode] {zonename} {filename}

:program:`named-compilezone` [**-d**] [**-j**] [**-q**] [**-v**] [**-c** class] [**-C** mode] [**-f** format] [**-F** format] [**-J** filename] [**-i** mode] [**-k** mode] [**-m** mode] [**-n** mode] [**-l** ttl] [**-L** serial] [**-r** mode] [**-s** style] [**-t** directory] [**-T** mode] [**-w** directory] [**-D**] [**-W** mode] {**-o** filename} {zonename} {filename}

描述
~~~~~~~~~~~

``named-checkzone`` 检查一个区文件的语法和完整性。它与 ``named``
在装载一个区时执行同样的检查。这使 ``named-checkzone`` 能在将区文
件配置到一个名字服务器之前对其进行有用的检查。

``named-compilezone`` 与 ``named-checkzone`` 相似，但是它总是以一
个特殊的格式将区的内容转储到一个特定的文件中。缺省时，它也使用更
加严格的检查级别，因为转储的输出将用作一个实际的区文件并由
``named`` 所装载。否则，在手工指定时，必须至少达到 ``named`` 配置
文件所指定的检查级别。

选项
~~~~~~~

``-d``
   本选项打开调试。

``-h``
   本选项打印用法摘要并退出。

``-q``
   本选项设置安静模式，只设置一个退出码以指示成功或失败的结束。

``-v``
   本选项打印 ``named-checkzone`` 程序的版本并退出。

``-j``
   本选项告诉 ``named`` 在装载区文件时读日志，如果日志存在。日志文件名
   是由区文件名后加上字符串 ``.jnl`` 。

``-J filename``
   本选项告诉 ``named`` 在装载区文件时从给定的文件读日志，如果给定的日
   志存在。隐含 ``-j`` 。

``-c class``
   本选项指定区的类。如果未指定，就假设为 ``IN`` 。

``-i mode``
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

``-f format``
   本选项指定区文件格式。可能的格式为 ``text`` （缺省）和 ``raw`` 。

``-F format``
   本选项指定输出文件的格式。对 ``named-checkzone`` ，这个不会有任何效
   果，除非它转储区的内容。

   可能的格式为 ``text`` （缺省），这是区的标准文本表示形式，和
   ``raw`` 及 ``raw=N`` ，将会以二进制格式存放区以使 ``named`` 快速装载
   它。 ``raw=N`` 指定raw区文件的格式版本：如果 ``N`` 是0，raw文件可以
   被任何版本的 ``named`` 读取；如果N是1，则文件只能被9.9.0或更高版本读
   取。缺省为1。

``-k mode``
   本选项使用指定的失败模式执行 ``check-names`` 检查。可能的模式为
   ``fail`` （ ``named-compilezone`` 的缺省模式）， ``warn``
   （ ``named-checkzone`` 的缺省模式）和 ``ignore`` 。

``-l ttl``
   本选项为输入文件设定一个允许的最大TTL。任何一个TTL大于这个值的记录
   都会导致区被拒绝。这类似于在 ``named.conf`` 中使用 ``max-zone-ttl``
   选项。

``-L serial``
   当将一个区编译成 ``raw`` 格式时，本选项将头部中的"source serial"
   值设置为指定的序列号。预期这个功能主要被用于测试目的。

``-m mode``
   本选项指定是否检查MX记录以查看其是否为地址。可能的模式为 ``fail`` ，
   ``warn`` （缺省）和 ``ignore`` 。

``-M mode``
   本选项检查一个MX记录是否指向一个CNAME记录。可能的模式为 ``fail`` ，
   ``warn`` （缺省）和 ``ignore`` 。

``-n mode``
   本选项指定是否检查NS记录以查看其是否为地址。可能的模式为 ``fail``
   （ ``named-compilezone`` 的缺省模式）， ``warn``
   （ ``named-checkzone`` 的缺省模式）和 ``ignore`` 。

``-o filename``
   本选项写区的输出到 ``filename`` 。如果 ``filename`` 是 ``-`` ，区输
   出就写到标准输出。这个对 ``named-compilezone`` 是必须的。

``-r mode``
   本选项检查在DNSSEC中被当作不同的，但是在普通DNS语义上却是相等的记录。
   可能的模式为 ``fail`` ， ``warn`` （缺省）和 ``ignore`` 。

``-s style``
   本选项指定导出的区文件的风格。可能的模式为 ``full`` （缺省）和
   ``relative`` 。 ``full`` 格式最适合用一个单独的脚本自动进行处理。
   relative格式对人来说更易读，因而适合手工编辑。对
   ``named-checkzone`` ，这个不会有任何效果，除非它转储区的内容。
   如果输出格式不是文本，它也没有任何意义。

``-S mode``
   本选项检查一个SRV记录是否指向一个CNAME记录。可能的模式为 ``fail`` ，
   ``warn`` （缺省）和 ``ignore`` 。

``-t directory``
   本选项告诉 ``named`` 改变根到 ``directory`` ，这样在配置文件中的
   ``include`` 指令就象运行在类似的被改变了根的 ``named`` 中一样被处理。

``-T mode``
   本选项检查发送方策略框架（SPF，Sender Policy Framework）记录是否存
   在并在不存在一个SPF格式的TXT记录时发出一个警告。可能的模式为
   ``warn`` （缺省）， ``ignore`` 。

``-w directory``
   本选项指示 ``named`` 改变目录为 ``directory`` ，这样在主文件
   ``$INCLUDE`` 指令中的相对文件名就可以工作。这与 ``named.conf`` 中的
   directory子句相似。

``-D``
   本选项以正式格式转储区文件。对 ``named-compilezone`` 这总是打开的。

``-W mode``
   本选项指定是否检查非终结通配符。非终结通配符几乎总是对通配符匹配算法
   （ :rfc:`1034` ）理解失败的结果。可能的模式为 ``warn`` （缺省）和
   ``ignore`` 。

``zonename``
   这指示要检查的区的域名。

``filename``
   这是区文件名。

返回值
~~~~~~~~~~~~~

``named-checkzone`` 返回一个退出状态，如果检测到错误为1，否则为0。

参见
~~~~~~~~

:manpage:`named(8)`, :manpage:`named-checkconf(8)`, :rfc:`1035`, BIND 9管理员参考手册。
