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

BIND 9.18.10注记
----------------

特性变化
~~~~~~~~

- 为减少缓存中不必要的内存消耗，在正常的否定缓存TTL过期后不再保留
  NXDOMAIN记录，即使 :any:`stale-cache-enable` 被设置为 ``yes`` 。
  :gl:`#3386`

- :any:`auto-dnssec` 选项已被废弃，并将在一个未来的BIND 9.19.x版本中被
  移除。请迁移到 :any:`dnssec-policy` 。 :gl:`#3667`

- :any:`coresize` ， :any:`datasize` ， :any:`files` 和
  :any:`stacksize` 选项已被废弃。这些选项所设置的限制应该在外部实施，
  要么使用手工配置（例如，使用 ``ulimit`` ）要么通过进程管理器（例如，
  ``systemd`` ）。 :gl:`#3676`

- 为入向区传送设置一个替代的本地地址已被废弃。相关选项（
  :any:`alt-transfer-source` ， :any:`alt-transfer-source-v6` 和
  :any:`use-alt-transfer-source` ）将在一个未来的BIND 9.19.x版本中被移
  除。 :gl:`#3694`

- 在发给 :iscman:`named` 的统计通道的请求中所允许的HTTP头部的数量从10
  增加到100，以适应某些浏览器缺省发送超过10个头部。 :gl:`#3670`

漏洞修补
~~~~~~~~

- 当一个到统计通道的HTTP连接被过早关闭时（因为一个连接错误，关机等等），
  :iscman:`named` 可能因为一个断言失败而崩溃。这个已被修复。
  :gl:`#3693`

- 当一个目录区从配置中移除时，某些情形，一个悬空指针可能导致
  :iscman:`named` 进程崩溃。这个已被修复。 :gl:`#3683`

- 当一个区从一个服务器中删除，一个与之相关的密钥管理对象被不经意地保留
  在内存并只在停止时才会释放。这可能导致服务器不断的增加内存用量，带有
  一个很高的变化率，并影响所服务的所有区。这个已被修复。 :gl:`#3727`

- 主服务器的TLS配置没有应用到一个目录区的成员区。这个已被修复。
  :gl:`#3638`

- 在某些情况， :iscman:`named` 在停止之前等待外出的递归查询解析完成。
  这个是非预期的并且已被修复。 :gl:`#3183`

- :iscman:`host` 和 :iscman:`nslookup` 命令行选项为使用定制TCP/UDP的端
  口所进行的设置被ANY查询所忽略（它通过TCP发送）。这个已被修复。
  :gl:`#3721`

- ``zone <name>/<class>: final reference detached`` 日志消息从INFO日志
  级改为DEBUG(1)日志级，以阻止 :iscman:`named-checkzone` 工具在非调试
  模式下过度地记录这个消息到日志中。 :gl:`#3707`

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
