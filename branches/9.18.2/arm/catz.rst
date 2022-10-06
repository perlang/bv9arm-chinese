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

.. _catz-info:

目录区
-------------

一个“目录区”是一个特定的DNS区，它包含一个用于服务的区的列表，以及这
些区的配置参数。在目录区中列出的区被称为“member zones”（成员区）。
当一个目录区被装载或传送给一个支持这个功能的辅服务器时，辅服务器将
会自动建立成员区。当目录区被更新后（例如，增加或删除成员区，或修改
成员区的配置参数），这些变化会立即生效。因为目录区是一个普通的DNS区，
这些配置变化可以使用标准的AXFR/IXFR区传送机制扩散。

为了多个DNS实现的互操作性，目录区的格式和行为被规范到一个互联网草案。
最新版的DNS目录区草案可以在这里找到：
https://datatracker.ietf.org/doc/draft-toorop-dnsop-dns-catalog-zones/ 。

操作原理
~~~~~~~~~~~~~~~~~~~~~~

普通地，如果一个区由一个辅服务器服务提供服务，服务器上的
:iscman:`named.conf` 文件必须列出区，或者区必须使用 :option:`rndc addzone`
添加。在一个大量辅服务器和/或其中所服务的区被频繁修改，在所有辅
服务器上维护区配置的一致性的成本就会很大。

一个目录区是一种减小这个管理负担的方法。它是一个列出应在辅服务器上
提供服务的成员区的DNS区。当一个辅服务器收到一个对目录区的更新，它
基于所收到的数据增加、删除或者重新配置成员区。

要使用一个目录区，首先必须在主服务器上作为一个普通区设置好，并在
辅服务器上配置成使用它。它必须被添加到 :iscman:`named.conf` 中 ``options``
或 ``view`` 语句的一个 ``catalog-zones`` 列表中。与之相对的方式是，
一个策略区作为一个普通区配置并且也在一个 ``response-policy`` 语句
中列出。

使用目录区特性提供一个新的成员区：

-  和通常一样在主服务器上建立用于服务的成员区。这可以通过编辑
   :iscman:`named.conf` 或运行 :option:`rndc addzone` 来完成。

-  在目录区中为新的成员区增加一个条目。这可以通过编辑目录区的
   区文件并运行 :option:`rndc reload` ，或者使用 :iscman:`nsupdate` 更新这
   个区来完成。

对目录区的修改将使用普通的AXFR/IXFR机制从主服务器扩散到所有的辅服
务器。当辅服务器收到对目录区的更新，它会检查新成员区条目，在辅服
务器上创建区的实例，并将实例指向目录区数据所指定的 ``primaries`` 。
新创建的成员区是一个普通的辅区，所以BIND会立即发起一个从主区的区
内容的传送。一旦完成，辅服务器将开始服务于这个成员区。

从一个辅服务器删除一个成员区只是在目录区中删除成员区条目，不会有
更多的要求。对目录区的修改使用普通的AXFR/IXFR传送机制扩散到辅服
务器。辅服务器在处理更新时中会注意到成员区已被删除。它停止这个区
的服务并将其从已配置区的清单中删去。然而，从主服务器删除成员区必
须通过编辑配置文件或运行 :option:`rndc delzone`  完成。

配置目录区
~~~~~~~~~~~~~~~~~~~~~~~~~

目录区是在 :iscman:`named.conf` 中的 ``options`` 或 ``view`` 部份中使用
一条 ``catalog-zones`` 语句来配置的。例如：

::

   catalog-zones {
       zone "catalog.example"
            default-primaries { 10.53.0.1; }
            in-memory no
            zone-directory "catzones"
            min-update-interval 10;
   };

这个语句指定区 ``catalog.example`` 为一个目录区。这个区必须正确地
配置在同一个视图中。在大多数配置中，它是一个辅区。

区名后面的选项不是必须的，可以以任何顺序指定：

``default-masters``
   ``default-primaries`` 的同义词。

``default-primaries``
   该选项定义一个目录区中成员区的缺省主服务器。这可以被一个目录区
   内的选项所覆盖。如果未包含这样的选项，成员区将从这个选项中所列
   的服务器传输它们的内容。

``in-memory``
   如果该选项设置为 ``yes`` ，将使成员区仅存放于内存。这在功能上
   等效于配置一个辅区而不使用一个 ``file`` 选项。缺省是 ``no`` ；
   成员区的内容将会保存在一个本地的文件中，其名字由视图名、目录区
   名和成员区名自动生成。

``zone-directory``
   如果 ``in-memory`` 未被设置为 ``yes`` ，该选项使得成员区的区文件
   的本地拷贝被存放在一个指定的目录中。缺省是将区文件存放在服务器
   的工作目录。在 ``zone-directory`` 中一个非绝对路径被假设为相对
   于工作目录。

``min-update-interval``
   该选项设置对目录区更新的最小间隔，以秒计。如果一个目录区的更
   新（例如，通过IXFR）发生于最近的更新后不到 ``min-update-interval``
   秒，则变化不会被执行，直到这个间隔时间过去之后。缺省是5秒。

目录区的定义基于每个视图。在一个视图中配置一个非空的 ``catalog-zones``
语句将会自动对这个视图打开 ``allow-new-zones`` 。这意谓着在支持目
录区的任何视图上， :option:`rndc addzone` 和 :option:`rndc delzone` 也可以工
作。

目录区格式
~~~~~~~~~~~~~~~~~~~

目录区是一个普通的DNS区；所以，它必须拥有一个 ``SOA`` 和至少一个
``NS`` 记录。

一个声明目录区格式的版本的记录也是必须的。如果所列的版本号是服务
器不支持的，目录区不能被用于那台服务器。

::

   catalog.example.    IN SOA . . 2016022901 900 600 86400 1
   catalog.example.    IN NS nsexample.
   version.catalog.example.    IN TXT "1"

注意这个记录必须有域名 ``version.catalog-zone-name`` 。存储在一个目录区
的数据的含义是由紧接在目录区域名之前的域名标记来指明的。

目录区选项可以全局为所有目录区设置，也可为一个单独的成员区设置。
全局选项覆盖配置文件中的设置，而成员区选项覆盖全局选项。

全局选项设置在目录区的顶点，例如：

::

    primaries.catalog.example.    IN AAAA 2001:db8::1

BIND当前支持下列选项：

-  一个简单的 ``primaries`` 定义：

   ::

           primaries.catalog.example.    IN A 192.0.2.1


   这个选项为成员区定义一个主服务器，它可以是一条A或者AAAA记录。
   如果设置了多个主服务器，其使用顺序是随机的。

   注意： ``masters`` 可以用作 ``primaries`` 的一个同义词。

-  一个带有TSIG密钥定义的 ``primaries`` ：

   ::

               label.primaries.catalog.example.     IN A 192.0.2.2
               label.primaries.catalog.example.     IN TXT "tsig_key_name"


   这个选项使用一个TSIG密钥设置为成员区定义一个主服务器。TSIG密钥
   必须配置在配置文件中。 ``label`` 可以是任何有效的DNS标记。

   注意： ``masters`` 可以用作 ``primaries`` 的一个同义词。

-  ``allow-query`` 和 ``allow-transfer`` ACLs:

   ::

               allow-query.catalog.example.   IN APL 1:10.0.0.1/24
               allow-transfer.catalog.example.    IN APL !1:10.0.0.1/32 1:10.0.0.0/24


   这些选项等效于在 :iscman:`named.conf` 配置文件中一个区定义中的
   ``allow-query`` 和 ``allow-transfer`` 。ACL被顺序处理；如果没有
   匹配任何规则，缺省规则是禁止访问。关于APL资源记录的语法，参见
   :rfc:`3123` 。

通过在目录区的 ``zones`` 子域中包含一条 ``PTR`` 记录增加一个成员区。
记录标记是成员区线上格式的一个 ``SHA-1`` 哈希。PTR记录的目标是成员
区名。例如，要添加成员区 ``domain.example`` ：

::

   5960775ba382e7a4e09263fc06e7c00569b6a05c.zones.catalog.example. IN PTR domain.example.

这个哈希是必须的，用以为一个特殊的成员区识别选项。成员区特殊的选项
是与全局选项同样的方式定义的，只是在成员区子域中：

::

   primaries.5960775ba382e7a4e09263fc06e7c00569b6a05c.zones.catalog.example. IN A 192.0.2.2
   label.primaries.5960775ba382e7a4e09263fc06e7c00569b6a05c.zones.catalog.example. IN AAAA 2001:db8::2
   label.primaries.5960775ba382e7a4e09263fc06e7c00569b6a05c.zones.catalog.example. IN TXT "tsig_key"
   allow-query.5960775ba382e7a4e09263fc06e7c00569b6a05c.zones.catalog.example. IN APL 1:10.0.0.0/24

正如预料的一样，为一个特定区定义的选项覆盖在目录区中定义的全局选项。
这进而覆盖配置文件的 ``catalog-zones`` 语句中定义的全局选项。

注意，如果特定区为这个选项定义了任何记录，就不会从全球记录继承选项。
例如，如果区有一个类型A而没有AAAA的 ``primaries`` 记录，它 **不能**
从全局选项继承类型AAAA记录。
