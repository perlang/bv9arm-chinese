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


.. highlight: console

.. _man_dnssec-settime:

dnssec-settime: 为一个DNSSEC密钥设置密钥定时元数据
------------------------------------------------------------

概要
~~~~~~~~

:program:`dnssec-settime` [**-f**] [**-K** directory] [**-L** ttl] [**-P** date/offset] [**-P** sync date/offset] [**-A** date/offset] [**-R** date/offset] [**-I** date/offset] [**-D** date/offset] [**-D** sync date/offset] [**-S** key] [**-i** interval] [**-h**] [**-V**] [**-v** level] [**-E** engine] {keyfile} [**-s**] [**-g** state] [**-d** state date/offset] [**-k** state date/offset] [**-r** state date/offset] [**-z** state date/offset]

描述
~~~~~~~~~~~

``dnssec-settime`` 读取一个DNSSEC私钥文件并按照 ``-P`` ， ``-A`` ，
``-R`` ， ``-I`` 和 ``-D`` 选项的指定设置密钥定时的元数据。元数据
可以用于 ``dnssec-signzone`` 或其它签名软件，以决定何时发布一个密
钥，密钥是否可以用于对一个区签名等等。

如果命令行中没有设置这些选项， ``dnssec-settime`` 只是简单地打印
已经存储在密钥中的密钥定时元数据。

当密钥的元数据字段被改变时，密钥对的两个文件（
``Knnnn.+aaa+iiiii.key`` 和
``Knnnn.+aaa+iiiii.private`` ）都被重新生成。

元数据字段存放在private文件中。在key文件中也以注释形式存放一份人
可读的元数据描述。私钥文件的权限总是被设置为除属主外任何人都不可
访问（模式0600）。

在与状态文件同时工作时，可能更新这些文件中的定时元数据，如同使用
``-s`` 。如果使用了这个选项，你也可以使用 ``-d`` （DS），
``-k`` （DNSKEY）， ``-r`` （KSK的RRSIG）或 ``-z`` （ZSK的RRSIG）
更新密钥状态。允许的状态为HIDDEN，RUMOURED，OMNIPRESENT和
UNRETENTIVE。

你还可以使用 ``-g`` 设置密钥的目标状态。这个只能是HIDDEN或
OMNIPRESENT（表示密钥是否应该从区中删去或者发布）。

除非是用于测试，不推荐手工操作状态文件。

选项
~~~~~~~

**-f**
   强制更新一个不带元数据字段的旧格式的密钥。如果没有这个选项，
   ``dnssec-settime`` 在试图更新一个旧密钥时将会失败。有这个选项
   时，将会以新格式重新生成密钥，但是会保留原始的密钥数据。密钥
   的创建日期会被设置为当前时间。如果未指定其它值，密钥的发布日
   期和激活日期也将被设置为当前时间。

**-K** directory
   设置存放密钥文件的目录。

**-L** ttl
   设置本密钥在被转换进一个DNSKEY资源记录中时的缺省TTL值。如果这
   个密钥被导入进一个区，这就被用作密钥的TTL，除非区中已经有一个
   DNSKEY资源记录集，在后者的情况下，已经存在的TTL将会优先。如果
   未设置这个值并且不存在DNSKEY资源记录集，TTL缺省将是SOA TTL。
   将缺省的TTL设置为 ``0`` 或者 ``none`` 从密钥中删除它。

**-h**
   输出用法消息并退出。

**-V**
   打印版本信息。

**-v** level
   设置调试级别。

**-E** engine
   如果适用，指定要使用的加密硬件。

   当BIND使用带OpenSSL PKCS#11支持构建时，这个缺省值是字符串
   “pkcs11”，它标识一个可以驱动一个加密加速器或硬件服务模块的
   OpenSSL引擎，当BIND使用带原生PKCS#11加密
   （--enable-native-pkcs11）构建时，它缺省是由“--with-pkcs11”
   指定的PKCS#11提供者库的路径。

定时选项
~~~~~~~~~~~~~~

日期可以被表示成YYYYMMDD或YYYYMMDDHHMMSS格式。如果参数以‘+’或
‘-’开始，它将会被解释成自当前时间始的偏移量。为方便起见，如果
这个偏移量带有这些后缀之一，‘y’，‘mo’，‘w’，‘d’，‘h’或‘mi’，
这个偏移量就分别被以年（定义为365个24小时的天，忽略闰年），月
（定义为30个24小时的天），周，天，小时或分钟计算。没有后缀时，
偏移量以秒计算。要清除一个日期，使用‘none’或‘never’。

**-P** date/offset
   设置一个密钥被发布到区的日期。在此日期之后，密钥将会被包含到
   区中，但不会用于对其签名。

**-P** sync date/offset
   设置匹配这个密钥的CDS和CDNSKEY记录被发布到区的日期。

**-A** date/offset
   设置密钥被激活的日期。在此日期之后，密钥将会被包含到区中并用
   于对其签名。

**-R** date/offset
   设置密钥被撤销的日期。在此日期之后，密钥将被标志为被撤销。它
   将会被包含到区中并用于对其签名。

**-I** date/offset
   设置密钥被退休的日期。在此日期之后，密钥仍然被包含在区中，但
   它不再被用于签名。

**-D** date/offset
   设置密钥被删除的日期。在此日期之后，密钥将不再被包含在区中。
   （然而，它可能仍然保留在密钥仓库中。）

**-D** sync date/offset
   设置匹配这个密钥的CDS和CDNSKEY记录被删除的日期。

**-S** predecessor key
   选择一个密钥，被修改的密钥是其明确的后继。前驱密钥的名字，算
   法，大小，和类型必须与被修改密钥的精确匹配。后继密钥的激活日
   期将被设置为前驱密钥的失效日期。其发布日期被设置为激活日期减
   去发布前间隔，后者缺省是30天。

**-i** interval
   为一个密钥设置发布前间隔。如果设置，则发布日期与激活日期之间
   必须至少间隔这么多的日期。如果指定了激活日期而没有指定发布日
   期，则发布日期缺省为激活日期之前这么多时间；相反地，如果指定
   了发布日期但没有指定激活日期，则激活日期将被设置为在发布日期
   之后这么多时间。

   正在被创建的密钥是另一个密钥的明确后继，则缺省的发布前间隔是
   30天；否则就是零。

   与日期偏移量相伴，如果参数后面有后缀‘y’，‘mo’，‘w’，‘d’，‘h’，
   或‘mi’中的一个，则间隔的单位分别为年，月，周，天，小时，分钟。
   没有后缀的情况，间隔的单位为秒。

密钥状态选项
~~~~~~~~~~~~~~~~~

已知的密钥状态有HIDDEN，RUMOURED，OMNIPRESENT和UNRETENTIVE。
除非用于测试目的，不应该手工修改这些选项。

``-s``
   当设置密钥计时数据时，也更新状态文件。

``-g``
   设置这个密钥的目标状态。必须是HIDDEN或OMNIPRESENT。

``-d``
   设置这个密钥的DS状态，以及它的最后修改时间。

``-k``
   设置这个密钥的DNSKEY状态，以及它的最后修改时间。

``-r``
   设置这个密钥的RRSIG（KSK）状态，以及它的最后修改时间。

``-z``
   设置这个密钥的RRSIG（ZSK）状态，以及它的最后修改时间。

打印选项
~~~~~~~~~~~~~~~~

``dnssec-settime`` 也能够被用于打印出与一个密钥相关联的定时元
数据。

**-u**
   打印UNIX纪元格式的时间。

**-p** C/P/Psync/A/R/I/D/Dsync/all
   打印一个指定的元数据值或元数据值的集合。 ``-p`` 选项可以跟随
   一个或多个下列字符或字符串，以表示要打印哪一个或哪几个值：
   ``C`` 表示创建日期， ``P`` 表示发布日期， ``Psync`` 表示CDS
   和CDNSKEY发布日期， ``A`` 表示激活日期， ``R`` 表示撤销日期，
   ``I`` 表示失效日期， ``D`` 表示删除日期和 ``Dsync`` 表示CDS
   和CDNSKEY删除日期，使用 ``-p all`` 打印所有的元数据。

参见
~~~~~~~~

:manpage:`dnssec-keygen(8)`, :manpage:`dnssec-signzone(8)`, BIND 9管理员参考手册,
:rfc:`5011`.
