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

.. iscman:: filter-aaaa
.. _man_filter-aaaa:

filter-aaaa.so - 当A记录存在时从DNS响应中过滤AAAA记录
---------------------------------------------------------------

概要
~~~~~~~~

:program:`plugin query` "filter-aaaa.so" [{ parameters }];

描述
~~~~~~~~~~~

:program:`filter-aaaa.so` 是一个 :iscman:`named` 的请求插件模块，使 :iscman:`named`
能够在给客户端响应时省略某些IPv6地址。

在BIND 9.12之前，这个特性是在 :iscman:`named` 中原生实现的，并使用
``filter-aaaa`` ACL及 ``filter-aaaa-on-v4`` 和 ``filter-aaaa-on-v6``
选项开启。这些选项现在在 :iscman:`named.conf` 中已被废弃，但是可以作为参数
传送给 :program:`filter-aaaa.so` 插件，例如：

::

   plugin query "filter-aaaa.so" {
           filter-aaaa-on-v4 yes;
           filter-aaaa-on-v6 yes;
           filter-aaaa { 192.0.2.1; 2001:db8:2::1; };
   };

这个模块旨在协助从IPv4到IPv6的迁移，当正在查找的名称有一个可用
的IPv4地址时，阻止将IPv6地址返回给没有IPv6连接的DNS客户端。不
推荐使用这个模块，除非绝对需要。

注意：这个机制可能错误地导致其它服务器不对其客户端返回AAAA记录。
如果一个具有IPv6和IPv4双栈网络连接的递归服务器使用这个机制通过
IPv4请求一个权威服务器，它将拒绝AAAA记录，即使其客户端使用IPv6。

选项
~~~~~~~

``filter-aaaa``
   本选项指定一个客户端地址列表，对这些地址应用AAAA过滤。缺省是
   ``any`` 。

``filter-aaaa-on-v4``
   如果设置为 ``yes`` ，本选项指示DNS客户端是 ``filter-aaaa`` 中的一个
   IPv4地址，如果响应中不包括DNSSEC签名，那么响应中的所有AAAA记录
   都被删除。这个过滤动作应用到所有响应，不只是权威响应。

   如果设置为 ``break-dnssec`` ，即使DNSSEC开启，也会删掉AAAA
   记录。如同名字所揭示的，这会导致对响应的验证失败，因为DNSSEC
   协议就是设计用来检测删除的。

   这个机制可能错误地导致其它服务器不对其客户端返回AAAA记录。
   如果一个具有IPv6和IPv4双栈网络连接的递归服务器使用这个机制通过
   IPv4请求一个权威服务器，它将拒绝AAAA记录，即使其客户端使用
   IPv6。

``filter-aaaa-on-v6``
   本选项与 ``filter-aaaa-on-v4`` 相同，只是它过滤来自IPv6客户端而不
   是IPv4客户端查询的AAAA响应。要过滤所有响应，将两个选项都设
   置为 ``yes`` 。

参见
~~~~~~~~

BIND 9管理员参考手册。
