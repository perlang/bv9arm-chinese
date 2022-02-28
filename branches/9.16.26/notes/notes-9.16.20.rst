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

BIND 9.16.20注记
----------------------

安全修补
~~~~~~~~~~~~~~

- 修补了 ``named`` 中发生的一个断言失败，如果开启了响应比率限制（RRL），
  当 ``named`` 试图发送一个超过MTU大小的UDP包时。
  (CVE-2021-25218) :gl:`#2856`

- ``named`` 在执行区刷新，存根区更新和UPDATE转发时，检查响应的操作码
  （opcode）失败。这可能导致某种条件下的一个断言失败，已经通过拒绝操作
  码与期望值不匹配的响应得到解决。 :gl:`#2762`

特性变化
~~~~~~~~~~~~~~~

- 测试表明，为不同类型的 ``named`` 线程设置线程亲和性会导致不一致的递归
  性能，因为有时多个线程集会竞争一个资源。

  由于上述原因， ``named`` 不再设置线程亲和性。这导致权威性能略微下降约
  5%，但递归性能现在得到了持续改进。 :gl:`#2822`

- CDS和CDNSKEY记录现在可以在一个区中发布，而不需要它们与现有的DNSKEY记
  录精确匹配，只要该区是用CDS或CDNSKEY记录中表示的算法签名的。当使用多
  签名者DNSSEC配置时，这允许从一个DNS提供者到另一个DNS提供者的平滑的轮
  转。 :gl:`#2710`

漏洞修补
~~~~~~~~~

- 如果一条 ``controls`` 语句为同一个监听者配置了多个密钥算法， ``rndc``
  消息的认证可能失败。这个已被解决。 :gl:`#2756`
