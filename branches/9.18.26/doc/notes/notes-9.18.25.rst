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

BIND 9.18.25注记
----------------

漏洞修补
~~~~~~~~~

- 缓存清理代码中的一个后退使得内存使用比之前增长得更快，直到达到
  已配置的 :any:`max-cache-size` 限制。这个已被修复。 :gl:`#4596`

- 使用 :option:`rndc flush` 无意中导致对缓存的清理变得低效。这最终导致
  已配置的 :any:`max-cache-size` 限制被超过，现在已被修复。 :gl:`#4621`

- 清理过期缓存DNS记录的逻辑被调整得更激进。这有助于及时加强
  :any:`max-cache-ttl` 和 :any:`max-ncache-ttl` 。 :gl:`#4591`

- 当发起对重度内存缓存的清理时，可能触发一个释放后又使用的断言。这个
  已被修复。 :gl:`#4595`

  ISC感谢Infoblox的Jinmei Tatuya使我们关注到这个漏洞。

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
