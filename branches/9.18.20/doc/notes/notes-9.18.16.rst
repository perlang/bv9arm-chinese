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

BIND 9.18.16注记
----------------

安全修补
~~~~~~~~

- 内存过高的清理进程已被改进，以阻止缓存显著超过 :any:`max-cache-size`
  所配置的限额。 :cve:`2023-2828`

  ISC感谢Reichman大学的Shoham Danino，Tel-Aviv大学的Anat Bremler-Barr，
  Yehuda Afek和Yuval Shavitt使我们关注到这个漏洞。 :gl:`#4055`

- 使用过时数据优先于查找的查询将会触发一次数据获取以刷新缓存中的过时数
  据。如果数据获取因为超过递归限额而被终止， :iscman:`named` 可能进入
  无限回调循环，并因堆栈溢出而崩溃。这个已被修复。 :cve:`2023-2911`
  :gl:`#4089`

新特性
~~~~~~

- 系统测试套件现在可以使用pytest执行（伴随pytest-xdist，用于并行执行）。
  :gl:`#3978`

去掉的特性
~~~~~~~~~~

- TKEY模式2（Diffie-Hellman Exchanged Keying）现已被废弃，并将在未来一个
  版本中去除。当 ``named.conf`` 中使用了 :any:`tkey-dhkey` 选项时，会在日
  志中记录一个告警。 :gl:`#3905`

漏洞修补
~~~~~~~~

- 当一条为HTTP配置的 :any:`listen-on` 语句从配置中删除时，BIND重新配置
  时可能卡住。这个已被修复。 :gl:`#4071`

- 之前，在 :any:`stale-answer-client-timeout` 期已过后，有可能从缓存给
  客户端返回一个授权。这个已被修复。 :gl:`#3950`

- 在通过基于流的DNS传输发送数据时，BIND可能申请了过大的缓冲区，这导致
  内存使用增加。这个已被修复。 :gl:`#4038`

- 当 :any:`stale-answer-enable` 选项为开启且
  :any:`stale-answer-client-timeout` 选项为开启且大于0时，
  :iscman:`named` 先前为每个客户端从 :any:`clients-per-query` 限制中
  分配了两个插槽，并且未能按照配置逐渐自动调整其值。这个已被修复。
  :gl:`#4074`

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
