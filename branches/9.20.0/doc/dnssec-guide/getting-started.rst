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

.. _getting_started:

开始
----

.. _software_requirements:

软件要求
~~~~~~~~

本指南假设BIND 9.18.0或更新版本，尽管更复杂的手动过程适用于所有9.9以上
的BIND版本。

我们建议运行最新的稳定版本，以获得最完整的DNSSEC配置，及最新的安全补丁。

.. _hardware_requirements:

硬件要求
~~~~~~~~~~~~~~~~~~~~~

.. _recursive_server_hardware:

递归服务器硬件
^^^^^^^^^^^^^^

在递归服务器上启用DNSSEC验证将使其成为 *验证解析器* 。验证解析器的任务
是获取可用于计算验证答案集的附加信息。与普遍的看法相反，资源消耗的增长
是非常适度的： 

1. *CPU* ：验证解析器对未命中缓存的许多答复执行加解密功能，这通常会导
   致CPU用量增加，由于标准的DNS缓存和现代的CPU，稳定状态下CPU时间消耗
   的增加可以忽略不计 - 通常为5%。在解析器启动之后的很短一段时间（几分
   钟），增幅可能达到20%，但是随着DNS缓存的填充，它会迅速减少。

2. *系统内存* ：DNSSEC导致更大的应答集，并占用更多的内存空间。根据典型
   的ISP流量和截至2022年中的互联网状态，缓存的内存消耗大约增加了20%。

3. *网络接口* ：虽然DNSSEC总体上增加了DNS流量，在实践中，这种增加通常
   在测量误差范围内。

.. _authoritative_server_hardware:

权威服务器硬件
^^^^^^^^^^^^^^

在权威服务器端，DNSSEC是针对每个区启用。当一个区启用了dnssec时，它也被
称为“已签名”。以下是因服务于DNSSEC签名区而导致的可以预见的资源消耗的变
化：

1. *CPU* ：一个DNSSEC签名区需要定期重签，这是一个CPU密集型的密码功能。
   如果您的DNS区是动态的或经常更改，这也会增加到更高的CPU负载。

2. *系统存储* ：签名区肯定比非签名区大。具体大多少？参见
   :ref:`your_zone_before_and_after_dnssec` 关于一个比较的例子。
   最终大小取决于区的结构，签名算法，密钥数量，选择NSEC还是NSEC3，签名
   授权的比例，区文件的格式等等。通常，签名区的大小从可以忽略不计增加
   到未签名区大小的三倍。

3. *系统内存* ：DNS区文件越大，不仅会占用更多的文件系统的存储空间，加
   载到系统内存时也会占用更多的空间。最终的内存消耗也取决于上面列出的
   所有变量：在典型情况下，增量大约是未签名区内存消耗的一半，但在一些
   极端情况下，它可能高达三倍。

4. *网络接口* ：虽然您的权威名称服务器将开始发送回更大的响应，但您不太
   可能需要升级名字服务器上的网络接口卡(NIC)，除非您有一些真正过时的硬
   件。

有一个因素需要考虑，但您确实无法控制，那就是查询您的域名并启用了DNSSEC
的用户数量。截止2022年中，
`APNIC <https://stats.labs.apnic.net/dnssec>`__ 测量表明41%的互联网用
户发出了有DNSSEC感知的查询。这意味着更多针对您的域的DNS查
询将利用额外的安全特性，这将导致增加系统负载和可能的网络流量。

.. _network_requirements:

网络要求
~~~~~~~~

从网络的角度来看，DNS和DNSSEC报文非常相似：DNSSEC报文更大，这意味着DNS
更可能使用TCP。您应该测试以下两个项目，以确保您的网络为DNSSEC做好了准
备：

1. *DNS over TCP* ：验证TCP 53端口的网络连通性，这可能意味着更新路由器
   的防火墙策略或访问控制表(ACL)。参见 :ref:`dns_uses_tcp` 了解更多细
   节。

2. *大型UDP报文* ：一些网络设备，如防火墙，可能会假设DNS UDP报文的大小，
   并错误地拒绝看起来“太大”的DNS流量。验证您的名字服务器生成的响应正在
   被世界其它地方看到：参见 :ref:`whats_edns0_all_about` 了解更多细节。

.. _operational_requirements:

运行要求
~~~~~~~~

.. _parent_zone:

父区
^^^^

在开始您的DNSSEC部署之前，与您的父区管理员核对，以确保他们支持DNSSEC。
这可能是或可能不是与您的注册商相同的实体。正如你在后面的
:ref:`working_with_parent_zone` 中看到的，DNSSEC部署的一个关键步骤是建
立父子信任关系。如果您的父区还不支持DNSSEC，请联系管理员表达您的关注。

.. _security_requirements:

安全要求
^^^^^^^^

一些组织可能受到比其它组织更严格的安全要求。检查您的组织是否需要生成和
存储更强的加密密钥，以及需要旋转密钥的频率。本文中给出的示例并不适用于
高值（high-value，即上述参数更大的）区。我们在
:ref:`dnssec_advanced_discussions` 中涵盖了这些安全考虑。
