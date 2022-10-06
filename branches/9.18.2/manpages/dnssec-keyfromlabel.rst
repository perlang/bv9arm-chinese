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

.. iscman:: dnssec-keyfromlabel
.. program:: dnssec-keyfromlabel
.. _man_dnssec-keyfromlabel:

dnssec-keyfromlabel - DNSSEC密钥生成工具
------------------------------------------------

概要
~~~~~~~~

:program:`dnssec-keyfromlabel` {**-l** label} [**-3**] [**-a** algorithm] [**-A** date/offset] [**-c** class] [**-D** date/offset] [**-D** sync date/offset] [**-E** engine] [**-f** flag] [**-G**] [**-I** date/offset] [**-i** interval] [**-k**] [**-K** directory] [**-L** ttl] [**-n** nametype] [**-P** date/offset] [**-P** sync date/offset] [**-p** protocol] [**-R** date/offset] [**-S** key] [**-t** type] [**-v** level] [**-V**] [**-y**] {name}

描述
~~~~~~~~~~~

:program:`dnssec-keyfromlabel` 生成一个密钥对的文件，文件指向存储在一个
加密机硬件服务模块（HSM）中的一个密钥对象。私钥文件可以用于
DNSSEC对区数据的签名，就如同它是一个由 :iscman:`dnssec-keygen` 所创建
的传统签名密钥一样，但是密钥介质是存放在HSM内并且实际上签名也在其
中进行。

密钥的 ``name`` 在命令行指定。这必须与为其生成密钥的区的名字相匹
配。

选项
~~~~~~~

.. option:: -a algorithm

   本选项选择加密算法。 ``algorithm`` 的值必须为RSASHA1，NSEC3RSASHA1，
   RSASHA256，RSASHA512，ECDSAP256SHA256，ECDSAP384SHA384，
   ED25519或ED448之一。

   如果未指定算法，缺省使用RSASHA1，除非指定了 :option:`-3` 选项，这时
   使用NSEC3RSASHA1。（如果使用了 :option:`-3` 并指定了一个算法，将
   检查这个算法对NSEC3的兼容性。）

   这些值是大小写不敏感的。在某些情况，也支持缩写，如ECDSA256代
   表ECDSAP256SHA256，而ECDSA384代表ECDSAP384SHA384。如果指定
   RSASHA1并且同时使用 :option:`-3` 选项，就使用NSEC3RSASHA1替代。

   从BIND 9.12.0开始，这个选项是必须的，除了使用 :option:`-S` 选项时，
   这时将从前一个密钥中拷贝算法。之前，对于新生成密钥的缺省算
   法是RSASHA1。

.. option:: -3

   本选项使用NSEC3兼容算法生成一个DNSSEC密钥。如果这个选项与同时具有
   NSEC和NSEC3两个版本的算法一起使用，就会使用NSEC3版本；例如，
   ``dnssec-keygen -3a RSASHA1`` 指定使用使用NSEC3RSASHA1算法。

.. option:: -E engine

   本选项指定要使用的加密硬件。

   当BIND带有OpenSSL构建时，这需要设置成OpenSSL引擎标识符，它驱动加密加
   速器或者硬件服务模块（通常 ``pkcs11`` ）。

.. option:: -l label

   本选项指定加密硬件中密钥对的标记。

   当BIND 9使用基于OpenSSL的PKCS#11支持构建时，这个标记是一个任意
   的字符串，它标识一个特定的密钥。它由一个可选的OpenSSL引擎名开头，
   后跟一个冒号，如 ``pkcs11:keylabel`` 。

.. option:: -n nametype

   本选项指定密钥的拥有者类型。 ``nametype`` 的值是ZONE（对DNSSEC的区密
   钥（KEY/DNSKEY）），HOST或ENTITY（对一个与主机（KEY）相关的密钥），
   USER（对一个与用户（KEY）相关的密钥）或OTHER（DNSKEY）。这些值是
   大小写不敏感的。

.. option:: -C

   本选项开启兼容模式，它生成一个旧风格的密钥，不带任何元数据。缺省时，
   :program:`dnssec-keyfromlabel` 将在存放于私钥的元数据中包含密钥的创建日
   期；其它日期也可以在其中设置，包括发布日期，激活日期等等。包含这些
   数据的密钥可能与旧版本的BIND不兼容； :option:`-C` 防止了这些情况。

.. option:: -c class

   本选项指示包含密钥的DNS记录应该具有指定的类。如果未指定，使用类IN。

.. option:: -f flag

   本选项在KEY/DNSKEY记录的 ``flag`` 字段中设置特定的标志。只能被识别的
   标志是KSK（密钥签名密钥）和REVOKE。

.. option:: -G

   本选项生成一个密钥，但是不发布它，也不使用它签名。这个选项与 :option:`-P`
   和 :option:`-A` 不兼容。

.. option:: -h

   本选项打印 :program:`dnssec-keyfromlabel` 的选项和参数的简短摘要。

.. option:: -K directory

   本选项设置写密钥文件的目录。

.. option:: -k

   本选项生成KEY记录而不是DNSKEY记录。

.. option:: -L ttl

   本选项设置本密钥在被转换进一个DNSKEY资源记录中时的缺省TTL值。当这
   个密钥被导入到一个区，这就被用作密钥的TTL，除非区中已经有一个
   DNSKEY资源记录集，在后者的情况下，已经存在的TTL将会优先。将缺省
   的TTL设置为 ``0`` 或者 ``none`` 来删除它。

.. option:: -p protocol

   本选项为密钥设置协议值。协议是一个0到255之间的数。缺省是3（DNSSEC）。
   这个参数的其它可能值在 :rfc:`2535` 及其后继中列出。

.. option:: -S key

   本选项生成一个密钥，作为一个现存密钥的明确后继。这个密钥的名字，算法，
   大小和类型要设置成与其前驱相匹配。新密钥的激活日期设置成现存密
   钥的失活日期。公开日期设置成激活日期减去预先公开的间隔，后者缺
   省为30天。

.. option:: -t type

   本选项指定密钥的类型。 ``type`` 必须是AUTOCONF，NOAUTHCONF，NOAUTH或
   NOCONF之一。缺省是AUTHCONF。AUTH为认证数据的能力，而CONF为加密
   数据的能力。

.. option:: -v level

   本选项设置调试级别。

.. option:: -V

   本选项打印版本信息。

.. option:: -y

   本选项允许生成DNSSEC密钥文件，即使在密钥ID会与一个已存在的密钥冲突，
   一旦发生这种冲突，两个密钥都会被撤销。（这仅在 :rfc:`5011`
   信任锚点维护未用于这两个密钥时，才是安全的。）

定时选项
~~~~~~~~~~~~~~

日期可以被表示成YYYYMMDD或YYYYMMDDHHMMSS格式。如果参数以 ``+`` 或 ``-``
开始，它将会被解释成自当前时间始的偏移量。为方便起见，如果这个偏移量
带有这些后缀之一， ``y`` ， ``mo`` ， ``w`` ， ``d`` ， ``h`` 或
``mi`` ，这个偏移量就分别被以年（定义为365个24小时的天，忽略闰年），
月（定义为30个24小时的天），周，天，小时或分钟计算。没有后缀时，偏移量
以秒计算。要显式阻止设置一个日期，使用 ``none`` 或 ``never`` 。

.. option:: -P date/offset

   本选项设置一个密钥被发布到区的日期。在此日期之后，密钥被包含到区
   中，但不会用于对其签名。如果未设置，并且没有使用 :option:`-G` 选项，缺省是
   当前日期。

.. option:: -P sync date/offset

   本选项设置匹配这个密钥的CDS和CDNSKEY记录被发布到区的日期。

.. option:: -A date/offset

   本选项设置密钥被激活的日期。在此日期之后，密钥将会被包含到区中并用于
   对其签名。如果未设置，并且没有使用 :option:`-G` 选项，缺省是当前日期。

.. option:: -R date/offset

   本选项设置密钥被撤销的日期。在此日期之后，密钥将被标志为被撤销。它将
   会被包含到区中并用于对其签名。

.. option:: -I date/offset

   本选项设置密钥退出的日期。在此日期之后，密钥仍然被包含在区中，但它
   不再被用于签名。

.. option:: -D date/offset

   本选项设置密钥被删除的日期。在此日期之后，密钥不再被包含在区中。（
   然而，它可能仍然保留在密钥仓库中。）

.. option:: -D sync date/offset

   本选项设置匹配这个密钥的CDS和CDNSKEY记录被删除的日期。

.. option:: -i interval

   本选项为一个密钥设置发布前间隔。如果设置，则发布日期与激活日期之间必
   须至少间隔这么多的日期。如果指定了激活日期而没有指定发布日期，
   则发布日期缺省为激活日期之前这么多时间；相反地，如果指定了发布
   日期但没有指定激活日期，则激活日期将被设置为在发布日期之后这么
   多时间。

   正在被创建的密钥是另一个密钥的明确后继，则缺省的发布前间隔是30
   天；否则就是零。

   与日期偏移量相伴，如果参数后面有后缀 ``y`` ， ``mo`` ， ``w`` ，
   ``d`` ， ``h`` ，或 ``mi`` 中的一个，则间隔的单位分别为年，月，周，
   天，小时，分钟。没有后缀的情况，间隔的单位为秒。

生成的密钥文件
~~~~~~~~~~~~~~~~~~~

当 :program:`dnssec-keyfromlabel` 完全成功时，它打印一个
``Knnnn.+aaa+iiiii`` 格式的字符串到标准输出。这是其生成的密钥的
标识字符串。

-  ``nnnn`` 是密钥名。

-  ``aaa`` 是算法的数字表示。

-  ``iiiii`` 是密钥标识符（或足迹）。

:program:`dnssec-keyfromlabel` 创建两个文件，其名字类似这个打印的字符
串。 ``Knnnn.+aaa+iiiii.key`` 包含公钥，而
``Knnnn.+aaa+iiiii.private`` 包含私钥。

``.key`` 文件包含一个DNS KEY记录，可以（直接或使用一个$INCLUDE
语句）插入到一个区文件中。

``.private`` 文件包含算法相关字段。由于明显的安全原因，这个文件
不能具有任何人可读的权限。

参见
~~~~~~~~

:iscman:`dnssec-keygen(8) <dnssec-keygen>`, :iscman:`dnssec-signzone(8) <dnssec-signzone>`, BIND 9管理员参考手册,
:rfc:`4034`, :rfc:`7512` 。
