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

.. _dnssec.dynamic.zones:

DNSSEC，动态区，和自动化签名
--------------------------------------------

从不安全转换到安全
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

有三种方法可以将一个区从不安全转换为安全：使用动态DNS更新，使
用 ``auto-dnssec`` 区选项，或使用 ``dnssec-policy`` 为区设置
一个DNSSEC策略。

对每一种方法，都需要配置 :iscman:`named` ，使其能够看到 ``K*`` 文件，
而后者包含签名区时会用到的公钥和私钥部份。这些文件由
:iscman:`dnssec-keygen` 生成，或者当使用了 ``dnssec-policy`` 时由
:iscman:`named` 在需要时创建。密钥应当放到在 :iscman:`named.conf` 中所
指定的密钥目录中：

::

       zone example.net {
           type primary;
           update-policy local;
           file "dynamic/example.net/example.net";
           key-directory "dynamic/example.net";
       };

如果生成了一个KSK和一个ZSK DNSKEY密钥，这个配置将使区中所有的
记录被ZSK签名，并使DNSKEY资源记录集被KSK签名。作为初始签名过
程的一部份，还会生成一个NSEC链。

使用 ``dnssec-policy`` ，可以指定哪些密钥应该是KSK和/或ZSK。要
用一个密钥对所有记录签名，必须指定一个CSK。例如：

::

        dnssec-policy csk {
	    keys {
                csk lifetime unlimited algorithm 13;
            };
	};

动态DNS更新方法
~~~~~~~~~~~~~~~~~~~~~~~~~

要通过动态更新插入密钥：

::

       % nsupdate
       > ttl 3600
       > update add example.net DNSKEY 256 3 7 AwEAAZn17pUF0KpbPA2c7Gz76Vb18v0teKT3EyAGfBfL8eQ8al35zz3Y I1m/SAQBxIqMfLtIwqWPdgthsu36azGQAX8=
       > update add example.net DNSKEY 257 3 7 AwEAAd/7odU/64o2LGsifbLtQmtO8dFDtTAZXSX2+X3e/UNlq9IHq3Y0 XtC0Iuawl/qkaKVxXe2lo8Ct+dM6UehyCqk=
       > send

虽然更新请求会几乎立即完成，但是只有在 :iscman:`named` 有时间“遍历”整
个区并生成NSEC和RRSIG记录之后，区的签名才会完成。区顶点的NSEC
记录会在最后添加，作为一个完整NSEC链的信号。

要使用NSEC3来取代NSEC作签名，应该添加一条NSEC3PARAM记录到初始
更新请求中。NSEC3链中的OPTOUT位可以在NSEC3PARAM记录的标志字段
中设置。

::

       % nsupdate
       > ttl 3600
       > update add example.net DNSKEY 256 3 7 AwEAAZn17pUF0KpbPA2c7Gz76Vb18v0teKT3EyAGfBfL8eQ8al35zz3Y I1m/SAQBxIqMfLtIwqWPdgthsu36azGQAX8=
       > update add example.net DNSKEY 257 3 7 AwEAAd/7odU/64o2LGsifbLtQmtO8dFDtTAZXSX2+X3e/UNlq9IHq3Y0 XtC0Iuawl/qkaKVxXe2lo8Ct+dM6UehyCqk=
       > update add example.net NSEC3PARAM 1 1 100 1234567890
       > send

再次强调，更新请求将会几乎立即完成；然而，所添加的记录不会马
上可见，直到 :iscman:`named` 有机会建立/删除相关的链。一个私有类型
的记录将被创建，以记录操作状态（参见下面更详细的描述），并在
操作完成之后被删除。

当初始签名及NSEC/NSEC3链正在生成时，其它更新也可能发生。

完全自动化区签名
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

要打开自动签名，建立一个 ``dnssec-policy`` 或在 :iscman:`named.conf`
的区语句中增加 ``auto-dnssec`` 选项。 ``auto-dnssec`` 有两个
可能的参数： ``allow`` 或 ``maintain`` 。

使用 ``auto-dnssec allow`` ， :iscman:`named` 可以在密钥目录中查找
与区匹配的密钥，将其插入到区中，并使用它们来签名区。它仅仅在
其收到一个 :option:`rndc sign zonename <rndc sign>` 时才这样做。

``auto-dnssec maintain`` 包含上述功能，而且还可以根据密钥的时
间元数据的时间表自动调整区的DNSKEY记录。（更多信息参见
:ref:`man_dnssec-keygen` 和 :ref:`man_dnssec-settime` 。）

``dnssec-policy`` 与 ``auto-dnssec maintain`` 类似，而
``dnssec-policy`` 也能在需要时自动创建新密钥。此外，任何与
DNSSEC签名相关的配置都从策略中提取，而忽略现存的DNSSEC
:iscman:`named.conf` 选项。

:iscman:`named` 将会定期搜索密钥目录查找与区匹配的密钥，如果密钥的
元数据显示区发生了任何变化 - 诸如增加，删除或者撤销一个密钥 - 
这个动作都会被执行。缺省时，每60分钟检查一次密钥目录；这个周
期可以通过 ``dnssec-loadkeys-interval`` 调整，最大到24小时。
:option:`rndc loadkeys` 强制 :iscman:`named` 立即检查密钥是否更新。

如果密钥被提供到密钥目录中，区第一次装载时，区就会立刻被签名，
而不用等待 :option:`rndc sign` 或 :option:`rndc loadkeys` 命令。这些命令
仍然可以用于计划外的密钥变更时。

当新的密钥被添加到一个区时，TTL被设置为与任何已存在的DNSKEY
资源记录集的TTL相匹配。如果不存在DNSKEY资源记录集，TTL将被设
置为密钥创建时（使用 :option:`dnssec-keygen -L` 选项）所指定的TTL，
或者为SOA的TTL，如果有的话。

要使用NSEC3来取代NSEC作签名，需要在发布和激活密钥之前通过动态
更新提交一个NSEC3PARAM记录。NSEC3链中的OPTOUT位可以在
NSEC3PARAM记录的标志字段中设置。NSEC3PARAM记录将不会立即出现
在区中，但它将被存储以供之后参考。当区被签名并且NSEC3链完成之
后，NSEC3PARAM将会出现在区中。

使用 ``auto-dnssec`` 选项要求区被配置成允许动态更新，这是通过
在区配置中增加一个 ``allow-update`` 或 ``update-policy`` 语句
来实现的。如果没有这个，配置就会失败。

私有类型记录
~~~~~~~~~~~~~~~~~~~~

签名过程的状态由私有类型记录（带有一个缺省值65534）发信号通知。
当签名完成，这些带有非零初始字节的记录将会在最后一个字节有一
个非零值。

如果一个私有类型记录的第一个字节不为0，这个记录表明，要么区需
要由与记录匹配的密钥来签名，要么与记录匹配的所有签名应当被删
掉。这里是第一个字节的不同值的含义：

   - algorithm (octet 1)

   - key id in network order (octet 2 and 3)

   - removal flag (octet 4)
   
   - complete flag (octet 5)

只有被标志为“complete”的记录才能通过动态更新删除；删除其它
私有类型记录的企图将被静默地忽略掉。

如果第一个字节为零（这是一个保留的算法号，从来不会出现在一个
DNSKEY记录中），这个记录指示正在进行转换为NSEC3链的过程。其余
的记录包含一个NSEC3PARAM记录。标志字段表明要执行哪种基于标志位的操作：

   0x01 OPTOUT

   0x80 CREATE

   0x40 REMOVE

   0x20 NONSEC

DNSKEY轮转
~~~~~~~~~~~~~~~~

随着不安全到安全的转换，轮转DNSSEC密钥可以使用两种方法完成：
使用一个动态DNS更新，或者 ``auto-dnssec`` 区选项。

动态DNS更新方法
~~~~~~~~~~~~~~~~~~~~~~~~~

为通过一次动态更新执行密钥轮转，需要为新密钥添加 ``K*`` 文件，这
样 :iscman:`named` 就能够找到它们。然后可以通过动态更新添加新的
DNSKEY资源记录集。然后将导致 :iscman:`named` 使用新的密钥对区进行
签名。当签名完成，将更新私有类型记录，使最后一个字节为非零。

如果这是一个KSK，需要将新KSK通知上级域和所有的信任锚仓库。

在删除旧DNSKEY之前，区中最大TTL必须过期。如果正在更新一个KSK，
上级区中的DS资源记录集也必须更新，并允许其TTL过期。这就确保
在删除旧DNSKEY时，所有的客户端能够验证至少一个签名。

可以通过UPDATE删除旧的DNSKEY。需要小心指定正确的密钥。在更新
完成后， :iscman:`named` 将会清理由旧密钥生成的所有签名。

自动密钥轮转
~~~~~~~~~~~~~~~~~~~~~~~

当一个新密钥达到其激活日期（由 :iscman:`dnssec-keygen` 或
:iscman:`dnssec-settime` 所设置的）时，并且如果 ``auto-dnssec`` 区选项
被设置为 ``maintain`` ， :iscman:`named` 将会自动执行密钥轮转。如
果密钥的算法之前没有用于签名区，区将被尽可能快地被全部签名。
但是，如果替代现有密钥的新密钥使用同样的算法，则区将被增量重
签，在其签名有效期过期后，旧密钥的签名被新密钥的签名所替代。
缺省时，这个轮转在30天内完成，之后就可以安全地将旧密钥从
DNSKEY资源记录集中删掉。

通过UPDATE轮转NSEC3PARAM
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

可以通过动态更新增加新的NSEC3PARAM记录。当生成了新的NSEC3链
之后，NSEC3PARAM标志字段被置为零。在这时，可以删除旧的
NSEC3PARAM记录。旧的链将会在更新请求完成之后被删除。

从NSEC转换到NSEC3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

在 ``dnssec-policy`` 中增加一个 ``nsec3param`` 选项并运行
:option:`rndc reconfig` 。

或者使用 :iscman:`nsupdate` 增加一条 NSEC3PARAM 记录。

在这两者情形，都会生成 NSEC3 链，并在 NSEC 链被销毁之前增加
NSEC3PARAM 记录。

从NSEC3转换到NSEC
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

要做这个，从 ``dnssec-policy`` 中去掉 ``nsec3param`` 选项并
运行 :option:`rndc reconfig` 。

或者使用 :iscman:`nsupdate` 删除所有带有一个零标志字段的
NSEC3PARAM记录。在NSEC3链被删除之前先生成NSEC链。

从安全转换为不安全
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

要使用动态DNS将一个签名的区转换为未签名的区，需要使用
:iscman:`nsupdate` 删除区顶点的所有DNSKEY记录。所有签名，NSEC或
NSEC3链，以及相关的NSEC3PARAM记录都会被自动地删除掉。这个发
生在更新请求完成之后。

这要求 :iscman:`named.conf` 中的 ``dnssec-secure-to-insecure`` 选
项被设置为 ``yes`` 。

此外，如果使用了 ``auto-dnssec maintain`` 区命令，应该将其去
掉或者将其值改为 ``allow`` ；否则它将被重签。

定期重签名
~~~~~~~~~~~~~~~~~~~

在任何支持动态更新的安全区中， :iscman:`named` 会定期对因为某些更
新动作而变为未签名的资源记录集进行重新签名。签名的生存期会被
调整，这样就会将重新签名的负载分散在一段时间而不是集中在一起。

NSEC3和OPTOUT
~~~~~~~~~~~~~~~~

:iscman:`named` 仅仅支持一个区的所有NSEC3记录都有同样的OPTOUT状态
才建立新的NSEC3链。 :iscman:`named` 支持更新那些在链中的NSEC3记录
有混合OPTOUT状态的区。 :iscman:`named` 不支持变更一个单独NSEC3记录
的OPTOUT状态，如果需要变更一个单独NSEC3记录的OPTOUT状态，就
需要变更整个链。
