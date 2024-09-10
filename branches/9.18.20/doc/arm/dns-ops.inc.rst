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

.. _ns_operations:

名字服务器操作
--------------

.. _tools:

用于名字服务器后台进程的工具
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

本节描述了几个绝对必要的诊断，管理和监控工具，它们是提供给
系统管理员进行控制和调试名字服务器的。

.. _diagnostic_tools:

诊断工具
^^^^^^^^

:iscman:`dig` ， :iscman:`host` 和
:iscman:`nslookup` 程序都是用于手工向服务器发请求的命令行
工具。他们在输入风格和输出格式上不相同。

:iscman:`dig`
   :iscman:`dig` 是这些查询工具中最多功能的。它有两种
   模式：简单交互模式，用于单个请求，和批处理模式，对有多个请求的
   名单中的每一个执行请求。所有选项都可以从命令行访问。

   关于更多的可用命令和选项的清单，参见 :ref:`man_dig` 。

:iscman:`host`
   :iscman:`host` 工具强调简单和易用。缺省情况下，
   它在主机名和互联网地址之间互相转换，但它的功能也可使用选项
   扩展。

   关于更多的可用命令和选项的清单，参见 :ref:`man_host` 。

:iscman:`nslookup`
   :iscman:`nslookup` 有两种模式：交互式和非交互式。
   交互模式允许使用者向名字服务器发出对各种主机和域名信息
   的查询请求，或者打印出一个域下面的主机列表。非交互模式
   只能用于打印所查询的某个主机或域的名字和请求信息。

   由于其神秘的用户界面和频繁的不一致表现，我们不推荐使用
   :iscman:`nslookup` 。而使用 :iscman:`dig` 替代。

.. _admin_tools:

管理工具
^^^^^^^^

管理工具在一个服务器的管理中扮演一个不可或缺的角色。

:iscman:`named-checkconf`
   :iscman:`named-checkconf` 程序用来检查一个 :iscman:`named.conf` 文件的语法。

   更多信息及一个可用的命令和选项的列表，参见 :ref:`man_named-checkconf` 。

:iscman:`named-checkzone`
   :iscman:`named-checkzone` 程序用来检查一个区文件的语法和一致性。

   更多信息及一个可用的命令和选项的列表，参见 :ref:`man_named-checkzone` 。

:iscman:`named-compilezone`
   这个工具与 :iscman:`named-checkzone` 相似，但它总是将区的内容转储
   到一个指定的文件（通常是一个与区文件不同的格式）。

   更多信息及一个可用的命令和选项的列表，参见 :ref:`man_named-compilezone` 。

.. _ops_rndc:

:iscman:`rndc`
   远程名字服务控制（remote name daemon control，
   :iscman:`rndc` ）程序允许系统管理员控制一个名字服务器
   的运行。

   关于可用的 :iscman:`rndc` 命令细节，参见 :ref:`man_rndc` 。

   :iscman:`rndc` 需要一个配置文件，由于所有与服务器的通信都使用依赖共享密钥
   的数字签名来认证，并且没有其它方式可以比配置文件提供更好的保密方式。
   :iscman:`rndc` 配置文件的缺省路径是 |rndc_conf| ，但也可以使用 :option:`-c <rndc -c>`
   选项来指定一个其它的路径。如果 :iscman:`rndc` 没有找到配置文件，它将会查找
   |rndc_key| （或者是 BIND 构建时由 ``sysconfdir`` 所定义的
   其它目录）。
   ``rndc.key`` 文件是由 :option:`rndc-confgen -a` 所生成，如在
   :any:`controls` 中所描述。

   配置文件的格式类似于 :iscman:`named.conf` 的格式，但是限于三个块，
   :rndcconf:ref:`options` ， :rndcconf:ref:`key` ，
   :rndcconf:ref:`server` 和 :ref:`include_grammar` 。这些块
   都是与密钥相关的，服务器使用这些密钥共享密钥。块的顺序没有关系。

.. rndcconf:statement:: options

   .. rndcconf:statement:: default-server

      :any:`default-server` 需要一个主机名或IP地址参数，它表示一个要连
      接的服务器，如果未在命令行中提供 :option:`-s <rndc -s>` 选项。

   .. rndcconf:statement:: default-key

      :any:`default-key` 以一个密钥的名字作为其参数，密钥是在
      :rndcconf:ref:`key` 块中定义的。

   .. rndcconf:statement:: default-port

      :any:`default-port` 指定 :iscman:`rndc` 应连接到的端口，如果在命
      令行或 :rndcconf:ref:`server` 块中没有给出端口时。

   .. rndcconf:statement:: default-source-address
   .. rndcconf:statement:: default-source-address-v6

      :any:`default-source-address` 和 :any:`default-source-address-v6`
      指定用于与服务器通信的IPv4和IPv6源地址，如果在命令行或
      :rndcconf:ref:`server` 块中没有给出地址时。

.. rndcconf:statement:: key

   :rndcconf:ref:`key` 块定义 :iscman:`rndc` 同 :iscman:`named` 进行认
   证时要用到的密钥。其语法与 :iscman:`named.conf` 中的
   :namedconf:ref:`key` 语句相同。 :rndcconf:ref:`key` 关键字后跟一个
   密钥名，它必须是一个有效的域名，尽管它并不需要处于实际的域名层次结
   构中；因而，一个像 ``rndc_key`` 这样的字符串也是一个有效的名字。
   :rndcconf:ref:`key` 块有两个子句： :rndcconf:ref:`algorithm` 和
   :rndcconf:ref:`secret` 。
   
   .. rndcconf:statement:: algorithm

      配置分析器将接受任何字符串作为 :rndcconf:ref:`algorithm` 的参
      数，当前只有字符串 ``hmac-md5`` ， ``hmac-sha1`` ，
      ``hmac-sha224`` ， ``hmac-sha256`` ， ``hmac-sha384`` 和
      ``hmac-sha512`` 有意义。
      
   .. rndcconf:statement:: secret

      这个密钥是一个在 :rfc:`3548` 中所指定的Base64编码的字符串。

.. rndcconf:statement:: server

   :rndcconf:ref:`server` 块为一个给定的服务器指定连接参数。服务器可以
   指定为主机名或者地址。

   .. rndcconf:statement:: addresses

      指定与这个服务器通信时使用的一个或者多个地址。

   :rndcconf:ref:`key`
      将一个由 :rndcconf:ref:`key` 语句定义的密钥与一台服务器关联起来。

   .. rndcconf:statement:: port

      指定 :iscman:`rndc` 用来连接到这个服务器所用的端口。

   .. rndcconf:statement:: source-address
   .. rndcconf:statement:: source-address-v6

      为这台指定的服务器覆盖 :rndcconf:ref:`default-source-address` 和
      :rndcconf:ref:`default-source-address-v6` 。

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

   这个文件，如果是作为 |rndc_conf| 安装，允许以下命令：

   :option:`rndc reload`

   经过 953 端口连接到 127.0.0.1 并使名字服务器重新装载，如果一个
   运行在本机的名字服务器使用了以下的控制语句：

   ::

      controls {
          inet 127.0.0.1
              allow { localhost; } keys { rndc_key; };
      };

   并且它有一个对应于 ``rndc_key`` 的 key 块的话。

   运行 :iscman:`rndc-confgen` 程序将会方便地创建一个 :iscman:`rndc.conf`
   文件，并且会显示所需要添加到 :iscman:`named.conf` 中的相关的
   :any:`controls` 语句。另外一个选择是，可以运行 :option:`rndc-confgen -a`
   来建立一个 ``rndc.key`` 文件，就一点也不用修改 :iscman:`named.conf` 了。

信号
~~~~~~~

某些Unix信号将使名字服务器执行特定的动作，如下表所列。
这些信号可以由 ``kill`` 命令发出。

+--------------+-------------------------------------------------------+
| ``SIGHUP``   | 使服务器读 :iscman:`named.conf` 并重新装载数据库。    |
+--------------+-------------------------------------------------------+
| ``SIGTERM``  | 使服务器清理并退出。                                  |
+--------------+-------------------------------------------------------+
| ``SIGINT``   | 使服务器清理并退出。                                  |
+--------------+-------------------------------------------------------+

