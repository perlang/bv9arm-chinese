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

BIND 9.18.14注记
----------------

去掉的特性
~~~~~~~~~~

- 区类型 ``delegation-only`` ，以及 ``delegation-only`` 和
  ``root-delegation-only`` 语句，已被废弃。当它们被使用时，现在会
  在日志中记录一条告警信息。

  创建这些语句是为了解决站点发现者的争议，其中某些顶级域将拼写错误的
  查询重定向到其它站点，而不是返回NXDOMAIN响应。由于顶级域现在已经使
  用DNSSEC签名了，而DNSSEC验证缺省是打开的，不再需要这些语句了。
  :gl:`#3953`

漏洞修补
~~~~~~~~

- 在目录区处理中可能导致 :iscman:`named` 崩溃的几个漏洞已被修复。
  :gl:`#3955` :gl:`#3968` :gl:`#3997`

- 以前，在辅服务器上通过TLS从一个主服务器下载较大的区（XoT）可能导致
  挂死，尤其是连接不稳定时。这个已被修复。 :gl:`#3867`

- 带有多个DNSKEY记录的区中，DNSSEC验证性能已被改善。 :gl:`#3981`

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
