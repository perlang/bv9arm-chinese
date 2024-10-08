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

.. iscman:: named
.. program:: named
.. _man_named:

named - 互联网域名服务器
------------------------

概要
~~~~

:program:`named` [ [**-4**] | [**-6**] ] [**-c** config-file] [**-C**] [**-d** debug-level] [**-D** string] [**-E** engine-name] [**-f**] [**-g**] [**-L** logfile] [**-M** option] [**-m** flag] [**-n** #cpus] [**-p** port] [**-s**] [**-t** directory] [**-U** #listeners] [**-u** user] [**-v**] [**-V**] [**-X** lock-file]

描述
~~~~

:program:`named` 是一个域名系统（DNS）服务器，是由ISC发布的BIND 9的一部份。
关于更多DNS的信息，参考 :rfc:`1033` ， :rfc:`1034` 和 :rfc:`1035` 。

在没有参数时调用， :program:`named` 读缺省的配置文件 |named_conf| ，
从其中读入所有初始数据，并监听端口以待请求。

选项
~~~~

.. option:: -4

   本选项告诉 :program:`named` ，即使主机支持IPv6，也只使用IPv4。 :option:`-4` 和
   :option:`-6` 是互斥的。

.. option:: -6

   本选项告诉 :program:`named` ，即使主机支持IPv4，也只使用IPv6。 :option:`-4` 和
   :option:`-6` 是互斥的。

.. option:: -c config-file

   本选项告诉 :program:`named` 使用 ``config-file`` 作为配置文件，以取代缺省的
   |named_conf| 。由于配置文件中可能的 ``directory`` 选项，要保
   证在服务器改变了其工作目录之后，配置文件能够被重新装载，
   ``config-file`` 应该是一个绝对路径。

.. option:: -C

   本选项打印出缺省的内建配置并退出。

   注意：这个仅用于调试目的，并且不是 :iscman:`named` 运行时所使用的实
   际配置的准确表示。

.. option:: -d debug-level

   本选项设置服务器守护进程的调试级别为 ``debug-level`` 。随着调试级别
   的增加，来自 :program:`named` 的调试跟踪信息就会更冗长。

.. option:: -D string

   本选项指定一个用于在一个进程列表中标识一个 :program:`named` 实例的string。
   ``string`` 的内容是未被检查的。

.. option:: -E engine-name

   如果适用，本选项指定要使用的加密硬件，例如用于签名的安全密钥存储库。

   当BIND带有OpenSSL构建时，这需要设置成OpenSSL引擎标识符，它驱动加密加
   速器或者硬件服务模块（通常 ``pkcs11`` ）。

.. option:: -f

   本选项在前台运行服务器（即，不做守护进程化）。

.. option:: -g

   本选项在前台运行服务器并强制将所有日志写到 ``stderr`` 。

.. option:: -L logfile

   本选项设置缺省写日志到文件 ``logfile`` ，替代到系统日志。

.. option:: -M option

   本选项设置缺省的（逗号分隔的）内存上下文选项。可能的标志为：
   
   - ``fill`` ：当内存被分配或释放时，内存块将被填充为标记值，以辅助调
     试内存问题；如果 :program:`named` 编译时带有
     ``--enable-developer`` ，这是隐含的缺省项。

   - ``nofill`` ：关闭由 ``fill`` 开启的行为；除非 :program:`named` 编
     译时带有``--enable-developer`` ，这是隐含的缺省项。

.. option:: -m flag

   本选项打开内存使用的调试标志。可能的标志是 ``usage`` ， ``trace`` ，
   ``record`` ， ``size`` 和 ``mctx`` 。这些与 ``ISC_MEM_DEBUGXXXX`` 相
   关的标志在 ``<isc/mem.h>`` 中 描述。

.. option:: -n #cpus

   本选项创建 ``#cpus`` 个工作线程来利用多个CPU。如果未指定， :program:`named`
   会试图决定CPU的个数并为每个CPU创建一个线程。如果它不能决定CPU的数
   量，就只创建一个工作线程。

.. option:: -p value

   本选项指定服务器监听请求的端口。如果 ``value`` 是 ``<portnum>`` 或
   ``dns=<portnum>`` 的形式，服务器将在 ``portnum`` 监听DNS请求；如果
   未指定，缺省是53端口。如果 ``value`` 是 ``tls=<portnum>`` 的形式，服
   务器将在 ``portnum`` 监听TLS请求；缺省是853。
   如果 ``value`` 是 ``https=<portnum>`` 的形式，服
   务器将在 ``portnum`` 监听HTTPS请求；缺省是443。
   如果 ``value`` 是 ``http=<portnum>`` 的形式，服
   务器将在 ``portnum`` 监听HTTP请求；缺省是80。

.. option:: -s

   本选项在退出时将内存使用统计写到 ``stdout`` 。

.. note::

      这个选项主要是对BIND 9的开发者有趣，在未来的版本中可能被去
      掉或改变。

.. option:: -S #max-socks

   本选项已被废弃，不再有任何作用。

.. warning::

      这个选项对大量的多数用户而言是不需要的。使用这个选项甚至是
      有害的，因为所指定的值可能超过下层系统API的限制。因此仅仅在
      缺省配置会耗尽文件描述符并且确认运行环境支持所指定数目的套
      接字时才设置它。还要注意的是实际的最大数目通常比所指定的值
      小一点点，因为 :program:`named` 保留一些文件描述符供其内部使用。

.. option:: -t directory

   本选项告诉 :program:`named` ，在处理命令行参数之后而在读配置文件之前，将根
   改变为 ``directory`` 。

.. warning::

      这个选项应该与 :option:`-u` 选项结合使用，因为改变一个以root用户
      运行的进程的根目录在大多数系统上并不增强安全性；定义
      ``chroot`` 的方式允许一个具有root特权的进程逃出一个改变
      根限制。

.. option:: -U #dispatches

   本选项指定 :program:`named` 应当用来处理出向（递归）UDP连接的、每个接口
   UDP ``#dispatches`` 的数量，以减少解析器线程之间的竞争。

   如果未指定， :program:`named` 将基于检测到的CPU个数计算一个缺省值：单独
   一个CPU为1，对超过1个CPU的机器为检测到的CPU个数减一。
   
   不能将这个值增加到比CPU个数更大。（如何覆盖这个值，参见 :option:`-n` ）。

.. warning::

      对绝大多数用户而言，这个选项没有必要，并将在下一个BIND 9版本中被删除。

.. option:: -u user

   本选项在完成特权操作后，设置用户ID(setuid)为 ``user`` ，例如创建套接
   字，使其监听在特权端口上。

.. note::

      在Linux上， :program:`named` 使用内核提供的机制来放弃所有的root特
      权，除 ``bind`` 到一个特权端口和设置进程资源限制的能力
      之外。很遗憾，这意谓着当 :program:`named` 运行在2.2.18之后或
      2.3.99-pre3之后的内核上时， :option:`-u` 选项才能工作，因为之前
      的内核不允许 ``setuid`` 之后保留特权。

.. option:: -v

   本选项报告版本号并退出。

.. option:: -V

   本选项报告版本号，编译选项，支持的加密算法，然后退出。

.. option:: -X lock-file

   必须在运行时获取指定文件的锁；这帮助阻止同时运行重复的 :program:`named`
   实例。使用这个选项覆盖 :iscman:`named.conf` 中的 ``lock-file`` 选项。
   如果设置为 ``none`` ，就关闭对锁文件的检查。

信号
~~~~

在常规操作中，信号不应该用于控制名字服务器；应该使用 :iscman:`rndc` 来
代替。

SIGHUP
   本信号强制服务器重新装载。

SIGINT, SIGTERM
   这些信号关闭服务器。

发送任何其它信号到服务器的结果都未定义。

配置
~~~~

:program:`named` 的配置文件太复杂而无法在这里详细描述。完整的描述在
BIND 9管理员参考手册中提供。

:program:`named` 从父进程继承 ``umask`` （文件创建模式掩码）。如果文件
由 :program:`named` 创建，如日志文件，就需要具有定制的权限，就应当在用
于启动 :program:`named` 进程的脚本中显式地设置 ``umask`` 。

文件
~~~~

|named_conf|
   缺省配置文件。

|named_pid|
   缺省进程ID文件。

参见
~~~~

:rfc:`1033`, :rfc:`1034`, :rfc:`1035`, :iscman:`named-checkconf(8) <named-checkconf>`, :iscman:`named-checkzone(8) <named-checkzone>`, :iscman:`rndc(8) <rndc>`, :iscman:`named.conf(5) <named.conf>`, BIND 9管理员参考手册。
