.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.8注记
---------------------

新特性
~~~~~~~~~~~~

- 增加一个新的 ``rndc`` 命令， ``rndc dnssec -rollover`` ，它针对一个
  特定的密钥启动一次手动轮转。 :gl:`#1749`

- 增加一个新的 ``rndc`` 命令， ``rndc dumpdb -expired`` ，它转储缓存
  数据库，其中包括等待清理的已过期的资源记录集，到 ``dump-file`` ，
  出于诊断的目的。 :gl:`#1870`

特性变化
~~~~~~~~~~~~~~~

- 2020 DNS旗帜日：缺省的EDNS缓存大小被从4096修改为1232字节。根据多家
  机构已完成的测量，这应当不会带来任何操作问题，因为大多数互联网“核
  心”能够处理介于1400-1500字节之间的IP消息大小；1232的大小被选择作
  为保守的最小值，DNS操作人员可以将其修改为估计的路径MTU减去估计的
  头空间。在实践中，在运营DNS的社区中可见的最小MTU是1500字节，这是
  最大的以太网负载大小，因此在可靠的网络中，最大DNS/UDP负载大小的一
  个有益的缺省值是1400字节。 :gl:`#2183`

漏洞修补
~~~~~~~~~

- 在一个不能正确报告可用内存页数量和/或每个内存页大小的环境中运行
  时， ``named`` 报告了一个无效的内存大小。 :gl:`#2166`

- 当配置了多个转发者时， ``named`` 可能因为在 ``lib/dns/message.c``
  中的 ``REQUIRE(msg->state == (-1))`` 断言失败而导致崩溃。这个已被
  修正。 :gl:`#2124`

- 对于使用Ed25519或Ed448算法的KASP策略，由于创建的密钥大小与预期的
  密钥大小不匹配， ``named`` 错误地执行连续的密钥轮转。 :gl:`#2171`

- 如果一个RPZ区包含的名字混用大小写字母，在更新其内容时，可能会导致
  错误地忽略该RPZ区域中的一些处理规则。 :gl:`#2169`
