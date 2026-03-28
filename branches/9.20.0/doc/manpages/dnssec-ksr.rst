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

.. iscman:: dnssec-ksr
.. program:: dnssec-ksr
.. _man_dnssec-ksr:

dnssec-ksr - 为离线KSK设置创建签名的密钥响应（SKR）文件
-------------------------------------------------------

概要
~~~~

:program:`dnssec-ksr` [**-E** engine] [**-e** date/offset] [**-F**] [**-h**] [**-i** date/offset] [**-K** directory] [**-k** policy] [**-l** file] [**-V**] [**-v** level] {command} {zone}

描述
~~~~

:program:`dnssec-ksr` 可以用于发出为一个区生成预签名资源记录集而需要用到的命令，
这种区的密钥签名密钥（KSK）的私钥文件一般都是离线的。这要求区签名密钥（ZSK）能
够被预生成，并且DNSKEY，CDNSKEY，和CDS资源记录集已被提前签名。

后者是通过创建可以导入到KSK可用环境中的密钥签名请求（KSR）来完成的。一旦导入，
此程序可以创建可以由权威DNS加载的签名的密钥响应（SKR）。

选项
~~~~

.. option:: -E engine

   这个选项指定要使用的加密硬件，如果适用。

   当带有OpenSSL构建BIND 9时，这需要被设置为OpenSSL的引擎标识符，后者驱动
   加密加速器或硬件服务模块（通常的 ``pkcs11`` ）。

.. option:: -e date/offset

   这个选项设置需要为其生成密钥或SKR的结束日期（依赖于命令）。

.. option:: -F

   如果底层加密库支持在FIPS模式中运行，这个选项开启FIPS（美国联邦信息处理
   标准）模式。

.. option:: -h

   这个选项输出 :program:`dnssec-ksr` 的选项和参数的简短概要。

.. option:: -i date/offset

   这个选项设置需要为其生成密钥或SKR的开始日期（依赖于命令）。

.. option:: -K directory

   这个选项设置进行读写操作的密钥文件所在的目录（依赖于命令）。

.. option:: -k policy

   这个选项为需要生成或签名的密钥设置特定的 ``dnssec-policy`` 。

.. option:: -l file

   这个选项提供一个包含一个 ``dnssec-policy`` 语句（与使用 :option:`-k`
   设置的策略匹配）的配置文件。

.. option:: -V

   这个选项输出版本信息。

.. option:: -v level

   这个选项设置调试级别。级别1旨在给普通用户提供足够详细的信息；更高的级别
   提供给开发人员。

``command``

   要执行的KSR命令。可用命令参见下文。

``zone``

   被执行的KSR命令针对的区的名字。

命令
~~~~

.. option:: keygen

  根据给定的DNSSEC策略和一个时间间隔提前生成多个区签名密钥（ZSK）。生成的
  密钥的数量依赖于时间间隔和ZSK生命周期。

.. option:: request

  根据给定的DNSSEC策略和一个时间间隔创建一个密钥签名请求（KSR）。这会生成
  含有多个密钥包的文件，其中每个包都包含了当前已发布的ZSK（依据时序元数据
  ）。

.. option:: sign

  对一个密钥签名请求（KSR）进行签名，根据给定的DNSSEC策略和一个时间间隔，
  创建一个已签名密钥响应（SKR）。这会为用于签名的KSK增加相应的DNSKEY、
  CDS和CDNSKEY记录。

退出状态
~~~~~~~~

:program:`dnssec-ksr` 命令在成功时退出0，如果发生某个错误，退出非0。

例子
~~~~

当你需要为区 "example.com" 生成下一年的密钥时，假定有一个名为"mypolicy"
的 ``dnssec-policy`` ：

::

    dnssec-ksr -i now -e +1y -k mypolicy -l named.conf keygen example.com

为同样的区和周期创建一个KSR，可用如下命令：

::

    dnssec-ksr -i now -e +1y -k mypolicy -l named.conf request example.com > ksr.txt

通常，你现在可以将KSR传送到有权限访问KSK的系统上。

给已创建的KSR签名，可用如下命令：

::

    dnssec-ksr -i now -e +1y -k kskpolicy -l named.conf -f ksr.txt sign example.com

确保 ``kskpolicy`` 中的DNSSEC参数与 ``mypolicy`` 中的匹配。

参见
~~~~

:iscman:`dnssec-keygen(8) <dnssec-keygen>`,
:iscman:`dnssec-signzone(8) <dnssec-signzone>`,
BIND 9管理员参考手册。
