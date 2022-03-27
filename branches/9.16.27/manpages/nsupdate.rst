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

.. highlight: console

.. _man_nsupdate:

nsupdate - 动态DNS更新工具
-------------------------------------

概要
~~~~~~~~

:program:`nsupdate` [**-d**] [**-D**] [**-i**] [**-L** level] [ [**-g**] | [**-o**] | [**-l**] | [**-y** [hmac:]keyname:secret] | [**-k** keyfile] ] [**-t** timeout] [**-u** udptimeout] [**-r** udpretries] [**-v**] [**-T**] [**-P**] [**-V**] [ [**-4**] | [**-6**] ] [filename]

描述
~~~~~~~~~~~

``nsupdate`` 是用于提交在 :rfc:`2136` 中所定义的动态DNS更新请求给
一个名字服务器。这允许在不用手工编辑区文件的情况下增加或删除一个
区的资源记录。一个更新请求可以包含增加或删除多个资源记录的请求。

在由 ``nsupdate`` 进行动态控制之下的区或者一个DHCP服务器不应该由
手工编辑。手工编辑可能与动态更新相冲突并导致数据丢失。

使用 ``nsupdate`` 动态增加或删除的资源记录必须在同一个区内。请求
发给区的主服务器，它由区的SOA记录的MNAME字段来标识。

事务签名可以被用于认证动态DNS更新。这些使用在 :rfc:`2845` 中所描
述的TSIG资源记录，在 :rfc:`2535` 和 :rfc:`2931` 中所描述的SIG(0)
记录或者在 :rfc:`3645` 中所描述的GSS-TSIG。

TSIG依赖于一个仅有 ``nsupdate`` 和名字服务器所知道一个共享密钥。
例如，将合适的 ``key`` 和 ``server`` 语句添加到 ``/etc/named.conf``
中，这样名字服务器就可以将合适的密钥和算法与将使用TSIG认证的客
户端应用程序的IP地址相关联。 ``ddns-confgen`` 可以生成合
适的配置片段。 ``nsupdate`` 使用 ``-y`` 或 ``-k`` 选项提供TSIG
共享密码；这些选项是互斥的。

SIG(0)使用公钥加密算法。要使用一个SIG(0)密钥，公钥必须存放在名
字服务器所服务的区的一个KEY记录中。

GSS-TSIG使用Kerberos凭证。标准的GSS-TSIG模式使用 ``-g`` 标志打
开。Windows 2000所使用的一个非标准兼容的GSS-TSIG变体可以用
``-o`` 标志打开。

选项
~~~~~~~

``-4``
   本选项设置只使用IPv4。

``-6``
   本选项设置只使用IPv6。

``-d``
   本选项设置调试模式，它提供关于所生成的更新请求和从名字服务器收到的回
   复的跟踪信息。

``-D``
   本选项设置扩展调试模式。

``-i``
   本选项强制交互模式，即使标准输入不是一个终端。

``-k keyfile``
   本选项指示文件包含TSIG认证密钥。密钥文件可以有两种格式：一个包含
   一个 ``named.conf``-格式的 ``key`` 语句的文件，它可以由
   ``ddns-confgen`` 自动生成；或者一对文件，其文件名格式是
   ``K{name}.+157.+{random}.private`` 和
   ``K{name}.+157.+{random}.key`` ，它们可以由 ``dnssec-keygen``
   生成。 ``-k`` 选项也可用于指定一个用于认证动态DNS更新请求的
   SIG(0)密钥。在这个情况下，所指定的密钥不是一个HMAC-MD5密钥。

``-l``
   本选项设置只local-host模式，它将服务器地址设置为localhost（关闭
   ``server`` ，这样服务器地址就不能被覆盖）。到本地服务器的
   连接使用在 ``/var/run/named/session.key`` 中找到的一个
   TSIG密钥，后者由 ``named`` 自动生成，如果有任何本地 ``primary`` 区的
   ``update-policy`` 设置为 ``local`` 。这个密钥文件的
   位置可以使用 ``-k`` 选项覆盖。

``-L level``
   本选项设置日志的调试级别。如果为0，就关掉日志。

``-p port``
   本选项设置用于连接一个名字服务器的端口。缺省为53。

``-P``
   本选项打印输出私有的BIND特定资源记录类型的列表，这些资源记录类型
   的格式是 ``nsupdate`` 所能理解的。参见 ``-T`` 选项。

``-r udpretries``
   本选项设置UDP重试次数。缺省是3。如果为0，仅仅会生成一次更新请求。

``-t timeout``
   本选项设置一个更新请求在其被中断之前可以持续的最大时间。缺省是300秒。
   如果为0，就关掉超时。

``-T``
   本选项打印输出IANA标准资源记录类型的列表，这些资源记录类型的格式
   是 ``nsupdate`` 所能理解的。 ``nsupdate`` 在打印列表后退
   出。 ``-T`` 选项可以和 ``-P`` 选项组合。

   可以使用 ``TYPEXXXXX`` 输入其它类型，其中 ``XXXXX`` 是不以0开始的
   十进制数值。如果出现了rdata，会使用UNKNOWN rdata格式分析，
   （<backslash> <hash> <space> <length> <space> <hexstring>）。

``-u udptimeout``
   本选项设置UDP重试间隔。缺省是3秒。如果为0，这个间隔会从超时间隔和
   UDP重试次数中计算得到。

``-v``
   本选项指示即使对小的更新请求也使用TCP。缺省时， ``nsupdate`` 使用UDP
   发送更新请求给名字服务器，除非它们太大不能装进一个UDP请求
   中，这种情况将使用TCP。当有一批更新请求时，TCP可能是更优的。

``-V``
   本选项打印版本号并退出。

``-y [hmac:]keyname:secret``
   本选项设置字面的TSIG认证密钥。 ``keyname`` 是密钥的名字，而
   ``secret`` 是base64编码的共享密钥。 ``hmac`` 是密钥算法名；有效的选
   择为 ``hmac-md5`` ， ``hmac-sha1`` ， ``hmac-sha224`` ，
   ``hmac-sha256`` ， ``hmac-sha384`` 或 ``hmac-sha512`` 。如果
   未指定 ``hmac`` ，缺省是 ``hmac-md5`` ，或者如果MD5被禁止，
   则是 ``hmac-sha256`` 。

   注意：不鼓励使用 ``-y`` 选项，因为共享密钥是以明文形式作为命
   令行参数提供的。在ps1的输出或者在用户的shell所维护的历史文件
   中，这个可能是可见的。

输入格式
~~~~~~~~~~~~

``nsupdate`` 从 ``filename`` 或标准输入读取输入。每个命令刚好在
一个输入行内。一些命令是出于管理的目的；其它的命令要么是更新指
令，要么是检查区内容的先决条件。这些检查设置条件，即一些名字或
资源记录集要么存在，要么不存在于区中。如果要让整个更新请求成功，
这些条件必须被满足。如果对先决条件的测试失败，更新将被拒绝。

每个更新请求由0个或多个先决条件以及0个或多个更新所组成。如果某
些指定的资源记录出现或不出现在区中，这允许一个合适的经过认证的
更新请求进行处理。一个空输入行（或 ``send`` 命令）导致所有累积
的命令被作为一个动态DNS更新请求发送给名字服务器。

命令格式及其含义如下：

``server servername port``
   这个命令发送所有更新请求给名字服务器 ``servername`` 。当没有提供
   server语句时， ``nsupdate`` 发送更新请求给正确的区的主服
   务器。这个区的SOA记录中的MNAME字段将会标识这个区的主服务器。
   ``port`` 是动态更新请求发往的 ``servername`` 上的端口号。如
   果没有指定端口号，就使用缺省的DNS端口号53。

``local address port``
   这个命令使用本地 ``address`` 发送所有动态更新请求。当没有提供local
   语句时， ``nsupdate`` 使用系统所选择的一个地址和端口发送
   更新。 ``port`` 还可以用在使请求来自一个指定的端口。如果没
   有指定端口号，系统将会分配一个。

``zone zonename``
   这个命令指定所有的更新都发生在区 ``zonename`` 上。如果没有提供
   ``zone`` 语句， ``nsupdate`` 会试图基于其余的输入来决定正确的区。

``class classname``
   这个命令指定缺省类。如果没有指定 ``class`` ，缺省类是 ``IN`` 。

``ttl seconds``
   这个命令指定要添加记录的缺省生存期。值 ``none`` 将清除缺省生存期。

``key hmac:keyname secret``
   这个命令指定所有的更新都用 ``keyname``-``secret`` 对进行TSIG签名。
   如果指定了 ``hmac`` ，它将设置签名使用的算法。缺省是
   ``hmac-md5`` ，或者如果MD5被禁止，则是 ``hmac-sha256`` 。
   ``key`` 命令覆盖任何在命令行由 ``-y`` 或 ``-k`` 所指定的密
   钥。

``gsstsig``
   这个命令使用GSS-TSIG对更新签名。这个等效于在命令行指定 ``-g`` 。

``oldgsstsig``
   这个命令使用Windows 2000版的GSS-TSIG对更新签名。这个等效于在命令行
   指定 ``-o`` 。

``realm [realm_name]``
   当使用GSS-TSIG时，这个命令用 ``realm_name`` 而不是 ``krb5.conf`` 中
   的缺省realm。如果未指定realm，则已保存的realm将被清除。

``check-names [yes_or_no]``
   这个命令在增加记录时打开或者关闭check-names处理。check-names对被删
   除的先决条件或记录没有影响。缺省时check-names处理是打开的。
   如果check-names处理失败，记录将不会被添加到UPDATE消息中。

``prereq nxdomain domain-name``
   这个命令要求名字 ``domain-name`` 没有存在任何类型的资源记录。

``prereq yxdomain`` domain-name
   这个命令要求 ``domain-name`` 存在（至少有一个资源记录，可以是任何类
   型）。

``prereq nxrrset domain-name class type``
   这个命令要求指定的 ``type`` ， ``class`` 和 ``domain-name`` 不存在任
   何资源记录。如果省略 ``class`` ，就假定为IN（Internet）。

``prereq yxrrset domain-name class type``
   这个要求指定的 ``type`` ， ``class`` 和 ``domain-name`` 必须
   存在一个资源记录。如果省略 ``class`` ，就假定为IN（internet）。

``prereq yxrrset domain-name class type data``
   使用这个命令，来自这种形式的每个先决条件集合的 ``data`` 共享一个共同
   的 ``type`` ， ``class`` 和 ``domain-name`` ，并被组合成一个资
   源记录集合的形式。这个资源记录集合必须精确地匹配区中以
   ``type`` ， ``class`` 和 ``domain-name`` 给出的已存在的资源
   记录集合。 ``data`` 以资源记录RDATA的标准文本表示方法书写。

``update delete domain-name ttl class type data``
   这个命令删除名为 ``domain-name`` 的任何资源记录。如果提供了 ``type``
   和 ``data`` ，只有匹配的资源记录会被删除。如果没有提供
   ``class`` ，就假设是Internet类。 ``ttl`` 被忽略，仅为了兼容
   性而允许之。

``update add domain-name ttl class type data``
   这个命令使用指定的 ``ttl`` ， ``class`` 和 ``data`` 增添一个新的资源
   记录。

``show``
   这个命令显示当前消息，包含自上次发送以来所指定的所有先决条件和更新。

``send``
   这个命令发送当前消息。这等效于输入一个空行。

``answer``
   这个命令显示回答。

``debug``
   这个命令打开调试。

``version``
   这个命令打印版本号。

``help``
   这个命令打印命令表。

以分号(;)开始的行是注释，将被忽略。

例子
~~~~~~~~

下面的例子显示 ``nsupdate`` 如何被用于对 ``example.com`` 区插入
和删除资源记录。注意每个例子中的输入包含一个结尾的空行，这样就
将一组命令作为一个动态更新请求发送给 ``example.com`` 的主名字服
务器。

::

   # nsupdate
   > update delete oldhost.example.com A
   > update add newhost.example.com 86400 A 172.16.1.1
   > send

``oldhost.example.com`` 的任何A记录被删除。 ``newhost.example.com``
的一个带有IP地址172.16.1.1的A记录被添加。新添加的记录具有一个1
天的TTL（86400秒）。

::

   # nsupdate
   > prereq nxdomain nickname.example.com
   > update add nickname.example.com 86400 CNAME somehost.example.com
   > send

先决条件告诉名字服务器核实没有 ``nickname.example.com`` 的任何
类型的资源记录。如果有，更新请求失败。如果这个名字不存在，就为
它添加一个CNAME。这就确保了在添加CNAME时，不会与 :rfc:`1034` 中
的长标准规则相冲突，即如果一个名字存在一个CNAME，就必须不能存在
其它任何记录类型。（这个规则在 :rfc:`2535` 中为DNSSEC而被更新，
以允许CNAME可以有RRSIG，DNSKEY和NSEC记录。）

文件
~~~~~

``/etc/resolv.conf``
   用于标识缺省的名字服务器。

``/var/run/named/session.key``
   设置用于local-only模式的缺省TSIG密钥。

``K{name}.+157.+{random}.key``
   由 ``dnssec-keygen`` 所创建的HMAC-MD5密钥的base-64编码。

``K{name}.+157.+{random}.private``
   由 ``dnssec-keygen`` 所创建的HMAC-MD5密钥的base-64编码。

参见
~~~~~~~~

:rfc:`2136`, :rfc:`3007`, :rfc:`2104`, :rfc:`2845`, :rfc:`1034`, :rfc:`2535`, :rfc:`2931`,
:manpage:`named(8)`, :manpage:`ddns-confgen(8)`, :manpage:`dnssec-keygen(8)`.

缺陷
~~~~

TSIG密钥是冗余存放在两个分离的文件中。这是 ``nsupdate`` 为其加密操作
而使用DST库的一个后果，在将来的版本中可能会变化。
