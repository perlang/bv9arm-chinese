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

BIND 9.18.12注记
----------------

去掉的特性
~~~~~~~~~~

- 在配置源地址时指定一个 ``port`` （例如，作为 :any:`query-source` ，
  :any:`query-source-v6` ， :any:`transfer-source` ，
  :any:`transfer-source-v6` ， :any:`notify-source` ，
  :any:`notify-source-v6` ， :any:`parental-source` 或
  :any:`parental-source-v6` 的参数，或者作为 :any:`primaries` ，
  :any:`parental-agents` ， :any:`also-notify` 或 :any:`catalog-zones`
  的 ``source`` 或 ``source-v6`` 中的参数）已被废弃。另外，
  :any:`use-v4-udp-ports`, :any:`use-v6-udp-ports` ，
  :any:`avoid-v4-udp-ports`, and :any:`avoid-v6-udp-ports` 选项已被废弃。

  当在 ``named.conf`` 中遇到这些选项时，现在会记录告警。在将来的版本中，
  它们将会失效。 :gl:`#3781`

漏洞修补
~~~~~~~~

- 由于视图内存的延迟清理，通过 ``rndc reconfig`` 不断添加和删除区可能
  会导致内存消耗增加。这个已被修复。  :gl:`#3801`

- 消息摘要算法（MD5，SHA-1，SHA-2）和NSEC3散列的速度，已被增加。
  :gl:`#3795`

- 由于在DS请求中没有设置RD位，将 :any:`parental-agents` 指向一个解析器
  将不会工作。这个已被修复。  :gl:`#3783`

- 当 ``./configure`` 时使用了 ``--enable-dnsrps`` 开关，构建BIND 9会
  失败。这个已被修复。 :gl:`#3827`

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
