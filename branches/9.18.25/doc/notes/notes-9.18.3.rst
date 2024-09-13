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

BIND 9.18.3注记
---------------------

安全修补
~~~~~~~~~~~~~~

- 以前，TLS套接字对象可能被过早销毁，它会在 :iscman:`named` 实例服务于
  DNS-over-HTTPS (DoH) 客户端时触发断言失败。这个已被修复。

  ISC 感谢来自 arcade solutions 公司的 Thomas Amgarten 使我们关注到这个
  漏洞。 :cve:`2022-1183` :gl:`#3216`

已知问题
~~~~~~~~~~~~

- 根据 :rfc:`8310`, 第 8.1 部份，在建立一个DNS-over-TLS链接，验证一个
  远程证书时，必须不能检查 ``Subject`` 字段。作为替代，只有 
  ``subjectAltName`` 字段必须被检查。很遗憾，一些相当老版本的加密库可
  能缺乏忽略 ``Subject`` 字段的能力。这应当具有最小的生产使用后果，因
  为证书权威所发放的大多数生产达标证书都会设置 ``subjectAltName`` 。在
  这种情况， ``Subject`` 会被忽略。只有旧平台会受此影响，例如，那些使
  用OpenSSL版本早于1.1.1的。 :gl:`#3163`

  关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。

新特性
~~~~~~~~~

- :iscman:`named` 当前支持目录区模式版本2，如同“DNS Catalog Zones” IETF
  草案版本5文档中所描述。所有以前支持的BIND专用的目录区定制属性（
  :any:`primaries` ， :any:`allow-query` 和 :any:`allow-transfer` ），
  以及新的变更所有权（ ``coo`` ）属性，均已实现。模式版本1仍然支持，并
  从模式版本2应用了一些额外的验证规则：例如， :any:`version` 属性是必
  须的，并且一个成员区的PTR资源记录集必须不能包含一个以上的记录。在一
  个验证错误事件中，对应的错误日志消息被记录到日志中以帮助诊断问题。
  :gl:`#3221` :gl:`#3222` :gl:`#3223` :gl:`#3224` :gl:`#3225`

- 当从缓存返回陈旧答案时，支持 DNS 扩展错误 (:rfc:`8914`)
  ``Stale Answer`` 和 ``Stale NXDOMAIN Answer`` 。 :gl:`#2267`

- 增加对远程TLS证书验证的支持，包括 :iscman:`named` 和 :iscman:`dig` ，
  使实现严格和相互TLS认证成为可能，如同 :rfc:`9103` 第9.3部份的描述。
  :gl:`#3163`

漏洞修补
~~~~~~~~~

- 以前，当配置了 ``auto-dnssec maintain;`` 选项时，CDS和CDNSKEY DELETE
  记录会从区中删除。这个已被修复。 :gl:`#2931`
