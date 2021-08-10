.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

..
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")

   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/.

   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

.. Requirements:

BIND资源要求
==========================

.. _hw_req:

硬件要求
---------------------

传统上，DNS对硬件的要求十分适度。对于许多配置，
从日常服务中淘汰下来的服务器就可以极好地胜任DNS
服务器。

然而，BIND 9的DNSSEC特性需要更多的CPU能力，所以更多使用这
些特性的机构可能需要为其应用考虑更大的系统。BIND 9是
完全支持多线程的，可以完整地利用为其需要而配置的多个处理器。

.. _cpu_req:

CPU 要求
----------------

BIND 9 的CPU要求范围可以从服务于几个静态区并且没有
缓存服务的i386级机器变化到企业级的机器，需要处理多个动态更新且有
DNSSEC签名的区，并且可以达到每秒数千个请求。

.. _mem_req:

内存要求
-------------------

服务器的内存必须足够大，以适合缓存和将区数据从硬盘装载到内存。
``max-cache-size`` 选项可以用于限制缓存所使用的内存数量，
代价是减少缓存的命中率并带来更大的DNS流量。
保持足够的内存以装载所有的区并在内存中缓存数据仍然是最好的实践；遗憾的是，
对给定配置来决定这个的最好方法是在运行中观察
名字服务器。经过几周的运行，服务器进程能够达到一个相对稳定的大小，
这时，缓存中因过期而被丢掉的条目与进入缓存的条目的速度一样。

.. _intensive_env:

字服务器增强环境问题
----------------------------------------


对于名字服务器增强的环境，用到两种可供选择的配置。第一种是客户端和所有
的二级内部名字服务器请求一个主名字服务器，后者有足够的内存来建立一个
巨大的缓存。这个方法最大限度减少了外部名字查找所用到的带宽。第二种是
设置内部的二级服务器来各自独立进行查询。在这个配置中，不需要某台主机
有像第一种方法那样需要巨大的内存和CPU能力，但是这个方法的缺点是需要
更多的外部查询，因为所有的名字服务器都不共享它们缓存的数据。

.. _supported_os:

支持的操作系统
---------------------------

ISC BIND 9可以在大多数类UNIX操作系统和微软
Windows Server 2012 R2，2016和 Windows 10上编译和运行。
查看所支持系统的最新名单，
参见 BIND 9 源码分发包的顶级目录中的 PLATFORMS.md 文件。
