.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.6注记
---------------------

安全修补
~~~~~~~~~~~~~~

- 通过发送一个特别构造的大TCP DNS消息，可能触发一个断言失败。这在
  CVE-2020-8620中公开。

  ISC要感谢思科系统公司的Emanuel Almeida，是他让我们注意到这个漏洞。
  :gl:`#1996`

- 在QNAME最小化和转发都被开启的某种请求解析场景中， ``named`` 可能
  会在一个断言检查失败后崩溃。为防止这种崩溃，如果在任何使用转发的
  时候，对于给定请求的解析过程，现在总是禁用QNAME最小化。这在
  CVE-2020-8621中公开。

  ISC要感谢Joseph Gullo，是他让我们注意到这个漏洞。 :gl:`#1997`

- 当验证一个TSIG签名请求的响应时，可能触发一个断言失败。这在
  CVE-2020-8622中公开。

  ISC要感谢Oracle公司的Dave Feldman，Jeff Warren和Joel Cunningham，
  是他们让我们注意到这个漏洞。 :gl:`#2028`

- 当BIND 9是带有原生PKCS#11支持编译时，其用于确定PKCS#11 RSA公钥
  位数的代码，在遇到一个特别构造的包时可能触发一个断言失败。这在
  CVE-2020-8623中公开。

  ISC要感谢Lyu Chiy，是他让我们注意到这个漏洞。 :gl:`#2037`

- ``subdomain`` 类型的 ``update-policy`` 规则被错误当成 ``zonesub``
  规则处理，这允许 ``subdomain`` 规则中使用的密钥更新特定子域之外的
  名字。这个问题已被修正，通过确认 ``subdomain`` 规则是按照ARM中的
  描述再次被处理。

  ISC要感谢credativ GmbH公司的Joop Boonen，是他让我们注意到这个漏洞。
  :gl:`#2055`

新特性
~~~~~~~~~~~~

- 引入了一个新的配置选项 ``stale-cache-enable`` ，用以开启或关闭在缓存
  中保留旧答复。 :gl:`#1712`

特性变化
~~~~~~~~~~~~~~~

- BIND的缓存数据库实现已被更新，使用了更好的发行版中的更快的哈希函数。
  此外，有效的 ``max-cache-size`` （显式配置，默认值基于系统内存或设
  置为 ``unlimited`` ）现在可以预分配固定大小的哈希表。这可以防止在
  需要增加哈希表大小时中断查询解析。 :gl:`#1775`

- 收到的TTL为0的资源记录不再保留在缓存中，以用于旧答复。 :gl:`#1829`

漏洞修补
~~~~~~~~~

- 通配符RPZ passthru规则可能会被稍后出现在 ``response-policy`` 语句中
  从RPZ区域加载的其它规则错误地覆盖。这个已被修订。 :gl:`#1619`

- IPv6重复地址检测（Duplicate Address Detection，DAD）机制可能无意
  中阻止 ``named`` 绑定到新的IPv6接口，通过为每个IPv6地址发送多个
  路由套接字消息。当其配置成监听 ``any`` 或一个特定范围的地址时，
  ``named`` 监视新接口的 ``bind()`` 。新的IPv6接口在完全可用之前可
  能处于“试探性”状态。当使用了DAD，路由套接字发送两个消息：一个是
  接口首次出现时，然后第二个是当其完全“完成”。 ``named`` 过早尝试
  ``bind()`` 到新接口将会失败。通过在套接字上设置 ``IP_FREEBIND``
  选项并且如果在首次对此地址的 ``bind()`` 调用失败并带有
  ``EADDRNOTAVAIL`` 时，重新尝试 ``bind()`` 到每个IPv6地址，这个问
  题已被解决。 :gl:`#2038`

- 解决了递归客户端统计报告中的一个错误，该错误可能导致下溢，甚至是
  负统计数据。在某些情况下，进入的请求可能会触发对某些符合条件的资
  源记录集的预取，如果预取代码在递归之前执行，那么递归客户端统计不
  会增加。相反，在处理回复时，如果递归代码在预取之前执行，则相同的
  计数器将被递减而没有对应的增加。 :gl:`#1719`

- 引入KASP支持无意中导致第二个字段 ``sig-validity-interval`` 总是以
  小时计算，即使在应该以天计算的情况下也是如此。这个已被修订。（感
  谢Tony Finch。） :gl:`!3735`

- 修订了LMDB锁代码，以使 ``rndc reconfig`` 可以在FreeBSD且
  LMDB >= 0.9.26下面正常工作。 :gl:`#1976`
