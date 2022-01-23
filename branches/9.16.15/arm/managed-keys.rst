.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

.. _rfc5011.support:

动态信任锚管理
-------------------------------

BIND能够使用 :rfc:`5011` 密钥管理维护DNSSEC信任锚。这个特性允许
``named`` 跟踪关键的DNSSEC密钥变化，而不需要操作员改变配置文件。

验证解析器
~~~~~~~~~~~~~~~~~~~

为了配置一个验证解析器，使其用 :rfc:`5011` 来维护一个信任锚点，
需要使用一个 ``trust-anchors`` 语句及 ``initial-key`` 关键字来配
置信任锚。关于这个的信息可以在 :ref:`trust-anchors` 中找到。

权威服务器
~~~~~~~~~~~~~~~~~~~~

为设置一个使用 :rfc:`5011` 信任锚点维护的权威区，需要为区生成两
个（或更多）的密钥签名密钥（KSK）。使用其中一个对区签名；这个密
钥就是“活跃的”KSK。所有不对区签名的KSK都是“备用”密钥。

任何配置成将活跃KSK用作一个RFC 5011所管理的信任锚点的验证解析器
都会留意到区的DNSKEY资源记录集中的后备密钥，并将其存储以备将来
参考。解析器将会定期重新检查区，并在30天之后，如果新密钥仍然存
在，这个密钥将会作为这个区的一个有效信任锚点被解析器所接受。在
这个30天的接受计时器结束后的任何时间，活跃的KSK可以被撤销，而区
可以被“轮转”到新的所接受的密钥。

将一个备用密钥放入一个区的最简单的方法是使用 ``dnssec-keygen``
和 ``dnssec-signzone`` 的“智能签名”特征。如果一个密钥的发布日期
在过去，而激活日期未设置或是在未来， ``dnssec-signzone -S``
将会把DNSKEY记录包含到区中，但是不会使用它签名：

::

   $ dnssec-keygen -K keys -f KSK -P now -A now+2y example.net
   $ dnssec-signzone -S -K keys example.net

为撤销一个密钥，使用命令 ``dnssec-revoke`` 。这个命令增加
密钥标志的REVOKED位，并重新生成 ``K*.key`` 和 ``K*.private`` 文
件。

在撤销一个活跃的密钥之后，必须使用被撤销的KSK和新的活跃的KSK对
区签名。智能签名自动完成这个工作。

一旦一个密钥被撤销并用于对其所在的DNSKEY资源记录集签名，这个密
钥就再也不能被解析器接受为一个有效的信任锚点。然而，可以使用新
的活跃密钥（这个新密钥在作为备用密钥时已经被解析器所接受）进行
验证。

关于密钥轮换场景的更详细信息，参见 :rfc:`5011` 。

当一个密钥被撤销时，其密钥ID会变化，即增加128，并在超过65535时
轮转。所以，例如，密钥“ ``Kexample.com.+005+10000`` ”变成了
“ ``Kexample.com.+005+10128`` ”。

如果两个密钥的ID刚好相差128，并且在其中一个被撤销时，两个密钥ID
发生了碰撞，就会带来一些问题。为避免这种情况，如果另一个可能碰
撞的密钥出现， ``dnssec-keygen`` 将不会生成一个新的密钥。这
个检查仅仅发生在当新密钥被写到存放区的所有其它在用密钥的同一个
目录的时候。

旧版本的BIND 9没有这个预防措施。如果在用密钥撤销碰到先前版本所
生成的密钥，或者在用密钥存储在多个目录或多个服务器上，将会发出
警告。

预料将来发布的BIND 9将会以一个不同的方式应对这个问题，即通过将
已撤销的密钥和其原始未撤销密钥的ID一起存储。
