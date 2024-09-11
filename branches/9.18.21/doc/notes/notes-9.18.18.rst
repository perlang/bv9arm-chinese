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

BIND 9.18.18注记
----------------------

特性变化
~~~~~~~~

- 当一个区的主服务器响应了一个SOA查询，但拒绝了随后的要求区传送的TCP
  连接时，服务器将被标记为不可达。现在，在TCP连接超时时也会做同样标记，
  以阻止在一个不可达服务器上有太多排队的区，并且允许更新进程更快地转
  移到配置中的下一个主服务器。 :gl:`#4215`

- :any:`dialup` 和 :any:`heartbeat-interval` 已被废弃，并将在BIND 9的
  某个未来版本中被删除。 :gl:`#3700`

漏洞修补
~~~~~~~~

- 当服务器重新装载配置或者缓存正被刷新时，处理由TCP所接收的、已在队列
  中的查询可能导致一个断言失败。这个已被修复。 :gl:`#4200`

- 将 :any:`dnssec-policy` 设置为 ``insecure`` 会阻止包含带有大于86400
  秒（1天）的TTL值的资源记录的区的装载。通过忽略区中的TTL值和在密钥轮
  转时间计算中使用一个604800秒（1周）作为最大区TTL，这个已被修复。
  :gl:`#4032`

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
