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

BIND 9.18.26注记
----------------

新特性
~~~~~~

- 统计通道现在包含了指示当前已连接TCP IPv4/IPv6客户端数量的计数器。
  :gl:`#4425`

- 将RESOLVER.ARPA添加到内置空区中。 :gl:`#4580`

漏洞修补
~~~~~~~~

- 在重新加载配置时，对 ``listen-on`` 语句的修改被忽略了，除非修改了端
  口或接口地址，这使得不可能修改一个相关监听器的传输类型。这个问题已
  被修复。

  ISC感谢Thomas Amgarten使我们关注到这个问题。 :gl:`#4518` :gl:`#4528`

- keymgr代码中的一个漏洞无意间减缓了某些DNSSEC密钥轮转。这个已被修复。
  :gl:`#4552`

- 一些ISO 8601持续时间错误地未被接受，导致比预期更短的持续时间。这个已
  被修复。 :gl:`#4624`

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
