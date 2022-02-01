.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.22注记
----------------------

安全修补
~~~~~~~~~~~~~~

- ``lame-ttl`` 选项控制 ``named`` 缓存从授权服务器获取的损坏响应的时长
  （详细情况参见
  `security advisory <https://kb.isc.org/docs/cve-2021-25219>`_ ）。
  这种缓存机制可能被攻击者滥用，从而显著降低解析器的性能。通过将
  ``lame-ttl`` 的缺省值改为 ``0`` 并覆盖任何显式设置的值 ``0`` ，该漏洞
  得到了缓解，从而有效地完全禁用了此机制。ISC的测试表明，这样做对解析器
  性能的影响可以忽略不计，同时还可以防止滥用。与以前的BIND 9版本相比，
  管理员可能会观察到更多的服务器发出某些类型的损坏响应的流量，这取决于
  客户端查询模式。 (CVE-2021-25219)

  ISC感谢Infoblox的Kishore Kumar Kothapalli使我们关注到这个漏洞。
  :gl:`#2899`

特性变化
~~~~~~~~~~~~~~~

- 在BIND 9中使用的原生PKCS#11公钥加密体制已经被弃用，取而代之的是
  `OpenSC`_ 项目中的engine_pkcs11 OpenSSL引擎。
  ``--with-native-pkcs11`` 配置选项将在下一个BIND 9主版本中被移除。使用
  engine_pkcs11 OpenSSL引擎的选项在BIND 9中已经可用；更多详细信息，请参
  考 :ref:`ARM section on PKCS#11 <pkcs11>` :gl:`#2691`

- 旧式的动态加载区(DLZ)驱动在构建时必须在 ``named`` 中启用，已经被标记
  为废弃，以支持新式的DLZ模块。旧式的DLZ驱动将在下一个BIND 9主版本中被
  移除。 :gl:`#2814`

- ``map`` 区文件格式被标记为废弃，并将在下一个BIND 9主版本中被移除。
  :gl:`#2882`

- 当为 ``query-source`` ， ``transfer-source`` ， ``notify-source`` ，
  ``parental-source`` 和/或它们对应的IPv6命令配置的单一端口与全局监听端
  口冲突时， ``named`` 和 ``named-checkconf`` 将会退出，并带有一个错误。
  这个配置从BIND 9.16.0开始就不支持了，但是直到现在都没有报告错误（即使
  发送如NOTIFY这样的UDP消息失败）。 :gl:`#2888`

- 当为 ``query-source`` ， ``transfer-source`` ， ``notify-source`` ，
  ``parental-source`` 和/或它们对应的IPv6命令配置了单一端口时，
  ``named`` 和 ``named-checkconf`` 现在会发出一个警告。 :gl:`#2888`

.. _OpenSC: https://github.com/OpenSC/libp11

漏洞修补
~~~~~~~~~

- 最近在BIND 9.16.21中引入的一处变动无意中破坏了
  ``check-names master ...`` 和 ``check-names slave ...`` 选项的向后兼
  容，导致它们被静默地忽略。这个已被解决，这些选项现在又能正常工作了。
  :gl:`#2911`

- 在 ``named`` 启动期间，当操作系统设置了一个新的IP地址，它可能在新加接
  口上监听TCP连接失败。 :gl:`#2852`
