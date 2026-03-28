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

.. iscman:: ddns-confgen
.. program:: ddns-confgen
.. _man_ddns-confgen:

ddns-confgen - TSIG密钥生成工具
---------------------------------------

概要
~~~~~~~~
:program:`ddns-confgen` [**-a** algorithm] [**-h**] [**-k** keyname] [**-q**] [**-s** name] [**-z** zone]

描述
~~~~~~~~~~~

:program:`ddns-confgen` 是一个生成用于TSIG签名的密钥的应用程序。
例如，作为结果的密钥可以被用于加固对一个区的
动态DNS更新或者用于 :iscman:`rndc` 命令通道。

使用 :option:`-k` 参数指定密钥名字，缺省是 ``ddns-key`` 。
生成的密钥伴随着配置文本和指令，可以用于 :iscman:`nsupdate`
和设置了动态DNS的 :iscman:`named` ，还有一个例子 ``update-policy``
语句。（这个用法类似于用 :iscman:`rndc-confgen` 命令设置命令通道
的安全。）

注意 :iscman:`named` 自己可以配置一个本地DDNS密钥，并用于 :option:`nsupdate -l`; 
它在区被配置为 ``update-policy local;`` 时才这样做。
:program:`ddns-confgen` 只在更复杂的配置才需要：例如，如果 :iscman:`nsupdate`
用于来自一个远程系统。

选项
~~~~~~~

.. option:: -a algorithm

   本选项指定用于TSIG密钥的算法。可用的选择为：hmac-md5，hmac-sha1，
   hmac-sha224，hmac-sha256，hmac-sha384和hmac-sha512。缺省为
   hmac-sha256。选项是大小写无关的，前缀“hmac-”可以被忽略。

.. option:: -h

   本选项打印选项和参数的一个简短摘要。

.. option:: -k keyname

   本选项指定DDNS认证密钥的密钥名。当既没有指定 :option:`-s` ，也没有指定
   :option:`-z` 选项时，缺省是 ``ddns-key`` ；否则，缺省将 ``ddns-key`` 作为一
   个独立的标记，后跟选项的参数，例如， ``ddns-key.example.com.`` 。
   密钥名必须是合法的域名，由字母，数字，连字符和点组成。

.. option:: -q

   本选项开启安静模式，它只打印密钥，没有解释的文本或用法举例。这与
   :iscman:`tsig-keygen` 基本相同。

.. option:: -s name

   本选项给一个允许动态更新的单一主机名生成配置例子。例子
   :iscman:`named.conf` 文本显示了如何使用“name”名字类型为指定的名字设置一个
   更新策略。缺省的密钥名字是 ``ddns-key.name`` 。注意“self”名字类型不
   再使用，因为要被更新的名字可能与密钥名不同。这个选项不能与 :option:`-z` 
   选项同时使用。

.. option:: -z zone

   本选项给一个允许动态更新的区生成配置例子。例子 :iscman:`named.conf` 文本展
   示了如何使用"zonesub"名字类型为所指定的zone设置一个更新策略，允许更
   新zone内所有子域。这个选项不能与 :option:`-s` 选项同时使用。

参见
~~~~~~~~

:iscman:`nsupdate(1) <nsupdate>`, :iscman:`named.conf(5) <named.conf>`, :iscman:`named(8) <named>`, BIND 9管理员参考手册。
