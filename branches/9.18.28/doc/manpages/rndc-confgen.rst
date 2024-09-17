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

.. iscman:: rndc-confgen
.. program:: rndc-confgen
.. _man_rndc-confgen:

rndc-confgen - rndc密钥生成工具
-------------------------------

概要
~~~~

:program:`rndc-confgen` [**-a**] [**-A** algorithm] [**-b** keysize] [**-c** keyfile] [**-h**] [**-k** keyname] [**-p** port] [**-s** address] [**-t** chrootdir] [**-u** user]

描述
~~~~

:program:`rndc-confgen` 为 :iscman:`rndc` 生成配置文件。它可以用作一个方便手段，
用以手工书写 :iscman:`rndc.conf` 文件及在 :iscman:`named.conf` 中写相应的
``controls`` 和 ``key`` 语句。作为选择，它可以带有 :option:`-a` 选项运行
来建立一个 ``rndc.key`` 文件，以避免对 :iscman:`rndc.conf` 文件和一个
``controls`` 语句的需求。

选项
~~~~

.. option:: -a

   本选项设置自动的 :iscman:`rndc` 配置，它建立一个文件 |rndc_key| ，可以被
   :iscman:`rndc` 和 :iscman:`named` 两个在启动时读取。 ``rndc.key`` 文件定义
   了一个缺省的命令通道和认证密钥，它允许 :iscman:`rndc` 与本机上的
   :iscman:`named` 通信而不需要更多的配置。

   如果需要一个比 :option:`rndc-confgen -a` 所生成的更加复杂的配置，例如，
   如果rndc需要远程使用，不使用 :option:`-a` 选项运行 :program:`rndc-confgen`
   的并按指示设置 :iscman:`rndc.conf` 和 :iscman:`named.conf` 。

.. option:: -A algorithm

   本选项指定用于TSIG密钥的算法。可用的选择有：hmac-md5，hmac-sha1，
   hmac-sha224，hmac-sha256，hmac-sha384和hmac-sha512。缺省是
   hmac-sha256。

.. option:: -b keysize

   本选项指定认证密钥的位数。位数必须在1到512位之间；缺省是散列的大小。

.. option:: -c keyfile

   本选项与 :option:`-a` 选项一起使用指定一个 ``rndc.key`` 的替代位置。

.. option:: -h

   本选项打印 :program:`rndc-confgen` 的选项和参数的简短摘要。

.. option:: -k keyname

   本选项指定 :iscman:`rndc` 认证密钥的密钥名。这个必须是一个有效域名。缺省是
   ``rndc-key`` 。

.. option:: -p port

   本选项指定 :iscman:`named` 监听与 :iscman:`rndc` 连接的命令通道的端口。缺省是953。

.. option:: -q

   本选项阻止在自动配置模式下打印写入路径。

.. option:: -s address

   本选项指定 :iscman:`named` 监听与 :iscman:`rndc` 连接的命令通道的IP地址。缺省是
   环回地址127.0.0.1。

.. option:: -t chrootdir

   本选项与 :option:`-a` 选项一起使用，指定 :iscman:`named` 运行改变根的目录。一个
   附加的 ``rndc.key`` 拷贝会写到相对于这个目录的位置，这样改变了根
   的 :iscman:`named` 才能找到它。

.. option:: -u user

   本选项与 :option:`-a` 选项一起使用，设置所生成的 ``rndc.key`` 文件的拥有者。
   如果也指定了 :option:`-t` ，只有改变了根的目录下的文件才改变其拥有者。

例子
~~~~~~~~

允许不用手工配置而使用 :iscman:`rndc` ，运行：

.. option:: rndc-confgen -a

要打印一个例子 :iscman:`rndc.conf` 文件和相对应的用于手工插入
:iscman:`named.conf` 的 ``controls`` 和 ``key`` 语句，运行：

:program:`rndc-confgen`

参见
~~~~~~~~

:iscman:`rndc(8) <rndc>`, :iscman:`rndc.conf(5) <rndc.conf>`, :iscman:`named(8) <named>`, BIND 9管理员参考手册。
