.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
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

.. _man_dnssec-importkey:

dnssec-importkey - 从外部系统导入DNSKEY记录从而可对其进行管理
-------------------------------------------------------------------------------------

概要
~~~~~~~~

:program:`dnssec-importkey` [**-K** directory] [**-L** ttl] [**-P** date/offset] [**-P** sync date/offset] [**-D** date/offset] [**-D** sync date/offset] [**-h**] [**-v** level] [**-V**] {keyfile}

:program:`dnssec-importkey` {**-f** filename} [**-K** directory] [**-L** ttl] [**-P** date/offset] [**-P** sync date/offset] [**-D** date/offset] [**-D** sync date/offset] [**-h**] [**-v** level] [**-V**] [dnsname]

描述
~~~~~~~~~~~

``dnssec-importkey`` 读一个公共DNSKEY记录并生成一对.key/.private文件。
DNSKEY记录可以从一个现存的.key文件中读入，这种情况将会生成一个相关的
.private文件，或者它可以从任何其它文件或者标准输入读入，这时将会生成
.key和.private文件。

新建立的.private文件不包含私钥数据， **不能** 用于签名。但是，有一个
.private文件使得设置密钥的发布（ ``-P`` ）和删除（ ``-D`` ）时间成为
可能，这意谓着即使真正的私钥是离线存放，也可以按预计计划将公钥添加到
DNSKEY资源记录集中，或从中删除。

选项
~~~~~~~

**-f** filename
   区文件模式：作为公钥文件名的替代，此参数是一个区主文件的域名，它
   可以从 ``file`` 中读入。如果这个域名与 ``file`` 相同，这个参数可
   以忽略。

   如果 ``file`` 被设置为 ``"-"`` ，区数据将从标准输入读入。

**-K** directory
   设置存放密钥文件的目录。

**-L** ttl
   设置本密钥在被转换进一个DNSKEY资源记录中时的缺省TTL值。如果这个密
   钥被导入进一个区，这就被用作密钥的TTL，除非区中已经有一个DNSKEY资
   源记录集，在后者的情况下，已经存在的TTL将会优先。将缺省的TTL设置
   为 ``0`` 或者 ``none`` 来删除它。

**-h**
   输出用法消息并退出。

**-v** level
   设置调试级别。

**-V**
   打印版本信息。

定时选项
~~~~~~~~~~~~~~

日期可以被表示成YYYYMMDD或YYYYMMDDHHMMSS格式。如果参数以‘+’或
‘-’开始，它将会被解释成自当前时间始的偏移量。为方便起见，如果
这个偏移量带有这些后缀之一，‘y’，‘mo’，‘w’，‘d’，‘h’或‘mi’，
这个偏移量就分别被以年（定义为365个24小时的天，忽略闰年），月
（定义为30个24小时的天），周，天，小时或分钟计算。没有后缀时，
偏移量以秒计算。要显式阻止设置一个日期，使用‘none’或‘never’。

**-P** date/offset
   设置一个密钥被发布到区的日期。在此日期之后，密钥将会被包含
   到区中，但不会用于对其签名。

**-P** sync date/offset
   设置匹配这个密钥的CDS和CDNSKEY记录被发布到区的日期。

**-D** date/offset
   设置密钥被删除的日期。在此日期之后，密钥将不再被包含在区中。
   （然而，它可能仍然保留在密钥仓库中。）

**-D** sync date/offset
   设置匹配这个密钥的CDS和CDNSKEY记录被删除的日期。

文件
~~~~~

密钥文件可以由密钥标识 ``Knnnn.+aaa+iiiii`` 来设计，或者为
dnssec-keygen8所生成的完整文件名 ``Knnnn.+aaa+iiiii.key`` 。

参见
~~~~~

:manpage:`dnssec-keygen(8)`, :manpage:`dnssec-signzone(8)`, BIND 9管理员参考手册,
:rfc:`5011`.
