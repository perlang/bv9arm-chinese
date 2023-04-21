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

.. _reference:

配置参考
========

BIND 9的运行功能使用文件 **named.conf** 定义，典型情况下它位于/etc或
/usr/local/etc/namedb目录下，这取决于操作系统或版本。如果 **rndc** 从
一台远程主机上运行，还需要提供 **rndc.conf** 文件，但是如果rndc运行在
**localhost** （与BIND 9运行在同一个系统上），则其不是必须的。

.. _named_conf:

配置文件（named.conf）
----------------------

文件 :file:`named.conf` 可以包含三种类型的实体：
     
.. glossary::

   Comment
      :ref:`支持多种注释格式 <comment_syntax>` 。

   Block
      :ref:`块 <configuration_blocks>` 是 :term:`语句 <statement>` 的
      容器，而后者可以是通用的功能 - 例如，在一个 :namedconf:ref:`key`
      块中定义一个加密密钥 - 也可以是语句的范围定义 - 例如，一条出现在
      一个 :namedconf:ref:`zone` 块中的语句只能在区范围内适用。

      块在 :file:`named.conf` 中是以层次体系组织的，并且具有一些不同的
      属性：

      - 某些块不能被嵌套在其它块内，因而被称为 **顶级** 块：例如，
        :namedconf:ref:`options` 块和 the :namedconf:ref:`logging` 块。

      - 某些块可以多次出现，这时它们会关联一个名字以示区别：例如，
        :namedconf:ref:`zone` 块（ ``zone example.com { ... };`` ）或
        :namedconf:ref:`key` 块（ ``key mykey { ... };`` ）。

      - 某些块可以被“嵌套”在其它块内。例如， :namedconf:ref:`zone` 块
        可以出现在一个 :namedconf:ref:`view` 块内。

      本手册中每个块的描述列出了其允许的位置。

   Statement
      - 语句定义和控制特定的BIND行为。
      - 语句可以有单一参数（一个 **值** ）或者多个参数（ **参数/值**
        对）。例如， :any:`recursion` 需要单一的值参数 - 在此情况为字
        符串 ``yes`` 或 ``no`` （ ``recursion yes;`` ），而
        :namedconf:ref:`port` 语句需要一个数字值来定义DNS端口号（
        ``port 53;`` ）。更为复杂的语句需要一个或多个 参数/值 对。
        :any:`also-notify` 这样的一些参数/值对，例如
        ``also-notify port 5353;`` ，其中 ``port`` 是参数，而 ``5353``
        是对应的值。
      - 语句可以出现在一个单一的 :term:`block` 中 - 例如，一个
        :namedconf:ref:`algorithm` 语句可以仅出现在一个
        :namedconf:ref:`key` 块中 - 或者在多个块中 - 例如，一个
        :any:`also-notify` 可以出现在一个 :namedconf:ref:`options` 块
        中，这时它具有全局（服务器范围）范围，可以出现在一个
        :any:`zone` 块中，这时其范围仅局限于特定的区（并覆盖任何全局语
        句），或者甚至出现在一个 :any:`view` 块中，这时其范围仅局限于
        这个视图（并覆盖任何全局语句）。

文件 :file:`named.conf` 可能包含一个或多个 :ref:`include <include_grammar>`
**指令** 实例。提供该指令是为管理的便利而组合一个完整的 :file:`named.conf`
文件，在BIND 9运行特性或功能中没有后续作用。

.. Note::
   经过多年的发展，BIND ARM获得了一系列令人眼花缭乱的术语。许多在用的
   术语描述了类似的概念，只是为BIND 9配置增加了一层复杂性，可能造成混
   乱，甚至神秘。ARM现在只使用术语 **块** ， **语句** ， **参数** ，
   **值** 和 **指令** 来描述BIND 9配置中所使用的所有实体。

.. _comment_syntax:

注释语法
~~~~~~~~

BIND 9 注释语法允许注释可以出现在一个 BIND 配置文件中空白字符可以出现
的任何位置。应各种类型的程序员的要求，注释可以写成 C，C++ 或
shell/Perl的风格。

语法
^^^^

.. code-block:: none

   /* This is a BIND comment as in C */

.. code-block:: none

   // This is a BIND comment as in C++

.. code-block:: none

   # This is a BIND comment as in common Unix shells
   # and Perl

定义和用法
^^^^^^^^^^

在一个BIND配置文件中，注释可以插入在任何空白字符可以出现的地方。

C风格的注释以两个字符 /\*（斜线，星号）开始，以 \*/（星号，斜线）结束。
因为其完全以这些字符划界，所以它们可以用于在一行的一部份或跨越多行
时的注释。

C风格的注释不能嵌套。例如，以下是无效的，因为全部注释在第一个 \*/时结
束：

.. code-block:: none

   /* This is the start of a comment.
      This is still part of the comment.
   /* This is an incorrect attempt at nesting a comment. */
      This is no longer in any comment. */

C++风格的注释以两个字符 //（斜线，斜线）开始并持续到一行的结束。它们
不能继续并跨越多个行；要想使一个注释跨越多行，必须在每行都使用 //。
例如：

.. code-block:: none

   // This is the start of a comment.  The next line
   // is a new comment, even though it is logically
   // part of the previous comment.

Shell风格（或者称为Perl风格）的注释以字符 ``#`` （数字号/井号）开始
并持续到一行的结束，与C++注释一样。
例如：

.. code-block:: none

   # This is the start of a comment.  The next line
   # is a new comment, even though it is logically
   # part of the previous comment.

.. warning::

   不能使用分号（ ``;`` ）字符来开始一个注释，这与在一个区文件中不同。
   分号表示一个配置语句的结束。

配置设计风格
~~~~~~~~~~~~

BIND对左右括号/大括号，分号及在后续章节中的正式语法中所定义的所有其它
分隔符非常挑剔。有一些设计风格可以辅助减少错误，示例如下：

.. code-block:: none

	// dense single-line style
	zone "example.com" in{type secondary; file "secondary.example.com"; primaries {10.0.0.1;};};
	//  single-statement-per-line style
	zone "example.com" in{
		type secondary;
		file "secondary.example.com";
		primaries {10.0.0.1;};
	};
	// spot the difference
	zone "example.com" in{
		type secondary;
	file "sec.secondary.com";
	primaries {10.0.0.1;}; };

.. _include_grammar:

``include`` 指令
~~~~~~~~~~~~~~~~

.. code-block:: none

   include filename;

.. _include_statement:

``include`` 指令定义和用法
^^^^^^^^^^^^^^^^^^^^^^^^^^

include指令将指定的文件（或多个文件，如果检测到一个有效的 `通配表达式`_ ）插入到
include指令出现的点。include指令使配置文件的管理更加容易，可以允许读或
者写某些内容，没有其它用途。例如，这个语句可以包含进只有名字服务器才可以读的私钥。

.. _`通配表达式`: https://man7.org/linux/man-pages/man7/glob.7.html

.. _address_match_lists:

地址匹配表
~~~~~~~~~~

语法
^^^^

地址匹配表是一个分号分隔的 :term:`address_match_element` 的列表。

::

   { <address_match_element>; ... };

每个元素定义为：

.. glossary::

   ``address_match_element``

    ::

        [ ! ] ( <ip_address> | <netprefix> | key <server_key> | <acl_name> | { address_match_list } )

定义和用法
^^^^^^^^^^

地址匹配表主要用于决定对各种服务器操作的访问控制。它们通常也用在
:any:`listen-on` 和 :any:`sortlist` 语句中。组成一个地址匹配表的元素可以
是以下的任何一种：

- :term:`ip_address`: 一个IP地址（IPv4或IPv6）

- :term:`netprefix`: 一个IP前缀（以 ``/`` 表示法）

- :term:`server_key`: 一个密钥ID，由 ``key`` 语句所定义的

- :term:`acl_name`: 使用 :any:`acl` 语句定义的地址匹配表的名字

- 包含在花括号中的嵌套的地址匹配表

元素可以使用惊叹号（ ``!`` ）取反，匹配表名“any”、“none”、“localhost”
和“localnets”是预定义的。可以从 ``acl`` 语句的描述中找到这
些名字的更多信息。

增加 key 子句使这个句法元素的名字有些怪异，因为安全密钥可以校验访问而
不需考虑一个主机或网络的地址。虽然如此，“地址匹配表”这个术语仍然
贯穿整个文档。

当一个给定的IP地址或前缀与一个地址匹配表进行比较时，比较需要大致
O(1)的时间。然而，密钥比较要求遍历密钥链表，直到找到一个匹配的
密钥，这样就会较慢一些。

一次匹配的解释依赖于列表是否被使用于访问控制、定义 :any:`listen-on` 端
口，或者在一个 :any:`sortlist` 中，以及元素是否被取反。

当用作一个访问控制表时，非否定的匹配允许访问而否定的匹配拒绝访问。
如果没有匹配，则拒绝访问。子句 :any:`allow-notify`， :any:`allow-recursion`，
:any:`allow-recursion-on`， :any:`allow-query`， :any:`allow-query-on`，
:any:`allow-query-cache`， :any:`allow-query-cache-on`， :any:`allow-transfer`，
:any:`allow-update`， :any:`allow-update-forwarding`， :any:`blackhole` 和
:any:`keep-response-order` 都使用地址匹配表。类似地，:any:`listen-on` 选项
将使服务器拒绝任何发到不与列表匹配的机器地址的请求。

插入的顺序是重要的。如果一个ACL中有超过一个元素与给定的IP地址或
前缀匹配，那么在ACL中 **首先** 定义的就会优先。由于这个首次匹配的特性，
作为列表中某个元素的子集的元素应该放在列表的前面，而不考虑是否是否定
的条目。例如，在 ``1.2.3/24; ! 1.2.3.13;`` 中，元素 1.2.3.13 完全
是无用的，因为算法会将所有对 1.2.3.13 的查找匹配到元素 1.2.3/24 上。
使用 ``! 1.2.3.13; 1.2.3/24`` 修正了这个问题，通过否定符阻
止了1.2.3.13，而让其它的1.2.3.\*主机都通过。

术语汇编
~~~~~~~~

以下是贯穿在BIND配置文件文档中的术语清单：

.. glossary::

    ``acl_name``
        由 ``acl`` 语句所定义的一个 :term:`address_match_list` 的名字。

    ``address_match_list``
        参见 :ref:`address_match_lists` 。

    ``boolean``
        ``yes`` 或 ``no`` 。也可以接受单词 ``true`` 和 ``false`` ，以及 ``1`` 和 ``0`` 。

    ``domain_name``
        用作一个DNS名字的引号内字符串；如： ``my.test.domain`` 。

    ``dscp``
        一个介于 0 到 63 之间的 :term:`integer`，用于给支持差分服务代码点（DSCP）的操作系统的出向流量选择一个 DSCP 值。

    ``fixedpoint``
        一个非负实数，可以被指定为精确到百分之一。小数点前最大五位数，小数点后最大两位，即最大值为 99999.99。可接受的值受到其使用上下文中的更多限制。

    ``integer``
        一个非负 32 位整数（即 0 到 4294967295 （含）之间的整数）。它所能接受的值可能更多地受其使用的上下文所限制。

    ``ip_address``
        一个 :term:`ip4_address` 或者 :term:`ip6_address`。

    ``ip4_address``
        一个 IPv4 地址，严格含有四个值为0到255的整数元素，并以点（ ``.`` ）分隔，
        例如 ``192.168.1.1`` （一个包含完整四个元素的“点分十进制”表示法）。

    ``ip6_address``
        一个 IPv6 地址，如 ``2001:db8::1234``。IPv6 范围地址在其范围区间具有模糊性，必须由一个带有百分号（ ``%`` ）作分隔符的合适的区 ID 来澄清。强烈推荐使用字符串区名字而不是数字标识符，以在系统配置更改时更健壮。然而，由于没有映射这种名字和标识符值的标准，仅仅支持将接口名作为连接标识符。例如，一个连接的本地的地址 ``fe80::1`` 连接到接口 ``ne0`` 可以指定为 ``fe80::1%ne0`` 。注意在大多数系统的连接到本地的地址都有模糊性，需要澄清。

    ``netprefix``
        一个IP网络地址，由一个 :term:`ip_address` 后跟一个斜线（ ``/`` ）和一个代表掩码位数的数字所指定。 :term:`ip_address` 后面的零将被忽略。例如， ``127/8`` 表示网络 ``127.0.0.0`` ，掩码为 ``255.0.0.0`` ，而 ``1.2.3.0/28`` 表示网络 ``1.2.3.0`` ，掩码为 ``255.255.255.240`` 。
        当指定的一个前缀涉及一个IPv6范围地址，这个范围可以被忽略，在这个情况，前缀将会匹配来自任何范围的包。

    ``percentage``
        一个整数值后跟表示百分比的 ``%`` 。

    ``port``
        一个 IP 端口 :term:`integer`。它的范围为 0 到 65535，1024 以下端口被限制为以 root 身份运行的进程所使用。在某些情况下星号（``*``）字符用作占位符，以选择大数目的端口。

    ``portrange``
        一个 :term:`port` 或者端口范围的列表。一个端口范围以 ``range`` 后跟两个 :term:`port` 的形式指定，即 ``port_low`` 和 ``port_high`` ，表示从 ``port_low`` 到 ``port_high`` （含）的端口号。 ``port_low`` 必须小于或等于 ``port_high`` 。例如， ``range 1024 65535`` 表示从 1024 到 65535 的端口。星号（ ``*`` ）字符不允许作为有效 :term:`port` 或者作为端口范围的边界。

    ``remote-servers``
        一个或多个带有可选的 :term:`tls_id` ， :term:`server_key` 和/或 :term:`port` 的命名 :term:`ip_address` 列表。 一个 ``remote-servers`` 可以包含其它 ``remote-servers`` 。参见 :any:`primaries` 块。

    ``server_key``
        一个 :term:`domain_name`，代表一个共享密钥的名字，用在
        :ref:`事务安全 <tsig>` 中。密钥使用 :namedconf:ref:`key` 块定义。

    ``size``
    ``sizeval``
        一个 64 位无符号整数。整数可以取值的范围为 0 <= value <= 18446744073709551615，虽然某些参数（如 :any:`max-journal-size` ）在这个范围中使用更受限的区间。在大多数情况下，设置一个值为 0 不意谓着字面上的零；它表示“未定义”或“尽可能的大”，具体是什么取决于上下文。参见特殊参数的解释以获取 ``size`` 在如何解释其用法的详细信息。数字值后面可以选择跟比例因数：``K`` 或 ``k`` 表示千字节，``M`` 或 ``m`` 表示兆字节，``G`` 或 ``g`` 表示吉字节，其比例分别为乘 1024，1024*1024 和 1024*1024*1024。`

        一些语句也接受关键字 ``unlimited`` 或 ``default``:``unlimited``
        通常表示“尽可能的大”，并且通常是设置一个大数时的最佳方式。
        ``default`` 使用服务器启动时的有效限制。

    ``tls_id``
        一个命名TLS配置对象，它定义了一个TLS密钥和证书。参见 :any:`tls` 块。

.. _configuration_file_grammar:

.. _configuration_blocks:

块
--

BIND 9的配置文件由块，语句和注释组成。

以下是所支持的块：

    :any:`acl`
        定义一个命名的IP地址匹配列表，用于访问控制或其它用途。

    :any:`controls`
        声明控制通道，用于 :iscman:`rndc` 应用程序。

    :any:`dnssec-policy`
        为区描述一个 DNSSEC 密钥和签名策略。详细信息参见 :ref:`dnssec_policy_grammar` 。

    :namedconf:ref:`key`
        指定在使用TSIG时，用于认证和授权的密钥信息。

    :any:`logging`
        指定服务器记录哪些日志，和在哪里记录日志消息。

    ``masters``
        :any:`primaries` 的同义词。

    :namedconf:ref:`options`
        控制全局服务器配置和为其它语句设置缺省参数。

    :any:`parental-agents`
        定义一个命名的服务器列表，以包含在主区和辅区的 :any:`parental-agents` 列表中。

.. _primaries:

    :any:`primaries`
        定义一个命名的主服务器列表，一般包含在存根区和辅区的 :any:`primaries` 或 :any:`also-notify` 列表中。（注意：这是原来的关键字 ``masters`` 的同义词，后者仍可使用，但不再是首选术语。）

    :namedconf:ref:`server`
        为基于单个服务器的配置设置某个配置选项。

    :any:`statistics-channels`
        声明通信通道，以访问 :iscman:`named` 统计信息。

    :any:`tls`
        为一个TLS配置指定配置信息，包括一个 :any:`key-file` ， :any:`cert-file` ， :any:`ca-file` ， :any:`dhparam-file` ， :any:`remote-hostname` ， :any:`ciphers` ， :any:`protocols` ， :any:`prefer-server-ciphers` 和 :any:`session-tickets` 。

    :any:`http`
        为一个HTTP连接指定配置信息，包括 :any:`endpoints` ， :any:`listener-clients` 和 :any:`streams-per-connection` 。

    :any:`trust-anchors`
        定义 DNSSEC 信任锚：如果使用 ``initial-key`` 或 ``initial-ds`` 关键字定义，信任锚将通过使用 :rfc:`5011` 信任锚维护保持更新；如果使用 ``static-key`` 或 ``static-ds`` ，密钥将不变。

    :any:`managed-keys`
        与 :any:`trust-anchors` 相同；这个选项已被废弃，倾向使用 :any:`trust-anchors` 并带 ``initial-key`` 关键字，在未来的版本可能被去掉。

    :any:`trusted-keys`
        定义永久受信任的 DNSSEC 密钥；这个选项已被废弃，倾向使用 :any:`trust-anchors` 并带 ``static-key`` 关键字，在未来的版本可能被去掉。

    :any:`view`
        定义一个视图。

.. _zone_clause:

    :any:`zone`
        定义一个区。

:any:`logging` 和 :namedconf:ref:`options` 语句在每个配置文件中只能出现一次。

:any:`acl` 块语法
~~~~~~~~~~~~~~~~~

.. namedconf:statement:: acl
   :tags: server
   :short: 为一个地址匹配表指定一个符号名字。

:any:`acl` 块定义和用法
~~~~~~~~~~~~~~~~~~~~~~~

:any:`acl` 语句将一个地址匹配列表赋值给一个符号名字。其名字来源于地址匹配
列表的一个主要用途：访问控制表（Access Control Lists，ACLs）。

下列ACL是内建的：

    ``any``
        匹配所有主机。

    ``none``
        匹配空主机。

    ``localhost``
        匹配系统的所有网络接口的IPv4和IPv6地址。当有地址被添加或删除时， ``localhost`` ACL元素被更新以反映变化。

    ``localnets``
        匹配一个系统所在的IPv4或IPv6网络上的所有主机。当有地址被添加或删除时， ``localnets`` ACL元素被更新以反映变化。一些系统不提供决定本地IPv6地址的前缀长度的方法。在这样的情况下， ``localnets`` 只匹配本地 IPv6 地址，如同 ``localhost`` 一样。

.. _controls_grammar:

:any:`controls` 块语法
~~~~~~~~~~~~~~~~~~~~~~

.. namedconf:statement:: controls
   :tags: server
   :short: 指定用于管理名字服务器的控制通道。

.. _controls_statement_definition_and_usage:

:any:`controls` 块定义和用法
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:any:`controls` 语句声明控制通道，其被系统管理员用来管理对名字服务器的
操作。这些控制通道由 :iscman:`rndc` 应用程序使用，它可以发送命令到名字
服务器及从名字服务器获取一些非DNS的结果。

.. namedconf:statement:: unix
   :tags: server
   :short: 指定一个UNIX域套接字作为一个控制通道。

   一个 :any:`unix` 控制通道是一个 UNIX 域套接字，它监听文件系统中指定
   的路径。对这个套接字的访问由 ``perm`` 、 ``owner`` 和 ``group`` 子
   句指定。注意在某些平台（SunOS和Solaris）上，权限（ ``perm`` ）是应
   用在上级目录，而在套接字本身上的权限是被忽略的。

.. namedconf:statement:: inet
   :tags: server
   :short: 指定一个TCP套接字作为一个控制通道。

   一个 :any:`inet` 控制通道是一个监听在指定 :term:`ip_address` 地址上
   的指定 :term:`port` 端口的TCP套接字，可以是IPv4或IPv6地址。一个值为
   ``*`` （星号）的 :term:`ip_address` 被解释成IPv4通配地址；到系统的
   任何IPv4地址的连接都将被接受。要监听IPv6的通配地址，使用值为 ``::``
   的 :term:`ip_address` 。如果 :iscman:`rndc` 只用于本机，使用环回地
   址（ ``127.0.0.1`` 或 ``::1`` ）是最为安全的推荐做法。

   如果没有指定端口，就使用 953 端口。星号 ``*`` 不能用于 :term:`port` 。

   通过控制通道发送命令的能力是被 ``allow`` 和 :any:`keys` 子句所限制
   的。

   ``allow``
      通过基于 :term:`address_match_list` 来允许到控制通道的连接。这只
      是一个简单的基于 IP 地址的过滤； :term:`address_match_list` 中的
      任何 :term:`server_key` 元素都被忽略。

   :any:`keys`
      命令通道的主要授权机制是 :term:`server_key` 列表 ，所列的每个
      :namedconf:ref:`key` 都被授权能够通过控制通道执行命令。关于在
      :iscman:`rndc` 中配置密钥的信息，参见 :ref:`admin_tools` 中的信
      息。

``read-only``
   如果 ``read-only`` 参数为 ``on`` ，控制通道被限制在下列只读命令集中：
   ``nta -dump`` ， :any:`null` ， ``status`` ， ``showzone`` ，
   ``testgen`` 和 ``zonestatus`` 。缺省地， ``read-only`` 未开启，控制
   通道允许读写访问。

如果没有提供 :any:`controls` 语句， :iscman:`named` 将设置一个缺省的控
制通道，监听在环回地址127.0.0.1及其IPv6的对应者::1上。在这样的情况下，
当有 :any:`controls` 语句但是没有提供一个 :any:`keys` 子句时，
:iscman:`named` 将试图从 |rndc_key| 文件中装载命令通道密钥。要建立一个
``rndc.key`` 文件，运行 :option:`rndc-confgen -a` 。

要禁用命令通道，使用一个空的 :any:`controls` 语句： ``controls { };`` 。


.. _key_grammar:

``key`` 块语法
~~~~~~~~~~~~~~
.. namedconf:statement:: key
   :tags: security
   :short: 为使用 :ref:`tsig` 或者命令通道定义一个共享密钥。

.. _key_statement:

``key`` 块定义和用法
~~~~~~~~~~~~~~~~~~~~

``key`` 语句定义了一个共享密钥，用于 TSIG （参见 :ref:`tsig` ）或命令通道
（参见 :ref:`controls_statement_definition_and_usage` ）中。

``key`` 语句可以放在配置文件的顶级或一个 :any:`view` 语句的内部。定义在顶级
``key`` 语句中的密钥可以用于所有视图中。想要用于 :any:`controls` 语句（参见
:ref:`controls_statement_definition_and_usage` ）中的密钥必须定义在顶级中。

:term:`server_key` ，即密钥的名字，是一个唯一标识密钥的域名。它可以用于一个
:namedconf:ref:`server` 语句中，它使发向那台服务器的请求都用这个密钥签名，或者用于地址
匹配表中，以检验所收到的请求是由与这个名字、算法和秘密相匹配的密钥所签名。

.. namedconf:statement:: algorithm
   :tags: security
   :short: 定义用于一个key子句的算法。

   ``algorithm_id`` 是一个指定安全/认证算法的字符串。 :iscman:`named` 服务器支持
   ``hmac-md5`` ， ``hmac-sha1`` ， ``hmac-sha224`` ， ``hmac-sha256`` ，
   ``hmac-sha384`` 和 ``hmac-sha512`` TSIG认证。通过在尾部增加一个以减号开始
   的符合要求位数的最小数字来支持截断散列，如： ``hmac-sha1-80`` 。

.. namedconf:statement:: secret
   :tags: security
   :short: 定义一个Base64编码的字符串，被算法用作密码。

   ``secret_string`` 是算法所用到的秘密，被当作一个 Base64 编码的字符串。

.. _logging_grammar:

:any:`logging` 块语法
~~~~~~~~~~~~~~~~~~~~~

.. namedconf:statement:: logging
   :tags: logging
   :short: 为名字服务器配置日志选项。

.. _logging_statement:

:any:`logging` 块定义和用法
~~~~~~~~~~~~~~~~~~~~~~~~~~~

:any:`logging` 语句为名字服务器配置了广泛的日志选项种类。其 :any:`channel`
短语将输出方法、格式选项和严重级别与一个可以用于 :any:`category` 短语中的
名字联系起来，用以选择多种类别的消息应当如何记入日志。

只能使用一条 :any:`logging` 语句，它可以定义多个想要的通道和类别。
如果没有 :any:`logging` 语句，日志配置将会是：

::

   logging {
        category default { default_syslog; default_debug; };
        category unmatched { null; };
   };

如果 :iscman:`named` 启动时带有 :option:`-L <named -L>` 选项，它将日志
记录到启动时指定的文件，而不是使用syslog。在这个情况，日志配置将会是：

::

   logging {
        category default { default_logfile; default_debug; };
        category unmatched { null; };
   };

日志配置只是在全部的配置文件被分析完成之后才建立。在服务器启动时，所有
关于配置文件中语法错误的日志消息都被写到缺省通道，或者在指定 :option:`-g <named -g>`
选项时被写到标准错误中。

:any:`channel` 短语
^^^^^^^^^^^^^^^^^^^

.. namedconf:statement:: channel
   :tags: logging
   :short: 定义一个可以被独立记录的数据流。

所有的日志输出都写到一个或多个 ``channels`` ；对能够建立的通道数量
没有限制。

每个通道定义必须包含一个目标子句，这个子句中说明此通道的消息是到一
个文件、到特定的 syslog 设施、到标准错误输出流还是被丢弃。作为可选
项，定义还可以限定此通道所接受的消息严重级别（缺省为 ``info`` ），
以及是否包含 :iscman:`named` 所生成的时间戳，类别名字和/或严重级别（缺省
是不包含任何）。

.. namedconf:statement:: null
   :tags: logging
   :short: 使所有发向日志通道的消息都被丢弃。

   ``null`` 目标子句使得所有发送到此通道的消息被丢弃；在此情况下，通道
   的其它选项都没有意义。

``file``
   ``file`` 目标子句将通道定向到一个磁盘文件。它可以包含附加的参数指定
   文件在轮转到一个备份文件之前允许增长到多大（ ``size`` ），指定在每次
   轮转时可以保存多少个文件的备份版本（ ``versions`` ），以及用于命名备
   份版本的格式（ :any:`suffix` ）。

   ``size`` 选项用于限制日志文件的增长。如果文件超过了指定的大小，
   :iscman:`named` 将会停止写到文件，除非它有一个 ``versions`` 选项。
   如果保持备份版本，文件将按照下面描述的方式轮转。如果没有
   ``versions`` 选项，就不会写入更多的数据到日志中，除非有某些带外的机
   制删出日志或者截断日志使其小于最大大小。缺省行为是不限制文件大小。

   文件轮转仅发生在文件超过 ``size`` 选项指定的大小时。缺省不保有备份
   版本；任何存在的日志文件都是简单地添加。 ``versions`` 选项指定文件
   应该保持多少备份版本。如果设置为 ``unlimited`` ，就没有限制。

   :any:`suffix` 选项可以被设置为 ``increment`` 或者 ``timestamp`` 。
   如果被设置为 ``timestamp`` ，当一个日志文件轮转时， 它被保存为以当
   前时间戳作为文件的后缀。如果被设置为 ``increment`` ，备份文件被保存
   为以增加的数字作为后缀；轮转时，更旧的文件都被更名。例如，如果
   ``versions`` 被设置为3并且 :any:`suffix` 被设置为 ``increment`` ，
   那么当 ``filename.log`` 达到 ``size`` 所指定的大小时，
   ``filename.log.1`` 被更名为 ``filename.log.2`` ，
   ``filename.log.0`` 被更名为 ``filename.log.1`` ，而
   ``filename.log`` 被更名为 ``filename.log.0`` ， 同时一个新的
   ``filename.log`` 被打开。

   这里是使用 ``size`` ， ``versions`` 和 :any:`suffix` 选项的一个例子：

   ::

      channel an_example_channel {
          file "example.log" versions 3 size 20m suffix increment;
          print-time yes;
          print-category yes;
      };

.. _syslog:

.. namedconf:statement:: syslog
   :tags: logging
   :short: 定向日志通道到系统日志。

   :any:`syslog` 目标子句将通道导向系统日志。它的参数是在
   :any:`syslog` 手册页中所描述的一个syslog设施。知名的设施有
   ``kern`` ， ``user`` ， ``mail`` ， ``daemon`` ， ``auth`` ，
   :any:`syslog` ， ``lpr`` ， ``news`` ， ``uucp`` ， ``cron`` ，
   ``authpriv`` ， ``ftp`` ， ``local0`` ， ``local1`` ，
   ``local2`` ， ``local3`` ， ``local4`` ， ``local5`` ， ``local6``
   和 ``local7`` ，但是，不是所有的操作系统上都支持所有的设施。
   :any:`syslog` 如何处理发向这些设施的消息在 ``syslog.conf`` 手册页
   中描述。在一个使用非常旧的 :any:`syslog` 版本的系统上，只使用两个参
   数调用 ``openlog()`` 函数，这时这个子句会被静默地忽略。

.. _severity:

.. namedconf:statement:: severity
   :tags: logging
   :short: 定义日志消息的优先级。

   :any:`severity` 子句工作起来像 :any:`syslog` 的“优先级”，只有一点不
   同，就是如果直接写到文件而不是使用 :any:`syslog` 时，也可以使用它们。
   至少达到所使用的严重级别的消息将才会送到此通道；大于严重级别的消息
   会被接受。

   如果使用 :any:`syslog` ， ``syslog.conf`` 优先级也会决定最终的通过
   量。例如，定义一个通道设施，其严重级别为 ``daemon`` 和 ``debug`` ，
   但是通过 ``syslog.conf`` 设置只记录 ``daemon.warning`` ，将会导致严
   重级别为 ``info`` 和 ``notice`` 的消息被扔掉。在相反的情况下，
   :iscman:`named` 只记录 ``warning`` 或更高级别的消息， ``syslogd``
   会记录所有它从这个通道收到的消息。

.. namedconf:statement:: stderr
   :tags: logging
   :short: 定向日志通道输出到服务器的标准错误流。

   :any:`stderr` 目标子句将通道引导到服务器的标准错误流。其意图是在服
   务器作为一个前台进程运行时使用的，例如在调试一个配置时。

服务器在调试模式时可以支持扩展调试信息。如果服务器的全局调试级别大于
0，调试模式将会被激活。全局调试级别可以通过在启动 :iscman:`named` 服务
时带 :option:`-d <named -d>` 标志并后跟一个正整数，或者通过运行
:option:`rndc trace` 。全局调试级别可以设为0，调试模式被关闭，或者通过
运行 ``rndc notrace`` 。服务器中的所有调试信息都有一个调试级别，越高的
调试级别给出越详细的输出。在通道内指定一个特定的调试严重级别，例如：

::

   channel specific_debug_level {
       file "foo";
       severity debug 3;
   };

在服务器工作在调试模式的任何时间时，得到第3级或更低的调试输出，而
无论全局调试级别的设置是多少。严重级别为 ``dynamic`` 的通道使用服
务器的全局调试级别来决定输出哪些消息。

.. namedconf:statement:: print-time
   :tags: logging
   :short: 为日志消息指定时间格式。

   :any:`print-time` 可以被设置为 ``yes`` ， ``no`` 或一个时间格式说明
   符，它可以是 ``local`` ， ``iso8601`` 或 ``iso8601-utc`` 之一。如果
   设置为 ``no`` ，就不将日期和时间记入日志。 如果设置为 ``yes`` 或者
   ``local`` ，日期和时间就以人可读的格式，使用本地时区记入日志。 如果
   设置为 ``iso8601`` ，本地时间以 ISO8601 格式记入日志。 如果设置为
   ``iso8601-utc`` ，日期和时间以 ISO8601 格式记入日志，时区设置为 UTC。
   缺省是 ``no`` 。

   :any:`print-time` 可以用于 :any:`syslog` 通道，但是它通常不这样用，
   因为 :any:`syslog` 也记录日期和时间。

.. namedconf:statement:: print-category
   :tags: logging
   :short: 在日志消息中包含类别。

   如果配置了 :any:`print-category` ，消息的类别也将被记入日志。
   
.. namedconf:statement:: print-severity
   :tags: logging
   :short: 在日志消息中包含严重级别。

   如果打开 :any:`print-severity` ，消息的严重级别将被记入日志。
   ``print-`` 选项可以用在任何组合，并总是按照下列顺序打印：时间，类
   别，严重性。

这里是所有三个 ``print-`` 选项都打开的一个例子：

``28-Feb-2000 15:05:32.863 general: notice: running``

.. namedconf:statement:: buffered
   :tags: logging
   :short: 控制日志消息的刷新。

   如果打开了 :any:`buffered` ，到文件的输出不会在每次日志进入时都刷
   新。缺省是所有日志消息都被刷新。

有四个预定义的通道供 :iscman:`named` 缺省日志使用，具体如下。如果 :iscman:`named`
启动时带有 :option:`-L <named -L>` 选项，就会添加第五个通道 ``default_logfile`` 。如何
使用它们在 :ref:`the_category_phrase` 中描述。

::

   channel default_syslog {
       // send to syslog's daemon facility
       syslog daemon;
       // only send priority info and higher
       severity info;
   };

   channel default_debug {
       // write to named.run in the working directory
       // Note: stderr is used instead of "named.run" if
       // the server is started with the '-g' option.
       file "named.run";
       // log at the server's current debug level
       severity dynamic;
   };

   channel default_stderr {
       // writes to stderr
       stderr;
       // only send priority info and higher
       severity info;
   };

   channel null {
      // toss anything sent to this channel
      null;
   };

   channel default_logfile {
       // this channel is only present if named is
       // started with the -L option, whose argument
       // provides the file name
       file "...";
       // log at the server's current debug level
       severity dynamic;
   };

``default_debug`` 通道具有专门的属性，它只在服务器的调试级别不为零时
才有输出。通常情况下，它会写到服务器工作目录下面一个文件名为
``named.run`` 的文件。

由于安全原因，当使用了 :option:`-u <named -u>` 命令行选项时， ``named.run`` 文件只在
:iscman:`named` 改变为新的UID之后才被创建，并且在 :iscman:`named` 启动时以及仍然以
``root`` 运行时所产生的调试输出都被丢弃。为捕捉这些输出，在运行服务
时使用 :option:`-L <named -L>` 选项指定一个缺省的日志文件，或者使用 :option:`-g <named -g>` 选项记录到
标准错误，这可以重定向它到一个文件。

一旦一个通道被定义后，它不能被重定义。不能直接修改内建的
通道，但是可以修改缺省的日志，即，将类别指向所定义的通道。

.. _the_category_phrase:

:any:`category` 短语
^^^^^^^^^^^^^^^^^^^^

存在许多类别，这样期望的日志可以发送到各处，而忽略不想要的日志。
如果没有为一个类别指定一个通道名单，这个类别下面的日志消息将会被发
送到 ``default`` 类别。如果没有指定一个缺省的类别，就
使用下列“缺省的缺省”：

::

   category default { default_syslog; default_debug; };

如果启动 :iscman:`named` 时带有 :option:`-L <named -L>` 选项，缺省类别是：

::

   category default { default_logfile; default_debug; };

作为一个例子，我们假设一个用户想将安全事件记录到一个文件，但是也想保持
缺省的日志行为。他就会如下设定：

::

   channel my_security_channel {
       file "my_security_file";
       severity info;
   };
   category security {
       my_security_channel;
       default_syslog;
       default_debug;
   };

想丢弃一个类别中的所有消息，指定 :namedconf:ref:`null` 通道：

::

   category xfer-out { null; };
   category notify { null; };

.. namedconf:statement:: category
   :tags: logging
   :short: 指定记录到特定通道的数据类型。

以下是可用类别及其所包含的日志信息类型的简单描述。将来的
BIND发行版会添加更多的类别。


.. include:: logging-categories.inc.rst

.. _query_errors:

``query-errors`` 类别
^^^^^^^^^^^^^^^^^^^^^

``query-errors`` 类别是用于指示特定的请求为什么以及怎样导致错误响应。通常，
这些消息以 ``debug`` 日志级被记录；注意！然而如果请求日志是活跃的，一些消息将以
``info`` 级别记录。日志级别描述如下：

在 ``debug`` 级别 1 或更高 - 或者当请求日志活跃时的 ``info`` - 每个带有
响应码 SERVFAIL 的响应将按如下方式记录日志：

``client 127.0.0.1#61502: query failed (SERVFAIL) for www.example.com/IN/AAAA at query.c:3880``

这表示在源文件 ``query.c`` 的第 3880 行检测到一个导致SERVFAIL的错误。
这个级别的日志消息对识别一个权威服务器中导致 SERVFAIL 的原因特别有帮助。

在 ``debug`` 的级别 2 或更高级别时，会记录导致 SERVFAIL 的递归解析的
详细上下文信息。日志消息将像下面这样：

::

   fetch completed at resolver.c:2970 for www.example.com/A
   in 10.000183: timed out/success [domain:example.com,
   referral:2,restart:7,qrysent:8,timeout:5,lame:0,quota:0,neterr:0,
   badresp:1,adberr:0,findfail:0,valfail:0]

在冒号之前的第一部份表示一个对 www.example.com 的 AAAA 记录
的递归解析在 10.000183 秒内完成，并最终结果导致一个 SERVFAIL，
它是由源文件 ``resolver.c`` 的第 2970 行决定的。

下一个部份显示了所检测到的最终结果和 DNSSEC 验证的最近结果。
当不试图进行验证时，后者总是“成功”。在这个例子中，这个请求可能导致 SERVFAIL，
是因为所有的名字服务器都宕机或不可达，并在 10 秒内产生了一个超时。
很可能不试图进行 DNSSEC 验证。

最后部份，包含在方括号中，显示了这次特定的解析过程中搜集的统计。
``domain`` 字段显示解析器所到达的最深的区；它是最终检测到错误的区。
其它字段的含义在下面的列表中总结。

``referral``
    在解析过程中解析器所收到的引用个数。在上面的 ``example.com`` 中是 2。

``restart``
    解析器试探 ``domain`` 区的远程服务器循环次数。在每一个循环，解析器向 ``domain`` 区的每个已知的名字服务器发送一个请求（有可能重发，取决于响应）。

``qrysent``
    解析器发送到 ``domain`` 区的请求数。

``timeout``
    解析器收到最后响应之后的超时次数。

``lame``
    解析器所检测到的 ``domain`` 区的跛服务器数目。一个服务器被检测为跛服务器，要么是因为一个不正确的响应，要么是在 BIND 9 的地址数据库（ADB）中的查找结果，这个数据库缓存了跛服务器。

``quota``
    解析器不能发出请求的次数，由于它超过了针对某一服务器的取数据限额。

``neterr``
    解析器在发送请求到 ``domain`` 区时遇到的错误结果数目。一个通常的情形是当远程服务器不可达，解析器收到一个“ICMP 不可达”错误消息。

``badresp``
    解析器在发送请求到 ``domain`` 区时所收到的意料之外的响应（ ``lame`` 之外）数目。

``adberr``
    在ADB中查找 ``domain`` 区的远程服务器地址时的失败次数。一个通常的此类情形是远程服务器的名字没有任何地址记录。

``findfail``
    解析远程服务器地址时的失败次数。这是贯穿解析过程的失败总数。

``valfail``
    DNSSEC 验证失败次数。所计算的验证失败贯穿解析过程（不限于 ``domain`` 区），但是应该仅仅是发生在 ``domain`` 内的。

在 ``debug`` 的级 3 或更高级别时，会记录那些与在调试级别 ``debug`` 级别 1
相同的消息，但只对其它错误，而不记录 SERVFAIL。注意，像 NXDOMAIN 这样的
否定响应并不是错误，不会记录在这个调试级。

在 ``debug`` 的级 4 或更高级别时，对 SERVFAIL 之外的其它错误和 NXDOMAIN
这样的否定响应，会记录 ``debug`` 级 2 所记录的详细上下文信息。

.. _parental_agents_grammar:

:any:`parental-agents` 块语法
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. namedconf:statement:: parental-agents
   :tags: zone
   :short: 定义一个授权代理的列表，用于主区和辅区。

.. _parental_agents_statement:

:any:`parental-agents` 块定义和用法
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:any:`parental-agents` 列表允许一个通用的父区代理集合能够很容易地被用
于多个主区和辅区。父区代理是被允许修改一个区的授权信息的实体（在
:rfc:`7344` 中定义）。

.. _primaries_grammar:

:any:`primaries` 语句语法
~~~~~~~~~~~~~~~~~~~~~~~~~

.. namedconf:statement:: primaries
   :tags: zone
   :short: 为一个区定义一个或多个主主服务器。

.. _primaries_statement:

:any:`primaries` 语句定义和用法
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:any:`primaries` 列表让一组共同的主服务器易于被用于多个存根区和辅区，
通过放入后者的 :any:`primaries` 或 :any:`also-notify` 列表中。（注意：
:any:`primaries` 是原来的关键字 ``masters`` 的同义词，后者仍可使用，但
不再是首选术语。）

要强制通过TLS发送区传送请求，使用 :any:`tls` 关键字，例如
``primaries { 192.0.2.1 tls tls-configuration-name; };`` ，其中
``tls-configuration-name`` 指的是先前定义的
:any:`tls statement <tls>` 。 

.. warning::

   请注意，到主服务器的TLS连接是 **未认证的** ，除非在正在使用的
   :any:`tls statement <tls>` （参见 :ref:`Strict TLS <strict-tls>` 和
   :ref:`Mutual TLS <mutual-tls>` 查看更多详细内容）中指定
   :any:`remote-hostname` 或 :any:`ca-file` 。 **非认证模式** 模式提供
   了对被动观察攻击的保护，但不能保护对区传送的中间人攻击。

.. _options_grammar:

``options`` 块语法
~~~~~~~~~~~~~~~~~~

.. namedconf:statement:: options
   :tags: server
   :short: 定义BIND 9使用的全局选项。

这是 :iscman:`named.conf` 文件中 ``options`` 语句的语法：

.. _options:

``options`` 块定义和用法
~~~~~~~~~~~~~~~~~~~~~~~~

``options`` 语句设置 BIND 所使用的全局选项。这个语句在一个配置文件中只能
出现一次。如果没有 ``options`` 语句，将会使用一个 options 块，其中包含
每个选项的缺省值。

.. _attach-cache:

.. namedconf:statement:: attach-cache
   :tags: view
   :short: 允许多个视图共享一个单一的缓存数据库。

   这个选项允许多个视图共享一个缓存数据库。缺省时每个视图拥有自己的缓
   存数据库，但是如果多个视图在名字解析和缓存上有同样的操作策略，通过
   使用这个选项，这些视图可以共享一个缓存数据库来节约内存，并有可能提
   高解析效率。

   :any:`attach-cache` 选项也可以在 :any:`view` 语句中指定，这种情况下，
   它会覆盖全局的 :any:`attach-cache` 选项。

   ``cache_name`` 指定要共享的缓存。当 :iscman:`named` 服务器配置要共
   享一个缓存的视图时，它使用指定的名字为这些共享视图中的第一个视图建
   立一个缓存。其余的视图只是简单地引用已经建立的视图。

   一个通常的共享一个缓存的配置是允许所有的视图共享一个视图。这个可以
   通过在全局选项中为 :any:`attach-cache` 指定一个任意名字而完成。

   另一个可能的操作是允许全部视图中的一个子集共享一个缓存，而其它的视
   图使用各自的缓存。例如，如果有三个视图A，B和C，并且只有A和B应该共享
   一个缓存，指定 :any:`attach-cache` 选项作为视图A（或B）的选项，使其
   引用其它的视图名：

   ::

        view "A" {
          // this view has its own cache
          ...
        };
        view "B" {
          // this view refers to A's cache
          attach-cache "A";
        };
        view "C" {
          // this view has its own cache
          ...
        };

   共享同一个缓存的视图必须在可能影响缓存的配置参数上有同样的策略。当
   前的实现要求在这些视图在下列配置选项上要一致： :any:`check-names` ，
   :any:`dnssec-accept-expired` ， :any:`dnssec-validation` ，
   :any:`max-cache-ttl` ， :any:`max-ncache-ttl` ，
   :any:`max-stale-ttl` ， :any:`max-cache-size` ，
   :any:`min-cache-ttl` ， :any:`min-ncache-ttl` 和
   :any:`zero-no-soa-ttl` 。

   注意有可能其它参数也会带来混乱，如果它们在不同的视图共享一个缓存时
   不一致的话。例如，如果这些视图定义不同的转发者集合，而这些转发者对
   同样的问题可能返回不同的回答，共享这些回答可能就没有意义甚至是有害
   的。确保在不同的视图中的配置差异不会导致对共享缓存的破坏是系统管理
   员的责任。

.. _directory:

.. namedconf:statement:: directory
   :tags: server
   :short: 设置服务器的工作目录。

   这个设置服务器的工作目录。所有在配置文件中出现的非绝对路径都是相对
   于这个目录的。服务器的大多数输出文件（例如： ``named.run`` ）都是以
   此为缺省位置。如果未指定目录，工作目录缺省为’.’，即服务器开始运行的
   目录。这个目录应该被指定为一个绝对路径，并且 **必须** 对
   :iscman:`named` 进程的有效用户ID是可写的。

   该选项仅在分析配置选项时生效；如果其它文件在指定新的
   :any:`directory` 之前或之后被包含， :any:`directory` 选项必须在任何
   其它可以使用相对路径文件的指令(如 ``include``)之前列出。最安全的包
   含文件的方法是使用绝对文件名。

.. namedconf:statement:: dnstap
   :tags: logging
   :short: 开启对 :any:`dnstap` 信息的日志。

   :any:`dnstap` 是一个捕捉和记录DNS流量的快速、灵活的方法。由 Farsight
   Security 公司的 Robert Edmonds 所开发，并由多个 DNS 实现所支持，
   :any:`dnstap` 使用 ``libfstrm`` （一个轻量级高速框架库，参见
   https://github.com/farsightsec/fstrm ）发送以协议缓冲（
   ``libprotobuf-c`` ，一个由Google公司所开发的序列化结构数据的机制；
   参见 https://developers.google.com/protocol-buffers）编码的事件荷载。

   要在编译时开启 :any:`dnstap` ， ``fstrm`` 和 ``protobuf-c`` 库必须是
   可用的，并且 BIND 必须在配置时使用 ``--enable-dnstap`` 。

   :any:`dnstap` 选项是一个带括号的、被记录消息类型的列表。这些在每个视
   图中可以被设置为不同的值。支持的类型是 ``client`` ， ``auth`` 
   ``resolver`` ， ``forwarder`` 和 ``update`` 。 指定类型 ``all`` 将
   使所有 :any:`dnstap` 消息被日志记录，而不考虑其类型。

   每种类型可以接受一个额外的参数来指定是否记录 ``query`` 消息或
   ``response`` 消息；如果未指定，则请求和响应都记录。

   例如：要记录所有的权威请求和响应，递归客户端的响应和解析器发出的上
   游请求，使用：

   ::

      dnstap {
        auth;
        client response;
        resolver query;
      };

   .. note:: 在缺省配置中，递归解析器流量的dnstap输出不包括服务器端套
      接字所使用的IP。这是因为，除非显式地设置了
      :ref:`query source address <query_address>`，否则这些套接字都绑
      定到通配IP地址，确定每个套接字使用的特定IP地址需要发出系统调用
      （即导致性能损失）。

   所记录的 :any:`dnstap` 消息可以使用 :iscman:`dnstap-read` 应用程序
   进行分析（参见 :ref:`man_dnstap-read` 获取详细信息）。

   更多关于 :any:`dnstap` 的信息，参见 http://dnstap.info。

   fstrm 库有许多可调项提供给 :iscman:`named.conf` ，并且如果需要增进性能或
   者阻止数据丢失，可以修改它们。可调项有：

   .. namedconf:statement:: fstrm-set-buffer-hint
      :tags: logging
      :short: 设置在强制一次缓存刷新之前输出缓存中累计的字节数。

      在强制刷新一个缓冲区之前允许输出缓存中
      积累的字节数限额。最小值是 1024，最大值是 65536，缺省值是 8192。

   .. namedconf:statement:: fstrm-set-flush-timeout
      :tags: logging
      :short: 设置未刷新数据保留在输出缓存中的秒数。

      允许待刷新数据停留在输出缓存中的秒数。
      最小值是 1 秒，最大值是 600 秒（10 分钟），缺省值是 1 秒。

   .. namedconf:statement:: fstrm-set-output-notify-threshold
      :tags: logging
      :short: 设置在唤醒I/O线程之前一个输入队列中允许的未完成队列条目数。

      在唤醒I/O线程之前允许存在
      于一个输入队列中的未解决队列条目的数目。最小值是 1，缺省值是 32.

   .. namedconf:statement:: fstrm-set-output-queue-model
      :tags: logging
      :short: 设置用于队列对象的队列语义。

      控制队列语义以使用队列对象。缺
      省值是 ``mpsc`` （多个生产者，单个消费者）；另外的选项是 ``spsc``
      （单个生产者，单个消费者）。

   .. namedconf:statement:: fstrm-set-input-queue-size
      :tags: logging
      :short: 设置为每个输入队列分配的队列条目数。

      为每个输入队列申请的队列条目的数
      目。这个值必须是 2 的整数次幂。最小值是 2，最大值是 16384，缺省值
      是 512。

   .. namedconf:statement:: fstrm-set-output-queue-size
      :tags: logging
      :short: 设置为每个输出队列分配的队列条目数。

      为每个输出队列申请的队列条目的数目。最小值是 2，最大值依赖于系统
      并基于 ``IOV_MAX`` ，缺省值是 64。

   .. namedconf:statement:: fstrm-set-reopen-interval
      :tags: logging
      :short: 设置在两次试图重新打开一个已关闭输出流之间等待的秒数。

      在重新打开一个已关闭输出流之间需要等待的秒数。最小值是 1 秒，最
      大值是 600 秒（10 分钟），缺省值是 5 秒。为方便起见，可以为这个
      值指定TTL风格的时间单位后缀。

   注意以上所有最小值、最大值和缺省值都由 ``libfstrm`` 库设置，并且可能
   服从这个库未来版本的变化。参见 ``libfstrm`` 文档以获得更多信息。

.. namedconf:statement:: dnstap-output
   :tags: logging
   :short: 配置 :any:`dnstap` 帧流被发送到的路径。

   如果 :any:`dnstap` 在编译时开启并被激活，这个配置 :any:`dnstap` 框
   架流的发送路径。

   第一个参数要么是 ``file`` ，要么是 ``unix`` ，指明目标是一个文件或
   UNIX 域套接字。第二个参数是一个文件或者一个 UNIX 域套接字。（注意：
   当使用一个套接字时， :any:`dnstap` 消息仅在另一个进程，例如
   ``fstrm_capture`` （由 ``libfstrm`` 提供），监听了这个套接字时才发
   送。）

   如果第一个参数是 ``file`` ，就可以最大添加三个附加选项： ``size``
   指示一个 :any:`dnstap` 日志文件在轮转到一个新文件之前可以增长到的最
   大大小； ``versions`` 指定要保持的已经轮转的日志文件的数量；而
   :any:`suffix` 指示是以一个增长的计数器（ ``increment`` ）还是以当前
   时间戳（ ``timestamp`` ）作为已经轮转的日志文件的后缀。这些类似于在
   一个 :any:`logging` 通道中的 ``size`` ， ``versions`` 和
   :any:`suffix` 选项。缺省是允许 :any:`dnstap` 日志文件增长到任何大小
   而没有轮转。

   :any:`dnstap-output` 只能在 :namedconf:ref:`options` 中全局设置。当
   前，它只能在 :iscman:`named` 运行时设置一次；一旦设置，不能通过
   :option:`rndc reload` 或 :option:`rndc reconfig` 修改。

.. namedconf:statement:: dnstap-identity
   :tags: logging
   :short: 指定一个要在 :any:`dnstap` 消息中发送的 ``identity`` 字符串。

   这个指定一个要在 :any:`dnstap` 消息中发送的 ``identity`` 字符串。如
   果设置为 :any:`hostname` ，这是缺省的，将发送服务器主机名。如果设置
   为 ``none`` ，不发送标识字符串。

.. namedconf:statement:: dnstap-version
   :tags: logging
   :short: 指定一个要在 :any:`dnstap` 消息中发送的 :any:`version` 字符串。

   这个指定一个要在 :any:`dnstap` 消息中发送的 :any:`version` 字符串。
   缺省是 BIND 的版本号。如果设置为 ``none`` ，不发送版本字符串。

.. namedconf:statement:: geoip-directory
   :tags: server
   :short: 指定包含GeoIP数据库文件的目录。

   当 :iscman:`named` 编译时带有 MaxMind GeoIP2 地理位置 API 时，这指
   定包含GeoIP数据库文件的目录。缺省时，这个选项是基于编译
   ``libmaxminddb`` 模块时用到的前缀：例如，如果库时安装在
   ``/usr/local/lib`` ，则缺省的 :any:`geoip-directory` 是
   ``/usr/local/share/GeoIP`` 。参见 :any:`acl` 以获取关于 ``geoip``
   ACL 更详细的内容。

.. namedconf:statement:: key-directory
   :tags: dnssec
   :short: 指示能够找到DNSSEC公钥和私钥文件的目录。

   当对安全区执行一次动态更新时，这是能够从中找到 DNSSEC 公钥和私钥文
   件的目录，如果不是当前工作目录。（注意这个选项对如同 ``bind.keys`` ，
   ``rndc.key`` 或 ``session.key`` 这样包含非 DNSSEC 密钥的文件的路径
   时无效。）

.. namedconf:statement:: lmdb-mapsize
   :tags: server
   :short: 为以LMDB数据库格式的新区数据库的内存映射设置最大大小。

   当 :iscman:`named` 构建时带有 liblmdb，这个选项为映射 new-zone 数据库（NZD），
   以 LMDB 数据库格式，设置最大的内存大小。这个数据库用于存储使用
   :option:`rndc addzone` 添加的区的配置信息。注意这不是 NZD 数据库文件的大小，而
   是数据库可能增长到的最大大小。

   由于数据库文件是内存映射，它的大小被 :iscman:`named` 进程的地址空间所限制。缺省
   值选择 32 兆字节适合用于 32 位的 :iscman:`named` 构建。最大允许的值是 1 太字节。
   假设没有复杂 ACL 的典型区配置，一个 32 MB 的 NZD 文件应该能够容纳大约
   100,000 个区的配置。

.. namedconf:statement:: managed-keys-directory
   :tags: dnssec
   :short: 指定保存跟踪被管理DNSSEC密钥的文件的目录。

   这个指定保存跟踪被管理DNSSEC密钥的文件的目录（即，这些配置在一条
   :any:`trust-anchors` 语句中使用 ``initial-key`` 或 ``initial-ds`` 关键字）。
   缺省时，它就是工作目录。这个目录对 :iscman:`named` 进程的有效用户ID **必须**
   是可写的。

   如果 :iscman:`named` 被配置为没有使用视图，服务器的被管理密钥会保存在一个名为
   ``managed-keys.bind`` 的文件中。否则，被管理密钥在不同的文件中被跟踪，
   每个视图一个文件；每个文件名都是视图名（或者，如果视图名包含不能用于文件
   名的字符，就是视图名的SHA256 HASH值），再加上后缀 ``.mkeys`` 。

   （注意：在先前的版本中，视图对应的文件名总是使用视图名的 SHA256 hash。
   为确保以后升级的兼容性，如果发现存在一个使用旧名字格式的文件，将使用新格
   式来替换。）

.. namedconf:statement:: max-ixfr-ratio
   :tags: transfer
   :short: 为区传送请求的IXFR响应设置最大大小。

   这个设置一个增量传输大小的阈值（表示为完整区的一个百分比），在响应
   区传送请求时，如果超过了这个阈值， :iscman:`named` 会选择一个 AXFR
   响应而不是 IXFR。参见 :ref:`incremental_zone_transfers` 。

   最小值是 ``1%`` 。关键字 ``unlimited`` 禁止比例检查并允许任何大小的
   IXFR。缺省值是 ``100%`` 。

.. namedconf:statement:: new-zones-directory
   :tags: zone
   :short: 为由 :option:`rndc addzone` 所增加的区指定配置参数存储的目录。

   这个指定存放通过 :option:`rndc addzone` 增加的区的配置参数的存放目
   录。缺省时，这就是工作目录。如果设置为一个相对路径，它将是相对于工
   作目录。这个目录 **必须** 是 :iscman:`named` 进程的有效用户ID可写的。

.. namedconf:statement:: qname-minimization
   :tags: query
   :short: 控制在BIND 9解析器中QNAME最小化行为。

   这个选项控制BIND解析器中QNAME最小化行为。当设置为 ``strict`` 时，
   BIND将严格遵循QNAME最小化算法，如同在 :rfc:`7816` 中所描述。将这
   个选项设置为 ``relaxed`` 将使BIND回退到普通（非最小化）请求模式，即
   当它收到NXDOMAIN或其它不可预期的响应（如，SERVFAIL，不正确的区截断，
   REFUSED）时成为一个最小化请求。 ``disabled`` 完全关闭 QNAME 最小化。
   ``off`` 是 ``disabled`` 的同义词。当前缺省是 ``relaxed`` ，但是在未
   来的版本中可能被改为 ``strict`` 。

.. namedconf:statement:: tkey-gssapi-keytab
   :tags: security
   :short: 设置用于GSS-TSIG更新的KRB5 keytab文件。

   用于 GSS-TSIG 更新的 KRB5 keytab文件。如果设置了这个选项并且没有设置
   ``tkey-gssapi-credential`` ，允许使用与指定 keytab 中的一个
   principal 相匹配的任何密钥进行更新。

.. namedconf:statement:: tkey-gssapi-credential
   :tags: security
   :short: 为GSS-TSIG协议所请求的认证密钥设置安全凭据。

   安全证书，服务器应该用它来认证GSS-TSIG协议所请求的密钥。当前只能使用
   Kerberos 5认证，并且证书是一个 Kerberos 主，服务器可以通过缺省的系统
   密钥文件，一般是 ``/etc/krb5.keytab`` ，来获取它。keytab 文件的位置
   可以使用 :any:`tkey-gssapi-keytab` 选项来重载。通常这个主是这样的形式
   ``DNS/server.domain`` 。要使用 GSS-TSIG，如果没有使用
   :any:`tkey-gssapi-keytab` 设置一个特定的 keytab，就必须设置
   :any:`tkey-domain` 。

.. namedconf:statement:: tkey-domain
   :tags: security
   :short: 设置添加到由 ``TKEY`` 生成的所有共享密钥名的域名。

   添加到由 ``TKEY`` 生成的所有共享密钥名的域名。当一个客户端请求进行
   ``TKEY`` 交换时，它可以指定所期望的密钥的名字，也可以不指定。如果指定，
   共享密钥的名字是 ``client-specified part`` + :any:`tkey-domain` 。否则，
   共享密钥的名字是 ``random hex digits`` + :any:`tkey-domain` 。在大多数情
   况下， ``domainname`` 应该是服务器的域名，或者是一个不存在的子域，如
   ``_tkey.domainname`` 。如果使用了 GSS-TSIG，必须定义这个变量，除非使用
   :any:`tkey-gssapi-keytab` 指定了一个特定的 keytab。

.. namedconf:statement:: tkey-dhkey
   :tags: security
   :short: 设置服务器用于生成共享密钥的Diffie-Hellman密钥。

   这是服务器所使用的 Diffie-Hellman 密钥，它用来生成与客户端共享的密钥，
   使用 ``TKEY`` 的 Diffie-Hellman 模式。服务器必须能够从工作目录的文件中
   加载公钥和私钥。在大多数情况下， ``key_name`` 应该是服务器的主机名。

.. namedconf:statement:: dump-file
   :tags: logging
   :short: 指示在 :option:`rndc dumpdb` 之后服务器转储数据库到文件的路径名。

   这是在服务器收到 :option:`rndc dumpdb` 命令时，转储数据到文件的路径
   名。如果未指定，缺省为 ``named_dump.db`` 。

.. namedconf:statement:: memstatistics-file
   :tags: logging
   :short: 设置服务器在退出时将内存使用统计写到的文件路径。

   这是服务器在退出时，将内存使用统计写到的文件路径。如果没有指定，缺省是
   ``named.memstats`` 。

.. namedconf:statement:: lock-file
   :tags: server
   :short: 设置 :iscman:`named` 首次启动时试图获取一个文件锁的文件的路径名。

   这是 :iscman:`named` 首次启动时试图在其中获取一个文件锁的一个文件的
   路径名；如果不成功，服务器将会终止，这是假设另一个服务器已经正在运
   行中。如果未指定，缺省是 ``none`` 。

   指定 ``lock-file none`` 关闭使用一个锁文件。如果 :iscman:`named` 使
   用 :option:`-X <named -X>` 选项运行， :any:`lock-file` 将被忽略，它被
   这个选项所覆盖。如果 :iscman:`named` 被重新加载或者重新配置，对
   :any:`lock-file` 的修改将被忽略；它仅在服务器初次启动时有效。

.. namedconf:statement:: pid-file
   :tags: server
   :short: 指定服务器将其进程ID写到的文件的路径名。

   这是服务器将其进程号写入的文件。如果未指定，缺省为 |named_pid| 。
   PID文件是用于要向正在运行的名字服务器
   发送信号的程序。指定 ``pid-file none`` 关闭使用一个 PID 文件；不写文件，
   如果已经有一个，将被删除。注意 ``none`` 是一个关键字，不是一个文件名，
   所以不使用双引号将其包含。

.. namedconf:statement:: recursing-file
   :tags: server
   :short: 指定服务器通过 :option:`rndc recursing` 将当前正在递归的查询转储到的文件的路径名。

   这是在服务器收到 :option:`rndc recursing` 命令时，转储当前递归请求到文件的路
   径名。如果未指定，缺省为 ``named.recursing`` 文件。

.. namedconf:statement:: statistics-file
   :tags: logging, server
   :short: 指定服务器在使用 :option:`rndc stats` 时将统计增添到的文件的路径名。

   这是在服务器收到 :option:`rndc stats` 命令时，追加统计数据的文件路径。如果未
   指定，缺省为服务器当前目录下的 ``named.stats`` 文件。这个文件的格式在
   :ref:`statsfile` 中描述。

.. namedconf:statement:: bindkeys-file
   :tags: dnssec
   :short: 指定覆盖由 :iscman:`named` 所提供的内建信任密钥的文件的路径名。

   这是用于覆盖由 :iscman:`named` 所提供的内置信任密钥的文件的路径名。
   更详细的内容参见对 :any:`dnssec-validation` 的讨论。如果未指定，缺
   省是 |bind_keys| 。

.. namedconf:statement:: secroots-file
   :tags: dnssec
   :short: 指定服务器在使用 :option:`rndc secroots` 时将安全根转储到的文件的路径名。

   这是在服务器收到 :option:`rndc secroots` 命令时，转储安全根的目的文件的路径
   名。如果未指定，缺省为 ``named.secroots`` 。

.. namedconf:statement:: session-keyfile
   :tags: security
   :short: 指定由 :iscman:`named` 生成，用于 ``nsupdate -l`` 的TSIG会话密钥所写入的文件的路径名。

   这是存放一个由 :iscman:`named` 所生成的、用于 ``nsupdate -l`` 的
   TSIG 会话密钥的文件的路径名。如果未指定，缺省是 |session_key| 。
   （参见 :ref:`dynamic_update_policies` ，特别是对 :any:`update-policy`
   语句的 ``local`` 选项的讨论，以获取关于这个特征的更多信息。）

.. namedconf:statement:: session-keyname
   :tags: security
   :short: 指定TSIG会话密钥的密钥名。

   这是用于 TSIG 会话密钥的密钥名。如果未指定，缺省是 ``local-ddns`` 。

.. namedconf:statement:: session-keyalg
   :tags: security
   :short: 指定TSIG会话密钥所用的算法。

   这是用于 TSIG 会话密钥的算法。有效值为 hmac-sha1，hmac-sha224，
   hmac-sha256，hmac-sha384，hmac-sha512 和 hmac-md5。如果未指定，缺省为
   hmac-sha256。

.. namedconf:statement:: port
   :tags: server, query
   :short: 指定服务器用于接收和发送DNS协议流量的UDP/TCP端口号。

   这是服务器用于接收和发送DNS协议流量的 UDP/TCP 端口。缺省是 53。这个
   选项的主要目的是服务器测试；一个使用53端口之外的服务器将无法与全球
   的DNS进行通信。

.. namedconf:statement:: tls-port
   :tags: server, query
   :short: 指定服务器用于接收和发送DNS-over-TLS协议流量的TCP端口号。

   这是服务器用于接收和发送DNS-over-TLS协议流量的TCP端口号。缺省是853。

.. namedconf:statement:: https-port
   :tags: server, query
   :short: 指定服务器用于接收和发送DNS-over-HTTPS协议流量的TCP端口号。

   这是服务器用于接收和发送DNS-over-HTTPS协议流量的TCP端口号。缺省是
   443。

.. namedconf:statement:: http-port
   :tags: server, query
   :short: 指定服务器用于接收和发送经由HTTP的未加密DNS流量的TCP端口号。

   这是服务器用于接收和发送经过HTTP的未加密DNS流量的TCP端口号。（当加密
   由第三方软件或反向代理处理时，可能有用的配置）。

.. namedconf:statement:: http-listener-clients
   :tags: server
   :short: 基于每个监听者限制活跃并发连接的数目。

   这个基于每个监听者为活跃的并发连接数设置一个硬限制。缺省值是300；设
   置为0就取消配额。

.. namedconf:statement:: http-streams-per-connection
   :tags: server
   :short: 基于每个连接限制活跃并发HTTP/2流的数目。

   这个基于每个连接为活跃的并发HTTP/2流数设置一个硬限制。缺省值是100；
   设置为0就取消限制。一旦超过限制，服务器就终结HTTP会话。

.. namedconf:statement:: dscp
   :tags: server, query
   :short: 指定全局差分服务代码点（DSCP），对出向的DNS流量进行分类。

   这是全局的差分服务代码点（DSCP，Differentiated Services Code Point）
   值，用于在支持DSCP的操作系统上分类所出向的DNS流量。有效值为从0到
   63。缺省未配置。

.. namedconf:statement:: random-device
   :tags: server, security
   :short: 指定一个服务器使用的熵源。

   这指定一个服务器使用的熵源；这是一个从中读取熵的设备或文件。如果它
   是一个文件，在文件被耗尽时，请求熵的操作将会失败。

   熵被用于加密操作中，例如TKEY事务，签名区的动态更新和生成TSIG会话密
   钥。它也用于伪随机数生成器的生成种子和扰动，伪随机数生成器用于较不
   太关键的要求随机性的函数，如DNS消息事务ID的生成。

   如果未指定 :any:`random-device` ，或者它被设置为 ``none`` ，将会从
   BIND所链接到的加密库（即，OpenSSL或者一个PKCS#11提供者）所提供的随
   机数生成函数中读取熵。

   :any:`random-device` 选项在服务器启动时的初始配置装载时生效，而在随
   后的重载将会忽略它。

.. namedconf:statement:: preferred-glue
   :tags: query
   :short: 控制在一个A或者AAAA响应中粘连记录的顺序。

   如果指定，在一个请求响应的附加部份内的其它粘连记录之前，所列的类型
   （A 或AAAA）将被写入。缺省是优先为A记录，如果在响应经由IPv4到达的请
   求时，以及优先为AAAA记录，如果在响应经由IPv6到达的请求时。

.. _root-delegation-only:

.. namedconf:statement:: root-delegation-only
   :tags: query
   :short: 使用一个可选的排除列表，在顶级域（TLD）和根区打开只授权模式的增强特性。

   这使用一个可选的排除列表，在顶级域（TLD）和根区中打开只授权模式的增强特性。

   只授权区期待接受和回复 DS 请求。这样的请求和响应被当成只授权处理的一个例外，
   并且不能转换 NXDOMAIN 响应，前提是没有找到请求名字的 CNAME 记录。

   如果一个只授权区的服务器同时也作为一个子区的服务器，就不可能都能够判断
   一个应答是来自于只授权区还是子区。SOA 记录、NS 记录和 DNSKEY 记录是区顶点
   仅有的记录，并且包含这些记录或者 DS 记录的一个匹配的响应被当作是来自于一
   个子区。同时也检查 RRSIG 记录看其是否被一个子区签名。还要检查权威部份看是
   否有应答来自子区的迹象。被确认为来自一个子区的应答不会被转换为 NXDOMAIN
   响应。尽管有所有这些检查，在同时提供一个子区服务时，仍然存在错误否定响应的
   可能性。

   类似地，错误肯定响应也可能产生于只授权区中的空节点（名字中没有记录）且请求
   类型不是 ANY 时。

   注意一些 TLD 不是只授权的；如：“DE”，“LV”，“US”和“MUSEUM”。这个列表并不
   穷尽。

   ::

      options {
          root-delegation-only exclude { "de"; "lv"; "us"; "museum"; };
      };

.. namedconf:statement:: disable-algorithms
   :tags: dnssec
   :short: 对一个指定的区禁用DNSSEC算法。

   这关掉在指定名字下的指定DNSSEC算法。允许使用多个
   :any:`disable-algorithms` 语句。只有最与 :any:`disable-algorithms`
   匹配的子句将被用于决定使用哪个算法。

   如果所有支持的算法都被关闭，由 :any:`disable-algorithms` 所覆盖的区
   将被视为不安全的。

   在 :any:`trust-anchors` （或 :any:`managed-keys` 或
   :any:`trusted-keys` ）中配置的信任锚如果匹配到被关闭的算法，会被忽
   略，就如同他们未被配置一样。

.. namedconf:statement:: disable-ds-digests
   :tags: dnssec, zone
   :short: 对一个指定的区禁用DS摘要类型。

   这关闭在指定的名字及之下名字的指定的 DS 摘要类型。允许使用多个
   :any:`disable-ds-digests` 语句。只有最与 :any:`disable-ds-digests`
   匹配的子句将被用于决定使用哪个摘要类型。

   如果所有支持的摘要类型都被关闭，由 :any:`disable-ds-digests` 所覆盖
   的区将被视为不安全的。

.. namedconf:statement:: dnssec-must-be-secure
   :tags: dnssec
   :short: 定义必须或者不必安全（被签名和校验）的层次体系。

   这指定必须或者不必安全（被签名和校验）的层次体系。如果是 ``yes`` ，
   :iscman:`named` 将仅仅接受安全的回答。如果为 ``no`` ，应用普通的
   DNSSEC 校验，也接受不安全的回答。指定的域必须为其定义一个信任锚，例
   如在一个 :any:`trust-anchors` 语句中，或者
   ``dnssec-validation auto`` 必须被激活。

.. namedconf:statement:: dns64
   :tags: query
   :short: 指示 :iscman:`named` 在没有AAAA记录时给AAAA查询返回对应的IPv4地址。

   这条指令指示 :iscman:`named` 在没有找到AAAA记录时，给AAAA查询返回对
   应的IPv4地址。其意图是用于和NAT64相配合。每个 :any:`dns64` 定义一个
   DNS64前缀。可以定义多个DNS64前缀。

   按照 :rfc:`6052` ，兼容的IPv6前缀可以有32，40，48，56，64和96这些长
   度。其中的位 64..71 必须为 0，且带有位置 0 的前缀最高位。 

   另外，使用合成的CNAME记录为前缀创建一个反向IP6.ARPA区，提供了一个从
   IP6.ARPA名字到对应的IN-ADDR.ARPA名字的映射。
  
   .. namedconf:statement:: dns64-server
      :tags: server
      :short: 指定 :any:`dns64` 区的服务器名字。

   .. namedconf:statement:: dns64-contact
      :tags: server
      :short: 指定 :any:`dns64` 区的联系人名字。

      :any:`dns64-server` 和 :any:`dns64-contact` 可以用于指定服务器的
      名字和区的联系人。这些也可以在view/options级中设置，而不能在每个
      前缀的基础上设置。

      如果没有使用 :any:`ipv4only-enable` 显式关闭。 :any:`dns64` 将建
      立IPV4ONLY.ARPA。

   .. namedconf:statement:: clients
      :tags: query
      :short: 指定受一条给定 :any:`dns64` 指令影响的客户端的一个访问控制表（ACL）。

      每个 :any:`dns64` 支持一个可选的 :any:`clients` 访问控制表，它决
      定哪些客户端受这条指令的影响。如果未设置，缺省值为 ``any;`` 。

   .. namedconf:statement:: mapped
      :tags: query
      :short: 指定IPv4地址的一个访问控制表（ACL），它在 :any:`dns64` 中被映射到相应的A资源记录集。

      每个 :any:`dns64` 块支持一个可选的 :any:`mapped` 访问控制表，它
      在相关的A资源记录集中选择哪些IPv4地址会被映射。如果未设置，缺省
      值为 ``any;`` 。

   .. namedconf:statement:: exclude
      :tags: query
      :short: 允许忽略一个IPv6地址列表，如果他们出现在 :any:`dns64` 中的一个域名的AAAA记录中。

      通常地，DNS64不会应用于一个拥有一个或多个AAAA记录的域名；只是简
      单地返回这些记录。可选的 :any:`exclude` 访问控制表允许规定一个
      IPv6地址的列表，如果它们出现在一个域名的AAAA记录中，将被忽略，并
      且DNS64将被用于这个域名所拥有的任何A记录。如果未定义，
      :any:`exclude` 缺省为::ffff:0.0.0.0/96。

   .. namedconf:statement:: suffix
      :tags: query
      :short: 为 :any:`dns64` 中被映射的IPv4地址位定义结尾位。

      也可以定义一个可选的 :any:`suffix` ，用来设置映射到IPv4地址位的
      结尾部分。缺省时这些位被设置为 ``::`` 。这些位匹配的前缀和映射的
      IPv4地址必须为零。

   .. namedconf:statement:: recursive-only
      :tags: query
      :short: 切换是否仅对递归查询进行 :any:`dns64` 合成。

      如果 :any:`recursive-only` 被设置为 ``yes`` ，DNS64合成仅仅发生
      在递归请求。缺省是 ``no`` 。

   .. namedconf:statement:: break-dnssec
      :tags: query
      :short: 开启 :any:`dns64` 合成，即使验证的结果可能导致一个DNSSEC验证失败。

      如果 :any:`break-dnssec` 被设置为 ``yes`` ，将会进行DNS64合成，
      即使结果在验证时会导致一个DNSSEC验证失败。如果这个选项被设置为
      ``no`` （缺省值），进来的请求中带有DO位，在可用的记录中有RRSIG，
      这时不会进行DNS64合成。

   ::

          acl rfc1918 { 10/8; 192.168/16; 172.16/12; };

          dns64 64:FF9B::/96 {
              clients { any; };
              mapped { !rfc1918; any; };
              exclude { 64:FF9B::/96; ::ffff:0000:0000/96; };
              suffix ::;
          };

.. namedconf:statement:: ipv4only-enable
   :tags: query
   :short: 如果配置了一个 :any:`dns64` 块，开启自动IPv4区。
    
   这个开启或关闭自动区 ``ipv4only.arpa``,
   ``170.0.0.192.in-addr.arpa`` 和 ``171.0.0.192.in-addr.arpa`` 。

   缺省时，如果配置了 :any:`dns64` ，这些区都会被加载。

.. namedconf:statement:: ipv4only-server
   :tags: query
   :short: 指定由 :any:`dns64` 创建的 IPV4ONLY.ARPA 区的服务器名字。

.. namedconf:statement:: ipv4only-contact
   :tags: query
   :short: 指定由 :any:`dns64` 创建的 IPV4ONLY.ARPA 区的联系人。

   :any:`ipv4only-server` 和 :any:`ipv4only-contact` 可以用于指定由
   :any:`dns64` 所创建的IPV4ONLY.ARPA区的服务器名字和联系人。
    
.. namedconf:statement:: dnssec-loadkeys-interval
   :tags: dnssec
   :short: 设置对DNSSEC密钥仓库进行自动检查的频率。

   当一个区配置了 ``auto-dnssec maintain;`` ，必须定期检查其密钥仓库，
   以查看是否有新密钥被添加或者任何现有密钥的时间元数据被更新（参见
   :ref:`man_dnssec-keygen` 和 :ref:`man_dnssec-settime` ）。
   :any:`dnssec-loadkeys-interval` 选项设置仓库自动检查的频率，以分钟计。
   缺省是 ``60`` （1小时），最小是 ``1`` （1分钟），最大是 ``1440``
   （24小时）；任何更大的值将被静默地减小。

:namedconf:ref:`dnssec-policy`

   它为区指定使用哪个密钥和签名策略（KSAP）。这是一个指向一
   个 :namedconf:ref:`dnssec-policy` 块的字符串。缺省是 ``none`` 。

.. namedconf:statement:: dnssec-update-mode
   :tags: dnssec
   :short: 控制对DNSSEC签名进行定期的维护。

   如果在一个 :any:`type primary` 类型的区中这个选项被设为其缺省值
   ``maintain`` ，而这个区是DNSSEC签名的并被配置为允许动态更新（参见
   :ref:`dynamic_update_policies` ），并且如果 :iscman:`named` 能够访
   问区的私有签名密钥， :iscman:`named` 就会自动对所有新的或修改过的记
   录签名并通过重新生成RRSIG记录维护区的签名，无论其是否过期。

   如果这个选项被改为 ``no-resign`` ， :iscman:`named` 将只对所有新的
   或修改过的记录签名，但不安排对签名的维护。

   对这两个设置中的任何一种，如果签名密钥是未激活或者对 :iscman:`named` 不可
   用， :iscman:`named` 都会拒绝对一个DNSSEC签名区的更新。（一个计划的第三个
   选项， ``external`` ，将会关闭所有自动签名并允许将DNSSEC数据提交给一
   个通过动态更新的区；这个还未实现。）

.. namedconf:statement:: nta-lifetime
   :tags: dnssec
   :short: 对由 :option:`rndc nta` 添加的否定信任锚指定以秒计的生命周期。

   这个为由 :option:`rndc nta` 所添加的否定信任锚指定以秒计的缺省生命周期。

   一个否定信任锚选择性关闭对已知将会因为错误配置而非攻击导致验证失败的
   区的DNSSEC验证。当要被验证的数据处于一个活跃的NTA（及其之上任何其它
   已配置的信任锚）或之下， :iscman:`named` 将终止DNSSEC验证过程并将数据作为
   非安全的（insecure）而不是伪造的（bogus）。这会持续直到NTA的生命周期
   结束。NTA的持久化会跨越 :iscman:`named` 的重启。

   为方便起见，TTL风格的时间单位后缀可以用于指定以秒，分钟或小时为单位
   的NTA生命周期。它也接受 ISO 8601 的持续时间格式。

   :any:`nta-lifetime` 缺省是一小时。它不能超过一周。

.. namedconf:statement:: nta-recheck
   :tags: dnssec
   :short: 指定检查由 :option:`rndc nta` 添加的否定信任锚是否仍然需要的时间间隔。

   这指定检查由 :option:`rndc nta` 所添加的否定信任锚是否仍然需要的频繁程度。

   一个否定信任锚通常用在一个域由于操作错误而停止验证；它暂时关闭对这个
   域的DNSSEC验证。为了确保DNSSEC验证尽快恢复， :iscman:`named` 将周期性发送
   一个请求到这个域，忽略否定信任锚，以发现其是否可以被验证。如果可以，
   允许否定信任锚提前过期。

   对某个NTA的正确性检查可以通过使用 :option:`rndc nta -f <rndc nta>`
   关闭，或者将 :any:`nta-recheck` 设置为零关闭所有NTA。

   为方便起见，TTL风格的时间单位后缀可以用于指定以秒，分钟或小时为单位
   的NTA重检查间隔。它也接受 ISO 8601 的持续时间格式。

   缺省是五分钟。它不能超过 :any:`nta-lifetime` （后者不能超过一周）。

:any:`max-zone-ttl`
   :tags: zone, query
   :short: 指定一个最大可能的以秒计的生存期（TTL）值。

   这应该作为 :namedconf:ref:`dnssec-policy` 的一部份来配置。对于已经
   配置了 :namedconf:ref:`dnssec-policy` 的任何区，在
   :namedconf:ref:`options` ， :namedconf:ref:`view` 和
   :namedconf:ref:`zone` 块中使用这个选项没有任何效果。

   :any:`max-zone-ttl` 指定一个最大可能的以秒计的TTL值。为方便起见，
   TTL风格的时间单位后缀可以用于指定最大值。在装载一个区文件时，任何带
   有超过 :any:`max-zone-ttl` 的TTL值的记录都将导致区被拒绝。
   
   这在DNSSEC维护的区中很有用，因为在轮转到一个新DNSKEY时，旧密钥需要
   保持可用，直到RRSIG记录从缓存中过期。 :any:`max-zone-ttl` 选项保证
   区中的最大TTL不会比所设置的值更大。

   当用于 :namedconf:ref:`options` ， :namedconf:ref:`view` 和
   :namedconf:ref:`zone` 块中时，将 :any:`max-zone-ttl` 设置为0等效于
   “unlimited”。

.. namedconf:statement:: stale-answer-ttl
   :tags: query
   :short: 指定以秒计的返回的旧答复的生存期（TTL）值。

   这为旧答复指定TTL。缺省是30秒。最小的允许值是1秒；一个为0的值将被静
   默地更改为1秒。

   对要返回的旧答复，它们必须打开，要么在配置文件中使用
   :any:`stale-answer-enable` 或者通过
   :option:`rndc serve-stale on <rndc serve-stale>` 。

.. namedconf:statement:: serial-update-method
   :tags: zone
   :short: 指定用于SOA记录中区序列号的更新方法。

   被配置为动态DNS的区可以使用这个选项设置用于更新SOA记录中区序列号的更
   新方法。

   使用缺省的设置 ``serial-update-method increment;`` ，SOA序列号将会在
   每次区被更新时加一。

   当设置为 ``serial-update-method unixtime;`` 时，SOA序列号将被设置为
   UNIX纪元以来的秒数，除非序列号已经大于或等于那个值，这时它只是简单的
   加一。

   当设置为 ``serial-update-method date;`` 时，新的SOA序列号将是
   “YYYYMMDD”格式的当前日期，后跟两个零，除非已存在的序列号已经大于或等
   于那个值，这时它只是加一。

.. namedconf:statement:: zone-statistics
   :tags: zone, logging
   :short: 控制为所有区收集的统计的级别。

   如果为 ``full`` ，服务器搜集所有区的统计数据，除非在每个区的配置中
   被关掉，这可以通过在 :any:`zone` 语句中指定
   ``zone-statistics terse`` 或 ``zone-statistics none`` 来实现。例如，
   统计数据包括DNSSEC签名操作和每种查询类型的权威响应的数量。缺省是
   ``terse`` ，提供对区的最小统计（包括名字和当前序列号，但不含请求类
   型计数器）。

   这些统计可以通过 ``statistics-channel`` 访问到，或使用
   :option:`rndc stats` 来访问，后者将把数据存放在
   :any:`statistics-file` 所指定的文件中。参见 :ref:`statsfile` 。

   为向后兼容早期的BIND 9版本， :any:`zone-statistics` 选项也可接受
   ``yes`` 或 ``no`` ； ``yes`` 与 ``full`` 有同样的含义。对于
   BIND 9.10， ``no`` 与 ``none`` 有同样的含义；之前的版本，它与
   ``terse`` 相同。

.. _boolean_options:

布尔选项
^^^^^^^^

.. namedconf:statement:: automatic-interface-scan
   :tags: server
   :short: 控制当添加或删除地址时自动重新扫描网络接口。

   如果为 ``yes`` 且操作系统支持，在接口地址被添加或删除时自动扫描网络
   接口。缺省是 ``yes`` 。这个配置选项不影响基于时间的
   :any:`interface-interval` 选项，并且推荐在操作员确定操作系统支持自
   动接口扫描时，将基于时间的 :any:`interface-interval` 设置为0。

   ``automatic-interface-scan`` 的实现使用了路由套接字 [#]_ 进行网络接
   口发现，因此，要使这个特性能够工作，操作系统必须支持路由套接字。

.. [#]
   译注：原文为routing sockets

.. namedconf:statement:: allow-new-zones
   :tags: server, zone
   :short: 控制在运行时通过 :option:`rndc addzone` 添加区的能力。

   如果为 ``yes`` ，就可以在运行时通过 :option:`rndc addzone` 添加区。
   缺省为 ``no`` 。

   新添加区的配置参数被存储，这样在服务器重启后也可以持久化。配置信息保
   存在一个名为 ``viewname.nzf`` （或者，如果 :iscman:`named` 是带liblmdb编
   译，在一个名为 ``viewname.nzd`` 的LMDB数据库文件中）。“viewname”是视
   图的名字，除非视图名包含不能用于文件名中的字符，这种情况下使用一个视
   图名的加密hash作为替代。

   运行时添加的区的配置要么存储在一个new-zone文件（NZF），要么存储在一
   个new-zone数据库（NZD）中，取决于 :iscman:`named` 在编译时是否链接了
   liblmdb。参见 :ref:`man_rndc` 以获取关于 :option:`rndc addzone` 的更多细节。

.. namedconf:statement:: auth-nxdomain
   :tags: query
   :short: 重置BIND，在作为一个解析器时，是否提供权威的NXDOMAIN（域名不存在）答复。

   如果为 ``yes`` ，总是在NXDOMAIN响应中设置 ``AA`` 位，即使服务器并非
   实际的权威服务器。缺省为 ``no`` 。

.. namedconf:statement:: memstatistics
   :tags: server, logging
   :short: 控制是否在退出时将内存统计写到由 :any:`memstatistics-file` 所指定的文件。

   这个在退出时写内存统计到由 :any:`memstatistics-file` 所指定的文件。
   缺省是 ``no`` ，除非在命令行指定 :option:`-m record <named -m>` ，
   在这种情况下，它是 ``yes`` 。

.. namedconf:statement:: dialup
   :tags: transfer
   :short: 压缩区维护以使所有区传送在每个 :any:`heartbeat-interval` 进行一次，理想情况在一次调用中完成。

   如果为 ``yes`` ，服务器将所有区当成通过即时拨号线路进行区传送，拨号
   连接是由此服务器的流量所引发。虽然这个设置依据不同的区类型有不同的效
   果，它压缩了区维护，以使每个动作快速发生，每个
   :any:`heartbeat-interval` 进行一次，理想情况在一次调用中完成。它也
   抑制了一些通常的区维护流量。缺省为 ``no`` 。
      
   如果在 :any:`view` 和 :any:`zone` 语句中指定了 :any:`dialup` 选项，
   会覆盖全局的 :any:`dialup` 选项。

   如果区是一个主区，服务器将会向其所有辅发出一个NOTIFY请求（缺省的）。
   这将会触发辅服务器（假设其支持NOTIFY）检查区的序列号，允许辅服务器
   在连接有效时对区进行验证。NOTIFY所发向的服务器可以通过
   :namedconf:ref:`notify` 和 :any:`also-notify` 来进行控制。

   如果区是辅区或存根区，服务器将会超越普通的“区更新”（refresh）请求，
   而只会在 :any:`heartbeat-interval` 过期时执行，附带发送NOTIFY请求。

   可以通过使用 :namedconf:ref:`notify` ，它仅仅发送NOTIFY消息；使用 
   ``notify-passive`` ，它发送NOTIFY消息并禁止普通刷新请求；使用 
   ``refresh`` ，它禁止普通刷新处理并在 :any:`heartbeat-interval` 过期
   时发送刷新请求；以及使用 ``passive`` ，它关闭普通刷新处理等来进行更
   细的控制。

   +--------------------+-----------------+-----------------+-----------------+
   | dialup mode        | normal refresh  | heart-beat      | heart-beat      |
   |                    |                 | refresh         | notify          |
   +--------------------+-----------------+-----------------+-----------------+
   | ``no``             | yes             | no              | no              |
   | (default)          |                 |                 |                 |
   +--------------------+-----------------+-----------------+-----------------+
   | ``yes``            | no              | yes             | yes             |
   +--------------------+-----------------+-----------------+-----------------+
   | ``notify``         | yes             | no              | yes             |
   +--------------------+-----------------+-----------------+-----------------+
   | ``refresh``        | no              | yes             | no              |
   +--------------------+-----------------+-----------------+-----------------+
   | ``passive``        | no              | no              | no              |
   +--------------------+-----------------+-----------------+-----------------+
   | ``notify-passive`` | no              | no              | yes             |
   +--------------------+-----------------+-----------------+-----------------+

   注意，普通的NOTIFY进程不受 :any:`dialup` 的影响。

.. namedconf:statement:: flush-zones-on-shutdown
   :tags: zone
   :short: 控制在名字服务器退出时，是否刷新未完成的区信息写磁盘操作。

   当服务器由于收到SIGTERM信号而退出时，刷新或不刷新未完成的区信息写磁
   盘操作。缺省为 ``flush-zones-on-shutdown no`` 。

.. namedconf:statement:: root-key-sentinel
   :tags: server
   :short: 控制BIND 9是否响应对根密钥标记的探测。

   如果为 ``yes`` ，按照 `draft-ietf-dnsop-kskroll-sentinel-08 <https://datatracker.ietf.org/doc/html/draft-ietf-dnsop-kskroll-sentinel-08>`_ 中所描述的响
   应对根密钥标记的探测。缺省是 ``yes`` 。

.. namedconf:statement:: reuseport
   :tags: server
   :short: 开启套接字的内核负载均衡。

   本选项在支持它的系统上，包括Linux（SO_REUSEPORT）和FreeBSD（
   SO_REUSEPORT_LB），开启套接字的内核负载均衡。这指内核基于一个散列机
   制在网络线程之间分配入向的套接字连接。更多信息，参见 ``ethtool`` 手
   册页中接收网络流分类选项（ ``rx-flow-hash`` ）。缺省是 ``yes`` 。

   开启 :any:`reuseport` 显著地增加了总吞吐量，因为入向的流量被均匀地
   分配给操作系统的进程。然而，在一个工作线程忙于一个持久的操作时，如
   处理一个响应策略区（RPZ），或者目录区的更新，或者不寻常的较大的区传
   送，散列到该线程的入向流量将会被延迟。在这些事件频繁发生的服务器上，
   关闭套接字负载均衡可能是更好的选择，这样其它线程可以获得原本会被发
   给繁忙线程的流量。

   注意：本选项只能在 ``named`` 首次启动时设置。重配置时的修改将不会生
   效；服务器必须重启。

.. namedconf:statement:: message-compression
   :tags: query
   :short: 控制DNS名字压缩是否被用在给普通请求的响应中。

   如果为 ``yes`` ，DNS名字压缩被用在给普通请求（不包含AXFR或IXFR，这两
   个总是使用压缩）的响应中。设置这个选项为 ``no`` 能减少服务器上的CPU
   使用并可能提高吞吐量。然而，它增加了响应的大小，这可能导致更多的请求
   使用TCP处理；一个关闭压缩的服务器是与 :rfc:`1123` 的6.1.3.2.节不兼容
   的。缺省是 ``yes`` 。
		  
.. namedconf:statement:: minimal-responses
   :tags: query
   :short: 控制服务器是否只添加必须的记录（例如，授权，否定响应）到权威和附件数据部份）。这提高了服务器的性能。

   这个选项控制对响应的权威和附加部份添加记录。这类记录可以被添加到响应
   中以帮助客户端；例如，NS 或 MX 记录可以附带相应的地址记录在附加部份，
   避免了一次额外的地址查询。然而，向响应中添加这些记录不是必须的，且需
   要额外的数据库查找，在安排响应时带来额外的延迟。
   :any:`minimal-responses` 的取值为下列四种之一：

   -  ``no`` ：服务器在生成响应时将尽可能完整。
   -  ``yes`` ：服务器将只添加 DNS 协议所要求的记录到权威和附加部份（例
      如，在返回授权或否定响应时）。这将提供最好的服务器性能，但是可能导
      致更多的客户端请求。
   -  ``no-auth`` ：服务器省略权威部份的记录，除非它们恰是被请求的记录。
      但是仍然会添加记录到附加部份。
   -  ``no-auth-recursive`` ：当请求中要求递归时（RD=1），与 ``no-auth``
      时相同，或者在没有要求递归时，与 ``no`` 时相同。

   在回复存根客户端时， ``no-auth`` 和 ``no-auth-recursive`` 很有用，因为
   存根客户端通常忽略权威部份。 ``no-auth-recursive`` 是设计用于混合模式
   服务器中，它会处理权威和递归请求。

   缺省是 ``no-auth-recursive`` 。

.. namedconf:statement:: glue-cache
   :tags: deprecated
   :short: 已废弃。

   当设置为 ``yes`` 时，在添加地址类型（A和AAAA）的粘连记录到授权到一个
   子区的DNS响应信息的附加部分时，会使用一个缓存来提高请求性能。

   粘连缓存使用的内存与中授权数目成比例。缺省设置是 ``yes`` ，它提高了性
   能，代价是增加了这个区的内存使用量。要避免这样，将其设置为 ``no`` 。

   .. note:: 这个选项已被废弃，不鼓励使用它。在将来的版本中，粘连缓存可
      能会永久 **开启** 。

.. namedconf:statement:: minimal-any
   :tags: query
   :short: 控制当生成一个针对ANY类型且通过UDP传输的请求的肯定响应时，服务器是否对一个查询名仅仅回复一个资源记录集。

   如果设置为 ``yes`` ，当生成一个针对ANY类型且通过UDP传输的请求的肯定
   响应时，服务器将会仅仅回复请求名的一个资源记录集，以及覆盖它的RRSIG
   记录，如果存在RRSIG记录的情况，而不是回复这个名字的所有已知的RRSIG。
   类似地，对类型RRSIG的请求将使用覆盖仅一个类型的RRSIG记录响应。这能
   够减少某些类型攻击流量的影响，而不伤害合法的客户端。（注意，然而，
   返回的资源记录集是在数据库中首先找到的；它不需要是最小可用的资源记
   录集。）此外， :any:`minimal-responses` 对这些请求是打开的，这样不
   必要的记录就不会被添加到权威或附加部份。缺省是 ``no`` 。

.. _notify_st:

.. namedconf:statement:: notify
   :tags: transfer
   :short: 控制当区发生变化时是否发送 ``NOTIFY`` 消息。

   如果设置为 ``yes`` （缺省情况），服务器所负责的区发生改变时发出DNS
   NOTIFY消息，参见 :ref:`using notify<notify>` 。消息发向区的NS记录
   （除SOA记录的MNAME字段所指示的主服务器之外）中所列出的服务器，以及
   在 :any:`also-notify` 选项中列出的任何服务器。

   如果设置为 ``primary-only`` （或者旧关键字 ``master-only`` ），通知
   仅发给主区。如果设置为 ``explicit`` ，通知仅发给使用
   :any:`also-notify` 显式列出的服务器。如果设置为 ``no`` ，不发出通知。

   :namedconf:ref:`notify` 选项也可在 :any:`zone` 语句中指定，在这种情
   况下，它将覆盖 ``options notify`` 语句。仅仅在它导致辅服务器崩溃时
   才需要关掉这个选项。

.. namedconf:statement:: notify-to-soa
   :tags: transfer
   :short: 控制是否针对SOA MNAME检查NS资源记录集中的名字服务器。

   如果是 ``yes`` ，就不针对SOA MNAME检查NS资源记录集中的名字服务器。通常
   一个NOTIFY消息不会发送给SOA MNAME（SOA源），因为假设它包含终极主服务器
   的名字。然而，有时候在隐藏主服务器的配置中一个辅服务器被作为SOA MNAME
   列出，在这种情况下，应该设置终极主服务器仍然发送NOTIFY消息给NS资源记
   录集中列出的所有名字服务器。

.. _recursion:

.. namedconf:statement:: recursion
   :tags: query
   :short: 定义是否允许递归和缓存。

   如果为 ``yes`` ，并且一个DNS请求也要求递归，服务器就试图完成所有要
   求的工作以回答请求。如果递归关闭并且服务器不知道答案，它将会返回一
   个参考响应。缺省为 ``yes`` 。注意，设置 ``recursion no`` 不会阻止客
   户端从服务器的缓存获取数据；它仅仅阻止作为客户端请求结果的新的数据
   被缓存。缓存仍然会作为服务器内部操作的结果而被产生，例如NOTIFY地址
   查找。

.. namedconf:statement:: request-nsid
   :tags: query
   :short: 控制在迭代解析时，是否所有发向权威服务器的请求都会带上一个空的EDNS(0) NSID（名字服务器标识符）。

   如果为 ``yes`` ，在迭代解析时，所有发向权威服务器的请求都会带上一个空
   的EDNS(0) NSID（名字服务器标识符）。如果权威服务器在其响应中返回了一个
   NSID选项，其内容将被记录到日志的 ``nsid`` 分类，级别为 ``info`` 。缺省
   是 ``no`` 。

.. namedconf:statement:: require-server-cookie
   :tags: query
   :short: 控制在发送一个完整响应给一个UDP请求之前，是否要求一个正确的服务器cookie。

   如果为 ``yes`` ，在发送一个完整响应给一个来自cookie感知的客户端的UDP请
   求之前，要求一个正确的服务器cookie。如果存在一个错误的或不存在服务器
   cookie，将发送BADCOOKIE。

   缺省为 ``no`` 。

   那些希望测试DNS COOKIE客户端是否正确处理BADCOOKIE的用户，或者那些收到许
   多带有DNS COOKIES的伪造DNS请求的人应该将这个设置为 ``yes`` 。将这个选项
   设置为 ``yes`` ，将在遇到反射攻击时有效降低放大效果，因为BADCOOKIE响应
   将比一个完整的响应更小，同时也会要求一个合法的客户端随后的第二个请求使
   用新的、有效的cookie。

.. namedconf:statement:: answer-cookie
   :tags: query
   :short: 控制在回复客户端请求时，是否发送COOKIE EDNS选项。

   当设置为缺省值 ``yes`` 时，在合适的时候，将在回复客户端请求时发送
   COOKIE EDNS选项。如果设置为 ``no`` ，应答中将不会发送COOKIE EDNS选项。
   这个仅能在全局选项中设置，不能用于视图中。

   ``answer-cookie no`` 的目的是作为一个临时测量手段，用于 :iscman:`named` 与还
   不支持DNS COOKIE的其它服务器共享一个IP地址时。监听在同一个地址上的服务
   器不一致不会导致运行问题，但是出于更加谨慎，还是提供了一个关闭COOKIE响
   应的选项以使所有的服务器有同样的行为表现。DNS COOKIE是一个重要的安全机
   制，不应该被关闭，除非绝对必要。

.. namedconf:statement:: send-cookie
   :tags: query
   :short: 控制是否伴随请求发送一个COOKIE EDNS。

   如果设置为 ``yes`` ，伴随请求会发送一个COOKIE EDNS。如果解析器先前与服
   务器有过通信，将会发送先前交易中返回的COOKIE。这是服务器用于决定解析器
   是否曾与之对话。一个发送正确COOKIE的解析器会被假设不是发送伪造源地址请
   求的旁路攻击者；因而，请求不太可能是一个反射/放大攻击的一部分，所以发
   送一个正确COOKIE选项的解析器就不会遭遇响应率限制（RRL）。不发送一个正
   确COOKIE选项的解析器可能被服务器通过 :any:`nocookie-udp-size` 选项限制成
   只能收到更小的响应。
   
   :iscman:`named` 服务器可能判定远程服务器不支持COOKIE，就不在请求中
   添加一个COOKIE EDNS选项。

   缺省为 ``yes`` 。

.. namedconf:statement:: stale-answer-enable
   :tags: server, query
   :short: 开启当一个区的名字服务器没有答复时返回“旧的”缓存答复。

   如果为 ``yes`` ，开启当一个区的名字服务器没有答复且
   :any:`stale-cache-enable` 选项也开启时时返回“旧的”缓存答复。缺省是
   不返回旧答复。

   旧答复也可以在运行时通过 :option:`rndc serve-stale on <rndc serve-stale>`
   或 :option:`rndc serve-stale off <rndc serve-stale>` 开启或关闭；这些覆盖已
   配置的设置。 :option:`rndc serve-stale reset <rndc serve-stale>` 将设置恢复
   成 :iscman:`named.conf` 中的设置。注意，如果旧答复被 :iscman:`rndc` 关闭，
   它们不能通过重新装载或重新配置 :iscman:`named` 来重新打开；它们只能通过
   :option:`rndc serve-stale on <rndc serve-stale>` 或者重新启动服务器来重新打
   开。

   关于旧答复的信息是记录在 ``serve-stale`` 日志类别下。

.. namedconf:statement:: stale-answer-client-timeout
   :tags: server, query
   :short: 定义了 :iscman:`named` 在尝试用缓存中的陈旧的RRset回答查询之前等待的时间(单位毫秒)。

   这个选项定义了 :iscman:`named` 在尝试用缓存中的陈旧的RRset回答查询
   之前等待的时间(单位毫秒)。如果找到一个过时的答案， :iscman:`named`
   将继续进行正在进行的提取操作，试图刷新缓存中的RRset，直到达到
   :any:`resolver-query-timeout` 的时间间隔。

   这个选项缺省是关闭的，等效于将其设置为 ``off`` 或 ``disabled`` 。如
   果 :any:`stale-answer-enable` 被关闭，这个选项也无效。

   这个选项的最大值是 :any:`resolver-query-timeout` 减1秒。最小值 ``0`` ，
   导致立即返回一个缓存的（陈旧的）RRset，如果后者可用，同时仍然尝试次
   刷新缓存中的数据。 :rfc:`8767` 推荐的值为 ``1800`` (毫秒)。

.. namedconf:statement:: stale-cache-enable
   :tags: server, query
   :short: 开启对“旧的”缓存答复的保留。

   如果为 ``yes`` ，开启对“旧的”缓存答复的保留。缺省是 ``no`` 。

.. namedconf:statement:: stale-refresh-time
   :tags: server, query
   :short: 设置如果名字服务器对一个给定的区没有答复，在下次尝试联系权威服务器之前，返回“过时的”缓存答复的时间窗口。

   如果名字服务器对一个给定的区没有答复，这个选项设置一个时间窗口，
   :iscman:`named` 将在窗口内立即使用“过时的”缓存答复来响应被请求的资
   源记录集，然后尝试联系权威服务器。为方便起见，可以使用TTL风格的时间
   单位后缀来指定这个值。也接受ISO 8601持续格式。

   缺省的 :any:`stale-refresh-time` 是30秒，如同 :rfc:`8767` 所建议，
   刷新尝试不应该比每30秒一次更频繁。一个为零的值关闭此特性，意谓着先
   进行普通的解析过程，如果其失败， :iscman:`named` 将返回 “过时的”缓
   存答复。 

.. namedconf:statement:: nocookie-udp-size
   :tags: query
   :short: 设置发送给不带合法服务器COOKIE的请求的最大UDP响应大小。

   这个设置发送给不带合法服务器COOKIE的请求的最大UDP响应大小。小于128
   的值将被静默地提高到128。缺省值是4096，但是 :any:`max-udp-size` 选
   项可以更多地限制响应大小，因为 :any:`max-udp-size` 的缺省值是1232。

.. namedconf:statement:: cookie-algorithm
   :tags: server
   :short: 设置用于生成服务器cookie的算法。

   这个设置用于生成服务器cookie的算法。选项为“aes”或“siphash24”。
   缺省是“siphash24”。“aes”选项仍然用于遗留目的。

.. namedconf:statement:: cookie-secret
   :tags: server
   :short: 指定一个用于在一个任播集群内生成和验证EDNS COOKIE选项的共享密钥。

   如果设置，这是一个用于在一个任播集群内生成和验证EDNS COOKIE选项的共享
   密钥。如果未设置，系统将在启动时生成一个随机密钥。共享密钥被编码成一个
   十六进制字符串，对于“siphash24”或“aes”，都是128位。

   如果指定了多个密钥，在 :iscman:`named.conf` 中列出的第一个将用于生成新的服务
   器cookie。其它的将仅用于验证返回的cookie。

.. namedconf:statement:: response-padding
   :tags: query
   :short: 为加密消息增加一个EDNS填充选项，以减少通过大小猜测内容的机会。

   EDNS填充选项的目的是当DNS请求通过一个加密通道发送时，通过减少包大小的
   变化来提升保密性。如果一个请求：

   1. 包含一个EDNS填充选项，
   2. 包含一个有效的服务器cookie或者使用TCP，
   3. 没有被TSIG或SIG(0)签名，以及
   4. 来自一个地址与指定ACL匹配的客户端，

   响应就使用一个EDNS填充选项被填充到 ``block-size`` 字节的倍数。如果这
   些条件不满足，响应就不会被填充。

   如果 ``block-size`` 是0或者ACL是 ``none;`` ，这个特性会被关闭，不进行
   填充；这是缺省行为。如果 ``block-size`` 大于512，将在日志中记录一条告
   警，并且这个值会被截断到512。块大小通常期望是2的幂（例如，128），但这
   不是必须的。

.. namedconf:statement:: trust-anchor-telemetry
   :tags: dnssec
   :short: 指示 :iscman:`named` 每天发送一次特定格式的请求给配置了信任锚的域。

   这使 :iscman:`named` 每天发送一次特定格式的请求给配置了信任锚的域，
   例如，通过 :any:`trust-anchors` 或者 ``dnssec-validation auto`` 。

   这些请求的请求名具有这样的格式 ``_ta-xxxx(-xxxx)(...).<domain>`` ，其中每
   个“xxxx”是一组四位十六进制数字，表示一个信任的DNSSEC密钥的密钥ID。每
   个域的密钥在编码前以从最小到最大的顺序排序。请求类型为NULL。

   通过监控这些请求，区操作员能够发现哪些解析器被更新以信任一个新密钥；
   这会帮助他们决定何时能够安全地删除一个旧密钥。

   缺省值是 ``yes`` 。


.. namedconf:statement:: provide-ixfr
   :tags: transfer
   :short: 控制一个主服务器对一个增量区传送请求（IXFR）进行响应，还是使用一个全量区（AXFR）传送作为响应。
 
   :any:`provide-ixfr` 子句决定本地服务器在作为主服务器时，当给定的远
   程服务器，一个辅服务器，请求它时是否使用一个增量区传送来响应。如果
   设置为 ``yes`` ，就在可能的时候提供增量区传送。如果设置为 ``no`` ，
   则到远程服务器的所有区传送都不是增量的。


.. namedconf:statement:: request-ixfr
   :tags: transfer
   :short: 控制一个辅服务器是请求一个增量区传送（IXFR），还是一个全量区（AXFR）传送。

   :any:`request-ixfr` 语句决定本地服务器在作为辅服务器时，是否向一个
   给定的远程服务器，一个主服务器，请求增量区传送。

   发给不支持IXFR的服务器的IXFR请求会自动回退为AXFR。所以，不需要手动
   列出哪些服务器支持IXFR和哪些不支持；全局缺省的 ``yes`` 应当总是能够
   工作。 :any:`provide-ixfr` 和 :any:`request-ixfr` 语句的目的是在主
   服务器和辅服务器都声称支持IXFR时，也能够关闭对它的使用：例如，如果
   其中的一方在使用IXFR时充满漏洞且崩溃或者丢失数据。

   它也可以设置在区块中；如果这样，它覆盖全局或视图中对应于这个区的设
   置。它也可以设置在 :namedconf:ref:`server` 块中。


.. namedconf:statement:: request-expire
   :tags: transfer, query
   :short: 指定在作为辅服务器时，本地服务器是否请求EDNS EXPIRE值。

   :any:`request-expire` 语句决定本地服务器在作为辅服务器时，是否请求
   EDNS EXPIRE值。EDNS EXPIRE值指示在区数据过期并且需要刷新前的剩余时
   间。这用于当一个服务器从另一个服务器传输一个区时；当从主服务器传输
   时，作为替代，过期计时器被设置为来自SOA记录中EXPIRE字段的值。缺省是
   ``yes`` 。

.. namedconf:statement:: match-mapped-addresses
   :tags: server
   :short: 允许映射到IPv4的IPv6地址与地址匹配表中对应IPv4地址的条目匹配。

   如果为 ``yes`` ，一个映射到IPv4的IPv6地址将会和与对应IPv4地址匹配的任何
   地址匹配表条目匹配。

   引入这个选项是工作在某些操作系统中内核特有的行为，即导致例如区传送
   中的IPv4的TCP的连接被使用地址映射的IPv6套接字所接受。这会导致为IPv4
   所设计的地址匹配表匹配失败。然而， :iscman:`named` 现在在内部解决这
   个问题。不鼓励使用这个选项。

.. namedconf:statement:: ixfr-from-differences
   :tags: transfer
   :short: 控制如何计算IXFR区传送。

   如果为 ``yes`` 并且服务器从其区文件装载一个新版本的主区或者通过区传送
   方式接收一个新版本的辅区文件时，它将会比较新版本与先前版本并计算一个
   差集。差别就写入到区的日志文件中，这样变化就可以用增量区传送的方式向
   下游的辅服务器传送。

   通过允许在非动态区中使用增量区传送，这个选项以增加主服务器的CPU和内存
   消耗的代价节约了带宽。在特殊情况下，如果一个区的新版本与前一个版本完
   全不一样，差别集将会有相当于旧版本和新版本之和的大小，并且服务器会临
   时申请内存以保持这个完整的差别集。

   :any:`ixfr-from-differences` 在view和options级别也接受 ``primary``
   和 ``secondary`` ，这将导致 :any:`ixfr-from-differences` 分别在所有
   的主区或辅区被打开。缺省时对所有区都是关闭的。

   注意：如果一个区打开了行内签名（译注：inline signing），用户为这个区
   所提供的 :any:`ixfr-from-differences` 设置将被忽略。

.. namedconf:statement:: multi-master
   :tags: transfer
   :short: 控制是否将序列号不匹配错误记录到日志。

   当一个区有多个主服务器并且其地址指向不同的机器时，应该设置此选项。
   如果为 ``yes`` ， :iscman:`named` 在主服务器的序列号小于当前
   :iscman:`named` 的序列号时将不会记录。缺省为 ``no`` 。

.. namedconf:statement:: auto-dnssec
   :tags: dnssec
   :short: 允许不同级别的自动DNSSEC密钥管理。

   为动态DNS配置的区可以使用这个选项来允许不同级别的自动DNSSEC密钥管理。
   有三个可能的设置：

   ``auto-dnssec allow;`` 允许无论何时用户发送
   :option:`rndc sign zonename <rndc sign>` 命令时更新密钥和重签整个区。

   ``auto-dnssec maintain;`` 包含上述功能，但也根据密钥时间元数据，按
   时自动调整区的DNSSEC密钥。（参见 :ref:`man_dnssec-keygen` 和
   :ref:`man_dnssec-settime` ）。命令
   :option:`rndc sign zonename <rndc sign>` 使得 :iscman:`named` 从密
   钥仓库加载密钥并使用所有活跃密钥对区签名。
   :option:`rndc loadkeys zonename <rndc loadkeys>` 使得
   :iscman:`named` 从密钥仓库加载密钥并调度未来发生的密钥维护事件，但
   它不会立即对整个区签名。注意：一旦密钥首次从一个区加载，就会定期搜
   索仓库以查找变化，而不考虑是否使用了 :option:`rndc loadkeys` 。重新
   检查的间隔由 :any:`dnssec-loadkeys-interval` 定义。
   
   ``auto-dnssec off`` 不允许DNSSEC密钥管理。这是缺省设置。

   DNSSEC记录被写到在 :any:`file` 中所设置的区文件中，除非开启了
   :any:`inline-signing` 。

.. _dnssec-validation-option:

.. namedconf:statement:: dnssec-validation
   :tags: dnssec
   :short: 在 :iscman:`named` 中打开 DNSSEC 验证。

   这个选项在 :iscman:`named` 中打开 DNSSEC 验证。

   如果设置为 ``auto`` ，DNSSEC验证被开启，并使用一个缺省的DNS根区信任
   锚。这个信任锚作为BIND的一部份而提供，并使用 :ref:`rfc5011.support`
   密钥管理来保持更新。

   如果设置为 ``yes`` ，DNSSEC验证被开启，但是必须使用一个
   :any:`trust-anchors` 语句（或者 :any:`managed-keys` 或
   :any:`trusted-keys` 语句，这两个都已被废弃）手工配置一个信任锚；如
   果没有配置信任锚，将不会进行验证。

   如果设置为 ``no`` ，DNSSEC验证将被关闭。

   缺省为auto，除非BIND使用 ``configure --disable-auto-validation`` 构
   建，在此情况下缺省为 ``yes`` 。

   缺省的根信任锚被存储在文件 ``bind.keys`` 中。如果
   :any:`dnssec-validation` 被设置为 ``auto`` ， :iscman:`named` 将在
   启动时装载这个密钥。这个文件的一份拷贝随着BIND 9被安装，是发布日期
   时的版本。如果根密钥过期，新的 ``bind.keys`` 拷贝可以从
   https://www.isc.org/bind-keys 下载。

   （为防止因未找到 ``bind.keys`` 而带来的问题，当前信任锚也被编译进
   :iscman:`named` 。不推荐依赖这个措施，无论如何，因为这在根密钥过期
   时，要求带一个新密钥重新编译 :iscman:`named` 。）

   .. note:: :iscman:`named` **只** 从 ``bind.keys`` 中装载根密钥。这
         个文件不能用于存放其它区的密钥。如果未使用
         ``dnssec-validation auto`` ， ``bind.keys`` 中的根密钥将被忽
         略。

         无论何时解析器发出请求到EDNS兼容的服务器，它总是设置DO位表示
         它可以支持DNSSEC响应，即使 :any:`dnssec-validation` 被关闭。

.. namedconf:statement:: validate-except
   :tags: dnssec
   :short: 指定一个域名列表，在这些域名或之下不应执行DNSSEC验证。

   这指定一个域名列表，在这些域名或之下 **不应** 执行DNSSEC验证，无论
   这些名字或之上是否提供了信任锚。这个可以被用于，例如，当配置一个顶
   级域仅仅用于内部，这样缺乏在根区中对这个域的安全授权不会导致验证失
   败。（这类似设置一个否定信任锚，除了它是永久配置，而否定信任锚会在
   一段时间之后过期并被删除之外。）

.. namedconf:statement:: dnssec-accept-expired
   :tags: dnssec
   :short: 指定BIND 9在验证时接受过期的签名。

   这在校验DNSSEC签名时接受过期的签名。缺省为 ``no`` 。把这个选项设置为
   ``yes`` 有可能使 :iscman:`named` 遭受重发攻击。

.. namedconf:statement:: querylog
   :tags: logging, server
   :short: 指定当 :iscman:`named` 首次启动时是否启动请求日志。

   请求日志提供一个所有进入的请求和所有请求错误的完整日志。这提供了对服
   务器活动更多了解，但是对高负载服务器会有更显著的性能消耗。

   :any:`querylog` 选项指定是否在 :iscman:`named` 启动的同时启动请求日
   志。如果未指定 :any:`querylog` ，则是否记录请求日志由logging类别中
   ``queries`` 中是否出现来决定。请求日志也可以在运行时使用命令
   ``rndc querylog on`` 来激活，或者使用
   :option:`rndc querylog off <rndc querylog>` 来关闭。

.. namedconf:statement:: check-names
   :tags: query, server
   :short: 限制主服务器文件和/或从网络中接收到的DNS响应中的域名的字符集和语法。

   这个选项是用于限制主服务器文件和/或从网络中接收到的DNS响应中的域名
   的字符集和语法。根据使用场合的缺省值是不一样的。对于 :any:`type primary`
   区，缺省为 ``fail`` 。对于 :any:`type secondary` 区，缺省是 ``warn`` 。
   对于从网络接收的回答（ ``response`` ），缺省是 ``ignore`` 。

   合法主机名和邮件域名的规则是由 :rfc:`952` 和 :rfc:`821` 派生出来的，
   并由 :rfc:`1123` 所修改。

   :any:`check-names` 应用到A，AAAA和MX记录的属主名字段。它也应用到
   NS，SOA，MX和SRV记录RDATA字段的域名中。它更应用到PTR记录的RDATA字段
   中，在这里属主名表示其是一个主机的反向查找（属主名以IN-ADDR.ARPA，
   IP6.ARPA或者IP6.INT结尾）。

.. namedconf:statement:: check-dup-records
   :tags: dnssec, query
   :short: 检查主区中，在DNSSEC中被当作不同的，但是在普通DNS中语义上相等的记录。

   这检查主区中，在DNSSEC中被当作不同的，但是在普通DNS中语义上相等的记录。
   缺省为 ``warn`` ，其它可能值为 ``fail`` 和 ``ignore`` 。

.. namedconf:statement:: check-mx
   :tags: zone
   :short: 检查MX记录是否是指向一个IP地址。

   这检查MX记录是否是指向一个IP地址。缺省值为 ``warn`` 。其它可能值为
   ``fail`` 和 ``ignore`` 。

.. namedconf:statement:: check-wildcard
   :tags: zone
   :short: 检查非终结的通配符。非终结的通配符。

   这个选项用于检查非终结的通配符。使用非终结的通配符几乎总是由于缺乏对
   通配符匹配算法（ :rfc:`1034` ）的理解。这个选项影响主区。缺省（ ``yes``
   ）是检查非终结的通配符并发出一个警告。

.. namedconf:statement:: check-integrity
   :tags: zone
   :short: 对主区执行加载后的区完整性检查。

   这对主区执行加载后的区完整性检查。这将检查MX和SRV记录指向地址（A或
   AAAA）记录和因授权区而存在的粘连地址记录。对MX和SRV记录，仅对本区的
   主机名进行检查（对区外的主机名，使用 :iscman:`named-checkzone` ）。
   对NS记录，仅对区的顶端下的名字进行检查（对区外名字和粘连一致性检查
   使用 :iscman:`named-checkzone` ）。缺省是 ``yes`` 。

   使用SPF记录用于发送者策略框架的发布已被弃用，如同从使用TXT记录到SPF
   记录的迁移被放弃一样。如果已存在一个SPF记录，打开这个选项会检查一个
   TXT类型的发送者策略框架记录（以"v=spf1"开头）是否已经存在。如果TXT
   记录不存在，将发出警告，也可通过 :any:`check-spf` 拟制。

.. namedconf:statement:: check-mx-cname
   :tags: zone
   :short: 为指向CNAME的MX记录设置响应。

   如果设置了 :any:`check-integrity` ，遇到指向CNAME记录的MX记录就会失
   败，警告或忽略。缺省是 ``warn`` 。

.. namedconf:statement:: check-srv-cname
   :tags: zone
   :short: 为指向CNAME的SRV记录设置响应。

   如果设置了 :any:`check-integrity` ，遇到指向CNAME记录的SRV记录就会
   失败，警告或忽略。缺省是 ``warn`` 。

.. namedconf:statement:: check-sibling
   :tags: zone
   :short: 指定是否在执行完整性检查的同时也检查兄弟粘连记录。

   在执行完整性检查的同时，也检查兄弟粘连记录的存在。缺省是 ``yes`` 。

.. namedconf:statement:: check-spf
   :tags: zone
   :short: 指定如果存在一条SPF记录，是否检查一条TXT发送者策略框架记录。

   如果设置了 :any:`check-integrity` 并且存在一条SPF记录，就检查是否存
   在一条TXT类型的发送者策略框架记录（以"v=spf1"开头）。缺省是
   ``warn`` 。

.. namedconf:statement:: zero-no-soa-ttl
   :tags: zone, query, server
   :short: 指定当为SOA查询返回权威的否定响应时，是否将SOA记录的生存期（TTL）设置为零。

   如果为 ``yes`` ，当为SOA查询返回权威的否定响应时，将所返回的权威部份
   中的SOA记录的TTL值设置为零。缺省是 ``yes`` 。

.. namedconf:statement:: zero-no-soa-ttl-cache
   :tags: zone, query, server
   :short: 当为一个SOA查询缓存一个否定响应时，将生存期（TTL）设置为零。

   如果为 ``yes`` ，当为一个SOA查询缓存一个否定响应时，将其中TTL值设置为零。
   缺省是 ``no``。

.. namedconf:statement:: update-check-ksk
   :tags: zone, dnssec
   :short: 指定在为一个安全区生成RRSIG时，是否检查KSK位以决定如何使用一个密钥。

   在设置为缺省值 ``yes`` 时，检查每个密钥的KSK位以决定为一个安全区生成
   RRSIG时如何使用密钥。

   正常情况下，区签名密钥（即未置KSK位的密钥）用于对整个区签名，而密钥签名
   密钥（设置了KSK位的密钥）仅用于对区顶点的DNSKEY资源记录集签名。然而，如
   果这个选项被设置为 ``no`` ，KSK位被忽略；KSK被当成ZSK，用于对整个区签名。
   这与 :option:`dnssec-signzone -z` 命令行选项相似。

   当这个选项被设置为 ``yes`` 时，在DNSKEY资源记录集中的每个算法至少有两个
   激活的密钥：每个算法至少有一个KSK和一个ZSK。如果有任何一个算法的要求未
   被满足，这个选项对于这种算法将被忽略。

.. namedconf:statement:: dnssec-dnskey-kskonly
   :tags: dnssec
   :short: 指定只有密钥签名密钥会被用于对区顶点的DNSKEY，CDNSKEY和CDS资源记录集签名。

   当这个选项和 :any:`update-check-ksk` 都被设置为 ``yes`` 时，只有密钥签名密
   钥（即设置了KSK位的密钥）会被用于对区顶点的DNSKEY，CDNSKEY和CDS资源记录
   集签名。区签名密钥（未置KSK位的密钥）会被用于对区剩下部份签名，不包括
   DNSKEY资源记录集。这与 :option:`dnssec-signzone -x` 命令行选项相似。

   缺省为 ``yes`` 。如果 :any:`update-check-ksk` 被设置为 ``no`` ，这个选项将
   被忽略。

.. namedconf:statement:: try-tcp-refresh
   :tags: transfer
   :short: 指定BIND 9应该在UDP查询失败时尝试使用TCP刷新一个区。

   如果为 ``yes`` ，如果UDP请求失败，试图使用TCP刷新区。缺省是 ``yes`` 。

.. namedconf:statement:: dnssec-secure-to-insecure
   :tags: dnssec
   :short: 允许一个动态区通过删除所有DNSKEY记录从安全状态迁移到不安全状态。

   这允许一个动态区通过删除所有DNSKEY记录从安全状态迁移到不安全状态（
   即，从签名到不签名）。缺省为 ``no`` 。如果设置为 ``yes`` ，并且如果
   区顶点处的DNSKEY资源记录集被删除了，则所有的RRSIG和NSEC记录也会从区
   中删除。

   如果区使用了NSEC3，也需要从区顶点处删除NSEC3PARAM资源记录集；这将导
   致所有相关的NSEC3记录被删除。（预计这一要求将在未来的版本中被去掉。）

   注意如果一个区配置了 ``auto-dnssec maintain`` 并且在密钥仓库中仍然
   能够访问私钥，则在 :iscman:`named` 下次启动时，区将会再次自动签名。

.. namedconf:statement:: synth-from-dnssec
   :tags: dnssec
   :short: 开启对 :rfc:`8198` 的支持，积极使用DNSSEC验证过的缓存。

   这个选项开启对 :rfc:`8198` 的支持，积极使用DNSSEC验证过的缓存。它允
   许解析器在解析DNSSEC签名域的查询时，通过从缓存的NSEC和其它已被DNSSEC
   证明是正确的资源记录集合成答案，从而减少查询次数。缺省是 ``yes`` 。

   .. note:: 要使这个选项生效，必须开启DNSSEC验证。这个首次实现仅仅覆盖
      了从NSEC记录合成答复。从NSEC3合成是将来的计划。这个也由
      :any:`synth-from-dnssec` 控制。
			
转发
^^^^

转发设施可以被用于在一些服务器上建立一个大的缓存，并减少到外部名字服务器的流量。
它也允许这样的请求，服务器不能直接访问互联网，但也希望通过某种方式查找外部的名
字。转发只发生在那些服务器不是其权威服务器并且其缓存没有答案的请求上。

.. _forward:

.. namedconf:statement:: forward
   :tags: query
   :short: 如果转发失败，允许或不允许回退到递归；它总是与 :any:`forwarders` 配合使用。

   这个选项仅在转发服务器列表非空的情况下有意义。一个为 ``first`` 的值是其缺省
   值，将使服务器首先请求转发服务器；并且如果它不回答问题时，服务器再自行查找
   答案。如果指定为 ``only`` ，服务器只请求转发服务器。

.. _forwarders:

.. namedconf:statement:: forwarders
   :tags: query
   :short: 定义一个或多个，请求将会被转发到的主机。

   这个指定一个请求会被转发到的IP地址列表。缺省是空列表（不转发）。列表中的每个
   地址可以附带一个可选的端口号和/或DSCP值，还可以为整个列表设置一个缺省的端口号
   和DSCP值。

转发也可以按域来配置，允许全局转发选项被多种方式覆盖。可以设置某个特定
的域使用不同的转发服务器，或者使用不同的 ``forward only/first`` 行为，
或者全都不转发，参见 :ref:`zone_statement_grammar` 。

.. _dual_stack:

双栈服务器
^^^^^^^^^^

双栈服务器是服务器用于解决由于主机缺乏对IPv4或IPv6的支持而导致的可达性
问题的最后手段。

.. namedconf:statement:: dual-stack-servers
   :tags: server
   :short: 指定机器的主机名或者地址，它可以通过IPv4和IPv6传输协议都能被访问到。

   这指定机器的主机名或者地址，它可以通过IPv4和IPv6传输协议都能被访问
   到。如果使用主机名，服务器必须在其所使用的传输协议上能够被解析到。
   如果机器是双栈的， :any:`dual-stack-servers` 参数就无效，除非对某个
   传输协议的访问被命令行所关闭（如 :option:`named -4` ）。

.. _access_control:

访问控制
^^^^^^^^

对服务器的访问可以基于发出请求的系统的IP地址进行限制。参见
:ref:`address_match_lists` 以获得如何指定IP地址列表的详细内容。

.. namedconf:statement:: allow-notify
   :tags: transfer
   :short: 定义一个 :any:`address_match_list` ，用于为区发送 ``NOTIFY`` 消息，这为该区在 :any:`primaries` 中所定义地址增加了额外部份。

   这个 ACL 指定哪些主机可以发送NOTIFY消息通知本服务器关于本服务器作为
   辅服务器的区的变化。这个仅适用于辅区（即 :any:`type secondary` 或
   ``slave`` ）。

   如果这个选项设置在 :any:`view` 或 :namedconf:ref:`options` 中，它全
   局应用于所有的辅区。如果设置在 :any:`zone` 语句，会覆盖全局值。

   如果未指定，缺省是仅处理来自区中配置在 :any:`primaries` 中的服务器
   的NOTIFY消息。 :any:`allow-notify` 可以用于扩展所允许的主机的名单，
   但不能缩小它。

.. namedconf:statement:: allow-query
   :tags: query
   :short: 指定哪些主机（一个IP地址列表）被允许发送查询到本解析器。

   这指定允许哪些主机可以进行普通的DNS查询。 :any:`allow-query` 也可以
   在 :any:`zone` 语句中指定，这时它会覆盖 ``options allow-query`` 语
   句。如果未指定，缺省是允许所有主机请求。

   .. note:: :any:`allow-query-cache` 用于指定对缓存的访问。

.. namedconf:statement:: allow-query-on
   :tags: query
   :short: 指定哪些本地地址（一个iP地址列表）被允许发送查询到本解析器。用于多宿主配置。

   这使得这样的情况成为可能，例如，允许面向内部的接口接受请求而不允许
   面向外部的接口接受请求，而不需要知道内部的网络地址。

   注意 :any:`allow-query-on` 仅仅针对被 :any:`allow-query` 所允许的请
   求才被检查。请求必须被两个ACL都允许，否则将被拒绝。

   :any:`allow-query-on` 也可以在 :any:`zone` 语句中指定，这时，它会覆
   盖 ``options allow-query-on`` 语句。

   如果未指定，缺省是允许在所有地址上的请求。

   .. note:: :any:`allow-query-cache` 用于指定对缓存的访问。

.. namedconf:statement:: allow-query-cache
   :tags: query
   :short: 指定哪些主机（一个IP地址列表）可以访问本服务器的缓存，因而有效地控制递归。

   定义一个IP地址的 :term:`address_match_list` ，其中的主机被允许发送
   访问本地缓存的查询。如果不访问本地缓存，递归查询实际上是无用的，因
   此，本语句（或者其缺省值）实际上控制了递归行为。这个语句的缺省设置
   依赖：

   1. 如果配置了 :namedconf:ref:`recursion no; <recursion>` ，缺省为
      ``allow-query-cache {none;};`` 。不允许访问本地缓存。

   2. 如果配置了 :namedconf:ref:`recursion yes; <recursion>` （缺省值），
      然后如果配置了 :any:`allow-recursion` ，缺省为
      :any:`allow-recursion` 的值。与 :any:`allow-recursion` 中
      :term:`address_match_list` 相匹配的主机可以访问本地缓存。

   3. 如果配置了 :namedconf:ref:`recursion yes; <recursion>` （缺省值），
      然后如果 **没有** 配置 :any:`allow-recursion` ，缺省为
      ``allow-query-cache {localnets; localhost;};`` 。仅
      :term:`address_match_list` 中定义的本地网络上的主机和本地主机IP
      地址才可以访问本地缓存。

.. namedconf:statement:: allow-query-cache-on
   :tags: query
   :short: 指定哪些主机（一个IP地址列表）可以访问本服务器的缓存。用于带有多个接口的服务器。

   这指定哪些本机地址可以发送来自缓存的响应，如果未设置
   :any:`allow-query-cache-on` ，就使用 :any:`allow-recursion-on` ，
   如果设置了后者。否则，缺省允许缓存响应从任何地址发送。注意：在一个
   缓存响应被发送之前， :any:`allow-query-cache` 和
   :any:`allow-query-cache-on` 都必须被满足；一个被其中之一阻止的客户
   端也会被另一个阻止。

.. namedconf:statement:: allow-recursion
   :tags: query
   :short: 定义一个被允许执行递归查询的客户端的 :any:`address_match_list` 。

   这指定允许哪些主机可以通过本服务器进行递归查询。BIND以顺序：
   :any:`allow-query-cache` 和 :any:`allow-query` 检查这些参数是否设置。
   如果这些参数都没有设置，就使用缺省的（localnets;localhost;）。

.. namedconf:statement:: allow-recursion-on
   :tags: query, server
   :short: 指定哪些本机地址可以接受递归请求。

   这指定哪些本机地址可以接受递归请求。如果 :any:`allow-recursion-on`
   未设置，就使用 :any:`allow-query-cache-on` ，如果后者被设置了；否则，
   缺省是允许在所有地址上的递归请求：任何允许发送递归请求的客户端可以
   将其发送到 :iscman:`named` 监听的任何地址。注意：在递归被允许之前，
   :any:`allow-recursion` 和 :any:`allow-recursion-on` 都必须被满足；
   被其中之一阻止的客户端也会被另一个阻止。

.. namedconf:statement:: allow-update
   :tags: transfer
   :short: 定义一个允许为主区提交动态更新的主机的 :any:`address_match_list` 。

   一个简单的访问控制表。当为了一个主区而设置在 :any:`zone` 语句中时，
   这指定允许哪些主机可以对这个区提交动态DNS更新。缺省是拒绝所有主机的
   动态更新。

   注意，允许基于请求者IP地址的动态更新是不安全的；更详细的内容
   参见 :ref:`dynamic_update_security` 。

   通常，这个选项只应该设置在 :any:`zone` 级。由于一个缺省值可以设置在
   :namedconf:ref:`options` 或 :any:`view` 级并被区所继承，这可能导致
   某些区无意间允许更新。

   更新写到在 :any:`file` 中设置的区文件中。
 
.. namedconf:statement:: allow-update-forwarding
   :tags: transfer
   :short: 定义一个允许向一个辅区提交动态更新的主机的 :any:`address_match_list` ，辅区随后将更新转发给主区。

   当为了一个辅区而设置在 :any:`zone` 语句中时，这指定允许哪些主机可以提交
   动态DNS更新，并将其转发给主区。缺省是 ``{ none; }`` ，表示不执行更新
   转发操作。

   要允许更新转发，在 :any:`zone` 语句中指定
   ``allow-update-forwarding { any; };`` 。
   指定 ``{ none; }`` 或 ``{ any; }`` 之外的值通常是事与愿违的；对更新的
   访问控制应该是主服务器的责任，而不是辅服务器的责任。

   注意打开一个辅服务器上的更新转发特性可能将主服务器暴露给攻击者，如
   果它们依赖不安全的基于IP地址的访问控制；更详细的内容参见
   :ref:`dynamic_update_security` 。

   通常情况这个选项只应该设置在 :any:`zone` 级。由于一个缺省值可以设置
   在 :namedconf:ref:`options` 或 :any:`view` 级并被区所继承，这可能导
   致某些区无意间允许转发更新。

.. _allow-transfer-access:

.. _allow-transfer:

.. namedconf:statement:: allow-transfer
   :tags: transfer
   :short: 定义一个允许从本服务器传输区信息的主机的 :any:`address_match_list` 。

   这指定哪些主机允许从服务器接收区传送。 :any:`allow-transfer` 也可以
   在 :any:`zone` 语句中指定，在这种情况下它会覆盖设置在
   :namedconf:ref:`options` 或 :any:`view` 中的 :any:`allow-transfer`
   语句。如果未指定，缺省是允许所有主机进行传送。

   也可以指定传输层限制。特别地，可以使用选项 :term:`port` 和
   ``transport`` 将区传送限制到一个特定的端口和/或DNS传输协议。两个选
   项可同时使用；如果都使用，两个限制都必须满足才能允许区传送。当前区
   传送只能经过TCP和TLS传输。

   例如： ``allow-transfer port 853 transport tls { any; };`` 允许对外
   区传送给任何主机，使用TLS传输，在端口853上。

.. warning::

   请注意，入向的TLS连接是 **在TLS层未认证的** 。请参考 :ref:`tsig`
   来认证请求者，或实现 :ref:`Mutual TLS <mutual-tls>` 认证。

.. namedconf:statement:: blackhole
   :tags: query
   :short: 定义一个要忽略的 :any:`address_match_list` 。服务器不会响应来自这些地址的查询也不会发送查询到这些地址。

   这指定一个地址列表，服务器将不会接受来自其中的请求或者用其解析一个请
   求。从这些地址来的请求将不会有任何响应。缺省是 ``none`` 。

.. namedconf:statement:: keep-response-order
   :tags: server
   :short: 定义一个不接受在单一TCP流中重新排序答复的地址的 :any:`address_match_list` 。
    
   这指定一个地址列表，服务器向这些地址的TCP请求发送响应时将会以接收它
   们时同样的顺序。这关闭了对TCP请求的并行处理。缺省是 ``none`` 。

.. namedconf:statement:: no-case-compress
   :tags: server
   :short: 指定一个要求响应使用大小写无关的压缩的地址列表。

   这指定一个地址列表，其中地址要求响应使用大小写无关的压缩。当
   :iscman:`named` 需要与那些不遵守 :rfc:`1034` 所要求的在匹配域名时使
   用大小写无关的名字压缩的客户端的通信时，可以使用这个ACL。

   如果未定义，ACL缺省为 ``none`` ：大小写无关的压缩将用于所有客户端。
   如果定义了ACL并且与一个客户端匹配，在发送给那个客户端的DNS响应中压缩
   域名时将忽略大小写。

   这将导致稍稍小一点的响应：如果一个响应包含名字"example.com"和
   "example.COM"，大小写无关的压缩将把第二个当成一个副本。它也确保请求
   名的大小写与返回记录的属主名精确匹配，而不是匹配其文件中记录的大小
   写。这允许响应精确匹配请求，这是一些不正确使用大小写相关压缩的客户端
   所要求的。

   大小写无关压缩 **总是** 用在AXFR和IXFR响应上，而不管客户端是否匹配这
   个ACL。

   在有些环境中 :iscman:`named` 不保持记录属主名的大小写：如果一个区文件中定
   义同一个名字的不同类型记录，但名字的大写字母使用不同（例如，
   "www.example.com/A"和"WWW.EXAMPLE.COM/AAAA"），那么所有对那个名字的
   响应将使用在区文件中用到的那个名字的 **第一个** 版本。这个限制可能在
   一个将来的版本中被处理。然而，在资源记录的rdata部份所指定的域名（例
   如，NS，MX，CNAME等等）将总是保持其大小写，除非客户端匹配这个ACL。

.. namedconf:statement:: resolver-query-timeout
   :tags: query
   :short: 指定以毫秒计的时间长度，是一个解析器在尝试解析一个递归请求时能使用的时间。

   解析器在尝试解析一个递归请求时，在失败之前将花费的以毫秒计的时间。缺
   省值和最小值是 ``10000`` ，最大值是 ``30000`` 。将其设置为 ``0`` 将会
   导致使用缺省值。

   这个值最初以秒指定。小于或等于300的值将被当成秒，并在应用到上述限制之
   前被转换为毫秒。

.. _interfaces:

接口
^^^^

服务器回答请求的接口，端口和协议可以由 :any:`listen-on` 和
:any:`listen-on-v6` 选项指定。

.. namedconf:statement:: listen-on
   :tags: server
   :short: 指定服务器监听DNS查询的IPv4地址。

.. namedconf:statement:: listen-on-v6
   :tags: server
   :short: 指定服务器监听DNS查询的IPv6地址。

   :any:`listen-on` 和 :any:`listen-on-v6` 语句都可以接受可选项的端口
   号，TLS配置标识符和/或HTTP配置标识符，以及一个
   :term:`address_match_list` 。

   :any:`listen-on` 中的 :term:`address_match_list` 指定服务器要监听的
   IPv4地址。（IPv6地址被忽略，并在日志中记录一条警告。）服务器将监听
   在地址匹配表所允许的所有接口上。如果未指定 :any:`listen-on` ，缺省
   是在所有的IPv4接口上监听标准DNS请求使用的53端口。

   :any:`listen-on-v6` 使用一个IPv6地址的 :term:`address_match_list` 。
   服务器将监听在地址匹配表所允许的所有接口上。如果未指定
   :any:`listen-on-v6` ，缺省是在所有的IPv6接口上监听标准DNS请求使用的
   53端口。

   如果指定了一个TLS配置， :iscman:`named` 将监听DNS-over-TLS（DoT）连
   接，并使用在引用的 :any:`tls` 语句中所指定的密钥和证书。如果使用了
   名字 ``ephemeral`` ，将使用一个为当前运行的 :iscman:`named` 进程所
   创建的短暂的密钥和证书。

   如果指定了一个HTTP配置， :iscman:`named` 将监听DNS-over-HTTPS（DoH）
   连接，并使用在引用的 :any:`http` 语句中所指定的HTTP端点。如果使用了
   名字 ``default`` ， :iscman:`named` 将在缺省的端点，
   ``/dns-query`` ，上监听连接。

   使用一个 :any:`http` 规范也要求指定 :any:`tls` 。如果想要一个未加密
   的连接（例如，在一个反向代理之后的负载分担服务器），也可使用
   ``tls none`` 。

   如果未指定端口号，对标准DNS缺省是53，对TLS上的DNS是853，对HTTPS上的
   DNS是443，而对HTTP（未加密）上的DNS是80。这些缺省值可以分别使用
   :namedconf:ref:`port` ， :any:`tls-port` ， :any:`https-port` 和
   :any:`http-port` 选项覆盖。

   允许使用多个 ``listen-on`` 语句。例如：

   ::

      listen-on { 5.6.7.8; };
      listen-on port 1234 { !1.2.3.4; 1.2/16; };
      listen-on port 8853 tls ephemeral { 4.3.2.1; };
      listen-on port 8453 tls ephemeral http myserver { 8.7.6.5; };

   头两行指示名字服务器在地址5.6.7.8的端口53和在网络1.2上且非1.2.3.4的
   地址的端口1234上监听标准的DNS请求。第三行指示服务器在地址4.3.2.1的
   端口8853上监听DNS-over-TLS连接，并使用短暂的密钥和证书。第四行在地
   址8.7.6.5的端口8453上开启DNS-over-HTTPS连接，并使用短暂的密钥和证书，
   以及在一条 :any:`http` 语句中使用名字 ``myserver`` 所配置的HTTP端点。

   可以使用多个 :any:`listen-on-v6` 选项。例如：

   ::

      listen-on-v6 { any; };
      listen-on-v6 port 1234 { !2001:db8::/32; any; };
      listen-on port 8853 tls example-tls { 2001:db8::100; };
      listen-on port 8453 tls example-tls http default { 2001:db8::100; };
      listen-on port 8000 tls none http myserver { 2001:db8::100; };

   头两行指示名字服务器在任何IPv6地址的端口53和除2001:db8::/32以外的地
   址的端口1234上监听标准的DNS请求。第三行指示服务器在地址
   2001:db8::100的端口8853上监听DNS-over-TLS连接，并使用在一条
   :any:`tls` 语句中名字 ``example-tls`` 所指定的一个TLS密钥和证书。第
   四行指示服务器在缺省的HTTP端点监听DNS-over-HTTPS连接，再次使用了
   ``example-tls`` 。第五行，其中 :any:`tls` 参数被设置为 ``none`` ，
   指示服务器以 ``myserver`` 中指定的端点监听 **未加密** 的HTTP上的DNS
   请求。

   要指示服务器不监听在任何IPv6地址，使用：

   ::

      listen-on-v6 { none; };

.. _query_address:

请求地址
^^^^^^^^

.. namedconf:statement:: query-source
   :tags: query
   :short: 控制发出递归查询的IPv4地址和端口。

.. namedconf:statement:: query-source-v6
   :tags: query
   :short: 控制发出递归查询的IPv6地址和端口。

   如果服务器不知道一个问题答案，它就会请求其它的名字服务器。
   :any:`query-source` 指定这样的请求所使用的地址和端口。对通过IPv6发
   出的请求，有一个单独的 :any:`query-source-v6` 选项。如果
   ``address`` 为 ``*`` （星号）或被省略，就使用通配符IP地址
   （ ``INADDR_ANY`` ）。

   :any:`query-source` 和 :any:`query-source-v6` 选项的缺省值是：

   ::

      query-source address * port *;
      query-source-v6 address * port *;

   .. note:: 在 :any:`query-source` 选项中指定的地址用于UDP和TCP查询这
      两者中，但是端口仅适用于UDP查询。TCP查询总是使用一个随机的非特权
      端口。

.. namedconf:statement:: use-v4-udp-ports
   :tags: query
   :short: 指定作为UDP/IPv4消息的有效源端口的列表。

.. namedconf:statement:: use-v6-udp-ports
   :tags: query
   :short: 指定作为UDP/IPv6消息的有效源端口的列表。

   这些语句指定一个IPv4和IPv6的UDP端口的列表，用作UDP消息的源端口。

   如果 :term:`port` 为 ``*`` 或被省略，就从一个预先配置的范围中随机选
   择一个端口号，并用在每个请求中。端口范围是在
   :any:`use-v4-udp-ports` （对IPv4）和 :any:`use-v6-udp-ports` （对
   IPv6）选项中指定。

   如果未指定 :any:`use-v4-udp-ports` 或者 :any:`use-v6-udp-ports` ，
   :iscman:`named` 检查操作系统是否提供一个程序接口来提取系统缺省的临
   时端口的范围。如果有这样的一个接口， :iscman:`named` 将使用相应的系
   统缺省范围；否则，它将使用自己的缺省值：

   ::

      use-v4-udp-ports { range 1024 65535; };
      use-v6-udp-ports { range 1024 65535; };

.. namedconf:statement:: avoid-v4-udp-ports
   :tags: query
   :short: 指定被排除作为UDP/IPv4消息源端口的端口范围。

.. namedconf:statement:: avoid-v6-udp-ports
   :tags: query
   :short: 指定被排除作为UDP/IPv6消息源端口的端口范围。

   这些范围分别从哪些在 :any:`avoid-v4-udp-ports` 和
   :any:`avoid-v6-udp-ports` 选项中所指定的端口排除掉。

   ``avoid-v4-udp-ports`` 和 ``avoid-v6-udp-ports`` 选项缺省为：

   ::

      avoid-v4-udp-ports {};
      avoid-v6-udp-ports {};

   例如，下面的配置：

   ::

      use-v6-udp-ports { range 32768 65535; };
      avoid-v6-udp-ports { 40000; range 50000 60000; };

   从 :iscman:`named` 所发出的IPv6消息的UDP端口为下列范围之一：32768到
   39999,40001到49999，或者60001到65535。

   :any:`avoid-v4-udp-ports` 和 :any:`avoid-v6-udp-ports` 可以用于阻止
   :iscman:`named` 选择一个被防火墙封禁或者已被其它应用所使用的端口作
   为其随机源端口；如果一个查询使用一个被防火墙封禁的源端口出去，答复
   将无法通过防火墙，服务器会再次查询。注意：期望的范围也可仅使用
   :any:`use-v4-udp-ports` and :any:`use-v6-udp-ports` 表达，而
   ``avoid-`` 选项在这个意义上是冗余的；提供它们是为了向后兼容并可能
   简化端口规范。

   .. note:: 确保这个范围足够大，以保证安全。理想的大小依赖于几个参数，但
      是我们通常推荐它至少包含16384个端口（14位熵）。还要注意系统的缺省范
      围在使用时可能太小而不满足这个目的，这个范围甚至可能在 :iscman:`named` 运
      行时发生变化；当 :iscman:`named` 重新装载时，将会自动应用新的范围。鼓励显
      式地配置 :any:`use-v4-udp-ports` 和 :any:`use-v6-udp-ports` ，这样范围就足
      够大并适度地独立于其它应用所使用的范围。

   .. note:: :iscman:`named` 所用的运行配置可能禁止使用某些端口。例如，UNIX系统
      将不允许以非root权限运行的 :iscman:`named` 使用小于1024的端口。如果这样的
      端口被包含在所指定的（或被检测的）请求端口集合中，相应的请求企图将会
      失败，从而导致解析失败或延期。因此，配置端口集合，使其能够安全地使用
      在期望的运行环境中是很重要的。

   .. warning:: 不鼓励指定单一端口，因为它去掉了针对欺骗错误的一层保护。

   .. warning:: 配置的 :term:`port` 不能与监听端口相同。

   .. note:: 参见 :any:`transfer-source` ， :any:`notify-source` 和 :any:`parental-source` 。

.. _zone_transfers:

区传送
^^^^^^

BIND有机制来做区传送，并在系统进行区传送的地方对负载量设置限制。下列选
项应用于区传送。

.. _also-notify:

.. namedconf:statement:: also-notify
   :tags: transfer
   :short: 定义一个或多个当区发生变换时会向其发送 ``NOTIFY`` 消息的主机。

   这个选项定义一个全局的名字服务器的IP地址表，无论何时只要有更新的区被
   加载，都会向这个表中的服务器发出NOTIFY消息，还包括在区的NS记录中列出
   的服务器。这将有助于确保区拷贝尽快地同步到隐藏服务器。作为可选项，可
   以在每个 :any:`also-notify` 地址指定一个端口，用于将通知消息发到缺省的
   53之外的端口。每个地址也可指定一个可选的TSIG密钥，使通知信息也被签名；
   这在向多个视图发送通知时很有用。作为显式地址的替代，也可以使用一个或
   多个命名的 :any:`primaries` 列表。

   如果在 :any:`zone` 语句中有一个 :any:`also-notify` 表，它将会覆盖
   ``options also-notify`` 语句。当一个 ``zone notify`` 语句被设置为
   ``no`` ，对于这个区，将不会向全局 :any:`also-notify` 表中的IP地址发出
   NOTIFY消息。缺省是空表（无全局通知表）。

.. namedconf:statement:: max-transfer-time-in
   :tags: transfer
   :short: 指定入向区传送超时的分钟数，超过这个时间将被终止。

   入向区传送如果运行超过这个分钟数将被终止。缺省为120分钟（2小时）。
   最大值为28天（40320分钟）。

.. namedconf:statement:: max-transfer-idle-in
   :tags: transfer
   :short: 指定入向区传送没有进展的分钟数，超过这个时间将被终止。

   入向区传送在这个分钟数之内没有进展将被终止。缺省为60分钟（1小时）。
   最大值为28天（40320分钟）。

.. namedconf:statement:: max-transfer-time-out
   :tags: transfer
   :short: 指定出向区传送超时的分钟数，超过这个时间将被终止。

   出向区传送如果运行超过这个分钟数将被终止。缺省为120分钟（2小时）。
   最大值为28天（40320分钟）。

.. namedconf:statement:: max-transfer-idle-out
   :tags: transfer
   :short: 指定出向区传送没有进展的分钟数，超过这个时间将被终止。

   出向区传送在这个分钟数之内没有进展将被终止。缺省为60分钟（1小时）。
   最大值为28天（40320分钟）。

.. namedconf:statement:: notify-rate
   :tags: transfer, zone
   :short: 指定在通常的区维护操作中，NOTIFY请求被发送的频率。

   这指定在通常的区维护操作中，NOTIFY请求被发送的频率。（NOTIFY请求由于初始
   化区加载而受限于一个独立的速率限制；参见以下。）缺省是每秒20。可能的最低
   速率是1每秒；当设置为0时，它会被静默地提升为1。

.. namedconf:statement:: startup-notify-rate
   :tags: transfer, zone
   :short: 指定当名字服务器初次启动，或者当区是新增到名字服务器中时，NOTIFY请求被发送的频率。

   这是当名字服务器初次启动，或者当区是新增到名字服务器中时，NOTIFY请求被发
   送的频率。缺省是每秒20。可能的最低速率是1每秒；当设置为0时，它会被静默地
   提升为1。

.. namedconf:statement:: serial-query-rate
   :tags: transfer
   :short: 定义一个服务器查询用于区传送的SOA资源记录的每秒查询数的上限。

   辅服务器将会定期请求主服务器以发现区的序列号是否改变。每个这样的请求占用
   一定量的辅服务器网络带宽。为限制所使用的带宽数量，BIND 9限制请求发送的速
   率。 :any:`serial-query-rate` 选项的值为一个整数，表示每秒发送的最大请求数。
   缺省为20每秒。可能的最低速率是1每秒；当设置为0时，它会被静默地提升为1。

.. namedconf:statement:: transfer-format
   :tags: transfer
   :short: 控制在区传送时多条记录是否能打包在一条消息中。

   区传送可以使用两种不同的格式发送， ``one-answer`` 和 ``many-answers`` 。
   :any:`transfer-format` 选项用于在主服务器上决定使用那种格式发送。
   ``one-answer`` 使用一个DNS消息传送一个资源记录。 ``many-answers`` 将多个
   资源记录尽可能地打包在一个消息中。 ``many-answers`` 更有效率；缺省是
   ``many-answers`` 。通过使用 :namedconf:ref:`server` 语句，
   :any:`transfer-format` 可以被覆盖成以每个服务器为基础。

.. namedconf:statement:: transfer-message-size
   :tags: transfer
   :short: 在通过TCP进行区传送中使用的未压缩DNS消息大小的限制。

   这是一个用于使用TCP进行区传送的DNS消息的未压缩大小的上限。如果一个消息增
   长超过这个大小，会增加额外的消息以完成区传送。（注意，无论如何，这是一个
   提示，不是一个硬限制；如果一个消息包含单一资源记录并且其RDATA超过了这个
   大小限制，将允许一个更大的消息以完成这个记录的传送。）

   有效值介于512和65535字节之间，任何超过这个范围的值将被调整为范围内最接近
   的值。缺省是 ``20480`` ，选择这个值是为了提高消息压缩：大多数这个大小的
   DNS消息将被压缩到16536字节以内。更大的消息不能被有效地压缩，因为16536是
   一个DNS消息内最大允许压缩偏移量指针。

   这个选项主要用于服务器测试；设置为缺省值之外的值几乎没有收益。

.. namedconf:statement:: transfers-in
   :tags: transfer
   :short: 入向区传送并发数限制。

   这是可以同时运行的入向区传送的最大数目。缺省值是 ``10`` 。增加
   :any:`transfers-in` 可以加速辅区的同步，但是它也会增加本地系统的负载。

.. namedconf:statement:: transfers-out
   :tags: transfer
   :short: 出向区传送并发数限制。

   这是可以同时运行的出向区传送的最大数目。超过限制的区传送请求将会被拒
   绝。缺省值是 ``10`` 。

.. namedconf:statement:: transfers-per-ns
   :tags: transfer
   :short: 来自一个远程服务器的入向区传送的并发数量限制。

   这是可以同时运行的来自某个给定远程名字服务器的入向区传送的最大数目。
   缺省值是 ``2`` 。增加 :any:`transfers-per-ns` 可以加速辅区的同步，但是
   它也会增加远程名字服务器的负载。通过在 :namedconf:ref:`server` 语句中使用
   :any:`transfers` 子句， :any:`transfers-per-ns` 可以被覆盖成基于每个服务
   器。

.. namedconf:statement:: transfer-source
   :tags: transfer
   :short: 定义绑定服务器用其进行入向区传送的TCP连接的本地IPv4地址。

   :any:`transfer-source` 决定哪个本地地址将会被绑定到IPv4的TCP连接，是用
   于服务器获取传入的区。它也决定更新区的请求和转发动态更新所使用的源
   IPv4地址，及可选的UDP端口，如果未指定，它缺省是一个系统控制的值，通
   常是“最接近”远端的接口的地址。这个地址必须出现在远端被传送区的
   :any:`allow-transfer` 选项中，如果指定了这个选项的话。这个语句为所有区
   设置 :any:`transfer-source` ，但是可以通过在配置文件的 :any:`view` 或
   :any:`zone` 块中包含 :any:`transfer-source` 语句而被覆盖成以每个视图或每
   个区为基础。

   .. warning:: 不鼓励指定单一端口，因为它去掉了针对欺骗错误的一层保护。

   .. warning:: 配置的 :term:`port` 不能与监听端口相同。

.. namedconf:statement:: transfer-source-v6
   :tags: transfer
   :short: 定义绑定服务器用其进行入向区传送的TCP连接的本地IPv6地址。

   这个选项与 :any:`transfer-source` 相似，除了区传送是使用IPv6之外。

.. namedconf:statement:: alt-transfer-source
   :tags: transfer
   :short: 如果由 :any:`transfer-source` 定义的地址不能使用并且开启了 :any:`use-alt-transfer-source` ，这定义可以被服务器用于入向区传送的作为替换的本地IPv4地址。

   这个指示了一个可替换的传送源，如果在 :any:`transfer-source` 中列出的源
   失效并且设置了 ``use-alt-transfer-source`` 。

   .. note:: 要避免使用替换的传送源，正确设置 :any:`use-alt-transfer-source`
      并且不要依赖从第一个更新请求获得回复。

.. namedconf:statement:: alt-transfer-source-v6
   :tags: transfer
   :short: 定义可以被服务器用于入向区传送的作为替换的本地IPv6地址。

   这个指示了一个可替换的传送源，如果在 :any:`transfer-source-v6` 中列出的
   源失效并且设置了 :any:`use-alt-transfer-source` 。

.. namedconf:statement:: use-alt-transfer-source
   :tags: transfer
   :short: 指示是否使用 :any:`alt-transfer-source` 和 :any:`alt-transfer-source-v6` 。

   这个指示是否使用可替换的传送源，如果使用视图，这个选项的缺省为 ``no`` ，
   否则其缺省为 ``yes`` 。

.. namedconf:statement:: notify-source
   :tags: transfer
   :short: 定义用于向外发送 ``NOTIFY`` 消息的IPv4地址（和可选的端口）。

   :any:`notify-source` 决定哪个本地源地址，及可选的UDP端口，将用于发送
   NOTIFY消息。这个地址必须出现在辅服务器的 :any:`primaries` 区子句或
   :any:`allow-notify` 子句中。本语句为全部区设置 :any:`notify-source` ，但是
   可以通过在配置文件的 :any:`zone` 或 :any:`view` 块中包含 :any:`notify-source`
   语句而被覆盖成以每个区或每个视图为基础。

   .. warning:: 不鼓励指定单一端口，因为它去掉了针对欺骗错误的一层保护。

   .. warning:: 配置的 :term:`port` 不能与监听端口相同。

.. namedconf:statement:: notify-source-v6
   :tags: transfer
   :short: 定义用于向外发送 ``NOTIFY`` 消息的IPv6地址（和可选的端口）。

   这个选项与 :any:`notify-source` 相似，但是是将 ``NOTIFY`` 消息发送到IPv6地址。

.. _resource_limits:

操作系统资源限制
^^^^^^^^^^^^^^^^

服务器使用的大多数系统资源是可以限制的。在指定资源限制时的值是可变
的。例如， ``1G`` 可以使用 ``1073741824`` 来替代，以指定一吉字节的
限制。 ``unlimited`` 要求不限制使用，或可利用的最大数量。 ``default``
使用服务器启动时强制设定的限制。参见对 :term:`size` 的描述。

下列选项为名字服务器进程设置操作系统限制。某些操作系统不支持某些或
任何限制；在这样的系统上，如果使用一个不支持的限制，将会发出一条警
告。

.. namedconf:statement:: coresize
   :tags: server
   :short: 设置内核转储的最大大小。

   这个设置内核转储的最大大小。缺省为 ``default`` 。

.. namedconf:statement:: datasize
   :tags: server
   :short: 设置服务器可以使用的数据内存的最大数量。

   这个设置服务器可以使用的数据内存的最大数量。缺省为 ``default`` 。这是
   服务器内存用量的硬限制。如果服务器企图申请的内存超过这个限制，申请
   将会失败，将会导致服务器不能执行DNS服务。所以，这个选项很少作为一种
   限制内存总量的方式由服务器所使用，但是它可以用于在缺省值太小的情况
   下提升操作系统数据大小的限制。如果想限制服务器所使用的内存总量，使用
   :any:`max-cache-size` 和 :any:`recursive-clients` 选项来替代。

.. namedconf:statement:: files
   :tags: server
   :short: 设置服务器可以同时打开的文件的最大数量。

   这个设置服务器可以同时打开的文件的最大数量。缺省为 ``unlimited`` 。

.. namedconf:statement:: stacksize
   :tags: server
   :short: 设置服务器可以使用的栈内存的最大数量。

   这个设置服务器可以使用的栈内存的最大数量。缺省为 ``default`` 。

.. _server_resource_limits:

服务器资源限制
^^^^^^^^^^^^^^

下列选项设置了服务器对资源消耗的限额，这些限额是在服务器内部实现而
不是由操作系统来实现的。

.. namedconf:statement:: max-journal-size
   :tags: transfer
   :short: 控制日志文件的大小。

   这个设置每个日志文件（参见 :ref:`journal` ）的最大大小，表示成字节，
   或者如果后跟一个可选的单位后缀（‘k’，‘m’或‘g’），成千字节，兆字节或
   吉字节。当日志文件达到指定的大小时，其中一些最旧的事务会被自动删除。
   允许的最大值为2G字节。非常小的值会取整到4096字节。可以指定为
   ``unlimited`` ，表示2吉字节。如果设置限制为 ``default`` 或者不设置值，
   日志可以增长到两倍区的大小。（存储较大的日志有点微小的好处。）

   这个选项也可以基于每个区来设置。

.. namedconf:statement:: max-records
   :tags: zone, server
   :short: 设置一个区内允许的最大记录条目数。

   这个设置一个区内允许的最大记录条目数。缺省是零，表示没有限制。

.. namedconf:statement:: recursive-clients
   :tags: query
   :short: 指定服务器能够执行的并发递归查询的最大数目。

   这个设置服务器代表客户端执行的并行递归查询的最大数目（“硬限额”），缺省
   值是 ``1000`` 。因为每个递归查询使用相当大小的内存（大致是20k字节），
   在内存有限的主机上可以降低 :any:`recursive-clients` 选项的值。

   :any:`recursive-clients` 为等待的递归客户端定义一个“硬限额”：当超过这个数
   目的客户端在等待时，新进入的请求将不被接受，对每个新进入的请求，先前等
   待的请求将被丢弃。

   也可以设置一个“软限额”。当这个更低的限额被超过时，新进入的请求被接受，
   但是对每个新进入的请求，一个等待的请求将被丢弃。如果 :any:`recursive-clients`
   大于1000，软限额被设置为 :any:`recursive-clients` 减100；否则，它被设置为
   :any:`recursive-clients` 的90%。

.. namedconf:statement:: tcp-clients
   :tags: server
   :short: 指定服务器所能接受的并发的TCP客户端连接的最大数目。

   这个是服务器所能接受的并发的TCP客户端连接的最大数目。缺省是 ``150`` 。

.. namedconf:statement:: clients-per-query
   :tags: server
   :short: 设置服务器可以接受的针对任何给定请求的同时进行的递归客户端的初始最小数目，超过这个数目的额外请求都将被服务器丢掉。

   这设置允许同时进行的针对任何给定请求（<qname，qtype，qclass>）的递归
   客户端的初始数目（最小值），对任何超过这个数目的额外请求，服务器都
   将丢掉。 :iscman:`named` 会尝试自己调整这个值，并将改变记入日志。
   缺省值为10。

   所选择的值应该反映自它开始解析某个名字开始的一段时间内进来了多少个
   针对给定名字的请求。

.. namedconf:statement:: max-clients-per-query
   :tags: server
   :short: 设置服务器可以接受的针对任何给定请求的同时进行的递归客户端的最大数目，超过这个数目的额外请求都将被服务器丢掉。
    
   这设置允许同时进行的针对任何给定请求（<qname，qtype，qclass>）的递
   归客户端的最大数目，对任何超过这个数目的额外请求，服务器都将扔掉。

   如果请求的数目超过了 :any:`clients-per-query` ， :iscman:`named` 将
   会假定它正在与一个无响应的区打交道，就会扔掉多余的请求。如果它在扔
   掉请求后收到响应，它会调高估值直到 :any:`max-clients-per-query` 的
   限制。如果没有变化，20分钟后估值会被降低。

   如果 :any:`max-clients-per-query` 设为零，表示除了
   :any:`recursive-clients` 所设定的值外没有上限。如果
   :any:`clients-per-query` 设为零，不再应用
   :any:`max-clients-per-query` ，并且除了 :any:`recursive-clients` 要
   求外，没有上限。

.. namedconf:statement:: fetches-per-zone
   :tags: server, query
   :short: 设置对任何一个域的最大并发迭代请求数目，在这个数目内服务器会允许，超过这个数目，服务器或阻塞对这个区及之下数据的请求。

   这个设置对任何一个域的最大并发迭代请求数目，在这个数目内服务器会允
   许，超过这个数目，服务器或阻塞对这个区及之下数据的请求。这个值反映了
   在它所承担的解析时间内，对任意一个区，可以发送多少个正常的解析请求。
   它应该小于 :any:`recursive-clients` 。

   当多个客户端并发请求同样的名字和类型，客户端将被归并为同一次解析，直
   到达到 :any:`max-clients-per-query` 限制，并且只发出一个迭代请求。然
   而，当不同的客户端并发请求不同的名字或类型，将会发出多个请求，而
   :any:`max-clients-per-query` 没有限制效果。

   做为可选项，这个值可以跟随关键字 ``drop`` 或 ``fail`` ，指示针对一个
   区超过解析限额的请求是毫无响应地丢弃还是回应SERVFAIL。缺省是
   ``drop`` 。

   如果 :any:`fetches-per-zone` 被设置为0，对每个请求的解析数没有限制，不
   会丢弃请求。缺省是0.

   当前活跃解析的名单可以通过运行 :option:`rndc recursing` 导出。名单包括针对
   每个域活跃解析的数目和作为 :any:`fetches-per-zone` 限制的结果而通过（允
   许）或丢弃（溢出）的请求数目。（注意：这些计数器不随时间而累积；无论
   何时一个域的活跃解析数目下降为0，这个域的计数器将被删除，下一次一个
   解析发到这个域，就会重建计数器并被设置为0.）

.. namedconf:statement:: fetches-per-server
   :tags: server, query
   :short: 设置服务器允许发送给单一上游服务器的最大并发迭代请求数目，超过这个数目，服务器阻塞额外的请求。

   这个设置服务器允许发送给单一上游服务器的最大并发迭代请求数目，超过这
   个数目，服务器阻塞额外的请求。这个值反映了在它所承担的解析时间内，对
   任意一个服务器，可以发送多少个正常的解析请求。它应该小于
   :any:`recursive-clients` 。

   做为可选项，这个值可以跟随关键字 ``drop`` 或 ``fail`` ，指示在一个区
   的所有权威服务器被发现超过每个服务器的限额时，请求是应该毫无响应地丢
   弃还是回应SERVFAIL。缺省是 ``fail`` 。

   如果 :any:`fetches-per-server` 被设置为0，对每个请求的解析数没有限制，
   不会丢弃请求。缺省是0.

   响应中的 :any:`fetches-per-server` 限额是动态调整以检测拥塞。发给服务器的请
   求要么被响应，要么超时，会计算一个响应超时比率的指数加权移动平均值。如果
   当前平均超时比率上升到超过“高”限，那台服务器的 :any:`fetches-per-server` 被
   减小。如果超时比率下降到“低”限以下， :any:`fetches-per-server` 被增加。
   :any:`fetch-quota-params` 选项可以用来调整这个计算的参数。

.. namedconf:statement:: fetch-quota-params
   :tags: server, query
   :short: 设置用于动态增减 :any:`fetches-per-server` 限额的参数。上述限额是在响应中检测拥塞。

   这个设置用于动态增减 :any:`fetches-per-server` 限额的参数。上述限额是在响应
   中检测拥塞。

   第一个参数是一个整数，指示重新计算对每个服务器响应超时比率的移动平均值的
   频率。缺省值是100，意谓着每100个请求被回答或超时之后我们重新计算平均比率。

   剩余三个参数表示“低”限（缺省是0.1的超时比率），“高”限（缺省是0.3的比
   率）和移动平均值的折扣率（缺省是0.7）。越大的折扣率在计算移动平均值
   时使最近的事件权重更大；越小的折扣率使更远的事件权重更大，平滑掉超时
   比率中的短期噪点。这些参数都是定点数，精度为1/100；小数点后至少2位是
   要保留的。

.. namedconf:statement:: reserved-sockets
   :tags: deprecated
   :short: 已废弃。

   这个选项已被废弃并不再有效。

.. _max-cache-size:

.. namedconf:statement:: max-cache-size
   :tags: server
   :short: 设置用于一个独立的缓存及其相关元数据的最大内存量。

   这个设置用于一个独立的缓存及其相关元数据的最大内存量，以字节或物理内
   存总量的百分比计。缺省时，每个视图都有自身独立的缓存，这意谓着缓存数
   据所需的总内存量是所有视图的缓存数据库大小之和（除非使用了
   :ref:`attach-cache <attach-cache>` 选项）。

   当一个缓存数据库中的数据量达到配置的限制时， :iscman:`named` 开始修剪非过
   期的记录（遵循一个基于LRU的策略）。
   
   每个独立缓存的缺省大小限制是：
   
     - 对 :any:`recursion` 设置为 ``yes`` （缺省值）的视图是物理内存的
       90%，或者

     - 对 :any:`recursion` 设置为 ``no`` （缺省值）的视图是2 MB。

   任何小于2MB的正数都被忽略并重置为2MB。关键字 ``unlimited`` ，或值0，
   将使缓存大小没有限制；记录仅在过期时（根据其TTL）才从缓存中清除。
   
   .. note::

       对于定义了多个带有独立缓存并开启递归的视图的配置，推荐为每个视图
       设置合适的 :any:`max-cache-size` ，因为这个选项所使用的缺省值（每个
       独立缓存使用90%的物理内存）可能在长期运行之后导致内存耗尽。
   
   在启动和重配置时，带有限制大小的缓存预分配一个小块的内存（对每个给出
   的视图，不超过 :any:`max-cache-size` 的1%）。这个预分配作为一种优化，可
   以消除由于调整内部缓存结构的大小而引入的额外延迟。

   在不支持检测物理内存的系统上，基于百分比的值回退为 ``unlimited`` 。
   注意对可用物理内存总量的检测仅在启动时做一次，所以如果运行时物理内存
   数量发生变化， :iscman:`named` 将不会调整缓存大小。

.. namedconf:statement:: tcp-listen-queue
   :tags: server
   :short: 设置监听队列长度。

   这个设置监听队列长度。缺省值和最小值都是10。如果内核支持接受过滤器
   “dataready”，这个也可以控制有多少TCP连接可以在内核空间中排队以等待数
   据被接收。小于10的非零值将被静默地提升。也可以使用0；在大多数平台上
   这将会将监听队列长度设置为一个系统定义的缺省值。

.. namedconf:statement:: tcp-initial-timeout
   :tags: server, query
   :short: 设置服务器等待一个新的TCP连接上客户端的第一个消息的总时间（以毫秒为单位）。

   这个设置服务器等待一个新的TCP连接上客户端的第一个消息的总时间（以100毫秒为单
   位）。缺省是300（30秒），最小值是25（2.5秒），最大值是1200（2分钟）。超过最大
   值或者低于最小值将被调整，并在日志中记录告警。（注意：这个值必须大于期望的往
   返延迟时间；否则没有客户端能够有足够的时间提交一个消息。）这个值可以在运行时
   使用 :option:`rndc tcp-timeouts` 更改。

.. namedconf:statement:: tcp-idle-timeout
   :tags: query
   :short: 设置如果不使用EDNS TCP keepalive选项时，服务器在关闭一个空闲的TCP连接之前等待的总时间（以毫秒为单位）。

   这个设置当客户端不使用EDNS TCP keepalive选项时，服务器在关闭一个空闲的TCP连接
   之前等待的总时间（以100毫秒为单位）。缺省是300（30秒），最大值是1200（2分钟），
   最小值是1（十分之一秒）。超过最大值或者低于最小值将被调整，并在日志中记录告警。
   参见 :any:`tcp-keepalive-timeout` 查看客户端使用EDNS TCP keepalive选项。这个值可
   以在运行时使用 :option:`rndc tcp-timeouts` 更改。

.. namedconf:statement:: tcp-keepalive-timeout
   :tags: query
   :short: 设置如果使用EDNS TCP keepalive选项时，服务器在关闭一个空闲的TCP连接之前等待的总时间（以毫秒为单位）。

   这个设置当客户端使用EDNS TCP keepalive选项时，服务器在关闭一个空闲
   的TCP连接之前等待的总时间（以100毫秒为单位）。缺省是300（30秒），最
   大值是65535（大约1.8小时），最小值是1（十分之一秒）。超过最大值或者
   低于最小值将被调整，并在日志中记录告警。这个值可以大于
   :any:`tcp-idle-timeout` ，因为使用EDNS TCP keepalive选项的客户端期
   望使用TCP连接传送多个消息。这个值可以在运行时使用
   :option:`rndc tcp-timeouts` 更改。

.. namedconf:statement:: tcp-advertised-timeout
   :tags: query
   :short: 设置服务器在包含EDNS TCP keepalive选项的响应中发送的超时值（以毫秒为单位）。

   这个设置服务器在包含EDNS TCP keepalive选项的响应中发送的超时值（以100
   毫秒为单位）。它通知一个客户端应该保持会话打开的总时间。缺省是300（
   30秒），最大值是65535（大约1.8小时），最小值是0，这表示客户端必须立
   即关闭TCP连接。通常这应该被设置为与 :any:`tcp-keepalive-timeout` 相
   同的值。这个值可以在运行时使用 :option:`rndc tcp-timeouts` 更改。

.. _intervals:

周期性任务的间隔
^^^^^^^^^^^^^^^^

.. namedconf:statement:: heartbeat-interval
   :tags: zone
   :short: 设置服务器将对所有标记为 :any:`dialup` 的区执行区维护任务的间隔。

   服务器将对所有标记为 :any:`dialup` 的区执行区维护任务，无论本时间间
   隔是否过期。缺省是60分钟。1天（1440分钟）以内的值都是合理的。最
   大值是28天（40320分钟）。如果设置为0，就不会对这些区进行区维护。

.. namedconf:statement:: interface-interval
   :tags: server
   :short: 设置服务器扫描网络接口列表的间隔。

   服务器将每 :any:`interface-interval` 分钟对网络接口列表进行扫描。缺省是60分钟。
   最大值是28天（40320分钟）。如果设置为0，仅在配置文件装载后，或者当
   :any:`automatic-interface-scan` 被开启并且操作系统支持，才会进行接口扫描。扫描
   后，服务器将开始在新发现的端口监听请求（假定这些端口在 :any:`listen-on` 配置中
   被允许），并会停止在已经不存在的端口上的监听。为方便起见，可以用TTL风格的时
   间单位后缀来指定这个值。它也接受 ISO 8601 的持续时间格式。

.. _the_sortlist_statement:

:any:`sortlist` 语句
^^^^^^^^^^^^^^^^^^^^

一个DNS请求的响应由多个资源记录（Resource Record，RR）构成，它们形成
了一个资源记录集（RRset）。名字服务器的通常返回中，资源记录集中的资源
记录的顺序是不确定的（但可参见 :ref:`rrset_ordering` 中的
:any:`rrset-order` 语句）。客户端解析器代码应该适当地重新对资源记录排序：
即，优先使用本地网络中的任何地址，然后是其它地址。然而，不是所有的解析
器可以完成这项工作，或者被错误配置。当一个客户端使用一个本地服务器时，
排序可以基于客户端的地址在服务器上完成。这仅需要配置名字服务器，完全不
需要配置客户端。

.. namedconf:statement:: sortlist
   :tags: query
   :short: 基于客户端的IP地址控制返回给客户端的资源记录的顺序。

   :any:`sortlist` 语句（见下）接受一个 :term:`address_match_list` ，
   并以一个特殊的方式解释它。每个 :any:`sortlist` 中的顶层语句必须使用
   一个或两个元素在 :term:`address_match_list` 中显式地指定其自身。每
   个顶层列表的第一个元素（必须是一个IP地址，一个IP前缀，一个ACL名或者
   一个嵌套的 :term:`address_match_list` ）与请求的源地址比较，直到匹
   配。当第一个元素中的地址一致时，第一个匹配的规则就会被选择。

   一旦请求的源地址匹配，如果顶层语句只包含一个元素，实际与源地址匹配的
   元素用于选择响应中的地址，通过放在响应的开始处来实现。如果语句是两个
   元素的列表，第二个元素被解释成一个拓扑优先列表。每个顶层元素被指定一
   个距离，响应中具有最小距离的地址被放在响应的开始。

   在下面的例子中，从主机的任何地址所收到的任何请求将会优先得到任何本地
   连接网络地址的响应。下一个优先的是在192.168.1/24网络上的地址，然后是
   192.168.2/24或192.168.3/24网络，这两个网络之间没有优先关系。来自
   192.168.1/24网络上的主机的请求比192.168.2/24和192.168.3/24网络的地址
   优先。来自192.168.4/24或192.168.5/24网络的主机的请求将仅仅比主机直接
   连接的其它地址优先。

::

   sortlist {
       // IF the local host
       // THEN first fit on the following nets
       { localhost;
       { localnets;
           192.168.1/24;
           { 192.168.2/24; 192.168.3/24; }; }; };
       // IF on class C 192.168.1 THEN use .1, or .2 or .3
       { 192.168.1/24;
       { 192.168.1/24;
           { 192.168.2/24; 192.168.3/24; }; }; };
       // IF on class C 192.168.2 THEN use .2, or .1 or .3
       { 192.168.2/24;
       { 192.168.2/24;
           { 192.168.1/24; 192.168.3/24; }; }; };
       // IF on class C 192.168.3 THEN use .3, or .1 or .2
       { 192.168.3/24;
       { 192.168.3/24;
           { 192.168.1/24; 192.168.2/24; }; }; };
       // IF .4 or .5 THEN prefer that net
       { { 192.168.4/24; 192.168.5/24; };
       };
   };

下列例子给出本地主机和本地主机直接连接网络下的合理行为。发给来自本地
主机请求的响应优先选用任何直接连接的网络。发给来自直接连接网络的其它
主机请求的响应优先选用同一网络的地址。发给其它请求的响应不排序。

::

   sortlist {
          { localhost; localnets; };
          { localnets; };
   };

.. _rrset_ordering:

资源记录集排序
^^^^^^^^^^^^^^

.. note::

    在随后的请求中变换一个DNS响应中记录的顺序是一个众所周知的负载分担
    技术，某些警告（主要来自缓存）适用于这种情况，当单独使用时，通常
    使其成为负载平衡的次优选择。

.. namedconf:statement:: rrset-order
   :tags: query
   :short: 定义返回资源记录（资源记录集）的顺序。

   :any:`rrset-order` 语句允许在一个多记录响应中配置记录的顺序。参见：
   :ref:`the_sortlist_statement`.

   一条 :any:`rrset-order` 语句中的每条规则是如下定义的：

   ::

       [class <class_name>] [type <type_name>] [name "<domain_name>"] order <ordering>

   每条规则的缺省修饰符为：

     - 如果没有指定 ``class`` ，缺省是 ``ANY`` 。
     - 如果没有指定 :any:`type` ，缺省是 ``ANY`` 。
     - 如果没有指定 ``name`` ，缺省是 ``*`` （星号）。

   :term:`<domain_name> <domain_name>` 只匹配名字自身，不匹配其任何子
   域。要使一条规则匹配一个给定名字的所有子域，必须使用一个通配名（
   ``*.<domain_name>`` ）。注意 ``*.<domain_name>`` **不会** 匹配
   ``<domain_name>`` 自身；要指定一个名字和其所有子域的资源记录集顺序，
   必须定义两条独立的规则：一条用于 ``<domain_name>`` 而另一条用于
   ``*.<domain_name>`` 。

   合法的 ``<ordering>`` 值是：

   ``fixed``
       以区文件中定义的顺序返回记录。

   .. note::

       ``fixed`` 选项仅在BIND编译时带有 ``--enable-fixed-rrset`` 配置时
       才可用。

   ``random``
       以随机的顺序返回记录。

   ``cyclic``
       以循环轮转的顺序返回记录，每次请求轮转一条记录。

   ``none``
       以从数据库中提取到的顺序返回记录。这个顺序是不确定的，但是会保持一致，
       只要数据库没有被修改。

   使用的缺省资源记录集顺序取决于 :iscman:`named` 所使用的配置文件中是
   否存在任何 :any:`rrset-order` 语句：

     - 如果配置文件中没有出现 :any:`rrset-order` 语句，隐式的缺省是以
       ``random`` 顺序返回所有记录。

     - 如果配置文件中有任何 :any:`rrset-order` 语句，但是与给定的资源记录
       集匹配的这些语句中没有顺序规则，对那些资源记录集而言，缺省的顺
       序是 ``none`` 。

   注意如果在配置文件（在 :namedconf:ref:`options` 和 :any:`view` 两级
   中）出现了多条 :any:`rrset-order` 语句，它们 **不会** 组合；而是更
   具体的一个（ :any:`view` ）取代不太具体的一个（ :namedconf:ref:`options` ）。

   如果同一条 :any:`rrset-order` 语句内的多条规则匹配了一个给定的资源记录集，
   将会应用第一条匹配的规则。

   例如：

   ::

       rrset-order {
           type A name "foo.isc.org" order random;
           type AAAA name "foo.isc.org" order cyclic;
           name "bar.isc.org" order fixed;
           name "*.bar.isc.org" order random;
           name "*.baz.isc.org" order cyclic;
       };

   由于上述的配置，将使用下列资源记录集顺序：

   ===================    ========    ===========
   QNAME                  QTYPE       RRset Order
   ===================    ========    ===========
   ``foo.isc.org``        ``A``       ``random``
   ``foo.isc.org``        ``AAAA``    ``cyclic``
   ``foo.isc.org``        ``TXT``     ``none``
   ``sub.foo.isc.org``    all         ``none``
   ``bar.isc.org``        all         ``fixed``
   ``sub.bar.isc.org``    all         ``random``
   ``baz.isc.org``        all         ``none``
   ``sub.baz.isc.org``    all         ``cyclic``
   ===================    ========    ===========

.. _tuning:

调优
^^^^

.. namedconf:statement:: lame-ttl
   :tags: server
   :short: 设置解析器的跛缓存。

   这个总是设置为0。更多可用信息在
   `关于CVE-2021-25219的安全咨询
   <https://kb.isc.org/docs/cve-2021-25219>`_.

.. namedconf:statement:: servfail-ttl
   :tags: server
   :short: 设置一个SERVFAIL响应被缓存的时间长度（以秒计）。

   这个设置由于DNSSEC验证失败或者其它通用的服务器失败而导致SERVFAIL响应被缓存
   的秒数。如果设置为 ``0`` ，关闭SERVFAIL缓存。如果一个请求带有
   CD（Checking Disabled）位，SERVFAIL缓存不被查询；这允许由于DNSSEC验证而失
   败的请求能够重试，而不是等待SERVFAIL的TTL过期。

   最大值是 ``30`` 秒；更高的值将被静默地减小。缺省是 ``1`` 秒。

.. namedconf:statement:: min-ncache-ttl
   :tags: server
   :short: 指定服务器缓存中所存储的否定答复的最小保持时间（以秒计）。

   为了减少网络流量和提高性能，服务器存储否定响应。 :any:`min-ncache-ttl` 用于
   设置这些响应在服务器中最小保持时间，单位为秒。为方便起见，TTL风格的时间单
   位后缀也可用于指定这个值。它也接受 ISO 8601 的持续时间格式。

   缺省的 :any:`min-ncache-ttl` 值是 ``0`` 秒。 :any:`min-ncache-ttl` 不能超过90
   秒，如果设置为更大的值将被截断成90秒。

.. namedconf:statement:: min-cache-ttl
   :tags: server
   :short: 指定服务器缓存普通（肯定）答复的最小时间（以秒计）。

   这个设置服务器缓存普通（肯定）响应的最小时间，单位为秒。为方便起见，TTL
   风格的时间单位后缀也可用于指定这个值。它也接受 ISO 8601 的持续时间格式。

   缺省的 :any:`min-cache-ttl` 值是 ``0`` 秒。 :any:`min-cache-ttl` 不能超过90秒，
   如果设置为更大的值将被截断成90秒。

.. namedconf:statement:: max-ncache-ttl
   :tags: server
   :short: 指定服务器缓存中所存储的否定答复的最大保持时间（以秒计）。

   为了减少网络流量和提高性能，服务器会存储否定响应。 :any:`max-ncache-ttl` 用于
   设置这些响应在服务器中最大保持时间，单位为秒。为方便起见，TTL风格的时间单
   位后缀也可用于指定这个值。它也接受 ISO 8601 的持续时间格式。

   缺省的 :any:`max-ncache-ttl` 值为 ``10800`` （3小时）。 :any:`max-ncache-ttl`
   不能超过7天，如果设置为更大的值，将会静默地被截为7天。

.. namedconf:statement:: max-cache-ttl
   :tags: server
   :short: 指定服务器缓存普通（肯定）答复的最大时间（以秒计）。

   这个设置服务器缓存普通（肯定）响应的最大时间，单位为秒。为方便起见，TTL
   风格的时间单位后缀也可用于指定这个值。它也接受 ISO 8601 的持续时间格式。

   缺省的 :any:`max-cache-ttl` 值是 ``604800`` （一周）。值为0可能导致所有的请
   求都返回SERVFAIL，因为在解析过程中会丢失中间资源记录集（如NS和粘连AAAA/A
   记录）的缓存。

.. namedconf:statement:: max-stale-ttl
   :tags: server
   :short: 指定服务器保留已过普通有效期而作为旧数据返回的记录的最大时间。

   如果在缓存中保留旧资源记录集被开启，并且返回旧缓存答复也被开启，
   :any:`max-stale-ttl` 设置服务器保留那些超期记录的最大时
   间。这些超期记录在其服务器不可达时将作为旧记录响应。缺省是1天。允许
   的最小值是1秒；一个为0的值将被静默地更新为1秒。

   要返回旧记录，必须通过配置选项 :any:`stale-cache-enable` 将其保留在缓存中，
   并且必须开启返回所缓存的答复，要么在配置文件中使用
   :any:`stale-answer-enable` 选项，或者通过调用
   :option:`rndc serve-stale on <rndc serve-stale>` 。

   当 :any:`stale-cache-enable` 被设置为 ``no`` 时，设置 :any:`max-stale-ttl` 没有
   效果，在这种情况下， :any:`max-stale-ttl` 的值将为 ``0`` 。

.. namedconf:statement:: resolver-nonbackoff-tries
   :tags: server
   :short: 指定在指数后退进行之前重试的次数。

   这个指定在指数后退进行之前重试的次数。缺省是 ``3`` 。

.. namedconf:statement:: resolver-retry-interval
   :tags: server
   :short: 指定基本重试间隔（以毫秒计）。

   这个设置以毫秒计的基本重试间隔。缺省是 ``800`` 。

.. namedconf:statement:: sig-validity-interval
   :tags: dnssec
   :short: 指定由 :iscman:`named` 生成的RRSIG有效的最大天数。

   这个指定由 :iscman:`named` 生成的RRSIG有效天数的上限；缺省是 ``30`` 天，最
   大值是3660天（10年）。可选的第二个值指定这些RRSIG的下限，并且也决定
   在过期前多长时间 :iscman:`named` 开始重新生成这样RRSIG。下限的缺省值是上限
   的 1/4；如果上限大于7天，则以天为单位，如果小于等于7天，则以小时为单
   位。

   当生成新的RRSIG时，在这两个限制之间随机选择时间长度，以分散重新签名
   的负载。当重新生成RRSIG时，使用上限，并增加一个较小的抖动量。新RRSIG
   由许多进程生成，包括对UPDATE请求(:ref:`dynamic_update`)的处理，通过内
   联签名添加和删除记录，以及区的初始签名。

   签名的开始时间被无条件地设为当前时间之前一小时，以允许有限的时钟误差。

   :any:`sig-validity-interval` 可以为了DNSKEY记录被覆盖，通过设置
   :any:`dnskey-sig-validity` 。

   :any:`sig-validity-interval` 应该至少是SOA过期间隔的几倍，以允许在不同计时器
   和过期日期之间合理的互操作。

.. namedconf:statement:: dnskey-sig-validity
   :tags: dnssec
   :short: 指定自动生成的DNSSEC签名在未来过期的天数。

   这个指定在未来的一个天数，在这个时候，为DNSKEY资源记录集而自动生成的，且作
   为动态更新（ :ref:`dynamic_update` ）的结果的DNSSEC签名将会过期。如果设置
   为一个非零值，这将覆盖由 :any:`sig-validity-interval` 所设置的值。缺省是零，
   表示使用 :any:`sig-validity-interval` 。最大值是3660天（10年），更大的值将被
   拒绝。

.. namedconf:statement:: sig-signing-nodes
   :tags: dnssec
   :short: 指定当使用一个新DNSKEY对一个区签名时，在每个单元中检查的节点的最大数目。

   这个指定在使用一个新DNSKEY签名一个区时，在每个单元中检查的节点的最大数
   目。缺省是 ``100`` 。

.. namedconf:statement:: sig-signing-signatures
   :tags: dnssec
   :short: 指定当使用一个新DNSKEY对一个区签名时，签名数目的阈值，如果超过将会终止对一个单元的处理。

   这个指定在使用一个新DNSKEY签名一个区时，签名数目的阈值，如果超过将会
   终止对一个单元的处理。缺省是 ``10`` 。

.. namedconf:statement:: sig-signing-type
   :tags: dnssec
   :short: 指定在生成签名状态记录时会用到的一个私有RDATA类型。

   这个指定在生成签名状态记录时会用到的一个私有RDATA类型。缺省是
   ``65534`` 。

   一旦有了一个标准类型，这个参数可能在将来的版本中被去掉。

   签名状态记录是用于 :iscman:`named` 内部，用来跟踪一个区签名进程的当
   前状态。即，它是否还存活或者已经完成。这些记录可以使用命令
   :option:`rndc signing -list zone <rndc signing>` 检查。一旦
   :iscman:`named` 使用一个特定密钥完成对一个区的签名，与那个密钥相关
   的签名状态记录就可以通过执行
   :option:`rndc signing -clear keyid/algorithm zone <rndc signing>`
   删除。要删除一个区的所有已完成签名状态记录，使用
   :option:`rndc signing -clear all zone <rndc signing>` 。

.. namedconf:statement:: min-refresh-time
   :tags: transfer
   :short: 限制区刷新间隔不能比指定值，以秒为单位，更小。

   这个选项控制服务器在刷新一个区（请求SOA看是否有变化）时的行为。通常
   使用区SOA的refresh值；然而，这些值是由主服务器设置的，只给辅服务器
   管理员一点点对内容的控制权。

   这个选项允许管理员针对每个区，每个视图或者全局设置一个以秒计的最小
   的刷新时间。这个选项对辅区和存根区有效，将SOA的刷新时间指定到特定的
   值上。

   缺省值是300秒。

.. namedconf:statement:: max-refresh-time
   :tags: transfer
   :short: 限制区刷新间隔不能比指定值，以秒为单位，更大。

   这个选项控制服务器在刷新一个区（请求SOA看是否有变化）时的行为。通常
   使用区SOA的refresh值；然而，这些值是由主服务器设置的，只给辅服务器
   管理员一点点对内容的控制权。

   这个选项允许管理员针对每个区，每个视图或者全局设置一个以秒计的最大
   的刷新时间。这个选项对辅区和存根区有效，将SOA的刷新时间指定到特定的
   值上。

   缺省值是2419200秒（4周）。

.. namedconf:statement:: min-retry-time
   :tags: transfer
   :short: 限制区刷新重试间隔不能比指定值，以秒为单位，更小。

   这个选项控制服务器在重试失败的区传送时的行为。通常使用区SOA的retry
   值；然而，这些值是由主服务器设置的，只给辅服务器管理员一点点对内容
   的控制权。

   这个选项允许管理员针对每个区，每个视图或者全局设置一个以秒计的最小
   的重试时间。这个选项对辅区和存根区有效，将SOA的重试时间指定到特定的
   值上。

   缺省值是500秒。

.. namedconf:statement:: max-retry-time
   :tags: transfer
   :short: 限制区刷新重试间隔不能比指定值，以秒为单位，更大。

   这个选项控制服务器在重试失败的区传送时的行为。通常使用区SOA的retry
   值；然而，这些值是由主服务器设置的，只给辅服务器管理员一点点对内容
   的控制权。

   这个选项允许管理员针对每个区，每个视图或者全局设置一个以秒计的最大
   的重试时间。这个选项对辅区和存根区有效，将SOA的重试时间指定到特定的
   值上。

.. namedconf:statement:: edns-udp-size
   :tags: query
   :short: 设置被广告的EDNS UDP缓存的最大大小，用以控制从权威服务器接收的作为递归响应的包的大小。

   这个设置被广告的以字节计的EDNS UDP缓存的最大大小，用以控制从权威服
   务器接收的作为递归响应的包的大小。有效值为从512到4096；超出这个范围
   的值将被静默地调整为范围内最接近的值。缺省值是1232。

   设置 :any:`edns-udp-size` 为非缺省值的通常的原因是为了让UDP回答穿过
   坏的防火墙，这样的防火墙阻止碎包和（或）阻止大于512字节的UDP DNS包
   通过。

   当 :iscman:`named` 首次请求一个远程服务器时，它会广告一个1232字节的
   UDP缓冲区。

   任何给定服务器观察到的查询超时都会影响发送到该服务器的查询中通告的
   缓冲区大小。依赖于观察到的包丢弃模式，查询在TCP上重试。每个服务器的
   EDNS统计信息仅为给定服务器ADB条目的生命周期而保留在内存中。

   :iscman:`named` 现在对向外发出的UDP包设置
   **不要分片（DON'T FRAGMENT）** 的标志。根据多个团队的测量，这不会导
   致任何运行问题，由于大多数互联网“核心”都能够处理大小介于1400-1500字
   节的IP消息，1232被采用为一个保守的最小值，它可以被DNS操作员修改为一
   个估计的路径MTU减去估计的头大小。在实践中，在正常运行DNS的社区中可
   见证的MTU最小值是1500字节，即以太网最大荷载，所以在 **可靠的** 网络
   上最大DNS/UDP荷载的有益的缺省值是1432。

   任何特定于服务器的 ``edns-udp-size`` 设置都优先于上述所有规则。即，
   为一个给定的 :namedconf:ref:`server` 块配置一个静态值。

.. namedconf:statement:: max-udp-size
   :tags: query
   :short: 设置 :iscman:`named` 所发送的EDNS UDP消息的最大字节数。

   这个设置 :iscman:`named` 所发送的EDNS UDP消息的最大字节数。有效值为
   从512到4096（超出这个范围的值将被静默地调整为范围内最接近的值）。缺
   省值是1232。

   这个值应用在一个服务器发出的响应；要设置请求中广告的缓存大小，参见
   :any:`edns-udp-size` 。

   设置 :any:`max-udp-size` 为非缺省值的通常的原因是允许UDP回答穿过坏
   的防火墙，这样的防火墙阻止碎包和（或）阻止大于512字节的UDP包通过。
   这是独立于所广播的接收缓存（ :any:`edns-udp-size` ）。

   这个值设置得越小，就会鼓励越多的TCP流量到达名字服务器。

.. namedconf:statement:: masterfile-format
   :tags: zone, server
   :short: 指定区文件的文件格式。

   这个指定区文件的文件格式（详细情况参见 :ref:`zonefile_format` ）。
   缺省值是 ``text`` ，即标准的文本表示，除非对辅区，对后者缺省值为
   ``raw`` 。 ``text`` 之外的文件格式一般是用
   :iscman:`named-compilezone` 工具生成，或由 :iscman:`named` 导出。

   需要注意的是，如果一个非 ``text`` 格式的区文件被装载，
   :iscman:`named` 将省略某些只对 ``text`` 格式文件才做的检查。例如，
   :any:`check-names` 只用于装载 ``text`` 格式的区。 ``raw`` 格式的区
   文件应以 :iscman:`named` 配置文件中所指定的同样检查级别来生成。
   
   当配置在 :namedconf:ref:`options` 中时，本语句为所有区设置
   :any:`masterfile-format` ，但是可以通过在配置文件中的 :any:`zone`
   或 :any:`view` 块中包含 :any:`masterfile-format` 语句而被覆盖成以每
   个区或每个视图为基础。

.. namedconf:statement:: masterfile-style
   :tags: server
   :short: 指定当 :any:`masterfile-format` 为 ``text`` ，在导出时的区文件格式。

   这指定当 :any:`masterfile-format` 为 ``text`` ，在导出时的区文件格式。
   在带有任何其它 :any:`masterfile-format` 时，这个选项被忽略。

   当设置为 ``relative`` 时，记录以多行格式输出，其属主名被表示成相对于一
   个共享的起点。当设置为 ``full`` ，记录以单行格式输出，并带有绝对的属主
   名。当一个区文件需要被一个脚本自动化处理时， ``full`` 格式是最适合的。
   ``relative`` 格式更适合阅读，更适合手工编辑一个区。缺省是 ``relative`` 。

.. namedconf:statement:: max-recursion-depth
   :tags: server
   :short: 设置在任意一次提供递归服务时，所允许的最大递归层级数。

   这设置在任意一次提供递归服务时，所允许的最大递归层级数。解析一个名
   字时可能要求查找一个名字服务器的地址，这会导致要求解析另外的名字，
   等等；如果递归查询的次数超过了这个值，递归请求会被终止并返回
   SERVFAIL。缺省是7.

.. namedconf:statement:: max-recursion-queries
   :tags: server, query
   :short: 设置提供递归请求服务时可以发出的迭代查询的最大数目。

   这个设置提供递归请求服务时可以发出的迭代查询的最大数目。如果需要发出
   更多的请求，递归请求会被终止并返回SERVFAIL。缺省是100。

.. namedconf:statement:: notify-delay
   :tags: transfer, zone
   :short: 设置发送一个区的NOTIFY消息集之间的延迟（以秒计）。

   这个设置在发送一个区的NOTIFY消息集之间的延迟，单位为秒。无论何时发送
   一个区的NOTIFY消息，都会为这个时间段设置一个计时器。如果该区在计时器
   到期之前又被更新，更新的NOTIFY将被推迟。缺省是5秒。

   所有区所发出的NOTIFY消息的整体速率是由 :any:`notify-rate` 来控制。

.. namedconf:statement:: max-rsa-exponent-size
   :tags: dnssec, query
   :short: 设置在验证时能够接受的最大RSA指数的大小（以位计）。

   这个设置在验证时能够接受的最大RSA指数的位数。有效值是从35到4096位。
   缺省值0也可以接受的，并且等效于4096.

.. namedconf:statement:: prefetch
   :tags: query
   :short: 指定当前查询发生预取的“触发器”生存期（TTL）。

   当收到一个有缓存且即将过期的请求， :iscman:`named` 可以立即从权威服务器刷
   新数据，确保缓存总有答复可用。

   :any:`prefetch` 指定"触发"TTL值，在这个值将进行当前请求的预取：当一个低TTL
   值的缓存记录在查询过程中遇到，它将被刷新。有效的触发TTL值是1到10秒。超
   过10秒的值将被静默地减到10。将一个触发TTL设置为零将关闭预取功能。缺省的
   触发TTL是 ``2`` 。

   一个可选的第二参数指定"合格" TTL：对于一个适合预取的记录可接受的最小
   **初始** TTL值。合格TTL必须至少比触发TTL大六秒：如果不是这样， :iscman:`named`
   将静默地向大调整。缺省的合格TTL是 ``9`` 。

.. namedconf:statement:: v6-bias
   :tags: server, query
   :short: 指示IPv6名字服务器优先的毫秒数。

   在决定要试探的下一个名字服务器时，这个指示IPv6的名字服务器会优先的毫秒数。
   缺省是 ``50`` 毫秒。

.. namedconf:statement:: tcp-receive-buffer
   :tags: server
   :short: 设置操作系统的TCP套接字接收缓存大小。

.. namedconf:statement:: udp-receive-buffer
   :tags: server
   :short: 设置操作系统的UDP套接字接收缓存大小。

   这些选项分别为TCP和UDP套接字控制操作系统的接收缓冲区大小（
   ``SO_RCVBUF`` ）。在操作系统层的缓存可以防止在短暂的负载高峰是丢包，
   但是如果缓存大小设置太高，服务器可能被已超时的、未完成的请求阻塞。缺
   省是 ``0`` ，意谓着应该使用操作系统的缺省值。可配置的最小值是
   ``4096`` ；任何小于它的非零值都会被静默地提高。最大值已由内核决定，
   超过最大值将被静默地减少。

.. namedconf:statement:: tcp-send-buffer
   :tags: server
   :short: 设置操作系统的TCP套接字发送缓存大小。

.. namedconf:statement:: udp-send-buffer
   :tags: server
   :short: 设置操作系统的UDP套接字发送缓存大小。

   这些选项分别为TCP和UDP套接字控制操作系统的发送缓冲区大小（
   ``SO_SNDBUF`` ）。在操作系统层的缓存可以防止在短暂的负载高峰是丢包，
   但是如果缓存大小设置太高，服务器可能被已超时的、未完成的请求阻塞。缺
   省是 ``0`` ，意谓着应该使用操作系统的缺省值。可配置的最小值是
   ``4096`` ；任何小于它的非零值都会被静默地提高。最大值已由内核决定，
   超过最大值将被静默地减少。

.. _builtin:

服务器内置信息区
^^^^^^^^^^^^^^^^

服务器通过在 ``CHAOS`` 类中的伪顶级域 ``bind`` 下面的一些内置区提供了
一些有用的诊断信息。这些区是 ``CHAOS`` 类中内置视图（参见
:ref:`view_statement_grammar` ）的一部份，与缺省的 ``IN`` 类视图是分开
的。大多数全局配置选项（ :any:`allow-query` 等等）将会应用到这个视图，
但是有一些是局部被覆盖的： :namedconf:ref:`notify` ， :any:`recursion`
和 :any:`allow-new-zones` 总是被设置为 ``no`` ，并且 :any:`rate-limit`
被设置为允许每秒三个响应。

要关掉这些区，使用下面的选项，或者通过定义一个 ``CHAOS`` 类下的匹配所
有客户端的显式视图来隐藏内置的 ``CHAOS`` 视图。

.. namedconf:statement:: version
   :tags: server
   :short: 指定在响应一个 ``version.bind`` 查询时所返回的服务器的版本号。

   这是服务器在收到一个类型为 ``TXT`` ，类为 ``CHAOS`` ，名为 ``version.bind``
   的查询时应该报告的版本。缺省是这个服务器的真实版本号。指定 ``version none``
   关掉对这个请求的处理。

   将 :any:`version` 设置为任何值（包括 ``none`` ）将同时关闭对
   ``authors.bind TXT CH`` 的请求。

.. namedconf:statement:: hostname
   :tags: server
   :short: 指定在响应一个 ``hostname.bind`` 查询时所返回的服务器的主机名。

   这是服务器在收到一个类型为 ``TXT`` ，类为 ``CHAOS`` ，名为
   ``hostname.bind`` 的请求时应该报告的主机名。缺省为运行名字服务器的主
   机名，是由 ``gethostname()`` 函数所查到的。这个请求的主要目的是判定
   在一组anycast服务器中是哪一台在实际回应请求。指定 ``hostname none;``
   关掉对这个请求的处理。

.. namedconf:statement:: server-id
   :tags: server
   :short: 指定在响应一个 ``ID.SERVER`` 查询时所返回的服务器的ID。

   这是服务器在收到一个名字服务器标识符（Name Server Identifier, NSID）
   请求，或一个类型为 ``TXT`` ，类为 ``CHAOS`` ，名为 ``ID.SERVER`` 的
   请求时应该报告的ID。这类请求的主要目的是判定在一组anycast服务器中是
   哪一台在实际回应请求。指定 ``server-id none;`` 关掉对这个请求的处
   理。指定 ``server-id hostname;`` 将使 :iscman:`named` 使用由
   ``gethostname()`` 函数所查到的主机名。缺省 :any:`server-id` 是
   ``none`` 。

.. _empty:

内置空区
^^^^^^^^

:iscman:`named` 服务器有一些内置空区（仅含有SOA和NS记录）。这是通常情况下只应在本
地响应而不应该发到互联网的根服务器上的请求。覆盖这些名字空间的官方服务器会
对这些请求响应NXDOMAIN。特别地，这些覆盖了来自于 :rfc:`1918` ，:rfc:`4193` ，
:rfc:`5737` 和 :rfc:`6598` 。其中也包含IPv6本地地址（本地分配的），IPv6链路
本地地址，IPv6环回地址和IPv6未知地址的反向名字空间。

服务器将试图决定是否一个内置区已经存在或者是激活的（被一个forward-only的转
发定义所覆盖），并且在有一种情况为真时不会创建一个空区。

当前的空区列表为：

-  10.IN-ADDR.ARPA
-  16.172.IN-ADDR.ARPA
-  17.172.IN-ADDR.ARPA
-  18.172.IN-ADDR.ARPA
-  19.172.IN-ADDR.ARPA
-  20.172.IN-ADDR.ARPA
-  21.172.IN-ADDR.ARPA
-  22.172.IN-ADDR.ARPA
-  23.172.IN-ADDR.ARPA
-  24.172.IN-ADDR.ARPA
-  25.172.IN-ADDR.ARPA
-  26.172.IN-ADDR.ARPA
-  27.172.IN-ADDR.ARPA
-  28.172.IN-ADDR.ARPA
-  29.172.IN-ADDR.ARPA
-  30.172.IN-ADDR.ARPA
-  31.172.IN-ADDR.ARPA
-  168.192.IN-ADDR.ARPA
-  64.100.IN-ADDR.ARPA
-  65.100.IN-ADDR.ARPA
-  66.100.IN-ADDR.ARPA
-  67.100.IN-ADDR.ARPA
-  68.100.IN-ADDR.ARPA
-  69.100.IN-ADDR.ARPA
-  70.100.IN-ADDR.ARPA
-  71.100.IN-ADDR.ARPA
-  72.100.IN-ADDR.ARPA
-  73.100.IN-ADDR.ARPA
-  74.100.IN-ADDR.ARPA
-  75.100.IN-ADDR.ARPA
-  76.100.IN-ADDR.ARPA
-  77.100.IN-ADDR.ARPA
-  78.100.IN-ADDR.ARPA
-  79.100.IN-ADDR.ARPA
-  80.100.IN-ADDR.ARPA
-  81.100.IN-ADDR.ARPA
-  82.100.IN-ADDR.ARPA
-  83.100.IN-ADDR.ARPA
-  84.100.IN-ADDR.ARPA
-  85.100.IN-ADDR.ARPA
-  86.100.IN-ADDR.ARPA
-  87.100.IN-ADDR.ARPA
-  88.100.IN-ADDR.ARPA
-  89.100.IN-ADDR.ARPA
-  90.100.IN-ADDR.ARPA
-  91.100.IN-ADDR.ARPA
-  92.100.IN-ADDR.ARPA
-  93.100.IN-ADDR.ARPA
-  94.100.IN-ADDR.ARPA
-  95.100.IN-ADDR.ARPA
-  96.100.IN-ADDR.ARPA
-  97.100.IN-ADDR.ARPA
-  98.100.IN-ADDR.ARPA
-  99.100.IN-ADDR.ARPA
-  100.100.IN-ADDR.ARPA
-  101.100.IN-ADDR.ARPA
-  102.100.IN-ADDR.ARPA
-  103.100.IN-ADDR.ARPA
-  104.100.IN-ADDR.ARPA
-  105.100.IN-ADDR.ARPA
-  106.100.IN-ADDR.ARPA
-  107.100.IN-ADDR.ARPA
-  108.100.IN-ADDR.ARPA
-  109.100.IN-ADDR.ARPA
-  110.100.IN-ADDR.ARPA
-  111.100.IN-ADDR.ARPA
-  112.100.IN-ADDR.ARPA
-  113.100.IN-ADDR.ARPA
-  114.100.IN-ADDR.ARPA
-  115.100.IN-ADDR.ARPA
-  116.100.IN-ADDR.ARPA
-  117.100.IN-ADDR.ARPA
-  118.100.IN-ADDR.ARPA
-  119.100.IN-ADDR.ARPA
-  120.100.IN-ADDR.ARPA
-  121.100.IN-ADDR.ARPA
-  122.100.IN-ADDR.ARPA
-  123.100.IN-ADDR.ARPA
-  124.100.IN-ADDR.ARPA
-  125.100.IN-ADDR.ARPA
-  126.100.IN-ADDR.ARPA
-  127.100.IN-ADDR.ARPA
-  0.IN-ADDR.ARPA
-  127.IN-ADDR.ARPA
-  254.169.IN-ADDR.ARPA
-  2.0.192.IN-ADDR.ARPA
-  100.51.198.IN-ADDR.ARPA
-  113.0.203.IN-ADDR.ARPA
-  255.255.255.255.IN-ADDR.ARPA
-  0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.IP6.ARPA
-  1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.IP6.ARPA
-  8.B.D.0.1.0.0.2.IP6.ARPA
-  D.F.IP6.ARPA
-  8.E.F.IP6.ARPA
-  9.E.F.IP6.ARPA
-  A.E.F.IP6.ARPA
-  B.E.F.IP6.ARPA
-  EMPTY.AS112.ARPA
-  HOME.ARPA

可以在视图一级设置空区，并且只应用到IN类的视图。仅当没有在视图一级指定
被禁止的空区时，被禁止的空区才从全局选项继承。要重载被禁止区的全局选项
列表，需要在视图一级禁止根区，例如：

::

           disable-empty-zone ".";

如果使用这里所列的地址范围，应该已经有反向区来覆盖所用的地址。在实际中，
不会出现这样的情况，即许多请求发向基础的服务器来查找这个空间中的名字。在
实际情况中有太多这样的情况，需要部署牺牲服务器来将查询负载从基础服务器引
导出来。



.. note::

   在这些区的真实的上级服务器中，应该禁止其下的所有空区。对真正的根服务器，
   这都是内建空区。这使它们能够返回树中对更深一级的引用。

.. namedconf:statement:: empty-server
   :tags: server, zone
   :short: 指定对空区的返回SOA记录中的服务器名字。

   这个指定出现在空区的返回的SOA记录中的服务器名字。如果未指定，就使用区的名字。

.. namedconf:statement:: empty-contact
   :tags: server, zone
   :short: 指定对空区的返回SOA记录中的联系人名字。

   这个指定出现在空区的返回的SOA记录中的联系人名字。如果未指定，就使用“.”。

.. _empty-zones-enable:

.. namedconf:statement:: empty-zones-enable
   :tags: server, zone
   :short: 开启或关闭所有的空区。

   这个开启或关闭所有的空区。缺省是打开的。

.. _disable-empty-zone:

.. namedconf:statement:: disable-empty-zone
   :tags: server, zone
   :short: 关闭单独的空区。

   这个关闭单独的空区。缺省没有空区是关闭的。这个选项可以多次指定。

.. _content_filtering:

内容过滤
^^^^^^^^

.. namedconf:statement:: deny-answer-addresses
   :tags: query
   :short: 拒绝A或者AAAA记录，如果对应的IPv4或IPv6地址与给定的 :any:`address_match_list` 匹配。

   BIND 9提供了过滤来自外部DNS服务器的，在回答部份包含某种类型数据的响
   应的能力。特别地，如果相关的IPv4或IPv6地址与
   :any:`deny-answer-addresses` 选项中的 :term:`address_match_list` 相
   匹配，它可以拒绝地址（A或者AAAA）记录。
   
   在 :any:`deny-answer-addresses` 选项的 :term:`address_match_list`
   中，只有 :term:`ip_address` 和 :term:`netprefix` 是有意义的；任何
   :term:`server_key` 都被静默地忽略。

.. namedconf:statement:: deny-answer-aliases
   :tags: query
   :short: 拒绝CNAME或者DNAME记录，如果“别名”与一个给定的 :any:`domain_name` 列表匹配。

   它也可以拒绝CNAME或DNAME记录，如果“别名”（即CNAME别名或由于DNAME而
   被替换的请求名）与 :any:`deny-answer-aliases` 选项中的
   :term:`domain_name` 匹配时，这里所指的“匹配”表示别名是所列域名中一
   个元素的一个子域。如果使用 ``except-from`` 指定了可选的列表，请求
   名与列表匹配的记录也会被接受，而不考虑过滤设置。同样地，如果别名是
   相应区的一个子域， :any:`deny-answer-aliases` 过滤器也不会生效；例
   如，即使给 :any:`deny-answer-aliases` 指定了“example.com”，

   ::

      www.example.com. CNAME xxx.example.com.

   来自一个“example.com”服务器的响应会被接受。

如果一个响应消息因为过滤而被拒绝，整个消息将会被丢弃并且不会缓存，还
会返回一个SERVFAIL错误给客户端。

这个过滤器是为了阻止“DNS重绑定攻击”，在这种攻击中，攻击者对查询一个攻
击者所控制的域名的请求，返回一个用户自己网络内的IP地址或者一个用户自
己域内的一个别名。一个幼稚的网页浏览器或者脚本可能无意会充当代理，会
让攻击者访问局域网络中的内部节点，而这本不是外部所能够访问到的。关于
这些攻击更详细的内容参见
https://dl.acm.org/doi/10.1145/1315245.1315298 处的论文。

例如，拥有一个域名“example.net”并且内部网络使用192.0.2.0/24的IPv4前缀，
一个管理员可能设定如下规则：

::

   deny-answer-addresses { 192.0.2.0/24; } except-from { "example.net"; };
   deny-answer-aliases { "example.net"; };

如果一个外部攻击者让局域网内的一个网页浏览器查找“attacker.example.com”
的IPv4地址，攻击者的DNS服务器会返回一个在回答部份中有像这样记录的响应：

::

   attacker.example.com. A 192.0.2.1

由于这个记录（IPv4地址）的rdata与所设定的前缀192.0.2.0/24匹配，这个响应
将会被忽略。

另一方面，如果浏览器查找一个合法的内部web服务器“www.example.net”并且下
列响应被返回给BIND 9服务器：

::

   www.example.net. A 192.0.2.2

这个响应会被接受，因为属主名“www.example.net”与 ``except-from`` 元素的设
置“example.net”匹配。

注意这个本身并非真正是对DNS的攻击。实际上，一个“外部的”名字映射到“内部
的”IP地址或者来自一个视图点上的域名没有任何错误；它实际上可能被用作合法
目的，例如调试。由于这个映射表是由正确的属主所提供的，在DNS中检测这个映
射的目的是否合法是不可能的或者是没有意义的。“重绑定”攻击首先必须由使用
DNS的应用进行防护。然而，对一个大的站点，立即保护所有可能的应用是很困难
的。提供这个过滤特征仅仅是为了对这种运行环境有所帮助；通常是不鼓励打开
这个功能，除非没有其它的选择，并且攻击是一个现实的威胁。

如果在地址段127.0.0.0/8中使用这个选项，就需要特别小心。这些地址显然是“
内部的”地址，但是许多应用传统上依赖DNS将某些名字映射到这样的地址。过滤
掉虚假地包含这类地址的DNS记录可能会破坏这类应用。

.. _rpz:

响应策略区（RPZ）重写
^^^^^^^^^^^^^^^^^^^^^^^^

BIND 9包含了一个限制机制，它修改请求的DNS响应，类似于电子邮件中的反垃圾
邮件DNS拒绝名单。响应可以被修改成某个域名不存在（NXDOMAIN），某个域名的
IP地址不存在（NODATA），或者包含其它的IP地址或数据。

.. namedconf:statement:: response-policy
   :tags: server, query, zone, security
   :short: 为视图或在全局选项中指定响应策略区。

   响应策略区在视图中的 :any:`response-policy` 选项中命名，或者当视图
   中没有 :any:`response-policy` 选项时在全局选项中命名。响应策略区是
   普通的DNS区，包含资源记录集，在允许时可以进行普通的查询。通常最好使
   用某些规则限制那些请求，如： ``allow-query { localhost; };`` 。

   一个 :any:`response-policy` 选项可以支持多个策略区。为最大化性能，
   使用一个基数树来快速识别包含与当前查询匹配的触发器的响应策略区。这
   强制一个 :any:`response-policy` 选项中策略区的数量上限为64；超过那
   个数就是一个配置错误。

在响应策略区中编码的规则当其在 :ref:`access_control` 中被定义之后处理。
来自不被允许访问本解析器的客户端的所有请求都将得到带一个REFUSED状态码的
回复，而不管所配置的RPZ规则。

在RPZ记录中可以编码五种策略触发器。

``RPZ-CLIENT-IP``
   IP记录由DNS客户端的IP地址触发。客户端IP地址触发器被编码到的记录中，
   其属主名是 ``rpz-client-ip`` 的子域名，它相对于策略区原点名字，并编
   码一个地址或地址块。IPv4地址被表示为
   ``prefixlength.B4.B3.B2.B1.rpz-client-ip`` 。IPv4前缀长度必须在1和32
   之间。所有四个字节 - B4，B3，B2和B1 - 都必须出现。B4是IPv4地址中的最
   低字节的十进制数值，如同在IN-ADDR.ARPA中一样。

   IPv6被编码成类似于标准的IPv6文本表示格式，
   ``prefixlength.W8.W7.W6.W5.W4.W3.W2.W1.rpz-client-ip`` 。W8，...，W1
   中的每个都是一个一到四位的十六进制数，表示IPv6地址中的16位，如同IPv6
   地址的标准文本表示法，但是是反向表示的，如同IN6.ARPA中一样。（注意，
   这个IPv6地址表示是与IP6.ARPA中的每个16进制数字占据一个标记是不同的。
   ）所有的8个双字节都必须出现，除非一个连续值为零的双字节集合，后者被
   替换为 ``.zz.`` ，类似于标准IPv6文本编码中的双冒号（::）。IPv6前缀长
   度必须在1和128之间。

``QNAME``
   QNAME策略记录由请求中的请求名所触发，并且CNAME记录所指向的目标被解析
   用以生成响应。一个QNAME策略记录的属主名是与策略区相对的请求名。

``RPZ-IP``
   IP触发器是一个响应中ANSWER部份中的一个A或AAAA记录中的IP地址。它们被编
   码成类似客户端IP触发器，除了作为 ``rpz-ip`` 的子域名之外。

``RPZ-NSDNAME``
   NSDNAME触发器用权威服务器的名字去匹配请求名，一个请求名的父域，一个
   请求名的CNAME或者一个CNAME的父域。它们被编码成相对于RPZ原点的
   ``rpz-nsdname`` 的子域名。NSIP触发器匹配域名的A和AAAA资源记录集中的
   IP地址，而域名可以根据NSDNAME策略记录进行检查。 ``nsdname-enable``
   子句为单一策略区或所有策略区关闭或打开NSDNAME触发器。

   如果请求的名字的权威服务器还是未知， :iscman:`named` 在应用一条
   RPZ-NSDNAME规则之前会为这个请求名递归地查找权威服务器，这会导致一个
   处理延迟。为了以精度为代价加快处理速度，可以使用
   ``nsdname-wait-recurse`` 选项；当设置为 ``no`` ， RPZ-NSDNAME规则仅
   在请求名的权威服务器已经被查找过并且被缓存时才会应用。如果请求名的权
   威服务器不在缓存中，RPZ-NSDNAME规则会被忽略，但是请求名的权威服务器
   会在后端被查找，并且对随后的请求，这条规则会被应用。 缺省是
   ``yes`` ，意谓着RPZ-NSDNAME规则总是被应用，即使需要首先查找请求名的
   权威服务器。

``RPZ-NSIP``
   NSIP触发器匹配权威服务器的IP地址。他们被编码成类似IP触发器，除了作为
   ``rpz-nsip`` 的子域名之外。NSDNAME和NSIP触发器仅在名字至少带有
   ``min-ns-dots`` 个点时才被检查。 ``min-ns-dots`` 的缺省值是1，以排除
   顶级域。 ``nsip-enable`` 子句为单一策略区或所有策略区关闭或打开NSIP
   触发器。

   如果一个名字服务器的IP地址还是未知， :iscman:`named` 将在应用一条RPZ-NSIP
   规则之前递归查找这个IP地址，这会导致处理延迟。要以精确的成本来加速处
   理，可以使用 ``nsip-wait-recurse`` 选项：当设置为 ``no`` 时，
   RPZ-NSIP规则仅应用在一个名字服务器的IP地址已经被查找并缓存的情况。如
   果一个名字服务器的IP地址不在缓存中，RPZ-NSIP规则将被忽略，但地址将在
   后台被查找，这条规则将应用到后续的请求上。缺省是 ``yes`` ，表示
   RPZ-NSIP规则应该总是应用，即使一个地址需要先查找。

查询响应将与所有响应策略区进行比对，所以两条或多条策略记录可以被
一条响应所触发。由于DNS响应根据至多一条策略记录被重写，必须选择一
条策略编码一个动作（除 ``DISABLED`` 策略之外）。以下列顺序为重写
选择编码它们的触发器或记录：

1. 选择区中最先在response-policy选项中出现的触发器记录。
2. 在单个区中，按CLIENT-IP，QNAME，IP，NSDNAME，NSIP的顺序使用触发器。
3. 在NSDNAME触发器中，优先使用匹配DNSSEC顺序下最小名字的触发器。
4. 在IP或者NSIP触发器之间，优先选择具有最长前缀的触发器。
5. 在带有相同前缀长度的触发器之间，优先选择匹配最小IP地址的IP或NSIP触发器。

当一个响应的处理被重新开始解析DNAME或CNAME记录并且没有策略记录被
触发，所有的响应策略区被重新针对DNAME或者CNAME名字和地址查找。

RPZ记录集是除了DNAME或DNSSEC之外的任何类型的DNS记录，它编码了针对
请求的动作或响应。任何策略可以于任何触发器一起使用。例如，
``TCP-only`` 策略通常与 ``client-IP`` 触发器一起使用，但它也可以与
任意其它类型的触发器一起使用，并强制一个区中对属主名的响应使用TCP。

``PASSTHRU``
   自动接受策略由一个目标为 ``rpz-passthru`` 的CNAME所指定。它使响应
   不被重写，通常用于在CIDR块的策略中"挖出小洞"。

``DROP``
   自动拒绝策略由一个目标为 ``rpz-drop`` 的CNAME所指定。它使响应被丢
   弃。不发送任何响应给DNS客户端。

``TCP-Only``
   "滑动"策略由一个目标为 ``rpz-tcp-only`` 的CNAME所指定。它修改UDP
   响应为短小的、被截断的DNS响应，要求DNS客户端使用TCP重试。它用于缓
   解分布式DNS反射攻击。

``NXDOMAIN``
   “domain undefined”响应由一个目标为根域（.）的CNAME编码。


``NODATA``
   空白资源记录集由目标为通配顶级域（ ``*.`` ）的CNAME指定。它重写响应为
   NODATA或ANCOUNT=0。

``Local Data``
   一个由普通DNS记录所组成的集合可以用于回答请求。请求不在集合中的记
   录类型将会得到NODATA应答。

   本地数据的一个特殊形式是一条目标为一个通配符，如 \*.example.com，
   的CNAME。它通常被用作一个普通的CNAME，在星号（\*）被请求名替换之
   后。这个特殊形式被用于在围墙花园（原文：walled garden）内的权威
   DNS服务器上作请求日志。

在一个策略区中所有由全部单个记录指定的动作可以被 :any:`response-policy`
选项中的 ``policy`` 字句所覆盖。一个使用由另一个组织所提供的策略区的
组织可以使用这个机制来重定向域名到它自己的围墙花园。

``GIVEN``
   占位符策略表示"不覆盖但是执行区中所指定的动作。"

``DISABLED``
   测试覆盖策略导致策略区记录不做任何事情，但是记录在策略区未被关闭时
   可能做的事情。对DNS请求的应答会根据任何被触发的未被关闭的策略记录
   被重写（或不被重写）。关闭的策略区应放在最前面，因为如果一个更高优
   先级的触发器在前面时，它们通常都不会被记录。

``PASSTHRU``; ``DROP``; ``TCP-Only``; ``NXDOMAIN``; ``NODATA``
   这些设置都覆盖相应的每记录策略。

``CNAME domain``
   这个导致所有RPZ策略记录表现为好像它们是"cname domain"记录。

缺省时，在一个响应策略区中编码的动作仅应用到要求递归（RD=1）的请求。
这个缺省可以在一个视图中使用一条 ``recursive-only no`` 子句为一个策
略区或全部响应策略区而被改变。这个特性在下面的情况很有用，在一个
:rfc:`1918` 云的内部和外部有同样的区文件，并使用RPZ来删除外部可见的
名字服务器或视图上可能包含的 :rfc:`1918` 值。

同样缺省的是，RPZ动作仅应用于那些要么不要求DNSSEC元数据（DO=0），要
么在原始区中没有请求名的DNSSEC记录的DNS请求中。这个缺省可以在一个视
图中使用 ``break-dnssec yes`` 子句而对所有响应策略区被改变。在这种
情况下，RPZ动作被应用而不考虑DNSSEC。子句选项的名字反映了被RPZ动作
所重写的结果不能被验证的事实。

对一个QNAME或Client-IP触发器，不需要DNS记录；名字或者IP地址自身就已
足够，所以原则上请求名不需要被递归解析。但是，不解析请求名可能泄漏
使用了策略区重写和名字被列入一个策略区的事实给所列名字的服务器的操
作者。为阻止这个信息泄漏，缺省时一个请求所需的任何递归查询都在任何
策略触发器被考虑之前完成。因为列出的域名通常有较慢的权威服务器，这
个行为可能花费大量时间。当递归查询不能改变一个非错误响应时，
``qname-wait-recurse no`` 选项覆盖缺省并开启这个行为。这个选项不影
响列在其它包含IP，NSIP和NSDNAME触发器的区之后的策略区中的QNAME或
client-IP触发器，因为那些（触发器）可能依赖在递归解析中会被发现的A，
AAAA和NS记录。它也不影响DNSSEC请求（DO=1），除非使用了
``break-dnssec yes`` ，因为响应会依赖解析中是否发现了RRSIG记录。使
用这个选项可能导致诸如出现SERVFAIL的错误响应被重写，由于没有递归查
询被完成，以发现权威服务器中的问题。

.. namedconf:statement:: dnsrps-enable
   :tags: server, security
   :short: 打开DNS响应策略服务（DNSRPS）接口。

   ``dnsrps-enable yes`` 选项打开DNS响应策略服务（DNSRPS）接口，如果它
   已经使用 ``configure --enable-dnsrps`` 编译进了 :iscman:`named` 。

.. namedconf:statement:: dnsrps-options
   :tags: server, security
   :short: 提供额外的RPZ配置设置，它会被传递给DNSRPS提供者库。

   这个块提供额外的RPZ配置设置，它会被传递给DNSRPS提供者库。在一个
   :any:`dnsrps-options` 串中的多个DNSRPS设置应当使用分号(;)分开。
   DNSRPS提供者库，librpz，被传递一个由 :any:`dnsrps-options` 文本组成
   的配置字符串，连接到从 :any:`response-policy` 语句所派生的设置。

   注意： :any:`dnsrps-options` 文本只能包含与具体DNSRPS提供者相关的配
   置设置。例如，来自Farsight Security的DNSRPS提供者使用的选项有
   ``dnsrpzd-conf`` ， ``dnsrpzd-sock`` 和 ``dnzrpzd-args`` （关于这些
   选项的详细信息，参见 ``librpz`` 文档）。其它RPZ配置设置也可以被包含
   进 :any:`dnsrps-options` ，但是如果 :iscman:`named` 通过设置
   :any:`dnsrps-enable` 为“no”而切换到传统的RPZ时，这些选项都会被忽略。

一个被RPZ策略所修改的记录的TTL根据策略区中相关记录的TTL来设置。它被
限制为一个最大值。 ``max-policy-ttl`` 子句从其缺省值5改变最大值秒数。
为方便起见，TTL风格的时间单位后缀也可用于指定这个值。它也接受ISO 8601
的持续时间格式。

例如，一个管理员可能使用这个选项语句：

::

       response-policy { zone "badlist"; };

和这个区语句：

::

       zone "badlist" {type primary; file "primary/badlist"; allow-query {none;}; };

以及这个区文件：

::

   $TTL 1H
   @                       SOA LOCALHOST. named-mgr.example.com (1 1h 15m 30d 2h)
               NS  LOCALHOST.

   ; QNAME policy records.  There are no periods (.) after the owner names.
   nxdomain.domain.com     CNAME   .               ; NXDOMAIN policy
   *.nxdomain.domain.com   CNAME   .               ; NXDOMAIN policy
   nodata.domain.com       CNAME   *.              ; NODATA policy
   *.nodata.domain.com     CNAME   *.              ; NODATA policy
   bad.domain.com          A       10.0.0.1        ; redirect to a walled garden
               AAAA    2001:2::1
   bzone.domain.com        CNAME   garden.example.com.

   ; do not rewrite (PASSTHRU) OK.DOMAIN.COM
   ok.domain.com           CNAME   rpz-passthru.

   ; redirect x.bzone.domain.com to x.bzone.domain.com.garden.example.com
   *.bzone.domain.com      CNAME   *.garden.example.com.

   ; IP policy records that rewrite all responses containing A records in 127/8
   ;       except 127.0.0.1
   8.0.0.0.127.rpz-ip      CNAME   .
   32.1.0.0.127.rpz-ip     CNAME   rpz-passthru.

   ; NSDNAME and NSIP policy records
   ns.domain.com.rpz-nsdname   CNAME   .
   48.zz.2.2001.rpz-nsip       CNAME   .

   ; auto-reject and auto-accept some DNS clients
   112.zz.2001.rpz-client-ip    CNAME   rpz-drop.
   8.0.0.0.127.rpz-client-ip    CNAME   rpz-drop.

   ; force some DNS clients and responses in the example.com zone to TCP
   16.0.0.1.10.rpz-client-ip   CNAME   rpz-tcp-only.
   example.com                 CNAME   rpz-tcp-only.
   *.example.com               CNAME   rpz-tcp-only.

RPZ会影响服务器性能。每个已配置的响应策略区都会使一个请求被回答前要
求服务器执行一到四次额外的数据库查找。例如，一个DNS服务器有四个策略
区，每个有四种类型的响应触发器（QNAME，IP，NSIP和NSDNAME），会要求
进行相当于一个没有响应策略区的普通DNS服务器17倍的数据库查找。一个
BIND9服务器，带有足够内存和一个带QNAME和IP触发器的响应策略区可能比
最大每秒请求数(queries-per-second, QPS)下降约20%。一个有四个带QNAME和
IP触发器的响应策略区的服务器可能比最大QPS下降约50%。

由RPZ所重写的响应在 ``RPZRewrites`` 统计中被计数。

可以使用 ``log`` 子句来选择性关闭对某个特定响应策略区的重写日志。缺
省时，所有重写都被记录到日志。

``add-soa`` 选项控制是否将RPZ的SOA记录添加到用于从该区追踪变化的部
份中。这个可以在单独的策略区级别或者在响应策略级别设置。缺省是
``yes`` 。

对RPZ区的更新是异步处理的；如果存在多个更新，它们会被捆绑在一起。如
果一个对RPZ区的更新（例如，通过IXFR）在最近的更新之后还不到
``min-update-interval`` 秒，这个改变就不会被执行，直到这个间隔时间
之后。缺省是 ``60`` 秒。为方便起见，TTL风格的时间单位后缀也可用于指
定这个值。它也接受 ISO 8601 的持续时间格式。

.. _rrl:

响应比率限制
^^^^^^^^^^^^

.. namedconf:statement:: rate-limit
   :tags: query
   :short: 控制过多的UDP响应，阻止BIND 9被用于放大反射拒绝服务（DoS）攻击。

   过多的，几乎同样的UDP **响应** 可以通过在一个
   :namedconf:ref:`options` 或 :any:`view` 语句中配置
   :any:`rate-limit` 子句来控制。这个机制使权威的BIND 9免于被用于放大
   反射拒绝服务（DoS）攻击。可以通过发送短小的BADCOOKIE错误或者截断的
   （TC=1）响应来提供按比率限制的响应给位于一个伪造的、受攻击的IP地址
   范围中的合法客户端。合法客户端对丢弃响应的反应是重试，对BADCOOKIE错
   误的反应是包含一个服务器cookie重试，而对截断响应的反应是切换为TCP。

   这个机制目的是用于权威DNS服务器。它也可以用于递归服务器，但会减慢诸
   如SMTP服务器（邮件接收者）和HTTP客户端（web浏览器）这些反复请求同一
   个域的应用。在可能情况下，关闭“公开”递归服务器是更好的选择。

   响应比率限制使用一个“信用（credit）”或“代价桶（token bucket）”方案。
   每个同一响应和客户端的组合有一个概念上的“帐号”，会每秒挣得一个特定
   数目的信用值。一个预期的的响应将会从其帐号上减一。当帐号是负值时，
   响应将被丢弃或者被截断。
   
   .. namedconf:statement:: window
      :tags: query
      :short: 指定响应被追踪的时间长度。
   
      响应在一个缺省值为15秒的时间轮转窗口中被跟踪，窗口大小可以使用
      :any:`window` 选项配置为从1到3600秒（1小时）之间的任意值。帐号不
      能大于每秒限制值或者小于 :any:`window` 乘以每秒限制值。当一类响
      应的指定信用值被设为0，这些响应没有比率限制。

   .. namedconf:statement:: ipv4-prefix-length
      :tags: server
      :short: 指定IPv4地址块的前缀长度。

   .. namedconf:statement:: ipv6-prefix-length
      :tags: server
      :short: 指定IPv6地址块的前缀长度。

      对比率限制中的“同一响应（identical response）”和“DNS客户端”的概
      念是不能简单化理解的。所有到一个地址块的响应被统计为如同到一个单
      一地址。地址块的前缀长度由 :any:`ipv4-prefix-length` （缺省24）
      和 :any:`ipv6-prefix-length` （缺省56）指定。

   .. namedconf:statement:: responses-per-second
      :tags: query
      :short: 限制针对一个有效域名和记录类型的非空响应的数量。

      所有针对一个有效域名（qname）和记录类型（qtype）的非空响应都是相
      同的，有一个由 :any:`responses-per-second` 指定的限制(缺省为0或
      没有限制)。所有有效的通配域名被解释为区的原始名字拼接到“*”名字。

   .. namedconf:statement:: nodata-per-second
      :tags: query
      :short: 限制针对一个有效域名的空（NODATA）响应的数量。

      所有针对一个有效域名，不管其请求类型的空（NODATA）响应也是相同的。
      NODATA这一类响应被 :any:`nodata-per-second` 所限制（缺省是
      :any:`responses-per-second` ）。

   .. namedconf:statement:: nxdomains-per-second
      :tags: query
      :short: 限制针对一个有效域名的未定义子域的数量。

      对一个给定的有效域名的任何及所有未定义的子域的请求而产生的
      NXDOMAIN错误，不考虑请求类型，都是同一的。它们由
      :any:`nxdomains-per-second` 限制（缺省是
      :any:`responses-per-second` ）。这控制某些使用随机域名的攻击，但
      能够在期望许多合法NXDOMAIN响应的服务器上被放松或关闭（设置为0），
      例如来自反垃圾拒绝名单。
      
   .. namedconf:statement:: referrals-per-second
      :tags: query
      :short: 限制针对一个给定域的指引或授权到一个服务器的数量。
      
      指向或授权到一个给定域名的服务器都是同一的并可以被
      :any:`referrals-per-second` 所限制（缺省是
      :any:`responses-per-second` ）。

   由本地通配符产生的响应被计数并限制，如同对于其父域名一样。这使用
   random.wild.example.com控制泛洪。

   所有导致DNS错误，例如SERVFAIL和FORMERR，而不是NXDOMAIN的请求都是相同的，
   而不考虑请求名（qname）或记录类型（qtype）。这控制使用无效请求或使用陌
   生、缺陷权威服务器的攻击。

   .. namedconf:statement:: errors-per-second
      :tags: server
      :short: 限制针对一个有效域名和记录类型的错误的数量。
   
      缺省时，对错误的限制与 :any:`responses-per-second` 值一致，但它
      也可以被独立地使用 :any:`errors-per-second` 设置。

   .. namedconf:statement:: slip
      :tags: query
      :short: 设置“滑动”响应的数量，以尽量减少使用伪造源地址进行攻击。

      许多利用DNS的攻击涉及伪造源地址的UDP请求。比率限制阻止利用BIND 9
      由于对伪造源地址请求的响应而对一个网络进行泛洪攻击，但是可以让一
      个第三方阻塞对合法请求响应。有一个机制可以回复一些来自一个其地址
      被伪造而用于泛洪攻击的客户端的合法请求。设置 :any:`slip` 为2（其
      缺省值）将使每隔一个不带有效服务器cookie的UDP请求在回复时带有一
      个短小的、截断的响应。“滑动的”响应的小尺寸和低频率，导致缺乏放大
      效应，使其对反射DoS攻击没有吸引力。 :any:`slip` 必须介于0到10之
      间。值为0表示不“滑动”；由于比率限制而不发出短小的响应。所有响应
      都被丢弃。值为1使每个响应都滑动；值为2到10之间使每N个响应一次。

      如果请求包含了一个客户端cookie，“滑动的”响应为一个BADCOOKIE错误
      并带有一个服务器cookie，这允许合法客户端包含服务器cookie，从而在
      重试请求时免受速率限制。
      如果请求不包含一个客户端cookie，“滑动的”响应为一个截断的（TC=1）
      响应，它提示一个合法客户端切换到TCP，因而免受速率限制。一些错误
      响应，包括REFUSE和SERVFAIL，不能被替代成截断的响应，而是以
      :any:`slip` 比率返回响应。

      （注意：从一个权威服务器丢弃响应可能减小一个第三方成功伪造响应到
      一个递归解析器的难度。针对伪造响应的最安全方法，对权威服务器的操
      作者而言是使用DNSSEC签名自己的区，对递归服务器的操作者而言是验证
      响应。当这不是一个可选项时，对更关心响应完整性而不是缓解泛洪攻击
      的操作者，可以考虑设置 :any:`slip` 为1，将使所有比率限制响应都被
      截断而不是被丢弃。这就减小了针对反射攻击的比率限制的效果。）

   .. namedconf:statement:: qps-scale
      :tags: query
      :short: 通过降低当前每秒查询速率的比例，加强对DNS攻击的防御。

      当大致的每秒请求率超过了 :any:`qps-scale` 值，
      :any:`responses-per-second` ， :any:`errors-per-second` ，
      :any:`nxdomains-per-second` 和 :any:`all-per-second` 的值就减小
      一个比率，即当前比率比 :any:`qps-scale` 的值。这个特性可以在攻击
      时增强抵抗能力。例如，设置
      ``qps-scale 250; responses-per-second 20;`` 并且一个包含TCP的所
      有DNS客户端的所有请求的总请求率为1000次请求/秒，这时的
      '有效响应/秒'限制变为(250/1000)*20，或5。在请求中包含了一个有效
      服务器cookie的响应，和通过TCP发送的响应不会被限制，但是会被计数，
      以计算每秒请求率。

   .. namedconf:statement:: exempt-clients
      :tags: query
      :short: 免除特定客户或客户组的比率限制。

      DNS客户端社区可以给出其自身的参数，或完全没有比率限制，即将
      :any:`rate-limit` 语句放入 :any:`view` 语句中而不是全局
      ``option`` 语句中。一个视图中的 :any:`rate-limit` 语句是替代而不
      是增补了主配置中的 :any:`rate-limit` 语句。
     
      在一个视图中的DNS客户端可以通过 :any:`exempt-clients` 子句免除比
      率限制。

   .. namedconf:statement:: all-per-second
      :tags: query
      :short: 限制所有种类的UDP响应。

      所有类型的UDP响应可以由 :any:`all-per-second` 短句限制。这个比率
      限制不同于在一个DNS服务器上由 :any:`responses-per-second` ，
      :any:`errors-per-second` 和 :any:`nxdomains-per-second` 所提供的
      比率限制，后者通常都是DNS反射攻击的受害者所看不到的。除非攻击者
      伪造的请求与受害者的合法请求完全一致，受害者的请求是不受影响的。
      受一个 :any:`all-per-second` 限制影响的响应总是被丢弃；
      :any:`slip` 值没有任何效果。一个 :any:`all-per-second` 限制至少
      是其它限制的4倍大，因为单一的DNS客户端通常爆发出合法的请求。例如，
      在考虑到进入的SMTP/TCP/IP连接时，单个邮件消息的接收者可能产生来
      自一个SMTP服务器的对NS，PTR，A和AAAA记录的请求。这个SMTP服务器在
      它考虑SMTP的 ``Mail From`` 命令时，可能需要额外的NS，A，AAAA，
      MX，TXT和SPF记录。Web浏览器通常重复地解析在一页的HTML <IMG>标签
      中重复出现的同样名字。 :any:`all-per-second` 类似于防火墙所提供
      的比率限制，但通常不如后者。忽略DNS响应内容的攻击更像是对服务器
      本身的攻击。它们通常应该在DNS服务器花费资源建立TCP连接或分析DNS
      请求之前被丢弃，但是比率限制必须在DNS服务器见到请求之前完成。

   .. namedconf:statement:: max-table-size
      :tags: server
      :short: 设置用于追踪请求和比率限制响应的表的最大大小。

   .. namedconf:statement:: min-table-size
      :tags: query
      :short: 设置用于追踪请求和比率限制响应的表的最小大小。

      用于跟踪请求和比率限制响应的表的最大大小，通过
      :any:`max-table-size` 设置。表中每个条目介于40到80字节之间。表中
      需要的条目数大致是每秒收到的请求数。缺省是20,000。为减小冷启动时
      的表增长， :any:`min-table-size` （缺省是500）可以设置最小的表大
      小。打开 :any:`rate-limit` 类日志以监控表的增长并获取关于选择表
      大小初始值和最大值的信息。

   .. namedconf:statement:: log-only
      :tags: logging, query
      :short: 测试比率限制参数，并不实际丢弃任何请求。

      使用 ``log-only yes`` 测试比率限制参数而不会实际丢掉任何请求。

   被比率限制所丢弃的响应被包含在 ``RateDropped`` 和 ``QryDropped`` 统
   计中。被比率限制所截断的响应被包含在 ``RateSlipped`` 和
   ``RespTruncated`` 统计中。

NXDOMAIN重定向
^^^^^^^^^^^^^^^^

:iscman:`named` 通过两个方法支持NXDOMAIN重定向：

-  重定向区 (:ref:`zone_statement_grammar`)
-  重定向名字空间
	      
在这两种方法中，当 :iscman:`named` 收到一条NXDOMAIN响应，它检查一个独立的名
字空间以查看NXDOMAIN响应是否应该被替换为替代的响应。

在一个重定向区（ ``zone "." { type redirect; };`` ），用于替换
NXDOMAIN的数据保存在一个单独的区中，它不是通常的名字空间的一部分。所
有重定向信息都存放在这个区中；其中没有授权。

.. namedconf:statement:: nxdomain-redirect
   :tags: query
   :short: 当使用一个重定向名字空间替代一个NXDOMAIN时，为原始的查询名附加指定的后缀。

   在一个重定向名字空间（ ``option { nxdomain-redirect <suffix> };``
   ），用于替换NXDOMAIN的数据是普通名字空间的一部份，通过在原始请求名
   后添加指定的后缀来查找。这大致使所需的缓存增加一倍，以处理NXDOMAIN
   响应，因为原始的NXDOMAIN响应和替代数据（或者一个NXDOMAIN指示不存在
   替代者）都必须存储。

如果一个重定向区和一个重定向名字空间都被配置了，首先试探重定向区。

.. _server_statement_grammar:

``server`` 块语法
~~~~~~~~~~~~~~~~~
.. namedconf:statement:: server
   :tags: server
   :short: 定义与一个远程名字服务器相关的特性。

.. _server_statement_definition_and_usage:

``server`` 块定义和用法
~~~~~~~~~~~~~~~~~~~~~~~

:namedconf:ref:`server` 语句定义与一个远程名字服务器相关的特性。如果指
定一个前缀长度，就覆盖一个范围的服务器。只有最特定的server子句应用，不
考虑在 :iscman:`named.conf` 中的顺序。

:rndcconf:ref:`server` 语句可以出现在配置文件的顶级，也可以在一个
:any:`view` 语句中。如果一个 :any:`view` 语句中包含一个或多个
:namedconf:ref:`server` 语句时，只有这些会应用到视图中，而任何顶级的都
被忽略。如果一个视图不包含 :namedconf:ref:`server` 语句，任何顶级
:namedconf:ref:`server` 语句都作为缺省使用。

.. namedconf:statement:: bogus
   :tags: server
   :short: 允许忽略一个远程服务器。

   如果一个远程服务器发出错误的数据，将其标志为bogus而阻止再发请求给它。
   :any:`bogus` 的缺省值是 ``no`` 。

.. namedconf:statement:: edns
   :tags: server
   :short: 控制EDNS0（ :rfc:`2671` ）特性的使用。

   :any:`edns` 子句决定在与远程服务器通信时，是否试图使用EDNS。缺省是
   ``yes`` 。

.. namedconf:statement:: edns-version
   :tags: server
   :short: 设置被解析器发送给服务器的最大EDNS VERSION。

   :any:`edns-version` 选项设置解析器能够发送给服务器的最大
   EDNS VERSION。实际发送的EDNS版本仍然服从通常的EDNS版本协商规则（参
   见 :rfc:`6891` ），服务器所支持的最大EDNS版本，以及其它线索指示的一
   个更低版本应被发送。这个选项的意图是用于一个远程服务器对一个给定的
   EDNS版本或更高版本反应错误时；它应该被设置为远程服务器为外界所知的
   能够支持的最高版本。有效值是0到255；更大的值将被静默地调整。这个选
   项在比0更高的EDNS版本被使用之前将不需要。

.. namedconf:statement:: padding
   :tags: server
   :short: 给输出消息添加EDNS填充选项，以增加包大小。

   这个选项为发出的消息增加EDNS填充选项，增加包的大小到一个指定块大小
   的倍数。有效块大小范围从0（缺省值，它关闭使用ENS填充）到512字节。更
   大的值将被缩减成512，并在日志中记录告警。注意：这个选项当前不兼容于
   TSIG或SIG(0)，因为包含填充的EDNS OPT记录必须被添加到已经被签名的包
   中。

.. namedconf:statement:: tcp-only
   :tags: server
   :short: 设置传输协议为TCP。

   这个选项设置传输协议为TCP。缺省是使用UDP传输，并仅在收到一个截断响
   应时回退到TCP。

.. namedconf:statement:: tcp-keepalive
   :tags: server
   :short: 添加EDNS TCP keepalive到经过TCP发送的消息。

   这个选项添加EDNS TCP keepalive到经过TCP发送的消息。注意当前响应中的
   空闲超时被忽略。

.. namedconf:statement:: transfers
   :tags: server
   :short: 限制从一台服务器入向并发区传送的数目。

   :any:`transfers` 用于限制从指定的服务器入向并发区传送的数目。如果
   没有设定 :any:`transfers` 子句，就根据 :any:`transfers-per-ns` 选项
   设定限制。

.. namedconf:statement:: keys
   :tags: server, security
   :short: 指定一个或多个用于一台远程服务器的 :any:`server_key` 。

   :suppress_grammar:

   .. warning::
      不要与 :any:`dnssec-policy` 规范中的 :any:`keys` 混淆。尽管在两
      个上下文中都存在名称相同的语句，但它们指的是根本不兼容的概念。

   在一个 :namedconf:ref:`server` 块的上下文中，标识一个由
   :namedconf:ref:`key` 语句所定义的 :term:`server_key` 的选项，在与远
   程服务器通讯时，用于事务安全（参见 :ref:`tsig` ）。当一个请求发向远
   程服务器时，就使用这里所指定的key来生成一个请求签名并将其添加到消息
   尾部。一个源自远程服务器的请求不要求被这个key签名。

   当前只支持每个服务器一个key。

在 :namedconf:ref:`view` 和 :namedconf:ref:`options` 块中定义的下列值
可能被覆盖：

   - :namedconf:ref:`edns-udp-size`
   - :namedconf:ref:`max-udp-size`
   - :namedconf:ref:`notify-source-v6`
   - :namedconf:ref:`notify-source`
   - :namedconf:ref:`provide-ixfr`
   - :namedconf:ref:`query-source-v6`
   - :namedconf:ref:`query-source`
   - :namedconf:ref:`request-expire`
   - :namedconf:ref:`request-ixfr`
   - :namedconf:ref:`request-nsid`
   - :namedconf:ref:`send-cookie`
   - :namedconf:ref:`transfer-format`
   - :namedconf:ref:`transfer-source-v6`
   - :namedconf:ref:`transfer-source`

.. _statschannels:

:any:`statistics-channels` 块语法
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.. namedconf:statement:: statistics-channels
   :tags: logging
   :short: 指定系统管理员访问名字服务器上的统计信息时使用的通信通道。

.. _statistics_channels:

:any:`statistics-channels` 块定义和用法
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:any:`statistics-channels` 语句声明了系统管理员用来获取名字服务器上面
统计信息的通信通道。

这个语句是打算在将来能够灵活地支持多个通信协议，但是当前只支持HTTP访问。
它要求带有libxml2和/或json-c（也被称为libjson0）编译BIND 9；即使在编译
时没有提供库， :any:`statistics-channels` 语句也被接受，但是任何HTTP访问
都会失败并返回一个错误。

一个 :any:`inet` 控制通道是一个监听在特定 :term:`ip_address` ，可以是
一个IPv4或IPv6地址，上的特定 :term:`port` 的TCP套接字，一个为 ``*`` （
星号）的 :term:`ip_address` 将被解释为IPv4通配地址；到系统的任何IPv4地
址的连接都会被接受。要监听在IPv6的通配地址，使用为 ``::`` 的
:term:`ip_address` 。

如果没有指定端口，端口80用于HTTP通道。星号（ ``*`` ）不能用作
:term:`port` 。

打开一个统计通道的企图被可选的 ``allow`` 子句所限制。到统计通道的连接
基于 :term:`address_match_list` 而允许。如果没有提供 ``allow`` 子句，
:iscman:`named` 接受任何地址来的连接企图；由于统计可能包含敏感的内部信
息，强烈推荐正确地限制连接源。

如果没有提供 :any:`statistics-channels` 语句， :iscman:`named` 将不会
打开任何通信通道。

统计以不同格式和视图提供，依赖于访问它们所使用的URI。例如，如果配置了
统计通道并监听在127.0.0.1的8888端口，就可以以XML格式在
http://127.0.0.1:8888/或http://127.0.0.1:8888/xml访问统计。引入一个CSS
文件，在使用一个样式表兼容的浏览器查看时，可以将XML统计转换格式为表格，
在使用一个支持javascript的浏览器查看时，可以使用Google Charts API将其
转换格式为图表和图形。

统计的单独子项可以在下列位置查看 http://127.0.0.1:8888/xml/v3/status
（服务器运行时间和上次修改配置时间），
http://127.0.0.1:8888/xml/v3/server（服务器和解析器统计），
http://127.0.0.1:8888/xml/v3/zones（区统计），
http://127.0.0.1:8888/xml/v3/net（网络状态和套接字统计），
http://127.0.0.1:8888/xml/v3/mem（内存管理统计），
http://127.0.0.1:8888/xml/v3/tasks（任务管理统计）和
http://127.0.0.1:8888/xml/v3/traffic（流量大小）。

也可以JSON格式读取完整的统计集合http://127.0.0.1:8888/json,
在下列位置查看单独子项http://127.0.0.1:8888/json/v1/status
（服务器运行时间和上次修改配置时间），
http://127.0.0.1:8888/json/v1/server（服务器和解析器统计），
http://127.0.0.1:8888/json/v1/zones（区统计），
http://127.0.0.1:8888/json/v1/net（网络状态和套接字统计），
http://127.0.0.1:8888/json/v1/mem（内存管理统计），
http://127.0.0.1:8888/json/v1/tasks（任务管理统计）和
http://127.0.0.1:8888/json/v1/traffic（流量大小）。

:any:`tls` 块语法
~~~~~~~~~~~~~~~~~
.. namedconf:statement:: tls
   :tags: logging
   :short: 配置一个TLS连接。

:any:`tls` 块定义和用法
~~~~~~~~~~~~~~~~~~~~~~~

:any:`tls` 语句用于配置一个TLS连接；这个配置随后可以被一条
:any:`listen-on` 或 :any:`listen-on-v6` 语句引用，而使 :iscman:`named`
监听经由TLS而进入的请求，或在 :any:`primaries` 语句中为一个
:any:`type secondary` 类型的区而引用，使区传送请求经由TLS发送。

:any:`tls` 只能设置在 :iscman:`named.conf` 的顶层。

一个 :any:`tls` 语句中可以指定下列选项：

.. namedconf:statement:: key-file
   :tags: server, security
   :short: 指定包含用于一个连接的TLS私钥的文件路径。

    包含用于连接的TLS私钥的文件路径。

.. namedconf:statement:: cert-file
   :tags: server, security
   :short: 指定包含用于一个连接的TLS证书的文件路径。

    包含用于连接的TLS证书的文件路径。

.. namedconf:statement:: ca-file
   :tags: server, security
   :short: 指定包含受信任CA中心的TLS证书的文件的路径，用于验证远程对端证书。

    一个包含受信任CA中心的TLS证书，用于验证远程对端证书的文件的路径。指
    定这个选项开启对远程对端证书的验证。对于入向连接，指定这个选项将
    使BIND要求一个来自客户端的有效TLS证书。在出向连接的情况，如果未指
    定 :any:`remote-hostname` ，就使用远程服务器IP地址作为替代。

.. namedconf:statement:: dhparam-file
   :tags: server, security
   :short: 指定包含Diffie-Hellman参数的文件路径，用于开启加密套件。

    包含Diffie-Hellman参数的文件路径，这些参数用于开启依赖
    Diffie-Hellman临时密钥交换（DHE）的密码套件。指定这些参数对于在
    TLSv1.2中启用具有完全前向保密能力的密码至关重要。

.. namedconf:statement:: remote-hostname
   :tags: security
   :short: 指定期望的远程服务器的TLS证书中的主机名。

    期望的远程服务器的TLS证书中的主机名。这个选项开启一个远程服务器证
    书验证。如果未指定 :any:`ca-file` ，就使用平台专用的证书仓库进行验证。
    仅当连接到一个远程对端时使用此选项，因此，当 :any:`listen-on` 或
    :any:`listen-on-v6` 语句引用 :any:`tls` 语句时，忽略该选项。

.. namedconf:statement:: protocols
   :tags: security
   :short: 指定允许的TLS协议版本。

    允许的TLS协议版本。支持TLS版本1.2及更高版本，依赖于所使用的加密库。
    可以指定多个版本（例如， ``protocols { TLSv1.2; TLSv1.3; };`` ）。

.. namedconf:statement:: ciphers
   :tags: security
   :short: 指定允许的密码列表。

    密码列表，它定义了允许的密码，例如
    ``HIGH:!aNULL:!MD5:!SHA1:!SHA256:!SHA384`` 。这个字符串必须根据
    OpenSSL文档（参见
    https://www.openssl.org/docs/man1.1.1/man1/ciphers.html 以获取详细
    信息）中指定的规则来形成。

.. namedconf:statement:: prefer-server-ciphers
   :tags: server, security
   :short: 指定服务器密码应该优先于客户端密码。

    指定服务器密码应该优先于客户端密码。

.. namedconf:statement:: session-tickets
   :tags: security
   :short: 通过TLS会话单据启用或禁用会话恢复。

    通过TLS会话单据启用或禁用会话恢复，定义在RFC5077中。在需要前向保密
    的情况下，或者计划跨多个BIND实例使用TLS证书和密钥对时，可能需要禁用
    无状态会话单据。

.. warning::

   TLS配置可能会发生变化，将来可能会引入不兼容的变化。我们鼓励TLS用户在
   升级时仔细阅读发布说明。

上述选项用于控制TLS功能的各个方面。它们没有明确定义的缺省值，因为这些依
赖于使用的密码库版本和系统范围的密码策略。另一方面，通过指定所需的选
项，可以在一系列平台上部署统一的配置。

下面是一个面向隐私，启用了完美前向保密的配置示例。它可以作为一个起点。

::

   tls local-tls {
       key-file "/path/to/key.pem";
       cert-file "/path/to/fullchain_cert.pem";
       dhparam-file "/path/to/dhparam.pem";
       ciphers "HIGH:!kRSA:!aNULL:!eNULL:!RC4:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS:!SHA1:!SHA256:!SHA384";
       prefer-server-ciphers yes;
       session-tickets no;
   };

使用OpenSSL可以生成一个Diffie-Hellman参数文件，如下所示：

::

   openssl dhparam -out /path/to/dhparam.pem <3072_or_4096>

确保它是在一台具有来自外部源的足够熵的机器上生成的（例如，你工作的计算
机应该是满足条件的，而远程虚拟机或服务器可能不是）。这些文件不包含任何
敏感数据，如果需要，可以共享。

有两个内置的TLS连接配置： ``ephemeral`` ，仅为当前的 :iscman:`named` 会话创建
一个临时的密钥和证书，和 ``none`` ，它用于设置一个不加密的HTTP监听者。

BIND支持在 RFC 9103，第9.3部份中所描述的下列认证机制：
Opportunistic TLS, Strict TLS, and Mutual TLS.

.. _opportunistic-tls:

Opportunistic TLS 为数据提供加密但不为通道提供任何认证。此模式是缺省模
式，当使用的 :any:`tls` 语句中没有设置 :any:`remote-hostname` 和 :any:`ca-file`
选项时，就使用此模式。当TLS不可用时，RFC 9103允许可选的回退到明文DNS。
不过，为了防止由于错误配置而导致的意外数据泄漏，BIND有意不支持这种方法。
BIND及其补充工具要么在被指示时通过TLS成功建立一个安全通道，要么无法建
立连接。

.. _strict-tls:

Strict TLS 通过一个预定义的主机名为出向连接提个服务器认证。这个机制提
供了通道机密性和（服务器的）通道认证。为了实现 Strict TLS，需要在用于
建立出向连接（例如，用于通过TLS从主服务器下载区的连接）的 :any:`tls` 语句
中使用 :any:`remote-hostname` 选项以及可选的 :any:`ca-file` 选项。提供任何已
提到的选项都会开启服务器认证。如果提供了 :any:`remote-hostname` 而没有
:any:`ca-file` ，将使用平台专用的证书权威证书来认证。该集合大致对应于使用
WEB浏览器认证HTTPS主机的集合。在另一方面，如果提供了 :any:`ca-file` 而没
有 :any:`remote-hostname` ，则使用远端的IP地址来替代。

.. _mutual-tls:

Mutual TLS 是一个 Strict TLS 的扩展，它提供了通道机密性和相互通道认证。
它建立在客户端提供客户端证书的基础上，当建立连接时，客户端进行服务器身
份验证，就像在 Strict TLS 的情况下一样。服务器验证所提供的客户端证书，
并在成功验证时接受TLS连接，否则拒绝连接。为了指示服务器要求并验证客户
端TLS证书，需要在用于配置服务器监听器的 :any:`tls` 配置中指定 :any:`ca-file`
选项。所提供的文件必须包含用于发放客户端证书的证书权威证书。在大多数情
况，应该建立自己的TLS证书权威专门用于颁发客户端证书，并将证书权威证书
包含到文件中。

对于TLS上的认证区传送，Mutual TLS 可能被考虑是一个独立的解决方案，而
Strict TLS与基于TSIG认证的配合，或者作为可选的，与基于IP的访问列表的
配合可能被认为是大多数实际应用能够接受的。Mutual TLS具有不需要TSIG的
优势，因而没有与共享密码相关的安全问题。

:any:`http` 块语法
~~~~~~~~~~~~~~~~~~
.. namedconf:statement:: http
   :tags: server, query
   :short: 配置HTTP端点，在其上监听DNS-over-HTTPS（DoH）查询。

:any:`http` 块定义和用法
~~~~~~~~~~~~~~~~~~~~~~~~

:any:`http` 语句用于配置HTTP端点，在其上监听DNS-over-HTTPS (DoH)查询。
这个配置随后被一条 :any:`listen-on` 或 :any:`listen-on-v6` 语句引用，
而使 :iscman:`named` 监听经由HTTPS而进入的请求。

:any:`http` 只能设置在 :iscman:`named.conf` 的顶层。

一个 :any:`http` 语句中可以指定下列选项：

.. namedconf:statement:: endpoints
   :tags: server, query
   :short: 指定一个监听HTTP请求的路径的列表。

    一个监听HTTP请求的路径的列表。这是一个兼容 :rfc:`3986` 的URI的主机
    名后的部份；它必须是一个绝对路径，以“/”开始。如果省略，缺省值是
    ``"/dns-query"`` 。

.. namedconf:statement:: listener-clients
   :tags: server, query
   :short: 为活动连接指定每个监听者的配额。

    这个选项为活动连接指定每个监听者的配额。

.. namedconf:statement:: streams-per-connection
   :tags: server, query
   :short: 指定在一个HTTP/2连接上的并发HTTP/2流的最大数目。

    这个选项指定在一个HTTP/2连接上的并发HTTP/2流数目的硬限制。

上述任何选项都可省略。在这种情况，使用 :namedconf:ref:`options` 语句中所指定的全局值
（参见 :any:`http-listener-clients` ， :any:`http-streams-per-connection` ）。

例如，下列配置在所有本地地址上开启DNS-over-HTTPS请求：

::

   http local {
       endpoints { "/dns-query"; };
   };

   options {
       ....
       listen-on tls ephemeral http local { any; };
       listen-on-v6 tls ephemeral http local { any; };
   };

:any:`trust-anchors` 块语法
~~~~~~~~~~~~~~~~~~~~~~~~~~~
.. namedconf:statement:: trust-anchors
   :tags: dnssec
   :short: 定义 :ref:`DNSSEC` 信任锚。

:any:`trust-anchors` 块定义和用法
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:any:`trust-anchors` 语句定义DNSSEC信任锚。DNSSEC在 :ref:`DNSSEC` 中描述。

当一个非权威区的公钥或公钥摘需要公开，但又不能通过DNS安全地获得，要么
因为它是DNS根区，要么因为它的父区未签名，这时，就定义一个信任锚。一旦
一个密钥或一个摘要被配置成一个信任锚，它就被当作已验证并被证实为安全。

解析器试图对一个已配置信任锚的子域中的所有 DNS 数据进行 DNSSEC 验证。
在指定名字之下的验证可以使用 :option:`rndc nta` 暂时关闭，或使用 :any:`validate-except`
选项永久关闭。

所有 :any:`trust-anchors` 中列出的密钥，和对应的区，都被认为是存在的，并
与父区怎么说无关。只有配置在信任锚中的密钥被用于验证对应名字的DNSKEY
资源记录集。而不会用到父区的DS资源记录集。

:any:`trust-anchors` 可以被设置在 :iscman:`named.conf` 的顶层或者在一个视图内。
如果它在两个地方都被设置了，它们都会被添加；在顶层定义的密钥被所有的视
图所继承，但是在一个视图内部定义的密钥只能用于那个视图。

:any:`trust-anchors` 语句可以包含多个信任锚条目，每个条目由一个域名，一
个“锚类型”关键字用来指示信任锚的格式，以及密钥或摘要数据所组成。

如果锚类型是 ``static-key`` 或者 ``initial-key`` ，那它后面会跟随密钥标
志，协议和算法，外加Base64表示的公钥数据。这与DNSKEY记录的文本表示相同。
密钥数据中的空格、制表符、换行和回车字符都被忽略，所以配置可以被分割
为多行。

如果锚类型是 ``static-ds`` 或者 ``initial-ds`` ，那它后面会跟随密钥标
签，算法，摘要类型和十六进制表示的密钥摘要。这与DS记录的文本表示相同。
空格、制表符、换行和回车字符都被忽略。

使用 ``static-key`` 或 ``static-ds`` 配置的信任锚是不可变的，而使用
``initial-key`` 或 ``initial-ds`` 配置的密钥可以保持自动更新，而无需
解析器操作员的干预。（ ``static-key`` 中的密钥与使用已废弃的
:any:`trusted-keys` 语句配置的密钥是一致的。）

例如，假设一个区的密钥签名密钥被攻破了，区的所有者必须撤销并替代这个
密钥。拥有由 ``static-key`` 或者 ``static-ds`` 所配置的初始密钥的解析
器就不能再验证这个区的数据；它的回答会带有一个SERVFAIL响应码。这会一
直持续到解析器管理员使用新的密钥更新 :any:`trust-anchors` 语句。

然而，如果信任锚是以 ``initial-key`` 或 ``initial-ds`` 配置的，区的
所有者可以预先给他的区增加一个“备用的”密钥。 :iscman:`named` 将会存储这个
备用的密钥，并在原始的密钥被撤销时， :iscman:`named` 将能够平滑地过渡到新
的密钥。它也能够识别旧密钥已经被撤销，并停止使用旧密钥验证回答，最
小化被攻破的密钥所能够带来的损害。这是用于保持ICANN根DNSSEC密钥为最
新的流程。

鉴于 ``static-key`` 和 ``static-ds`` 信任锚持续受信任直到从
:iscman:`named.conf` 中删除，一个 ``initial-key`` 或 ``initial-ds`` 只被信
任 **一次** ：只要它一被装载到被管理密钥数据库中就开始 :rfc:`5011` 密
钥维护进程。

对同一个域名，不能将静态与初始信任锚混合使用。

当 :iscman:`named` 第一次在 :iscman:`named.conf` 中配置有
``initial-key`` 或 ``initial-ds`` 的情况下运行时，它直接从区顶点取得
DNSKEY资源记录集，并使用 :any:`trust-anchors` 中所指定的信任锚验证它。
如果这个DNSKEY资源记录集被一个与这个信任锚相匹配的密钥验证是有效签名
的，它就被用作一个新的被管理密钥数据库的基础。

从那个点开始，无论 :iscman:`named` 何时运行，只要它发现了出现在
:any:`trust-anchors` 中的 ``initial-key`` 或 ``initial-ds`` ，检查并确
认针对指定域的 :rfc:`5011` 密钥维护已经被初始化，如果是，它只是简单
地继续。在 :any:`trust-anchors` 语句中所指定的密钥并不用于校验回答；它
被储存在被管理的密钥数据库中的一个或多个密钥所替代。

在一个 ``initial-key`` 或 ``initial-ds`` 信任锚从 :any:`trust-anchors`
语句中 **删除** （或者改变成一个 ``static-key`` 或 ``static-ds`` ）之
后下一次运行 :iscman:`named` 时，对应的区将会从被管理密钥数据库中删除，并
且 :rfc:`5011` 密钥维护将不再用于这个域。

在当前实现中，被管理密钥数据库是以一个 ``master-format`` （主区格式
）区文件存放的。

在没有使用视图的服务器上，这个文件被命名为 ``managed-keys.bind`` 。
当使用了视图时，对每个视图有一个独立的被管理密钥数据库；文件名是视
图名（或者，如果一个视图名包含了使其成为非法文件名的字符，则是视图
名的一个hash），后跟后缀 ``.mkeys`` 。

当密钥数据库被改变时，区就被更新。与其它任何动态区一样，改变会被写入到
一个日志文件中，例如， ``managed-keys.bind.jnl`` 或
``internal.mkeys.jnl`` 。随后改变会尽快被提交到主文件，通常在30秒之内。
所以，无论何时 :iscman:`named` 采用了自动密钥管理，期望区文件和日志文件存在于
工作目录中。（因为这个以及其它原因，工作目录应该总是 :iscman:`named` 可写的。
）

如果 :any:`dnssec-validation` 选项被设为 ``auto`` ， :iscman:`named` 会自动
为根区初始化一个 ``initial-key`` 。用于初始化密钥维护进程的密钥存
储在 ``bind.keys`` ；这个文件的位置可以使用 :any:`bindkeys-file` 选项
覆盖。如果没有找到 ``bind.keys`` ，作为回退，初始化密钥也被直接编
译进 :iscman:`named` 。

.. _dnssec_policy_grammar:

:any:`dnssec-policy` 块语法
~~~~~~~~~~~~~~~~~~~~~~~~~~~
.. namedconf:statement:: dnssec-policy
   :tags: dnssec
   :short: 为区定义一个密钥和签名策略（KASP）。

.. _dnssec_policy:

:any:`dnssec-policy` 块定义和用法
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:any:`dnssec-policy` 语句为区定义了一个密钥和签名策略
（KASP，key and signing policy）。

一个KASP决定一个或多个区将怎样使用DNSSEC签名。例如，它指定密钥多长
时间应当轮转，使用哪种加密算法，以及RRSIG记录多久需要刷新。
多个密钥和签名策略可以使用同一个策略名配置。

对应一个区的一条策略可以使用 :namedconf:ref:`zone` 中的一条
:any:`dnssec-policy` 语句选择，指定应当使用的策略的名字。

有三条内建策略：
  - ``default`` ，用于 :ref:`default policy <dnssec_policy_default>` ，
  - ``insecure`` ，用于当你想要平滑地取消对区的签名，
  - ``none`` ，表示没有DNSSEC策略（与完全不选择 :any:`dnssec-policy`
    相同；区没有被签名。）

不同的区之间不共享密钥，这意谓着每个区将生成一套密钥，即使条目有同
样的策略。如果多个视图配置了同一个区的不同版本，则每个单独的版本都
将使用同一套签名密钥。

缺省时， :any:`dnssec-policy` 为 :any:`inline-signing` 。这意味着区的
一个签名版本被独立维护并被写到磁盘上的一个不同文件中（区文件名加上
``.signed`` 扩展）。

如果区是动态的，因为其使用一条 :any:`update-policy` 或
:any:`allow-update` 配置，DNSSEC记录被写到由原来的区的 :any:`file` 中
所设置的文件名中，除非显示设置了 :any:`inline-signing` 。

每个密钥的轮转时间是根据KASP中定义的密钥生存期来计算的。生存期可以
被区的TTL和广播延迟所修改，目的是防止验证失败。当一个密钥到达其生
存期末尾时， :iscman:`named` 将自动生成并发布一个新密钥，然后失效旧密钥
并激活新的；最终，根据计算的时间表将旧密钥废弃。

区签名密钥（ZSK，Zone-signing key）的轮转不需要操作员输入。密钥签
名密钥（KSK，Key-signing key）和组合签名密钥（CSK，combined signing key）
的轮转需要进行一个向父区提交一条DS记录的动作。对KSK和CSK的轮转时间
进行调整，以考虑在处理和传播DS更新中的延迟。

.. _dnssec_policy_default:

策略 ``default`` 导致区被一个使用算法ECDSAP256SHA256
的单一组合签名密钥（CSK，combined signing key）所签名；这个密钥将
有一个无限的生存期。（可以在源码树种找到这个策略的拷贝，在文件
``doc/misc/dnssec-policy.default.conf`` 中。）

.. note:: 在未来的版本中，缺省的签名策略可能会变化。这可能会在升级
   到新版本的BIND时要求签名策略的变化。在升级时仔细检查发行说明以
   了解这些变化。要防止在升级时的策略变化，使用一个显式定义的
   :any:`dnssec-policy` 而不是 ``default`` 。

如果一条 :any:`dnssec-policy` 语句被修改并且服务器重启或重读配置，
:iscman:`named` 会试图平滑地从旧的策略改变为新的策略。例如，如果密钥算
法改变了，就会使用新算法生成一个新密钥，在当前密钥的生存期结束之
后，旧算法就会退役了。

.. note:: 在一个密钥轮转正在进行时，不支持轮转到一个新策略，这可能
   导致无法预期的行为。

在一个 :any:`dnssec-policy` 语句中，可以指定下列选项：

.. namedconf:statement:: dnskey-ttl
   :tags: dnssec
   :short: 为DNSKEY资源记录指定生存期（TTL）。

    这指定在生成DNSKEY资源记录时使用的TTL。缺省是1小时（3600秒）。

:any:`keys`
    这是一个指定用于生成密钥和签名区的算法和角色的列表。这个列表
    中的条目不代表特定的DNSSEC密钥，密钥可能会定期更改，而是密钥
    将在签名策略中扮演的角色。例如，配置一个使用算法RSASHA256的
    密钥确保DNSKEY资源记录集总是包含一个使用此算法的密钥签名密钥。

    这里是在一个 :any:`keys` 列表中可能出现的一些条目的一个例子（仅作
    说明用途）。

    ::

        keys {
            ksk key-directory lifetime unlimited algorithm rsasha256 2048;
            zsk lifetime P30D algorithm 8;
            csk lifetime P6MT12H3M15S algorithm ecdsa256;
	};

    这个例子指定了三个应当用在区中的密钥。第一个符号决定了密钥在
    签名资源记录集中所扮演的角色。如果设为 ``ksk`` ，这就是一个
    密钥签名密钥；它会设置有KSK标志并且只能用于对DNSKEY，CDS和
    CDNSKEY资源记录集签名。如果设为 ``zsk`` ，这就是一个区签名密
    钥；其KSK标志位为复位状态，这个密钥可以用于对 **除了** DNSKEY，
    CDS和CDNSKEY之外的其它所有资源记录集签名。如果设为 ``csk`` ，
    这个密钥会设置KSK标志位并且可以用于给所有资源记录集签名。

    一个可选的第二个符号决定密钥的存储位置。当前，密钥只能存放在
    :any:`key-directory` 配置的目录。这个符号可以在将来用于将密钥存
    放在硬件安全模块或分离的目录中。

    ``lifetime`` 参数指定一个密钥在轮转前使用多长时间。在上面的
    例子中，第一个密钥有无限的生存期，第二个密钥可以使用30天，第
    三个密钥则具有一个相当特别地生存期，6个月，12小时，3分又15秒。
    一个为0秒的生存期与 ``unlimited`` 相同。

    注意，如果一个密钥退役太快可能引起验证失败时，其生存期可以延长。密
    钥的生存期必须比它做一次轮转的时间更长；即生存期必须大于发布间隔（
    它是 :any:`dnskey-ttl` ， :any:`publish-safety` 与
    :any:`zone-propagation-delay` 之和）。它还必须大于退休间隔（对于
    ZSK，它是 :any:`max-zone-ttl` ， :any:`retire-safety` 与
    :any:`zone-propagation-delay` 之和，对于KSK和CSK，它是
    :any:`parent-ds-ttl` ， :any:`retire-safety` 与
    :any:`parent-propagation-delay` 之和）。BIND 9将一个太短的密钥生存
    期当做一个错误。

    ``algorithm`` 参数指定密钥的算法，表示成一个字符串（“rsasha256”，
    “ecdsa384”等等）或者一个十进制数。一个可选的第二个参数指定以位计算
    的密钥的大小。如果省略，如同例子中第二和第三个密钥，就会使用这种算
    法的一个合适的缺省大小。每个KSK/ZSK对必须使用同样的算法。一个CSK组
    合了一个ZSK和一个KSK的功能。

.. namedconf:statement:: purge-keys
   :tags: dnssec
   :short: 指定自DNSSEC密钥从区中被删除之后到能从磁盘中删除的时间。

    这是自DNSSEC密钥从区中被删除之后到能从磁盘中删除的时间。如果
    决定一个密钥仍然存在（例如，在某些解析器的缓存中）， :iscman:`named`
    不会删除密钥文件。
 
    缺省是 ``P90D`` （90天）。将这个选项设置为 ``0`` 就从不清除
    已删除密钥。

.. namedconf:statement:: publish-safety
   :tags: dnssec
   :short: 增加密钥发布和密钥被激活之间的时间，以允许未预见的事件。

    这是一段在计算轮转时间时增加到发布前间隔的空白，以留出一些额
    外的时间来覆盖未预见的事件。这增加了密钥在发布和激活之间的时
    间。缺省值是 ``PT1H`` （1小时）。

.. namedconf:statement:: retire-safety
   :tags: dnssec
   :short: 增加密钥不再活跃之后的维持发布的时间，以允许未预见的事件。

    这是一段在计算轮转时间时增加到发布后间隔的空白，以留出一些额
    外的时间来覆盖未预见的事件。这增加了密钥在失活之后维持被发布
    状态的时间。缺省值是 ``PT1H`` （1小时）。

.. namedconf:statement:: signatures-refresh
   :tags: dnssec
   :short: 指定一个RRSIG记录被刷新的频繁程度。

    这个决定一个RRSIG记录需要刷新的频繁程度。签名在距离过期时间
    小于指定的间隔时被更新。缺省值是 ``P5D`` （5天），意谓着将在
    5天或更短时间内过期的签名会被刷新。 :any:`signatures-refresh`
    值必须小于 :any:`signatures-validity` 和
    :any:`signatures-validity-dnskey` 中最小值的90%。

.. namedconf:statement:: signatures-validity
   :tags: dnssec
   :short: 指示一个RRSIG记录的有效期。

    这指示一个RRSIG记录的有效期（取决于起始偏移和抖动）。缺省值
    是 ``P2W`` （2周）。

.. namedconf:statement:: signatures-validity-dnskey
   :tags: dnssec
   :short: 指示DNSKEY记录的有效期。

    这个类似于 :any:`signatures-validity` ，但仅对DNSKEY记录。缺省
    值是 ``P2W`` （2周）。

.. namedconf:statement:: max-zone-ttl
   :tags: zone, query
   :short: 指定一个允许的最大生存期（TTL）值，以秒计。

   这为区指定允许的最大TTL值。加载一个区文件时，任何带有比
   :any:`max-zone-ttl` 更大的TTL的记录都会导致区被拒绝。

   这保证了当轮转到一个新的DNSKEY时，旧密钥保持可用指定RRSIG记录从缓存
   过期。 :any:`max-zone-ttl` 选项区中最大的TTL不超过一个已知的和可预
   计的值。

   缺省值 ``PT24H`` （24小时）。为0的值将当做使用缺省值一样对待。

    
.. namedconf:statement:: nsec3param
   :tags: dnssec
   :short: 指定使用NSEC替代NSEC，并设置NSEC3参数。

    使用NSEC3替代NSEC，以及作为可选项，设置NSEC3参数。

    这是一个 ``nsec3`` 配置的例子：

    ::

        nsec3param iterations 0 optout no salt-length 0;

    缺省是使用 :ref:`NSEC` 。 ``iterations`` ， ``optout`` 和
    ``salt-length`` 部份是可选的，但是如果未设置，上述例子中的值为缺省
    的 :ref:`NSEC3` 参数。注意到用户没有指定一个特定的盐值；
    :iscman:`named` 按指示的长度创建一个盐值。

    .. warning::
       不要使用额外的 :term:`iterations` ， :term:`salt` 和
       :term:`opt-out` ，除非完全理解其含义。一个较大循环次数导致互操
       作问题并使服务器面临CPU耗尽的DoS攻击。

.. namedconf:statement:: zone-propagation-delay
   :tags: dnssec, zone
   :short: 设置从一个区首次更新到区的新版本在所有辅服务器上提供服务的传播延迟。

    这是从一个区首次更新到区的新版本在所有辅服务器上提供服务的期
    望传播延迟。缺省值是 ``PT5M`` （5分钟）。

.. namedconf:statement:: parent-ds-ttl
   :tags: dnssec
   :short: 设置父区使用的DS资源记录集的生存期（TTL）。

    这是父区使用的DS资源记录集的TTL。缺省值是 ``P1D`` （1天）。

.. namedconf:statement:: parent-propagation-delay
   :tags: dnssec, zone
   :short: 设置从父区被更新到新版本在所有父区的名字服务器中提供服务的传播延迟。

    这是从父区被更新到新版本在所有父区的名字服务器中提供服务的期
    望的传播延迟。缺省值是 ``PT1H`` （1小时）。

自动化的KSK轮转
^^^^^^^^^^^^^^^

BIND具有促进KSK自动轮转的机制。它发布的CDS和CDNSKEY记录可以被父区用来发
布或撤销区的DS记录。BIND将查询父区代理，以查看在撤销旧DNSSEC密钥之前新
DS是否已实际发布。

   .. note::
      DS响应没有经过验证，因此建议与父区代理建立信任关系。例如，使用
      TSIG来认证父区代理，或者指向一个验证解析器。

下列选项应用于发给 :any:`parental-agents` 的DS请求：

.. namedconf:statement:: parental-source
   :tags: dnssec
   :short: 指定使用哪个本地IPv4源地址发送父区DS查询。

   :any:`parental-source` 决定哪个本地源地址，以及可选的UDP端口，被用于发
   送父区DS查询。这个语句为所有区设置 :any:`parental-source` ，但是可以通
   过在配置文件的 :any:`zone` 或 :any:`view` 块中包含一条 :any:`parental-source`
   语句而被覆盖为基于每个区或每个视图。

   .. warning:: 不鼓励指定单一端口，因为它去掉了针对欺骗错误的一层保护。

   .. warning:: 配置的 :term:`port` 不能与监听端口相同。

.. namedconf:statement:: parental-source-v6
   :tags: dnssec
   :short: 指定使用哪个本地IPv6源地址发送父区DS查询。

   这个选项行为与 :any:`parental-source` 类似，但是应用于发送给IPv6地址的
   父区DS请求。

:any:`managed-keys` 块语法
~~~~~~~~~~~~~~~~~~~~~~~~~~
.. namedconf:statement:: managed-keys
   :tags: deprecated
   :short: 已废弃，使用 :any:`trust-anchors` 。

:any:`managed-keys` 块定义和用法
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:any:`managed-keys` 语句已被废弃，建议使用带 ``initial-key``
关键字的 :any:`trust-anchors` 。

:any:`trusted-keys` 块语法
~~~~~~~~~~~~~~~~~~~~~~~~~~
.. namedconf:statement:: trusted-keys
   :tags: deprecated
   :short: 已废弃，使用 :any:`trust-anchors` 。

:any:`trusted-keys` 块定义和用法
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:any:`trusted-keys` 语句已被废弃，建议使用带 ``static-key``
关键字的 :any:`trust-anchors` 。

.. _view_statement_grammar:

:any:`view` 块语法
~~~~~~~~~~~~~~~~~~
.. namedconf:statement:: view
   :tags: view
   :short: 允许一个名字服务器向不同的请求者对同样的DNS查询作出不同的回答。

::

   view view_name [ class ] {
       match-clients { address_match_list } ;
       match-destinations { address_match_list } ;
       match-recursive-only <boolean> ;
     [ view_option ; ... ]
     [ zone_statement ; ... ]
   } ;

.. _view_statement:

:any:`view` 块定义和用法
~~~~~~~~~~~~~~~~~~~~~~~~

:any:`view` 语句是BIND 9的一个强大功能，它使一个名字服务器在回答一
个DNS请求时，可以依据是谁在请求而有所不同。这在实现分割的DNS设置
却不需要运行多个服务器时特别有用。

.. namedconf:statement:: match-clients
   :tags: view
   :short: 对一个给定的客户端IP地址子集指定一个DNS名字空间的视图。

.. namedconf:statement:: match-destinations
   :tags: view
   :short: 对一个给定的目标地址子集指定一个DNS名字空间的视图。

   每个 :any:`view` 语句定义了一个被一些客户端子集所看到的DNS名字空间
   的视图。一个客户匹配一个视图是指它的源地址与视图的 :any:`match-clients`
   子句中的 :term:`address_match_list` 相匹配并且它的目的地址与视图的
   :any:`match-destinations` 子句中的 :term:`address_match_list` 相匹配。
   如果未指定， :any:`match-clients` 和 :any:`match-destinations` 缺省都
   是匹配所有地址。除了检查IP地址， :any:`match-clients` 和
   :any:`match-destinations` 也可以使用一个TSIG :namedconf:ref:`key`
   的名字，它给客户端提供了一个选择视图的机制。
   
.. namedconf:statement:: match-recursive-only
   :tags: view
   :short: 指定仅递归请求可以匹配这个DNS名字空间的视图。

   一个视图也可以指定成为 :any:`match-recursive-only` ，
   它表示仅仅来自相匹配客户的递归请求才匹配此视图。 :any:`view` 语句的
   顺序非常重要；一个客户端请求将在它所匹配的第一个 :any:`view` 的上
   下文中被解析。

在一个 :any:`view` 语句中定义的区只能被与这个 :any:`view` 相匹配的客户
端访问。通过在多个视图中定义同样名字的区，可以为不同的客户端提供
不同的区数据，例如，在一个分割的DNS上建立“internal”和“external”
客户端。

许多在 :namedconf:ref:`options` 语句中给出的选项也可以用在一个
:any:`view` 语句中，并且仅仅在解析这个视图之内的请求时生效。当没有给出
按视图指定的值时，缺省使用 :namedconf:ref:`options` 语句中的值。同样，
区选项也使用在 :any:`view` 语句中指定的值做缺省值；这些按视图指定的缺
省值优先于其在 :namedconf:ref:`options` 语句中的值。

视图是按类划分的。如果没有给出类，假设为IN类。注意所有的非IN视图
必须包含一个暗示区，因为只有IN类有一个预编译的缺省暗示区。

如果配置文件中没有 :any:`view` 语句，就自动在IN类中建立一个匹配所有
客户端的缺省视图。然后在配置文件的顶层所指定的 :any:`zone` 语句都是
这个缺省视图的一部份， :namedconf:ref:`options` 语句将会应用到这个缺省视图。
如果提供任何显式的 :any:`view` 语句，所有 :any:`zone` 语句都必须出现在
:any:`view` 语句之内。

这里是使用 :any:`view` 语句实现分割DNS的一个典型设置：

::

   view "internal" {
         // This should match our internal networks.
         match-clients { 10.0.0.0/8; };

         // Provide recursive service to internal
         // clients only.
         recursion yes;

         // Provide a complete view of the example.com
         // zone including addresses of internal hosts.
         zone "example.com" {
           type primary;
           file "example-internal.db";
         };
   };

   view "external" {
         // Match all clients not matched by the
         // previous view.
         match-clients { any; };

         // Refuse recursive service to external clients.
         recursion no;

         // Provide a restricted view of the example.com
         // zone containing only publicly accessible hosts.
         zone "example.com" {
          type primary;
          file "example-external.db";
         };
   };

.. _zone_statement_grammar:

:any:`zone` 块语法
~~~~~~~~~~~~~~~~~~
.. namedconf:statement:: zone
   :tags: zone
   :short: 指定一个BIND 9配置中的区。

   :suppress_grammar:

.. _zone_statement:

:any:`zone` 块定义和用法
~~~~~~~~~~~~~~~~~~~~~~~~

区类型
^^^^^^
.. namedconf:statement:: type
   :tags: zone
   :short: 指定一个给定配置中的区类型。

   :suppress_grammar:

   :any:`zone` 配置要求 :any:`type` 关键字，除非它是一个 :any:`in-view`
   配置。可以接受的值是： :any:`primary <type primary>` （或 ``master`` ），
   :any:`secondary <type secondary>`
   （或 ``slave`` ）， :any:`mirror <type mirror>` ， :any:`hint <type hint>` ，
   :any:`stub <type stub>` ， :any:`static-stub <type static-stub>` ，
   :any:`forward <type forward>` ， :any:`redirect <type redirect>` 或
   :any:`delegation-only <type delegation-only>` 。

.. namedconf:statement:: type primary
   :tags: zone
   :short: 包含一个区的数据的主拷贝。

   一个主区拥有区数据的主拷贝，并能够提供关于这个区的权威回答。
   类型 ``master`` 与 :any:`primary <type primary>` 是同义词。

.. namedconf:statement:: type secondary
   :tags: zone
   :short: 包含一个区的数据的从一个主服务器传送来的复制拷贝。

   一个辅区是一个主区的一份复制。类型 ``slave`` 与
   :any:`secondary <type secondary>` 是同义词。 :any:`primaries` 列表
   指定一个或多个主服务器，辅服务器从其更新自己的区拷贝。主服务器列表
   元素也可以是其它主服务器列表的名字。缺省时，自53端口发出区传送；这
   个也可以通过在IP地址列表之前指定一个端口号修改，这对所有服务器都适
   用；或者在IP地址之后指定端口，这个就依每个服务器而不同。对主服务器
   的认证也可以基于每个服务器的TSIG密钥来做。如果指定了一个文件，无论
   何时区有了改变，就将复制来的数据写到这个文件中，并在服务重新启
   动时重新装载这个文件。推荐使用一个文件，因为这常常会加速服务
   的启动并消除不必要的带宽浪费。注意，对一个服务器上大量的区（
   数万或数十万），最好对区文件名使用两级命名机制。例如，区
   ``example.com`` 的辅服务器可能将区的内容放进名为
   ``ex/example.com`` 的文件中，在这里 ``ex/`` 仅仅是区名的头两
   个字母。（如果将100,000个文件放在一个目录中，大多数操作系统操
   作都非常缓慢。）

.. namedconf:statement:: type mirror
   :tags: zone
   :short: 包含一个区的主数据的经过DNSSEC验证的复制拷贝。

   一个镜像区类似于一个类型为 :any:`type secondary` 的区，除了其数据在用于响应
   之前会被DNSSEC验证。在区传送过程中，验证被应用到整个区，并且当
   :iscman:`named` 重启时，从磁盘装载区文件时又会再次进行验证。如果对一个新版
   本镜像区的验证失败，就调度一次重传；同时，使用最近正确验证过的区版
   本，直到其过期或者一个更新的版本被正确验证。如果一个镜像区完全没有可
   以使用的区数据，因为区传送失败或过期，作为替代，都会使用传统的DNS递
   归来查找答案。镜像区不能用在没有打开递归的视图中。

   来自镜像区的答复看起来几乎与来自 :any:`type secondary` 区的答复一模
   一样，除了这个显著的例外，即AA位（“权威答复”）未被置位，且AD
   位（“认证数据”）被置位。

   镜像区的目的是用于设置一个快速的根区的本地拷贝（ 参见 :rfc:`8806`
   ）。IANA根区的一个缺省的主服务器列表内置在 :iscman:`named` 中，因而它的镜
   像可以使用下列配置来打开：

    ::

        zone "." {
            type mirror;
        };

   镜像区的验证总是对整个区内容进行。这确保了解析器使用的每个版本的区在
   DNSSEC方面是完全一致的。对于进入的镜像区IXFR，在IXFR序列中所包含的区
   的每个版本都是独立验证的，以区版本出现在线上的顺序进行验证。由于这个
   原因，通过为相关区（或视图）设置 ``request-ixfr no;`` 来强制为镜像区
   是由AXFR可能是有益的。另外，未来可能会增加更有效率的区验证方法。

   要使镜像区内容在两次 :iscman:`named` 重启间持久化，使用
   :ref:`file <file-option>` 选项。

   镜像一个非根区需要使用 :any:`primaries` 选项提供一个显式的主服务器
   列表（参见 :ref:`primaries_grammar` 获取详细信息），并且要将指
   定区的一个密钥签名密钥（KSK）显式配置成一个信任锚（参见
   :any:`trust-anchors` ）。

   当为一个镜像区配置NOTIFY时，仅能在区一级使用 ``notify no;``
   和 ``notify explicit;`` 。在区一级的任何其它 :namedconf:ref:`notify`
   设置都是配置错误。在 :namedconf:ref:`options` 或者 :any:`view` 级使
   用 :namedconf:ref:`notify` 的任何其它设置将导致这个设置被镜像区的
   ``notify explicit;`` 所覆盖。 :namedconf:ref:`notify` 选项的全局缺
   省值是 ``yes`` ，所以镜像区缺省是配置为 ``notify explicit;`` 。

   镜像区的出向区传送缺省是被关闭的，但是可以使用
   :ref:`allow-transfer <allow-transfer-access>` 开启。

   .. note::
      对根之外的其它任何区使用这个区类型都应考虑为 **试验性的** ，
      可能会有性能问题，特别是对特别大的区和/或被频繁更新的区。

.. namedconf:statement:: type hint
   :tags: zone
   :short: 包含用于BIND 9启动时的根名字服务器的初始集合。

   使用一个提示区来指定初始的根名字服务器集合。在服务器启动时，
   它使用根提示信息来找到一个根名字服务器并从后者获取最近的根名
   字服务器名单。如果没有为类IN指定提示区，服务器使用编译内建的
   根服务器提示集合。IN之外的其它类没有内建缺省提示。

.. namedconf:statement:: type stub
   :tags: zone
   :short: 包含主区的NS记录的一个副本。

   存根（stub）区类似于一个辅区，差别仅仅是它只复制一个主区中的
   NS记录而不是整个区。存根区不是DNS的标准部份；它只是BIND实现的
   一个特性。

   存根区可以用来消除父区中粘连NS记录的需求，代价是维护一个存根
   区条目和 :iscman:`named.conf` 中名字服务器地址的集合。在新配置中不
   推荐这种用法，并且BIND 9仅仅以有限的方式支持它。如果一个BIND 9
   主服务器配置成一个父区，并配置了子区的存根区，那么所有父区的
   辅服务器也都需要配置同样的子区的存根区。

   存根区也可以用于强制使用某个特定权威服务器集合来解析某一给定
   域名。例如，使用 :rfc:`1918` 地址的某个私有网络上的缓存服务
   器可能为 ``10.in-addr.arpa`` 配置存根区，并使用内部名字服务
   器的一个集合作为这个区的权威服务器。

.. namedconf:statement:: type static-stub
   :tags: zone
   :short: 包含主区的NS记录的一个副本，但是是静态配置而不是从一个主服务器传送来的。

   静态存根（static-stub）区类似于存根区，仅仅有下列例外：区数据
   是静态配置而不是从主服务器传送而来；当一个匹配某个静态存根区
   的请求需要递归时，总是使用本地配置的数据（名字服务器的名字和
   粘连地址），即使其缓存了不同的权威信息。

   区数据使用 :any:`server-addresses` 和 :any:`server-names` 区
   选项来配置。

   区数据在内部是以NS和（如果需要）粘连的A或者AAAA资源记录的形式
   维护，可以使用 :option:`rndc dumpdb -all <rndc dumpdb>` 将区数据库导出为可读的格
   式。配置的资源记录集被认为是本地配置参数，而不是公共数据。所
   以发给一个静态存根区的非递归请求（即那些RD位复位的）是被禁止
   的，并且以REFUSED响应。

   由于数据是静态配置的，对于一个静态存根区来说，不会发生区维护
   动作。例如，没有定期刷新，收到的通知消息将会被拒绝，并带有一
   个NOTAUTH的响应码（rcode）。

   每个静态存根区都被配置为带有内部生成的NS和（如果需要）粘连的
   A或者AAAA资源记录。

.. namedconf:statement:: type forward
   :tags: zone
   :short: 包含应用于在一个给定域内查询的转发语句。

   一个转发区是基于域名配置转发的方式。一个 :any:`forward` 类型的
   :any:`zone` 语句可以包含 :any:`forward` 和/或 :any:`forwarders` 语句，
   这将对由区名所给出的域内的请求起作用。如果没有 :any:`forwarders`
   语句或者为 :any:`forwarders` 配置一个空表，这个域就不会有转发动
   作，即取消了 :namedconf:ref:`options` 语句中任何转发者的效果。这样，如果想
   使用这种类型的区来改变全局 :any:`forward` 选项（即，先“forward first”，
   然后“forward only”，或者相反）的行为，但是想要使用同样的服务
   器作为全局设置，需要重新指定全局转发者。

.. namedconf:statement:: type redirect
   :tags: zone
   :short: 包含当正常的解析应返回NXDOMAIN时答复查询的信息。

   重定向区用于在普通解析将导致返回一个NXDOMAIN时，而给请求提供
   一个回答。每个视图只支持一个重定向区。可以使用 :any:`allow-query`
   限制哪些客户端可以看见这些回复。

   如果客户端请求DNSSEC记录（DO=1）并且NXDOMAIN响应被签名，就不
   会发生任何替换。

   要重定向所有的NXDOMAIN响应到100.100.100.2和
   2001:ffff:ffff::100.100.100.2，需要配置一个名为“.”、类型为
   :any:`redirect <type redirect>` 的区，其区文件中包含指向期望地址的通配符记录：
   ``*. IN A 100.100.100.2`` 和
   ``*. IN AAAA 2001:ffff:ffff::100.100.100.2`` 。

   另外一个例子，要重定向所有西班牙名字（在.ES下面），需要使用类
   似的名字，但要用 ``*.ES.`` 替代 ``*.`` 。要重定向所有商业类西
   班牙名字（在.COM.ES下面），需要使用通配符条目 ``*.COM.ES.`` 。

   注意重定向区支持所有可能的类型；它不限于A和AAAA记录。

   如果一个重定向区配置了一个 :any:`primaries` 选项，那么它就会像一个
   辅区一样从外面做区传送。否则，它就会如同一个主区一样从一个文
   件装载。

   由于重定向区不会直接被名字引用，它们不保存在普通主区和辅区的
   区查找表中。因此，当前不可能使用要重新装载一个重定向区，使用
   :option:`rndc reload -redirect <rndc reload>` ，要重新传输一个作为辅区配置的重定
   向区，使用 :option:`rndc retransfer -redirect <rndc retransfer>` 。当使用 :option:`rndc reload`
   而不指定一个区名时，重定向区将会随着其它区被重载。

.. namedconf:statement:: type delegation-only
   :tags: query
   :short: 强制基础设施区（COM，NET，ORG等）为只授权的状态。

   这个区类型用于强制基础设施区（如COM，NET，ORG）为只授权状态。任何
   收到的回答在权威部份没有一个显式或隐式的授权时都会被当做
   NXDOMAIN。这个不应用在区顶点，也不应该应用在叶子区。

   :any:`delegation-only` 对从转发服务器来的回答没有效果。

   参见 :ref:`root-delegation-only <root-delegation-only>` 中的
   说明。

.. namedconf:statement:: in-view
   :tags: view, zone
   :short: 指定在其中已定义了一个给定区的视图。

   使用多个视图时，配置在一个视图中的一个 :any:`type primary` 或 :any:`type secondary`
   区可以被随后的视图引用。这允许两个视图使用同一个区而无须加载多次。这
   通过一条 :any:`zone` 语句，以及一个 :any:`in-view` 选项指定区所定义的视图
   来配置。一条包含 :any:`in-view` 的 :any:`zone` 语句不需要指定类型，因为那
   是在其它视图中的区定义的一部份。

   更多信息，参见 :ref:`multiple_views` 。

类
^^

作为可选项，区的名字后面可以跟一个类。如果未指定类，就设定为类
``IN`` （表示 ``Internet`` ）。这在大多数情况下是正确的。

``hesiod`` 类是表示来自MIT的雅典娜项目的一种信息服务。它用于在不
同系统数据库之间共享信息，如用户、组、打印机等等。关键字 ``HS``
是hesiod的符号。

另一个MIT开发的是Chaosnet，一个创建于1970年代中期的局域网协议。
它的区数据可以使用 ``CHAOS`` 类指定。

.. _zone_options:

区选项
^^^^^^

:any:`allow-notify`
   参见 :ref:`access_control` 中对 :any:`allow-notify` 的描述。

.. _allow-query:

:any:`allow-query`
   参见 :ref:`access_control` 中对 :any:`allow-query` 的描述。

:any:`allow-query-on`
   参见 :ref:`access_control` 中对 :any:`allow-query-on` 的描述。

:any:`allow-transfer`
   参见 :ref:`access_control` 中对 :any:`allow-transfer` 的描述。

:any:`allow-update`
   参见 :ref:`access_control` 中对 :any:`allow-update` 的描述。

:any:`update-policy`
   这个指定一个“简单安全更新”策略。参见 :ref:`dynamic_update_policies` 。

:any:`allow-update-forwarding`
   参见 :ref:`access_control` 中对 :any:`allow-update-forwarding`
   的描述。

:any:`also-notify`
   这个选项仅在这个区的 :namedconf:ref:`notify` 是激活时有意义。会收到这个区
   的 ``DNS NOTIFY`` 消息的机器集由所有为这个区而列出的区名字服
   务器（主服务器除外）组成，外加 :any:`also-notify` 所指定的任何IP
   地址。可以在每个 :any:`also-notify` 地址指定通知消息要送达的端
   口，缺省为53。也可以指定一个TSIG密钥，使 ``NOTIFY`` 被给出的
   密钥签名。 :any:`also-notify` 对存根区没有意义。缺省是空表。

:any:`check-names`
   这个选项用于限制某些域名的字符集和语法，这些域名包括来自主文件和/或
   来自网络的DNS响应。缺省值是依区类型的不同而不同的。对
   :any:`primary <type primary>` 区缺省值是 ``fail`` ；对
   :any:`secondary <type secondary>` 区缺省值
   是 ``warn`` 。对于 :any:`hint <type hint>` 区没有实现。

:any:`check-mx`
   参见 :ref:`boolean_options` 中对 :any:`check-mx` 的描述。

:any:`check-spf`
   参见 :ref:`boolean_options` 中对 :any:`check-spf` 的描述。

:any:`check-wildcard`
   参见 :ref:`boolean_options` 中对 :any:`check-wildcard` 的描述。

:any:`check-integrity`
   参见 :ref:`boolean_options` 中对 :any:`check-integrity` 的描述。

:any:`check-sibling`
   参见 :ref:`boolean_options` 中对 :any:`check-sibling` 的描述。

:any:`zero-no-soa-ttl`
   参见 :ref:`boolean_options` 中对 :any:`zero-no-soa-ttl` 的描述。

:any:`update-check-ksk`
   参见 :ref:`boolean_options` 中对 :any:`update-check-ksk` 的描述。

:any:`dnssec-loadkeys-interval`
   参见 :ref:`options` 中对 :any:`dnssec-loadkeys-interval` 的描述。

:any:`dnssec-update-mode`
   参见 :ref:`options` 中对 :any:`dnssec-update-mode` 的描述。

:any:`dnssec-dnskey-kskonly`
   参见 :ref:`boolean_options` 中对 :any:`dnssec-dnskey-kskonly` 的
   描述。

:any:`try-tcp-refresh`
   参见 :ref:`boolean_options` 中对 :any:`try-tcp-refresh` 的描述。

.. namedconf:statement:: database
   :tags: zone
   :short: 指定用于存储区数据的数据库类型。

   这个指定用于存放区数据的数据库类型。 :any:`database` 关键字后跟
   的字符串被解释为一个空格分隔的单词列表。第一个单词标识数据库
   类型，接下来的单词作为参数传递给数据库，并按照数据库类型所指
   定的处理方式来解释。

   缺省是 ``rbt`` ，BIND 9的原生内存红黑树数据库。这种数据库不
   需要参数。

   如果有附加的数据库驱动被链接到服务器，也可能有其它值。在分发
   包中包含一些简单的驱动，但是缺省没有被链接进来。

:any:`dialup`
   参见 :ref:`boolean_options` 中对 :any:`dialup` 的描述。

.. namedconf:statement:: delegation-only
   :tags: zone
   :short: 指定一个转发、提示或存根区被当做一个只授权类型区对待。

   这个标志只用于转发区，提示区和存根区。如果设置为 ``yes`` ，区
   将被当成一个只授权类型的区。

   参见 :ref:`root-delegation-only <root-delegation-only>` 中的说明。

.. _file-option:

.. _file:

.. namedconf:statement:: file
   :tags: zone
   :short: 指定区的文件名。

   这设置区的文件名，在 :any:`primary <type primary>` ，
   :any:`hint <type hint>` 和 :any:`redirect <type redirect>`
   这些没有定义 :any:`primaries` 的区中，区数据是从这个文件装载。在
   :any:`secondary <type secondary>` ， :any:`mirror <type mirror>` ，
   :any:`stub <type stub>` 和 :any:`redirect <type redirect>` 这些
   定义了 :any:`primaries` 的区中，区数据是来自另一个服务器并保存在这
   个文件中。这个选项对于其它区类型是不适用的。

:any:`forward`
   这个选项仅在区有一个转发者列表的时候有意义。 ``only`` 值将会
   在试探转发者却没有获得回复之后导致查找失败，而 ``first`` 值将
   会允许进行一个普通查找的试探。

:any:`forwarders`
   这个用于重载全局转发者列表。如果没有在一个 :any:`forward` 类型的
   区中指定，对此区就没有转发，也不使用全局选项。

.. namedconf:statement:: journal
   :tags: zone
   :short: 允许覆盖缺省的日志文件名。

   这允许覆盖缺省的日志文件名。缺省为区文件后增 “ ``.jnl`` ”。
   这个应用于 :any:`primary <type primary>` 和 :any:`secondary <type secondary>` 区中。

:any:`max-ixfr-ratio`
   参见 :ref:`options` 中对 :any:`max-ixfr-ratio` 的描述。

:any:`max-journal-size`
   参见 :ref:`server_resource_limits` 中对 :any:`max-journal-size` 的描述。

:any:`max-records`
   参见 :ref:`server_resource_limits` 中对 :any:`max-records` 的描述。

:any:`max-transfer-time-in`
   参见 :ref:`zone_transfers` 中对 :any:`max-transfer-time-in` 的描述。

:any:`max-transfer-idle-in`
   参见 :ref:`zone_transfers` 中对 :any:`max-transfer-idle-in` 的描述。

:any:`max-transfer-time-out`
   参见 :ref:`zone_transfers` 中对 :any:`max-transfer-time-out` 的描述。

:any:`max-transfer-idle-out`
   参见 :ref:`zone_transfers` 中对 :any:`max-transfer-idle-out` 的描述。

:namedconf:ref:`notify`
   参见 :ref:`boolean_options` 中对 :namedconf:ref:`notify` 的描述。

:any:`notify-delay`
   参见 :ref:`tuning` 中对 :any:`notify-delay` 的描述。

:any:`notify-to-soa`
   参见 :ref:`boolean_options` 中对 :any:`notify-to-soa` 的描述。

:any:`zone-statistics`
   参见 :ref:`options` 中对 :any:`zone-statistics` 的描述。

.. namedconf:statement:: server-addresses
   :tags: query, zone
   :short: 指定一个IP地址列表，在递归解析一个静态存根区时，查询将被发向这个列表。

   这个选项仅对静态存根区有意义。这是一个IP地址列表，在递归解析
   这个区时，查询将被发向这个列表。一个为这个选项配置的非空列表，
   会在内部配置顶点NS资源记录及附带的粘连A或者AAAA记录。

   例如，如果“example.com”被配置成一个静态存根区，在一个
   :any:`server-addresses` 选项中配置192.0.2.1和2001:db8::1234，内
   部将被配置为下列资源记录。

   ::

      example.com. NS example.com.
      example.com. A 192.0.2.1
      example.com. AAAA 2001:db8::1234

   这些记录将会被用于解析这个静态存根区下的名字。例如，如果服务
   器收到一个带RD位的“www.example.com”请求，服务器将发起一个递
   归解析，将请求发给192.0.2.1和/或2001:db8::1234。

.. namedconf:statement:: server-names
   :tags: zone
   :short: 指定一个名字服务器域名的列表，充当一个静态存根区的权威服务器。

   这个选项仅对静态存根区有意义。这是一个名字服务器域名的列表，充当
   这个静态存根区的权威服务器。在 :iscman:`named` 需要发送请求到这些
   服务器时，这些名字将被解析成IP地址。为使这个补充解析能够成功，
   这些名字必须不能是静态存根区原点名的子域名。即，当一个静态存
   根区的原点是“example.net”时，“ns.example”和“master.example.com”
   可以设定在 :any:`server-names` 选项中，但是“ns.example.net”不能；
   它将被配置分析器拒绝。

   为这个选项配置一个非空列表，将会使用指定的名字在内部配置顶点
   NS资源记录。例如，如果“example.com”被配置为一个静态存根区，
   并在一个 :any:`server-names` 选项中配置“ns1.example.net”和
   “ns2.example.net”，内部将被配置为下列资源记录：

   ::

      example.com. NS ns1.example.net.
      example.com. NS ns2.example.net.

   这些记录将会被用于解析这个静态存根区下的名字。例如，如果服务
   器收到一个带RD位的“www.example.com”请求，服务器将发起一个递
   归解析，先将“ns1.example.net”和/或“ns2.example.net”解析成IP
   地址，再将请求发给这些地址中的一个或多个。

:any:`sig-validity-interval`
   参见 :ref:`tuning` 中对 :any:`sig-validity-interval` 的描述。

:any:`sig-signing-nodes`
   参见 :ref:`tuning` 中对 :any:`sig-signing-nodes` 的描述。

:any:`sig-signing-signatures`
   参见 :ref:`tuning` 中对 :any:`sig-signing-signatures` 的描述。

:any:`sig-signing-type`
   参见 :ref:`tuning` 中对 :any:`sig-signing-type` 的描述。
   
:any:`transfer-source`
   参见 :ref:`zone_transfers` 中对 :any:`transfer-source` 的描述。

:any:`transfer-source-v6`
   参见 :ref:`zone_transfers` 中对 :any:`transfer-source-v6` 的描述。

:any:`alt-transfer-source`
   参见 :ref:`zone_transfers` 中对 :any:`alt-transfer-source` 的描述。

:any:`alt-transfer-source-v6`
   参见 :ref:`zone_transfers` 中对 :any:`alt-transfer-source-v6` 的描述。

:any:`use-alt-transfer-source`
   参见 :ref:`zone_transfers` 中对 :any:`use-alt-transfer-source` 的描述。

:any:`notify-source`
   参见 :ref:`zone_transfers` 中对 :any:`notify-source` 的描述。

:any:`notify-source-v6`
   参见 :ref:`zone_transfers` 中对 :any:`notify-source-v6` 的描述。

:any:`min-refresh-time`; :any:`max-refresh-time`; :any:`min-retry-time`; :any:`max-retry-time`
   参见 :ref:`tuning` 中的描述。

:any:`ixfr-from-differences`
   参见 :ref:`boolean_options` 中对 :any:`ixfr-from-differences` 的描述。
   （注意 :any:`ixfr-from-differences` 选择 :any:`primary <type primary>`
   和 :any:`secondary <type secondary>` 不能用于区这一级。）

:any:`key-directory`
   参见 :ref:`options` 中对 :any:`key-directory` 的描述。

:any:`auto-dnssec`
   参见 :ref:`options` 中对 :any:`auto-dnssec` 的描述。

:any:`serial-update-method`
   参见 :ref:`options` 中对 :any:`serial-update-method` 的描述。

.. namedconf:statement:: inline-signing
   :tags: dnssec, zone
   :short: 指定BIND 9是否维护一个区的单独的签名版本。

   如果为 ``yes`` ，BIND 9维护一个独立的区签名版本。
   一个未签名区通过区传送传入或从磁盘加载，将会生成区的签名版本，可
   能带有一个不同的序列号。区签名版本存放在一个由其区文件名（在
   :any:`file` 中设置）加上一个 ``.signed`` 扩展而形成的文件中。
   此特性缺省是关闭的。

:any:`multi-master`
   参见 :ref:`boolean_options` 中对 :any:`multi-master` 的描述。

:any:`masterfile-format`
   参见 :ref:`tuning` 中对 :any:`masterfile-format` 的描述。

:any:`max-zone-ttl`
   参见 :ref:`options` 中对 :any:`max-zone-ttl` 的描述。
   在 :any:`zone` 块中使用这个选项已被废弃，并将在未来的版本中变为不可操作的。

:any:`dnssec-secure-to-insecure`
   参见 :ref:`boolean_options` 中对 :any:`dnssec-secure-to-insecure` 的描述。

.. _dynamic_update_policies:

动态更新策略
^^^^^^^^^^^^

BIND 9支持两种方法来授权客户端对一个区执行动态更新：

- :namedconf:ref:`allow-update` - 一个简单的访问控制表
- :namedconf:ref:`update-policy` - 细粒度访问控制

在这两者情况中，BIND 9将更新写到在 :any:`file` 中设置的区的文件名。

在一个DNSSEC区的情况，DNSSEC记录也写到区的文件名，除非开启了
:any:`inline-signing` 。

   .. note:: 当 ``named`` 运行时，区文件不再能通过手工更新；它现在需要
      执行 :option:`rndc freeze` ，编辑，然后执行 :option:`rndc thaw` 。
      在动态更新发生时，区文件中的注释和格式将会丢失。

.. namedconf:statement:: update-policy
   :tags: transfer
   :short: 基于请求者标识，更新内容等设置细粒度的规则以允许或禁止动态更新（DDNS）。

   :any:`update-policy` 子句允许对所授权的更新作更细粒度的控制。它指定
   一个规则集，其中的每个规则是授权或禁止区中一个或多个名字被一个或多
   个身份所更新。身份是由密钥决定的，这个密钥使用TSIG或者SIG(0)签名更
   新请求。大多数情况下， :any:`update-policy` 仅仅应用于基于密钥的身
   份。没法指定基于客户端源地址更新权限。

   :any:`update-policy` 规则仅对 :any:`type primary` 的区有意义，不能
   用于任何其它类型的区中。同时指定 :any:`allow-update` 和
   :any:`update-policy` 会报出一个配置错误。

   一个预定义的 :any:`update-policy` 规则，可以使用命令
   ``update-policy local;`` 打开。 :iscman:`named` 在启动时自动生成一
   个TSIG会话密钥，并将其存放在一个文件中；在 :iscman:`named` 运行时这
   个密钥可以被本机客户端用于更新区。缺省时，会话密钥存放在文件
   |session_key| 中，密钥名是“local-ddns”，密钥算法是HMAC-SHA256。这些
   值可以分别由 :any:`session-keyfile` ， :any:`session-keyname` 和
   :any:`session-keyalg` 选项配置。一个运行在本地系统上的客户端，如果
   以合适的授权运行，可以从密钥文件读取会话密钥并使用它对更新请求签名。
   区的更新策略被设置为允许那个密钥改变区中的任何记录。假设密钥名是
   “local-ddns”，这个策略等效于：

   ::

      update-policy { grant local-ddns zonesub any; };

   带有附加限制条件，即只有连接来自本地系统的客户端允许发送更新。

   注意， :iscman:`named` 只生成一个会话密钥；所有配置成使用
   ``update-policy local`` 的区将接受同一个密钥。

   命令 ``nsupdate -l`` 实现了这个特性，发送请求到本机，并使用从会话密
   钥文件中取得的密钥对其签名。

   其它的规则看起来像这个：

   ::

      ( grant | deny ) identity ruletype  name   types

   每条规则授予或禁止权限。规则按其在 :any:`update-policy` 语句中指定
   的顺序进行检查。一旦一条消息成功地匹配了一条规则，立即进行授予或禁
   止操作，而不再进行更多的规则检查。存在16种类型的规则；规则类型由
   ``ruletype`` 字段指定，并且对其它字段的解释是变化的，这依赖于规则类
   型。

   通常，一条规则匹配是指对一个更新请求签名的密钥与 ``identity``
   字段匹配，将被更新记录的名字与 ``name`` 字段匹配（由 ``ruletype``
   字段所指定的方式），并且将被更新记录的类型与 ``types`` 字段匹配。
   每种规则类型的详细情况将在下面描述。

   ``identity`` 字段必须设置成一个完整域名。在大多数情况，表示必须
   被用于签名更新请求的TSIG或者SIG(0)密钥的名字。如果指定的名字是
   一个通配符，它服从DNS通配符扩展规范，并且规则可以应用到多个个体。
   当使用一个TKEY交换来创建一个共享密钥时，用于认证TKEY交换的密钥标识
   将被用作共享秘钥的标识。一些规则类型使用标识与客户端的
   Kerberos principal（例如， ``"host/machine@REALM"`` ）或
   Windows realm（ ``machine$@REALM`` ）匹配。

   ``name`` 字段也指定一个完整域名。这通常标识将被更新的记录的名字。对
   这个字段的解释依赖于规则类型。

   如果没有显式指定 ``types`` ，一条规则就匹配除了RRSIG，NS，SOA，NSEC
   和NSEC3之外的所有类型。类型可以由名字指定，包括 ``ANY`` ；ANY匹配除
   了NSEC和NSEC3之外的所有类型，这两种永远不能被更新。注意当试图删除与
   一个名字相联系的所有记录时，会针对每种存在的记录检查规则。

   如果类型后面紧跟一个包含在带括号中的数字，该数字就是一个更新应用之
   后在资源记录集中该类型允许的最大记录数。例如， ``PTR(1)`` 指示只能
   允许一个PTR记录。如果在一个更新中尝试增加两条PTR记录，第二条将被静
   默地丢弃。如果已经存在一条PTR记录，则两条新纪录都被静默地丢弃。

   如果为类型ANY指定了限制，这个限制将应用到所有没有单独指定的类型。例
   如， ``A PTR(1) ANY(2)`` 指示可以有不限数目的A记录存在，但只能有一
   条PTR记录，其它类型的记录不能超过两条。

   在区2.0.192.IN-ADDR.ARPA中的一条典型的规则
   ``grant * tcp-self . PTR(1);`` 使用看起来像这样：

   ::

     nsupdate -v <<EOF
     local 192.0.2.1
     del 1.2.0.192.IN-ADDR.ARPA PTR
     add 1.2.0.192.IN-ADDR.ARPA 0 PTR EXAMPLE.COM
     send
     EOF

   ruletype字段有16个值： ``name`` ， ``subdomain`` ， ``zonesub`` ，
   ``wildcard`` ， ``self`` ， ``selfsub`` , ``selfwild`` ， ``ms-self`` ，
   ``ms-selfsub`` ， ``ms-subdomain`` ， ``ms-subdomain-self-rhs`` ，
   ``krb5-self`` ， ``krb5-selfsub`` ， ``krb5-subdomain`` ，
   ``krb5-subdomain-self-rhs`` ， ``tcp-self`` ， ``6to4-self``
   和 ``external`` 。

   ``name``
       使用精确匹配语义，这个规则在被更新的名字与 ``name`` 字段内容一致时
       匹配。

   ``subdomain``
       当被更新的名字是 ``name`` 字段内容的子域或与其一致时，这个规则匹配。

   ``zonesub``
       这个规则与subdomain类似，除了当被更新的名字是配置了 :any:`update-policy`
       语句的区的子域时，它会匹配。这就排除了两次输入区名的需要，并
       且能够在多个区中使用标准的 :any:`update-policy` 语句而不需要修
       改。在使用这条规则时， ``name`` 字段会被忽略。

   ``wildcard``
       ``name`` 字段服从DNS通配符扩展，当被更新的名字是一个通配符的有效
       扩展时，这条规则匹配。

   ``self``
       当被更新记录的名字匹配 ``identity`` 字段的内容时，这条规则匹配。
       ``name`` 字段被忽略。为避免混淆，推荐将这个字段设置为与 ``identity``
       字段一致或为“.”。在允许为每个要更新的名字使用一个密钥时， ``self``
       规则类型是最有用的，这时密钥与被更新的记录有同样的名字。这种
       情况下， ``identity`` 字段可以被指定为 ``*`` （星号）。

   ``selfsub``
       这条规则与 ``self`` 相似，除了 ``self`` 的子域也可以被更新之外。

   ``selfwild``
       这条规则与 ``self`` 相似，除了仅仅只有 ``self`` 的子域才能被
       更新之外。

   ``ms-self``
       当一个客户端使用一个Windows机器标识（例如， ``machine$@REALM`` ）
       发送一个UPDATE，这条规则允许带有 ``machine.REALM`` 的绝对名
       字的记录被更新。

       要匹配的域（译注：realm）在 ``identity`` 字段中指定。

       ``name`` 字段在本规则中没有效果；作为占位符，它应被设置为“.”。

       例如， ``grant EXAMPLE.COM ms-self . A AAAA`` 允许域
       ``EXAMPLE.COM`` 中所有带有一个有效标记的机器更新它自己的地址
       记录。

   ``ms-selfsub``
       这个与 ``ms-self`` 相似，除了它还允许更新在Windows机器标记下
       指定名字的任何子域，而不仅仅它自身。

   ``ms-subdomain``
       当一个客户端使用一个Windows机器标识（例如， ``machine$@REALM``
       ）发送一个UPDATE时，这条规则允许在指定域（译注：realm）中的
       任何机器更新区中或区的指定子域中的任何记录。

       要匹配的域（译注：realm）在 ``identity`` 字段中指定。

       ``name`` 字段指定可能被更新的子域。如果设置为“.”（或任何在区顶点
       及之上的任何其它名字），任何区内的名字都可以被更新。

       例如，如果区“example.com”的 :any:`update-policy` 包含
       ``grant EXAMPLE.COM ms-subdomain hosts.example.com. A AAAA`` ，
       任何在域（译注：realm） ``EXAMPLE.COM`` 内带有有效标识（译注：
       principal）的机器都能够更新在 ``hosts.example.com`` 或之下的
       地址记录。

   ``ms-subdomain-self-rhs``
       这条规则与 ``ms-subdomain`` 相似，有一条额外的限制，即PTR和SRV的
       目标名字必须与principal中标识的机器名匹配。

   ``krb5-self``
       当一个客户端使用一个Kerberos机器标识（例如，
       ``host/machine@REALM`` ）发送一个UPDATE时，这条规则允许带有完全
       ``machine`` 名字的记录被更新，前提是它已被REALM认证了。这个类似
       于 ``ms-self`` ，但不完全与后者相同，这是由于Kerberos标识的
       ``machine`` 部份是一个完全名字而不是一个不完全的名字。

       要匹配的领域在 ``identity`` 字段中指定。

       ``name`` 字段对这条规则没有影响；它应该被设置为“.”作为一个占位符。

       例如， ``grant EXAMPLE.COM krb5-self . A AAAA`` 允许任何在域
       ``EXAMPLE.COM`` 带有一个有效标识的机器更新其自身的地址记录。

   ``krb5-selfsub``
       这条类似于 ``krb5-self`` ，除了它也允许更新在Kerberos标识的
       ``machine`` 部份中指定的名字的任何子域，而不仅仅是名字自身。

   ``krb5-subdomain``
       这条规则与 ``ms-subdomain`` 相同，除了它使用Kerberos机器标识
       （即， ``host/machine@REALM`` ）工作，而不是使用Windows机器
       标识。

   ``krb5-subdomain-self-rhs``
       这条规则与 ``krb5-subdomain`` 相似，有一条额外的限制，即PTR和SRV的
       目标名字必须与principal中标识的机器名匹配。

   ``tcp-self``
       这条规则允许通过TCP发送更新，并且对这些更新，从客户端的IP地
       址到 ``in-addr.arpa`` 和 ``ip6.arpa`` 名字空间的标准映射与被
       更新的名字进行匹配。 ``identity`` 字段必须与名字匹配。 ``name``
       字段应该被设置为“.”。注意，由于identity是基于客户端的IP地址，
       不必对更新请求消息进行签名。

       .. note::
           理论上有可能欺骗这些TCP会话。

   ``6to4-self``
       这允许任何来自6to4网络或来自对应的IPv4地址的TCP连接更新与一
       个6to4 IPv6前缀匹配的名字，如同在 :rfc:`3056` 中所描述的。这
       是刻意允许NS或DNAME资源记录集被添加到 ``ip6.arpa`` 反向树中。

    ``identity`` 字段必须和 ``ip6.arpa`` 中的6to4前缀相匹配。
    ``name`` 字段应被设置为“.”。注意，由于identity是基于客户端的
    IP地址，不必对更新请求消息进行签名。

    另外，如果指定一个在 ``2.0.0.2.ip6.arpa`` 名字空间之外的
    ``ip6.arpa`` 名字，对应的/48反向名字可以被更新。例如，来自
    2001:DB8:ED0C::/48的TCP/IPv6连接可以更新
    ``C.0.D.E.8.B.D.0.1.0.0.2.ip6.arpa`` 下的记录。

    .. note::
        理论上有可能欺骗这些TCP会话。

   ``external``
       这个规则允许 :iscman:`named` 推迟决定是否允许一个给定的更新到一个
       外部的服务进程。

       和服务进程通信的方法在 ``identity`` 字段中指定，其格式是
       "``local:``\ path"，
       这里“path”是一个Unix域套接字的位置。（当前，“local”是唯一支
       持的机制。）

       到外部服务进程的请求通过UNIX域套接字以数据报发送，其格式为：

       ::

           Protocol version number (4 bytes, network byte order, currently 1)
           Request length (4 bytes, network byte order)
           Signer (null-terminated string)
           Name (null-terminated string)
           TCP source address (null-terminated string)
           Rdata type (null-terminated string)
           Key (null-terminated string)
           TKEY token length (4 bytes, network byte order)
           TKEY token (remainder of packet)

       服务进程以网络字节序回应一个四字节值，包含0或者1；0表示指定
       的更新不被允许，1表示其被允许。

.. _multiple_views:

多视图
^^^^^^

当使用了多个视图，一个区可能被在超过一个视图中引用。通常，这些
视图会对同样的名字包含不同的区，即运行不同的客户端对同样请求收
到不同的回复。然而，在许多时候，期望多个视图包含同样的区。
:any:`in-view` 区选项提供一个有效的方法来做这事；它允许一个视图引
用在之前一个已配置视图中定义的一个区。例如：

::

   view internal {
       match-clients { 10/8; };

       zone example.com {
       type master;
       file "example-external.db";
       };
   };

   view external {
       match-clients { any; };

       zone example.com {
       in-view internal;
       };
   };

一个 :any:`in-view` 选项不能引用到在配置文件后面定义的视图。

一个使用了 :any:`in-view` 选项的 :any:`zone` 语句不能使用除 :any:`forward`
和 :any:`forwarders` 之外的任何其它选项。（这些选项控制包含视图的
行为，而不是改变区对象自身。）

区级ACL（例如：allow-query，allow-transfer）和区的其它详细配置
是在定义区的视图中设置。需要仔细地确保这些ACL足够广泛能适应
引用区的所有视图。

一个 :any:`in-view` 区不能用作一个响应策略区。

一个 :any:`in-view` 区不能引用一个 :any:`forward` 区。


语句
----

BIND 9支持数百个语句；发现正确的语句来控制一个特定的行为或者解决一个特
殊的问题可能是一件令人畏惧的任务。为了给用户简化这个任务，所有语句都被分配了
一个或多个标记。标签被设计用来将功能大致相似的语句分组；因此，例如，所
有控制对查询或区传送进行处理的语句都分别标记在 **query** 和
**transfer** 之下。

:ref:`dnssec_tag_statements` 是那些与DNSSEC相关或者控制DNSSEC的。

:ref:`logging_tag_statements` 与日志相关或者控制日志的，典型情况下只出
现在一个日志块内。

:ref:`query_tag_statements` 与查询相关或者控制查询的。

:ref:`security_tag_statements` 与安全特性相关或者控制安全特性的。

:ref:`server_tag_statements` 与服务器行为相关或者控制服务器行为的，典
型情况下只出现在一个服务器块内。

:ref:`transfer_tag_statements` 与区传送相关或者控制区传送的。

:ref:`view_tag_statements` 与视图选择标准相关或者控制视图选择标准的，
典型情况下只出现在一个视图块内。

:ref:`zone_tag_statements` 与区行为相关或者控制区行为的，典型情况下只
出现在一个区块内。

:ref:`deprecated_tag_statements` 是那些现在已被废弃，但因为历史上的参
考而包含在这里。

下列表格列出所有在 :file:`named.conf` 中允许的语句，及其相关的标记；下
一节按标记组织语句。请注意这些部份是正在进行的工作。

.. namedconf:statementlist::

标记语句
--------
这些表格通过其相关的标记组织了在 :file:`named.conf` 中允许的各种语句。

.. _dnssec_tag_statements:

DNSSEC标记语句
~~~~~~~~~~~~~~
.. namedconf:statementlist::
   :filter_tags: dnssec

.. _logging_tag_statements:

日志标记语句
~~~~~~~~~~~~
.. namedconf:statementlist::
   :filter_tags: logging

.. _query_tag_statements:

查询标记语句
~~~~~~~~~~~~
.. namedconf:statementlist::
   :filter_tags: query

.. _security_tag_statements:

安全标记语句
~~~~~~~~~~~~
.. namedconf:statementlist::
   :filter_tags: security

.. _server_tag_statements:

服务标记语句
~~~~~~~~~~~~
.. namedconf:statementlist::
   :filter_tags: server

.. _transfer_tag_statements:

区传送标记语句
~~~~~~~~~~~~~~
.. namedconf:statementlist::
   :filter_tags: transfer

.. _view_tag_statements:

视图标记语句
~~~~~~~~~~~~
.. namedconf:statementlist::
   :filter_tags: view

.. _zone_tag_statements:

区标记语句
~~~~~~~~~~
.. namedconf:statementlist::
   :filter_tags: zone

.. _deprecated_tag_statements:

废弃标记语句
~~~~~~~~~~~~
.. namedconf:statementlist::
   :filter_tags: deprecated

.. _statistics:

BIND 9统计
-----------------

BIND 9维护许多统计信息并为用户提供几个接口来访问这些统计。可用的
统计包括在BIND 9中有意义的所有统计计数器，以及其它被认为有用的信
息。

统计信息分类成下列部份：

Incoming Requests（入向请求）
   对每个OPCODE的进入的DNS请求数目。

Incoming Queries（入向查询）
   对每个资源记录类型的进入的查询数目。

Outgoing Queries（出向查询）
   从内部解析器向外发出的对每个资源记录类型的查询数目，每个视图
   各自维护。

Name Server Statistics（名字服务器统计）
   关于进入请求处理的统计计数器。

Zone Maintenance Statistics（区维护统计）
   关于区维护操作，如区传送，的统计计数器。

Resolver Statistics（解析器统计）
   关于内部解析器所执行的名字解析的统计计数器，每个视图各自维护。

Cache DB RRsets（缓存数据资源记录集）
   与缓存内容相关的统计计数器，每个视图各自维护。

   “NXDOMAIN”计数器是被当做不存在被缓存的名字的数目。以资源记录类
   型命名的计数器指示在缓存数据库中每种类型的活跃资源记录集的数目。

   如果一个资源记录类型名字前面有一个惊叹号（!），它表示特定名字
   的类型不存在；这也被称为“NXRRSET”。如果一个资源记录类型名字前面有一
   个井号（#），它表示在缓存中且TTL已经过期的这种类型的资源记录
   集的数目；这些资源记录集仅用于旧回答被开启时。如果一个资源记
   录类型名字前面有一个波浪号（~），它表示出现在缓存数据库中但被
   标记为垃圾回收的这种类型的资源记录集的数目；这些资源记录集不
   能被使用。

Socket I/O Statistics（套接字I/O统计）
   网络相关事件的统计计数器。

对于服务器上的每个权威区，都收集并显示名字服务器统计的一个子集，
当 :any:`zone-statistics` 被设为 ``full`` （或 ``yes`` ），以便向后
兼容。参见 :ref:`options` 中对 :any:`zone-statistics` 更详细的描述。

这些统计计数器和它们的区和视图名一起显示。如果服务器没有显式配置
视图，视图名被省略。

当前有两种用户接口可以用来访问统计信息。一个是普通文本格式，导出
到由 :any:`statistics-file` 配置选项所指定的文件中；另一个是通过在
配置文件中的 :any:`statistics-channels` 语句所指定的统计通道远程访
问。（参见 :ref:`statschannels` ）。

.. _statsfile:

统计文件
~~~~~~~~~~~~~~~~~~~

文本格式的统计导出以类似下面这一行开始：

``+++ Statistics Dump +++ (973798949)``

括号中的数是标准的UNIX风格的时间戳，是自1970年1月1日以来的秒数。
后面紧接的行是一个统计信息的集合，其分类在上面已描述。每部份以
类似下面这一行开始：

``++ Name Server Statistics ++``

每个部份由一些行组成，每行包含统计计数器的值，后面有文本描述。
参见下面的可用的计数器。为简短起见，值为0的计数器没有显示在统
计文件中。

统计导出结束是一个带有与开始行同样数字的行；例如：

``--- Statistics Dump --- (973798949)``

.. _statistics_counters:

统计计数器
~~~~~~~~~~

下表概括了BIND 9所提供的统计计数器。对每个计数器，给出了其缩写
符号名；这些符号显示在可以通过HTTP统计通道访问的统计信息页面上。
对计数器的描述，也显示在统计文件上，但是，在本文档中，为了更好
的可读性可能做了一点修改。

.. _stats_counters:

名字服务器统计计数器
^^^^^^^^^^^^^^^^^^^^

``Requestv4``
   这指示收到的IPv4请求数量。注意：这也会记录非查询的请求。

``Requestv6``
   这指示收到的IPv6请求数量。注意：这也会记录非查询的请求。

``ReqEdns0``
   这指示收到的带EDNS(0)请求的数量。

``ReqBadEDN SVer``
   这指示收到的带有一个不支持的EDNS版本的请求的数量。

``ReqTSIG``
   这指示收到的带有TSIG的请求的数量。

``ReqSIG0``
   这指示收到的带有SIG(0)的请求的数量。

``ReqBadSIG``
   这指示收到的带有不正确（TSIG或SIG(0)）签名的请求的数量。

``ReqTCP``
   这指示收到的TCP请求的数量。

``AuthQryRej``
   这指示拒绝掉的权威（非递归）请求的数量。

``RecQryRej``
   这指示拒绝掉的递归查询的数量。

``XfrRej``
   这指示拒绝掉的区传送请求的数量。

``UpdateRej``
   这指示拒绝掉的动态更新请求的数量。

``Response``
   这指示已发出的响应的数量。

``RespTruncated``
   这指示已发出的截断响应的数量。

``RespEDNS0``
   这指示已发出的带EDNS(0)的响应的数量。

``RespTSIG``
   这指示已发出的带TSIG的响应的数量。

``RespSIG0``
   这指示已发出的带SIG(0)的响应的数量。

``QrySuccess``
   这指示导致一个成功回答的查询的数量，表示请求返回了一个NOERROR
   应答，并至少带有一个回答资源记录。这相当于先前BIND 9版本中的
   ``success`` 计数器。

``QryAuthAns``
   这指示导致一个权威回答的查询的数量。

``QryNoauthAns``
   这指示导致一个非权威回答的查询的数量。

``QryReferral``
   这指示导致一个引用回答的查询的数量。这相当于先前BIND 9版本中
   的 ``referral`` 计数器。

``QryNxrrset``
   这指示导致在NOERROR响应中没有数据的查询的数量。这相当于先前
   BIND 9版本中的 ``nxrrset`` 计数器。

``QrySERVFAIL``
   这指示导致SERVFAIL的查询的数量。

``QryFORMERR``
   这指示导致FORMERR的查询的数量。

``QryNXDOMAIN``
   这指示导致NXDOMAIN的查询的数量。这相当于先前BIND 9版本中的
   ``nxdomain`` 计数器。

``QryRecursion``
   这指示导致服务器执行递归解析以获取最终回答的查询的数量。这相
   当于先前BIND 9版本中的 :any:`recursion` 计数器。

``QryDuplicate``
   这指示导致服务器试图进行递归解析但是却发现已经存在一个具有同
   样IP地址、端口、查询ID、名字、类型和类的查询并且已经被处理过
   的查询的数量。这相当于先前BIND 9版本中的 ``duplicate`` 计数
   器。

``QryDropped``
   这指示服务器所发现的已有的对同一名字、类型和类的递归查询并随后被丢
   弃的巨量递归查询的数量。这是由于 :any:`clients-per-query` 和
   :any:`max-clients-per-query` 选项所解释的原因而被丢弃的查询的数目。
   这相当于先前BIND 9版本中的 ``dropped`` 计数器。

``QryFailure``
   这指示其它查询失败的数量。这相当于先前BIND 9版本中的 ``failure``
   计数器。注意：提供这个计数器主要是为了向后兼容以前的版本。通
   常情况一些更细粒度的计数器如 ``AuthQryRej`` 和 ``RecQryRej``
   也落在这个计数器范围中，所以在实际中，这个计数器的意义不大。

``QryNXRedir``
   这指示导致NXDOMAIN而被重定向的请求的数量。

``QryNXRedirRLookup``
   这指示导致NXDOMAIN而被重定向并且结果是一个成功的远程查询的请
   求的数量。

``XfrReqDone``
   这指示已完成的所请求的区传送的数量。

``UpdateReqFwd``
   这指示已转发的更新请求的数量。

``UpdateRespFwd``
   这指示已转发的更新响应的数量。

``UpdateFwdFail``
   这指示已失败的动态更新转发的数量。

``UpdateDone``
   这指示已完成的动态更新的数量。

``UpdateFail``
   这指示已失败的动态更新的数量。

``UpdateBadPrereq``
   这指示由于先决条件失败而被拒绝的动态更新的数量。

``RateDropped``
   这指示被比率限制丢弃的响应的数量。

``RateSlipped``
   这指示被比率限制截断的响应的数量。

``RPZRewrites``
   这指示响应策略区重写的数量。

.. _zone_stats:

区维护统计计数器
^^^^^^^^^^^^^^^^

``NotifyOutv4``
   这指示已发送的IPv4通知的数量。

``NotifyOutv6``
   这指示已发送的IPv6通知的数量。

``NotifyInv4``
   这指示已收到的IPv4通知的数量。

``NotifyInv6``
   这指示已收到的IPv6通知的数量。

``NotifyRej``
   这指示拒绝掉的进入通知的数量。

``SOAOutv4``
   这指示已发送的IPv4 SOA查询的数量。

``SOAOutv6``
   这指示已发送的IPv6 SOA查询的数量。

``AXFRReqv4``
   这指示已请求的IPv4 AXFR的数量。

``AXFRReqv6``
   这指示已请求的IPv6 AXFR的数量。

``IXFRReqv4``
   这指示已请求的IPv4 IXFR的数量。

``IXFRReqv6``
   这指示已请求的IPv6 IXFR的数量。

``XfrSuccess``
   这指示成功的区传送请求的数量。

``XfrFail``
   这指示失败的区传送请求的数量。

.. _resolver_stats:

解析器统计计数器
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Queryv4``
   这指示已发送的IPv4查询的数量。

``Queryv6``
   这指示已发送的IPv6查询的数量。

``Responsev4``
   这指示已收到的IPv4响应的数量。

``Responsev6``
   这指示已收到的IPv6响应的数量。

``NXDOMAIN``
   这指示已收到的NXDOMAIN的数量。

``SERVFAIL``
   这指示已收到的SERVFAIL的数量。

``FORMERR``
   这指示已收到的FORMERR的数量。

``OtherError``
   这指示已收到的其它错误的数量。

``EDNS0Fail``
   这指示EDNS(0)查询失败的数量。

``Mismatch``
   这指示已收到的不匹配响应的数量。意谓着DNS ID，响应的源地址
   和/或响应的源端口与期望的不匹配。（端口必须是53或 :namedconf:ref:`port` 所
   定义的。）这可能暗示一个缓存污染攻击。

``Truncated``
   这指示已收到的截断响应的数量。

``Lame``
   这指示已收到的不完整授权的数量。

``Retry``
   这指示执行过的查询重试的数量。

``QueryAbort``
   这指示由于配额控制而被终止的查询的数量。

``QuerySockFail``
   这指示打开查询套接字时的失败的数量。这类失败的一个通常原因是
   由于在文件描述符上的限制。

``QueryTimeout``
   这指示查询超时的数量。

``GlueFetchv4``
   这指示发起的取IPv4 NS的地址操作的数量。

``GlueFetchv6``
   这指示发起的取IPv6 NS的地址操作的数量。

``GlueFetchv4Fail``
   这指示失败的取IPv4 NS的地址操作的数量。

``GlueFetchv6Fail``
   这指示失败的取IPv6 NS的地址操作的数量。

``ValAttempt``
   这指示试探过的DNSSEC验证的数量。

``ValOk``
   这指示成功的DNSSEC验证的数量。

``ValNegOk``
   这指示在否定信息上成功的DNSSEC验证的数量。

``ValFail``
   这指示失败的DNSSEC验证的数量。

``QryRTTnn``
   这提供请求往返时间（RTT）的频率表。每个 ``nn`` 指定相应的频率。
   在序列 ``nn_1`` ， ``nn_2`` ，...， ``nn_m`` 中， ``nn_i`` 的
   值是其RTT在 ``nn_(i-1)`` （含）和 ``nn_i`` （不含）之间毫秒的请
   求的数目。为方便起见，我们将 ``nn_0`` 定义为0。最后的条目应该表
   示为 ``nn_m+`` ，它表示其RTT等于或大于 ``nn_m`` 毫秒的请求的数
   目。

.. _socket_stats:

套接字I/O统计计数器
^^^^^^^^^^^^^^^^^^^

套接字I/O统计计数器是按每种套接字类型定义的，它们是 ``UDP4`` （UDP/IPv4），
``UDP6`` （UDP/IPv6）， ``TCP4`` （TCP/IPv4）， ``TCP6`` （TCP/IPv6），
``Unix`` （Unix Domain）和 ``FDwatch`` （朝套接字模块外打开的套接字）。
在下面的表中 ``<TYPE>`` 表示一个套接字类型。并非所有套接字都可以使
用所有的计数器；在描述字段会说明例外情况。

``<TYPE>Open``
   这指示套接字成功打开的数量。这个计数器不适用于 ``FDwatch`` 类型。

``<TYPE>OpenFail``
   这指示套接字打开失败的数量。这个计数器不适用于 ``FDwatch`` 类型。

``<TYPE>Close``
   这指示套接字关闭的数量。

``<TYPE>BindFail``
   这指示绑定套接字失败的数量。

``<TYPE>ConnFail``
   这指示连接套接字失败的数量。

``<TYPE>Conn``
   这指示成功建立连接的数量。

``<TYPE>AcceptFail``
   这指示接受进入连接请求失败的数量。这个计数器不能用于 ``UDP`` 和
   ``FDwatch`` 类型。

``<TYPE>Accept``
   这指示成功接受进入连接请求的数量。这个计数器不能用于 ``UDP`` 和
   ``FDwatch`` 类型。

``<TYPE>SendErr``
   这指示套接字发送操作中的错误的数量。

``<TYPE>RecvErr``
   这指示套接字接收操作中的错误的数量。这包括在一个收到ICMP错误消
   息通知的已连接UDP套接字上发送操作的错误。
