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

BIND 9.16.5注记
---------------------

新特性
~~~~~~~~~~~~

- 新的 ``rndc`` 命令 ``rndc dnssec -status`` 显示当前的DNSSEC策略和
  使用的密钥，密钥的状态和轮转状态。 :gl:`#1612`

漏洞修补
~~~~~~~~~

- 在 ``named`` 正在等待一个递归响应时，如果一个TCP套接字被关闭，可能
  会发生一个竞争条件。试图发送一个响应到正在关闭的连接会触发函数
  ``isc__nm_tcpdns_send()`` 中的一个断言失败。 :gl:`#1937`

- 当 ``named`` 试图使用一个正在关闭的UDP接口时可能会发生一个竞争条件。
  这会触发 ``uv__udp_finish_close()`` 中的一个断言失败。 :gl:`#1938`

- 修复了当服务器处于负载状态且根区尚未加载时断言失败的问题。 :gl:`#1862`

- 当清理 ``lib/dns/rbtdb.c`` 中被重新使用的死节点时， ``named`` 可能
  崩溃。 :gl:`#1968`

- 当服务进程停止时收到一个新的 ``rndc`` 连接， ``named`` 会崩溃。
  :gl:`#1747`

- 由 ``dns_keynode_dsset()`` 返回的DS资源记录集被用于一个非线程安全
  的方式。这可能导致一个INSIST被触发。 :gl:`#1926`

- 当安装CMocka时，会正确处理缺失的 ``kyua`` 命令， ``make check``
  不会意外失败，但是Kyua不会。 :gl:`#1950`

- 当用作 ``check-names`` 的参数时， ``primary`` 和 ``secondary`` 关
  键字未被正确处理，而被忽略了。 :gl:`#1949`

- ``rndc dnstap -roll <value>`` 没有限制保存文件的数目为 ``<value>``
  :gl:`!3728`

- 如果DNSKEY资源记录集中不支持的算法比支持的算法出现更早，在接受一个
  正确签名的资源记录集时，验证器可能失败。如果它检测到一个错误格式的
  公钥，它也可能停止。 :gl:`#1689`

- 在客户端查询时，无意中禁用了 ``blackhole`` ACL。被阻止的IP地址不能
  用于上游查询，但是来自这些地址的查询仍然可以被回答。 :gl:`#1936`
