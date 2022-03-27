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

BIND 9.16.26注记
----------------------

特性变化
~~~~~~~~~~~~~~~

- DLZ API已被更新：在处理查询时，客户端发送的EDNS客户端子网(ECS)选项现
  在被包含在发送给DLZ模块的客户端信息中。 :gl:`#3082`

漏洞修补
~~~~~~~~~

- 之前， ``recvmmsg`` 支持在libuv 1.35.0和1.36.0中被开启，但在libuv
  1.37.0或者更大版本中没有开启，这减少了最大请求-响应性能。这个已被修
  订。 :gl:`#3095`

- 在一次 ``named`` 重配置过程中的一个错误视图配置可能导致BIND内部数据结
  构的不一致，并产生崩溃或其它不可预知的错误。这个已被修订。 :gl:`#3060`

- 之前， ``named`` 在达到其连接数的硬限额时在日志中记录一条
  "quota reached"消息。这个消息被意外地删除了，但现在已经恢复。
  :gl:`#3125`

- 由于在上一个版本中的一个未完成的修改，一些DLZ模块中引入了构建错误。这
  个已被修订。 :gl:`#3111`
