.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.2注记
---------------------

安全修补
~~~~~~~~~~~~~~

-  当BIND 9被配置为一个转发服务器时，DNS重绑定保护失效。由Tobias Klein
   发现并负责地报告。 [GL #1574]

已知问题
~~~~~~~~~~~~

-  我们收到一些报告，在某些环境下，接收一个IXFR时可能导致对请求的处理
   显著变慢。其中一些与RPZ处理相关，这在新版本中已被修订（参见下面）。
   其它似乎发生在NSEC3相关的变化中（例如一个操作员修改了用于散列计算中
   的NSEC3 salt）。这些正在研究中。 [GL #1685]

特性变化
~~~~~~~~~~~~~~~

-  先前的DNSSEC签名统计使用了大量的内存。每个区要跟踪的密钥数目减少到
   四个，这对99%的全签名区已经足够。 [GL #1179]

漏洞修补
~~~~~~~~~

-  当一个RPZ策略区通过区传送更新且有大量记录被删除时， ``named`` 可能
   有一小段时间，即从RPZ概要数据库中删除名字这段时间，没有响应。现在
   这个数据库经过一个较长的时间段就会增量地清理，减少了这个延迟。 [GL #1447]

-  当试图从 ``auto-dnssec maintain`` 到基于 ``dnssec-policy`` 迁移一
   个已签名的区时，已存在的密钥会立即被删掉并被新的密钥所替代。由于密
   钥轮转计时限制未被遵守，可能某些客户端无法验证响应，直到所有的旧
   DNSSEC信息都从缓存中过期。BIND现在查找现存密钥的时间元数据并使其并
   入DNS策略操作。 [GL #1706]
