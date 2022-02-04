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
--------------------------

公钥加密标准 #11(PKCS#11)为控制硬件安全模块（HSM）和其它
密码支持设备定义了一个平台独立的API。

PKCS#11使用一个“提供者库（provider library）”：一个动态加载库，
它提供一个低级PKCS#11接口来驱动HSM硬件。PKCS#11提供者库来自HSM厂
商，它针对于由其控制的特定HSM有效。


BIND 9为PKCS#11使用了engine_pkcs11。engine_pkcs11是一个OpenSSL引擎，它
是 `OpenSC`_ 项目的一部份。这个引擎是动态加载到OpenSSL中，并且HSM是间接
操作的；HSM不支持的任何加密操作都可以由OpenSSL来执行。

.. _OpenSC: https://github.com/OpenSC/libp11

先决条件
~~~~~~~~~~~~~

关于HSM的安装，初始化，测试和故障解决方面的信息，参见由HSM厂商
提供的文档。

构建SoftHSMv2
^^^^^^^^^^^^^^^^^^

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

基于OpenSSL的PKCS#11
~~~~~~~~~~~~~~~~~~~~~

基于OpenSSL的PKCS#11使用来自libp11项目的engine_pkcs11 OpenSSL引擎。

engine_pkcs11尝试将PKCS#11 API放入OpenSSL的引擎API中。即，它提供了
PKCS#11模块和OpenSSL引擎API之间的网关。必须向OpenSSL注册引擎，并且必须
提供通往PKCS#11模块的路径。这可以通过编辑OpenSSL配置文件、引擎特定的控
制操作或使用p11-kit代理模块来实现。

推荐使用 libp11 >= 0.4.12 的版本。

要想了解更多关于包括示例的入门细节，我们建议阅读：

https://gitlab.isc.org/isc-projects/bind9/-/wikis/BIND-9-PKCS11

使用HSM
~~~~~~~~~~~~~

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

并在文件的末尾添加以下行：

::

   [openssl_init]
   engines=engine_section

   [engine_section]
   pkcs11 = pkcs11_section

   [pkcs11_section]
   engine_id = pkcs11
   dynamic_path = <PATHTO>/pkcs11.so
   MODULE_PATH = <FULL_PATH_TO_HSM_MODULE>
   init = 0

密钥生成
~~~~~~~~~~~~~~

现在可以创建和使用HSM密钥。我们假设你已经安装了一个BIND 9，或是从一个包
中安装的，或是从源代码中安装的，并且工具可以在 ``$PATH`` 中轻松获得。

为生成密钥，我们将使用OpenSC套件中提供的 ``pkcs11-tool`` 。在基于DEB和
基于RPM的发行版上，这个包都称为opensc。

我们需要至少生成两个RSA密钥：

::

   pkcs11-tool --module <FULL_PATH_TO_HSM_MODULE> -l -k --key-type rsa:2048 --label example.net-ksk --pin <PIN>
   pkcs11-tool --module <FULL_PATH_TO_HSM_MODULE> -l -k --key-type rsa:2048 --label example.net-ksk --pin <PIN>

记住，每个密钥都应该有唯一的标签，我们将使用这个标签来引用私钥。

将存储于HSM中的RSA密钥转换为BIND 9能够理解的格式。BIND 9中的
``dnssec-keyfromlabel`` 工具可以将存储在HSM中的原始密钥与
``K<zone>+<alg>+<id>`` 文件链接起来。你需要提供OpenSSL引擎名（
``pkcs11`` ），算法（ ``RSASHA256`` ）和指定token的PKCS#11标签（我们假
定它被初始化为bind9），PKCS#11对象的名字（使用 ``pkcs11-tool`` 生成密钥
时称为标签）和HSM的PIN。

转换KSK：

::

   dnssec-keyfromlabel -E pkcs11 -a RSASHA256 -l "token=bind9;object=example.net-ksk;pin-value=0000" -f KSK example.net

和ZSK:

::

   dnssec-keyfromlabel -E pkcs11 -a RSASHA256 -l "token=bind9;object=example.net-zsk;pin-value=0000" example.net

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

在命令行指定引擎
~~~~~~~~~~~~~~~~~~~~~~

在使用基于OpenSSL的PKCS#11时，OpenSSL所使用的“engine”可以通过
使用 ``-E <engine>`` 命令行选项在 ``named`` 和所有BIND的 ``dnssec-*``
工具中指定。通常是不需要指定引擎的，除非使用了一个不同的OpenSSL引擎。

区签名开始与往常一样，只有一个很小的不同。我们需要使用-E命令行选项提供
OpenSSL引擎的名称。

::

   dnssec-signzone -E pkcs11 -S -o example.net example.net

以自动区重签的方式运行 ``named``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

区也可能通过named自动签名。同样，我们需要使用-E命令行选项提供OpenSSL引
擎的名称。

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

要让 ``named`` 使用HSM密钥动态重签区，和/或签名通过
nsupdate插入的新记录， ``named`` 必须能够访问HSM的PIN。在基于
OpenSSL的PKCS#11中，这是通过将PIN放在 ``openssl.cnf`` 文件中来达到
（在上面的例子中， ``/opt/pkcs11/usr/ssl/openssl.cnf`` ）。

openssl.cnf文件的位置可以在运行 ``named`` 之前通过设置
``OPENSSL_CONF`` 环境变量进行覆盖。

这里是一个 ``openssl.cnf`` 的例子：

::

       openssl_conf = openssl_def
       [ openssl_def ]
       engines = engine_section
       [ engine_section ]
       pkcs11 = pkcs11_section
       [ pkcs11_section ]
       PIN = <PLACE PIN HERE>

这也将允许 ``dnssec-\*`` 工具无需PIN入口码就能够访问HSM。（
``pkcs11-\*``
工具直接访问HSM，不经过OpenSSL，所以仍然需要一个PIN来使用它们。）
