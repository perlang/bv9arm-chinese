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

.. _man_nslookup:

nslookup - 交互式请求互联网名字服务器
----------------------------------------------------

概要
~~~~~~~~

:program:`nslookup` [-option] [name | -] [server]

描述
~~~~~~~~~~~

``nslookup`` 是一个请求互联网域名服务器的程序。 ``nslookup`` 有
两种模式：交互式和非交互式。交互式模式允许用户请求名字服务器以
获取关于不同主机和域的信息，或者输出一个域中的一个主机列表。非
交互模式只是输出一个主机或域名的名字和所请求的信息。

参数
~~~~~~~~~

在下列情况将会进入交互模式：

a. 当没有给出参数时（使用缺省名字服务器）

b. 当第一个参数是一个连字符（-）并且第二个参数是主机名或者一个
   名字服务器的互联网地址时。

当被查找主机的名字或者互联网地址作为第一个参数给出时，就使用非
交互模式。可选的第二个参数指定一个名字服务器的主机名或者地址。

选项也可以在命令行中指定，如果它们在参数之前，并且以一个连字符
做前缀。例如，要将缺省的请求类型改为主机信息，以及要将初始的超
时设置为10秒，敲入：

::

   nslookup -query=hinfo  -timeout=10

``-version`` 选项使得 ``nslookup`` 输出版本号并立即退出。

交互命令
~~~~~~~~~~~~~~~~~~~~

``host [server]``
   这个命令使用当前缺省服务器或者 ``server`` ，如果指定了，查找
   ``host`` 的信息。如果 ``host`` 是一个互联网地址并且请求类型是A或者
   PTR，就返回主机的名字。如果 ``host`` 是一个名字，并且没有结尾的点
   (``.``)，就使用搜索列表来使名字合格 [#]_ 。

   要查找非当前域的一台主机，在名字之后添加一个点。

.. [#]
   译注：使用搜索列表中的名字作为后缀，将要查找的名字补充为一个完整域名。

``server domain`` | ``lserver domain``
   这些命令将缺省服务器设置为 ``domain`` ； ``lserver`` 使用最初的服务
   器来查找关于 ``domain`` 的信息，而 ``server`` 则使用当前缺省的服务
   器。如果不能发现一个权威的答复，则返回可能具有答复的服务器的名字。

``root``
   本命令未实现

``finger``
   本命令未实现

``ls``
   本命令未实现

``view``
   本命令未实现

``help``
   本命令未实现

``?``
   本命令未实现

``exit``
   本命令退出程序。

``set keyword[=value]``
   这个命令用于改变影响查找的状态信息。有效关键字是：

   ``all``
      本关键字输出 ``set`` 频繁使用的选项的当前值。关于当前缺省服务器
      和主机的信息也会被输出。

   ``class=value``
      本关键字改变请求类为下列之一：

      ``IN``
         Internet类

      ``CH``
         Chaos类

      ``HS``
         Hesiod类

      ``ANY``
         通配符

      类指定信息的协议组。缺省是 ``IN`` ；这个关键字的缩写是 ``cl`` 。

   ``nodebug``
      本关键字打开或者关闭在搜索时对完整响应包和任何中间响应包的显示。
      这个关键字的缺省是 ``nodebug`` ；这个关键字的缩写是 ``[no]deb`` 。

   ``nod2``
      本关键字打开或者关闭调试模式。这显示关于nslookup正在做什么的更多
      信息。缺省是 ``nod2`` 。

   ``domain=``\ name
      本关键字为 ``name`` 设置搜索名单。

   ``nosearch``
      如果查询请求包含至少一个点但是不以点结尾，本关键字就在请求的尾部
      添加域名搜索列表中的域名，直到收到一个回答。缺省是 ``search`` 。

   ``port=``\ value
      本关键字将缺省的TCP/UDP名字服务器端口从缺省的53口改变为
      ``value`` 。本关键字的缩写是 ``po`` 。

   ``querytype=value`` | ``type=value``
      本关键字改变信息请求的类型为 ``value`` 。缺省是A然后是AAAA；这些
      关键字的缩写是 ``q`` 和 ``ty`` 。

      请注意只可能指定一个请求类型。只有在未指定两者之一时，缺省行为才
      是查找两种。

   ``norecurse``
      本关键字告诉名字服务器请求其它服务器，如果它没有信息。缺省是
      ``recurse`` ；本关键字的缩写是 ``[no]rec`` 。

   ``ndots=number``
      本关键字设置在一个被禁止搜索的域名中的点（标记分隔符）的数量。绝
      对名字总是停止搜索。

   ``retry=number``
      本关键字设置重试次数为 ``number`` 。

   ``timeout=number``
      本关键字改变为等待一个回复的初始的超时间隔为 ``number`` 秒。

   ``novc``
      本关键字指示在发送请求给服务器时总是使用一个虚电路 [#]_ 。
      ``novc`` 是缺省值。

   ``nofail``
      如果一个服务器的响应为SERVFAIL，或者是一个指引（nofail），
      或者是这样一个响应上的中止请求（fail），本选项试探下一个名字服
      务器。缺省是 ``nofail`` 。

.. [#]
   译注：virtual circuit，指TCP。

返回值
~~~~~~~~~~~~~

如果任何请求失败， ``nslookup`` 使用退出码1返回，否则返回0。

IDN支持
~~~~~~~~~~~

如果 ``nslookup`` 在编译时带有IDN（国际化域名，
internationalized domain name）
支持，它可以接受并显示非ASCII域名。 ``nslookup`` 在发送一个请
求到一台DNS服务器之前或者在显示一个来自服务器的响应时会适当的转换
一个域名的字符编码。要关闭IDN支持，定义 ``IDN_DISABLE`` 环境变量即可。
当 ``nslookup`` 运行时，这个变量被定
义，或者当标准输出不是一个终端时，IDN支持将被关闭。

文件
~~~~~

``/etc/resolv.conf``

参见
~~~~~~~~

:manpage:`dig(1)`, :manpage:`host(1)`, :manpage:`named(8)`.
