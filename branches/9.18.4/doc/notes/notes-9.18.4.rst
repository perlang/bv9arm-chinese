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

BIND 9.18.4注记
---------------------

特性变化
~~~~~~~~

- 新增了 ``dnssec-policy`` 配置检查，以检查不寻常的策略，例如KSK和/或
  ZSK的缺失，太短的密钥生命周期和重签周期。 :gl:`#1611`

漏洞修补
~~~~~~~~

- ``fetches-per-server`` 限额被设计为在权威服务器超时太频繁时自动向下
  调整。由于一个编码错误，这个调整应用不正确，导致一个拥塞服务器的限额
  总被设置为1。这个已被修订。 :gl:`#3327`

- 已经DNSSEC签名的目录区不会被正确的处理。这个已被修正。 :gl:`#3380`

- 每次 ``dnssec-policy`` 密钥管理器运行时，密钥文件都会更新，无论元数
  据是否发生了更改。 :iscman:`named` 现在在写出密钥文件之前检查是否应
  用了更改。 :gl:`#3302`
