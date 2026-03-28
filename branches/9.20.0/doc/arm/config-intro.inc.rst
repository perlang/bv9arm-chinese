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

.. _configuration:

.. _sample_configuration:

配置和区文件
============

介绍
----

BIND 9使用一个配置文件 :ref:`named.conf <named_conf>` 。典型情况下，
它位于/etc/namedb目录或者/usr/local/etc/namedb目录。

   .. Note:: 如果本地使用（与BIND 9在同一台主机上）
      :ref:`rndc<ops_rndc>` ，可能需要一个额外的文件
      :iscman:`rndc.conf` ，即使 :iscman:`rndc` 操作不会用到它。如果在
      一个远程主机上运行 :iscman:`rndc` ，就必须提供一个
      :iscman:`rndc.conf` 文件，因为它定义了连接特性和属性。

依赖于系统的功能，需要一个或多个区文件。

本章和后续章节所给出的例子对 :iscman:`named.conf` 和 **example.com** 区
文件都使用了标准基本格式。其目的是让读者看到在添加或删除功能时，从一个
公共基础上的演变。

.. _base_named_conf:

``named.conf`` 基本文件
~~~~~~~~~~~~~~~~~~~~~~~

这个文件展示了 :iscman:`named.conf` 用到的典型格式和布局风格，并提供了
一个基本的日志服务，它可以按照用户的需求进行扩展。

.. code-block:: c

        // base named.conf file
        // Recommended that you always maintain a change log in this file as shown here
        // options clause defining the server-wide properties
        options {
          // all relative paths use this directory as a base
          directory "/var";
          // version statement for security to avoid hacking known weaknesses
          // if the real version number is revealed
          version "not currently available";
        };

        // logging clause
        // log to /var/log/named/example.log all events from info UP in severity (no debug)
        // uses 3 files in rotation swaps files when size reaches 250K
        // failure messages that occur before logging is established are
        // in syslog (/var/log/messages)
        //
        logging {
          channel example_log {
            // uses a relative path name and the directory statement to
            // expand to /var/log/named/example.log
            file "log/named/example.log" versions 3 size 250k;
            // only log info and up messages - all others discarded
            severity info;
          };
          category default {
            example_log;
          };
        };

:any:`logging` 和 :namedconf:ref:`options` 块
以及 :any:`category` ， :any:`channel` ，
:any:`directory` ， :any:`file` 和 :any:`severity`
语句在这个管理员参考手册的合适章节都有更多的描述。

.. _base_zone_file:

**example.com** 基本区文件
~~~~~~~~~~~~~~~~~~~~~~~~~~

下面是域 **example.com** 的完整区文件，它演示了一些共同特性。文件中的
注释在适当的地方解释了这些特性。区文件由 :ref:`资源记录 (RR)
<zone_file>` 组成，它描述了区的特性和属性。

.. code-block::

        ; base zone file for example.com
        $TTL 2d    ; default TTL for zone
        $ORIGIN example.com. ; base domain-name
        ; Start of Authority RR defining the key characteristics of the zone (domain)
        @         IN      SOA   ns1.example.com. hostmaster.example.com. (
                                        2003080800 ; serial number
                                        12h        ; refresh
                                        15m        ; update retry
                                        3w         ; expiry
                                        2h         ; minimum
                                        )
        ; name server RR for the domain
                   IN      NS      ns1.example.com.
        ; the second name server is external to this zone (domain)
                   IN      NS      ns2.example.net.
        ; mail server RRs for the zone (domain)
                3w IN      MX  10  mail.example.com.
        ; the second  mail servers is  external to the zone (domain)
                   IN      MX  20  mail.example.net.
        ; domain hosts includes NS and MX records defined above
        ; plus any others required
        ; for instance a user query for the A RR of joe.example.com will
        ; return the IPv4 address 192.168.254.6 from this zone file
        ns1        IN      A       192.168.254.2
        mail       IN      A       192.168.254.4
        joe        IN      A       192.168.254.6
        www        IN      A       192.168.254.7
        ; aliases ftp (ftp server) to an external domain
        ftp        IN      CNAME   ftp.example.net.

这种类型的区文件频繁地作为一个 **正向映射区文件** 被提及，因为个将域名
映射为其它一些值，而 :ref:`反向映射区文件<ipv4_reverse>` 将
一个IP地址映射到一个域名。这个区文件被称为 **example.com** ，除了它是
它所描述的区的域名以外，没有其它好的原因；和往常一样，用户可以自由使用
任何适合其需求的文件命名约定。

其它区文件
~~~~~~~~~~

根据配置的不同，可能会出现或应该出现其他区文件。这里简要介绍它们的格式
和功能。

本地区文件
~~~~~~~~~~

所有终端用户系统都带有一个 ``hosts`` 文件（通常位于/etc下）。这个文件
通常配置为将名字 **localhost** （应用程序在本地运行时使用的名字）映射
到环回地址。因此，有理由认为， **localhost** 的正向映射区文件不是必要
的。由于下列原因，本手册在所有配置例子中使用BIND 9分发文件
``localhost-forward.db`` （通常在/etc/namedb/master或
/usr/local/etc/namedb/master目录）：

1. 许多用户由于安全原因，选择删除 ``hosts`` 文件（它是严重的域名重定
   向/污染攻击的潜在目标）。

2. 系统通常首先使用 ``hosts`` 文件来查找如何名字（包括域名），然后是
   DNS。然而， ``nsswitch.conf`` 文件（典型在/etc下）控制这个顺序（通
   常为 **hosts: file dns** ），可以修改这个顺序或者完全删除 **file**
   值，这依赖于本地需求。除非BIND管理员控制这个文件并清楚其中的值，否
   则就假设 **localhost** 正向解析正确是不安全的。

3. 作为对用户的提醒，即对 **localhost** 的不必要的查询，会在公网上形成
   大量DNS请求，这影响所有用户的DNS性能。

因此，用户可以自行选择不实现该文件，因为，根据操作环境，它可能不是必需
的。

以下完整展示了BIND 9分发文件 ``localhost-forward.db`` 格式，并提供了
IPv4和IPv6的本地主机解析。区（域）名是 **localhost.** 。

.. code-block::

        $TTL 3h
        localhost.  SOA      localhost.  nobody.localhost. 42  1d  12h  1w  3h
                    NS       localhost.
                    A        127.0.0.1
                    AAAA     ::1

.. NOTE:: 有一定年龄或性格的读者可能会注意到这个文件中对已故的道格拉
   斯·诺埃尔·亚当斯的提及。

本地反向映射区文件
~~~~~~~~~~~~~~~~~~

这个区文件允许任何与环回地址（127.0.0.1）有关的名字。这个文件对于阻止
不必要的请求到达公共DNS体系是必要的。BIND 9发布的文件 ``localhost.rev``
展示了完整的文件：

.. code-block::

        $TTL 1D
        @        IN        SOA  localhost. root.localhost. (
                                2007091701 ; serial
                                30800      ; refresh
                                7200       ; retry
                                604800     ; expire
                                300 )      ; minimum
                 IN        NS    localhost.
        1        IN        PTR   localhost.
