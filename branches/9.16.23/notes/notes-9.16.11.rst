.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.11注记
----------------------

特性变化
~~~~~~~~~~~~~~~

- 在 BIND 9.16 中引入的新的网络代码(netmgr)被全面修改，以使其更稳定、
  可测试和容易维护。 :gl:`#2321`

- 早期的BIND 9.16和更新的版本要求操作系统支持负载均衡的套接字，以便
  ``named`` 能够实现高性能(通过在多个线程中分配进入的查询)。然而，目前
  已知的支持负载平衡套接字的操作系统只有Linux和FreeBSD 12，这意味着在其
  它系统上UDP和TCP的性能都被限制在单个线程上。从BIND 9.16.11版本开始，
  ``named`` 尝试在缺乏负载均衡套接字支持的系统(Windows除外)上将进入的查
  询分配到多个线程中。 :gl:`#2137`

- 现在可以将一个区从安全模式过渡到不安全模式，而不会在这个过程中让它变
  成伪模式；改变为 ``dnssec-policy none;`` 也会导致CDS和CDNSKEY删除被发
  布的记录，以表示父节点上的整个DS资源记录集必须被删除，如 :rfc:`8078`
  所述。 :gl:`#1750`

- 当使用 ``unixtime`` 或 ``date`` 方法更新SOA序列号时， ``named`` 和
  ``dnssec-signzone`` 会悄悄地退回到 ``increment`` 方法，以防止新序列号
  比旧序列号小(使用序列号算术)。当发生这种回退时， ``dnssec-signzone``
  将打印一条警告消息， ``named`` 将记录一条警告. :gl:`#2058`

漏洞修补
~~~~~~~~~

- 多个线程可能尝试在同时销毁单个RBTDB实例，导致在 ``free_rbtdb()`` 中的
  一个不可预料却低概率的断言失败。这已被修订。 :gl:`#2317`

- ``named`` 不再尝试将线程分配给CPU亲和集之外的CPU。感谢
  Ole Bjørn Hessen。 :gl:`#2245`

- 当重配置 ``named`` 时，删除 ``auto-dnssec`` 没有关掉DNSSEC维护。这已
  被修订。 :gl:`#2341`

- 在 ``lib/dns/resolver.c:dns_name_issubdomain()`` 中触发的间歇性BIND断
  言失败的报告现在已经关闭，无需进一步处理。对此，我们最初的反应是添加
  诊断日志，而不是终止 ``named`` ，希望能收到更多有用的故障排除输入。这
  个解决方案首先出现在BIND版本9.17.5和9.16.7中。但是，由于发布了这些版
  本，没有匹配此问题的断言失败的新报告，而且也没有进一步的诊断输入，所
  以我们已经关闭了该问题。 :gl:`#2091`
