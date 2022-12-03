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

.. _dlz-info:

DLZ (Dynamically Loadable Zones，动态加载区)
---------------------------------------------

动态加载区（DLZ）是一项BIND 9扩展，它允许直接从一个外部数据库中
提取区数据。它对格式或模式没有要求。已经存在对应几种不同的数据
库后端包括MySQL和LDAP的DLZ模块，也可以写其它驱动。

当DLZ模块以文本格式给 :iscman:`named` 提供数据，由 :iscman:`named` 转换为
DNS线上格式。这个转换缺乏任何内部缓存，给DLZ模块的查询性能带来
了重大限制。因此，不推荐在大访问量服务器上使用DLZ。然而，它可
以被用于一个隐藏主配置中，让辅服务器通过AXFR获取区更新。注意，
由于DLZ没有对DNS notify的内置支持；辅服务器不会收到数据库中区
变化的通知信息。

配置DLZ
~~~~~~~
.. namedconf:statement:: dlz
   :tags: zone
   :short: 在 :iscman:`named.conf` 中配置一个动态加载区（DLZ）数据库。

通过 :iscman:`named` 中的一个 :any:`dlz` 语句配置一个DLZ数据库：

::

       dlz example {
       database "dlopen driver.so args";
       search yes;
       };

这指定了一个在回复请求时要搜索的DLZ模块；这个模块在 ``driver.so``
中实现，并通过dlopen DLZ驱动在运行时装载。可以指定多个 :any:`dlz`
语句。


.. namedconf:statement:: search
   :tags: query
   :short: 指定是否为答复一个查询而查询一个动态加载区（DLZ）模块。

在回复一个请求时，所有 :namedconf:ref:`search` 被设置为 ``yes`` 的DLZ
模块都将被查询，以发现它们是否包含对请求名的答复；最好的可用答复将被返
回给客户端。

上述例子中的 :namedconf:ref:`search` 选项可以省略，因为 ``yes`` 是缺省
值。

如果 :namedconf:ref:`search` 被设置为 ``no`` ，在收到一个请求时，就
**不会** 在这个DLZ模块中查找最佳匹配。作为替代，在这个DLZ中的区必须在
一个zone语句中独立指定。这允许你使用标准的区选项语义配置一个区，同时却
指定一个不同的数据库后端来存储区数据。例如，使用一个DLZ模块作重定向规
则的后端存储来实现NXDOMAIN重定向：

::

       dlz other {
              database "dlopen driver.so args";
              search no;
       };

       zone "." {
              type redirect;
              dlz other;
       };


样例DLZ模块
~~~~~~~~~~~~~~~~~

为指导实现DLZ模块，目录 ``contrib/dlz/example`` 包含了一个基本
的动态可链接DLZ模块 - 即一个可以由“dlopen” DLZ驱动在运行时加载
的模块。这个例子建立了一个区，其名字作为 :any:`dlz` 语句中的一个
参数被传递给模块：

::

       dlz other {
              database "dlopen driver.so example.nil";
       };

在上面的例子中，模块被配置为建立一个区“example.nil”，它可以回
复查询和AXFR请求，并接受DDNS更新。在运行时，在任何更新的前面，
区中包含其顶点一条SOA记录，一条NS记录及一条A记录：

::

    example.nil.  3600    IN      SOA     example.nil. hostmaster.example.nil. (
                              123 900 600 86400 3600
                          )
    example.nil.  3600    IN      NS      example.nil.
    example.nil.  1800    IN      A       10.53.0.1

样例驱动能够提取关于请求客户端的信息，并基于这个信息修改它的响
应。为演示这个特性，例子驱动用请求的源地址响应对
“source-addr. ``zonename`` >/TXT”的请求。注意，这个记录将 **不会**
被包含到AXFR或ANY响应中。通常，这个特性用于以一些其它的方式修
改响应。例如，根据请求来自的不同网络而对同一个特定名字提供不同
的地址记录。

DLZ模块API的文档可以在 ``contrib/dlz/example/README`` 中找到。
这个目录也包含头文件 ``dlz_minimal.h`` ，后者定义了这个API并应
被包含在任何动态可链接DLZ模块中。
