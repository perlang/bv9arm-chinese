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

.. _pkcs11:

PKCS#11(Cryptoki)支持
~~~~~~~~~~~~~~~~~~~~~

公钥加密标准 #11(PKCS#11)为控制硬件安全模块（HSM）和其它
密码支持设备定义了一个平台独立的API。

PKCS#11使用一个“提供者库（provider library）”：一个动态加载库，
它提供一个低级PKCS#11接口来驱动HSM硬件。PKCS#11提供者库来自HSM厂
商，它针对于由其控制的特定HSM有效。

BIND 9经由OpenSSL扩展访问PKCS#11库。对于OpenSSL 3或更新的版本，该扩展
是 `pkcs11-provider`_ 。对于更旧的OpenSSL版本，可以使用来自 `OpenSC`_
项目的engine_pkcs11。

.. _`pkcs11-provider`: https://github.com/latchset/pkcs11-provider
.. _OpenSC: https://github.com/OpenSC/libp11

在两种情况中，扩展都是动态加载到OpenSSL中，并且间接操作HSM；任何HSM不
支持的加密操作都可以被OpenSSL替换完成。

先决条件
^^^^^^^^

关于HSM的安装，初始化，测试和故障解决方面的信息，参见由HSM厂商
提供的文档。

构建SoftHSMv2
^^^^^^^^^^^^^

SoftHSMv2，SoftHSM的最新开发版，可在
https://github.com/opendnssec/SoftHSMv2 得到。它是由OpenDNSSEC
项目所开发的软件库（https://www.opendnssec.org），它提供了一个
虚拟HSM的PKCS#11接口，以一个在本地文件系统上的SQLite3数据库的
形式实现。它提供的安全性较一个真正的HSM较少，但是它允许用户在
没有可用的HSM时试验原生的PKCS#11。SoftHSMv2可以被配置成使用
OpenSSL或者Botan库来执行加密功能，但当其用于在BIND中的原生
PKCS#11时，必须使用OpenSSL。

缺省时，SoftHSMv2配置文件是 ``prefix/etc/softhsm2.conf`` （这里
的 ``prefix`` 是在编译时配置的）。这个位置可以被SOFTHSM2_CONF环
境变量覆盖。SoftHSMv2加密存储必须在与BIND一起使用之前被安装和初
始化。

::

   $  cd SoftHSMv2
   $  configure --with-crypto-backend=openssl --prefix=/opt/pkcs11/usr
   $  make
   $  make install
   $  /opt/pkcs11/usr/bin/softhsm-util --init-token 0 --slot 0 --label softhsmv2

使用engine_pkcs11的OpenSSL 1.x.x
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

基于OpenSSL引擎的PKCS#11使用来自libp11项目的engine_pkcs11 OpenSSL引擎。

engine_pkcs11尝试将PKCS#11 API放入OpenSSL的引擎API中。即，它提供了
PKCS#11模块和OpenSSL引擎API之间的网关。必须向OpenSSL注册引擎，并且必须
提供通往PKCS#11模块的路径。这可以通过编辑OpenSSL配置文件、引擎特定的控
制操作或使用p11-kit代理模块来实现。

推荐使用 libp11 >= 0.4.12 的版本。

要想了解更多关于包括示例的入门细节，我们建议阅读：

https://gitlab.isc.org/isc-projects/bind9/-/wikis/BIND-9-PKCS11

在使用engine_pkcs11时，所有潜在需要密钥的BIND二进制应用要求 '-E pkcs11'
参数来激活引擎支持。

即使OpenSSL 3具有对引擎API的兼容性支持，由于OpenSSL和libp11中的错误，也
不推荐使用。

无法通过engine_pkcs11生成新密钥，因此不建议将其用于 ``dnssec-policy`` 设置中
（尽管可以将之前生成的密钥放入 ``key-directory`` 中，并让密钥管理器在密钥轮转
开始时选择这些密钥）。

配置engine_pkcs11
^^^^^^^^^^^^^^^^^

配置engine_pkcs11的正式文档在 `libp11/README.md`_ ，但为你方面起见，这
里有一份工作配置：

.. _`libp11/README.md`: https://github.com/OpenSC/libp11/blob/master/README.md#pkcs-11-module-configuration

我们将使用自己定制的OpenSSL配置副本，同样，它是由一个环境变量驱动的，这
次名为OPENSSL_CONF。我们将复制全局OpenSSL配置（通常在
``etc/ssl/openssl.conf`` 中找到），并定制其使用engine_pkcs11。

::

   cp /etc/ssl/openssl.cnf /opt/bind9/etc/openssl.cnf

然后导出环境变量：

::

   export OPENSSL_CONF=/opt/bind9/etc/openssl.cnf

现在，在定义任何部份（方括号中）之前，在文件的顶部添加以下一行：

::

   openssl_conf = openssl_init

并确保文件中没有其它的 ‘openssl_conf = ...' 行。

在文件的末尾添加以下行：

::

   [openssl_init]
   engines=engine_section

   [engine_section]
   pkcs11 = pkcs11_section

   [pkcs11_section]
   engine_id = pkcs11
   dynamic_path = <PATHTO>/pkcs11.so
   MODULE_PATH = <FULL_PATH_TO_HSM_MODULE>
   # if automatic logging to the token is needed, PIN can be specified as below
   #PIN = 1234
   init = 0

在BIND命令中开启OpenSSL引擎
^^^^^^^^^^^^^^^^^^^^^^^^^^^

在使用基于OpenSSL的PKCS#11时，OpenSSL所使用的“engine”可以通过
使用 ``-E <engine>`` 命令行选项在 :iscman:`named` 和所有BIND的 ``dnssec-*``
工具中指定。这个引擎名与在前面部份中创建的 ``openssl.cnf`` 中的 'engine_id'
一致。

区签名开始与往常一样，只有一个很小的不同。我们需要使用-E命令行选项提供
OpenSSL引擎的名称。

::

   dnssec-signzone -E pkcs11 -S -o example.net example.net

OpenSSL 3带pkcs11-provider
^^^^^^^^^^^^^^^^^^^^^^^^^^

OpenSSL基于提供者的PKCS#11使用pkcs11-provider项目。

pkcs11-provider试图在OpenSSL的提供者API之内适应PKCS#11 API。
即，它提供了一个PKCS#11模块和OpenSSL提供者API之间的网关。
必须使用OpenSSL对引擎注册，并且必须提供要连接的PKCS#11模块的路径。
这可以通过编辑OpenSSL配置文件、使用引擎特定的控制方法，或者通过使用
p11-kit代理模块来实现。

要求使用pkcs11-provider 2023年10月2日git提交
2e8c26b4157fd21422c66f0b4d7b26cf8c320570及之后的版本。

BIND对pkcs11-provider的支持是内置的，不应当使用上面解释的-E命令行选项。

配置pkcs11-provider
^^^^^^^^^^^^^^^^^^^

配置pkcs11-provider的正式文档在 `provider-pkcs11.7`_ 手册页，但这有一份工作配置
的副本，供您参考使用：

.. _`provider-pkcs11.7`: https://github.com/latchset/pkcs11-provider/blob/main/docs/provider-pkcs11.7.md

我们将要使用我们自己定制的OpenSSL配置的拷贝，以及驱动它的环境变量，这次
被称为OPENSSL_CONF。我们将要拷贝全局OpenSSL配置（通常在
``etc/ssl/openssl.conf`` ）并定制其使用pkcs11-provider。

::

   cp /etc/ssl/openssl.cnf /opt/bind9/etc/openssl.cnf

并导出环境变量：

::

   export OPENSSL_CONF=/opt/bind9/etc/openssl.cnf

现在，在定义任何部份（方括号中）之前，在文件的顶部添加以下一行：

::

   openssl_conf = openssl_init

并确保文件中没有其它的 'openssl_conf = ...' 行。

添加下列行到文件底部：

::

   [openssl_init]
   providers = provider_init

   [provider_init]
   default = default_init
   pkcs11 = pkcs11_init

   [default_init]
   activate = 1

   [pkcs11_init]
   module = <PATHTO>/pkcs11.so
   pkcs11-module-path = <FULL_PATH_TO_HSM_MODULE>
   # bind uses the digest+sign api. this is broken with the default load behaviour,
   # but works with early load. see: https://github.com/latchset/pkcs11-provider/issues/266
   pkcs11-module-load-behavior = early
   # no-deinit quirk is needed if you use softhsm2
   #pkcs11-module-quirks = no-deinit
   # if automatic logging to the token is needed, PIN can be specified as below
   # the file referenced should contain just the PIN
   #pkcs11-module-token-pin = file:/etc/pki/pin.txt
   activate = 1

密钥生成
^^^^^^^^

现在可以创建和使用HSM密钥。我们假设你已经安装了一个BIND 9，或是从一个包
中安装的，或是从源代码中安装的，并且工具可以在 ``$PATH`` 中轻松获得。

为生成密钥，我们将使用OpenSC套件中提供的 ``pkcs11-tool`` 。在基于DEB和
基于RPM的发行版上，这个包都称为opensc。

我们需要至少生成两个RSA密钥：

::

   pkcs11-tool --module <FULL_PATH_TO_HSM_MODULE> -l -k --key-type rsa:2048 --label example.net-ksk --pin <PIN>
   pkcs11-tool --module <FULL_PATH_TO_HSM_MODULE> -l -k --key-type rsa:2048 --label example.net-zsk --pin <PIN>

记住，每个密钥都应该有唯一的标签，我们将使用这个标签来引用私钥。

将存储于HSM中的RSA密钥转换为BIND 9能够理解的格式。BIND 9中的
:iscman:`dnssec-keyfromlabel` 工具可以将存储在HSM中的原始密钥与
``K<zone>+<alg>+<id>`` 文件链接起来。

你需要提供OpenSSL引擎名（ ``pkcs11`` ）和算法（ ``RSASHA256`` ）。该密钥使用
PKCS#11 URI方案引用，并且可以包含PKCS#11令牌标记（我们假设其已初始化为bind9），
以及PKCS#11对象标记（当使用 ``pkcs11-tool`` 生成密钥时称为标记）以及 HSM PIN
码。关于完整的PKCS#11 URI规范，请参阅 :rfc:`7512` 。

和指定token的PKCS#11标签（我们假
定它被初始化为bind9），PKCS#11对象的名字（使用 ``pkcs11-tool`` 生成密钥
时称为标签）和HSM的PIN。

转换KSK：

::

   dnssec-keyfromlabel -E pkcs11 -a RSASHA256 -l "pkcs11:token=bind9;object=example.net-ksk;pin-value=0000" -f KSK example.net

和ZSK:

::

   dnssec-keyfromlabel -E pkcs11 -a RSASHA256 -l "pkcs11:token=bind9;object=example.net-zsk;pin-value=0000" example.net

注意：你可以通过指定 ``pin-source=<path_to>/<file>`` 来使用存储于磁盘上的PIN，例如：

::

   (umask 0700 && echo -n 0000 > /opt/bind9/etc/pin.txt)

然后在标签规范中使用使用：

::

   pin-source=/opt/bind9/etc/pin.txt

确认在当前目录中有一个KSK和一个ZSK：

::

   ls -l K*

输出应该看起来像这样（第二个数会不同）：

::

   Kexample.net.+008+31729.key
   Kexample.net.+008+31729.private
   Kexample.net.+008+42231.key
   Kexample.net.+008+42231.private

在生成ECDSA密钥时需要注意一点：libp11中有一个漏洞，在查找一个密钥时，函
数只比较密钥的ID，不比较密钥的标记。因此，在查找一个密钥时，它返回第一
个密钥，而不是匹配的密钥。解决这个问题的方法是在创建ECDSA密钥时，您应该
指定一个唯一的ID：

::

   ksk=$(echo "example.net-ksk" | openssl sha1 -r | awk '{print $1}')
   zsk=$(echo "example.net-zsk" | openssl sha1 -r | awk '{print $1}')
   pkcs11-tool --module <FULL_PATH_TO_HSM_MODULE> -l -k --key-type EC:prime256v1 --id $ksk --label example.net-ksk --pin <PIN>
   pkcs11-tool --module <FULL_PATH_TO_HSM_MODULE> -l -k --key-type EC:prime256v1 --id $zsk --label example.net-zsk --pin <PIN>


以自动区重签的方式运行 :iscman:`named`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

区也可能通过named自动签名。同样，我们需要使用 :option:`-E <named -E>` 命令行选
项提供OpenSSL引擎的名称，如果是与engine_pkcs11一起使用OpenSSL 1.x.x时，而
在使用OpenSSL 3.x.x提供者时，这是不需要的。

::

   named -E pkcs11 -c named.conf

而日志中应该有类似这样的行：

::

   Fetching example.net/RSASHA256/31729 (KSK) from key repository.
   DNSKEY example.net/RSASHA256/31729 (KSK) is now published
   DNSKEY example.net/RSA256SHA256/31729 (KSK) is now active
   Fetching example.net/RSASHA256/42231 (ZSK) from key repository.
   DNSKEY example.net/RSASHA256/42231 (ZSK) is now published
   DNSKEY example.net/RSA256SHA256/42231 (ZSK) is now active

要让 :iscman:`named` 使用HSM密钥动态重签区，和/或签名通过
nsupdate插入的新记录， :iscman:`named` 必须能够访问HSM的PIN。在基于
OpenSSL的PKCS#11中，这是通过将PIN放在 ``openssl.cnf`` 文件中来达到
（在上面的例子中， ``/opt/pkcs11/usr/ssl/openssl.cnf`` ）。

关于如何在全局层面上配置PIN，请参阅OpenSSL扩展相关文档。
这也将允许 ``dnssec-\*`` 工具无需PIN入口码就能够访问HSM。（
``pkcs11-\*``
工具直接访问HSM，不经过OpenSSL，所以仍然需要一个PIN来使用它们。）
