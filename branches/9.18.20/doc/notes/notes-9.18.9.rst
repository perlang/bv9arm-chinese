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

BIND 9.18.9注记
---------------

漏洞修补
~~~~~~~~

- 当一个使用NSEC3的 :any:`dnssec-policy` 区被重新配置为开启
  :any:`inline-signing` 时发生的崩溃已被修复。 :gl:`#3591`

- 在某些解析场景，服务器可能错误地达到限额，包括任何已配置的转发器，导
  致给客户端发送SERVFAIL答复。这个已被修复。 :gl:`#3598`

- 如果一个查询的CD（关闭检查）位被设置为1，在某些情况下，
  :any:`response-policy` 区中的 ``rpz-ip`` 规则可能没有效果。
  :gl:`#3247`

- 先前，如果在 :iscman:`named` 初始启动时经历过互联网连接问题，一个带
  有 :any:`dnssec-validation` 设置为 ``auto`` 的BIND解析器可能进入到一
  个无法恢复的状态，如果不停止 :iscman:`named` ，手工删除
  ``managed-keys.bind`` 和 ``managed-keys.bind.jnl`` 文件，并重新启动
  :iscman:`named` 。这个已被修复。 :gl:`#2895`

- 代表客户端等待递归解析结果（ ``RecursClients`` ）的当前数量的统计计
  数器可能在某种解析场景下溢出。这个已被修复。 :gl:`#3584`

- 先前，远程服务器诸如 :any:`primaries` 和 :any:`parental-agents` 上的
  端口可能因为一个继承的缺陷而被错误地配置。这个已被修复。 :gl:`#3627`

- 先前，BIND在带有数百个CPU的基于Solaris的系统上无法启动。这个已被修复。
  :gl:`#3563`

- 当一个DNS资源记录的TTL值等于解析器的已配置 :any:`prefetch` “资格”值，
  记录被错误地没有被当成符合预取条件。这个已被修复。 :gl:`#3603`

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
