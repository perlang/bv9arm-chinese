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

BIND 9.16.12注记
----------------------

安全修补
~~~~~~~~~~~~~~

- 当配置了 ``tkey-gssapi-keytab`` 或 ``tkey-gssapi-credential`` 时，
  一个特定构造的GSS-TSIG请求可能导致在ISC实现的SPNEGO（一个用于GSSAPI
  认证的开启安全机制的协商的协议）中的一个缓冲区溢出。这个缺陷可以用来
  使 ``named`` 崩溃。理论上，它也能远程执行代码，但是在真实世界条件下
  达到后者还是非常困难的。 
  (CVE-2020-8625)

  这个漏洞由Trend Micro Zero Day Initiative向我们报告，编号为
  ZDI-CAN-12302。 :gl:`#2354`

新特性
~~~~~~~~~~~~

- 当辅助服务器接收到较大的增量区域传输(IXFR)时，在对该区应用增量更改
  时，可能会对查询性能产生负面影响。为了解决这个问题， ``named`` 现在
  可以限制IXFR响应区传送请求时发送响应的大小。如果IXFR响应大于整个区
  的AXFR响应，则会发送AXFR响应。

  这个行为是由 ``max-ixfr-ratio`` 选项控制的，该选项是一个百分比值，
  表示IXFR大小与全部区传输的大小之比。缺省是 ``100%`` 。 :gl:`#1515`

- 添加了一个新的选项 ``stale-answer-client-timeout`` ，以改进 ``named``
  关于提供陈旧数据的行为。该选项定义了 ``named`` 在尝试用缓存中的陈旧
  RRset回答请求之前等待的时间。如果找到一个陈旧的答案， ``named`` 将
  继续进行正在进行的获取数据的动作，试图刷新缓存中的RRset，直到达到
  ``resolver-query-timeout`` 的时间间隔。

  默认值为 ``1800`` (毫秒)，最大值限制为 ``resolver-query-timeout`` 减
  去1秒。值 ``0`` 导致立即返回任何可用的缓存RRset，同时仍然触发缓存中
  的数据刷新。

  这个新行为可以通过设置 ``stale-answer-client-timeout`` 为 ``off`` 或
  ``disabled`` 来禁用。如果 ``stale-answer-enable`` 被禁用，新的选项就
  不生效。 :gl:`#2247`

特性变化
~~~~~~~~~~~~~~~

- 作为使用 :rfc:`8499` 术语的持续努力的一部分， ``primaries`` 现在可以
  在 ``named.conf`` 中用作 ``masters`` 的同义词。类似地，
  ``notify primary-only`` 现在可以用作 ``notify master-only`` 的同义词。
  ``rndc zonestatus`` 的输出现在使用 ``primary`` 和 ``secondary`` 术语。
  :gl:`#1948`

- ``max-stale-ttl`` 的缺省值从12小时修改为1天， ``stale-answer-ttl`` 的
  缺省值从1秒修改为30秒，遵循 :rfc:`8767` 的建议。 :gl:`#2248`

- BIND 9库的SONAME现在包括当前的BIND 9版本号，这是为了将内部库与特定版
  本紧密耦合在一起。这一变化使BIND 9的发布过程更加简单和一致，同时也明
  确防止BIND 9二进制文件在启动时静默加载错误版本的共享库(或同一个共享库
  的多个版本)。 :gl:`#2387`

- 当 ``check-names`` 生效时，在一个 ``_spf`` ， ``_spf_rate`` 或
  ``_spf_verify`` 标记(由定义在 :rfc:`7208` 第5.7部份/附录D.1中的
  ``exists`` SPF机制所使用)之下的记录不再被报告为警告/错误。 :gl:`#2377`

漏洞修补
~~~~~~~~~

- 当 ``named`` 的配置包含一个带有非内置 ``allow-update`` ACL的区时，
  ``named`` 启动失败。 :gl:`#2413`

- 以前， ``dnssec-keyfromlabel`` 在操作ECDSA密钥时崩溃。这个已被解决。
  :gl:`#2178`

- KASP错误地将签名有效性设置为DNSKEY签名有效性的值。这个已被解决。
  :gl:`#2383`

- 当迁移到KASP时，BIND 9将带有 ``Inactive`` 和/或 ``Delete`` 定时元数据
  的密钥当成可能的活动密钥。这个已被解决。 :gl:`#2406`

- 修复了KASP中的 "three is a crowd" 密钥轮转漏洞。当密钥轮转的速度超过
  完成轮转过程所需的时间时，后续关系的等式就失败了，因为它假设只有两个
  密钥参与轮转过程。这可能导致提前删除前驱密钥。BIND 9现在实现了一个递
  归后继关系，如论文 "Flexible and Robust Key Rollover" (公式(2))所述。
  :gl:`#2375`

- DNSSEC验证代码（ ``dnssec-signzone`` ， ``dnssec-verify`` 和镜像区都
  用到）的性能有所提高。 :gl:`#2073`

