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

BIND 9.16.19注记
----------------------

新特性
~~~~~~~~~~~~

- 使用一个新的配置选项， ``parental-agents`` ，每个区现在可以被关联到一
  个服务器列表，后者可以用于核对父区中的DS资源记录集。这个开启了自动KSK
  轮转。 :gl:`#1126`

特性变化
~~~~~~~~~~~~~~~

- 向外发出的UDP套接字别禁止了IP分片。由发送超过指定的路径MTU大小的DNS消
  息而触发的错误被正确地处理，通过发送空DNS答复并置位 ``TC`` （截断）
  位，它强制DNS客户端回退到TCP。 :gl:`#2790`

漏洞修补
~~~~~~~~~

- 管理 :rfc:`5011` 信任锚的代码在刷新失败时创建了一个无效的站位密钥数据
  记录，它阻止了受管理密钥的数据库被顺序读回。这个已被解决。 :gl:`#2686`

- 当需要通配符扩展和CNAME链接来准备响应时，由 ``named`` 准备的签名的、
  不安全的授权响应要么缺少必要的NSEC记录，要么包含重复的NSEC记录。这个
  已被解决。 :gl:`#2759`

- 如果 ``nsupdate`` 发送一个SOA请求并收到一个REFUSED响应，它现在会通过
  故障转移而试探下一个可用的服务器。 :gl:`#2758`

- 一个导致使用KASP的区在每次重启时NSEC3盐被修改的漏洞已被修补。
  :gl:`#2725`

- 配置检查代码无法解释 ``dnssec-policy`` 选项的继承规则。这个已被解决。
  :gl:`#2780`

- 对 :gl:`#1875` 的修订无意中引入了一个死锁：当为读写锁定密钥文件时，
  ``in-view`` 逻辑没有被考虑。这个已被解决。 :gl:`#2783`

- 当两个线程竞争同一个密钥文件锁的集合时可能发生一个竞争条件，导致一个
  死锁。这个已被解决。 :gl:`#2786`
