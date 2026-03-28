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

SIG(0)
------

BIND部份支持 :rfc:`2535` 和 :rfc:`2931` 所规定的DNSSEC SIG(0)事务签名。
SIG(0)使用公钥/私钥来认证消息。访问控制的执行方式与使用TSIG密钥的方式相
同；可以基于密钥名称在ACL指令中授予或拒绝权限。

当收到一个SIG(0)签名的消息时，只有服务器知道并信任的密钥时才会验证。服
务器不会试图递归地获取或验证密钥。

不支持对包含多个消息的TCP流的SIG(0)签名操作。

BIND 9所带的唯一生成SIG(0)签名消息的工具是 :iscman:`nsupdate` 。
