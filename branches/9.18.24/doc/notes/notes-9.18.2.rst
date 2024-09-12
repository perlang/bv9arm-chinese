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

BIND 9.18.2注记
---------------

新特性
~~~~~~

- 增加了一个新的配置选项 :any:`reuseport` 以在处理响应策略区（RPZ），
  目录区或者较大的区传送可能导致服务失败时，关闭在套接字上的负载均衡。
  参见 BIND 9 管理员参考手册以获得更详细的信息。 :gl:`#3249`

漏洞修补
~~~~~~~~

- 以前，如果目标服务器不可达，区维护DNS请求会一直重试。这些请求包括出
  向的NOTIFY消息，刷新SOA请求，上级域DS检查和存根区NS请求。例如，如果
  一个区有一些具有IPv6地址的名字服务器和一个没有IPv6接入的辅服务器，这
  些服务器会不断尝试通过IPv6发送越来越多的NOTIFY流量。这种无用的通信没
  有被记录。这种过度的重试行为已被修复。 :gl:`#3242`

- 识别并解决了一些在 :iscman:`dig` 中可能触发的崩溃和挂起问题。
  :gl:`#3020` :gl:`#3128`
  :gl:`#3145` :gl:`#3184` :gl:`#3205` :gl:`#3244` :gl:`#3248`

- 无效的 :any:`dnssec-policy` 定义，其中所定义的密钥没有覆盖给定算法的
  KSK和ZSK角色，会被接受。现在将会进行检查，如果对所有在用算法，两个角
  色都缺失， :any:`dnssec-policy` 将被拒绝。 :gl:`#3142`

- 改进了对TCP写超时的处理，对每个TCP写独立跟踪其超时，在对方没有读取数
  据的情况下，可以更快地断开连接。 :gl:`#3200`

已知问题
~~~~~~~~

  本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
