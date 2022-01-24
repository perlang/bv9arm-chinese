.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.3注记
---------------------

已知问题
~~~~~~~~~~~~

-  BIND在链接到libuv 1.36时，启动时会宕掉。这个问题与libuv中对
   ``recvmmsg()`` 的支持相关，在libuv 1.35中首次出现。这个问题在
   libuv 1.37中解决了，但是相关的libuv代码进行了修改，要求在库的
   初始化时，为了打开对recvmmsg()的支持，需要设置一个特定的标志。
   本BIND版本在需要时设置了这个特定的标志，所以BIND在针对libuv 1.35
   或libuv >= 1.37编译时开启了对recvmmsg()的支持；libuv 1.36不能
   与BIND一起使用。 :gl:`#1761` :gl:`#1797`

特性变化
~~~~~~~~~~~~~~~

-  BIND 9不再为UDP套接字设置接收/发送缓冲区大小，而是依赖系统缺
   省值。 :gl:`#1713`

-  缺省的rwlock实现被修改为回退到原生的BIND 9 rwlock实现。 :gl:`#1753`

-  原生的PKCS#11 EdDSA实现被更新到PKCS#11 v3.0，这样就又可以使用了。
   由Aaron Thompson贡献。 :gl:`!3326`

-  OpenSSL ECDSA实现被更新，以通过OpenSSL引擎支持PKCS#11（参见lip11
   项目的engine_pkcs11）。 :gl:`#1534`

-  OpenSSL EdDSA实现被更新，以通过OpenSSL引擎支持PKCS#11。请注意支持
   EdDSA的OpenSSL引擎是必须的，因而这个代码仅是暂时为了概念验证的。
   由Aaron Thompson贡献。 :gl:`#1763`

-  进入AXFR区传送中的消息ID现在进行一致性检查。对于消息ID不一致的流，
   将记录到日志。 :gl:`#1674`

-  区计时器现在会输出到统计通道。对于主区，只有装载时间会输出。对于
   辅区，输出的计时器还包括过期和刷新计时器。由Paul Frieden，
   Verizon Media贡献。 :gl:`#1232`

漏洞修补
~~~~~~~~~

-  dnstap初始化中的一个漏洞可能阻止某些dnstap数据被记录，特别是对于
   递归解析器。 :gl:`#1795`

-  当运行在一个具有Linux能力的系统上时， ``named`` 在启动后会尽快放
   弃根特权。这将产生一个误导性的日志消息， ``unable to set effective
   uid to 0: Operation not permitted`` ，这个已被去掉。 :gl:`#1042`
   :gl:`#1090`

-  当 ``named-checkconf`` 运行时，有时它会错误地设置其退出码。它只反
   映所发现的最后一个视图的状态；对其它配置视图所发现的任何错误都不会
   报告。感谢Graham Clinch. :gl:`#1807`

-  当不带LMDB支持编译时，当一个区的名字中带有一个双引号（"）并使用
   ``rndc addzone`` 增加时， ``named`` 的重启会失败。感谢
   Alberto Fernández. :gl:`#1695`
