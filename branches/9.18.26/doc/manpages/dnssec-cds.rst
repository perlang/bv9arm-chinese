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

.. iscman:: dnssec-cds
.. program:: dnssec-cds
.. _man_dnssec-cds:

dnssec-cds - 基于CDS/CDNSKEY修改一个子区的DS记录
------------------------------------------------

概要
~~~~~~~~

:program:`dnssec-cds` [**-a** alg...] [**-c** class] [**-D**] {**-d** dsset-file} {**-f** child-file} [**-i**[extension]] [**-s** start-time] [**-T** ttl] [**-u**] [**-v** level] [**-V**] {domain}

描述
~~~~~~~~~~~

:program:`dnssec-cds` 命令基于在子区中发布的CDS或CDNSKEY记录修改一个授权点
的DS记录。如果CDS和CDNSKEY记录都出现在子区中，优先使用CDS。这使得一
个子区可以向其父区通知即将对其自身的密钥签名密钥(KSK)的修改；通过定期使
用 :program:`dnssec-cds` 轮询，父区可以保持DS记录为最新的，并开启自动对KSK的
轮转。

要求两个输入文件。 :option:`-f child-file <-f>` 选项指定一个包含子区的CDS和/或
CDNSKEY记录加上RRSIG和DNSKEY记录的文件，这样它们就能够认证。
:option:`-d path <-d>` 选项指定一个包含当前DS记录的文件的位置。例如，这可能是
由 :iscman:`dnssec-signzone` 生成的一个 ``dsset-`` 文件，或者
:iscman:`dnssec-dsfromkey` 的输出，或者之前运行
:program:`dnssec-cds` 的输出。

:program:`dnssec-cds` 命令使用由 :rfc:`7344` 指定的特定的DNSSEC验证逻辑。
它要求CDS和/或CDNSKEY记录是由一个在现存DS记录中表示的密钥有效签名。
这将是典型的预先存在的KSK。

为了防止重放攻击，子记录上的签名不能比它们在之前运行 :program:`dnssec-cds`
时的签名更老。它们的年龄是从 ``dsset-`` 文件的修改时间，或从 :option:`-s`
选项获得的。

为了防止授权被破坏， :program:`dnssec-cds` 确保DNSKEY资源记录集能够被新的
DS资源记录集中的每个密钥算法验证，并且同样的密钥集合能够被每个DS摘
要类型覆盖。

缺省时，替换的DS记录被写到标准输出；使用 :option:`-i` 选项时，输入文件将
被覆盖。当不需要修改时，替换的DS记录将与现有记录相同。如果
CDS/CDNSKEY记录指定子区想要成为不安全的，则输出可以为空。

.. warning::

   当 :program:`dnssec-cds` 失败时，需要小心，不要删除 DS 记录！

作为一种选择， :option:`dnssec-cds -u` 将一个 :iscman:`nsupdate` 脚本写到标准
输出。可以同时使用 :option:`-u` 和 :option:`-i` 选项来维护一个 ``dsset-`` 文
件，如同执行一个 :iscman:`nsupdate` 脚本。

选项
~~~~~~~

.. option:: -a algorithm

   当转换CDS记录到DS记录时，本选项指定可接受的摘要算法。这个选项可以重
   复，这样可以允许多种摘要类型。如果没有CDS记录使用一个可接受的摘要类
   型， :program:`dnssec-cds` 会试图使用CDNSKEY记录来代替；如果不存在CDNSKEY记
   录，它将报错。

   当转换CDNSKEY记录到DS记录时，本选项指定摘要算法。它可以重复，这样会
   为每个CDNSKEY记录建立多个DS记录。

   algorithm必须是SHA-1，SHA-256或SHA-384之一。这些值是大小写不敏
   感的，并且连字符可以省略。如果没有指定算法，缺省只能是SHA-256。

.. option:: -c class

   本选项指定区的DNS类。

.. option:: -D

   如果CDS和CDNSKEY记录都出现在子区中，本选项从CDNSKEY生成DS记录。缺省
   优先CDS记录。

.. option:: -d path

   本选项指定父区DS记录的位置。这个路径可以是包含DS记录的一个文件的名
   字；如果它是一个目录， :program:`dnssec-cds` 在这个目录中查找域的
   ``dsset-`` 文件。

   为了防止重放攻击，如果子记录的签名时间早于 ``dsset-`` 文件的修改
   时间，子记录将被拒绝。这个可以使用 :option:`-s` 选项调整。

.. option:: -f child-file

   本选项指定包含子区的CDS和/或CDNSKEY记录，及其DNSKEY记录和覆盖的
   RRSIG记录的文件，这样它们就能被认证。

   下面的例子描述了如何生成这个文件。

.. option:: -i extension

   本选项更新 ``dsset-`` 文件，而不是将DS记录写到标准输出。

   在 :option:`-i` 和extension之间必须没有空格。如果你没有提供extension，
   旧的 ``dsset-`` 会被丢弃。如果提供了一个extension，旧 ``dsset-``
   文件的备份就被保存在旧文件名跟上extension作为新文件名的文件中。

   为了防止重放攻击， ``dsset-`` 文件的修改时间被设置为与子记录的签
   名起始时间相匹配，前提是该时间晚于文件的当前修改时间。

.. option:: -s start-time

   本选项指定RRSIG记录可以接受的日期和时间。这可以是一个绝对或一个相对
   时间。一个绝对开始时间是由一个YYYYMMDDHHMMSS格式的数表示的；
   20170827133700表示UTC时间2017年8月27日 13:37:00。一个相对于
   ``dsset-`` 文件的时间由 ``-N`` 表示，即文件修改时间之前N秒。一个相对
   于当前时间的时间用 ``now+N`` 表示。

   如果没有指定start-time，就使用 ``dsset-`` 文件的修改时间。

.. option:: -T ttl

   本选项指定一个用于新的DS记录的TTL。如果未指定，缺省是旧DS记录的TTL。
   如果它们没有显式的TTL，新DS记录也没有显式的TTL。

.. option:: -u

   本选项写一个 :iscman:`nsupdate` 脚本到标准输出，而不是打印新DS记录。如果
   不需要修改，输出可以为空。

   注意：必须指定新记录的TTL：可以通过在原始的 ``dsset-`` 文件中，
   使用 :option:`-T` 选项来指定，或者使用 :iscman:`nsupdate` ``ttl`` 命令。

.. option:: -V

   本选项打印版本信息。

.. option:: -v level

   本选项设置调试级别。级别1用于为普通用户提供更详细信息；更高的级别是
   给开发者使用。

``domain``
   这指示授权点/子区顶点的名字。

退出状态
~~~~~~~~~~~

:program:`dnssec-cds` 命令运行成功时退出码为0，如果发生一个错误则为非零。

如果成功，DS记录可能需要也可能不需要修改。

例子
~~~~~~~~

在运行 :iscman:`dnssec-signzone` 之前，可以通过在每个 ``dsset-`` 文件
上运行 :program:`dnssec-cds` 来确保授权是最新的。

要获取 :program:`dnssec-cds` 要求的子区记录，可以在下面的脚本中调用
:iscman:`dig` 。如果 :iscman:`dig` 失败，也可以接受，因为 :program:`dnssec-cds` 会执
行所有需要的检查。

::

   for f in dsset-*
   do
       d=${f#dsset-}
       dig +dnssec +noall +answer $d DNSKEY $d CDNSKEY $d CDS |
       dnssec-cds -i -f /dev/stdin -d $f $d
   done

当父区通过 :iscman:`named` 自动签名，可以使用 :program:`dnssec-cds` 和
:iscman:`nsupdate` 来维护一个授权，如下所示。 ``dsset-`` 文件允许脚本避免
必须获取和验证父区的DS记录，并且它还维护了重放攻击保护时间。

::

   dig +dnssec +noall +answer $d DNSKEY $d CDNSKEY $d CDS |
   dnssec-cds -u -i -f /dev/stdin -d $f $d |
   nsupdate -l

参见
~~~~~~~~

:iscman:`dig(1) <dig>`, :iscman:`dnssec-settime(8) <dnssec-settime>`, :iscman:`dnssec-signzone(8) <dnssec-signzone>`, :iscman:`nsupdate(1) <nsupdate>`, BIND 9管理员参考手册, :rfc:`7344`.
