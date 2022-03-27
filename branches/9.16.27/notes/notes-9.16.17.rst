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

BIND 9.16.17注记
----------------------

特性变化
~~~~~~~~~~~~~~~

- 在 ``named`` 引入网络管理器来处理进入的流量之后，递归性能与以前的
  BIND 9版本相比下降了。现在，通过在网络管理器工作线程内处理内部任务，
  防止了两组线程之间的资源争用，解决了这个问题。 :gl:`#2638`

- 区导出任务现在运行在独立的异步线程池上。这个变化阻止区导出阻塞网络
  I/O。 :gl:`#2732`

- ``inline-signing`` 被错误地描述为继承自 ``options``/``view`` 级别，并
  在这些级别上被错误地接受且没有效果。这个已被解决；在这些级别上带有
  ``inline-signing`` 的 ``named.conf`` 文件将不再被加载。 :gl:`#2536`

漏洞修补
~~~~~~~~~

- 在 ``dns_journal_iter_init()`` 中对预计的IXFR事务大小的计算是无效的。
  这个结果超出了AXFR方式的IXFR响应 :gl:`#2685`

- 修正了一个可能发生的断言失败，即如果在使用陈旧数据答复一个请求时，当
  请求重新启动（例如，沿着一个CNAME记录）之后，触发了一次预取操作。
  :gl:`#2733`

- 如果一台开启DNS64的服务器上，一个请求被回应以陈旧数据，随后又有一条
  非陈旧答复到达，可能发生一个断言。这个已被解决。 :gl:`#2731`

- 修正了一个导致 ``IP_DONTFRAG`` 套接字选项被启用而不是禁用的错误，导致
  发送超过过大的UDP包。 :gl:`#2746`

- 配置在多个视图中的区，带有不同的 ``dnssec-policy`` 且有相同的
  ``key-directory`` 值，现在被检测并动作一个配置错误。 :gl:`#2463`

- 当使用KASP读写区的密钥文件并配置在多个视图中时，可能会出现一个竞争条
  件。这个已被解决。 :gl:`#1875`
