.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

..
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")

   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/.

   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

.. Security:

BIND 9安全考虑
==============================

.. _Access_Control_Lists:

访问控制表
--------------------

访问控制表（Access Control Lists，ACL）是地址匹配表，你可以建立并命名，
以备以后用于 ``allow-notify`` ， ``allow-query`` ， ``allow-query-on`` ，
``allow-recursion`` ， ``blackhole`` ， ``allow-transfer`` ，
``match-clients`` 等语句中。

ACL允许对谁能够访问名字服务器有一个更精细的控制，而不会用巨大的IP地址
表将你的配置文件搞混乱。

使用ACL并控制对你的服务器的访问是一个 **好主意** 。限制外来者访问你的服
务器可以帮助阻止对你的服务器的欺骗和拒绝服务（DoS）攻击。

访问控制表根据三个特征来匹配客户端：1) 客户端的IP地址； 2) 用于签名请
求的TSIG或SIG(0)密钥，如果有的话；和 3) 编码在一个EDNS客户端子网选项
中的一个地址前缀，如果有的话。

这是一个基于客户端地址的ACL的例子：

::

   // Set up an ACL named "bogusnets" that blocks
   // RFC1918 space and some reserved space, which is
   // commonly used in spoofing attacks.
   acl bogusnets {
       0.0.0.0/8;  192.0.2.0/24; 224.0.0.0/3;
       10.0.0.0/8; 172.16.0.0/12; 192.168.0.0/16;
   };

   // Set up an ACL called our-nets. Replace this with the
   // real IP numbers.
   acl our-nets { x.x.x.x/24; x.x.x.x/21; };
   options {
     ...
     ...
     allow-query { our-nets; };
     allow-recursion { our-nets; };
     ...
     blackhole { bogusnets; };
     ...
   };

   zone "example.com" {
     type master;
     file "m/example.com";
     allow-query { any; };
   };

这将允许来自任何地址对 ``example.com`` 的权威请求，但是只有指定的网络
``our-nets`` 才能进行递归请求，并且指定网络 ``bogusnets`` 中的任何请
求都被禁止。

除了网络地址和前缀，这些与DNS请求中的源地址比对，之外，ACL也可包含
``key`` 元素，这是指定一个TSIG或者SIG(0)密钥的名字。

当BIND 9构建时带有GeoIP支持，ACL也可用于地理访问限制。这是通过指定一
个如下形式的ACL元素完成的： ``geoip db database field value`` 。

``field`` 指定在一个匹配中搜索哪个字段。可用的字段是 ``country`` ，
``region`` ， ``city`` ， ``continent`` ， ``postal`` （邮政编码），
``metro`` （城区编码）， ``area`` （区域编码）， ``tz`` （时区），
``isp`` ， ``asnum`` 和 ``domain`` 。

``value`` 是要在数据库中搜索的值，字符串需要用引号引上，如果其中包含
空格或其它特殊字符。一个对自治系统号的搜索 ``asnum`` 可以使用字符串
``ASNNNN`` 或整数NNNN来指定。当一个 ``country`` 搜索由两个字符的字符
串所指定时，它必须是一个标准的ISO-3166-1两字符国家码；否则它被解释成
国家的全名。类似的，如果搜索条目是 ``region`` 并且字符串是两个字符，
它被当成一个州或者省的标准两字母；否则它被当成州或省的全名。

``database`` 字段指定在一个匹配中搜索哪个GeoIP数据库。大多数情况下，
这不是必须的，因为大多数搜索字段仅能在一个数据库中找到。然而，对
``continent`` 或 ``country`` 的搜索可以从 ``city`` 或 ``country`` 数
据库中得到回答，所以对于这些搜索类型，指定一个 ``database`` 将强制请
求只从那个数据库，而不能是其它的数据库，得到回答。如果未指定
``database`` ，这些请求就将首先从 ``city`` 数据库得到回答，如果它被
安装了，然后从 ``country`` 数据库得到回答，如果它被安装了。有效的数
据库名字是 ``country`` ， ``city`` ， ``asnum`` ， ``isp`` 和
``domain`` 。

一些GeoIP ACL的例子：

::

   geoip country US;
   geoip country JP;
   geoip db country country Canada;
   geoip region WA;
   geoip city "San Francisco";
   geoip region Oklahoma;
   geoip postal 95062;
   geoip tz "America/Los_Angeles";
   geoip org "Internet Systems Consortium";

ACL使用一个“首先匹配”逻辑，而不是“最佳匹配”：如果一个地址前缀与一个
ACL元素匹配，则这个ACL就被认为匹配成立，即使一个稍后的元素将会匹配得
更准确。例如，ACL ``{ 10/8; !10.0.0.1; }`` 实际将会匹配来自10.0.0.1
的请求，因为第一个元素表明请求应该被接受，第二个元素就被忽略。

当使用“嵌套”ACL时（即，ACL包含或者被包含于其它ACL），一个嵌套ACL的否
定匹配将导致外部ACL继续查找以成功匹配。这使得可以构造复杂的ACL，在其
中，多个客户端特性可以被同时检查。例如，要构造一个允许仅来自一个特定
网络 **并且** 仅当其被一个特定密钥签名的请求的ACL，使用：

::

   allow-query { !{ !10/8; any; }; key example; };

在嵌套ACL中，任何 **不在** 10/8网络前缀中的地址都会被拒绝，这会终止ACL
的处理过程。任何 **在** 10/8网络前缀中的地址会被接受，但是这导致此嵌套
ACL的一个否定匹配，所以外部ACL继续处理。如果请求被密钥 ``example``
签名，它将被接受，否则将被拒绝。这样，这个ACL仅在 **两个** 条件都为真
时匹配。

.. _chroot_and_setuid:

``Chroot`` 和 ``Setuid``
-------------------------

在UNIX服务器上，可以通过为 ``named`` 设定 ``-t`` 选项使BIND运行在
**chroot的** 环境中（使用 ``chroot()`` 函数）。这可以帮助增进系统的安
全性，它通过将BIND放入一个“沙箱”，后者将在服务器遇到危险时把损坏限制
在一个局部范围内。

UNIX版本的BIND的另外一个能力是作为一个非特权用户（ ``-u`` user）身份
运行服务。我们建议在使用 ``chroot`` 特征时以一个非特权用户身份运行。

这里是有个命令行的例子，即将BIND加载到一个 ``chroot`` 沙箱，
``/var/named`` ，并且通过 ``setuid`` 以用户202的身份运行 ``named`` ：

``/usr/local/sbin/named -u 202 -t /var/named``

.. _chroot:

``chroot`` 环境
~~~~~~~~~~~~~~~~~

为了让一个 ``chroot`` 环境在一个特定目录（例如， ``/var/named`` ）中
正常工作，环境必须包含BIND运行所需的所有东西。从BIND的视角，
``/var/named`` 是文件系统的根；必须调整像 ``directory`` 和 ``pid-file``
这样的选项的值来满足这个需求。

与BIND的早期版本不同，典型地， **不** 需要静态地编译 ``named`` ，也不
需要在新的根下面安装共享库。然而，依赖于操作系统，可能需要设置诸如这
样的路径： ``/dev/zero`` ， ``/dev/random`` ， ``/dev/log`` 以及
``/etc/localtime`` 。

.. _setuid:

使用 ``setuid`` 函数
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

在运行 ``named`` 服务之前，在BIND要写的文件上使用 ``touch`` 应用程序
（改变文件访问和修改时间）或者 ``chown`` 应用程序（设置用户id和/或组
id）。

.. note::

   如果 ``named`` 后台进程是以一个非特权用户身份运行的，如果服务器重
   新加载，它将不能够绑定到新的受限端口上。

.. _dynamic_update_security:

动态更新的安全
-----------------------

应该严格限制对动态更新设施的访问。在早期的BIND版本中，仅有的方法是基
于请求进行动态更新的主机的IP地址，通过在 ``allow-update`` 区选项中列
出一个IP地址或者网络前缀来实现。由于更新UDP包的源地址非常容易伪造，
这个方法是不安全的。另外要注意的是，如果 ``allow-update`` 选项中所允
许的地址包含一个可以执行转发动态更新的辅服务器的IP地址，主服务器将可
能遭受到很简单的攻击，即通过发送更新到辅服务器，辅服务器使用自己的地
址作源地址将其转发到主服务器 - 使主服务器毫无怀疑地接受。

由于这些原因，我们强烈推荐通过事务签名（TSIG）来加密和认证所进行的更
新。这就是说， ``allow-update`` 选项仅应该列出TSIG密钥名，而不是IP地
址或网络前缀。作为另外的选择，也可以使用新的 ``update-policy`` 选项。

一些站点选择将所有的动态更新的DNS数据保存到一个子域并将子域授权到一
个单独的区。在这种方法中，包含像公共web和邮件服务器的IP地址这样的关
键数据的顶级区就完全不允许对其进行动态更新。
