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

.. iscman:: rndc
.. program:: rndc
.. _man_rndc:

rndc - 名字服务器控制工具
----------------------------------

概要
~~~~~~~~

:program:`rndc` [**-b** source-address] [**-c** config-file] [**-k** key-file] [**-s** server] [**-p** port] [**-q**] [**-r**] [**-V**] [**-y** server_key] [[**-4**] | [**-6**]] {command}

描述
~~~~~~~~~~~

:program:`rndc` 控制一个名字服务器的运行。
如果 :program:`rndc` 在没有命令行选项或参数时被调用，它将
打印出其所支持的命令和可用选项和参数的简短总结。

:program:`rndc` 通过一个TCP连接与名字服务器通信，发送经过数字签名认证的
命令。在当前版本的 :program:`rndc` 和 :iscman:`named` 中，只支持的认证算法是
HMAC-MD5（为了兼容），HMAC-SHA1，HMAC-SHA224，HMAC-SHA256（缺省），
HMAC-SHA384和HMAC-SHA512。它们在连接的两端使用共享密钥。它为命令
请求和名字服务器的响应提供TSIG类型的认证。所有经由通道发送的命令
都必须被一个服务器所知道的server_key签名。

:program:`rndc` 读一个配置文件来决定如何联系名字服务器并决定使用哪一个算
法和密钥。

选项
~~~~~~~

.. option:: -4

   本选项指示只使用IPv4。

.. option:: -6

   本选项指示只使用IPv6。

.. option:: -b source-address

   本选项指示 ``source-address`` 作为连接服务器的源地址。允许多个实例设
   置其IPv4和IPv6源地址。

.. option:: -c config-file

   本选项指示 ``config-file`` 作为缺省的配置文件 |rndc_conf| 的
   替代。

.. option:: -k key-file

   本选项指示 ``key-file`` 作为缺省的密钥文件 |rndc_key| 的替代。
   如果config-file不存在， |rndc_key| 中的密钥将用于认证发
   向服务器的命令。

.. option:: -s server

   ``server`` 是与 :program:`rndc` 的配置文件中server语句相匹配的服务器的名
   字或地址。如果命令行没有提供服务器，会使用 :program:`rndc` 配置文件
   中options语句中的default-server子句所命名的主机。

.. option:: -p port

   本选项指示BIND 9发送命令到TCP端口 ``port`` ，以取代缺省控制通道端
   口，953。

.. option:: -q

   本选项设置安静模式，在这个模式下，从服务器返回的消息文本将不被打印，
   除非存在错误。

.. option:: -r

   本选项指示 :program:`rndc` 打印出 :iscman:`named` 在执行了请求的命令之后的返回
   码（例如，ISC_R_SUCCESS，ISC_R_SUCCESS等等）。

.. option:: -V

   本选项打开详细日志。

.. option:: -y server_key

   本选项指示使用配置文件中的密钥 ``server_key`` 。 ``server_key`` 必
   须为 :iscman:`named` 所知，带有同样的算法和密钥字符串，以便成功通过
   控制消息的验证。如果没有指定 ``server_key`` ， :program:`rndc` 将首
   先在所用的服务器的server语句中查找key子句，或者如果没有为主机提供
   server语句，就查找options语句中的default-key子句。注意配置文件中包
   含有用于发送认证控制命令到名字服务器的共享密钥，并且它不应该具有通
   常的读或写的权限。

命令
~~~~~~~~

:program:`rndc` 所支持的命令列表，可以通过不带任何参数运行 :program:`rndc`
来查看。

当前支持的命令是：

.. option:: addzone zone [class [view]] configuration

   这个命令在服务器运行时增加一个区。这个命令要求 ``allow-new-zones``
   选项被设置为 ``yes`` 。在命令行所指定的configuration字符串
   就是通常被放在 :iscman:`named.conf` 中的区配置文本。

   配置被保存在名为 ``viewname.nzf`` 的文件中（或者，如果
   :iscman:`named` 编译时带有liblmdb，就保存到一个名为
   ``viewname.nzd`` 的LMDB数据库文件中）。 ``viewname`` 是视图的名字，
   除非视图名字中包含有不兼容用于文件名的字符，这种情况下就使
   用视图名字的加密哈希之后的字符串替代。当 :iscman:`named`
   被重启时，这个文件将被转载到视图的配置中，这样被添加的区将
   会在重启后能够持续。

   这个例子 ``addzone`` 命令添加区 ``example.com`` 到缺省
   视图：

   ``rndc addzone example.com '{ type primary; file "example.com.db"; };'``

   （注意围绕区配置文本的花括号和配置文本之后的分号。）

   参见 :option:`rndc delzone` 和 :option:`rndc modzone` 。

.. option:: delzone [-clean] zone [class [view]]

   这个命令在服务器运行时删除一个区。

   如果指定了 ``-clean`` 参数，区的主文件（和日志文件，如果有
   的话）将会随着区一块被删除。没有 ``-clean`` 选项时，区文件
   必须手动清除。（如果区是 ``secondary`` 或 ``stub`` 类型时，
   :option:`rndc delzone` 命令的输出将报告需要删除的文件。）

   如果区最初是通过 ``rndc addzone`` 增加，它就会被永久地删除。
   然而，如果它最初是在 :iscman:`named.conf` 中配置，则最初的配置仍
   然存在；当服务器重启或重新读入配置时，区就会重建。要永
   久地删除，必须从 :iscman:`named.conf` 中删除。

   参见 :option:`rndc addzone` 和 :option:`rndc modzone` 。

.. option:: dnssec (-status | -rollover -key id [-alg algorithm] [-when time] | -checkds [-key id [-alg algorithm]] [-when time]  published | withdrawn)) zone [class [view]]

   这个命令允许你交互操作一个给定区的“dnssec-policy”。

   ``rndc dnssec -status`` 显示指定区的DNSSEC签名状态。

   ``rndc dnssec -rollover`` 允许你为一个特定的密钥调度一次密钥
   轮转（覆盖原来的密钥寿命）。

   ``rndc dnssec -checkds`` 通知 :iscman:`named` 一个特定区的密
   钥签名密钥的DS记录已被确认发布在父区或从父区撤回。这是为了完
   成KSK轮转所必须的。如果需要，可用 ``-key id`` 和
   ``-alg algorithm`` 参数指定一个特定的KSK；如果这个区仅有一个
   密钥充当KSK，这些参数可被省略。缺省时，DS记录发布或撤回的时
   间被设置为当前时间，但是可以通过一个特定的带有参数
   ``-when time`` 的时间来覆盖，其中 ``time`` 被表示为
   YYYYMMDDHHMMSS格式。
   
.. option:: dnstap (-reopen | -roll [number])

   这个命令关闭和重新打开DNSTAP输出文件。
  
   ``rndc dnstap -reopen`` 允许输出文件在外部被改名，这样
   :iscman:`named` 可以截断并重新打开它。
  
   ``rndc dnstap -roll`` 使输出文件自动轮转，类似于日志文
   件。最近的输出文件在其名字后添加“.0”；更早的最近输出文件被
   移动为“.1”，诸如此类。如果指定了 ``number`` ，备份日志文件的个数
   被限制为这个数。

.. option:: dumpdb [-all | -cache | -zones | -adb | -bad | -expired | -fail] [view ...]

   这个命令转储服务器指定视图的缓存（缺省情况）和/或区到转储文件中。如
   果未指定视图就转储所有视图。（参见BIND 9管理员参考手册中的
   ``dump-file`` 选项。）

.. option:: flush

   这个命令刷新服务器的缓存。

.. option:: flushname name [view]

   这个命令从视图的DNS缓存，如果合适，和从视图的名字服务器地址库，不存
   在缓存和SERVFAIL缓存中刷新给定的名字。

.. option:: flushtree name [view]

   这个命令从视图的DNS缓存，地址库，不存在缓存和SERVFAIL缓存中刷新给定
   的名字及其所有子域。

.. option:: freeze [zone [class [view]]]

   这个命令冻结对一个动态更新区的更新。如果没有指定区，就冻结对所有区
   的更新。这就允许对一个动态更新方式正常更新的区进行手工编辑，
   并导致日志文件中的变化被同步到主区文件。在区被冻结时，
   所有的动态更新尝试都会被拒绝。

   参见 :option:`rndc thaw` 。

.. option:: halt [-p]

   这个命令立即停止服务器。所有由动态更新或IXFR所作的最新改变没有被存
   到区文件中，但是在服务器重新启动时，将从日志文件中向前滚动。
   如果指定了 :option:`-p` ，将返回 :iscman:`named` 的进程号。这
   可以让一个外部进程来检查 :iscman:`named` 是否完全被中止。

   参见 :option:`rndc stop` 。

.. option:: loadkeys [zone [class [view]]]

   这个命令从密钥目录取给定区的所有DNSSEC密钥。如果它们在其发布期内，
   就被合并到区的DNSKEY资源记录集中。然而，与 :option:`rndc sign`
   不同，不会立即使用新密钥重签区，但是允许随时间推移进行增量
   重签。

   这个命令要求使用 ``dnssec-policy`` 配置区，或者 ``auto-dnssec``
   区选项被设置为 ``maintain`` ，而且还要求区被配置为允许动态
   DNS。（更详细情况参见管理员参考手册中的“动态更新策略”。）

.. option:: managed-keys (status | refresh | sync | destroy) [class [view]]

   这个命令检查和控制用于处理 :rfc:`5011` DNSSEC 信任锚维护的“被管理
   密钥”数据库。如果指定一个视图，这些命令应用于这个视图；否
   则，就应用于所有视图。

   -  在使用 ``status`` 关键字运行时，它打印被管理密钥数据库的
      当前状态。

   -  在使用 ``refresh`` 关键字运行时，它强制发送一个针对所有被
      管理密钥的立即刷新请求，如果发现任何新的密钥，就更新被
      管理密钥数据库，而不等待通常的刷新间隔。

   -  在使用 ``sync`` 关键字运行时，它强制进行一个立即的转储被
      管理密钥数据库到磁盘（到文件 ``managed-keys.bind`` 或者
      ``viewname.mkeys`` ）。这个对数据库的同步使用它的日志文
      件，这样数据库的当前内容可以可视化地检查。

   -  在使用 ``destroy`` 关键字运行时，被管理密钥数据库被关闭
      和删除，所有密钥维护都被终止。这个命令只能在超级谨慎的
      情况下使用。

      当前存在的已经受信任的密钥不会从内存中删除；使用这条命
      令后DNSSEC验证可以继续进行。但是，密钥维护操作将会停止
      直到 :iscman:`named` 重启或者重读配置，并且所有已存
      在的密钥维护状态都会被删除。

      在这条命令后立即运行 :option:`rndc reconfig` 或重启
      :iscman:`named` 将会导致密钥维护重新初始化，就
      像服务器第一次启动时一样。这主要用于测试，但是也可以用
      于，例如，在发生信任锚轮转时开始获取新密钥，或者作为密
      钥维护问题的强力修复。

.. option:: modzone zone [class [view]] configuration

   这个命令在服务器运行时修改一个区的配置。这个命令要求
   ``allow-new-zones`` 选项被设置为 ``yes`` 。与 ``addzone``
   一起使用时，命令行中指定的configuration字符串就是原本应该
   放在 :iscman:`named.conf` 中的区配置文本。

   如果区最初通过 :option:`rndc addzone` 添加，配置变化被永久记录，
   并在服务器重启或重新读入配置之后仍然有效。然而，如果它最初
   在 :iscman:`named.conf` 中配置，最初的配置仍然保持在那里；当服务
   器重启或重新读入配置后，区将会恢复到其初始配置。为是变化永
   久化，必须也在 :iscman:`named.conf` 中修改。

   参见 :option:`rndc addzone` 和 :option:`rndc delzone` 。

.. option:: notify zone [class [view]]

   这个命令重新发出区的NOTIFY消息。

.. option:: notrace

   这个命令将服务器的调试级别设置为0。

   参见 :option:`rndc trace` 。

.. option:: nta [(-class class | -dump | -force | -remove | -lifetime duration)] domain [view]

   这个命令为 ``domain`` 设置一个DNSSEC不存在信任锚（NTA），带有一个
   ``duration`` 的生存时间。缺省的生存时间是通过 ``nta-lifetime``
   选项配置在 :iscman:`named.conf` 中的，缺省是一小时。生存时间不能
   超过一周。

   一个不存在信任锚选择性地关闭那些由于错误配置而不是攻击而明
   知会失败的区的DNSSEC验证。当被验证的数据处于或低于一个活跃
   的NTA（并且在任何其它被配置的信任锚之上）， :iscman:`named`
   将会终止DNSSEC验证过程并将数据当成不安全的而不是作为伪造的。
   这个过程会持续到NTA的生命周期结束。

   NTA持久化能够跨越 :iscman:`named` 服务器的重启。一个视图的NTA被保存在一个
   名为 ``name.nta`` 的文件中，其中的 ``name`` 是视图的名字；当视图名
   中含有不能用于文件名的字符时，就根据视图名生成一个加密哈希。

   一个现存的NTA可以通过使用 ``-remove`` 选项删除。

   一个NTA的生命周期可以使用 ``-lifetime`` 选项指定。TTL风格
   的后缀可以用于指定生命周期，以秒，分或小时的格式。如果指定
   的NTA已经存在，它的生命周期会被更新为新的值。将 ``lifetime``
   设置为零等效于设置为 ``-remove`` 。

   如果使用了 ``-dump`` ，任何其它参数都被忽略，并打印出当前存在的NTA
   列表。注意这会包含已经过期但还未被清理的NTA。

   通常， :iscman:`named` 会周期性测试以检查一个NTA之下的
   数据现在是否可以被验证（参考管理员参考手册中的 ``nta-recheck``
   选项获取详细信息）。如果数据可以被验证，这个NTA就被认为不
   再需要，允许提前过期。 ``-force`` 参数覆盖这个特性并强制一个NTA
   持久到其完整的生命周期，不考虑在NTA不存在时数据是否可以被验
   证。

   视图类可以使用 ``-class`` 指定。缺省是 ``IN`` 类，这是唯一
   支持DNSSEC的类。

   所有这些选项都可以被简化，如，简化成 ``-l`` ， ``-r`` ，
   ``-d`` ， ``-f`` 和 ``-c`` 。

   不能识别的选项被当做错误对待。要引用一个以连字符开始的域名
   或视图名，在命令行使用双连字符(--)指示选项的结束。

.. option:: querylog [(on | off)]

   这个命令打开或关闭请求日志。为向后兼容，可以不带参数使用这个命令，
   即请求日志在开和关之间切换。

   请求日志也可以显式打开，通过在 :iscman:`named.conf` 的 ``logging``
   部份指定 ``queries`` ``category`` 到一个 ``channel`` ，或者
   在 :iscman:`named.conf` 的 ``options`` 部份指定 ``querylog yes;`` 。

.. option:: reconfig

   这个命令重新载入配置文件和新的区，但是不载入已经存在的区文件，即使其
   已经被修改过。这在有大量区的时候可以比完全的 :option:`rndc reload` 更快，因
   为它避免了去检查区文件的修改时间。

.. option:: recursing

   这个命令转储 :iscman:`named` 当前为其提供递归服务的请求列表，以及当
   前迭代请求所发向的域名列表。
   
   第一个列表包括所有等待递归完成的唯一客户端，包括等待响应的查询和
   named开始处理这个客户端查询时的时间戳（自Unix纪元以来的秒数）。

   第二个列表包含那些具有正在进行的活跃的（或最近活跃的）解析操作的域
   名。它报告针对每个域活跃解析的数目和作为 ``fetches-per-zone`` 限制的
   结果而通过（允许）或丢弃（溢出）的请求数目。（注意：这些计数器不随时
   间而累积；无论何时一个域的活跃解析数目下降为0，这个域的计数器将被删
   除，下一次一个解析发到这个域，就会重建计数器并被设置为0。）

.. option:: refresh zone [class [view]]

   这个命令对指定的区进行区维护。

.. option:: reload

   这个命令重新载入配置文件和区文件。

   .. program:: rndc reload
   .. option:: zone [class [view]]

      如果指定一个区，这个命令仅重新载入指定的区。

.. program:: rndc

.. option:: retransfer zone [class [view]]

   这个命令重新从主服务器传送指定的辅区。

   如果使用 ``inline-signing`` 配置区，区的签名版本将被丢弃；在重新
   传送非签名版本完成后，将使用所有新签名重新生成签名版本。

.. option:: scan

   这个命令扫描可用网络接口列表以查看变化，不执行完全的 :option:`rndc reconfig` ，
   也不等待 ``interface-interval`` 计时器。

.. option:: secroots [-] [view ...]

   这个命令为指定视图转储安全根（即，通过 ``trust-anchors`` 语句，或
   ``managed-keys`` 或 ``trusted-keys`` 语句[这两个都被废弃了]，
   或 ``dnssec-validation auto`` 配置的信任锚）和否定信任锚。如果没
   有指定视图，就转储所有视图。安全根指示它们是否配置成受信任密钥，
   被管理密钥，或者正在初始化的被管理密钥（还未被一个成功的密钥刷新
   请求更新的被管理密钥）。

   如果第一个参数是 ``-`` ，通过 :program:`rndc` 响应通道返回输出，并输出到标
   准输出。否则，将返回写到安全根转储文件，缺省是 ``named.secroots`` ，
   但可以在 :iscman:`named.conf` 中通过 ``secroots-file`` 选项覆盖。

   参见 :option:`rndc managed-keys` 。

.. option:: serve-stale (on | off | reset | status) [class [view]]

   这个命令打开，关闭，重置或报告配置在 :iscman:`named.conf` 中的旧答复服务的
   当前状态。

   如果旧答复服务被 ``rndc-serve-stale off`` 关闭，那么，即使 :iscman:`named`
   重新加载或重新配置，它仍然会关闭。 ``rndc serve-stale reset`` 恢复
   :iscman:`named.conf` 中的配置。

   ``rndc serve-stale status`` 报告缓存过时数据和使用过时数据服务当前是
   开启或者关闭。它也会报告 ``stale-answer-ttl`` 和 ``max-stale-ttl``
   的值。

.. option:: showzone zone [class [view]]

   这个命令输出一个运行区的配置。

   参见 :option:`rndc zonestatus` 。

.. option:: sign zone [class [view]]

   这个命令从密钥目录取给定区的所有DNSSEC密钥（参见BIND 9管理员参考手册
   中的 ``key-directory`` ），如果它们在其发布期内，它们会被合并到区的
   DNSKEY资源记录集中。如果DNSKEY资源记录集发生了变化，就自动使用新
   的密钥集合对区重新签名。

   这个命令要求使用 ``dnssec-policy`` 配置区，或者 ``auto-dnssec``
   区选项被设置为 ``allow`` 或 ``maintain`` ，还要求区被配置为允许
   动态更新。（更详细情况参见BIND 9管理员参考手册中的“动态更新策略”。）

   参见 :option:`rndc loadkeys` 。

.. option:: signing [(-list | -clear keyid/algorithm | -clear all | -nsec3param (parameters | none) | -serial value) zone [class [view]]

   这个命令列出，编辑或删除指定区的DNSSEC签名状态记录。正在进行的DNSSEC
   操作，如签名或生成NSEC3链，的状态以DNS资源记录类型
   ``sig-signing-type``
   的形式存放在区中。 ``rndc signing -list`` 转换这些记录成为人可读
   的格式，指明哪个密钥是当前签名所用，哪个已完成对区的签名，哪个
   NSEC3链被创建和删除。

   ``rndc signing -clear`` 可以删除单一的一个密钥（以
   ``rndc signing -list`` 用来显示密钥的同一格式所指定的），或所有
   密钥。在这两种情况下，只有完成的密钥才能被删除；任何记录指明，
   一个没有完成签名的密钥将会被保留。

   ``rndc signing -nsec3param`` 为一个区设置NSEC3参数。这只是在与
   ``inline-signing`` 区一起使用NSEC3时才有的支持机制。参数以与
   NSEC3PARAM资源记录同样的格式指定： ``hash algorithm`` ， ``flags`` ，
   ``iterations`` 和 ``salt`` ，按上述顺序。

   当前， ``hash algorithm`` 的唯一定义值是 ``1`` ，表示SHA-1。
   ``flags`` 可以被设置为 ``0`` 或 ``1`` ，取决于NSEC3链中的opt-out位是
   否应当设置。 ``iterations`` 定义额外次数的数字，它应用于生成NSEC3哈
   希的算法中。 ``salt`` 是一个表示成十六机制数的一串数据，一个连字符
   （ ``-`` ）表示不使用salt，或者关键字 ``auto`` ，它使 :iscman:`named`
   生成一个随机64位salt。

   唯一推荐的配置是 ``rndc signing -nsec3param 1 0 0 - zone`` ，即没有
   盐，没有额外的循环，没有opt-out。

   .. warning::
      除非完全理解其含义，否则不要使用额外的循环，盐或者opt-out。更多
      次数的循环导致互操作性问题，并使开放的服务器受到耗尽CPU的DoS攻击。

   ``rndc signing -nsec3param none`` 删除一个现存的NSEC3链并使用NSEC
   替代它。

   ``rndc signing -serial value`` 设置区的序列号为 ``value`` 。如果这个
   值将会使序列号后退，它将被拒绝。这个参数的主要用途是在联机签名区中设
   置序列号。

.. option:: stats

   这个命令写服务器的统计信息到统计文件。（参见BIND 9管理员参考手册中的
   ``statistics-file`` 选项。）

.. option:: status

   这个命令显示服务器的状态。注意，区数目包括内部的 ``bind/CH`` 区，如
   果没有显式配置根区还包括缺省的 ``./IN`` 区。

.. option:: stop -p

   这个命令停止服务器，在之前先确保所有通过动态更新或IXFR所作的最新修改
   第一时间被存入被修改区的区文件中。如果指定了 :option:`-p` ，将返回
   :iscman:`named` 的进程号。这可以让一个外部进程来检查 :iscman:`named` 是否完全
   被停止。

   参见 :option:`rndc halt` 。

.. option:: sync -clean [zone [class [view]]]

   这个命令将一个动态区中日志文件的变化部分同步到其区文件。如果指定了
   “-clean”选项，会将日志文件删除。如果未指定区，将同步所有区。

.. option:: tcp-timeouts [initial idle keepalive advertised]

   当不使用参数调用时，这个命令显示 ``tcp-initial-timeout`` ，
   ``tcp-idle-timeout`` ， ``tcp-keepalive-timeout`` 和
   ``tcp-advertised-timeout`` 选项的当前值。当使用参数调用时，这些值被
   更新。这允许一位管理员在面临一次拒绝服务攻击(DoS)时能够快速调整。参
   见BIND 9管理员参考手册中对这些选项的描述以获取关于它们用法的详细信
   息。

.. option:: thaw [zone [class [view]]]

   这个命令解冻一个被冻结的动态更新区。如果没有指定区，就解冻所有被冻结
   的区。它会导致服务器重新从磁盘载入区，并在载入完成后打开动态更新功能。
   在解冻一个区后。动态更新请求不会被拒绝。如果区被修改并且使用了
   ``ixfr-from-differences`` 选项，将修改日志文件以对应到区的变化。否
   则，如果区被修改，会删除所有现存的日志文件。

   参见 :option:`rndc freeze` 。

.. option:: trace [level]

   如果未指定级别，这个命令将服务器的调试级别加1。

   .. program:: rndc trace
   .. option:: level

      如果指定，这个命令将服务器的调试级别设置为所提供的值。

   参见 :option:`rndc notrace` 。

.. program:: rndc

.. option:: tsig-delete keyname [view]

   这个命令从服务器删除所给出的TKEY协商的密钥。这不会应用于静态配置的
   TSIG密钥上。

.. option:: tsig-list

   这个命令列出当前被配置由 :iscman:`named` 所使用的每个视图中的全部TSIG
   密钥的名字。这个列表包含静态配置的密钥和动态TKEY协商的密钥。

.. option:: validation (on | off | status) [view ...]

   这个命令打开，关闭DNSSEC验证或检查DNSSEC验证的状态。缺省时，验证是打
   开的。

   当验证被打开或者关闭时刷新缓存，以避免使用不同状态下可能不同的数据。

.. option:: zonestatus zone [class [view]]

   这个命令显示给定区的当前状态，包含主文件名以及它加载时包含的所有文
   件，最近加载的时间，当前序列号，节点数目，区是否支持动态更新，区是否
   作了DNSSEC签名，它是否使用动态DNSSEC密钥管理或inline签名，以及区的预
   期刷新或过期时间。

   参见 :option:`rndc showzone` 。

指定区名的 :program:`rndc` 命令，例如 :option:`reload` ， :option:`retransfer` 或
:option:`zonestatus` ，在应用于类型 ``redirect`` 的区时可能会有歧义。
重定向区总是被称为 ``.`` ，可能与 ``hint`` 类型的区或者根区的辅拷贝
混淆。要指定一个重定向区，使用特定的区名 ``-redirect`` ，不带结
尾的点。（如果带有结尾的点，这就会指定一个名为“-redirect”的区。）

限制
~~~~~~~~~~~

当前没有在不使用配置文件的方式下提供共享密码 ``server_key`` 的方式。

几个错误消息可以被清除。

参见
~~~~~~~~

:iscman:`rndc.conf(5) <rndc.conf>`, :iscman:`rndc-confgen(8) <rndc-confgen>`,
:iscman:`named(8) <named>`, :iscman:`named.conf(5) <named.conf>`, BIND 9管理员参考手册。
