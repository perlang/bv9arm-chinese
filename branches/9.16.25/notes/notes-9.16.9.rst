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

BIND 9.16.9注记
---------------------

新特性
~~~~~~~~~~~~

- 引入了一个新的配置选项， ``stale-refresh-time`` 。它允许在查找失败后
  的一段时间内从缓存中使用过时的资源记录集提供服务，然后再尝试刷新它。
  :gl:`#2066`

漏洞修补
~~~~~~~~~

- 如果当一个请求仍然在处理时，TCP连接被关闭， ``named`` 可能崩溃，并报
  出一个断言失败。 :gl:`#2227`

- ``named`` 在作为一个解析器时，可能错误地将父区中没有DS记录的签名区当
  成伪造的。这样的区应当被当成不安全的。这个已经被修正。 :gl:`#2236`

- 在添加了一个否定信任锚（Negative Trust Anchor，NTA）之后，BIND会周期
  性检查其是否仍然需要。如果BIND在创建一个请求来执行这个检查时遭遇失败，
  它会试图释放一个 ``NULL`` 指针，这将导致一个崩溃。 :gl:`#2244`

- 如果区的权威服务器配置成最小应答，一个在获取粘连记录时的问题可能阻止
  存根区的正常功能。 :gl:`#1736`

- ``UV_EOF`` 不再被当成一个 ``TCP4RecvErr`` 或一个 ``TCP6RecvErr`` 对待。
  :gl:`#2208`
