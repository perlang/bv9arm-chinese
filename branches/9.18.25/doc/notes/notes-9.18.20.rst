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

BIND 9.18.20注记
----------------

特性变化
~~~~~~~~

- B.ROOT-SERVERS.NET的IP地址被更新为170.247.170.2和2801:1b8:10::b.
  :gl:`#4101`

漏洞修补
~~~~~~~~

- 如果一个内联签名区的未签名版本中包含DNSSEC记录，会错误地调度进行
  签名。这个已被修复。 :gl:`#4350`

- 从缓存中查找旧数据时不会考虑权威数据。这个已被修复。 :gl:`#4355`

- 当 :any:`lock-file` 与 :option:`named -X` 命令行选项同时使用时，会
  触发一个断言失败。这个已被修复。 :gl:`#4386`

- 当 :iscman:`named` 启动三次或更多次的时候，不该被删除的
  :any:`lock-file` 文件会被删除，从而使该语句失效。 :gl:`#4387`

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
