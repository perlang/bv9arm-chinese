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

.. Configuration:

名字服务器配置
=========================

在本章，我们提供一些建议的配置和使用其的准则。我们建议给某些选项设置
合理的值。

.. _sample_configuration:

样例配置
---------------------

.. _cache_only_sample:

一个只缓存名字服务器
~~~~~~~~~~~~~~~~~~~~~~~~~~

下列配置样例适合用于一个只缓存名字服务器，由一个公司的内部客户端
所使用。
通过使用 ``allow-query`` 选项，所有外来客户端的请求都被
拒绝。使用合适的防火墙规则也可以取得同样的效果。

::

   // Two corporate subnets we wish to allow queries from.
   acl corpnets { 192.168.4.0/24; 192.168.7.0/24; };
   options {
        // Working directory
        directory "/etc/namedb";

        allow-query { corpnets; };
   };
   // Provide a reverse mapping for the loopback
   // address 127.0.0.1
   zone "0.0.127.in-addr.arpa" {
        type primary;
        file "localhost.rev";
        notify no;
   };

.. _auth_only_sample:

一个只权威名字服务器
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

这个样例配置是给只权威服务器的，在这里服务器作
``example.com`` 的主服务器和其子域
``eng.exmaple.com`` 的辅服务器。

::

   options {
        // Working directory
        directory "/etc/namedb";
        // Do not allow access to cache
        allow-query-cache { none; };
        // This is the default
        allow-query { any; };
        // Do not provide recursive service
        recursion no;
   };

   // Provide a reverse mapping for the loopback
   // address 127.0.0.1
   zone "0.0.127.in-addr.arpa" {
        type primary;
        file "localhost.rev";
        notify no;
   };
   // We are the primary server for example.com
   zone "example.com" {
        type primary;
        file "example.com.db";
        // IP addresses of secondary servers allowed to
        // transfer example.com
        allow-transfer {
         192.168.4.14;
         192.168.5.53;
        };
   };
   // We are a secondary server for eng.example.com
   zone "eng.example.com" {
        type secondary;
        file "eng.example.com.bk";
        // IP address of eng.example.com primary server
        primaries { 192.168.4.12; };
   };

.. _load_balancing:

负载均衡
--------------

使用DNS对一个名字配置多个记录（例如多个A记录）
可以完成原始形式的负载均衡。

例如，如果你有3 台 HTTP 服务器分别使用10.0.0.1，10.0.0.2和10.0.0.3
的网络地址，像以下这个记录集就意味着客户端将会分别对每台机器有
三分之一的连接时间：

+-----------+------+----------+----------+----------------------------+
| Name      | TTL  | CLASS    | TYPE     | Resource Record (RR) Data  |
+-----------+------+----------+----------+----------------------------+
| www       | 600  |   IN     |   A      |   10.0.0.1                 |
+-----------+------+----------+----------+----------------------------+
|           | 600  |   IN     |   A      |   10.0.0.2                 |
+-----------+------+----------+----------+----------------------------+
|           | 600  |   IN     |   A      |   10.0.0.3                 |
+-----------+------+----------+----------+----------------------------+

当一个解析器请求这些记录时，BIND将滚动这三个记录，
以一个不同的顺序响应请求。在上面的例子中，不同的客户端将会随机收到以
1，2，3；2，3，1 和 3，1，2的顺序的
记录。大多数客户端将使用所得到的第一个记录而丢弃其余的。

关于将响应排序的更详细的内容，检查 ``options``
语句的 ``rrset-order`` 子语句，参见 :ref:`rrset_ordering` 。

.. _ns_operations:

名字服务器操作
----------------------

.. _tools:

用于名字服务器后台进程的工具
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

本节描述了几个绝对必要的诊断，管理和监控工具，它们是提供给
系统管理员进行控制和调试名字服务器的。

.. _diagnostic_tools:

诊断工具
^^^^^^^^^^^^^^^^

``dig`` ， ``host`` 和
``nslookup`` 程序都是用于手工向服务器发请求的命令行
工具。他们在输入风格和输出格式上不相同。

``dig``
   ``dig`` 是这些查询工具中最多功能的。它有两种
   模式：简单交互模式，用于单个请求，和批处理模式，对有多个请求的
   名单中的每一个执行请求。所有选项都可以从命令行访问。

   ``dig [@server] domain [query-type][query-class][+query-option][-dig-option][%comment]``

   经常使用的 ``dig`` 的简单形式是

   ``dig @server domain query-type query-class``

   关于更多的可用命令和选项的清单，参见 ``dig`` 的手册页。

``host``
   ``host`` 工具强调简单和易用。缺省情况下，
   它在主机名和互联网地址之间互相转换，但它的功能也可使用选项
   扩展。

   ``host [-aCdlnrsTwv][-c class][-N ndots][-t type][-W timeout][-R retries]
   [-m flag][-4][-6] hostname [server]``

   关于更多的可用命令和选项的清单，参见 ``host`` 的手册页。

``nslookup``
   ``nslookup`` 有两种模式：交互式和非交互式。
   交互模式允许使用者向名字服务器发出对各种主机和域名信息
   的查询请求，或者打印出一个域下面的主机列表。非交互模式
   只能用于打印所查询的某个主机或域的名字和请求信息。

   ``nslookup [-option][ [host-to-find]|[-[server]] ]``

   在没有给出参数（使用缺省的名字服务器）或者第一个参数是
   连字符（ ``-`` ）并且第二个参数是主机名或者是一台名字服务器的
   IP地址时，就进入了交互模式。

   当需要查找的名字或者主机的IP 地址作为第一个参数给出时，就
   使用非交互模式。可选的第二个参数指定主机名或者一台名字服务器
   的地址。

   由于其神秘的用户界面和频繁的不一致表现，我们不推荐使用
   ``nslookup`` 。而使用 ``dig`` 替代。

.. _admin_tools:

管理工具
^^^^^^^^^^^^^^^^^^^^

管理工具在一个服务器的管理中扮演一个不可或缺的角色。

``named-checkconf``
   ``named-checkconf`` 程序用来检查一个 ``named.conf`` 文件的语法。

   ``named-checkconf [-jvz][-t directory][filename]``

``named-checkzone``
   ``named-checkzone`` 程序用来检查一个区文件的语法和一致性。

   ``named-checkzone [-djqvD][-c class][-o output][-t directory][-w directory]
   [-k (ignore|warn|fail)][-n (ignore|warn|fail)][-W (ignore|warn)] zone [filename]``

``named-compilezone``
   这个工具与 ``named-checkzone`` 相似，但它总是将区的内容转储
   到一个指定的文件（通常是一个与区文件不同的格式）。

``rndc``
   远程名字服务控制（remote name daemon control，
   ``rndc`` ）程序允许系统管理员控制一个名字服务器
   的运行。
   如果不带任何参数运行 ``rndc`` ，它显示出以下的用法信息：

   ``rndc [-c config][-s server][-p port][-y key] command [command...]``

   关于可用的 ``rndc`` 命令细节，参见 :ref:`man_rndc` 。

   ``rndc`` 需要一个配置文件，由于所有与服务器的通信都使用依赖共享密钥
   的数字签名来认证，并且没有其它方式可以比配置文件提供更好的保密方式。
   ``rndc`` 配置文件的缺省路径是 ``/etc/rndc.conf`` ，但也可以使用 ``-c``
   选项来指定一个其它的路径。如果 ``rndc`` 没有找到配置文件，它将会查找
   ``/etc/rndc.key`` （或者是 BIND 构建时由 ``sysconfdir`` 所定义的
   其它目录）。
   ``rndc.key`` 文件是由 ``rndc-confgen -a`` 所生成，如在
   :ref:`controls_statement_definition_and_usage` 中所描述。

   配置文件的格式类似于 ``named.conf`` 的格式，但是只有四个语句，
   ``options`` ， ``key`` ， ``server`` 和 ``include`` 语句。这些语句
   都是与密钥相关的，服务器使用这些密钥共享密钥。语句的顺序没有关系。

   ``options`` 语句有三个子句： ``default-server`` ， ``default-key`` 和
   ``default-port`` 。 ``default-server`` 需要一个主机名或IP地址参数，
   它表示一个要连接的服务器，如果服务器未在命令行中以
   ``-s`` 选项指定。
   ``default-key`` 以一个密钥的名字作为其参数,密钥是在 ``key`` 语句中
   定义的。
   ``default-port`` 指定 ``rndc`` 用到的缺省端口，它在命令行或
   ``server`` 语句中没有指定端口的情况下生效。

   ``key`` 语句定义 ``rndc`` 同 ``named`` 进行认证时要用到的密钥。
   其语法与 ``named.conf`` 中的 ``key`` 语句相同。
   ``key`` 关键字后跟一个密钥名，它必须是一个有效的域名，尽管它并不需要
   处于实际的域名层次结构中；因而，一个像 ``rndc_key`` 这样的字符串也是
   一个有效的名字。 ``key`` 语句有两个子句： ``algorithm`` 和
   ``secret`` 。配置分析器将接受任何字符串作为 ``algorithm`` 的参数，当
   前只有字符串 ``hmac-md5`` ，
   ``hmac-sha1`` ， ``hmac-sha224`` ， ``hmac-sha256`` ，
   ``hmac-sha384`` 和 ``hmac-sha512`` 有意义。这个密钥是一个在
   :rfc:`3548` 中所指定的Base64编码的字符串。

   ``server`` 语句将一个由 ``key`` 语句定义的密钥与一台服务器结合起来。
   关键字 ``server`` 后跟一个主机名或 IP 地址。
   ``server`` 语句有两个子句： ``key`` 和 ``port`` 。
   ``key`` 子句指定用于同这个服务器通信的密钥， ``port`` 子句用于指定
   ``rndc`` 用来连接到这个服务器所用的端口。

   以下是一个最小配置文件的样例：

   ::

      key rndc_key {
           algorithm "hmac-sha256";
           secret
             "c3Ryb25nIGVub3VnaCBmb3IgYSBtYW4gYnV0IG1hZGUgZm9yIGEgd29tYW4K";
      };
      options {
           default-server 127.0.0.1;
           default-key    rndc_key;
      };

   这个文件，如果是作为 ``/etc/rndc.conf`` 安装，允许以下命令：

   ``$ rndc reload``

   经过 953 端口连接到 127.0.0.1 并使名字服务器重新装载，如果一个
   运行在本机的名字服务器使用了以下的控制语句：

   ::

      controls {
          inet 127.0.0.1
              allow { localhost; } keys { rndc_key; };
      };

   并且它有一个对应于 ``rndc_key`` 的 key 语句的话。

   运行 ``rndc-confgen`` 程序将会方便地创建一个 ``rndc.conf``
   文件，并且会显示所需要添加到 ``named.conf`` 中的相关的
   ``controls`` 语句。另外一个选择是，可以运行 ``rndc-confgen -a``
   来建立一个 ``rndc.key`` 文件，就一点也不用修改 ``named.conf`` 了。

信号
~~~~~~~

某些Unix信号将使名字服务器执行特定的动作，如下表所列。
这些信号可以由 ``kill`` 命令发出。

+--------------+-------------------------------------------------------+
| ``SIGHUP``   | 使服务器读 ``named.conf`` 并重新装载数据库。          |
+--------------+-------------------------------------------------------+
| ``SIGTERM``  | 使服务器清理并退出。                                  |
+--------------+-------------------------------------------------------+
| ``SIGINT``   | 使服务器清理并退出。                                  |
+--------------+-------------------------------------------------------+

.. include:: plugins.rst
