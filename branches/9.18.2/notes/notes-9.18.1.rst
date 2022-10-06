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

BIND 9.18.1注记
---------------------

安全修补
~~~~~~~~~~~~~~

- 接受记录进入缓存的规则已经收紧，以防止如果转发者发送的记录超出了配置
  的范围而中毒的可能性。 (CVE-2021-25220)

  ISC感谢清华大学网络与信息安全实验室的李想、刘保君和陆超逸，以及奇安信
  集团公司的Changgen Zou使我们关注到这个漏洞。 :gl:`#2950`

- 当客户端没有正确关闭连接时，启用了 ``keep-response-order`` 的TCP连接
  可能将TCP套接字遗留在 ``CLOSE_WAIT`` 状态。 (CVE-2022-0396) :gl:`#3112`

- 当开启 ``synth-from-dnssec`` 时（这是缺省设置），涉及一个DNAME的查找
  可能触发一个断言失败。 (CVE-2022-0635)

  ISC感谢AFNIC的Vincent Levigneron使我们关注到这个漏洞。 :gl:`#3158`

- 当追踪DS记录时，一个超时或人为延迟的提取可能导致 :iscman:`named` 在恢复DS查
  找时崩溃。 (CVE-2022-0667) :gl:`#3129`

特性变化
~~~~~~~~~~~~~~~

- DLZ API已经更新：在处理查询时，客户端发送的EDNS Client-Subnet (ECS)选
  项现在包含在发送给DLZ模块的客户端信息中。 :gl:`#3082`

- 在开始和结束BIND 9任务独占模式时，这时会停止正常的DNS操作（例如，重配
  置，接口扫描和其它需要独占对一个共享资源访问的事件），会增加DEBUG(1)
  级消息。 :gl:`#3137`

- 通过TCP接收到的同时处理的流水线的DNS查询的数量限制已经被移除。以前，
  它的上限是同时处理23个查询。 :gl:`#3141`

漏洞修补
~~~~~~~~~

- 在一个 ``named`` 重配置过程中的一个对视图配置的失败可能导致在BIND
  内部结构中的不一致，进而导致崩溃或其它不可预知的错误。这个已被解决。
  :gl:`#3060`

- 之前， ``named`` 在其达到连接数的硬配额时会在日志中记录一条
  "quota reached"的消息。该消息被意外删除，但现在已被恢复。 :gl:`#3125`

- 当BIND网络栈在9.16中被重构时， ``max-transfer-time-out`` 和
  ``max-transfer-idle-out`` 选项未被实现。这遗漏的功能现已被重新实现，
  并且出向的区传送现在在没有进展时会正确地超时。 :gl:`#1897`

- 如果其它部份不读取已发出的数据，TCP连接可能无限期挂起，从而导致TCP写
  缓冲被填满。这个已被解决，通过增加一个"write"计时器。写时挂起的连接现
  在会在 ``tcp-idle-timeout`` 时段后超时。 :gl:`#3132`

- 当接收的数据无法分析为一个有效的DNS请求时，客户端TCP连接将立即关闭。
  :gl:`#3149`

- 表示客户端正等待递归解析结果(``RecursClients``)的当前数目的统计计数器
  在某种解析场景下可能错误计算，潜在导致计数器的值降为负数。这个已被解
  决。 :gl:`#3147`

- 一个处理 ``blackhole`` ACL的错误可能导致某些 ``named`` 发出的DNS失
  败 - 例如，区传送请求和SOA刷新查询 - 如果在ACL中使用 ``!`` 专门排除目
  标地址或前缀，或者如果ACL被设置为 ``none`` 时。这个已被解决。之前，
  ``blackhole`` 在未设置或只包含正匹配元素时才能正常工作。 :gl:`#3157`

- 由于一个在先前版本中的不完全修改而在某些DLZ模块中引入了构建错误。这个
  已被解决。 :gl:`#3111`
