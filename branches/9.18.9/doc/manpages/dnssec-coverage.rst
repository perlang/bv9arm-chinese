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

.. _man_dnssec-coverage:

dnssec-coverage - 检查一个区DNSKEY将来的覆盖
----------------------------------------------------------

概要
~~~~~~~~

``dnssec-coverage`` [**-K**\ *directory*] [**-l**\ *length*]
[**-f**\ *file*] [**-d**\ *DNSKEY TTL*] [**-m**\ *max TTL*]
[**-r**\ *interval*] [**-c**\ *compilezone path*] [**-k**] [**-z**]
[zone...]

描述
~~~~~~~~~~~

``dnssec-coverage`` 验证一个给定的区或一个区集合的DNSSEC密钥是
正确设置了定时元数据以确保将来没有DNSSEC覆盖的失误。

如果指定了 ``zone`` ，在密钥仓库中与这个区匹配的密钥都会被扫描，
并为那个密钥生成一个事件日程的顺序列表（如，发布，激活，失效，
删除）。事件列表以发生顺序遍历。如果任何事件在进行时，可能导致
区进入一个可能发生验证失败的状态时，会生成一个警告。例如，如果
一个对给定算法，其发布或激活的密钥数下降到零，或者如果一个密钥
在一个新密钥轮转后从其区中被太快地删除，由前一个密钥签名的缓存
数据还没时间从解析器的缓存中过期。 

如果未指定 ``zone`` ，在密钥仓库中的所有密钥都会被扫描，所有带
密钥的区都会被分析。（注意：这个报告方法只在所有带有给定仓库中
密钥的区共享同样的TTL参数时才是精确的。）

选项
~~~~~~~

**-K** *directory*

   设置能够找到密钥的目录。缺省为当前工作目录。

**-f** *file*

   如果指定了一个 ``file`` ，区就从那个文件读取；最大TTL和
   DNSKEY TTL就直接从区数据决定，就不需要在命令行指定 ``-m``
   和 ``-d`` 选项。

**-l** *duration*

   检查DNSSEC覆盖的时间长度。计划在超过 ``duration`` 的将来的
   密钥事件将被忽略，并假设为正确的。

   ``duration`` 的值可以按秒设置，或通过增加一个后缀设为更大的
   时间单位：mi表示分钟，h表示小时，d表示天，w表示周，mo表示月，
   y表示年。

**-m** *maximum TTL*

   在决定是否存在一个验证失败的可能性时，为一个或多个被分析的
   区设置最大TTL值。当一个区签名密钥失效时，在密钥被剔除出
   DNSKEY资源记录集之前，必须有足够的时间，让区中最大TTL的记录
   在解析器的缓存中过期。如果这个条件不满足，将会产生一个警告。

   TTL长度可以按秒设置，或通过增加一个后缀设为更大的时间单位：
   mi表示分钟，h表示小时，d表示天，w表示周，mo表示月，y表示年。

   如果使用 ``-f`` 指定了一个区文件，这个选项是不必要的。如果
   指定了 ``-f`` ，仍然可以使用这个选项；它将覆盖在文件中发现
   的值。

   如果没有使用这个选项并且不能从一个区文件提取到最大TTL，将生
   成一个警告，并使用1周作为缺省值。

**-d** *DNSKEY TTL*

   在决定是否存在一个验证失败的可能性时，为一个或多个被分析的
   区设置用作DNSKEY TTL的值。当一个密钥被轮转时（即被一个新密
   钥替代），在新密钥被激活并开始生成签名之前，必须有足够的时
   间让旧的DNSKEY资源记录集在解析器缓存中过期。如果这个条件不
   满足，将会产生一个警告。

   TTL长度可以按秒设置，或通过增加一个后缀设为更大的时间单位：
   mi表示分钟，h表示小时，d表示天，w表示周，mo表示月，y表示年。

   如果使用 ``-f`` 指定了一个区文件来读入DNSKEY资源记录集的
   TTL，或者使用 ``dnssec-keygen`` 的 ``-L`` 设定一个缺省的密
   钥TTL，这个选项是不必要的。如果上述一项是真，仍然可以使用
   这个选项；它将覆盖在区文件或密钥文件中发现的值。

   如果没有使用这个选项并且不能从区文件或密钥文件提取到密钥TTL，
   将生成一个警告，并使用1天作为缺省值。

**-r** *resign interval*

   在决定是否存在一个验证失败的可能性时，为一个或多个被分析的
   区设置用作放弃间隔（resign interval）的值。这个值缺省为22.5
   天，也是 ``named`` 中的缺省值。然而，如果在named.conf使用
   ``sig-validity-interval`` 选项修改了，它应该在这里被修改。

   TTL长度可以按秒设置，或通过增加一个后缀设为更大的时间单位：
   mi表示分钟，h表示小时，d表示天，w表示周，mo表示月，y表示年。

**-k**

   只检查KSK覆盖；忽略ZSK事件。不能与 ``-z`` 一起使用。

**-z**

   只检查ZSK覆盖；忽略KSK事件。不能与 ``-k`` 一起使用。

**-c** *compilezone path*

   指定一个 ``named-compilezone`` 二进制文件的路径。用于测试。

参见
~~~~~~~~

``dnssec-checkds``\ (8), ``dnssec-dsfromkey``\ (8),
``dnssec-keygen``\ (8), ``dnssec-signzone``\ (8)
