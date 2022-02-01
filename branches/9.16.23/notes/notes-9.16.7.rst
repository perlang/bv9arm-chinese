.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.7注记
---------------------

新特性
~~~~~~~~~~~~

- 增加了一个新的 ``rndc`` 命令， ``rndc dnssec -checkds`` ，它发送
  信号给 ``named`` ，一个给定区或密钥的一条DS记录已被发布到父区或
  者已从父区撤回。这个命令替代料基于时间的
  ``parent-registration-delay`` 配置选项。 :gl:`#1613`

- 当 ``named`` 增加一条 CDS/CDNSKEY 记录到区中时记录日志。 :gl:`#1748`

漏洞修补
~~~~~~~~~

- 在罕见的情况下，当存储在红黑树中的节点数目超过内部哈希表所允许的
  最大数目时， ``named`` 可能会发生一个断言失败并退出。 :gl:`#2104`

- 消除在旧操作系统上看到的EPROTO(71)错误代码的虚假系统日志消息，未
  处理的ICMPv6错误导致返回一个通用协议错误，而不是更具体的错误代码。
  :gl:`#1928`

- 当开启了查询名字最小化时， ``named`` 在解析IPv6部份左边有额外标记
  的 ``ip6.arpa.`` 名字时会失败。例如，当 ``named`` 试图在一个类似
  ``A.B.1.2.3.4.(...).ip6.arpa.`` 的名字上的请求名最小化时，它在最
  左边的IPv6标记，即 ``1.2.3.4.(...).ip6.arpa.`` ，位置停止，而不考
  虑额外标记（ ``A.B`` ）。这会导致在解析名字时的请求循环：如果
  ``named`` 收到NXDOMAIN答复，同样的请求重复发送直到发送的请求数达
  到 ``max-recursion-queries`` 配置选项的值。 :gl:`#1847`

- 通过拒绝一个单一点（ ``.`` ）和/或 ``m`` 作为值而对LOC记录的分析
  变得更加严格。这些变化阻止区文件在加载时使用这样的值。对负海拔不
  是整数的处理也已修正。 :gl:`#2074`

- 修正了几个由 `OSS-Fuzz`_ 发现的问题。 （这些都不是安全问题。）
  :gl:`!3953` :gl:`!3975`

.. _OSS-Fuzz: https://github.com/google/oss-fuzz
