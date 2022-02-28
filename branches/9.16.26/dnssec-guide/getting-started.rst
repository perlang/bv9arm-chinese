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
---------------

.. _software_requirements:

软件要求
~~~~~~~~~~~~~~~~~~~~~

.. _bind_version:

BIND版本
^^^^^^^^^^^^

本文档中给出的大多数配置例子需要BIND版本9.16.0或更新版本(尽管许多例子可
以使用9.9之后的所有BIND版本)。
要检查已安装的 ``named`` 的版本，使用 ``-v`` 开关，如下所示：

::

   # named -v
   BIND 9.16.0 (Stable Release) <id:6270e602ea>

BIND版本9.17中增加了一些配置示例，并向后移植到9.16。例如，配置NSEC3需要
BIND 9.16.9版本。

我们建议您运行最新的稳定版本，以获得最完整的DNSSEC配置，以及最新的安全
修复。

.. _dnssec_support_in_bind:

BIND中对DNSSEC的支持
^^^^^^^^^^^^^^^^^^^^^^

BIND 9.7之后的所有版本的BIND 9都支持DNSSEC，就像目前部署在全球DNS中一样，
所以你运行的BIND软件很可能已经支持DNSSEC了。运行命令 ``named -V`` 查看
构建时使用的标志。如果它是带有OpenSSL(``——with- OpenSSL``)构建的，那么
它支持DNSSEC。下面是运行 ``named -V`` 的输出示例：

::

   $ named -V
   BIND 9.16.0 (Stable Release) <id:6270e602ea>
   running on Linux x86_64 4.9.0-9-amd64 #1 SMP Debian 4.9.168-1+deb9u4 (2019-07-19)
   built by make with defaults
   compiled by GCC 6.3.0 20170516
   compiled with OpenSSL version: OpenSSL 1.1.0l  10 Sep 2019
   linked to OpenSSL version: OpenSSL 1.1.0l  10 Sep 2019
   compiled with libxml2 version: 2.9.4
   linked to libxml2 version: 20904
   compiled with json-c version: 0.12.1
   linked to json-c version: 0.12.1
   compiled with zlib version: 1.2.8
   linked to zlib version: 1.2.8
   threads support is enabled

   default paths:
     named configuration:  /usr/local/etc/named.conf
     rndc configuration:   /usr/local/etc/rndc.conf
     DNSSEC root key:      /usr/local/etc/bind.keys
     nsupdate session key: /usr/local/var/run/named/session.key
     named PID file:       /usr/local/var/run/named/named.pid
     named lock file:      /usr/local/var/run/named/named.lock

如果你的BIND 9软件不支持DNSSEC，你应该升级它。(自2018年发布BIND 9.13以来，
如果不带DNSSEC支持，就不可能构建BIND。)除了错过DNSSEC的支持，你还错过了
近年来对该软件进行的一些安全修复。

.. _system_entropy:

系统熵
^^^^^^^^^^^^^^

要将DNSSEC部署到您的授权服务器，您需要生成加密密钥。生成密钥所需的时间
取决于系统上随机性，或熵，的来源。在一些熵不足的系统(尤其是虚拟机)上，
可能需要更长的时间才能生成密钥。

有一些软件包，如Linux的 ``haveged`` ，可以为系统提供额外的熵。一旦安装，
它们将大大减少生成密钥所需的时间。

熵越多，你得到的伪随机数就越好，生成的密钥也就越强。如果您想要或需要高
质量的随机数，请查看 :ref:`hardware_security_modules` ，关于一些基于硬
件的解决方案。

.. _hardware_requirements:

硬件要求
~~~~~~~~~~~~~~~~~~~~~

.. _recursive_server_hardware:

递归服务器硬件
^^^^^^^^^^^^^^^^^^^^^^^^^

在递归服务器上启用DNSSEC验证将使其成为 *验证解析器* 。验证解析器的任务
是获取可用于计算验证答案集的附加信息。以下是用于验证解析器的可能的硬件
增强应该考虑的方面：

1. *CPU* ：验证解析器对返回的许多答复执行加密函数，这通常会导致CPU用量
   增加，除非你的递归服务器内置了硬件来执行加密计算。

2. *系统内存* ：DNSSEC导致更大的应答集，并占用更多的内存空间。

3. *网络接口* ：虽然DNSSEC总体上增加了DNS流量，但您不太可能需要在名字
   服务器上升级您的网络接口卡(NIC)，除非您有一些真正过时的硬件。

需要考虑的一个因素是当前DNS流量的目的地。如果您当前的用户花费较多时间
访问 ``.gov`` 的网站，您应该期望在开启验证后，上述所有资源类别中出现跳
跃，因为 ``.gov`` 有超过90%的签名。这意味着在超过90%的时间中，你的验证
解析器将会如在 :ref:`how_does_dnssec_change_dns_lookup` 中所描述的这样
做。然而，如果您的用户只关注 ``.com`` 域的资源，截至2020年年中，其下只
有1.5%的区签名了。 [#]_ ，您的递归服务器不太可能在开启DNSSEC验证后经历
较大的负载。

.. _authoritative_server_hardware:

权威服务器硬件
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

在权威服务器端，DNSSEC是针对每个区启用。当一个区启用了dnssec时，它也被
称为“已签名”。以下是用于带有签名区的权威服务器的可能的硬件增强需要考虑
的方面：

1. *CPU* ：一个DNSSEC签名区需要定期重签，这是一个CPU密集型的密码功能。
   如果您的DNS区是动态的或经常更改，这也会增加到更高的CPU负载。

2. *系统存储* ：签名区肯定比非签名区大。具体大多少？参见
   :ref:`your_zone_before_and_after_dnssec` 关于一个比较的例子。粗略地
   说，您应该期望您的区域文件至少增长三倍，而且经常增长更多。

3. *系统内存* ：DNS区文件越大，不仅会占用更多的文件系统的存储空间，加
   载到系统内存时也会占用更多的空间。

4. *网络接口* ：虽然您的权威名称服务器将开始发送回更大的响应，但您不太
   可能需要升级名字服务器上的网络接口卡(NIC)，除非您有一些真正过时的硬
   件。

有一个因素需要考虑，但您确实无法控制，那就是查询您的域名并启用了DNSSEC
的用户数量。估计在2014年底，大约有10%到15%的互联网DNS请求时DNSSEC感知
的。 `APNIC <https://www.apnic.net/>`__ 的估计表明在2020年约
`三分之一 <https://stats.labs.apnic.net/dnssec>`__ 的总请求都是验证请
求，虽然这个比例在每个国家有较大的变化。这意味着更多针对您的域的DNS查
询将利用额外的安全特性，这将导致增加系统负载和可能的网络流量。

.. [#]
   https://rick.eng.br/dnssecstat

.. _network_requirements:

网络要求
~~~~~~~~~~~~~~~~~~~~

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
~~~~~~~~~~~~~~~~~~~~~~~~

.. _parent_zone:

父区
^^^^^^^^^^^

在开始您的DNSSEC部署之前，与您的父区管理员核对，以确保他们支持DNSSEC。
这可能是或可能不是与您的注册商相同的实体。正如你在后面的
:ref:`working_with_parent_zone` 中看到的，DNSSEC部署的一个关键步骤是建
立父子信任关系。如果您的父区还不支持DNSSEC，请联系管理员表达您的关注。

.. _security_requirements:

安全要求
^^^^^^^^^^^^^^^^^^^^^

一些组织可能受到比其它组织更严格的安全要求。检查您的组织是否需要生成和
存储更强的加密密钥，以及需要旋转密钥的频率。本文中给出的示例并不适用于
高值（high-value，即上述参数更大的）区。我们在
:ref:`dnssec_advanced_discussions` 中涵盖了这些安全考虑。
