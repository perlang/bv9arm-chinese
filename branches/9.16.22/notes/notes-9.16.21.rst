.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.21注记
----------------------

新特性
~~~~~~~~~~~~

- 添加了对HTTPS和SVCB记录类型的支持。（这不包含ADDITIONAL部份对这些记录
  类型的处理，只有对资源记录类型的分析和打印这些基本支持。） :gl:`#1132`

特性变化
~~~~~~~~~~~~~~~

- 当 ``dnssec-signzone`` 使用一个其前趋密钥仍处于发布状态的后继密钥对区
  签名时，它现在只刷新具有无效签名、过期签名或在所提供的周期间隔中过期
  的签名的资源记录集的签名。这允许 ``dnssec-signzone`` 逐步替换ZSK被轮
  转的区中的签名（类似于 ``auto-dnssec maintain;`` 所做的）。
  :gl:`#1551`

漏洞修补
~~~~~~~~~

- 最近对区数据库的内部内存结构的更改无意中忽略了去更新 ``map`` 格式区文
  件的MAPAPI值。这使版本9.16.20的 ``named`` 试图装载不再兼容的文件到内
  存，在启动时触发了一个断言失败。MAPAPI值现在已被更新，这样 ``named``
  遇到过时的文件时会拒绝它们。 :gl:`#2872`

- 大小超过2 GB的 ``map`` 格式的区文件加载失败。这个已被解决。
  :gl:`#2878`

- 在某种环境下， ``named`` 不能作为一项Windows服务来运行。这个已被解
  决。 :gl:`#2837`

- 缓存中的过时数据可能导致 ``named`` 在启用了QNAME最小化时发送非最小化
  的请求。这个已被解决。 :gl:`#2665`

- 当只有一个可用的签名密钥的DNSSEC签名区迁移到 ``dnssec-policy`` 时，这
  个密钥现在被当成一个组合签名密钥（CSK）。 :gl:`#2857`

- 当一个动态区在另一个视图中通过使用 ``in-view`` 语句而可用时，运行
  ``rndc freeze`` 总是报告一个 ``already frozen`` 错误，即使区已被成功
  冻结。这个已被解决。 :gl:`#2844`
