.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.15注记
----------------------

安全修补
~~~~~~~~~~~~~~

- 一个不良的入向IXFR传输可能触发 ``named`` 中的一个断言失败，导致它异常
  退出。 (CVE-2021-25214)

  ISC感谢SaskTel的Greg Kuechle使我们关注到这个漏洞。 :gl:`#2467`

- 当DNAME跟踪成为一个客户端请求的最终回答时，将一条DNAME记录放入ANSWER
  部份时，会导致 ``named`` 崩溃。 (CVE-2021-25215)

  ISC感谢 `Siva Kakarla`_ 使我们关注到这个漏洞。 :gl:`#2540`

.. _Siva Kakarla: https://github.com/sivakesava1

- 当一个服务器的配置中设置了 ``tkey-gssapi-keytab`` 或
  ``tkey-gssapi-credential`` 选项时，一个特定构造的GSS-TSIG请求可能导致
  ISC实现的SPNEGO（一种增强安全机制协商的协议，用于GSSAPI认证）中出现一
  个缓冲区溢出。这个缺陷可能被利用来瘫痪64位平台上编译的 ``named`` ，也
  可能在32位平台上编译的 ``named`` 开启远程代码执行。 (CVE-2021-25216)

  这个漏洞由Trend Micro Zero Day Initiative报告给我们，编号
  ZDI-CAN-13347。 :gl:`#2604`

特性变化
~~~~~~~~~~~~~~~

- ISC的SPNEGO实现从BIND 9源代码中移除了。取而代之的是，当BIND 9构建时带
  有GSSAPI支持，它现在总是使用由系统GSSAPI库所提供的SPNEGO实现。所有现
  代Kerberos/GSSAPI库都包含一个SPNEGO机制的实现。 :gl:`#2607`

- ``stale-answer-client-timeout`` 选项的缺省值从 ``1800`` (ms)变化为
  ``off`` 。随着这个特性的成熟，这个缺省值将来可能还会变化。 :gl:`#2608`

漏洞修补
~~~~~~~~~

- TCP闲置和发起超时被错误应用：只有 ``tcp-initial-timeout`` 被应用在整
  个连接中，即使连接仍然活跃，这可能阻止一个大的区传送被发回给客户端。
  缺省的 ``tcp-initial-timeout`` 设置是30秒，意谓着任何超过30秒的连接都
  被突然中止。这个已被解决。 :gl:`#2583`

- 当 ``stale-answer-client-timeout`` 被设置为一个正数并且一个客户端请求
  的递归过程完成， ``named`` 要查找一个过时答案时，在
  ``query_respond()`` 中的一个断言可能失败，导致崩溃。这个已被解决。
  :gl:`#2594`

- 当BIND被升级到BIND 9.16.13或BIND 9.16.13时，如果出现了由BIND 9.16.11
  或更早版本所写的区日志文件，则这个区的区文件可能无意中被当前区内容重
  写。这导致原始的区文件结构（例如，注释， ``$INCLUDE`` 指令）可能会丢
  失，即使区数据本身会被保留。 :gl:`#2623`

- 在升级到BIND 9.16.13之后，信任锚数据库的日志文件（例如
  ``managed-keys.bind.jnl`` ）可能处于损坏状态。（其它区日志文件不受影
  响。）这个已被解决。如果检测到一个损坏的日志文件， ``named`` 现在可以
  恢复它。 :gl:`#2600`

- 当使用TCP发送请求时， ``dig`` 现在能够正确处理 ``+tries=1
  +retry=0`` ，在远程服务器过早关闭连接时不再重试连接。 :gl:`#2490`

- 当一个区从安全状态转移到不安全状态时，CDS/CDNSKEY DELETE记录现在会被
  移除。当这样的记录在一个未签名区中被发现时， ``named-checkzone`` 也不
  再作为一个错误来报告。 :gl:`#2517`

- 使用KASP的区在使用 ``rndc freeze`` 冻结后无法解冻。这个已被解决。
  :gl:`#2523`

- 在使用了 ``rndc checkds -checkds`` 或 ``rndc dnssec -rollover`` 之后，
  ``named`` 现在立即尝试重新配置区密钥。这个变化阻止了不必要的密钥轮转
  延迟。 :gl:`#2488`

- 之前，当 ``named`` 绑定一个UDP套接字到一个网络接口失败时，可能发送一
  个内存泄漏。这个已被解决。 :gl:`#2575`
