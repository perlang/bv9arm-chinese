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

BIND 9.18.8注记
---------------

已知问题
~~~~~~~~

- 从BIND 9.16.32，9.18.6或更旧的版本升级可能需要手工修改配置。下列配置
  会受影响：

  - 配置了 :any:`dnssec-policy` 但没有 :any:`allow-update` 或
    :any:`update-policy` 的 :any:`type primary` 区。
  - 配置了 :any:`dnssec-policy` 的 :any:`type secondary` 区。

  在这些情况，请将 :namedconf:ref:`inline-signing yes; <inline-signing>`
  增加到各个区配置中。如果没有这个变化， :iscman:`named` 启动将会失败。
  更多信息参见
  https://kb.isc.org/docs/dnssec-policy-requires-dynamic-dns-or-inline-signing

- 当与在TLS上的区传送（XoT）相配合时，BIND 9.18不支持动态更新的转发（
  参见 :any:`allow-update-forwarding` ）。 :gl:`#3512`

  关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。

新特性
~~~~~~

- 在SVCB记录中增加了对分析和验证 ``dohpath`` 服务参数的支持。
  :gl:`#3544`

- :iscman:`named` 现在在启动时会把支持的加密算法写入日志，也会在
  :option:`named -V` 时输出它们。 :gl:`#3541`

- ``recursion not available`` 和 ``query (cache) '...' denied`` 日志消
  息被扩展为包括导致一个给定查询被拒绝的ACL的名字 :gl:`#3587`

特性变化
~~~~~~~~

- 通过只使用OpenSSL 3.0.0中被废弃的API，经由engine_pkcs11使用PKCS#11的
  能力已被恢复。BIND 9需要在编译时在CFLAGS环境变量中指定
  ``-DOPENSSL_API_COMPAT=10100`` 。
  :gl:`#3578`

漏洞修补
~~~~~~~~

- 修复了 :iscman:`named` 中的一个断言失败，它由在发送统计数据给客户端
  时中止统计通道连接而导致。 :gl:`#3542`

- 在目录区的成员区中只改变主区使用的TSIG密钥名没有失效。这个已被修复。
  :gl:`#3557`
