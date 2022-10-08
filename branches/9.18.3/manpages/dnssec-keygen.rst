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

.. highlight: console

.. iscman:: dnssec-keygen
.. program:: dnssec-keygen
.. _man_dnssec-keygen:

dnssec-keygen: DNSSEC密钥生成工具
-----------------------------------------

概要
~~~~~~~~

:program:`dnssec-keygen` [**-3**] [**-A** date/offset] [**-a** algorithm] [**-b** keysize] [**-C**] [**-c** class] [**-D** date/offset] [**-d** bits] [**-D** sync date/offset] [**-E** engine] [**-f** flag] [**-G**] [**-g** generator] [**-h**] [**-I** date/offset] [**-i** interval] [**-K** directory] [**-k** policy] [**-L** ttl] [**-l** file] [**-n** nametype] [**-P** date/offset] [**-P** sync date/offset] [**-p** protocol] [**-q**] [**-R** date/offset] [**-S** key] [**-s** strength] [**-T** rrtype] [**-t** type] [**-V**] [**-v** level] {name}

描述
~~~~~~~~~~~

:program:`dnssec-keygen` 为DNSSEC（安全DNS）生成密钥，在 :rfc:`2535` 和
:rfc:`4034` 中定义。它也可以为使用在 :rfc:`2845` 中所定义的TSIG（事务
签名）或在 :rfc:`2930` 中所定义的TKEY（事务密钥）生成密钥。

密钥的 ``name`` 在命令行指定。对于DNSSEC密钥，这必须与为其生成密钥的
区的名字相匹配。

选项
~~~~~~~

.. option:: -3

   本选项使用一个适用于NSEC3的算法生成一个DNSSEC密钥。如果这个选项与一
   个同时具有NSEC和NSEC3版本的算法一起使用，将会选择NSEC3版本；例如，
   ``dnssec-keygen -3a RSASHA1`` 指定了NSEC3RSASHA1算法。

.. option:: -a algorithm

   本选项选择加密算法。对DNSSEC密钥， ``algorithm`` 的值必须为RSASHA1，
   NSEC3RSASHA1，RSASHA256，RSASHA512，ECDSAP256SHA256，
   ECDSAP384SHA384，ED25519或ED448之一。对TKEY，其值必须为
   DH（Diffie-Hellman）；指定它的值会自动设置 :option:`-T KEY <-T>` 选项。

   这些值是大小写不敏感的。在某些情况，也支持缩写，如ECDSA256代表
   ECDSAP256SHA256，而ECDSA384代表ECDSAP384SHA384。如果指定RSASHA1并
   且同时使用 :option:`-3` 选项，将使用NSEC3RSASHA1替代。

   这个选项 **必须** 被指定，除了使用 :option:`-S` 选项时，这时将从前一个
   密钥中拷贝算法。

   在先前的版本，HMAC算法可以用作生成TSIG密钥，但是这个特性在
   BIND 9.13.0已被移除了。使用 :iscman:`tsig-keygen` 生成TSIG密钥。

.. option:: -b keysize

   本选项指定密钥的位数。密钥大小的选择依赖于所使用的算法：RSA密钥必须
   在1024和4096位之间；Diffie Hellman密钥必须在128和4096位之间。椭圆
   曲线算法不需要这个参数。

   如果未指定密钥大小，一些算法具有预定义的缺省值。例如，用于DNSSEC
   区签名密钥的RSA密钥具有一个缺省为1024位的大小；用于密钥签名密钥
   （KSK，由 :option:`-f KSK <-f>` 生成）的缺省大小为2048位。

.. option:: -C

   本选项开启兼容模式，它生成一个旧风格的密钥，不带任何时间元数据。缺省
   时， :program:`dnssec-keygen` 在存放于私钥的元数据中包含密钥的创建日期，
   其它日期也可以在其中设置，包括发布日期，激活日期等等。包含这些数
   据的密钥可能与旧版本的BIND不兼容； :option:`-C` 选项防止了这些情况。

.. option:: -c class

   本选项指示包含密钥的DNS记录应该具有指定的类。如果未指定，使用类IN。

.. option:: -d bits

   本选项指定以位为单位的密钥大小。对于算法 RSASHA1，NSEC3RSASA1，
   RSASHA256和RSASHA512，密钥大小必须在1024到4096位之间。DH大小在128和
   4096位之间。对于算法ECDSAP256SHA256，ECDSAP384SHA384，ED25519和ED448，
   这个选项被忽略。

.. option:: -E engine

   如果适用，本选项指定要使用的加密硬件。

   当BIND带有OpenSSL构建时，这需要设置成OpenSSL引擎标识符，它驱动加密加
   速器或者硬件服务模块（通常 ``pkcs11`` ）。

.. option:: -f flag

   本选项在KEY/DNSKEY记录的标志字段中设置特定的标志。只能被识别的标志是
   KSK（密钥签名密钥）和REVOKE。

.. option:: -G

   本选项生成一个密钥，但是不发布它，也不使用它签名。这个选项与 :option:`-P`
   和 :option:`-A` 不兼容。

.. option:: -g generator

   如果生成一个Diffie Hellman密钥，本选项指示使用这个生成器。允许值为2
   到5。如果未指定生成器，如果可能，就使用来自 :rfc:`2539` 的著名素数；
   否则缺省为2。

.. option:: -h

   本选项打印 :program:`dnssec-keygen` 的选项和参数的简短摘要。

.. option:: -K directory

   本选项设置写密钥文件的目录。

.. option:: -k policy

   本选项为指定的 ``dnssec-policy`` 建立密钥。如果一个策略使用了多个密
   钥， :program:`dnssec-keygen` 将生成多个密钥。这还将建立一个“.state”文件来
   跟踪密钥状态。

   这个选项根据 ``dnssec-policy`` 配置建立密钥，因此它不能与
   :program:`dnssec-keygen` 提供的许多其它选项同时使用。

.. option:: -L ttl

   本选项设置本密钥在被转换进一个DNSKEY资源记录中时的缺省TTL值。当这
   个密钥被导入到一个区，这就被用作密钥的TTL，除非区中已经有一个
   DNSKEY资源记录集，在后者的情况下，已经存在的TTL将会优先。如果未
   设置这个值并且不存在DNSKEY资源记录集，TTL缺省将是SOA TTL。将缺
   省的TTL设置为 ``0`` 或者 ``none`` 与不设置它有同样的效果。

.. option:: -l file

   本选项提供一个包含 ``dnssec-policy`` 语句（与使用 :option:`-k` 时的策略设
   置相匹配）的配置文件。

.. option:: -n nametype

   本选项指定密钥的拥有者类型。 ``nametype`` 的值要么是ZONE（对DNSSEC的
   区密钥（KEY/DNSKEY）），HOST或ENTITY（对一个与主机（KEY）相关的
   密钥），USER（对一个与用户（KEY）相关的密钥）或OTHER（DNSKEY）。
   这些值是大小写不敏感的。缺省是ZONE，用于DNSKEY生成。

.. option:: -p protocol

   本选项为生成的密钥设置协议值，与 :option:`-T KEY <-T>` 一起使用。协议是一个0到
   255之间的数。缺省是3（DNSSEC）。这个参数的其它可能值在
   :rfc:`2535` 及其后继中列出。

.. option:: -q

   本选项设置安静模式，它拟制不必要的输出，也包含进度指示。在没有这个选
   项时，当交互式运行 :program:`dnssec-keygen` 来生成一个RSA或DSA密钥对时，它
   会打印一串符号到 ``stderr`` ，以指示生成密钥的进度。一个 ``.`` 表
   示发现一个随机数，它被传递给一个初始化过滤测试； ``+`` 表示一个随
   机数被传递给一个单轮Miller-Rabin primality测试；一个空格表示
   随机数被传递给所有的测试并且是一个合格的密钥。

.. option:: -S key

   本选项创建一个新密钥，它是一个当前存在密钥的明确的后继。这个密钥的名
   字，算法，大小，和类型都被设置为与现存密钥向匹配。新密钥的激活
   日期设置为现存密钥的失效日期。其发布日期被设置为激活日期减去发
   布前间隔，后者缺省是30天。

.. option:: -s strength

   本选项指定密钥的强度值。这个强度是0到15之间的一个数，当前在DNSSEC中
   没有定义其意图。

.. option:: -T rrtype

   本选项为密钥指定所使用的资源记录类型。 ``rrtype`` 必须是DNSKEY或KEY。
   在使用一个DNSSEC算法时，缺省是DNSKEY，但是与SIG(0)一起使用时，
   它可以被覆盖为KEY。

.. option:: -t type

   本选项指定与 :option:`-T KEY <-T>` 一起使用的密钥的类型。 ``type`` 必须是
   AUTOCONF，NOAUTHCONF，NOAUTH或NOCONF之一。缺省是AUTHCONF。
   AUTH为认证数据的能力，而CONF为加密数据的能力。

.. option:: -V

   本选项打印版本信息。

.. option:: -v level

   本选项设置调试级别。

定时选项
~~~~~~~~~~~~~~

日期可以被表示成YYYYMMDD或YYYYMMDDHHMMSS格式。如果参数以 ``+`` 或 ``-``
开始，它将会被解释成自当前时间始的偏移量。为方便起见，如果这个偏
移量带有这些后缀之一， ``y`` ， ``mo`` ， ``w`` ， ``d`` ， ``h`` 或
``mi`` ，这个偏移量就分别被以年（定义为365个24小时的天，忽略闰年），月
（定义为30个24小时的天），周，天，小时或分钟计算。没有后缀时，偏移量以
秒计算。要显式阻止设置一个日期，使用 ``none`` 或 ``never`` 。

.. option:: -P date/offset

   本选项设置一个密钥被发布到区的日期。在此日期之后，密钥将会被包含到
   区中，但不会用于对其签名。如果未设置，并且没有使用 :option:`-G` 选项，缺
   省是当前日期。

   .. program:: dnssec-keygen -P
   .. option:: sync date/offset

      本选项设置匹配这个密钥的CDS和CDNSKEY记录被发布到区的日期。

.. program:: dnssec-keygen

.. option:: -A date/offset

   本选项设置密钥被激活的日期。在此日期之后，密钥被包含到区中并用于
   对其签名。如果未设置，并且没有使用 :option:`-G` 选项，缺省是当前日期。如果
   设置，并且未设置 :option:`-P` ，公开日期将被设置为激活日期减去提前公开的间
   隔。

.. option:: -R date/offset

   本选项设置密钥被撤销的日期。在此日期之后，密钥将被标志为被撤销。它将
   会被包含到区中并用于对其签名。

.. option:: -I date/offset

   本选项设置密钥退出的日期。在此日期之后，密钥仍然被包含在区中，但它
   不再被用于签名。

.. option:: -D date/offset

   本选项设置密钥被删除的日期。在此日期之后，密钥将不再被包含在区中。
   （然而，它可能仍然保留在密钥仓库中。）

   .. program:: dnssec-keygen -D
   .. option:: sync date/offset

      本选项设置匹配这个密钥的CDS和CDNSKEY记录被删除的日期。

.. program:: dnssec-keygen

.. option:: -i interval

   本选项为一个密钥设置发布前间隔。如果设置，则发布日期与激活日期之间必
   须至少间隔这么多的日期。如果指定了激活日期而没有指定发布日期，
   则发布日期缺省为激活日期之前这么多时间；相反地，如果指定了发布
   日期但没有指定激活日期，则激活日期被设置为在发布日期之后这么
   多时间。

   正在被创建的密钥是另一个密钥的明确后继，则缺省的发布前间隔是30
   天；否则就是零。

   与日期偏移量相伴，如果参数后面有后缀 ``y`` ， ``mo`` ， ``w`` ，
   ``d`` ， ``h`` ，或 ``mi`` 中的一个，则间隔的单位分别为年，月，周，
   天，小时，分钟。没有后缀的情况，间隔的单位为秒。

生成的密钥
~~~~~~~~~~~~~~

当 :program:`dnssec-keygen` 完全成功时，它打印一个 ``Knnnn.+aaa+iiiii``
格式的字符串到标准输出。这是其生成的密钥的标识字符串。

-  ``nnnn`` 是密钥名。

-  ``aaa`` 是算法的数字表示。

-  ``iiiii`` 是密钥标识符（或足迹）。

:program:`dnssec-keygen` 创建两个文件，其名字类似这个打印的字符串。
``Knnnn.+aaa+iiiii.key`` 包含公钥，而 ``Knnnn.+aaa+iiiii.private``
包含私钥。

``.key`` 文件包含一个DNSKEY或者KEY记录。当一个区被 :iscman:`named` 或者
:option:`dnssec-signzone -S` 签名时，DNSKEY记录是自动被包含进去的。在其
它情况下， ``.key`` 文件可以手工或使用一个 ``$INCLUDE`` 语句插入
到一个区文件中。

``.private`` 文件包含算法相关字段。由于明显的安全原因，这个文件不
能具有任何人可读的权限。

例子
~~~~~~~

要为区 ``example.com`` 生成一个ECDSAP256SHA256区签名密钥，执行
命令：

.. option:: dnssec-keygen -a ECDSAP256SHA256 example.com

命令打印下列格式的字符串：

.. option:: Kexample.com.+013+26160

在这个例子中， :program:`dnssec-keygen` 建立文件
``Kexample.com.+013+26160.key`` 和
``Kexample.com.+013+26160.private`` 。

要生成一个对应的密钥签名密钥，执行命令：

.. option:: dnssec-keygen -a ECDSAP256SHA256 -f KSK example.com

参见
~~~~~~~~

:iscman:`dnssec-signzone(8) <dnssec-signzone>`, BIND 9管理员参考手册, :rfc:`2539`,
:rfc:`2845`, :rfc:`4034`.
