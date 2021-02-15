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

.. _man_rndc:

rndc - 名字服务器控制工具
----------------------------------

概要
~~~~~~~~

:program:`rndc` [**-b** source-address] [**-c** config-file] [**-k** key-file] [**-s** server] [**-p** port] [**-q**] [**-r**] [**-V**] [**-y** key_id] [[**-4**] | [**-6**]] {command}

描述
~~~~~~~~~~~

``rndc`` 控制一个名字服务器的运行。它替代了旧BIND发布版本所提供的
``ndc`` 工具。如果 ``rndc`` 在没有命令行选项或参数时被调用，它将
打印出其所支持的命令和可用选项和参数的简短总结。

``rndc`` 通过一个TCP连接与名字服务器通信，发送经过数字签名认证的
命令。在当前版本的 ``rndc`` 和 ``named`` 中，只支持的认证算法是
HMAC-MD5（为了兼容），HMAC-SHA1，HMAC-SHA224，HMAC-SHA256（缺省），
HMAC-SHA384和HMAC-SHA512。它们在连接的两端使用共享密钥。它为命令
请求和名字服务器的响应提供TSIG类型的认证。所有经由通道发送的命令
都必须被一个服务器所知道的key_id签名。

``rndc`` 读一个配置文件来决定如何联系名字服务器并决定使用哪一个算
法和密钥。

选项
~~~~~~~

**-4**
   只使用IPv4。

**-6**
   只使用IPv6。

**-b** source-address
   使用source-address作为连接服务器的源地址。允许多个实例设置其
   IPv4和IPv6源地址。

**-c** config-file
   使用config-file作为缺省的配置文件 ``/etc/rndc.conf`` 的替代。

**-k** key-file
   使用key-file作为缺省的密钥文件 ``/etc/rndc.key`` 的替代。如
   果config-file不存在， ``/etc/rndc.key`` 中的密钥将用于认证发
   向服务器的命令。

**-s** server
   server是与 ``rndc`` 的配置文件中server语句相匹配的服务器的名
   字或地址。如果命令行没有提供服务器，会使用 ``rndc`` 配置文件
   中options语句中的default-server子句所命名的主机。

**-p** port
   发送命令到TCP端口port，以取代BIND 9的缺省控制通道端口，953。

**-q**
   安静模式：从服务器返回的消息文本将不被打印，除非存在错误。

**-r**
   指示 ``rndc`` 打印出 ``named`` 在执行了请求的命令之后的返回
   码（例如，ISC_R_SUCCESS，ISC_R_SUCCESS等等）。

**-V**
   打开详细日志。

**-y** key_id
   使用配置文件中的密钥key_id。key_id必须被 ``named`` 所知道，
   带有同样的算法和密钥字符串，以便成功通过控制消息的验证。如
   果没有指定key_id， ``rndc`` 将首先在所用的服务器的server语
   句中查找key子句，或者如果没有为主机提供server语句，就查找
   options语句中的default-key子句。注意配置文件中包含有用于发
   送认证控制命令到名字服务器的共享密钥。因此它不应该具有通常
   的读或写的权限。

命令
~~~~~~~~

``rndc`` 所支持的命令列表，可以通过不带任何参数运行 ``rndc``
来查看。

当前支持的命令是：

``addzone`` *zone* [*class* [*view*]] *configuration*
   在服务器运行时增加一个区。这个命令要求 ``allow-new-zones``
   选项被设置为 ``yes`` 。在命令行所指定的configuration字符串
   就是通常被放在 :manpage:`named.conf(5)` 中的区配置文本。

   配置被保存在名为 ``viewname.nzf`` 的文件中（或者，如果
   :manpage:`named(8)` 编译时带有liblmdb，就保存到一个名为
   ``viewname.nzd`` 的LMDB数据库文件中）。viewname视图的名字，
   除非视图名字中包含有不兼容用于文件名的字符，这种情况下就使
   用视图名字的加密哈希之后的字符串替代。当 :manpage:`named(8)`
   被重启时，这个文件将被转载到视图的配置中，这样被添加的区将
   会在重启后能够持续。

   这个例子 ``addzone`` 命令将会添加区 ``example.com`` 到缺省
   视图：

   ``$``\ ``rndc addzone example.com '{ type master; file "example.com.db"; };'``

   （注意围绕区配置文本的花括号和分号。）

   参见 ``rndc delzone`` 和 ``rndc modzone`` 。

``delzone`` [**-clean**] *zone* [*class* [*view*]]
   在服务器运行时删除一个区。

   如果指定了 ``-clean`` 参数，区的主文件（和日志文件，如果有
   的话）将会随着区一块被删除。没有 ``-clean`` 选项时，区文件
   必须手动清除。（如果区是"slave"或"stub"类型时， ``rndc delzone``
   命令的输出将报告需要清理的文件。）

   如果区最初是通过 ``rndc addzone`` 增加，它就会被永久地删除。
   然而，如果它最初是在 ``named.conf`` 中配置，则最初的配置仍
   然存在；当服务器重启或重新读入配置时，区就会恢复回来。要永
   久地删除，必须从 ``named.conf`` 中删除。

   参见 ``rndc addzone`` 和 ``rndc modzone`` 。

``dnssec`` [**-status** *zone* [*class* [*view*]]
   显示指定区的DNSSEC签名状态。要求区具有一个“dnssec-policy”。

``dnstap`` ( **-reopen** | **-roll** [*number*] )
   关闭和重新打开DNSTAP输出文件。 ``rndc dnstap -reopen`` 允许
   输出文件被改名，这样 :manpage:`named(8)` 可以截断并重新打开
   它。 ``rndc dnstap -roll`` 使输出文件自动轮转，类似于日志文
   件；最近的输出文件在其名字后添加“.0”；更早的最近输出文件被
   移动为“.1”，诸如此类。如果指定了number，备份日志文件的个数
   被限制为这个数。

``dumpdb`` [**-all** | **-cache** | **-zones** | **-adb** | **-bad** | **-fail**] [*view ...*]
   转储服务器指定视图的缓存（缺省情况）和/或区到转储文件中。如
   果未指定视图就转储所有视图。（参见BIND 9管理员参考手册中的
   ``dump-file`` 选项。）

``flush``
   刷新服务器的缓存。

``flushname`` *name* [*view*]
   从视图的DNS缓存，如果合适，和从视图的名字服务器地址库，不存
   在缓存和SERVFAIL缓存中刷新给定的名字。

``flushtree`` *name* [*view*]
   从视图的DNS缓存，地址库，不存在缓存和SERVFAIL缓存中刷新给定
   的名字及其所有子域。

``freeze`` [*zone* [*class* [*view*]]]
   冻结对一个动态更新区的更新。如果没有指定区，就冻结对所有区
   的更新。这就允许对一个动态更新方式正常更新的区进行手工编辑。
   它也会导致日志文件中的变化被同步到主区文件。在区被冻结时，
   所有的动态更新尝试都会被拒绝。

   参见 ``rndc thaw`` 。

``halt`` [**-p**]
   立即停止服务器。所有由动态更新或IXFR所作的最新改变没有被存
   到区文件中，但是在服务器重新启动时，将从日志文件中向前滚动。
   如果指定了 ``-p`` ，将返回 :manpage:`named(8)` 的进程号。这
   可以让一个外部进程来检查 :manpage:`named(8)` 是否完全被中断。

   参见 ``rndc stop`` 。

``loadkeys`` [*zone* [*class* [*view*]]]
   从密钥目录取给定区的所有DNSSEC密钥。如果它们在其发布期内，
   将它们合并到区的DNSKEY资源记录集中。然而，与 ``rndc sign``
   不同，不会立即使用新密钥重签区，但是允许随时间推移进行增量
   重签。

   这个命令要求使用 ``dnssec-policy`` 配置区，或者 ``auto-dnssec``
   区选项被设置为 ``maintain`` ，而且还要求区被配置为允许动态
   DNS。（更详细情况参见管理员参考手册中的“动态更新策略”。）

``managed-keys`` (*status* | *refresh* | *sync* | *destroy*) [*class* [*view*]]
   检查和控制用于处理 :rfc:`5011` DNSSEC 信任锚维护的“被管理
   密钥”数据库。如果指定一个视图，这些命令应用于这个视图；否
   则就应用于所有视图。

   -  在使用 ``status`` 关键字运行时，打印被管理密钥数据库的
      当前状态。

   -  在使用 ``refresh`` 关键字运行时，强制发送一个针对所有被
      管理密钥的立即刷新请求，如果发现任何新的密钥，就更新被
      管理密钥数据库，而不等待通常的刷新间隔。

   -  在使用 ``sync`` 关键字运行时，强制进行一个立即的转储被
      管理密钥数据库到磁盘（到文件 ``managed-keys.bind`` 或者
      ``viewname.mkeys`` ）。这个对数据库的同步使用它的日志文
      件，这样数据库的当前内容可以可视化地检查。

   -  在使用 ``destroy`` 关键字运行时，被管理密钥数据库被关闭
      和删除，所有密钥维护都被终止。这个命令只能在超级谨慎的
      情况下使用。

      当前存在的已经受信任的密钥不会从内存中删除；使用这条命
      令后DNSSEC验证可以继续进行。但是，密钥维护操作将会停止
      直到 :manpage:`named(8)` 重启或者重读配置，并且所有已存
      在的密钥维护状态都会被删除。

      在这条命令后立即运行 ``rndc reconfig`` 或重启
      :manpage:`named(8)` 将会导致密钥维护从头开始初始化，就
      像服务器第一次启动时一样。这主要用于测试，但是也可以用
      于，例如，在发生信任锚轮转时开始获取新密钥，或者作为密
      钥维护问题的强力修复。

``modzone`` *zone* [*class* [*view*]] *configuration*
   在服务器运行时修改一个区的配置。这个命令要求
   ``allow-new-zones`` 选项被设置为 ``yes`` 。与 ``addzone``
   一起使用时，命令行中指定的configuration字符串就是原本应该
   放在 ``named.conf`` 中的区配置文本。

   如果区最初通过 ``rndc addzone`` 添加，配置变化将被永久记录，
   并在服务器重启或重新读入配置之后仍然有效。然而，如果它最初
   在 ``named.conf`` 中配置，最初的配置仍然保持在那里；当服务
   器重启或重新读入配置后，区将会恢复到其初始配置。为是变化永
   久化，必须也在 ``named.conf`` 中修改。

   参见 ``rndc addzone`` 和 ``rndc delzone`` 。

``notify`` *zone* [*class* [*view*]]
   重新发出区的NOTIFY消息。

``notrace``
   将服务器的调试级别设置为0。

   参见 ``rndc trace`` 。

``nta`` [( **-class** *class* | **-dump** | **-force** | **-remove** | **-lifetime** *duration*)] *domain* [*view*]
   为 ``domain`` 设置一个DNSSEC不存在信任锚（NTA），带有一个
   ``duration`` 的生存时间。缺省的生存时间是通过 ``nta-lifetime``
   选项配置在 ``named.conf`` 中的，缺省是一小时。生存时间不能
   超过一周。

   一个不存在信任锚选择性地关闭那些由于错误配置而不是攻击而明
   知会失败的区的DNSSEC验证。当被验证的数据处于或低于一个活跃
   的NTA（并且在任何其它被配置的信任锚之上）， :manpage:`named(8)`
   将会终止DNSSEC验证过程并将数据当成不安全的而不是作为伪造的。
   这个过程会持续到NTA的生命周期结束。

   NTA持久化能够跨越 :manpage:`named(8)` 服务器重启。一个视图
   的NTA被保存在一个名为 ``name.nta`` 的文件中，其中的name是
   视图的名字，或者当视图名中含有不能用于文件名的字符时，是根
   据视图名生成的加密哈希。

   一个现存的NTA可以通过使用 ``-remove`` 选项删除。

   一个NTA的生命周期可以使用 ``-lifetime`` 选项指定。TTL风格
   的后缀可以用于指定生命周期，以秒，分或小时的格式。如果指定
   的NTA已经存在，它的生命周期会被更新为新的值。将 ``lifetime``
   设置为零等效于设置为 ``-remove`` 。

   如果使用了 ``-dump`` ，任何其它参数都被忽略，打印出现存NTA
   的列表（注意这会包含已经过期但还未被清理的NTA）。

   通常， :manpage:`named(8)` 会周期性测试以检查一个NTA之下的
   数据现在是否可以被验证（参考管理员参考手册中的 ``nta-recheck``
   选项获取详细信息）。如果数据可以被验证，这个NTA就被认为不
   再需要，允许提前过期。 ``-force`` 覆盖这个特性并强制一个NTA
   持久到其完整的生命周期，不考虑在NTA不存在时数据是否可以被验
   证。

   视图类可以使用 ``-class`` 指定。缺省是 ``IN`` 类，这是唯一
   支持DNSSEC的类。

   所有这些选项都可以被简化，如，简化成 ``-l`` ， ``-r`` ，
   ``-d`` ， ``-f`` 和 ``-c`` 。

   不能识别的选项被当做错误对待。要引用一个以连字符开始的域名
   或视图名，在命令行使用双连字符指示选项的结束。

``querylog`` [(*on* | *off*)]
   打开或关闭请求日志。（为向后兼容，可以不带参数使用这个命令，
   即请求日志在开和关之间切换。

   请求日志也可以显式打开，通过在 ``named.conf`` 的 ``logging``
   部份指定 ``queries`` ``category`` 到一个 ``channel`` ，或者
   在 ``named.conf`` 的 ``options`` 部份指定 ``querylog yes;`` 。

``reconfig``
   重新载入配置文件和新的区，但是不载入已经存在的区文件，即使其已
   经被修改过。这在有大量区的时候可以比完全的 ``reload`` 更快，因
   为它避免了去检查区文件的修改时间。

``recursing``
   转储 :manpage:`named(8)` 当前为其提供递归服务的请求列表，以及当
   前迭代请求所发向的域名列表。（第二个列表包含对给定域名的当前活
   跃获取的个数，以及由于 ``fetches-per-zone`` 选项而被传递或丢掉
   个数。）。

``refresh`` *zone* [*class* [*view*]]
   对指定的区进行区维护。

``reload``
   重新载入配置文件和区文件。

``reload`` *zone* [*class* [*view*]]
   重新载入指定的区文件。

``retransfer`` *zone* [*class* [*view*]]
   重新从主服务器传送指定的区文件。

   如果使用 ``inline-signing`` 配置区，区的签名版本将被丢弃；在重新
   传送非签名版本完成后，将使用所有新签名重新生成签名版本。

``scan``
   扫描可用网络接口列表以查看变化，不执行完全的 ``reconfig`` ，也不
   等待 ``interface-interval`` 计时器。

``secroots`` [**-**] [*view* ...]
   为指定视图转储安全根（即，通过 ``trust-anchors`` 语句，或
   ``managed-keys`` 或 ``trusted-keys`` 语句（这两个都被废弃了），
   或 ``dnssec-validation auto`` 配置的信任锚）和否定信任锚。如果没
   有指定视图，就转储所有视图。安全根指示它们是否配置成受信任密钥，
   被管理密钥，或者正在初始化的被管理密钥（还未被一个成功的密钥刷新
   请求更新的被管理密钥）。

   如果第一个参数是“-”，通过 ``rndc`` 响应通道返回输出，并输出到标
   准输出。否则，将返回写到安全根转储文件，缺省是 ``named.secroots`` ，
   但可以在 ``named.conf`` 中通过 ``secroots-file`` 选项覆盖。

   参见 ``rndc managed-keys`` 。

``serve-stale`` (**on** | **off** | **reset** | **status**) [*class* [*view*]]
   打开，关闭，重置或报告配置在 ``named.conf`` 中的旧答复服务的当前
   状态。

   如果旧答复服务被 ``rndc-serve-stale off`` 关闭，那么，即使 :manpage:`named(8)`
   重新加载或重新配置，它仍然会关闭。 ``rndc serve-stale reset`` 恢复
   ``named.conf`` 中的配置。

   ``rndc serve-stale status`` 将报告旧答复服务当前是被配置打开或关
   闭，或者被 ``rndc`` 关闭。它也会报告 ``stale-answer-ttl`` 和
   ``max-stale-ttl`` 的值。

``showzone`` *zone* [*class* [*view*]]
   输出一个运行区的配置。

   参见 ``rndc zonestatus`` 。

``sign`` *zone* [*class* [*view*]]
   从密钥目录取给定区的所有DNSSEC密钥（参见BIND 9管理员参考手册中的
   ``key-directory`` ），如果它们在其发布期内，将它们合并到区的
   DNSKEY资源记录集中。如果DNSKEY资源记录集发生了变化，就自动使用新
   的密钥集合对区重新签名。

   这个命令要求使用 ``dnssec-policy`` 配置区，或者 ``auto-dnssec``
   区选项被设置为 ``allow`` 或 ``maintain`` ，还要求区被配置为允许
   动态更新。（更详细情况参见管理员参考手册中的“动态更新策略”。）

   参见 ``rndc loadkeys`` 。

``signing`` [(**-list** | **-clear** *keyid/algorithm* | **-clear** *all* | **-nsec3param** ( *parameters* | none ) | **-serial** *value* ) *zone* [*class* [*view*]]
   列出，编辑或删除指定区的DNSSEC签名状态记录。正在进行的DNSSEC操作
   （如签名或生成NSEC3链）的状态以DNS资源记录类型 ``sig-signing-type``
   的形式存放在区中。 ``rndc signing -list`` 转换这些记录成为人可读
   的格式，指明哪个密钥是当前签名所用，哪个已完成对区的签名，哪个
   NSEC3链被创建和删除。

   ``rndc signing -clear`` 可以删除单一的一个密钥（以
   ``rndc signing -list`` 用来显示密钥的同一格式所指定的），或所有
   密钥。在这两种情况下，只有完成的密钥才能被删除；任何记录指明，
   一个没有完成签名的密钥将会被保留。

   ``rndc signing -nsec3param`` 为一个区设置NSEC3参数。这只是在与
   ``inline-signing`` 区一起使用NSEC3时才有的支持机制。参数以与
   NSEC3PARAM资源记录同样的格式指定：hash算法，flags，iterations和
   salt，按上述顺序。

   当前，hash算法唯一定义的值为 ``1`` ，表示SHA-1。 ``flags`` 可以
   被设置为 ``0`` 或 ``1`` ，取决与你是否希望设置NSEC3链中的opt-out
   位。 ``iterations`` 定义额外次数的数字，它应用于生成NSEC3哈希的
   算法中。 ``salt`` 是一个表示成十六机制数的一串数据，一个连字符
   （‘-’）表示不使用salt，或者关键字 ``auto`` ，它使 :manpage:`named(8)`
   生成一个随机64位salt。

   例如，要创建一个NSEC3链，使用SHA-1 哈希算法，没有opt-out标志，
   10次循环，以及一个值为“FFFF”的salt，使用：
   ``rndc signing -nsec3param 1 0 10 FFFF zone`` 。要设置opt-out
   标志，15次循环，没有salt，使用：
   ``rndc signing -nsec3param 1 1 15 - zone`` 。

   ``rndc signing -nsec3param none`` 删除一个现存的NSEC3链并使用NSEC
   替代它。

   ``rndc signing -serial value`` 设置区的序列号为指定值。如果这个值
   将会使序列号后退，它将被拒绝。主要用途是在联机签名区中设置序列号。

``stats``
   写服务器的统计信息到统计文件。（参见BIND 9管理员参考手册中的
   ``statistics-file`` 选项。）

``status``
   显示服务器的状态。注意，区数目包括内部的 ``bind/CH`` 区，如果没有
   显式配置根区还包括缺省的 ``./IN`` 区。

``stop`` **-p**
   停止服务器，在之前先确保所有通过动态更新或IXFR所作的最新修改第一时
   间被存入被修改区的区文件中。如果指定了 ``-p`` ，将返回
   :manpage:`named(8)` 的进程号。这可以让一个外部进程来检查
   :manpage:`named(8)` 是否完全被停止。

   参见 ``rndc halt`` 。

``sync`` **-clean** [*zone* [*class* [*view*]]]
   将一个动态区中日志文件的变化部分同步到其区文件。如果指定了“-clean”
   选项，会将日志文件删除。如果未指定区，将同步所有区。

``tcp-timeouts`` [*initial* *idle* *keepalive* *advertised*]
   当不使用参数调用时，显示 ``tcp-initial-timeout`` ，
   ``tcp-idle-timeout`` ， ``tcp-keepalive-timeout`` 和
   ``tcp-advertised-timeout`` 选项的当前值。当使用参数调用时，更新这
   些值。这允许一位管理员在面临一次拒绝服务攻击时能够快速调整。参见
   BIND 9管理员参考手册中对这些选项的描述以获取关于它们用法的详细信息。

``thaw`` [*zone* [*class* [*view*]]]
   解冻一个被冻结的动态更新区。如果没有指定区，就解冻所有被冻结的区。
   它会导致服务器重新从磁盘载入区，并在载入完成后打开动态更新功能。在
   解冻一个区后。动态更新请求将不会被拒绝。如果区被修改并且使用了
   ``ixfr-from-differences`` 选项，将修改日志文件以对应到区的变化。否
   则，如果区被修改，将会删除所有现存的日志文件。

   参见 ``rndc freeze`` 。

``trace``
   将服务器的调试级别增加1。

``trace`` *level*
   将服务器的调试级别设置为指定的值。

   参见 ``rndc notrace`` 。

``tsig-delete`` *keyname* [*view*]
   从服务器删除所给出的TKEY协商的密钥。（这个命令不会删除静态配置的
   TSIG密钥。）

``tsig-list``
   列出当前被配置由 :manpage:`named(8)` 所使用的每个视图中的全部TSIG
   密钥的名字。这个列表包含静态配置的密钥和动态TKEY协商的密钥。

``validation`` (**on** | **off** | **status**) [*view* ...]``
   打开，关闭DNSSEC验证或检查DNSSEC验证的状态。缺省时，验证时打开的。

   当验证被打开或者关闭时刷新缓存，以避免使用不同状态下可能不同的数据。

``zonestatus`` *zone* [*class* [*view*]]
   显示给定区的当前状态，包含主文件名以及它加载时包含的所有文件，最近
   加载的时间，当前序列号，节点数目，区是否支持动态更新，区是否作了
   DNSSEC签名，它是否使用动态DNSSEC密钥管理或inline签名，以及区的预期
   刷新或过期时间。

   参见 ``rndc showzone`` 。

指定区名的 ``rndc`` 命令，例如 ``reload`` ， ``retransfer`` 或
``zonestatus`` ，在应用于类型 ``redirect`` 的区时可能会有歧义。
重定向区总是被称为“.”，可能与 ``hint`` 类型的区或者根区的辅拷贝
混淆。要指定一个重定向区，使用特定的区名 ``-redirect`` ，不带结
尾的点。（如果带有结尾的点，这就会指定一个名为“-redirect”的区。）

限制
~~~~~~~~~~~

当前没有在不使用配置文件的方式下提供共享密码 ``key_id`` 的方式。

几个错误消息可以被清除。

参见
~~~~~~~~

:manpage:`rndc.conf(5)`, :manpage:`rndc-confgen(8)`,
:manpage:`named(8)`, :manpage:`named.conf(5)`, :manpage:`ndc(8)`, BIND 9管理员参考手册。
