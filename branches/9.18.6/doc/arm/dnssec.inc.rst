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

.. _dnssec:

DNSSEC
------

DNS安全扩展（DNSSEC）针对 `缓存污染`_ 攻击提供了可靠的保护。
同时这些扩展还提供了其它好处：它们限制了 `随机子域攻击`_ 在解析器缓存
和权威服务器上的影响，并为如同 `已认证的和私密的电子邮件传输`_ 这样的
现代应用提供了基础。

为达成这个目标，DNSSEC 添加了 `数字签名`_ 到权威DNS区的DNS记录，
并且DNS解析器对收到的记录验证其签名的有效性。如果签名与收到的数据相匹
配，解析器可以确认数据在传输中没有被修改。

.. note::
   DNSSEC和传输级加密是互补的！与典型的传输级加密（如DNS-over-TLS、
   DNS-over-HTTPS或VPN）不同，DNSSEC使DNS记录在DNS解析链的所有点上都可
   验证。

本部份聚焦于是有BIND部署DNSSEC的方法。有关DNSSEC原理（例如
:ref:`how_does_dnssec_change_dns_lookup` ）的更深入的讨论请参见
:doc:`dnssec-guide` 。

.. _`缓存污染`: https://en.wikipedia.org/wiki/DNS_cache_poisoning
.. _`随机子域攻击`: https://www.isc.org/blogs/nsec-caching-should-limit-excessive-queries-to-dns-root/
.. _`数字签名`: https://en.wikipedia.org/wiki/Digital_signature
.. _`已认证的和私密的电子邮件传输`: https://github.com/internetstandards/toolbox-wiki/blob/main/DANE-for-SMTP-how-to.md


.. _dnssec_zone_signing:

区签名
~~~~~~

BIND提供了几种方法来生成签名和并在DNS区的生命周期内维护签名的有效性：

  - :ref:`dnssec_kasp` - **强烈推荐**
  - :ref:`dnssec_dynamic_zones` - 仅对特殊需求
  - :ref:`dnssec_tools` - 不鼓励，仅用于调试

.. _zone_keys:

区密钥
^^^^^^

不管使用的 :ref:`zone-signing <dnssec_zone_signing>` 方法，加密密钥存
储在类似 :file:`Kdnssec.example.+013+12345.key` 和
:file:`Kdnssec.example.+013+12345.private` 的文件名中。私钥（在
``.private`` 文件中）用于生成签名，公钥（在 ``.key`` 文件中）用于验证
签名。另外， :ref:`dnssec_kasp` 方法创建第三个文件，
:file:`Kdnssec.example+013+12345.state` ，它用于跟踪DNSSEC密钥计时并安
全地执行密钥轮转。

这些文件包括：

   - 密钥名，其总是与区名匹配(``dnssec.example.``)，
   - `算法数`_ (013 is ECDSAP256SHA256，008 is RSASHA256，等等)，
   - 和密钥标记, 即一个非唯一密钥标识符(本例中的12345)。

.. _`算法数`: https://www.iana.org/assignments/dns-sec-alg-numbers/dns-sec-alg-numbers.xhtml#dns-sec-alg-numbers-1

.. warning::
   要求私钥具有完全的灾难恢复。备份的密钥文件存放在一个安全的位置，并
   使其避免非授权访问。任何能够访问私钥的人都可以创建伪造的却能通过验
   证的DNS数据。

.. _dnssec_kasp:

完全自动化（密钥和签名策略）
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

密钥和签名策略（KASP）是一种配置方法，它描述了如何维护DNSSEC签名密钥以
及如何对区签名。

这是推荐的，完全自动化的签名和维护DNS区的方法。对大多数使用情况，用户
以简单地使用内置的缺省策略，该策略应用最新的DNSSEC实践：

.. code-block:: none
  :emphasize-lines: 4

    zone "dnssec.example" {
        type primary;
        file "dnssec.example.db";
        dnssec-policy default;
    };

这单独的一行足够建立所需的签名密钥，并为区生成 ``DNSKEY`` ， ``RRSIG``
和 ``NSEC`` 记录。BIND还负责这个区的DNSSEC维护，包括替换即将过期的签名
和管理 :ref:`key_rollovers` 。

.. note::
   :any:`dnssec-policy` 需要区的写权限。关于区存储的含义的详细信息，请
   参阅 :ref:`dnssec_policy` 。

缺省策略建立一个密钥，用于对整个区签名，并使用 ``NSEC`` 开启对不存在的
认证（一个告诉区中不存在哪些记录的安全方法）。这个策略是推荐的，并且典
型情况不需要改变。

如果需要，可以在配置中添加一条 :any:`dnssec-policy` 语句来定义一个定制
的策略：

.. code-block:: none


    dnssec-policy "custom" {
        dnskey-ttl 600;
        keys {
            ksk lifetime P1Y algorithm ecdsap384sha384;
            zsk lifetime 60d algorithm ecdsap384sha384;
        };
        nsec3param iterations 0 optout no salt-length 0;
    };

这个 ``custom`` 策略，例如：

  - 使用一个非常短的 ``DNSKEY`` TTL (600 秒),
  - 使用两个密钥来签名区：一个密钥签名密钥（KSK）用于对密钥相关的资源
    记录集（ ``DNSKEY``, ``CDS``, and ``CDNSKEY`` ）签名，和一个区签名
    密钥（ZSK）用于对区内其余记录签名。KSK在一年后，ZSK在60天后自动轮
    转。

另外:
  - 所配置的密钥具有一个生命周期设置，并使用ECDSAP384SHA384算法。
  - 最后一行指示BIND为
    :ref:`不存在的证明 <advanced_discussions_proof_of_nonexistence>`
    生成NSEC3记录，使用0次额外迭代且没有盐值。NSEC3 opt-out被关闭，意
    谓着不安全的授权也会获得一条NSEC3记录。

更多关于KASP配置的信息，参见 :ref:`dnssec_policy_grammar` 。

在DNSSEC指南的 :ref:`dnssec_advanced_discussions` 部份讨论了各种策略设
置和可能有助于决定针对特定需求的值。

密钥轮转
========

当使用一个 :any:`dnssec-policy` 时，可以设置一个密钥生命周期以触发密钥
轮转。ZSK轮转时全自动化的，但是对于KSK和CSK轮转，需要向父区提交一条DS
记录。完成这个任务的可能的方法，参见 :ref:`secure_delegation` 。

一旦DS已在父区（并且前一个密钥的DS已经撤销），需要告诉BIND这个事件已经
发生。可以配置父区代理来自动完成这件事：

.. code-block:: none
  :emphasize-lines: 5

    zone "dnssec.example" {
        type primary;
        file "dnssec.example.db";
        dnssec-policy default;
        parental-agents { 192.0.2.1; };
    };

这里为BIND配置了一个服务器 ``192.0.2.1`` ，使其发送DS查询，用于在密钥
轮转时检查 ``dnssec-example`` 的DS资源记录集。这需要是一个信任的服务器，
因为BIND不会验证响应。

如果不想设置一个父区代理，也可能使用下列命令告诉BIND，DS已经发布在父区
中了：
:option:`rndc dnssec -checkds -key 12345 published dnssec.example. <rndc dnssec>` 。
并且前一个密钥的DS记录已经被删除了：
:option:`rndc dnssec -checkds -key 54321 withdrawn dnssec.example. <rndc dnssec>` 。
其中的 12345 和 54321 分别是后一个和前一个密钥的密钥标记。

要比时间表更快地轮转一个密钥，或者轮转一个具有无限生命周期的密钥，使用：
:option:`rndc dnssec -rollover -key 12345 dnssec.example. <rndc dnssec>`.

若要将已签名的区恢复为不安全的区，修改区配置以使用内置的“不安全”策略。
详细指令在 :ref:`revert_to_unsigned` 中描述。

.. _dnssec_dynamic_zones:

手工密钥管理
^^^^^^^^^^^^

.. warning::
   这里描述的方法允许对用于签名区的密钥进行完全控制。这仅在非常特殊的
   情况下有要求，通常是不鼓励的。在普通情况，请使用 :ref:`dnssec_kasp` 。

.. _dnssec_dynamic_zones_multisigner_model:

多签名者模式
============

动态区提供了由多个提供者对一个区签名的能力，意谓着每个提供者独立地签名
并服务于同样的区。这样的一个设置要求在提供者之间进行一些协调，当其遇到
密钥轮转时，可能适合的是配置 ``auto-dnssec allow;`` 。这允许仅当用户发
送命令 :option:`rndc sign zonename <rndc sign>` 时，才能更新密钥并重签
区。

一个区也可以配置 ``auto-dnssec maintain`` ，它根据密钥计时元数据以某个
时间表自动调整区的DNSSEC密钥。然而，密钥仍需单独生成，例如，使用
:iscman:`dnssec-keygen` 。

当然，动态区也可使用 :any:`dnssec-policy` 来完全自动化DNSSEC的维护。下
面的部份假设需要更多的密钥管理控制，并描述如何使用动态DNS更新执行各种
DNSSEC操作。

.. _dnssec_dynamic_zones_enabling_dnssec:

手工开启DNSSEC
==============

作为使用 :ref:`dnssec-policy <dnssec_kasp>` 对区进行完全自动签名的替代，
一个区可以通过使用一个动态DNS更新来从不安全改变为安全。必须配置
:iscman:`named` ，使其能够看到 ``K*`` 文件，而后者包含签名区时会用到的
`zone_keys`_ 的公钥和私钥部份。密钥文件应当放到在 :iscman:`named.conf`
中所指定的 :any:`key-directory` 中：

::

       zone update.example {
           type primary;
           update-policy local;
           auto-dnssec allow;
           file "dynamic/update.example.db";
           key-directory "keys/update.example/";
       };

如果有可用的一个KSK和一个ZSK（或者一个CSK），这个配置将使区被签名。作
为初始签名过程的一部份，还会生成一个 ``NSEC`` 链。

在任何支持动态更新的安全区中， :iscman:`named` 会定期对因为某些更
新动作而变为未签名的资源记录集进行重新签名。签名的生存期会被
调整，这样就会将重新签名的负载分散在一段时间而不是集中在一起。

.. _dnssec_dynamic_zones_publishing_dnskey_records:

发布DNSKEY记录
==============

通过动态更新插入密钥：

::

       % nsupdate
       > ttl 3600
       > update add update.example DNSKEY 256 3 7 AwEAAZn17pUF0KpbPA2c7Gz76Vb18v0teKT3EyAGfBfL8eQ8al35zz3Y I1m/SAQBxIqMfLtIwqWPdgthsu36azGQAX8=
       > update add update.example DNSKEY 257 3 7 AwEAAd/7odU/64o2LGsifbLtQmtO8dFDtTAZXSX2+X3e/UNlq9IHq3Y0 XtC0Iuawl/qkaKVxXe2lo8Ct+dM6UehyCqk=
       > send

为了使用这些密钥签名，对应的密钥文件应放在 :any:`key-directory` 中。

.. _dnssec_dynamic_zones_nsec3:

NSEC3
=====

要使用 :ref:`NSEC3 <advanced_discussions_nsec3>` 来取代
:ref:`NSEC <advanced_discussions_nsec>` 作签名，应该添加一条NSEC3PARAM
记录到初始更新请求中。NSEC3链中的 :term:`OPTOUT <opt-out>` 位可以在
NSEC3PARAM记录的标志字段中设置。

::
  
       % nsupdate
       > ttl 3600
       > update add update.example DNSKEY 256 3 7 AwEAAZn17pUF0KpbPA2c7Gz76Vb18v0teKT3EyAGfBfL8eQ8al35zz3Y I1m/SAQBxIqMfLtIwqWPdgthsu36azGQAX8=
       > update add update.example DNSKEY 257 3 7 AwEAAd/7odU/64o2LGsifbLtQmtO8dFDtTAZXSX2+X3e/UNlq9IHq3Y0 XtC0Iuawl/qkaKVxXe2lo8Ct+dM6UehyCqk=
       > update add update.example NSEC3PARAM 1 0 0 -
       > send

注意， ``NSEC3PARAM`` 记录不会出见，直到 :iscman:`named` 有机会建立/删
除相关的链。一个私有类型的记录将被创建，以记录操作状态（参见下面更详细
的描述），并在操作完成之后被删除。

在 ``NSEC`` 链被销毁之前，会生成 ``NSEC3`` 链并添加 ``NSEC3PARAM`` 记
录。

当初始签名及 ``NSEC``/``NSEC3`` 链正在生成时，其它更新也可能发生。

可以通过动态更新增加新的NSEC3PARAM记录。当生成了新的NSEC3链
之后，NSEC3PARAM标志字段被置为零。在这时，可以删除旧的
NSEC3PARAM记录。旧的链将会在更新请求完成之后被删除。

:iscman:`named` 仅支持当一个区的所有 ``NSEC3`` 记录都有同样的
``OPTOUT`` 状态时才建立新的 ``NSEC3`` 链。 :iscman:`named` 支持更新那
些在链中的 ``NSEC3`` 记录有混合 ``OPTOUT`` 状态的区。 :iscman:`named`
不支持变更一个单独 ``NSEC3`` 记录的 ``OPTOUT`` 状态，如果需要变更一个
单独 ``NSEC3`` 记录的 ``OPTOUT`` 状态，就需要变更整个链。

要切换回 ``NSEC`` ，使用 :iscman:`nsupdate` 删除所有带有一个零标志字段
的 ``NSEC3PARAM`` 记录。在 ``NSEC3`` 链被删除之前先生成 ``NSEC`` 链。

.. _dnssec_dynamic_zones_dnskey_rollovers:

DNSKEY轮转
==========

为通过一次动态更新执行密钥轮转，需要为新密钥添加 ``K*`` 文件，这
样 :iscman:`named` 就能够找到它们。然后可以通过动态更新添加新的
``DNSKEY`` 资源记录集。当区被签名时，它们是被新的密钥集签名；
当签名完成，将更新私有类型记录，使最后一个字节为非零。

如果这是一个KSK，需要将新KSK通知上级域和所有的信任锚仓库。

在删除旧 ``DNSKEY`` 之前，区中最大TTL必须过期。如果正在更新一个KSK，
上级区中的DS资源记录集也必须更新，并允许其TTL过期。这就确保
在删除旧 ``DNSKEY`` 时，所有的客户端能够验证至少一个签名。

可以通过 ``UPDATE`` 删除旧的 ``DNSKEY`` 。需要小心指定正确的密钥。在更
新完成后， :iscman:`named` 将会清理由旧密钥生成的所有签名。

.. _dnssec_dynamic_zones_going_insecure:

变为不安全
==========

要使用动态DNS将一个签名的区转换为未签名的区，需要使用
:iscman:`nsupdate` 删除区顶点的所有 ``DNSKEY`` 记录。当区被重启时，所
有签名， ``NSEC`` 或 ``NSEC3`` 链，以及相关的 ``NSEC3PARAM`` 记录都会
被自动地删除掉。

这要求 :iscman:`named.conf` 中的 :any:`dnssec-secure-to-insecure` 选
项被设置为 ``yes`` 。

此外，如果使用了 ``auto-dnssec maintain`` 或者一个
:any:`dnssec-policy` ，应该将其去掉或者将其值改为 ``allow`` ；否则它将
被重签。

.. _dnssec_tools:

手工签名
^^^^^^^^

有几个工具可以用于手工方式签名一个区。

.. warning::

   请注意手工过程主要用于向后兼容，并且只应当由专家用于专门的需求。

要手工设置一个DNSSEC安全区，必须遵循一系列的步骤。请参见
:doc:`dnssec-guide` 中的
:ref:`advanced_discussions_manual_key_management_and_signing` 以获得更
多信息。

使用私有类型记录进行监控
^^^^^^^^^^^^^^^^^^^^^^^^

签名过程的状态由私有类型记录（带有一个缺省值65534）发信号通知。
当签名完成，这些带有非零初始字节的记录将会在最后一个字节有一
个非零值。

如果一个私有类型记录的第一个字节不为0，这个记录表明，要么区需
要由与记录匹配的密钥来签名，要么与记录匹配的所有签名应当被删
掉。这里是第一个字节的不同值的含义：

   - algorithm (octet 1)

   - key ID in network order (octet 2 and 3)

   - removal flag (octet 4)
   
   - complete flag (octet 5)

只有被标志为“complete”的记录才能通过动态更新删除；删除其它
私有类型记录的企图将被静默地忽略掉。

如果第一个字节为零（这是一个保留的算法号，从来不会出现在一个
``DNSKEY`` 记录中），这个记录指示正在进行转换为 ``NSEC3`` 链的过程。其
余的记录包含一个 ``NSEC3PARAM`` 记录。标志字段表明要执行哪种基于标志位
的操作：

   0x01 OPTOUT

   0x80 CREATE

   0x40 REMOVE

   0x20 NONSEC

.. _secure_delegation:

安全授权
~~~~~~~~

一旦一个区在权威服务器上签名，剩下的最后一步是在父区（ ``example.`` ）
和本地区（ ``dnssec.example.`` ）之间建立信任链 [#validation]_ 。

通常的过程是：

  - **等待** 旧数据从缓存总过期。总共需要的时间等于签名前区中所使用的
    最大TTL值。这个步骤确保未签名数据从缓存中过期，解析器就不会因为缺
    失签名而混乱。
  - 在父区中插入/更新DS记录（ ``dnssec.example. DS`` 记录）。

有多个方法更新父区中的DS记录。参考父区的文档，找出哪些选项适用于给定的
案例区。一般来说，从最推荐到最不推荐的选项是：

  - 使用BIND自动生成的 ``CDS``/``CDNSKEY`` 记录自动更新父区中的DS记录。
    这要求要么在父区，注册局，要么在注册商中支持 :rfc:`7344` 。在此情
    况，配置BIND以 :ref:`监控父区中的DS记录 <cds_cdnskey>` ，所有的事
    情都会在正确的时间自动发生。
  - 使用 :iscman:`dig` 查询区，以自动生成 ``CDS`` 或 ``CDNSKEY`` 记录，
    任何使用父区所指定的方法（web形式，电子邮件，API，...）将这些记录
    插入到父区中。
  - 使用 `zone_keys`_ 中的:iscman:`dnssec-dsfromkey` 工具手工生成DS记
    录，然后将其插入到父区中。

.. [#validation] 在实践中任何使用信任链的更多细节，参见 :doc:`dnssec-guide`
                 中的 :ref:`dnssec_12_steps` 。

DNSSEC验证
~~~~~~~~~~

BIND解析器缺省验证来自权威服务器的答复。这个行为由配置语句
:ref:`dnssec-validation <dnssec-validation-option>` 控制。

缺省时，使用一个DNS根区的信任锚。这个信任锚作为BIND的一部份提供，并使
用 :ref:`rfc5011.support` 保持更新。

.. note::
   DNSSEC验证工作“开箱即用”，不需要额外的配置。额外的配置选项仅用于特
   殊情况。

要验证答复，解析器需要至少一个受信任的开始点，一个“信任锚”。本质上，信
任锚是区的 ``DNSKEY`` 资源记录的拷贝，它用于形成加密信任链的首个链接。
可以使用 :any:`trust-anchors` 指定替代的信任锚，但是这个设置非常不一般，
仅建议专家使用。更多信息，参见 :doc:`dnssec-guide` 中的
:ref:`trust_anchors_description` 。

BIND 9权威服务器在装载时不验证签名，所以不必在配置文件中指定权威区的区
密钥。

验证失败
^^^^^^^^

当DNSSEC验证被配置后，解析器将会拒绝来自已签名的、安
全的区中未通过验证的响应，并返回SERVFAIL给客户端。

响应可能因为以下任何一种原因而验证失败，包含错误的、过期的、或无
效的签名；密钥与父区中的DS资源记录集不匹配；或者来自一个区的不安
全的响应，而根据它的父区，应该是一个安全的响应。

更多信息参见 :ref:`dnssec_troubleshooting` 。

与未签名（不安全的）区共存
^^^^^^^^^^^^^^^^^^^^^^^^^^

不受DNSSEC保护的区被称为“不安全的”，这些区能够无缝地与签名区共存。

当验证者收到一个来自一个拥有签名父区的未签名区的响应，它必须
向其父区确认这个是有意未签名的。它通过验证父区没有包含子区的
DS记录，即通过签名的和验证了的NSEC/NSEC3记录，来确认这一点。

如果验证者 **能够** 证明区是不安全的，其响应就是可以接受的。
然而，如果不能证明，它就必须假设不安全的响应是伪造的；它就拒
绝响应并在日志中记录一个错误。

日志记录的错误为“insecurity proof failed”和
“got insecure response; parent indicates it should be secure”。
