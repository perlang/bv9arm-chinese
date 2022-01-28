.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.10注记
----------------------

新特性
~~~~~~~~~~~~

- 对 NSEC3 的支持已经增加到 KASP 中。 ``dnssec-policy`` 的一个新的选项，
  ``nsec3param`` ，可以用于设置期望的 NSEC3 参数。
  NSEC3 salt collisions are automatically prevented during resalting.
  :gl:`#1620`

特性变化
~~~~~~~~~~~~~~~

- ``max-recursion-queries`` 的缺省值从75增加到100。由于发到根和TLD服务
  器的请求现在被包括在计数以内（作为对CVE-2020-8616的修补结果），
  ``max-recursion-queries`` 有更高的几率被非攻击请求超过，这是增加其缺
  省值的主要原因。 :gl:`#2305`

- ``nocookie-udp-size`` 的缺省值被恢复成 4096 字节。由于 ``max-udp-size``
  是 ``nocookie-udp-size`` 的上限，这个变化依赖于操作者必须随同
  ``max-udp-size`` 来修改 ``nocookie-udp-size`` ，以增加缺省的 EDNS
  缓冲区大小限额。如果期望，也可以将 ``nocookie-udp-size`` 设置成低于
  ``max-udp-size`` 。 :gl:`#2250`

漏洞修补
~~~~~~~~~

- 通过回退到 TCP，增强对在 UDP 之上缺失 DNS COOKIE 响应缺失的处理。
  :gl:`#2275`

- 当 QTYPE 是 CNAME 或 ANY 时，从一个 DNAME 合成 CNAME 被错误执行了。
  :gl:`#2280`

- 构建对 AEP Keyper 的原生 PKCS#11 支持，自 BIND 9.16.6 被破坏了。这个
  已经被修补。 :gl:`#2315`
