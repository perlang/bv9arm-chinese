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

.. Advanced:

高级DNS特征
=====================

.. _notify:

通知（Notify）
--------------

DNS NOTIFY是一个让主服务器通知其辅服务器某个区数据发生了变化的机制。作为
对来自主服务器的 ``NOTIFY`` 的响应，辅服务器会检查自己的区版本是否是当前
版本，如果不是，就发起区传送。

更多的关于DNS ``NOTIFY`` 的信息，参见 :ref:`boolean_options` 中对
``notify`` 选项的描述以及 :ref:`zone_transfers` 中对区选项 ``also-notify``
的描述。 ``NOTIFY`` 协议由 :rfc:`1996` 规定。

.. note::

   一个辅服务器也可以成为其它辅服务器的主服务器， ``named`` 在缺省情况下
   会对其所载入的每个区发出 ``NOTIFY`` 消息。指定 ``notify primary-only;``
   将使 ``named`` 只对其所载入区的主服务器发出 ``NOTIFY`` 。

.. _dynamic_update:

动态更新（Dynamic Update）
--------------------------

动态更新是一个通过给主服务器发送一个特殊格式的DNS消息来增加、替换和删除
其上记录的方法。这些消息的格式和含义由 :rfc:`2136` 指定。

动态更新是通过在 ``zone`` 语句中包含一个 ``allow-update`` 或一个
``update-policy`` 子句来打开的。

如果区的 ``update-policy`` 被设为 ``local`` ，对区的更新将由密钥
``local-ddns`` 来许可，后者是由 ``named`` 启动时生成的。更多详细信息，
参见 :ref:`dynamic_update_policies` 。

使用Kerberos签名请求进行的动态更新可以通过使用TKEY/GSS协议来完成，
要么是设置 ``tkey-gssapi-keytab`` 选项，要么是同时设置
``tkey-gssapi-credential`` 和 ``tkey-domain`` 这两个选项。一旦开启
这个功能，Kerberos签名请求将与区的更新策略进行匹配，使用
Kerberos principal作为请求的签名者。

更新一个安全的区（使用DNSSEC的区）遵循 :rfc:`3007` ：受更新影响的
RRSIG、NSEC和NSEC3记录通过服务器使用一个在线区密钥来自动重新生成。
更新授权是基于事务签名和一个显式的服务器策略。

.. _journal:

日志文件
~~~~~~~~~~~~~~~~

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
唯一方法是执行 ``rndc stop`` 。

要手工修改一个动态区，按照下列步骤：首先，使用 ``rndc freeze zone``
关闭到这个区的动态更新；这会使用存放在其 ``.jnl`` 文件中的变化来更新
区文件。然后，编辑区文件。最后，执行 ``rndc thaw zone`` 重新装载
修改后的区文件并打开动态更新。

``rndc sync zone`` 将使用日志文件中的变化更新区文件而不停止动态更新；
这对观察当前区状态是有用的。要在更新区文件之后删除 ``.jnl`` 文件，使
用 ``rndc sync -clean`` 。

.. _incremental_zone_transfers:

增量区传送（IXFR）
---------------------------------

增量区传送（incremental zone transfer, IXFR）协议是一个为辅服务器提供
只传送变化的数据的方式，以代替必须传送整个区的方法。IXFR协议由
:rfc:`1995` 指定。

当作为一个主服务器时，BIND 9支持对这些区的IXFR，条件是必要的变化历史
信息是可用的。这些包括以动态更新维护的主区和通过IXFR获取数据的辅区。
对于手工维护的主区，以及通过全量区传送（AXFR）获取数据的辅区，IXFR仅
在 ``ixfr-from-differences`` 选项被设置成 ``yes`` 时才支持。

当作为一个辅服务器时，BIND 9将尝试使用IXFR，除非其被显式关闭。更多关
于关闭IXFR 的信息，参见 ``server`` 语句的 ``request-ixfr`` 子句的描述。

当一台辅服务器通过AXFR接收一个区，它会创建一个新的区数据库副本，然后
将其交换到适当的位置；在装载过程中，请求继续由旧数据库服务而不受干扰。
但是，当通过IXFR接收一个区，修改应用到正在运行的区，可能会在传输期间
降低查询性能。如果一台收到一条IXFR请求的服务器判断响应的大小类似于一
条AXFR响应的大小，它可能希望发送AXFR作为替代。可以使用
``max-ixfr-ratio`` 选项配置这个判断的阈值。

.. _split_dns:

分割DNS
---------

对DNS空间的内部和外部解析器设置不同的视图通常被称为一个 *split DNS*
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
~~~~~~~~~~~~~~~~~~~~~~~

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

.. _tsig:

TSIG
----

TSIG（Transaction SIGnatures，事务签名）是一个认证DNS消息的机制，
最早在 :rfc:`2845` 中规定。它允许使用一个共享密钥对DNS消息加密签
名。TSIG可以被用于任何DNS事务，可以作为一种限制授权的客户端对某个
服务器功能访问（例如，递归请求）的方法，这时基于IP的访问控制已无
法满足需求或者需要被覆盖，或者作为一种确保消息认证的方法，这时其
对服务器完整性非常关键，例如配合动态更新消息或者从一个主服务器到
一个辅服务器的区传送。

这个部份是一个在BIND中设置TSIG的指导。它描述了配置语法和创建TSIG
密钥的过程。

``named`` 支持TSIG用于服务器到服务器的通信，一些BIND附带工具也支
持TSIG用于发送消息给 ``named`` ：

   * :ref:`man_nsupdate` 支持TSIG，通过 ``-k`` ， ``-l`` 和 ``-y`` 命令行选项，或在交互运行方式下通过 ``key`` 命令。
   * :ref:`man_dig` 支持TSIG，通过 ``-k`` 和 ``-y`` 命令行选项。

生成一个共享密钥
~~~~~~~~~~~~~~~~~~~~~~~

TSIG密钥可以使用 ``tsig-keygen`` 命令生成；命令的输出是一个适合放入
``named.conf`` 的 ``key`` 指令。密钥名，算法名和大小可以由命令行参
数指定；缺省分别是“tsig-key”，HMAC-SHA256和256位。

任意一个有效DNS名字都可以用作一个密钥名，例如，在服务器 ``host1`` 和
``host2`` 之间共享的密钥可以叫做“host1-host2.”，这个密钥可以使用

::

     $ tsig-keygen host1-host2. > host1-host2.key

生成。

然后这个密钥被拷贝到两台主机上。在两台主机上密钥名和密码必须一致。
（注意：从一台服务器到另一台服务器拷贝一个共享密码超出了DNS的范围。
应该使用一个安全的传输机制：安全FTP，SSL，ssh，电话，加密电子邮件
等等。）

``tsig-keygen`` 也可以被用作 ``ddns-confgen`` ，在这种情况下，其输
出包括在 ``named`` 中设置动态DNS所用的附加配置。参见
:ref:`tsig-keygen, ddns-confgen - TSIG key generation
tool <man_tsig-keygen_ddns-confgen>` 获取详细信息。

装载一个新密钥
~~~~~~~~~~~~~~~~~

如果一个密钥在服务器 ``host1`` 和 ``host2`` 之间共享，每个服务器的
``named.conf`` 文件可以添加如下内容：

::

   key "host1-host2." {
       algorithm hmac-sha256;
       secret "DAopyf1mhCbFVZw7pgmNPBoLUq8wEUT7UuPoLENP2HY=";
   };

（这是上面使用 ``tsig-keygen`` 生成的同一个密钥。）

由于这段文本包含一个密码，推荐无论是 ``named.conf`` 还是存放 ``key``
指令的文件都不是任何人可读的，后者是通过 ``include`` 指令包含进
``named.conf`` 。

一旦一个密钥被添加到 ``named.conf`` ，服务器要重启或重新读入配置，
才能识别密钥。如果服务器收到密钥签名的消息，它将能够验证签名。如果
签名有效，响应将会使用同一个密钥签名。

为一台服务器所知的TSIG密钥可以使用命令 ``rndc tsig-list`` 列出。

指示服务器使用一个密钥
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

一个向其它服务器发送请求的服务器必须被告知是否使用一个密钥，以及
如果使用，使用哪个密钥。

例如，必须为一个辅区定义中的 ``primaries`` 语句中的每一个服务器指定
一个密钥；在这种情况下，所有SOA请求消息，NOTIFY消息和区传送请求（
AXFR或IXFR）都将使用指定密钥签名。密钥也可在一个主区或辅区中的
``also-notify`` 语句中指定，导致NOTIFY消息使用指定的密钥签名。

密钥也可以在一个 ``server`` 指令中指定。添加下列内容到 ``host1`` ，
如果 ``host2`` 的IP地址是10.1.2.3，将会导致 **所有** 从 ``host1``
到 ``host2`` 的请求，包括普通DNS请求，使用 ``host1-host2.`` 密钥签
名：

::

   server 10.1.2.3 {
       keys { host1-host2. ;};
   };

``keys`` 语句中可以提供多个密钥，但只能使用第一个。由于这条指令不包
含任何密码，所以它可以放在一个所有人可读的文件中。

从 ``host2`` 发向 ``host1`` 的消息将 **不会** 被签名，除非在
``host2`` 的配置文件中有一个类似的 ``server`` 指令。

无论何时，任何服务器只要发出了一个TSIG签名的DNS请求，它将会期待响应
被同一个密钥签名。如果响应未被签名，或者签名无效，响应将会被拒绝。

基于TSIG的访问控制
~~~~~~~~~~~~~~~~~~~~~~~~~

TSIG密钥可以在ACL定义和诸如 ``allow-query`` ， ``allow-transfer`` 和
``allow-update`` 的ACL指令中指定。上述密钥在一个ACL元素中被表示成
``key host1-host2.`` 。

这里是一个 ``allow-update`` 指令使用一个TSIG密钥的例子：

::

   allow-update { !{ !localnets; any; }; key host1-host2. ;};

这允许动态更新仅仅在UPDATE请求来自一个 ``localnets`` 内的地址，
**并且** 它使用 ``host1-host2.`` 密钥签名时才会成功。

参见 :ref:`dynamic_update_policies` 查看更为灵活的 ``update-policy``
语句的讨论。

错误
~~~~~~

处理TSIG签名消息时可能产生一些错误：

-  如果一个知道TSIG的服务器收到一个它所不知道的密钥的签名消息，响应
   将不会被签名，TSIG扩展错误码将被设置为BADKEY。
-  如果一个知道TSIG服务器收到一个它所知道密钥的却无效的签名消息，响
   应将不会被签名，TSIG扩展错误码将被设置为BADSIG。
-  如果一个知道TSIG的服务器收到一个允许的时间范围之外的消息，响应将
   会被签名，TSIG扩展错误码将被设置为BADTIME，并且时间值将会被调整
   以使响应能够被成功验证。

在以上所有情况中，服务器都将返回一个NOTAUTH响应码（未认证的）。

TKEY
----

TKEY（事务KEY）是一个用于在两台主机之间自动协商一个共享密码的机制，
最早在 :rfc:`2930` 中规定。

有几种TKEY“模式”来指定如何生成和分派一个密钥。BIND 9只实现了这些模
式中的一种：Diffie-Hellman密钥交换。两台主机都需要有一个带DH算法的
KEY记录（虽然并不要求这个记录出现在一个区中）。

TKEY过程由一个客户端或服务器通过发出一个TKEY类型的请求到一个知道
TKEY的服务器开始。请求必须在附加部分包括一个合适的KEY记录，并且必
须用TSIG或者SIG(0)使用先前建立的密钥签名。服务器的响应，如果成功，
必须在其回答部分包括一个TKEY记录。在这个事务之后，两个参与方都有足
够的信息使用Diffie-Hellman密钥交换计算一个共享密码。共享密码就能被
用于两台服务器之间签名随后的事务。

服务器所知的TSIG密钥，包括TKEY协商的密钥，可以使用
``rndc tsig-list`` 列出。

TKEY协商的密钥可以使用 ``rndc tsig-delete`` 从一个服务器删除。这也
可以经由TKEY协议自身，通过发送一个认证的TKEY请求指定“key deletion”
模式来完成。

SIG(0)
------

BIND部份支持 :rfc:`2535` 和 :rfc:`2931` 中所指定的DNSSEC SIG(0)事务
签名。SIG(0)使用公钥/私钥来认证消息。访问控制的执行方式与TSIG密钥相
同；可以基于密钥名授予或拒绝权限。

当收到一个SIG(0)签名消息时，仅仅在服务器知道并相信密钥的情况下才会
验证它；服务器不会试图递归获取或验证密钥。

多个消息的TCP流的SIG(0)签名还不支持。

随同BIND 9发行的生成SIG(0)签名消息的唯一工具是 ``nsupdate`` 。

.. _DNSSEC:

DNSSEC
------

通过 :rfc:`4033` 、 :rfc:`4034` 和 :rfc:`4035` 所定义的DNS安全
（DNSSEC-bis）扩展，DNS信息的加密认证是可能做到的。本节描述了建立
和使用DNSSEC对区签名。

为了设置一个DNSSEC安全的区，有一系列必须遵循的步骤。BIND 9在这个
过程中用到了几个附带的工具，这将在下面详细解释。在所有的情况下，
``-h`` 选项都会打印除一个完整的参数清单。注意，DNSSEC工具要求密
钥集文件在工作目录或者在由 ``-d`` 选项所指定的目录中。

必须同父区和/或子区的管理员通信，以传送密钥。一个区的安全状态必须
由其父区指明，以使支持DNSSEC的解析器相信它所得到的数据。这是通过
在授权点提供或者不提供一个DS记录来完成的。

对其它信任这个区的数据的服务器，它们必须静态地配置这个区的区密钥
或者在DNS树中这个区上面的另一个区的区密钥。

.. _generating_dnssec_keys:

生成密钥
~~~~~~~~~~~~~~~

``dnssec-keygen`` 程序用于生成密钥。

一个加密的区必须包含一个或多个区密钥。区密钥对区中的所有其它记录
签名，也对任何安全授权的区的区密钥签名。区密钥必须有一个与区同样
的名字，一个为 ``ZONE`` 的类型名，并且可以用于认证。推荐区密钥使
用由IETF作为“强制实现”所指定的加密算法；当前有两种算法：
RSASHA256和ECDSAP256SHA256。推荐ECDSAP256SHA256用于当前和将来的
部署。

下列命令为 ``child.example`` 区生成一个ECDSAP256SHA256密钥：

``dnssec-keygen -a ECDSAP256SHA256 -n ZONE child.example.``

将产生两个输出文件： ``Kchild.example.+013+12345.key`` 和
``Kchild.example.+013+12345.private`` （这里的12345是密钥标记的
一个例子）。密钥文件名包含密钥名（ ``child.example.`` ），
算法（5表示RSASHA1，8表示RSASHA256，13表示ECDSAP256SHA256，
15表示ED25519，等等）和密钥标记（在本例中为12345）。私钥
（在 ``.private`` 文件中）用于生成签名，公钥（在 ``.key`` 文件中）
用于验证签名。

要生成同样属性的另一个密钥但是使用一个不同的密钥标记，只需重复
上面的命令。

``dnssec-keyfromlabel`` 程序是用来从一个加密硬件设备获取一个密钥对，
并生成密钥文件。其用法与 ``dnssec-keygen`` 类似。

公钥应该通过使用 ``$INCLUDE`` 语句来包含 ``.key`` 文件的方式插入
到区文件中。

.. _dnssec_zone_signing:

对区签名
~~~~~~~~~~~~~~~~

``dnssec-signzone`` 程序用于对区签名。

任何与安全子区相关的 ``keyset`` 文件都应该出现。区的签名者将为区
生成 ``NSEC`` 、 ``NSEC3`` 和 ``RRSIG`` 记录，如同指定 ``-g`` 选
项时为子区生成的 ``DS`` 记录一样。如果未指定 ``-g`` 选项，就必须
为安全的子区手工添加DS资源记录集。

缺省情况下，所有的区密钥都有一个可用的私钥用来生成签名。下列命令
对区签名，假设它是一个名为 ``zone.child.example`` 的文件。

``dnssec-signzone -o child.example zone.child.example``

会产生一个输出文件： ``zone.child.example.signed`` 。这个文件必
须在 ``named.conf`` 中作为输入文件被引用。

``dnssec-signzone`` 也会生成keyset和dsset文件。它们用于向上
级区管理员提供 ``DNSKEY`` （或者与之相关的 ``DS`` 记录），作为本
区的安全入口点。

.. _dnssec_config:

为DNSSEC配置服务器
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

为了使 ``named`` 验证来自其它服务器的响应，必须将 ``dnssec-validation``
选项设置为 ``yes`` 或 ``auto`` 。

当 ``dnssec-validation`` 被设置为 ``auto`` 时，就会自动使用DNS根
区的一个信任锚。这个信任锚作为BIND的一部份提供并使用 :rfc:`5011`
密钥管理来保持更新。

当 ``dnssec-validation`` 被设置为 ``yes`` 时，仅当在 ``named.conf``
中使用一个 ``trust-anchors`` 语句（或者 ``managed-keys`` 和
``trusted-keys`` 语句，这两者都已被废弃了）至少显式配置了一个信任
锚，才会进行DNSSEC验证。

当 ``dnssec-validation`` 被设置为 ``no`` 时，不会进行DNSSEC验证。

缺省值是 ``auto`` ，除非BIND编译时带有
``configure --disable-auto-validation`` ，这种情况下缺省值是
``yes`` 。

``trust-anchors`` 中指定的密钥是区的DNSKEY资源记录的拷贝，它用于
形成加密信任链的首个链接。使用关键字 ``static-key`` 或
``static-ds`` 配置的密钥被直接装载到信任锚的表中，并且只能通过变
更配置来修改。使用 ``initial-key`` 或 ``initial-ds`` 配置的密钥
用于初始化 :rfc:`5011` 信任锚维护，并在 ``named`` 首次运行之后自
动保持更新。

在本文档的后面有更多关于 ``trust-anchors`` 的详细描述。

BIND 9在装载时不验证签名，所以不必在配置文件中指定权威区的区密钥。

在DNSSEC建立之后，一个典型的DNSSEC配置看起来就像以下内容。它有一
个或多个根的公钥。这可以允许来自外部的响应被验证。本单位所控制的
部份名字空间也需要几个密钥。其作用是确保 ``named`` 不受上级区安
全的DNSSEC组成中的危险因素的影响。

::

   trust-anchors {
       /* Root Key */
       "." initial-key 257 3 3 "BNY4wrWM1nCfJ+CXd0rVXyYmobt7sEEfK3clRbGaTwS
                    JxrGkxJWoZu6I7PzJu/E9gx4UC1zGAHlXKdE4zYIpRh
                    aBKnvcC2U9mZhkdUpd1Vso/HAdjNe8LmMlnzY3zy2Xy
                    4klWOADTPzSv9eamj8V18PHGjBLaVtYvk/ln5ZApjYg
                    hf+6fElrmLkdaz MQ2OCnACR817DF4BBa7UR/beDHyp
                    5iWTXWSi6XmoJLbG9Scqc7l70KDqlvXR3M/lUUVRbke
                    g1IPJSidmK3ZyCllh4XSKbje/45SKucHgnwU5jefMtq
                    66gKodQj+MiA21AfUVe7u99WzTLzY3qlxDhxYQQ20FQ
                    97S+LKUTpQcq27R7AT3/V5hRQxScINqwcz4jYqZD2fQ
                    dgxbcDTClU0CRBdiieyLMNzXG3";
       /* Key for our organization's forward zone */
       example.com. static-ds 54135 5 2 "8EF922C97F1D07B23134440F19682E7519ADDAE180E20B1B1EC52E7F58B2831D"

       /* Key for our reverse zone. */
       2.0.192.IN-ADDRPA.NET. static-key 257 3 5 "AQOnS4xn/IgOUpBPJ3bogzwc
                          xOdNax071L18QqZnQQQAVVr+i
                          LhGTnNGp3HoWQLUIzKrJVZ3zg
                          gy3WwNT6kZo6c0tszYqbtvchm
                          gQC8CzKojM/W16i6MG/eafGU3
                          siaOdS0yOI6BgPsw+YZdzlYMa
                          IJGf4M4dyoKIhzdZyQ2bYQrjy
                          Q4LB0lC7aOnsMyYKHHYeRvPxj
                          IQXmdqgOJGq+vsevG06zW+1xg
                          YJh9rCIfnm1GX/KMgxLPG2vXT
                          D/RnLX+D3T3UL7HJYHJhAZD5L
                          59VvjSPsZJHeDCUyWYrvPZesZ
                          DIRvhDD52SKvbheeTJUm6Ehkz
                          ytNN2SN96QRk8j/iI8ib";
   };

   options {
       ...
       dnssec-validation yes;
   };

..

.. note::

   本例中列出的所有密钥都是无效的。特别是，根密钥是无效的。

当DNSSEC验证被打开并正确地配置后，解析器将会拒绝来自已签名的、安
全的区中未通过验证的响应，并返回SERVFAIL给客户端。

响应可能因为以下任何一种原因而验证失败，包含错误的、过期的、或无
效的签名，密钥与父区中的DS资源记录集不匹配，或者来自一个区的不安
全的响应，而根据它的父区，应该是一个安全的响应。

.. note::

   当验证者收到一个来自一个拥有签名父区的未签名区的响应，它必须
   向其父区确认这个是有意未签名的。它通过验证父区没有包含子区的
   DS记录，即通过签名的和验证了的NSEC/NSEC3记录，来确认这一点。

   如果验证者 **能够** 证明区是不安全的，其响应就是可以接受的。
   然而，如果不能证明，它就必须假设不安全的响应是伪造的；它就拒
   绝响应并在日志中记录一个错误。

   日志记录的错误为“insecurity proof failed”和
   “got insecure response; parent indicates it should be secure”。

.. include:: dnssec.rst
.. include:: managed-keys.rst
.. include:: pkcs11.rst
.. include:: dlz.rst
.. include:: dyndb.rst
.. include:: catz.rst

.. _ipv6:

BIND 9对IPv6的支持
----------------------

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
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
