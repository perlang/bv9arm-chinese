.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.4注记
---------------------

安全修补
~~~~~~~~~~~~~~

-  当试图填充一个超大的TCP缓冲区时，可能触发一个断言。这个在
   CVE-2020-8618中披露。 [GL #1850]

-  当以某个模式查询一个带有内部通配符标记的区时，可能触发一个INSIST
   失败。这个在CVE-2020-8619中披露。 [GL #1111] [GL #1718]

新特性
~~~~~~~~~~~~

-  文档从DocBook转换为reStructuredText。BIND 9 ARM现在使用Sphinx生成并
   发布于 `Read the Docs`_。发行注记不再作为一个独立文档伴随发行版一起
   提供。 [GL #83]

-  ``named`` 和 ``named-checkzone`` 现在会拒绝加载主区，当其在区顶点有
   一个DS资源记录集时。通过UPDATE在区顶点添加DS记录会被记入日志，并忽略。
   DS记录属于父区，不应在区顶点。 [GL #1798]

-  ``dig`` 和其它工具现在输出扩展DNS错误（Extended DNS Error，EDE）
   选项，当其出现在一个请求或响应中时。 [GL #1835]

特性变化
~~~~~~~~~~~~~~~

-  ``max-stale-ttl`` 的缺省值从1周改为12小时。如果一个或多个域出现问题，
   这个选项控制 ``named`` 在缓存中保留过期资源记录集的时间，作为一种潜
   在的缓解机制。注意，缓存内容的保留与是否在响应客户机查询时使用陈旧
   的答案无关（ ``stale-answer-enable yes|no`` 和 ``rndc serve-stale
   on|off`` ）。当权威服务器没有响应而使用陈旧答案的功能必须显示开启，
   在具有这个特性的所有BIND 9版本上，将自动保留过期的缓存内容。 [GL #1877]

   .. warning::
       这个变化可能对于那些期望陈旧的缓存内容会自动保留1周的管理员来说
       是值得注意的。在 ``named.conf`` 中增加选项 ``max-stale-ttl 1w;``
       以保持 ``named`` 之前的行为。

-  ``listen-on-v6 { any; }`` 为每个接口创建一个独立的套接字。之前，只在
   遵循 :rfc:`3493` 和 :rfc:`3542` 的系统上创建一个套接字。这个变化自
   BIND 9.16.0引入，但它意外地从文档中遗漏了。 [GL #1782]

漏洞修补
~~~~~~~~~

-  当通过IXFR全部更新一个大区的NSEC3链时，当回应对不存在数据的请求时，
   需要DNSSEC证明不存在，可能会在辅服务器上出现暂时的性能损失（换句话
   说，请求要求服务器发现并返回NSEC3数据）。导致这种延迟的不必要的处
   理步骤现在已被删除。 [GL #1834]

-  如果一个数据库节点的名字在查找时，数据库被修改， ``named`` 可能
   会崩溃，并带有一个断言失败。 [GL #1857]

-  一个在 ``lib/isc/unix/socket.c`` 中可能的死锁被修正了。 [GL #1859]

-  之前， ``named`` 在netmgr代码中不会销毁某些互斥量和条件变量，这会
   在FreeBSD中导致一个内存泄漏。这个已被修正。 [GL #1893]

-  在 ``lib/dns/resolver.c:log_formerr()`` 中的一个数据竞争可能导致一
   个断言失败，已被修正。 [GL #1808]

-  之前，当序列号大于或等于当前序列号时， ``provide-ixfr no;`` 无法返
   回最新的响应。 [GL #1714]

-  dnssec-policy keymgr中的一个缺陷已被修正，对给定密钥的后继是否存在
   的检查会错误地返回 ``true`` ，如果密钥环（keyring）中的任何其它密
   钥具有一个后继。 [GL #1845]

-  当使用dnssec-policy创建一个后继密钥时，当前活跃密钥（前驱）的“goal”
   状态不会改变，因而永远不会从区中删除。 [GL #1846]

-  由于一个未初始化的DSCP值， ``named-checkconf -p`` 可能在
   ``server-addresses`` 语句中包含虚假的文本。这个已被修正。 [GL #1812]

-  ARM已被更新，指示当named启动时，生成TSIG会话密钥，而不管是否需要它。
   [GL #1842]

.. _Read the Docs: https://bind9.readthedocs.io/
