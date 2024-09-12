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

BIND 9.18.6注记
---------------

特性变化
~~~~~~~~

- DNSSEC算法RSASHA1和NSEC3RSASHA1现在在某些因为安全策略而禁用的系统上
  （例如红帽企业Linux 9）已经自动被关闭。使用这些算法的主区在这些系统
  上运行之前需要迁移到新算法，当操作系统禁用RSASHA1时，优雅迁移到不同
  的DNSSEC算法是不可能的。 :gl:`#3469`

- 与提取限制相关的日志消息已被改进以提高更完全的信息。特别地，在计数器
  对象被销毁之前，允许的和溢出的提取的最终计数将被记录下来。
  :gl:`#3461`

漏洞修补
~~~~~~~~

- 当作为一个验证解析器转发所有查询到另一个解析器时， :iscman:`named`
  可能因为一个验证失败而崩溃。当所配置的转发者发送一个损坏的DS响应并且
  :iscman:`named` 发现一个正确的来替代的尝试失败时，就会发生崩溃。
  :gl:`#3439`

- 从 :namedconf:ref:`view` or :namedconf:ref:`options` 块继承
  :any:`dnssec-policy` 的非动态区不被标记为内联签名而再也不会被重签所
  调度。这个已被修复。 :gl:`#3438`

- 旧 :any:`max-zone-ttl` 区选项注定要被 :any:`dnssec-policy` 中的
  :any:`max-zone-ttl` 选项取代。然而，后一种选择并不完全有效。这个已被
  纠正：如果区包含的TTL大于在 :any:`dnssec-policy` 中配置的限制，它们
  不会被加载。对于配置了旧 :any:`max-zone-ttl` 选项和
  :any:`dnssec-policy` 这两者的区，旧选项被忽略，并产生一个警告。
  :gl:`#2918`

- :option:`rndc dumpdb -expired <rndc dumpdb>` 被修复以包含过期的资源
  记录集，即使 :any:`stale-cache-enable` 被设置为 ``no`` 且缓存清理时
  间窗口已过。 :gl:`#3462`

已知问题
~~~~~~~~

  本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
