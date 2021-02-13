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

.. _man_dnssec-cds:

dnssec-cds - 基于CDS/CDNSKEY修改一个子区的DS记录
------------------------------------------------

概要
~~~~~~~~

:program:`dnssec-cds` [**-a** alg...] [**-c** class] [**-D**] {**-d** dsset-file} {**-f** child-file} [**-i** [extension]] [**-s** start-time] [**-T** ttl] [**-u**] [**-v** level] [**-V**] {domain}

描述
~~~~~~~~~~~

``dnssec-cds`` 命令基于在子区中发布的CDS或CDNSKEY记录修改一个授权点
的DS记录。如果CDS和CDNSKEY记录都出现在子区中，优先使用CDS。这使得一
个子区可以向其父区通知即将对其自身的密钥签名密钥的修改；通过定期使
用 ``dnssec-cds`` 轮询，父区可以保持DS记录的更新，并开启自动对KSK的
轮转。

要求两个输入文件。 ``-f child-file`` 选项指定一个包含子区的CDS和/或
CDNSKEY记录加上RRSIG和DNSKEY记录的文件，这样它们就能够认证。
``-d path`` 选项指定一个包含当前DS记录的文件的位置。例如，这可能是
由 ``dnssec-signzone`` 生成的一个 ``dsset-`` 文件，或者之前运行
``dnssec-cds`` 的输出。

``dnssec-cds`` 命令使用由 :rfc:`7344` 指定的特定的DNSSEC验证逻辑。
它要求CDS和/或CDNSKEY记录是由一个在现存DS记录中表示的密钥有效签名。
这将是典型的预先存在的密钥签名密钥（KSK）。

为了防止重放攻击，子记录上的签名不能比它们在之前运行 ``dnssec-cds``
时的签名更老。这个时间是从 ``dsset-`` 文件的修改时间，或从 ``-s``
选项获得的。

为了防止授权被破坏， ``dnssec-cds`` 确保DNSKEY资源记录集能够被新的
DS资源记录集中的每个密钥算法验证，并且同样的密钥集合能够被每个DS摘
要类型覆盖。

缺省时，替换的DS记录被写到标准输出；使用 ``-i`` 选项时，输入文件将
被覆盖。当不需要修改时，替换的DS记录将与现有记录相同。如果CDS/
CDNSKEY记录指定子区不需要安全，则输出可以为空。

警告：当 ``dnssec-cds`` 失败时，需要小心，不要删除 DS 记录！

作为一种选择， ``dnssec-cds -u`` 将一个 ``nsupdate`` 脚本写到标准
输出。你可以同时使用 ``-u`` 和 ``-i`` 选项来维护一个 ``dsset-`` 文
件，如同执行一个 ``nsupdate`` 脚本。

选项
~~~~~~~

**-a** algorithm
   指定用于转换CDNSKEY记录到DS记录的摘要算法。这个选项可以重复，这
   样会为每个CDNSKEY记录建立多个DS记录。在使用CDS记录时，这个选项
   无效。

   algorithm必须是SHA-1，SHA-256或SHA-384之一。这些值是大小写不敏
   感的，并且连字符可以省略。如果没有指定算法，缺省是SHA-256。

**-c** class
   指定区的DNS类。

**-D**
   如果CDS和CDNSKEY记录都出现在子区中，从CDNSKEY生成DS记录。缺省优
   先CDS记录。

**-d** path
   父区DS记录的位置。这个路径可以是包含DS记录的一个文件的名字，或者
   是一个目录， ``dnssec-cds`` 在这个目录中查找域的 ``dsset-`` 文件。

   为了防止重放攻击，如果子记录的签名时间早于 ``dsset-`` 文件的修改
   时间，子记录将被拒绝。这个可以使用 ``-s`` 选项调整。

**-f** child-file
   包含子区的CDS和/或CDNSKEY记录，及其DNSKEY记录和覆盖的RRSIG记录的
   文件，这样它们就能被认证。

   下面的例子描述了如何生成这个文件。

**-iextension**
   更新 ``dsset-`` 文件，而不是将DS记录写到标准输出。

   在 ``-i`` 和extension之间必须没有空格。如果你没有提供extension，
   旧的 ``dsset-`` 会被丢弃。如果提供了一个extension，旧 ``dsset-``
   文件的备份就被保存在旧文件名跟上extension作为新文件名的文件中。

   为了防止重放攻击， ``dsset-`` 文件的修改时间被设置为与子记录的签
   名起始时间相匹配，前提是该时间晚于文件的当前修改时间。

**-s** start-time
   指定RRSIG记录可以接受的日期和时间。这可以是一个绝对或相对时间。
   一个绝对开始时间是由一个YYYYMMDDHHMMSS格式的数表示的；
   20170827133700表示UTC时间2017年8月27日 13:37:00。一个相对于
   ``dsset-`` 文件的时间由-N表示，即文件修改时间之前N秒。一个相对
   于当前时间的时间用now+N表示。

   如果没有指定start-time，就使用 ``dsset-`` 文件的修改时间。

**-T** ttl
   指定一个用于新的DS记录的TTL。如果未指定，缺省是旧的DS记录的TTL。
   如果旧的没有显式的TTL，新的DS记录也没有。

**-u**
   写一个 ``nsupdate`` 脚本到标准输出，而不是打印新的DS记录。如果
   不需要修改，输出可以为空。

   注意：必须指定新记录的TTL，要么是在原始的 ``dsset-`` 文件中，
   要么是使用 ``-T`` 选项，要么使用 ``nsupdate`` ``ttl`` 命令。

**-V**
   打印版本信息。

**-v** level
   设置调试级别。级别1用于为普通用户提供更详细信息；更高的级别是
   给开发者使用。

domain
   授权点/子区顶点的名字。

退出状态
~~~~~~~~~~~

``dnssec-cds`` 命令运行成功时退出码为0，如果发生一个错误则为非零。

在成功的情况，DS记录可能需要也可能不需要修改。

例子
~~~~~~~~

在运行 ``dnssec-signzone`` 之前，你可以通过在每个 ``dsset-`` 文件
上运行 ``dnssec-cds`` 来确保授权是最新的。

要获取 ``dnssec-cds`` 要求的子记录，你可以在下面的脚本中调用
``dig`` 。如果 ``dig`` 失败，也没有关系，因为 ``dnssec-cds`` 会执
行所有需要的检查。

::

   for f in dsset-*
   do
       d=${f#dsset-}
       dig +dnssec +noall +answer $d DNSKEY $d CDNSKEY $d CDS |
       dnssec-cds -i -f /dev/stdin -d $f $d
   done

当父区通过 ``named`` 自动签名，你可以使用 ``dnssec-cds`` 和
``nsupdate`` 来维护一个授权，如下所示。 ``dsset-`` 文件允许脚本避免
必须获取和验证父区的DS记录，并且它还维护了重放攻击保护时间。

::

   dig +dnssec +noall +answer $d DNSKEY $d CDNSKEY $d CDS |
   dnssec-cds -u -i -f /dev/stdin -d $f $d |
   nsupdate -l

参见
~~~~~~~~

:manpage:`dig(1)`, :manpage:`dnssec-settime(8)`, :manpage:`dnssec-signzone(8)`, :manpage:`nsupdate(1)`, BIND 9管理员参考手册, :rfc:`7344`.
