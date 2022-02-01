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

.. _man_dnssec-signzone:

dnssec-signzone - DNSSEC区签名工具
------------------------------------------

概要
~~~~~~~~

:program:`dnssec-signzone` [**-a**] [**-c** class] [**-d** directory] [**-D**] [**-E** engine] [**-e** end-time] [**-f** output-file] [**-g**] [**-h**] [**-i** interval] [**-I** input-format] [**-j** jitter] [**-K** directory] [**-k** key] [**-L** serial] [**-M** maxttl] [**-N** soa-serial-format] [**-o** origin] [**-O** output-format] [**-P**] [**-Q**] [**-q**] [**-R**] [**-S**] [**-s** start-time] [**-T** ttl] [**-t**] [**-u**] [**-v** level] [**-V**] [**-X** extended end-time] [**-x**] [**-z**] [**-3** salt] [**-H** iterations] [**-A**] {zonefile} [key...]

描述
~~~~~~~~~~~

``dnssec-signzone`` 签名一个区；它生成NSEC和RRSIG记录并产生一个区的
签名版本。来自这个签名区的授权的安全状态（即，子区是否安全）是由是
否存在各个子区的 ``keyset`` 文件而决定的。

选项
~~~~~~~

``-a``
   本选项验证所有生成的签名。

``-c class``
   本选项指定区的DNS类。

``-C``
   本选项设置兼容模式，在这个模式中，对一个区签名时，除了生成
   ``dsset-zonename`` 之外还生
   成 ``keyset-zonename`` ，用于旧版本的 ``dnssec-signzone`` 。

``-d directory``
   本选项指示BIND 9应在其中 ``directory`` 中查找 ``dsset-`` 或
   ``keyset-`` 文件的目录。

``-D``
   本选项指示输出那些仅由 ``dnssec-signzone`` 自动管理的记录类型，即
   RRSIG，NSEC，NSEC3和NSEC3PARAM记录。如果使用了智能签名（ ``-S`` ），
   也包含DNSKEY记录。结果文件可以用 ``$INCLUDE`` 包含进原始的区文件中。
   这个选项不能和 ``-O raw`` ， ``-O map`` 或序列号更新一起使用。

``-E engine``
   如果适用，本选项指定要使用的加密硬件，例如用于签名的一个安全密钥存储。

   当BIND带有OpenSSL构建时，这需要设置成OpenSSL引擎标识符，它驱动加密加
   速器或者硬件服务模块（通常 ``pkcs11`` ）。当BIND使用原生PKCS#11加密
   （ ``--enable-native-pkcs11`` ）构建时，它缺省是由 ``--with-pkcs11``
   所指定的PKCS#11提供者库的路径。

``-g``
   本选项指示为来自 ``dsset-`` 或 ``keyset-`` 文件的子区生成DS记录。已
   经存在的DS将被删除。

``-K directory``
   本选项为搜索DNSSEC密钥指定一个目录。如果未指定，它缺省为当前目录。

``-k key``
   本选项告诉BIND 9将指定的密钥当作密钥签名密钥并忽略所有密钥标志。这个
   选项可以指定多次。

``-M maxttl``
   本选项为签名区设置最大TTL。输入区中任何超过 ``maxttl`` 的TTL在输出中
   将被减小到 ``maxttl`` 。这为签名区中最大可能的TTL提供了确定性，这对
   知道何时轮转密钥是非常有用的。maxttl是被解析器取走的签名在解析器缓存
   中过期之前的最长可能的时间，使用这个选项签名的区应该配置成在
   ``named.conf`` 中使用一个一致的 ``max-zone-ttl`` 。（注意：这个选项
   与 ``-D`` 不兼容，因为它修改了输出区中的非DNSSEC数据。）

``-s start-time``
   本选项指定所生成的RRSIG记录生效的日期和时间。这个可以是一个绝对或相
   对时间。一个绝对开始时间由一个YYYYMMDDHHMMSS格式的数所指明；
   20000530144500表示2000年5月30日14:45:00（UTC）。一个相对开始时间由
   ``+N`` 所指明，N是从当前时间开始的秒数。如果没有指定 ``start-time`` ，
   就使用当前时间减1小时（允许时钟误差）。

``-e end-time``
   本选项指定所生成的RRSIG记录过期的日期和时间。与 ``start-time`` 一样，
   一个绝对时间由YYYYMMDDHHMMSS格式所指明。一个相对于开始时间的时间由
   ``+N`` 所指明，即自开始时间之后N秒。一个相对于当前时间的时间由
   ``now+N`` 所指明。如果没有指定 ``end-time`` ，就使用开始时间30天后作
   为缺省值。 ``end-time`` 必须比 ``start-time`` 更晚。

``-X extended end-time``
   本选项指定为DNSKEY资源记录集而生成的RRSIG记录的过期日期和时间。这是
   用于DNSKEY签名的有效时间需要比其它记录签名的有效时间持续更长的情
   况；例如，当KSK的私密部份被离线保存并且需要手动刷新KSK签名时。

   与 ``end-time`` 一样，一个绝对时间由YYYYMMDDHHMMSS格式所指明。
   一个相对于开始时间的时间由 ``+N`` 所指明，即自开始时间之后N秒。一个
   相对于当前时间的时间由 ``now+N`` 所指明。如果没有指定
   ``extended end-time`` ，就使用 ``end-time`` 的值作为缺省值。（
   相应地， ``end-time`` 的缺省值为开始时间的30天后。）
   ``extended end-time`` 必须比 ``start-time`` 更晚。

``-f output-file``
   本选项指示包含签名区的输出文件的名字。缺省是在输入文件名后面添加
   ``.signed`` 。如果 ``output-file`` 被设置成 ``-`` ，签名区将
   被写到标准输出，以缺省的输出格式 ``full`` 。

``-h``
   本选项打印 ``dnssec-signzone`` 的选项和参数的简短摘要。

``-V``
   本选项打印版本信息。

``-i interval``
   本选项指示，当一个先前已签名的区被作为输入，记录可能被再次签名。
   ``interval`` 选项指定作为自当前时间开始的以秒为单位的偏移量的循环间
   隔。如果一个RRSIG记录在这个循环间隔后过期，它会被保留；否则，它被考
   虑为马上过期，并被替代。

   缺省的循环间隔是签名的结束时间和开始时间之差的四分之一，所以如果
   既不指定 ``end-time`` ，也不指定 ``start-time`` ， ``dnssec-signzone``
   生成的签名在30天内有效，并带有7.5天的循环间隔。所以，如果任何现存
   的RRSIG记录将在7.5天以内过期，它们将会被替代。

``-I input-format``
   本选项设置输入区文件的格式。可能的格式是 ``text`` （缺省）， ``raw``
   和 ``map`` 。这个选项主要用于动态签名区，这样一个包含动态更新的以
   非文本格式转储的区文件就可以被直接签名。这个选项对非动态区没有用。

``-j jitter``
   在使用一个固定的签名生存时间对一个区签名时，所有的RRSIG记录都分配
   了几乎是同时的签名过期时间。如果区被增量签名，例如，一个先前签过
   名的区作为输入传递给签名者，所有过期的签名必须在大致相同的时间被
   重新生成。 ``jitter`` 选项指定了一个抖动窗口，用来随机化签名的过
   期时间，这样就将增量签名的重生成扩展到一个时间段。

   签名生存时间抖动通过分散缓存过期时间，在某种程度上也有益于验证者和服
   务器，例如，如果所有的缓冲中都没有大量RRSIG在同一时间过期，就比
   所有验证者需要在几乎相同的时刻来重新获取记录有更少的拥塞。

``-L serial``
   当以“raw”或“map”格式输出一个签名区时，本选项在头部中设置
   “source serial”值以指定 ``serial`` 。（这个功能预期主要用于测试目的。）

``-n ncpus``
   本选项指定要使用的线程个数。缺省时，为每个被检测到的CPU绑定一个线程。

``-N soa-serial-format``
   本选项设置签名区的SOA序列号格式。可能的格式有 ``keep`` （缺省），
   ``increment`` ， ``unixtime`` 和 ``date`` 。

   **keep**
      本格式指示不改变SOA序列号。

   **increment**
      本格式使用 :rfc:`1982` 算术增加SOA序列号。

   **unixtime**
      本格式将SOA序列号设置为UNIX纪元开始以来的秒数，除非序列号已经
      大于或等于要设置成的值，在这种情况下它只是简单地加1。

   **date**
      本格式将SOA序列号以YYYYMMDDNN的格式设置为今天的日期，除非序列
      号已经大于或等于要设置成的值，在这种情况下它只是简单地加1。

``-o origin``
   本选项设置区起点。如果未指定，就使用区名作为起点。

``-O output-format``
   本选项设置包含签名区的输出文件的格式。可能的格式为 ``text`` （缺省），
   它是区的标准文本格式； ``full`` ，它是以文本输出的适合由外部脚本
   处理的格式，和 ``map`` ， ``raw`` 和 ``raw=N`` ，它是以二
   进制格式存储区以便 ``named`` 快速加载。 ``raw=N`` 指定raw区文
   件的格式版本：如果N为0，raw区文件可以被任何版本的named读取；如果
   N为1，这个文件则只能被9.9.0或更高版本读取。缺省为1。

``-P``
   本选项关闭后签名验证测试。

   后签名验证测试确保对每个用到的算法都有至少一个非撤销自签名的KSK
   密钥，所有撤销的KSK都是自签名的，以及区中所有记录都是由这个算法
   所签名的。这个选项跳过这些测试。

``-Q``
   本选项删除不再活动的密钥的签名。

   通常情况，当一个以前已经签名的区被作为输入传递给签名者时，并且一
   个DNSKEY记录被删除且被一个新的所替代时，来自旧密钥的并且仍在其有
   效期内的签名将被保留。这允许区继续使用缓存中的旧DNSKEY资源记录集
   来作验证。 ``-Q`` 选项强制 ``dnssec-signzone`` 删除不再活动的密钥的
   签名。这使ZSK使用 :rfc:`4641#4.2.1.1`
   （“Pre-Publish Key Rollover”）中描述的过程进行轮转。

``-q``
   本选项开启安静模式，它拟制不必要的输出。没有这个选项时，运行
   ``dnssec-signzone`` 将打印三段信息到标准输出：在用的密钥数目；用于验
   证区是否正确签名的算法和其它状态信息；以及包含签名区的文件名。使用这
   个选项时，输出被拟制，只剩下文件名。

``-R``
   本选项删除不再公开的密钥的签名。

   这个选项与 ``-Q`` 相似，除了它强制 ``dnssec-signzone`` 从不再公
   开的密钥删除签名之外。这使ZSK使用 :rfc:`4641#4.2.1.2`
   （“Double Signature Zone Signing Key Rollover”）中描述的过程进行
   轮转。

``-S``
   本选项开启智能签名，它指示 ``dnssec-signzone`` 在密钥仓库中搜索与被
   签名区匹配的密钥，如果有合适的还要将其包含到区中。

   当找到了一个密钥时，就检查其计时元数据以决定如何根据以下的规则来
   使用它。每个后面的规则优先于其之前的规则：

      如果没有为密钥指定计时元数据，密钥被发布在区中并用于对区签名。

      如果设置了密钥的发布日期并且已经过了，密钥就被发布到区中。

      如果设置了密钥的激活日期并且已经过了，密钥就被发布（忽略发布
      日期） 并用于对区签名。

      如果设置了密钥的撤销日期并且已经过了，并且密钥已被发布，就撤
      销密钥，已撤销的密钥可用于对区签名。

      如果设置了密钥的停止公开日期或删除日期之一并且已经过了，密钥
      不再公开或用于对区签名，而不管任何其它元数据。

      如果设置了密钥的同步发布日期并且已经过了，就建立同步记录（类
      型CDS和/或CDNSKEY）。

      如果设置了密钥的同步删除日期并且已经过了，就删除同步记录（类
      型CDS和/或CDNSKEY）。

``-T ttl``
   本选项为从密钥仓库导入到区中的新DNSKEY记录指定一个TTL。如果未指定，
   缺省是区的SOA记录中的TTL值。当不使用 ``-S`` 签名时这个选项被忽略，
   因为在那种情况下，不会从密钥仓库导入DNSKEY记录。同样，如果在区
   顶点存在任何DNSKEY记录时，也会忽略这个选项，在这个情况中，新记
   录的TTL值会被设置成与其匹配，或者如果任何被导入的DNSKEY记录有
   一个缺省的TTL值时也会被忽略。在导入密钥中的TTL值有冲突的情况下，
   使用时间最短的一个。

``-t``
   本选项在完成时打印统计结果。

``-u``
   当对之前已签过名的区重新签名时，本选项更新NSEC/NSEC3链。带有这个选项
   时，一个使用NSEC签名的区可以转换到NSEC3，或者一个使用NSEC3签名的区
   可以转换为NSEC或其它参数的NSEC3。没有这个选项时，重新签名时，
   ``dnssec-signzone`` 将维持已存在的链。

``-v level``
   本选项设置调试级别。

``-x``
   本选项指示BIND 9仅使用密钥签名密钥对DNSKEY，CDNSKEY和CDS资源记录集签
   名，并应该忽略来自区签名密钥的签名。（这与 ``named`` 中的
   ``dnssec-dnskey-kskonly yes;`` 区选项相似。）

``-z``
   本选项指示BIND 9在决定对何签名时，忽略密钥中的KSK标志。这导致有KSK标
   志的密钥对所有记录签名，而不仅仅是DNSKEY资源记录集。（这与 ``named``
   中的 ``update-check-ksk no;`` 区选项相似。）

``-3 salt``
   本选项使用给定的十六进制编码的干扰值（salt）生成一个NSEC3链。在生成
   NSEC3链时，可以使用一个破折号（-）来指示不使用干扰值（salt）。

``-H iterations``
   本选项指示，在生成一个NSEC3链时，BIND 9应使用这个循环次数。缺省是10。

``-A``
   本选项指示，在生成一个NSEC3链时，BIND 9应设置所有NSEC3记录的OPTOUT标
   志，并且不为不安全的授权生成NSEC3记录。

   使用这个选项两次（例如， ``-AA`` ）关闭所有记录的OPTOUT标志。这
   在使用 ``-u`` 选项修改一个先前具有OPTOUT集合的NSEC3链时很有用。

``zonefile``
   本选项设置包含被签名区的文件。

``key``
   本选项指定应该使用哪个密钥来签名这个区。如果没有指定密钥，会对区进行
   检查，在区顶点找DNSKEY记录。如果找到这样的记录并且在当前目录有匹配的
   私钥，它们就会用于签名。

例子
~~~~~~~

下列命令使用由 ``dnssec-keygen`` 所生成的ECDSAP256SHA256密钥
（Kexample.com.+013+17247）对 ``example.com`` 区签名。因为没有使用
``-S`` 选项，区的密钥必须在主文件中（ ``db.example.com`` ）。这个
需要在当前目录查找 ``dsset`` 文件，这样DS记录可以从中导入（ ``-g`` ）。

::

   % dnssec-signzone -g -o example.com db.example.com \
   Kexample.com.+013+17247
   db.example.com.signed
   %

在上述例子中， ``dnssec-signzone`` 创建文件 ``db.example.com.signed`` 。
这个文件被 ``named.conf`` 文件中的区语句所引用。

这个例子使用缺省参数重新对先前的签名区签名。假定私钥存放在当前目录。

::

   % cp db.example.com.signed db.example.com
   % dnssec-signzone -o example.com db.example.com
   db.example.com.signed
   %

参见
~~~~~~~~

:manpage:`dnssec-keygen(8)`, BIND 9管理员参考手册, :rfc:`4033`,
:rfc:`4641`.
