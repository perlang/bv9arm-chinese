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

BIND 9.18.17注记
----------------

特性变化
~~~~~~~~

- 如果来自一个权威服务器中的响应将其RCODE设置为FORMERR，并且包含一个与
  查询中所出现的完全一样的EDNS COOKIE选项， :iscman:`named` 现在将会不
  带EDNS COOKIE选项重新向同一个服务器发送查询。 :gl:`#4049`

- ``relaxed`` QNAME最小化模式现在使用NS记录。这减少了解析时
  :iscman:`named` 产生的查询数量，因为它除了缓存普通的引用外，还允许缓
  存非引用节点的不存在NS资源记录集。 :gl:`#3325`

漏洞修补
~~~~~~~~

- 读取 HMAC-MD5 密钥文件的能力，在BIND 9.18.8中意外丢失，已被恢复。
  :gl:`#3668` :gl:`#4154`

- 在目录区实现中的几个小的稳定性问题已被修复。 :gl:`#4132` :gl:`#4136`
  :gl:`#4171`

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
