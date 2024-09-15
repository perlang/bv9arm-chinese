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

BIND 9.18.24注记
----------------

安全修补
~~~~~~~~

- 验证包含许多DNSSEC签名的DNS消息可能导致过大的CPU负载，并导致拒绝服务
  状态。这个已被修复。 :cve:`2023-50387`

  ISC感谢德国国家应用网络安全研究中心ATHENE的Elias Heftrig，
  Haya Schulmann，Niklas Vogel和Michael Waidner使我们关注到这个漏洞。
  :gl:`#4424`

- 准备一个NSEC3最接近的闭环证据可能导致过大的CPU负载，并导致拒绝服务状
  态。这个已被修复。 :cve:`2023-50868` :gl:`#4459`

- 解析带有许多不同名字的DNS消息可能导致过大的CPU负载。这个已被修复。
  :cve:`2023-4408`

  ISC感谢Reichman大学的Shoham Danino，Tel-Aviv大学的Anat Bremler-Barr，
  Tel-Aviv大学的Yehuda Afek和Tel-Aviv大学的Yuval Shavitt使我们关注到这
  个漏洞。 :gl:`#4234`

- 当开启 :any:`nxdomain-redirect` 时，特定查询可能导致 :iscman:`named`
  出现一个断言失败而崩溃。这个已被修复。 :cve:`2023-5517` :gl:`#4281`

- 当DNS64和使用旧数据服务这两个特性都开启时，这两者之间不正确的交互可能
  导致 :iscman:`named` 出现一个断言失败而崩溃。这个已被修复。
  :cve:`2023-5679` :gl:`#4334`

- 在某种情况下，DNS-over-TLS客户端代码错误地试图在同一时间处理超过一个
  DNS消息，这可能导致 :iscman:`named` 出现一个断言失败而崩溃。这个已被
  修复。 :gl:`#4487`

漏洞修补
~~~~~~~~

- 由统计通道导出的计数器被改回有符号64位值；自BIND 9.15.0起，它们被无意
  中截断为无符号32位值。 :gl:`#4467`

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
