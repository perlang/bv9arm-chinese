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

BIND 9.16.27注记
---------------------

安全修补
~~~~~~~~~~~~~~

- 接受记录进入缓存的规则已经收紧，以防止如果转发者发送的记录超出了配置
  的范围而中毒的可能性。 (CVE-2021-25220)

  ISC感谢清华大学网络与信息安全实验室的李想、刘保君和陆超逸，以及奇安信
  集团公司的Changgen Zou使我们关注到这个漏洞。 :gl:`#2950`

- 当客户端没有正确关闭连接时，启用了 ``keep-response-order`` 的TCP连接
  可能将TCP套接字遗留在 ``CLOSE_WAIT`` 状态。 (CVE-2022-0396) :gl:`#3112`

特性变化
~~~~~~~~~~~~~~~

- 在开始和结束BIND 9任务独占模式时，这时会停止正常的DNS操作（例如，重配
  置，接口扫描和其它需要独占对一个共享资源访问的事件），会增加DEBUG(1)
  级消息。 :gl:`#3137`

漏洞修补
~~~~~~~~~

- 当BIND网络栈在9.16中被重构时， ``max-transfer-time-out`` 和
  ``max-transfer-idle-out`` 选项未被实现。这遗漏的功能现已被重新实现，
  并且出向的区传送现在在没有进展时会正确地超时。 :gl:`#1897`

- 如果其它部份不读取已发出的数据，TCP连接可能无限期挂起，从而导致TCP写
  缓冲被填满。这个已被解决，通过增加一个"write"计时器。写时挂起的连接现
  在会在 ``tcp-idle-timeout`` 时段后超时。 :gl:`#3132`

- 表示客户端正等待递归解析结果(``RecursClients``)的当前数目的统计计数器
  在某种解析场景下可能错误计算，潜在导致计数器的值降为负数。这个已被解
  决。 :gl:`#3147`
