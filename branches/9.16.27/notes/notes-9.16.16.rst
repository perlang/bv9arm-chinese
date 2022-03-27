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

BIND 9.16.16注记
----------------------

特性变化
~~~~~~~~~~~~~~~

- 包含迭代计数大于150的NSEC3记录的DNSSEC响应现在被当成是不安全的。
  :gl:`#2445`

- 能够给一个区配置的最大支持的NSEC3迭代数被减为150。 :gl:`#2642`

- ``max-ixfr-ratio`` 的缺省值被改变为 ``unlimited`` ，以在稳定版本系列
  中获得更好的向后兼容性。 :gl:`#2671`

- 想要从安全模式迁移到不安全模式的区，在迁移过程中如果不想被当成伪造的，
  必须先将其 ``dnssec-policy`` 更改为 ``insecure`` ，而不是 ``none`` 。
  在DNSSEC记录从区中删除后， ``dnssec-policy`` 可以被设置为 ``none`` 或
  者从配置中删除。将 ``dnssec-policy`` 设置为 ``insecure`` 使得CDS和
  CDNSKEY DELETE记录被发布。 :gl:`#2645`

- ZONEMD RR类型的实现已被更新，以满足 :rfc:`8976`. :gl:`#2658`

- ``draft-vandijk-dnsop-nsec-ttl`` IETF 草案已实现：NSEC(3) TTL现在被
  设置为SOA MINIMUM值或SOA TTL中的最小值。 :gl:`#2347`

漏洞修补
~~~~~~~~~

- 有早期版本的 ``named`` 所生成的损坏的日志文件可能在升级后引起问题。
  这个已被解决。 :gl:`#2670`

- 当 ``stale-cache-enable`` 被设置为 ``yes`` 时，在导出缓存中的TTL会
  被错误地报告。这个已被解决。 :gl:`#389` :gl:`#2289`

- 当不同区的多个 ``rndc addzone``, ``rndc delzone`` 和/或
  ``rndc modzone`` 命令被同时激活时，可能发生死锁。这个已被解决。
  :gl:`#2626`

- 当多个区通过 ``dnssec-policy`` 选项设置使用同一个区文件时， ``named``
  和 ``named-checkconf`` 不报告错误。这个已被解决。 :gl:`#2603`

- 如果 ``dnssec-policy`` 是活跃的且在一个rekey事件期间一个私钥文件临时
  离线， ``named`` 可能错误地引入替代密钥并破坏一个签名区。这个已被解
  决。 :gl:`#2596`

- 在生成区签名密钥时，KASP现在也检查新创建密钥之间的密钥ID冲突，而不只
  是新密钥与旧密钥之间的冲突。 :gl:`#2628`
