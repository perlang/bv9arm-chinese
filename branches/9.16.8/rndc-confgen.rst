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

.. _man_rndc-confgen:

rndc-confgen - rndc密钥生成工具
---------------------------------------

概要
~~~~~~~~

:program:`rndc-confgen` [**-a**] [**-A** algorithm] [**-b** keysize] [**-c** keyfile] [**-h**] [**-k** keyname] [**-p** port] [**-s** address] [**-t** chrootdir] [**-u** user]

描述
~~~~~~~~~~~

``rndc-confgen`` 为 ``rndc`` 生成配置文件。它可以用作一个方便手段，
用以手工书写 ``rndc.conf`` 文件及在 ``named.conf`` 中写相应的
``controls`` 和 ``key`` 语句。作为选择，它可以带有 ``-a`` 选项运行
来建立一个 ``rndc.key`` 文件，以避免对 ``rndc.conf`` 文件和一个
``controls`` 语句的需求。

参数
~~~~~~~~~

**-a**
   做自动的 ``rndc`` 配置。这会在 ``/etc`` （或其它在编译BIND时所
   指定的 ``sysconfdir`` ）建立一个文件 ``rndc.key`` ，可以被
   ``rndc`` 和 ``named`` 两个在启动时读取。 ``rndc.key`` 文件定义
   了一个缺省的命令通道和认证密钥，它允许 ``rndc`` 与本机上的
   ``named`` 通信而不需要更多的配置。

   运行 ``rndc-confgen -a`` 允许BIND 9和 ``rndc`` 作为BIND 8和
   ``ndc`` 的简易替代，而不对现存的BIND 8的 ``named.conf`` 做任何
   改变。

   如果需要一个比 ``rndc-confgen -a`` 所生成的更加复杂的配置，例如，
   如果rndc需要远程使用，你应该不使用 ``-a`` 选项运行 ``rndc-confgen``
   的并按指示设置 ``rndc.conf`` 和 ``named.conf`` 。

**-A** algorithm
   指定用于TSIG密钥的算法。可用的选择有：hmac-md5，hmac-sha1，
   hmac-sha224，hmac-sha256,hmac-sha384和hmac-sha512。缺省是
   hmac-sha256。

**-b** keysize
   指定认证密钥的位数。必须在1到512位之间；缺省是散列的大小。

**-c** keyfile
   与 ``-a`` 选项一起使用指定一个 ``rndc.key`` 的替代位置。

**-h**
   打印 ``rndc-confgen`` 的选项和参数的简短摘要。

**-k** keyname
   指定rndc认证密钥的密钥名。这个必须是一个有效域名。缺省是
   ``rndc-key`` 。

**-p** port
   指定 ``named`` 监听 ``rndc`` 连接的命令通道的端口。缺省是953。

**-s** address
   指定 ``named`` 监听 ``rndc`` 连接的命令通道的IP地址。缺省是环回
   地址127.0.0.1。

**-t** chrootdir
   与 ``-a`` 选项一起使用，指定 ``named`` 运行改变根的目录。一个附
   加的 ``rndc.key`` 拷贝会写到相对于这个目录的位置，这样改变了根
   的 ``named`` 才能找到它。

**-u** user
   与 ``-a`` 选项一起使用，设置所生成的 ``rndc.key`` 文件的拥有者。
   如果也指定了 ``-t`` ，只有改变了根的目录下的文件才改变其拥有者。

例子
~~~~~~~~

允许不用手工配置而使用 ``rndc`` ，运行

``rndc-confgen -a``

要打印一个例子 ``rndc.conf`` 文件和相对应的用于手工插入
``named.conf`` 的 ``controls`` 和 ``key`` 语句，运行

``rndc-confgen``

参见
~~~~~~~~

:manpage:`rndc(8)`, :manpage:`rndc.conf(5)`, :manpage:`named(8)`, BIND 9管理员参考手册。
