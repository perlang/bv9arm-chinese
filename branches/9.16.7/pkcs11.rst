.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

..
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")

   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/.

   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

.. _pkcs11:

PKCS#11(Cryptoki)支持
--------------------------

PKCS#11 (公钥加密标准 #11)为控制硬件安全模块（HSM）和其它
密码支持设备定义了一个平台独立的API。

BIND 9可以支持三种HSM：AEP Keyper，在Debian Linux，Solaris x86
和Windows Server 2003上测试通过；Thales nShield，在Debian Linux
上测试通过；以及Sun SCA 6000密码加速板，在Solaris x86上测试通过。
另外，BIND可以与所有当前版本的SoftHSM，一种基于软件的
由OpenDNSSEC项目产出的HSM模拟器，一块工作。

PKCS#11利用了一个“提供者库（provider library）”：一个动态加载库，
它提供一个低级PKCS#11接口来驱动HSM硬件。PKCS#11提供者库来自HSM厂
商，它针对于由其控制的特定HSM有效。

BIND 9中存在两种可用的对PKCS#11支持的机制：基于OpenSSL的PKCS#11
和原生PKCS#11。在使用第一种机制时，BIND使用一个OpenSSL的修改版本，
后者加载提供者库并间接操作HSM；任何HSM不支持的加密操作都替代成由
OpenSSL执行。第二种机制让BIND完全绕过OpenSSL；BIND自己加载提供者
库，并使用PKCS#11 API直接驱动HSM。

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

要在构建BIND带有对原生PKCS#11的支持，按如下配置：

::

   $ cd bind9
   $ ./configure --enable-native-pkcs11 \
       --with-pkcs11=provider-library-path

这将导致所有BIND工具，包括 ``named`` 和 ``dnssec-*`` 及
``pkcs11-*`` 工具，使用在provider-library-path中指定的PKCS#11提
供者库来加密。（提供者库的路径可以在 ``named`` 和 ``dnssec-*``
工具中使用 ``-E`` ，或者在 ``pkcs11-*`` 工具中使用 ``-m`` 来覆
盖。）

构建SoftHSMv2
^^^^^^^^^^^^^^^^^^

SoftHSMv2，SoftHSM的最新开发版，可在
https://github.com/opendnssec/SoftHSMv2 得到。它是由OpenDNSSEC
项目所开发的软件库（http://www.opendnssec.org），它提供了一个
虚拟HSM的PKCS#11接口，以一个在本地文件系统上的SQLite3数据库的
形式实现。它提供的安全性较一个真正的HSM较少，但是它允许你在没
有可用的HSM时试验原生的PKCS#11。SoftHSMv2可以被配置成使用
OpenSSL或者Botan库来执行加密功能，但当其用于在BIND中的原生
PKCS#11时，必须使用OpenSSL。

缺省时，SoftHSMv2配置文件是 prefix/etc/softhsm2.conf（这里的
prefix是在编译时配置的）。这个位置可以被SOFTHSM2_CONF环境变量
覆盖。SoftHSMv2加密存储必须在与BIND一起使用之前被安装和初始化。

::

   $  cd SoftHSMv2
   $  configure --with-crypto-backend=openssl --prefix=/opt/pkcs11/usr
   $  make
   $  make install
   $  /opt/pkcs11/usr/bin/softhsm-util --init-token 0 --slot 0 --label softhsmv2


基于OpenSSL的PKCS#11
~~~~~~~~~~~~~~~~~~~~~

基于OpenSSL的PKCS#11模式使用了一个OpenSSL库的修改版本；当前官方
版本的OpenSSL不能完全支持PKCS#11。ISC提供了一个补丁来纠正这个情
况。这个补丁是基于源于OpenSolaris项目所完成的工作；它被ISC修改
以提供诸如PIN管理和密钥引用（译注：key-by-reference）等新特性。

打过补丁的OpenSSL提供了两种PKCS#11新“风味”，其中一种必须在配置
时选择。正确的选择依赖于HSM硬件：

-  'crypto-accelerator'用于具有硬件加密加速的HSM，如SCA 6000板。
   这使得OpenSSL在HSM中运行所有支持的加密操作。

-  'sign-only'用于那些设计功能主要是作为密钥存储设备，而缺乏硬
   件加速的HSM。这类设备是高安全的，但是不需要在加密时比系统CPU
   更快 ------ 通常，他们会更慢。因此，最高效的方法是仅将其用于要
   求访问安全私钥的加密功能，而其它所有计算密集性操作都使用系统
   CPU。AEP Keyper是这类设备的一个例子。

修改的OpenSSL代码包含在BIND 9发行版中，以针对最新OpenSSL版本的
带上下文的diff结果的形式。OpenSSL 0.9.8，1.0.0，1.0.1和1.0.2都
被支持；分别有各自版本的diff文件。在后面的例子中，我们使用了
OpenSSL 0.9.8，但是同样的方法也适用于OpenSSL 1.0.0到1.0.2。

.. note::

   这篇文档（2016年1月）的最新OpenSSL版本是0.9.8zh，1.0.0t，
   1.0.1q和1.0.2f。ISC在新版本的OpenSSL发布时会提供升级的补丁。
   在以下例子中的版本号预期也会改变。

在构建带PKCS#11支持的BIND 9之前，需要在适当的位置使用这个补丁
构建OpenSSL并使用你的HSM的PKCS#11提供者库的路径来配置它。

给OpenSSL打补丁
^^^^^^^^^^^^^^^^

::

   $ wget http://www.openssl.org/source/openssl-0.9.8zc.tar.gz


解压tar包：

::

   $ tar zxf openssl-0.9.8zc.tar.gz

应用BIND 9发行版所带的补丁：

::

   $ patch -p1 -d openssl-0.9.8zc \
             < bind9/bin/pkcs11/openssl-0.9.8zc-patch

..

.. note::

   补丁文件可能与不同操作系统下的"patch"应用不兼容。你可能需要
   安装GNU patch。

在构建OpenSSL时，将其放在一个非标准的位置，这样它不会干扰系统上
的OpenSSL库。在下面的例子中，我们选择安装到"/opt/pkcs11/usr"。
我们将在配置BIND 9时使用这个位置。

之后，在构建BIND 9时，定制构建的OpenSSL库的位置需要通过
configure指定。

在Linux上为AEP Keyper构建OpenSSL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

AEP Keyper是一个高安全密钥存储设备，但是不提供硬件加密加速。它
能够执行加密操作，但是可能会减慢你的系统CPU。因此，我们在构建
OpenSSL时选择'sign-only'特性。

Keyper专用的PKCS#11提供者库是随同Keyper软件分发的。在这个例子
中，我们将其放在/opt/pkcs11/usr/lib下：

::

   $ cp pkcs11.GCC4.0.2.so.4.05 /opt/pkcs11/usr/lib/libpkcs11.so

::

   $ cd openssl-0.9.8zc
   $ ./Configure linux-x86_64 \
           --pk11-libname=/opt/pkcs11/usr/lib/libpkcs11.so \
           --pk11-flavor=sign-only \
           --prefix=/opt/pkcs11/usr

为Solaris上的SCA 6000构建OpenSSL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

SCA-6000 PKCS#11提供者是作为一个系统库libpkcs11安装的。它是一
个真正的加密加速器，能够比任何CPU快4倍以上，所以特性应该是
'crypto-accelerator'。

在这个例子中，我们正在AMD64系统上的Solaris x86平台上构建。

::

   $ cd openssl-0.9.8zc
   $ ./Configure solaris64-x86_64-cc \
           --pk11-libname=/usr/lib/64/libpkcs11.so \
           --pk11-flavor=crypto-accelerator \
           --prefix=/opt/pkcs11/usr

（对一个32位构建，使用"solaris-x86-cc"和/usr/lib/libpkcs11.so。）

在配置之后，运行 ``make`` 和 ``make test`` 。

为SoftHSM构建OpenSSL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

SoftHSM（版本1）是一个由OpenDNSSEC项目(http://www.opendnssec.org)
所提供的软件库，它提供了一个虚拟HSM的PKCS#11接口，以一个在本地
文件系统上的SQLite3数据库的形式实现。SoftHSM使用Botan库执行加
密功能。虽然比一个真正的HSM更不安全，但是它允许你在没有可用的
HSM时试验PKCS#11。

在与OpenSSL一起使用SoftHSM之前，必须安装和初始化SoftHSM加密存
储，并且SOFTHSM_CONF环境变量必须总是指向SoftHSM配置文件：

::

   $  cd softhsm-1.3.7
   $  configure --prefix=/opt/pkcs11/usr
   $  make
   $  make install
   $  export SOFTHSM_CONF=/opt/pkcs11/softhsm.conf
   $  echo "0:/opt/pkcs11/softhsm.db" > $SOFTHSM_CONF
   $  /opt/pkcs11/usr/bin/softhsm --init-token 0 --slot 0 --label softhsm

SoftHSM可以执行所有的加密操作，但是由于它只使用你系统的CPU，在
除了签名之外的其它事务上使用都没有优势。因此，我们在构建
OpenSSL时选择'sign-only'特性。

::

   $ cd openssl-0.9.8zc
   $ ./Configure linux-x86_64 \
           --pk11-libname=/opt/pkcs11/usr/lib/libsofthsm.so \
           --pk11-flavor=sign-only \
           --prefix=/opt/pkcs11/usr

在配置之后，运行"``make``"和"``make test``"。

一旦你完成构建OpenSSL，运行"``apps/openssl engine pkcs11``"来
确认PKCS#11支持是正确编译的。输出应该是下列行中的一种，具体取
决于所选的特性：

::

       (pkcs11) PKCS #11 engine support (sign only)

或：

::

       (pkcs11) PKCS #11 engine support (crypto accelerator)

接下来，运行"``apps/openssl engine pkcs11 -t``"。这将试图初始化
PKCS#11引擎。如果能够顺利完成，它将会报告“``[ available ]``”。

如果输出正确，运行"``make install``"，将会把修改后的OpenSSL套件
安装到 ``/opt/pkcs11/usr`` 。

为Linux配置带AEP Keyper的BIND 9
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   $ cd ../bind9
   $ ./configure \
          --with-openssl=/opt/pkcs11/usr \
          --with-pkcs11=/opt/pkcs11/usr/lib/libpkcs11.so

为Solaris配置带SCA 6000的BIND 9
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   $ cd ../bind9
   $ ./configure CC="cc -xarch=amd64" \
           --with-openssl=/opt/pkcs11/usr \
           --with-pkcs11=/usr/lib/64/libpkcs11.so

（对一个32位的构建，省略CC="cc -xarch=amd64"。）

如果configure报告OpenSSL不工作，你可能有一个32/64位体系结构的不
匹配。或者，你可能没有为OpenSSL指定正确的路径（这个路径应该与
OpenSSL配置时的--prefix参数一样）。

为SoftHSM配置BIND 9
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   $ cd ../bind9
   $ ./configure \
          --with-openssl=/opt/pkcs11/usr \
          --with-pkcs11=/opt/pkcs11/usr/lib/libsofthsm.so

在配置后，运行"``make``","``make test``"和"``make install``"。

（注意：如果“make test”在“pkcs11”系统测试中失败，你可能是忘记设
置SOFTHSM_CONF环境变量了。）

PKCS#11工具
~~~~~~~~~~~~~

BIND 9包含一个用以操作HSM的工具的最小集合，包括 ``pkcs11-keygen`` ，
用于在HSM内生成一个新的密钥对， ``pkcs11-list`` ，用于列出当前
可用的对象， ``pkcs11-destroy`` ，用于删除对象，和 ``pkcs11-tokens`` ，
用于列出可用的符号。

在UNIX/Linux构建中，这些工具仅在BIND 9使用--with-pkcs11选项
配置时才被构建。（注意：如果--with-pkcs11被设置为“yes”，而不是
PKCS#11提供者的路径，这时这些工具会被构建，但是提供者将会保持
未定义的状态。使用-m选项或PKCS11_PROVIDER环境变量来指定提供者
的路径。）

使用HSM
~~~~~~~~~~~~~

对基于OpenSSL的PKCS#11，我们必须设置运行时环境，以便装载
OpenSSL和PKCS#11库：

::

   $ export LD_LIBRARY_PATH=/opt/pkcs11/usr/lib:${LD_LIBRARY_PATH}

这导致 ``named`` 和其它的二进制可执行程序从
``/opt/pkcs11/usr/lib`` 而不是缺省位置装载OpenSSL库。在使用原
生PKCS#11时不需要本步骤。

一些HSM要求设置其它的环境变量。例如，在操作一个AEP Keyper时，
也需要指定“machine”文件的位置，它存放提供者库所用到的Keyper的
信息。如果机器文件在 ``/opt/Keyper/PKCS11Provider/machine`` ,
使用：

::

   $ export KEYPER_LIBRARY_PATH=/opt/Keyper/PKCS11Provider

无论何时运行使用HSM的任何工具，都必须设置这些环境变量，包含
``pkcs11-keygen``, ``pkcs11-list``, ``pkcs11-destroy``,
``dnssec-keyfromlabel``, ``dnssec-signzone``,
``dnssec-keygen`` 和 ``named`` 。

现在我们可以在HSM中创建和使用密钥。在这个例子中，我们将创建
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
"dnssec-keyfromlabel"应用程序完成这件事。在这个例子中，我们将
使用HSM密钥"sample-ksk"作为"example.net"的密钥签名密钥：

::

   $ dnssec-keyfromlabel -l sample-ksk -f KSK example.net

作为结果的K*.key和K*.private文件现在可以用于签名区。与包含公钥
和私钥的普通K\*文件不同，这些文件只包含公钥数据，和一个存储在
HSM中的私钥的标识符。使用私钥进行签名是在HSM内部完成的。

如果你想要在HSM中生成第二个密钥用作一个区签名密钥，遵循上面同
样的流程，使用一个不同的密钥标记，一个更小的密钥长度，并在
dnssec-keyfromlabel的参数中去掉"-f KSK"：

（注意：当使用基于OpenSSL的PKCS#11时，标记是一个任意的字符串，
它标识密钥。使用原生PKCS#11时，标记是一个PKCS#11 URI字符串，
其中可能包含关于和HSM的更详细的信息，包括自身的PIN。更详细的
内容参见 :ref:`man_dnssec-keyfromlabel` 。）

::

   $ pkcs11-keygen -b 1024 -l sample-zsk
   $ dnssec-keyfromlabel -l sample-zsk example.net

作为选择，你也可能更喜欢使用dnssec-keygen来生成一个传统的存
放在硬盘上的密钥：

::

   $ dnssec-keygen example.net

这比一个HSM密钥提供更弱的安全性，但是由于安全的原因，HSM可能更
慢或者使用不方便，保留HSM并将其用于更小频率的密钥签名操作可能
更为有效。如果你愿意，区签名密钥可以轮转更为频繁，以补偿密钥安
全性的降低。（注意：在使用原生PKCS#11时，与使用硬盘上的密钥相
比没有速度优势，因为加密操作无论如何将由HSM完成。）

现在你可以对区签名了。（注意：如果不给 ``dnssec-signzone`` 使
用-S选项，就需要将两个 ``K*.key`` 文件的内容添加到区的主文件
中再签名。）

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
使用“-E <engine>”命令行选项在 ``named`` 和所有BIND的 ``dnssec-*``
工具中指定。如果BIND 9是使用\-\-with-pkcs11选项构建的，这个选
项缺省为“pkcs11”。通常是不需要指定引擎的，除非因为某种原因，
你希望使用一个不同的OpenSSL引擎。

如果你希望关闭使用“pkcs11”引擎 ------ 因为调试目的，或者因为
HSM不可用 ------ 就将引擎设置为空串。例如：

::

   $ dnssec-signzone -E '' -S example.net

这将导致 ``dnssec-signzone`` 运行在如同没有使用\-\-with-pkcs11
选项编译时的情况。

当使用原生PKCS#11模式构建时，“engine”选项具有一个不同的含义：
它指定PKCS#11提供者库的路径。这在测试一个新的提供者库时可能很
有用。

以自动区重签的方式运行named
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

如果你想要 ``named`` 使用HSM密钥动态重签区，和/或签名通过
nsupdate插入的新记录， ``named`` 必须能够访问HSM的PIN。在基于
OpenSSL的PKCS#11中，这是通过将PIN放在openssl.cnf文件中来达到
（在上面的例子中， ``/opt/pkcs11/usr/ssl/openssl.cnf`` ）。

openssl.cnf文件的位置可以在运行 ``named`` 之前通过设置
OPENSSL_CONF环境变量进行覆盖。

openssl.cnf例子：

::

       openssl_conf = openssl_def
       [ openssl_def ]
       engines = engine_section
       [ engine_section ]
       pkcs11 = pkcs11_section
       [ pkcs11_section ]
       PIN = <PLACE PIN HERE>

这也将允许dnssec-\*工具无需PIN入口码就能够访问HSM。（pkcs11-\*
工具直接访问HSM，不经过OpenSSL，所以仍然需要一个PIN来使用它们。）

在原生PKCS#11模式，PIN可以在一个作为密钥标记的一个属性所指定
的文件中提供。例如，如果一个密钥有一个标记
``pkcs11:object=local-zsk;pin-source=/etc/hsmpin`` ，就可以从
文件 ``/etc/hsmpin`` 中读到PIN。

.. warning::

   在这个方式中，将HSM的PIN放在一个文本文件中可能减少使用一个
   HSM的安全优势。在以这种方式配置系统之前，确认这就是你想要
   的方式。
