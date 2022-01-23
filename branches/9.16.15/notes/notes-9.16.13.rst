.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.13注记
----------------------

新特性
~~~~~~~~~~~~

- ``dnssec-policy`` 中增加了一个新选项 ``purge-keys`` 。它设置在密钥
  由于轮转而被废弃之后，相应的密钥文件被保留的时间；缺省是90天。这个
  特性可以通过将 ``purge-keys`` 设置为0而禁止。 [GL #2408]

特性变化
~~~~~~~~~~~~~~~

- 当serve-stale开启并且陈旧数据可用时， ``named`` 现在在查询解析过程
  中遇到任何意外错误时返回陈旧答案。例如，如果达到
  ``fetches-per-server`` 或 ``fetches-per-zone`` 限制时，这可能发生。
  在这种情况， ``named`` 试图使用陈旧数据答复DNS请求，但是不会开始
  ``stale-refresh-time`` 窗口。 [GL #2434]

漏洞修补
~~~~~~~~~

- 在9.16.12之前的 ``named`` 版本所创建的区日志文件(``.jnl``)不再兼容；
  在升级时如果日志文件没有先期同步，这可能导致问题。这个已被改正：在启
  动时，旧日志文件现在可以被读入。当检测到一个旧格式的日志文件，在加载
  后会立即更新为新的格式。

  注意，当前版本的 ``named`` 所建立的日志不能用于9.16.12之前的版本。在
  降级到一个之前的版本之前，建议用户使用 ``rndc sync -clean`` 来确保全
  部动态区都已同步。

  日志文件的格式可以通过运行 ``named-journalprint -d`` （降级） 或
  ``named-journalprint -u`` （升级）来手工更改。注意，在 ``named`` 正
  在运行时， **不能** 做上述操作。 [GL #2505]

- 当 ``named`` 允许使用陈旧答复提供服务并且
  ``stale-answer-client-timeout`` 在缓存中没有任何（陈旧）数据可用时被
  触发以回复请求， ``named`` 会崩溃。 [GL #2503]

- 如果发出的包超过 ``max-udp-size`` ， ``named`` 丢弃它而不是送回一个
  正确的响应。为阻止这个问题，在UDP套接字上不再设置 ``IP_DONTFRAG`` 选
  项，这个从BIND 9.16.11就已经发生了。 [GL #2466]

- 当使用 ``dnssec-policy`` 带有 ``nsec3param`` 对一个动态区签名时，没有
  立即创建NSEC3记录。这个已被解决。 [GL #2498]

- 在 ``auto-dnssec maintain`` 开启的情况下，在增加了一个内联签名 [#]_
  区之后，如果 ``named`` 重新读入配置，将会发生一个内存泄漏。这个已被解
  决。 [GL #2041]

.. [#]
   译注：inline-signed

- 一条LOC记录中的一个无效的方向字段(不是 ``N``, ``S``, ``E``, ``W`` 之
  一)会在包含这样记录的区装载时导致一个INSIST失败。 [GL #2499]
