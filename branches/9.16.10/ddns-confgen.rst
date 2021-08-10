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

.. _man_ddns-confgen:

ddns-confgen - ddns密钥生成工具
---------------------------------------

概要
~~~~~~~~
:program:`tsig-keygen` [**-a** algorithm] [**-h**] [**-r** randomfile] [name]

:program:`ddns-confgen` [**-a** algorithm] [**-h**] [**-k** keyname] [**-q**] [**-r** randomfile] [**-s** name] [**-z** zone]

描述
~~~~~~~~~~~

``tsig-keygen`` 和 ``ddns-confgen`` 是一个应用程序的调用方法，它为
使用TSIG签名生成密钥。例如，作为结果的密钥可以被用于加固对一个区的
动态DNS更新或者用于 ``rndc`` 命令通道。

当作为 ``tsig-keygen`` 运行时，可以在命令行指定一个域名，它将被用
作所生成密钥的名字。如果未指定名字，缺省为 ``tsig-key`` 。

当作为 ``ddns-confgen`` 运行时，所生成的密钥伴随有设置动态DNS时用
于 ``nsupdate`` 和 ``named`` 的配置文件和指令，包括一个
``update-policy`` 语句的例子。（这个用法类似于用 ``rndc-confgen``
命令设置命令通道的安全。）

注意 ``named`` 自己可以配置一个本地DDNS密钥，并用于 ``nsupdate -l`` ：
它在区被配置为 ``update-policy local;`` 时才这样做。
``ddns-confgen`` 只在更复杂的配置才需要：例如，如果 ``nsupdate``
用于来自一个远程系统。

选项
~~~~~~~

**-a** algorithm
   指定用于TSIG密钥的算法。可用的选择为：hmac-md5，hmac-sha1，
   hmac-sha224，hmac-sha256，hmac-sha384和hmac-sha512。缺省为
   hmac-sha256。选项是大小写无关的，前缀“hmac-”可以被忽略。

**-h**
   打印选项和参数的一个简短摘要。

**-k** keyname
   指定DDNS认证密钥的密钥名。当既没有指定 ``-s`` ，也没有指定 ``-z``
   选项时，缺省是 ``ddns-key`` ；否则，缺省将 ``ddns-key`` 作为一
   个独立的标记，后跟选项的参数，例如， ``ddns-key.example.com.`` 。
   密钥名必须是合法的域名，由字母，数字，连字符和点组成。

**-q**
   （仅 ``ddns-confgen`` 。）安静模式：只打印密钥，没有解释的文
   本或用法举例；这与 ``tsig-keygen`` 基本相同。

**-s** name
   （仅 ``ddns-confgen`` 。）给一个允许动态更新的单一主机名生成
   配置例子。例子 ``named.conf`` 文本显示了如何使用“name”名字类
   型为指定的名字设置一个更新策略。缺省的密钥名字是ddns-key.name。
   注意“self”名字类型不再使用，因为要被更新的名字可能与密钥名不
   同。这个选项不能与 ``-z`` 选项同时使用。

**-z** zone
   （仅 ``ddns-confgen`` 。）给一个允许动态更新的区生成配置例子。
   例子 ``named.conf`` 文本展示了如何使用"zonesub"名字类型为所
   指定的zone设置一个更新策略，允许更新zone内所有子域。这个选项
   不能与 ``-s`` 选项同时使用。

参见
~~~~~~~~

:manpage:`nsupdate(1)`, :manpage:`named.conf(5)`, :manpage:`named(8)`, BIND 9管理员参考手册。
