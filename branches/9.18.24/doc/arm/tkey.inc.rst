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

TKEY
----

TKEY（事务KEY）是一个用于在两台主机之间自动协商一个共享密码的机制，
最早在 :rfc:`2930` 中规定。

有几种TKEY“模式”来指定如何生成和分派一个密钥。BIND 9只实现了这些模
式中的一种：Diffie-Hellman密钥交换。两台主机都需要有一个带DH算法的
KEY记录（虽然并不要求这个记录出现在一个区中）。

TKEY过程由一个客户端或服务器通过发出一个TKEY类型的请求到一个知道
TKEY的服务器开始。请求必须在附加部分包括一个合适的KEY记录，并且必
须用TSIG或者SIG(0)使用先前建立的密钥签名。服务器的响应，如果成功，
必须在其回答部分包括一个TKEY记录。在这个事务之后，两个参与方都有足
够的信息使用Diffie-Hellman密钥交换计算一个共享密码。共享密码就能被
用于两台服务器之间签名随后的事务。

服务器所知的TSIG密钥，包括TKEY协商的密钥，可以使用
:option:`rndc tsig-list` 列出。

TKEY协商的密钥可以使用 :option:`rndc tsig-delete` 从一个服务器删除。这也
可以经由TKEY协议自身，通过发送一个认证的TKEY请求指定“key deletion”
模式来完成。
