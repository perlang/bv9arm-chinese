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

BIND 9.18.11注记
----------------

安全修补
~~~~~~~~

- 一个UPDATE消息洪水可能导致 :iscman:`named` 耗尽所有可用内存。通过
  增加一个新的 :any:`update-quota` 选项，它控制 :iscman:`named` 在
  任何给定的时间在一个队列中可以保持的出向DNS UPDATE消息的最大数目
  （缺省：100），才定位了这个缺陷。 :cve:`2022-3094`

  ISC感谢Infoblox的Rob Schulhof，使我们关注到这个漏洞。 :gl:`#3523`

- 当收到一个RRSIG查询，并且 :any:`stale-answer-client-timeout` 被设置
  为一个非零值， :iscman:`named` 可能由于一个断言失败而崩溃。这个已被
  修复。 :cve:`2022-3736`

  ISC感谢Sarenet的Borja Marcos（在Fundación Sarenet的Iratxe Niño的帮
  助下），使我们关注到这个漏洞。 :gl:`#3622`

- 在 :iscman:`named` 作为一个解析器运行时，如果
  :any:`stale-answer-client-timeout` 选项被设置为任何大于 ``0`` 的值，
  当达到 :any:`recursive-clients` 软配额时，可能因为一个断言失败而崩
  溃。这个已被修复。 :cve:`2022-3924`

  ISC感谢AWS的Maksym Odinintsev，使我们关注到这个漏洞。 :gl:`#3619`

新特性
~~~~~~

- 新的 :any:`update-quota` 选项可以用于控制并发DNS UPDATE消息的数量，
  处理这些消息以更新一个主服务器上的一个权威区，或者由一个辅服务器转
  发到主服务器。缺省是100。添加了一个新的统计计数器以记录超过这个配
  额时的事件，XML和JSON统计机制的版本号也被更新。 :gl:`#3523`

去掉的特性
~~~~~~~~~~

- 自从BIND 9.16中引入了新的网络管理器之后，差分服务代码点（DSCP）特性就
  无法运行了。它现在被标记为废弃，实现它的残留代码已被删除。在
  ``named.conf`` 中配置DSCP值现在将导致一个警告，并被记入日志。 :gl:`#3773`

特性变化
~~~~~~~~

- 优化了目录区的实现，能够支持数十万个成员区。 :gl:`#3212` :gl:`#3744`

漏洞修补
~~~~~~~~

- 在出向TCP DNS连接处理中的一个罕见的断言失败已被修复。
  :gl:`#3178` :gl:`#3636`

- 通过TLS（XoT）的较大的区传送可能失败。这个已被修复。 :gl:`#3772`

- 除了先前修复的一个错误之外，还发现了另一个类似的问题，即服务器（包括
  任何已配置的转发器）可能会错误地达到限额，导致SERVFAIL应答被发送到客
  户端。这个已被修复。 :gl:`#3752`

- 在某种查询解析场景（例如，当跟随CNAME记录时），被配置为使用陈旧缓存
  来回答的 :iscman:`named` 在尽管有一个可用的、非陈旧的答案在缓存中时
  也可能返回一个SERVFAIL响应。这个已被修复。 :gl:`#3678`

- 当一个出向请求超时时， :iscman:`named` 会重复尝试同一个服务器三次，
  也不会尝试下一个可用的服务器。这个已被修复。 :gl:`#3637`

- 最近使用的ADB名字和ADB条目（IP地址）可能在ADB面临内存压力时被清除。
  为了缓解这一问题，现在只统计实际的ADB名字和ADB条目（不包括用于“内务
  管理”的内部内存结构），最近使用的（<= 10秒）ADB名字和条目将从overmem
  内存清理器中排除。 :gl:`#3739`

- 在一些NOERROR响应中不经意地设置了“Prohibited”扩展DNS错误。这个已
  被修复。 :gl:`#3743`

- 以前，使用客户端证书进行认证（Mutual TLS）时，TLS会话恢复可能导致
  握手失败。这个已被修复。 :gl:`#3725`

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
