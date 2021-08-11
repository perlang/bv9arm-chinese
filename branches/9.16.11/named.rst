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


.. highlight: console

.. _man_named:

named - 互联网域名服务器
-----------------------------------

概要
~~~~~~~~

:program:`named` [ [**-4**] | [**-6**] ] [**-c** config-file] [**-d** debug-level] [**-D** string] [**-E** engine-name] [**-f**] [**-g**] [**-L** logfile] [**-M** option] [**-m** flag] [**-n** #cpus] [**-p** port] [**-s**] [**-S** #max-socks] [**-t** directory] [**-U** #listeners] [**-u** user] [**-v**] [**-V**] [**-X** lock-file] [**-x** cache-file]

描述
~~~~~~~~~~~

``named`` 是一个域名系统（DNS）服务器，是由ISC发布的BIND 9的一部份。
关于更多DNS的信息，参考 :rfc:`1033` ， :rfc:`1034` 和 :rfc:`1035` 。

在没有参数时调用， ``named`` 将读缺省的配置文件 ``/etc/named.conf`` ，
从其中读入所有初始数据，并监听端口以待请求。

选项
~~~~~~~

**-4**
   即使主机支持IPv6，也只使用IPv4。 ``-4`` 和 ``-6`` 是互斥的。

**-6**
   即使主机支持IPv4，也只使用IPv6。 ``-4`` 和 ``-6`` 是互斥的。

**-c** config-file
   使用config-file作为配置文件，以取代缺省的 ``/etc/named.conf`` 。
   由于配置文件中可能的 ``directory`` 选项，服务器改变了其工作目录。
   要保证重新装入配置文件之后能够继续工作，config-file应该是一个绝
   对路径。

**-d** debug-level
   设置服务器守护进程的调试级别为debug-level。随着调试级别的增加，
   来自 ``named`` 的调试跟踪信息就会更冗长。

**-D** string
   指定一个用于在一个进程列表中标识一个 ``named`` 实例的string。
   string的内容是未检查过的。

**-E** engine-name
   如果适用，指定要使用的加密硬件，例如用于签名的安全密钥存储库。

   当BIND使用带OpenSSL PKCS#11支持构建时，这个缺省值是字符串"pkcs11"，
   它标识一个可以驱动一个加密加速器或硬件服务模块的OpenSSL引擎，
   当BIND使用带原生PKCS#11加密（--enable-native-pkcs11）构建时，
   它缺省是由"--with-pkcs11"指定的PKCS#11提供者库的路径。

**-f**
   在前台运行服务器（即，不做守护进程化）。

**-g**
   在前台运行服务器并强制将所有日志写到 ``stderr`` 。

**-L** logfile
   写日志到文件 ``logfile`` ，替代缺省的系统日志。

**-M** option
   设置缺省的内存上下文选项。如果设置为external，这就绕过了内部内
   存管理器，以支持系统所提供的内存申请函数。如果设置为fill，在分
   配或释放时，内存块将被填充为标记值，以辅助调试内存问题。（nofill
   关闭这个特性，这是缺省值，除非 ``named`` 编译时带有开发者选项。）

**-m** flag
   打开内存使用的调试标志。可能的标志是usage，trace，record，size
   和mctx。这些与ISC_MEM_DEBUGXXXX相关的标志在 ``<isc/mem.h>`` 中
   描述。

**-n** #cpus
   创建#cpus个工作线程来利用多个CPU。如果未指定， ``named`` 会试
   图决定CPU的个数并为每个CPU创建一个线程。如果它不能决定CPU的数
   量，就只创建一个工作线程。

**-p** port
   在端口port监听请求。如果未指定，缺省是53端口。

**-s**
   在退出时将内存使用统计写到 ``stdout`` 。

.. note::

      这个选项主要是对BIND 9的开发者有趣，在未来的版本中可能被去
      掉或改变。

**-S** #max-socks
   允许 ``named`` 使用最大数量直到#max-socks的套接字。在使用缺省
   配置选项构建的系统上缺省值为21000，在使用
   "configure --with-tuning=small"构建的系统上缺省值为4096。

.. warning::

      这个选项对大量的多数用户而言是不需要的。使用这个选项甚至是
      有害的，因为所指定的值可能超过下层系统API的限制。因此仅仅在
      缺省配置会耗尽文件描述符并且确认运行环境支持所指定数目的套
      接字时才设置它。还要注意的是实际的最大数目通常比所指定的值
      小一点点，因为 ``named`` 保留一些文件描述符供其内部使用。

**-t** directory
   在处理命令行参数之后而在读配置文件之前，将根改变为directory。

.. warning::

      这个选项应该与 ``-u`` 选项结合使用，因为改变一个以root用户
      运行的进程的根目录在大多数系统上并不增强安全性；定义
      ``chroot(2)`` 的方式允许一个具有root特权的进程逃出一个改变
      根限制。

**-U** #listeners
   在每个地址上使用#listeners个工作线程来监听UDP请求。如果未指定，
   ``named`` 将基于检测到的CPU个数计算一个缺省值：1个CPU为1，对
   超过1个CPU的机器为检测到的CPU个数减一。不能增加到比CPU个数更
   大的值。如果将 ``-n`` 设置为比检测到的CPU数目更大的值， ``-U``
   将会增加到同样的值，但不会超过它。在Windows上，UDP监听器的数
   目被硬编码为1，这个选项没有任何效果。

**-u** user
   在完成特权操作后，设置用户ID(setuid)为user，例如创建套接字，
   使其监听在特权端口上。

.. note::

      在Linux上， ``named`` 使用内核提供的机制来放弃所有的root特
      权，除 ``bind(2)`` 到一个特权端口和设置进程资源限制的能力
      之外。很遗憾，这意谓着当 ``named`` 运行在2.2.18之后或
      2.3.99-pre3之后的内核上时， ``-u`` 选项才能工作，因为之前
      的内核不允许 ``setuid(2)`` 之后保留特权。

**-v**
   报告版本号并退出。

**-V**
   报告版本号和编译选项，然后退出。

**-X** lock-file
   在运行时获取指定文件的锁；这帮助阻止同时运行重复的 ``named``
   实例。使用这个选项覆盖 ``named.conf`` 中的 ``lock-file`` 选项。
   如果设置为 ``none`` ，就关闭对锁文件的检查。

**-x** cache-file
   从 ``cache-file`` 装入数据到缺省视图的缓存中。

.. warning::

      这个选项必须不能使用。仅仅是BIND 9的开发者对其有兴趣，在未
      来的版本中可能被去掉或改变。

信号
~~~~~~~

在常规操作中，信号不应该用于控制名字服务器；应该使用 ``rndc`` 来
代替。

SIGHUP
   强制服务器重新装载。

SIGINT, SIGTERM
   关闭服务器。

发送任何其它信号到服务器的结果都未定义。

配置
~~~~~~~~~~~~~

``named`` 的配置文件太复杂而无法在这里详细描述。完整的描述在
BIND 9管理员参考手册中提供。

``named`` 从父进程继承 ``umask`` （文件创建模式掩码）。如果文件
由 ``named`` 创建，如日志文件，就需要具有定制的权限，就应当在用
于启动 ``named`` 进程的脚本中显式地设置 ``umask`` 。

文件
~~~~~

``/etc/named.conf``
   缺省配置文件。

``/var/run/named/named.pid``
   缺省进程ID文件。

参见
~~~~~~~~

:rfc:`1033`, :rfc:`1034`, :rfc:`1035`, :manpage:`named-checkconf(8)`, :manpage:`named-checkzone(8)`, :manpage:`rndc(8),` :manpage:`named.conf(5)`, BIND 9管理员参考手册。
