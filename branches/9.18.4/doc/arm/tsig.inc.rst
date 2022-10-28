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

.. _tsig:

TSIG
----

TSIG（Transaction SIGnatures，事务签名）是一个认证DNS消息的机制，
最早在 :rfc:`2845` 中规定。它允许使用一个共享密钥对DNS消息加密签
名。TSIG可以被用于任何DNS事务，可以作为一种限制授权的客户端对某个
服务器功能访问（例如，递归请求）的方法，这时基于IP的访问控制已无
法满足需求或者需要被覆盖，或者作为一种确保消息认证的方法，这时其
对服务器完整性非常关键，例如配合动态更新消息或者从一个主服务器到
一个辅服务器的区传送。

这个部份是一个在BIND中设置TSIG的指导。它描述了配置语法和创建TSIG
密钥的过程。

:iscman:`named` 支持TSIG用于服务器到服务器的通信，一些BIND附带工具也支
持TSIG用于发送消息给 :iscman:`named` ：

   * :ref:`man_nsupdate` 支持TSIG，通过 :option:`-k <nsupdate -k>` ， :option:`-l <nsupdate -l>` 和 :option:`-y <nsupdate -y>` 命令行选项，或在交互运行方式下通过 ``key`` 命令。
   * :ref:`man_dig` 支持TSIG，通过 :option:`-k <dig -k>` 和 :option:`-y <dig -y>` 命令行选项。

生成一个共享密钥
~~~~~~~~~~~~~~~~~~~~~~~

TSIG密钥可以使用 :iscman:`tsig-keygen` 命令生成；命令的输出是一个适合放入
:iscman:`named.conf` 的 ``key`` 指令。密钥名，算法名和大小可以由命令行参
数指定；缺省分别是“tsig-key”，HMAC-SHA256和256位。

任意一个有效DNS名字都可以用作一个密钥名，例如，在服务器 ``host1`` 和
``host2`` 之间共享的密钥可以叫做“host1-host2.”，这个密钥可以使用

::

     $ tsig-keygen host1-host2. > host1-host2.key

生成。

然后这个密钥被拷贝到两台主机上。在两台主机上密钥名和密码必须一致。
（注意：从一台服务器到另一台服务器拷贝一个共享密码超出了DNS的范围。
应该使用一个安全的传输机制：安全FTP，SSL，ssh，电话，加密电子邮件
等等。）

:iscman:`tsig-keygen` 也可以被用作 :iscman:`ddns-confgen` ，在这种情况下，其输
出包括在 :iscman:`named` 中设置动态DNS所用的附加配置。参见
:ref:`man_ddns-confgen` 获取详细信息。

装载一个新密钥
~~~~~~~~~~~~~~~~~

如果一个密钥在服务器 ``host1`` 和 ``host2`` 之间共享，每个服务器的
:iscman:`named.conf` 文件可以添加如下内容：

::

   key "host1-host2." {
       algorithm hmac-sha256;
       secret "DAopyf1mhCbFVZw7pgmNPBoLUq8wEUT7UuPoLENP2HY=";
   };

（这是上面使用 :iscman:`tsig-keygen` 生成的同一个密钥。）

由于这段文本包含一个密码，推荐无论是 :iscman:`named.conf` 还是存放 ``key``
指令的文件都不是任何人可读的，后者是通过 ``include`` 指令包含进
:iscman:`named.conf` 。

一旦一个密钥被添加到 :iscman:`named.conf` ，服务器要重启或重新读入配置，
才能识别密钥。如果服务器收到密钥签名的消息，它将能够验证签名。如果
签名有效，响应将会使用同一个密钥签名。

为一台服务器所知的TSIG密钥可以使用命令 :option:`rndc tsig-list` 列出。

指示服务器使用一个密钥
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

一个向其它服务器发送请求的服务器必须被告知是否使用一个密钥，以及
如果使用，使用哪个密钥。

例如，必须为一个辅区定义中的 ``primaries`` 语句中的每一个服务器指定
一个密钥；在这种情况下，所有SOA请求消息，NOTIFY消息和区传送请求（
AXFR或IXFR）都将使用指定密钥签名。密钥也可在一个主区或辅区中的
``also-notify`` 语句中指定，导致NOTIFY消息使用指定的密钥签名。

密钥也可以在一个 ``server`` 指令中指定。添加下列内容到 ``host1`` ，
如果 ``host2`` 的IP地址是10.1.2.3，将会导致 **所有** 从 ``host1``
到 ``host2`` 的请求，包括普通DNS请求，使用 ``host1-host2.`` 密钥签
名：

::

   server 10.1.2.3 {
       keys { host1-host2. ;};
   };

``keys`` 语句中可以提供多个密钥，但只能使用第一个。由于这条指令不包
含任何密码，所以它可以放在一个所有人可读的文件中。

从 ``host2`` 发向 ``host1`` 的消息将 **不会** 被签名，除非在
``host2`` 的配置文件中有一个类似的 ``server`` 指令。

无论何时，任何服务器只要发出了一个TSIG签名的DNS请求，它将会期待响应
被同一个密钥签名。如果响应未被签名，或者签名无效，响应将会被拒绝。

基于TSIG的访问控制
~~~~~~~~~~~~~~~~~~~~~~~~~

TSIG密钥可以在ACL定义和诸如 ``allow-query`` ， ``allow-transfer`` 和
``allow-update`` 的ACL指令中指定。上述密钥在一个ACL元素中被表示成
``key host1-host2.`` 。

这里是一个 ``allow-update`` 指令使用一个TSIG密钥的例子：

::

   allow-update { !{ !localnets; any; }; key host1-host2. ;};

这允许动态更新仅仅在UPDATE请求来自一个 ``localnets`` 内的地址，
**并且** 它使用 ``host1-host2.`` 密钥签名时才会成功。

参见 :ref:`dynamic_update_policies` 查看更为灵活的 ``update-policy``
语句的讨论。

错误
~~~~~~

处理TSIG签名消息时可能产生一些错误：

-  如果一个知道TSIG的服务器收到一个它所不知道的密钥的签名消息，响应
   将不会被签名，TSIG扩展错误码将被设置为BADKEY。
-  如果一个知道TSIG服务器收到一个它所知道密钥的却无效的签名消息，响
   应将不会被签名，TSIG扩展错误码将被设置为BADSIG。
-  如果一个知道TSIG的服务器收到一个允许的时间范围之外的消息，响应将
   会被签名，TSIG扩展错误码将被设置为BADTIME，并且时间值将会被调整
   以使响应能够被成功验证。

在以上所有情况中，服务器都将返回一个NOTAUTH响应码（未认证的）。
