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

BIND 9.18.7注记
---------------

安全修补
~~~~~~~~

- 先前，在处理大型的授权时，对执行的数据库查找数量没有限制，这可能在
  :iscman:`named` 作为一个递归解析器运行时严重影响其性能。这个已被
  修复。 :cve:`2022-2795`

  ISC感谢Tel-Aviv大学的Yehuda Afek及Reichman大学的Anat Bremler-Barr和
  Shani Stajnrod使我们关注到这个漏洞。 :gl:`#3394`

- 当一个HTTP连接被重用与来自于统计通道的统计请求时，后续响应的内容长度
  可能使大小增长到超过所申请的缓存尽头。这个已被修复。 :cve:`2022-2881`
  :gl:`#3493`

- 处理Diffie-Hellman (DH)密钥的代码中内存泄漏已被修复，当配合OpenSSL
  3.0.0或之后的版本使用TKEY记录与DH模式时，上述泄漏可能被外部触发。
  :cve:`2022-2906` :gl:`#3491`

- 带有被设置为 ``0`` 的 :any:`stale-answer-client-timeout` 选项的
  :iscman:`named` 在作为一个解析器运行时可能因一个断言失败而崩溃，
  当进入的查询有一个旧的CNAME在缓存中时。这个已被修复。
  :cve:`2022-3080` :gl:`#3517`

- 在DNSSEC针对EdDSA算法的验证代码中可能被外部触发的内存泄漏已被修复。
  :cve:`2022-38178` :gl:`#3487`

特性变化
~~~~~~~~

- 响应比率限制（RRL）代码现在将一个给定区内服从于通配符处理的所有QNAME
  视为同样的名字。以防止规避由RRL所强制的限制。 :gl:`#3459`

- 使用 :any:`dnssec-policy` 的区现在要求显式配置动态DNS或
  :any:`inline-signing` 。 :gl:`#3381`

- 当重新配置 :any:`dnssec-policy` ，从使用带有一个只支持NSEC的DNSKEY
  算法（例如，RSASHA1）的NSEC转向一个使用NSEC3的策略时，BIND 9不再废弃
  对区签名；作为替代，它保持使用NSEC直到有冲突的DNSKEY记录从区中被移除，
  然后转向使用NSEC3。 :gl:`#3486`

- 为在 :iscman:`dig` 中编码国际化域名（IDN）和转换域名到IDNA2008格式
  实现了一个后向兼容方法；如果失败，BIND就试探一个IDNA2003转换。
  :gl:`#3485`

漏洞修补
~~~~~~~~

- 修复了一个使用旧数据提供服务的错误，在该错误中，BIND会试图从缓存中返
  回旧数据，用于针对接收到的重复查询或将被丢弃的查询的查找。这个缺陷导
  致过早的SERVFAIL响应，现在已被解决。 :gl:`#2982`

已知问题
~~~~~~~~

  本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
