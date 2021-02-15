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


.. highlight: console

.. _man_rndc.conf:

rndc.conf - rndc的配置文件
----------------------------

概要
~~~~~~~~

:program:`rndc.conf`

描述
~~~~~~~~~~~

``rndc.conf`` 是BIND 9名字服务器控制工具 ``rndc`` 的配置文件。这个
文件有与 ``named.conf`` 相似的结构和语法。语句包含在花括号之内，并
以分号结束。语句中的子句也以分号结束。所支持的通常的注释风格为：

C风格：/\* \*/

C++风格：// 到行尾

Unix风格：# 到行尾

``rndc.conf`` 比 ``named.conf`` 简短得多。文件使用三个语句：一个
options语句，一个server语句和一个key语句。

``options`` 语句包含五个子句。 ``default-server`` 子句后跟名字或
者一个名字服务器的地址。在没有为 ``rndc`` 提供名字服务器参数时，
将使用这个主机。 ``default-key`` 子句后跟一个密钥名，这个密钥由
一个 ``key`` 语句标识。如果在rndc命令行没有提供 ``keyid`` ，并且
在一个匹配的 ``server`` 语句中没有找到 ``key`` 子句，就使用这个
缺省的密钥来认证服务器的命令和响应。 ``default-port`` 子句后跟要
连接到的远程名字服务器的端口。如果在rndc命令行没有提供 ``port``
选项，并且在一个匹配的 ``server`` 语句中没有找到 ``port`` 子句，
就使用这个缺省的端口来连接。 ``default-source-address`` 和
``default-source-address-v6`` 子句可以分别用来设置IPv4和IPv6的源
地址。

在 ``server`` 关键字之后，server语句包含一个字符串，代表一个名字
服务器的主机名或地址。这个语句有三个可能的子句： ``key`` ，
``port`` 和 ``addresses`` 。密钥名必须匹配文件中一个key语句的名
字。端口号指定要连接到的端口。如果提供了一个 ``addresses`` 子句，
将使用这些地址来代替服务器名字。每个地址可以带有一个可选的端口。
如果使用了 ``source-address`` 或者 ``source-address-v6`` ，这些
会分别用于指定IPv4和IPv6的源地址。

``key`` 语句以一个标识密钥名字的字符串开始。这个语句有两个子句。
``algorithm`` 定义 ``rndc`` 用到的认证算法；当前仅支持HMAC-MD5
（为了兼容），HMAC-SHA1，HMAC-SHA224，HMAC-SHA256（缺省），
HMAC-SHA384和HMAC-SHA512。它后跟一个secret子句，后者包含
base-64编码的算法的认证密钥。这个base-64字符串使用双引号引起来。

有两个通常的方式来生成密钥的base-64字符串。BIND 9程序
``rndc-confgen`` 可以用来生成一个随机密钥，或者 ``mmencode`` 程
序，也叫做 ``mimencode`` ，可以用来生成一个已知输入的base-64字
符串。 ``mmencode`` 不随BIND 9提供，但是它在许多系统上是可用的。
关于每个命令行的样例，参见例子部份。

例子
~~~~~~~

::

         options {
           default-server  localhost;
           default-key     samplekey;
         };

::

         server localhost {
           key             samplekey;
         };

::

         server testserver {
           key     testkey;
           addresses   { localhost port 5353; };
         };

::

         key samplekey {
           algorithm       hmac-sha256;
           secret          "6FMfj43Osz4lyb24OIe2iGEz9lf1llJO+lz";
         };

::

         key testkey {
           algorithm   hmac-sha256;
           secret      "R3HI8P6BKw9ZwXwN3VZKuQ==";
         };

在上面的例子中， ``rndc`` 缺省将使用localhost(127.0.0.1)作为服
务器，和名为samplekey的密钥。到服务器localhost的命令将使用密钥
samplekey，后者也必须使用同样的名字和密钥定义在服务器的配置文件
中。key语句指明samplekey使用HAMC-SHA256算法，它的secret子句包含
这个HMAC-SHA256密钥的base-64编码，并被包括在双引号中。

如果使用 ``rndc -s testserver`` ， ``rndc`` 将会连接到服务器
localhost的5353端口，并使用密钥testkey。

使用 ``rndc-confgen`` 生成一个随机密钥：

``rndc-confgen``

一个完整的 ``rndc.conf`` 文件，包含随机生成的密钥，将会被写到标
准输出。还会打印出为 ``named.conf`` 提供的被注释掉的 ``key`` 和
``controls`` 语句。

使用 ``mmencode`` 生成一个base-64密钥：

``echo "known plaintext for a secret" | mmencode``

名字服务器配置
~~~~~~~~~~~~~~~~~~~~~~~~~

名字服务器必须被配置成接受rndc连接和识别 ``rndc.conf`` 文件中所
指定的密钥，这通过在 ``named.conf`` 中的controls语句来实现。详
细情况参见BIND 9管理员参考手册中的 ``controls`` 语句部份。

参见
~~~~~~~~

:manpage:`rndc(8)`, :manpage:`rndc-confgen(8)`, :manpage:`mmencode(1)`, BIND 9管理员参考手册。
