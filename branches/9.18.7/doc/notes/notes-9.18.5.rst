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

BIND 9.18.5注记
---------------

特性变化
~~~~~~~~

- :option:`dnssec-signzone -H` 的缺省值被改为0次额外NSEC3循环。这个变
  化使 :iscman:`dnssec-signzone` 的缺省值与 :any:`dnssec-policy` 特性
  所使用的缺省值一致。同时，关于NSEC3的文档已与 `当前最佳实践`_ 一致。
  :gl:`#3395`

.. _当前最佳实践: https://datatracker.ietf.org/doc/html/draft-ietf-dnsop-nsec3-guidance-10

漏洞修补
~~~~~~~~~

- 在一个连接（或接受）与一个从套接字读取之间的一个TCP连接关闭所导致
  的断言失败已被修订。 :gl:`#3400`

- 当将非授权名字空间移植到授权名字空间时， :any:`synth-from-dnssec` 可
  能使用来自更上级区的NSEC记录在非授权名字空间中错误地合成表示不存在的
  记录。 :gl:`#3402`

- 之前，当 :iscman:`named` 在递归解析中从权威服务器收到一个FORMERR响应
  后，立即返回一个SERVFAIL响应。这个已被修订：当充当解析器的
  :iscman:`named` 从一个权威服务器收到一个FORMERR响应时，它现在会为一
  个给定的域名而试图联系其它权威服务器。 :gl:`#3152`

- 之前， :option:`rndc reconfig` 不会获取 :any:`http` 块中
  :any:`endpoints` 语句的变化。这个已被修订。
  :gl:`#3415`

- 当存在一个已配置的、已存在的只转发区，目录区的管理员可能处理一个同名
  的目录区的成员区。这个已被修订。 :gl:`#2506`
