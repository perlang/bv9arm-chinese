.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

.. _pkcs11:

PKCS#11(Cryptoki)支持
--------------------------

公钥加密标准 #11(PKCS#11)为控制硬件安全模块（HSM）和其它
密码支持设备定义了一个平台独立的API。

BIND 9可以支持三种HSM：AEP Keyper，在Debian Linux，Solaris x86
和Windows Server 2003上测试通过；Thales nShield，在Debian Linux
上测试通过；以及Sun SCA 6000密码加速板，在Solaris x86上测试通过。
另外，BIND可以与所有当前版本的SoftHSM，一种基于软件的
由OpenDNSSEC项目产出的HSM模拟器，一块工作。

PKCS#11使用一个“提供者库（provider library）”：一个动态加载库，
它提供一个低级PKCS#11接口来驱动HSM硬件。PKCS#11提供者库来自HSM厂
商，它针对于由其控制的特定HSM有效。

BIND 9中存在两种可用的对PKCS#11支持的机制：基于OpenSSL的PKCS#11
和原生PKCS#11。使用基于OpenSSL的PKCS#11，BIND使用一个OpenSSL的修
改版本，后者加载提供者库并间接操作HSM；任何HSM不支持的加密操作都
替代成由OpenSSL执行。原生PKCS#11让BIND完全绕过OpenSSL；BIND自己
加载提供者库，并使用PKCS#11 API直接驱动HSM。

先决条件
~~~~~~~~~~~~~

关于HSM的安装，初始化，测试和故障解决方面的信息，参见由HSM厂商
提供的文档。

原生PKCS#11
~~~~~~~~~~~~~~

原生PKCS#11模式仅能与一个能够执行 **每个** BIND 9可能需要的加密
操作的HSM一块工作。HSM的提供者库必须带有一个PKCS#11 API的完全实
现，因此所有这些函数都是可以访问的。在写作本文档时，仅有
Thales nShield HSM和SoftHSMv2可以被用于这个功能。对其它HSM，包括
AEP Keyper，Sun SCA 6000和旧版本的SoftHSM，使用基于OpenSSL的
PKCS#11。（注意：最终，当更多HSM支持原生PKCS#11，可以预料基于
OpenSSL的PKCS#11将被废弃。）

要在构建BIND时带有对原生PKCS#11的支持，按如下进行配置：

::

   $ cd bind9
   $ ./configure --enable-native-pkcs11 \
       --with-pkcs11=provider-library-path

这导致所有BIND工具，包括 ``named`` 和 ``dnssec-*`` 及
``pkcs11-*`` 工具，使用在provider-library-path中指定的PKCS#11提
供者库来加密。（提供者库的路径可以在 ``named`` 和 ``dnssec-*``
工具中使用 ``-E`` 参数，或者在 ``pkcs11-*`` 工具中使用 ``-m`` 参
数来覆盖。）

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

更多信息，参考
https://gitlab.isc.org/isc-projects/bind9/-/wikis/BIND-9-PKCS11

PKCS#11工具
~~~~~~~~~~~~~

BIND 9包含一个用以操作HSM的工具的最小集合，包括 ``pkcs11-keygen`` ，
用于在HSM内生成一个新的密钥对， ``pkcs11-list`` ，用于列出当前
可用的对象， ``pkcs11-destroy`` ，用于删除对象，和 ``pkcs11-tokens`` ，
用于列出可用的符号。

在UNIX/Linux构建中，这些工具仅在BIND 9使用 ``--with-pkcs11`` 选项
配置时才被构建。（注意：如果 ``--with-pkcs11`` 被设置为 ``yes`` ，
而不是PKCS#11提供者的路径，这时这些工具会被构建，但是提供者会保持
未定义的状态。使用 ``-m`` 选项或 ``PKCS11_PROVIDER`` 环境变量来指
定提供者的路径。）

使用HSM
~~~~~~~~~~~~~

对基于OpenSSL的PKCS#11，必须首先设置运行时环境，以便装载
OpenSSL和PKCS#11库：

::

   $ export LD_LIBRARY_PATH=/opt/pkcs11/usr/lib:${LD_LIBRARY_PATH}

这导致 ``named`` 和其它的二进制可执行程序从
``/opt/pkcs11/usr/lib`` 而不是缺省位置装载OpenSSL库。在使用原
生PKCS#11时不需要本步骤。

一些HSM要求设置其它的环境变量。例如，在操作一个AEP Keyper时，
必须指定“machine”文件的位置，它存放提供者库所用到的关于Keyper的
信息。如果机器文件在 ``/opt/Keyper/PKCS11Provider/machine`` ,
使用：

::

   $ export KEYPER_LIBRARY_PATH=/opt/Keyper/PKCS11Provider

当运行使用HSM的任何工具时，都必须设置这些环境变量，这些工具包含
``pkcs11-keygen``, ``pkcs11-list``, ``pkcs11-destroy``,
``dnssec-keyfromlabel``, ``dnssec-signzone``,
``dnssec-keygen`` 和 ``named`` 。

HSM密钥现在可以被创建和使用。在这个例子中，我们将创建
一个2048位的密钥并赋予其一个标记"sample-ksk"：

::

   $ pkcs11-keygen -b 2048 -l sample-ksk

要确认密钥已经存在：

::

   $ pkcs11-list
   Enter PIN:
   object[0]: handle 2147483658 class 3 label[8] 'sample-ksk' id[0]
   object[1]: handle 2147483657 class 2 label[8] 'sample-ksk' id[0]

在使用这个密钥签名一个区之前，我们必须创建一对BIND 9密钥文件。
``dnssec-keyfromlabel`` 应用程序完成这件事。在这个例子中，我们
使用HSM密钥"sample-ksk"作为"example.net"的密钥签名密钥：

::

   $ dnssec-keyfromlabel -l sample-ksk -f KSK example.net

作为结果的K*.key和K*.private文件现在可以用于签名区。与包含公钥
和私钥的普通K\*文件不同，这些文件只包含公钥数据，和一个存储在
HSM中的私钥的标识符。使用私钥进行签名是在HSM内部完成的。

要在HSM中生成第二个密钥用作一个区签名密钥，遵循上面同
样的流程，使用一个不同的密钥标记，一个更小的密钥长度，并在
dnssec-keyfromlabel的参数中去掉 ``-f KSK`` ：

::

   $ pkcs11-keygen -b 1024 -l sample-zsk
   $ dnssec-keyfromlabel -l sample-zsk example.net

作为选择，可以使用 ``dnssec-keygen`` 来生成一个传统的存
放在硬盘上的密钥：

::

   $ dnssec-keygen example.net

这比一个HSM密钥提供更弱的安全性，但是由于安全的原因，HSM可能更
慢或者使用不方便，保留HSM并将其用于更小频率的密钥签名操作可能
更为有效。如果需要，区签名密钥可以轮转更为频繁，以补偿密钥安
全性的降低。（注意：在使用原生PKCS#11时，与使用硬盘上的密钥相
比没有速度优势，因为加密操作由HSM完成。）

现在可以对区签名了。请注意，如果不给 ``dnssec-signzone`` 使
用-S选项，就必须将两个 ``K*.key`` 文件的内容添加到区的主文件
中再签名。

::

   $ dnssec-signzone -S example.net
   Enter PIN:
   Verifying the zone using the following algorithms:
   NSEC3RSASHA1.
   Zone signing complete:
   Algorithm: NSEC3RSASHA1: ZSKs: 1, KSKs: 1 active, 0 revoked, 0 stand-by
   example.net.signed

在命令行指定引擎
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

在使用基于OpenSSL的PKCS#11时，OpenSSL所使用的“engine”可以通过
使用 ``-E <engine>`` 命令行选项在 ``named`` 和所有BIND的 ``dnssec-*``
工具中指定。如果BIND 9是使用 ``--with-pkcs11`` 选项构建的，这个选
项缺省为“pkcs11”。通常是不需要指定引擎的，除非
使用了一个不同的OpenSSL引擎。

要关闭使用“pkcs11”引擎 - 因为调试目的，或者因为
HSM不可用 - 就将引擎设置为空串。例如：

::

   $ dnssec-signzone -E '' -S example.net

这将导致 ``dnssec-signzone`` 运行在如同没有使用 ``--with-pkcs11``
选项编译时的情况。

当使用原生PKCS#11模式构建时，“engine”选项具有一个不同的含义：
它指定PKCS#11提供者库的路径。这在测试一个新的提供者库时可能很
有用。

以自动区重签的方式运行 ``named``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

在原生PKCS#11模式，PIN可以在一个作为密钥标记的一个属性所指定
的文件中提供。例如，如果一个密钥有一个标记
``pkcs11:object=local-zsk;pin-source=/etc/hsmpin`` ，就可以从
文件 ``/etc/hsmpin`` 中读到PIN。

.. warning::

   在这个方式中，将HSM的PIN放在一个文本文件中可能减少使用一个
   HSM的安全优势。在以这种方式配置系统时，需要三思。
