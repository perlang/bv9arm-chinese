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

.. _man_host:

host - DNS查找工具
-------------------------

概要
~~~~~~~~

:program:`host` [**-aACdlnrsTUwv**] [**-c** class] [**-N** ndots] [**-p** port] [**-R** number] [**-t** type] [**-W** wait] [**-m** flag] [ [**-4**] | [**-6**] ] [**-v**] [**-V**] {name} [server]

描述
~~~~~~~~~~~

``host`` 是一个进行DNS查找的简单工具。它通常用于转换名字到IP地址
或相反的操作。在没有给出参数或选项时， ``host`` 打印出其命令行参
数和选项的简短摘要。

``name`` 是要查找的域名。它也可以是一个点分十进制的IPv4地址或者
一个冒号分隔的IPv6地址，在这种情况下 ``host`` 缺省将会对那个地址
执行一个反向查找。 ``server`` 是一个可选参数，可以是名字服务器的
名字或IP地址， ``host`` 应该查询这个服务器，而不是
``/etc/resolv.conf`` 中的服务器或服务器列表。

选项
~~~~~~~

``-4``
   本选项指定仅使用IPv4传输请求。参见 ``-6`` 选项。

``-6``
   本选项指定仅使用IPv6传输请求。参见 ``-4`` 选项。

``-a``
   ``-a`` （“全部”）选项通常等效于 ``-v -t ANY`` 。它也影响 ``-l``
   列出区名单选项的行为。

``-A``
   ``-A`` （“几乎全部”）等效于 ``-a`` ，除了RRSIG，NSEC和NSEC3记
   录在输出时被省略之外。

``-c class``
   本选项指定请求类，它可以用于查找HS（Hesiod）或CH（Chaosnet）类的资源
   记录。缺省类是IN（Internet）。

``-C``
   本选项指示 ``named`` 应当检查一致性，意谓着 ``host`` 将向区的所有列
   出的权威服务器请求区 ``name`` 的SOA记录。列出的名字服务器是由区中能
   找到的NS记录定义的。

``-d``
   本选项打印调试跟踪信息。等效于 ``-v`` 明细选项。

``-l``
   本选项告诉 ``named`` 对区列表，意谓着 ``host`` 命令对区 ``name`` 执
   行一个区传送，并打印出NS，PTR和地址记录（A/AAAA）。

   同时， ``-l -a`` 选项打印区中全部记录。

``-N ndots``
   本选项指定出现在被当做完整名字的 ``name`` 中的点的数目。缺省值是在
   ``/etc/resolv.conf`` 中用 ``ndots`` 语句定义的值，或者为1，如果没有
   使用 ``ndots`` 语句。少于这个数目的点的名字会被解释为相对名字，并在
   ``/etc/resolv.conf`` 的 ``search`` 或 ``domain`` 指令所列的域
   名中搜索。

``-p port``
   本选项指定请求去往的服务器的端口。缺省为53。

``-r``
   本选项指定一个非递归请求；设置这个选项清除请求中的RD（递归期望）位。
   这意谓着名字服务器在收到这个请求后不会试图去解析 ``name`` 。 ``-r``
   选项使 ``host`` 能够模仿一个名字服务器的行为，通过生成非递归
   请求并期望接收这些请求的回答，这些回答可以是对其它名字服务器
   指向。

``-R number``
   本选项指定UDP请求的重试次数：如果 ``number`` 是负数或零，重试次数将
   被静默地设置为1.缺省值是1，或者 ``/etc/resolv.conf`` 中 ``attempts``
   选项的值，如果设置了这个值。

``-s``
   本选项告诉 ``named`` ，如果任何服务器响应了一个SERVFAIL， **不** 发
   送请求到下一个名字服务器，这与普通的存根解析器行为相反。

``-t type``
   本选项指定请求类型。 ``type`` 参数可以是任何可识别的请求类型：CNAME,
   NS, SOA, TXT, DNSKEY, AXFR等等。

   没有指定请求类型时， ``host`` 自动选择一个合适的请求类型。缺
   省情况，它查找A，AAAA和MX记录。如果给出 ``-C`` 选项，请求将查
   找SOA记录，如果 ``name`` 是一个点分十进制IPv4地址或冒号分隔的
   IPv6地址， ``host`` 将查找PTR记录。

   如果选择一个IXFR请求类型，可以通过附加一个等号（=）和开始序列号来
   指定开始序列号（例如， ``-t IXFR=12345678`` ）。

``-T``; ``-U``
   本选项指定TCP/UDP。缺省时， ``host`` 在生成请求时使用UDP； ``-T`` 选
   项使其在请求一个名字服务器时使用一个TCP连接。对需要的请求，将会
   自动选择TCP，例如区传送（AXFR）请求。类型为 ``ANY`` 的请求缺省走TCP，
   但是可以通过使用 ``-U`` 强制使用UDP。

``-m flag``
   本选项设置内存使用调试：标志可以为 ``record`` ， ``usage`` 或
   ``trace`` 。可以多次指定 ``-m`` 选项以设置多个标志。

``-v``
   本选项设置明细输出，且等效于 ``-d`` 调试选项。明细输出也可以在
   ``/etc/resolv.conf`` 中通过设置 ``debug`` 选项打开。

``-V``
   本选项打印版本号并退出。

``-w``
   本选项设置“永远等待”：请求超时被设置为最大可能值。参见 ``-W`` 选项。

``-W wait``
   本选项设置等待超时的时长，指示 ``named`` 应该等待一个响应最多
   ``wait`` 秒。如果 ``wait`` 小于1，等待间隔被置为一秒。

   缺省时， ``host`` 将对UDP响应等待5秒，并对TCP连接等待10秒。这
   些缺省值可以被 ``/etc/resolv.conf`` 中的 ``timeout`` 选项所覆
   盖。

   参见 ``-w`` 选项。

IDN支持
~~~~~~~~~~~

如果编译 ``host`` 时带有IDN（internationalized domain name，国际
化域名）支持，它可以接受和显示非ASCII域名。 ``host`` 会在发送一
个请求到DNS服务器或显示一个来自服务器的回复之前正确地转换一个域名的
字符编码。要关闭IDN支持，定义 ``IDN_DISABLE`` 环境
变量。在 ``host`` 运行时，如果变量已设置，IDN支持就是关闭的。

文件
~~~~~

``/etc/resolv.conf``

参见
~~~~~~~~

:manpage:`dig(1)`, :manpage:`named(8)`.
