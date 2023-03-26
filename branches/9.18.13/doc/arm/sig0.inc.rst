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

BIND部份支持 :rfc:`2535` 和 :rfc:`2931` 中所指定的DNSSEC SIG(0)事务
签名。SIG(0)使用公钥/私钥来认证消息。访问控制的执行方式与TSIG密钥相
同；可以基于密钥名授予或拒绝权限。

当收到一个SIG(0)签名消息时，仅仅在服务器知道并相信密钥的情况下才会
验证它；服务器不会试图递归获取或验证密钥。

多个消息的TCP流的SIG(0)签名还不支持。

随同BIND 9发行的生成SIG(0)签名消息的唯一工具是 :iscman:`nsupdate` 。
