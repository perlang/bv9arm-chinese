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

BIND 9.16.25注记
----------------------

特性变化
~~~~~~~~~~~~~~~

- ``named`` 总体内存使用已被优化和减少，特别是在多CPU核心的系统上。缺省
  的内存分配器从 ``internal`` 切换到 ``external`` 。一个新的命令行选项
  ``-M internal`` 允许 ``named`` 以旧的内部内存分配器启动。 :gl:`#2398`

漏洞修补
~~~~~~~~~

- 在FreeBSD上，TCP连接泄漏了少量的堆内存，最终导致一个内存不足的问题。
  这个已被解决。 :gl:`#3051`

- 如果ZSK创建的签名过期且ZSK私钥处于离线状态，签名将不会被替换。这个行
  为已被修正，通过使用KSK创建新的签名替换过期的签名。 :gl:`#3049`

- 在某些情况下，一个内联签名区的签名版本在导出到磁盘时可能缺失区的未签
  名的序列号。如果在 ``named`` 未运行时修改了未签名区，那么在 ``named``
  重启后，就会阻止区内容的重新同步。这个已被解决。 :gl:`#3071`
