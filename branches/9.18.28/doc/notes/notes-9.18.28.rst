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

BIND 9.18.28注记
----------------

安全修补
~~~~~~~~

- 一个恶意的DNS客户端通过TCP发送许多查询缺从不读响应，可能导致服务器对所
  有其它客户端响应缓慢甚至完全没有响应。这个已被修复。
  :cve:`2024-0760` :gl:`#4481`

- 精心构造的特别大量的资源记录集可能具有减慢数据库处理的效果。通过增加一
  个可配置的、对缓存或者区数据库中每个名字和类型可以存储的记录数的限制，
  可以解决这个问题。缺省值是100，可以通过新的
  :any:`max-records-per-type` 选项调整。 :gl:`#497` :gl:`#3405`

- 针对一个给定属主名精心构造的特别大量的资源记录类型具有减慢数据库处理的
  效果。通过增加一个可配置的、对缓存或者区数据库中每个名字和类型可以存储
  的记录数的限制，可以解决这个问题。缺省值是100，可以通过新的
  :any:`max-types-per-name` 选项调整。 :cve:`2024-1737` :gl:`#3403`

  ISC感谢Toshifumi Sakaguchi独立发现并负责任地向ISC报告这个问题。
  :gl:`#4548`

- 验证使用SIG(0)协议(:rfc:`2931`)签名的DNS消息可能导致极高的CPU负载，导致
  拒绝服务的状态。从这个版本的 :iscman:`named` 起，对SIG(0)消息验证的支持
  已被移除。 :cve:`2024-1975` :gl:`#4480`

- 由于一个逻辑错误，触发提供陈旧数据和需要在本地权威区数据中查找的查找
  可能导致一个断言失败。这个已被修复。 :cve:`2024-4076` :gl:`#4507`

- 在我们的DoH实现中发现了潜在的数据竞争，与重新加载配置之后的HTTP/2会话
  对象管理和端点集对象管理相关。这个问题已被修复。 :gl:`#4473`

  ISC感谢nic.lv的Dzintars和Ivo是我们关注到这个漏洞。

- 当在父区中查找NS记录，作为查找DS记录的一部分时，如果开启了使用旧数据服
  务，这可能使 :iscman:`named` 触发一个断言失败。这个已被修复。
  :gl:`#4661`

漏洞修补
~~~~~~~~

- 只IPv4(:option:`named -4`)和只IPv6(:option:`named -6`)模式的命令行选项
  现在也对区 :any:`primaries` ， :any:`also-notify` 和
  :any:`parental-agents` 有效了。 :gl:`#3472`

- 如果使用了 ``add-soa`` ，一个RPZ响应的SOA记录的TTL被设置为1而不是SOA
  记录的TTL。这个已被修复。 :gl:`#3323`

- 当一个与区维护（NOTIFY，SOA）相关的查询超时，且接近一个试图的关闭（例
  如，由 :option:`rndc reload` 触发）， :iscman:`named` 可能出现一个断言
  失败而崩溃。这个已被修复。 :gl:`#4719`

- 指示当前已连接的TCP IPv4/IPv6客户端的统计通道计数器在某些故障场景中没
  有正确调整。这个已被修复。 :gl:`#4742`

- 由于在服务器选择时，EHOSTDOWN或ENETDOWN条件未被正确进行优先级处理，某
  些服务器可能无法被访问到。这些现在已被正确处理为无法访问。 :gl:`#4736`

- 在某些系统上，当针对一个连接发送一个TCP复位时，libuv调用可能返回一个错
  误码，它会在 :iscman:`named` 中触发一个断言失败。这个错误条件现在以一
  个更加优雅的方式处理：以日志记录事件并关闭连接。 :gl:`#4708`

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
