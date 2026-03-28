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

.. _advanced:

高级配置
========

.. _dynamic_update:

动态更新（Dynamic Update）
--------------------------

动态更新是一个通过给主服务器发送一个特殊格式的DNS消息来增加、替换和删除
其上记录的方法。这些消息的格式和含义由 :rfc:`2136` 指定。

动态更新是通过在 :any:`zone` 语句中包含一个 :any:`allow-update` 或一个
:any:`update-policy` 子句来打开的。

如果区的 :any:`update-policy` 被设为 ``local`` ，对区的更新将由密钥
``local-ddns`` 来许可，后者是由 :iscman:`named` 启动时生成的。更多详细信息，
参见 :ref:`dynamic_update_policies` 。

使用Kerberos签名请求进行的动态更新可以通过使用TKEY/GSS协议来完成，
要么是设置 :any:`tkey-gssapi-keytab` 选项，要么是同时设置
:any:`tkey-gssapi-credential` 和 :any:`tkey-domain` 这两个选项。一旦开启
这个功能，Kerberos签名请求将与区的更新策略进行匹配，使用
Kerberos principal作为请求的签名者。

更新一个安全的区（使用DNSSEC的区）遵循 :rfc:`3007` ：受更新影响的
RRSIG、NSEC和NSEC3记录通过服务器使用一个在线区密钥来自动重新生成。
更新授权是基于事务签名和一个显式的服务器策略。

.. _journal:

日志文件
~~~~~~~~~~

一个使用动态更新的区的所有变化将保存在这个区的日志文件中。这个文件在
第一个更新发生时自动创建。日志文件的名字由相关区文件的名字加上扩展名
``.jnl`` 组成，除非指定了名字。日志文件是二进制格式，不能手工编辑。

服务器会时常将更新后的区的完整内容转储到（“dump”）其区文件中。这个操
作不是每次动态更新后立即执行，因为如果这样，一个大的区在频繁更新时将
会导致服务器变得太慢。代替的方法是，转储操作延迟15分钟，以允许其它更
新。在转储过程中，将会创建以 ``.jnw`` 和 ``.jbk`` 为后缀的瞬时文件；
在普通情况下，这些文件将在转储完成后被删除掉，忽略它们也是安全的。

当服务器在停止或宕掉之后重启时，将重新装载日志文件，以便将自从上次区
转储以后发生的所有更新合并到区中。

增量区传送所产生的变化也是以类似的方式记录到日志的。

动态更新区的区文件不能像通常那样进行手工编辑，因为没法保证包含最近的
动态变化 — 这些变化只存在于日志文件中。保持动态更新区的区文件最新的
唯一方法是执行 :option:`rndc stop` 。

要手工修改一个动态区，按照下列步骤：首先，使用 :option:`rndc freeze zone <rndc freeze>`
关闭到这个区的动态更新；这会使用存放在其 ``.jnl`` 文件中的变化来更新
区文件。然后，编辑区文件。最后，执行 :option:`rndc thaw zone <rndc thaw>` 重新装载
修改后的区文件并打开动态更新。

:option:`rndc sync zone <rndc sync>` 将使用日志文件中的变化更新区文件而不停止动态更新；
这对观察当前区状态是有用的。要在更新区文件之后删除 ``.jnl`` 文件，使
用 :option:`rndc sync -clean <rndc sync>` 。

.. _notify:

通知（Notify）
--------------

DNS NOTIFY是一个让主服务器通知其辅服务器某个区数据发生了变化的机制。作
为对来自主服务器的 NOTIFY 消息的响应，辅服务器会检查自己的区版本是否是
当前版本，如果不是，就发起区传送。

更多的关于DNS NOTIFY 的信息，参见 :namedconf:ref:`notify` 和
:namedconf:ref:`also-notify` 语句中的描述。NOTIFY 协议由 :rfc:`1996`
规定。

.. note::

   一个辅区也可以成为其它辅区的主区， :iscman:`named` 在缺省情况下会对
   其所载入的每个区发出 ``NOTIFY`` 消息。

.. _incremental_zone_transfers:

增量区传送（IXFR）
-------------------

增量区传送（incremental zone transfer, IXFR）协议是一个为辅服务器提供
只传送变化的数据的方式，以代替必须传送整个区的方法。IXFR协议由
:rfc:`1995` 指定。

当作为一个主服务器时，BIND 9支持对这些区的IXFR，条件是必要的变化历史
信息是可用的。这些包括以动态更新维护的主区和通过IXFR获取数据的辅区。
对于手工维护的主区，以及通过全量区传送（AXFR）获取数据的辅区，IXFR仅
在 :any:`ixfr-from-differences` 选项被设置成 ``yes`` 时才支持。

当作为一个辅服务器时，BIND 9将尝试使用IXFR，除非其被显式关闭。更多关
于关闭IXFR的信息，参见 :namedconf:ref:`server` 语句的
:any:`request-ixfr` 子句的描述。

当一台辅服务器通过AXFR接收一个区，它会创建一个新的区数据库副本，然后
将其交换到适当的位置；在装载过程中，请求继续由旧数据库服务而不受干扰。
但是，当通过IXFR接收一个区，修改应用到正在运行的区，可能会在传输期间
降低查询性能。如果一台收到一条IXFR请求的服务器判断响应的大小类似于一
条AXFR响应的大小，它可能希望发送AXFR作为替代。可以使用
:any:`max-ixfr-ratio` 选项配置这个判断的阈值。

.. _split_dns:

分割DNS
-------

对DNS空间的内部和外部解析器设置不同的视图通常被称为一个 *分割DNS*
设置。有几个原因使某个组织可能想要这样设置其DNS。

一个使用分割DNS的共同的原因是对“外部”互联网上的客户隐藏“内部”DNS
信息。关于这样做是否确实有用，有一些争议。内部DNS信息以多种渠道
泄露（例如，通过电子邮件头部），并且大多数聪明的“攻击者”可以使用
其它手段来取得他们所需要的信息。无论如何，由于列出外部客户端不可
能访问到的内部服务器地址可以导致连接延迟和其它烦恼，一个组织可以
选择使用分割DNS来向外部世界提供一个一致的自身视图。

另一个设置一个分割DNS系统的共同的原因是允许在过滤器之后或在
:rfc:`1918` 空间（保留IP空间，在 :rfc:`1918` 中说明）中的内部网
络去查询互联网上的DNS。分割DNS也可以用于允许来自外部的回复邮件进
入内部网络。

.. _split_dns_sample:

分割DNS设置的例子
~~~~~~~~~~~~~~~~~

让我们假设一个名叫 *Example, Inc.* 的公司（ ``example.com`` ）有
几个公司站点，有一个使用保留地址空间的内部网络和一个外部停火区（
DMZ），或称为网络的“外部”部份，是外部可以访问到的。

Example公司想要其内部的客户端可以解析外部主机名并同外面的人们交
换电子邮件。公司也想要其内部的解析器可以访问某些内部才有的区，这
些区对内部网络之外的用户不可用。

为达到这个目标，公司设置两台名字服务器。一台在内部网（在保留地址
空间），另一台在DMZ中的堡垒主机上，堡垒主机是一个“代理”主机，它
可以同其两侧的网络通信。

内部服务器配置成除了对 ``site1.internal`` ， ``site2.internal`` ，
``site1.example.com`` 和 ``site2.example.com`` 之外的所有请求都
转发给在DMZ的服务器。这些内部服务器都有关于 ``site1.example.com`` ，
``site2.example.com`` ， ``site1.internal`` 和 ``site2.internal``
的全部信息。

为保护 ``site1.internal`` 和 ``site2.internal`` 域，内部服务器必须
配置成不允许任何外部主机对这些域的请求来访问，其中也包括堡垒主机。

在堡垒主机上的外部服务器被配置成服务于 ``site1.example.com`` 和
``site2.example.com`` 区的“公共”版本。其中可能包括这样的一些公共服
务器（ ``www.example.com`` 和 ``ftp.example.com`` ）的主机记录以及
邮件交换（MX）记录（ ``a.mx.example.com`` 和 ``b.mx.example.com``
）。

另外，公共的 ``site1.example.com`` 和 ``site2.example.com`` 区应该
有包括通配（ ``*`` ）记录的特定MX 记录指向堡垒主机。这是必须的，因
为外部邮件服务器没有其它任何方式来查到如何将邮件投递到那些内部的主
机。使用通配记录，邮件可以投递到堡垒主机，堡垒主机再将邮件转发到内
部主机。

这里是一个通配MX记录的例子：

::

   *   IN MX 10 external1.example.com.

堡垒主机代表内部网络的任何主机接收邮件，它需要指定如何将邮件投递到
内部主机。堡垒主机上的解析器需要配置成指向内部名字服务器，以完成
DNS解析。

对内部主机的查询请求将由内部服务器回答，对外部主机的查询请求将转发
到堡垒主机上的DNS服务器。

要让所有这些正常工作，内部客户端需要配置成 **只** 请求内部名字服务器。
这个也可以通过网络上的选择性过滤器来进行加强。

如果所有的东西都正确设置，Example公司的内部客户端将能够：

-  查询 ``site1.example.com`` 和 ``site2.example.com`` 区上的所有
   主机。

-  查询 ``site1.internal`` 和 ``site2.internal`` 域上的所有主机。

-  查询互联网上的任何名字。

-  同内部网和外部网上的用户交换电子邮件。

互联网上的主机将能够：

-  查询 ``site1.example.com`` 和 ``site2.example.com`` 区上的所有
   主机。

-  同 ``site1.example.com`` 和 ``site2.example.com`` 区上的任何人
   交换电子邮件。

这里是对我们上述描述进行配置的一个例子。注意这里仅仅有配置信息；
对于如何配置你的区文件的信息，参见 :ref:`sample_configuration` 。

内部DNS服务器配置：

::

   acl internals { 172.16.72.0/24; 192.168.1.0/24; };

   acl externals { bastion-ips-go-here; };

   options {
       ...
       ...
       forward only;
       // forward to external servers
       forwarders {
       bastion-ips-go-here;
       };
       // sample allow-transfer (no one)
       allow-transfer { none; };
       // restrict query access
       allow-query { internals; externals; };
       // restrict recursion
       allow-recursion { internals; };
       ...
       ...
   };

   // sample primary zone
   zone "site1.example.com" {
     type primary;
     file "m/site1.example.com";
     // do normal iterative resolution (do not forward)
     forwarders { };
     allow-query { internals; externals; };
     allow-transfer { internals; };
   };

   // sample secondary zone
   zone "site2.example.com" {
     type secondary;
     file "s/site2.example.com";
     primaries { 172.16.72.3; };
     forwarders { };
     allow-query { internals; externals; };
     allow-transfer { internals; };
   };

   zone "site1.internal" {
     type primary;
     file "m/site1.internal";
     forwarders { };
     allow-query { internals; };
     allow-transfer { internals; }
   };

   zone "site2.internal" {
     type secondary;
     file "s/site2.internal";
     primaries { 172.16.72.3; };
     forwarders { };
     allow-query { internals };
     allow-transfer { internals; }
   };

外部（堡垒主机）DNS服务器配置：

::

   acl internals { 172.16.72.0/24; 192.168.1.0/24; };

   acl externals { bastion-ips-go-here; };

   options {
     ...
     ...
     // sample allow-transfer (no one)
     allow-transfer { none; };
     // default query access
     allow-query { any; };
     // restrict cache access
     allow-query-cache { internals; externals; };
     // restrict recursion
     allow-recursion { internals; externals; };
     ...
     ...
   };

   // sample secondary zone
   zone "site1.example.com" {
     type primary;
     file "m/site1.foo.com";
     allow-transfer { internals; externals; };
   };

   zone "site2.example.com" {
     type secondary;
     file "s/site2.foo.com";
     primaries { another_bastion_host_maybe; };
     allow-transfer { internals; externals; }
   };

堡垒主机上的resolv.conf（或等效的）文件：

::

   search ...
   nameserver 172.16.72.2
   nameserver 172.16.72.3
   nameserver 172.16.72.4

.. _ipv6:

BIND 9对IPv6的支持
-------------------

BIND 9对当前所定义的各种IPv6形式的名字到地址和地址到名字的查找提
供完全的支持。它也可以在具有IPv6的系统上使用IPv6地址来发出请求。

对正向的查找，BIND 9仅支持AAAA记录。 :rfc:`3363` 废除了A6记录的
使用，相应地，作为客户端对A6记录的支持也从BIND 9中去掉了。然而，
权威BIND 9名字服务器仍然可以正确装载包含A6记录的区文件，回答对
A6记录的请求，并接受包含A6记录的区的区传送。

对IPv6反向查找，BIND 9支持传统的“半字节”格式，既可以用于
``ip6.arpa`` 域，也可以用于旧的、被废除的 ``ip6.int`` 域。旧版本
的的BIND 9支持“二进制标记”（也被称为“位串”）格式，但是对二进制标
记的支持已经完全被 :rfc:`3363` 所去掉了。多数BIND 9中的应用完全
不再识别二进制标记格式，如果遇到将会报错。特别的，一个权威BIND 9
名字服务器将不再装载一个包含二进制标记的区文件。

使用AAAA记录查找地址
~~~~~~~~~~~~~~~~~~~~

IPv6的AAAA记录与IPv4的A记录相对应，并且与被废除的A6记录不同，它
在一个记录中指定完整的IPv6地址。例如：

::

   $ORIGIN example.com.
   host            3600    IN      AAAA    2001:db8::1

不推荐使用IPv6内嵌IPv4映射地址。如果一个主机有一个IPv4地址，使用
一个A记录，而不是带有 ``::ffff:192.168.42.1`` 的AAAA记录来作为其
地址。

使用半字节格式从地址查名字
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

在使用半字节格式来查找一个地址时，地址元素只是简单地反转，并且在
反转之后的名字后面添加 ``ip6.arpa.`` ，就像在IPv4中一样。例如，
下面命令产生一个对具有地址 ``2001:db8::1`` 的主机的反向名字查找：

::

   $ORIGIN 0.0.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa.
   1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0  14400   IN    PTR    (
                       host.example.com. )
