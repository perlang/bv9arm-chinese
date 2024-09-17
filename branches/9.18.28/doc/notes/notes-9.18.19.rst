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

BIND 9.18.19注记
----------------

安全修补
~~~~~~~~

- 之前，通过控制通道发送一个特定的构造消息可能导致包分析代码耗尽可用
  的栈内存，进而导致 :iscman:`named` 异常终止。这个已被修复。
  :cve:`2023-3341`

  ISC感谢X41 D-Sec股份有限公司的Eric Sesterhenn，使我们关注到这个漏洞。
  :gl:`#4152`

- 由于在大量DNS-over-TLS查询条件下的一个断言失败，在处理DNS-over-TLS查
  询的网络代码中的一个缺陷可能导致 :iscman:`named` 异常终止。这个已被
  修复。 :cve:`2023-4236`

  ISC感谢USC/ISI根服务器运行机构的Robert Story，使我们关注到这个漏洞。
  :gl:`#4252`

去掉的特性
~~~~~~~~~~

- :any:`dnssec-must-be-secure` 选项已被废弃并将在未来的某个版本中被删除。
  :gl:`#4263`

特性变化
~~~~~~~~

- 如果指定了 ``server`` 命令， :iscman:`nsupdate` 现在接受
  :option:`nsupdate -v` 选项进行SOA查询，即发送UPDATE请求和初次查询都
  使用TCP。 :gl:`#1181`

漏洞修补
~~~~~~~~

- 统计通道中的If-Modified-Since头部值未被正确验证其长度，可能允许一个
  授权用户触发一个缓冲区溢出。确保正确配置统计信息通道，将访问权限只授予
  授权用户是至关重要的。（参见 :any:`statistics-channels` 块定义及使用部
  份）。 :gl:`#4124`

  该问题由X41 D-Sec股份有限公司的Eric Sesterhenn和Cameron Whitehead独立
  报告。

- 统计通道中的Content-Length头部缺少正确的边界检查。一个负数或者超大值可
  能触发一个整数溢出并导致一个断言失败。 :gl:`#4125`

  该问题由X41 D-Sec股份有限公司的Eric Sesterhenn报告。

- 几个由于未清除OpenSSL错误栈而导致的内存泄漏已被修复。 :gl:`#4159`

  该问题由X41 D-Sec股份有限公司的Eric Sesterhenn报告。

- ``krb5-subdomain-self-rhs`` 和 ``ms-subdomain-self-rhs`` UPDATE策略的
  引入意外导致 :iscman:`named` 对删除不存在PTR和SRV记录的请求返回
  SERVFAIL响应。这个已被修复。 :gl:`#4280`

- 当服务器缓存被 :option:`rndc flush` 刷新时， :any:`stale-refresh-time`
  特性被错误地关闭。这个已被修复。 :gl:`#4278`

- 通过实现专用的jemalloc内存区域用于发送缓冲，BIND的内存消耗得到改善。这
  个优化确保内存使用更有效率并更好地管理返回给操作系统的内存页。
  :gl:`#4038`

- 之前，TLS DNS代码中的部分写入未被正确解释，这可能导致DNS消息损坏。这个
  已被修复。 :gl:`#4255`

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
