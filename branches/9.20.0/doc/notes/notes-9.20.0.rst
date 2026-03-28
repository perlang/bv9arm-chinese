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

BIND 9.20.0注记
---------------

.. note:: 本部份仅列出自BIND 9.18.28以来的变化，它是在BIND 9.20.0发布
          之前的上一个BIND稳定分支的最新版本。

新特性
~~~~~~

- :any:`forwarders` 语句现在支持 :any:`tls` 参数，用于转发查询到开启
  DoT的服务器。 :gl:`#3726`

- :iscman:`named` 现在支持通过DNS-over-TLS (DoT)转发动态DNS更新。
  :gl:`#3512`

- :iscman:`nsupdate` 工具现在支持DNS-over-TLS (DoT)。 :gl:`!6752`

- :any:`tls` 块扩展了一个新的 :any:`cipher-suites` 选项，该选项允许为
  TLSv1.3设置被允许的加密套件。更多详细信息，请参考相关文档。
  :gl:`#3504`

- 增加了对PROXYv2协议的初步支持。 :iscman:`named` 现在可以在所有已实
  现的传输方式中接受PROXYv2头部，并且 :iscman:`dig` 也可以在其发送的
  查询中插入这些头部。更多详细信息，请查阅相关文档（对
  :iscman:`named` ，有 :any:`allow-proxy` ， :any:`allow-proxy-on` ，
  :any:`listen-on` 和 :any:`listen-on-v6` ，对 :iscman:`dig` ，有
  :option:`dig +proxy` 和 :option:`dig +proxy-plain` ）。 :gl:`#4388`

- EDNS EXPIRE选项的客户端侧支持扩展了包含IXFR和AXFR查询类型。这个增强
  使得 :iscman:`named` 能够在执行AXFR和IXFR查询时结合EDNS EXPIRE选项。
  :gl:`#4170`

- 引入了一个新配置选项 :any:`require-cookie` 。它规定了对一个给定的前缀，
  是否应该在响应中出现一个DNS COOKIE；如果不应该， :iscman:`named` 回退
  到TCP。它用于其知道给定的服务器支持DNS COOKIE时。它也可用于强制所有非
  DNS COOKIE响应回退到TCP。 :gl:`#2295`

- 增加了 :any:`check-svcb` 选项，用以控制检查SVCB记录上的附加限制。这
  个变化影响 :iscman:`named` ， :iscman:`named-checkconf` ，
  :iscman:`named-checkzone` ， :iscman:`named-compilezone` 和
  :iscman:`nsupdate` 。 :gl:`#3576`

- 新的 :any:`resolver-use-dns64` 选项使 :iscman:`named` 能够在发送递
  归查询时对IPv4服务器地址应用 :any:`dns64` 规则，这样解析可以在一个
  NAT64连接上执行。 :gl:`#608`

- :any:`dnssec-policy` 增加了一个新选项 :any:`cdnskey` ，它允许用户开
  启或者关闭CDNSKEY记录的公开。 :gl:`#4050`

- 在使用 :any:`dnssec-policy` 时，当需要用 :any:`cds-digest-types` 发
  布CDS记录时，现在能够配置使用摘要类型。另外，发布特定的CDNSKEY/CDS
  记录现在可以使用 :option:`dnssec-signzone -G` 设置。 :gl:`#3837`

- 在增加了使用 :any:`inline-signing` 时，支持多个签名者模式2
  (:rfc:`8901`)。 :gl:`#2710`

- 对HSM的支持被增加到 :any:`dnssec-policy` 中。现在可以使用
  ``key-store`` 配置密钥，它允许用户设置密钥文件存储的目录和设置一个
  PKCS#11 URI字符串。后者要求OpenSSL 3和为其配置一个有效的PKCS#11提供
  者。 :gl:`#1129`

- 新增一个DNSSEC工具 :iscman:`dnssec-ksr` ，用以创建密钥签名请求（KSR
  ）和签名密钥响应（SKR）文件。 :gl:`#1128`

- :iscman:`dnssec-verify` 和 :iscman:`dnssec-signzone` 现在接受 ``-J``
  选项，来指定在加载需要被验证或被签名的区时要读取的日志文件。
  :gl:`#2486`

- :iscman:`dnssec-keygen` 现在运行选项 :option:`-k
  <dnssec-keygen -k>` 和 :option:`-f <dnssec-keygen -f>` 一起使用。这
  允许为给定的 :any:`dnssec-policy` 创建仅匹配 KSK (``-fK``)或ZSK
  (``-fZ``)角色的密钥。 :gl:`#1128`

- :any:`response-policy` 语句扩展了一个新参数 ``ede`` 。它使得被一个
  给定RPZ所修改的响应，能够设置一个 :rfc:`8914` 扩展DNS错误码（EDE）。
  :gl:`#3410`

- 在与远端服务器，如 :any:`primaries` 和 :any:`parental-agents` ，通
  信时，新增了一种配置首选源地址的方式：现在可以为特定的语句设置
  ``source`` 和/或 ``source-v6`` 参数。这个新方法旨在最终替代诸如
  :any:`parental-source` ， :any:`parental-source-v6` ，
  :any:`transfer-source` 等。 :gl:`#3762`

- 新命令行 :option:`delv +ns` 选项激活名字服务器模式，在解析一个查询
  时，更精确地复制了 :iscman:`named` 的行为。在这个模式，
  :iscman:`delv` 使用了一个内部递归解析器，而不是一个外部服务器。所有
  在解析和验证过程中发送和接收的消息都被记录日志。这个可以用于替代
  :option:`dig +trace` 。:gl:`#3842`

- :iscman:`rndc` 中的读超时时间现在可以使用 :option:`-t <rndc -t>`
  选项在命令行中指定，允许需要相当长时间才能完成的命令能够完成。
  :gl:`#4046`

- 统计通道现在包含关于当前正在进行的入向区传送的信息。 :gl:`#3883`

- 在统计通道中的入向区传送信息现在也展示区的“首次刷新”标志，后者指示
  区尚未完全就绪，其首次更新正在等待处理或正在进行中。现在还可以通过
  :option:`rndc status` 命令查看这类区的数量。 :gl:`#4241`

- 增加了一个新的统计变量 ``recursive high-water`` ，它报告正在运行的
  BIND所处理的递归客户端的最大并发数量。 :gl:`#4668`

- 一条新命令， :option:`rndc fetchlimit` ，打印当前因
  :any:`fetches-per-server` 而受比率限制的名字服务器地址列表和因
  :any:`fetches-per-zone` 而受比率限制的域名列表。 :gl:`#665`

- 查询和响应现在针对DNS-over-TLS (DoT)和DNS-over-HTTPS (DoH)发送不同
  的dnstap条目，而 :any:`dnstap-read` 能够理解这些条目。 :gl:`#4523`

- :iscman:`dnstap-read` 现在可以带有毫秒精度的长时间戳。 :gl:`#2360`

- 增加了对libsystemd的 ``sd_notify()`` 函数的支持，使得
  :iscman:`named` 能够向初始化系统报告其状态。这就允许systemd在开始依
  赖名字解析的其它服务之前等待 :iscman:`named` 完全就绪。 :gl:`#1176`

- 增加了对用户静态定义跟踪（User Statically Defined Tracing，USDT）探
  测的支持。这些探测能够进行细粒度的应用跟踪，并在其未启用时不产生任
  何额外开销。 :gl:`#4041`

去掉的特性
~~~~~~~~~~

- 对Red Hat Enterprise Linux版本7（和克隆版）的支持被去掉了。现在需要
  C11兼容的编译器来编译BIND 9。 :gl:`#3729`

- 不再支持编译时带有比4.0.0版本更旧的 `jemalloc`_ 。这些版本不提供当
  前BIND 9版本所要求的特性。 :gl:`#4296`

- ``auto-dnssec`` 配置语句被移除了。请使用 :any:`dnssec-policy` 或手
  工签名作为替代。关于从 ``auto-dnssec`` 到 :any:`dnssec-policy` ，参
  考文章
  `迁移到dnssec-policy <https://kb.isc.org/docs/dnssec-key-and-signing-policy#migrate-to-dnssecpolicy>`_

  下列语句已被废除： :any:`dnskey-sig-validity` ，
  :any:`dnssec-dnskey-kskonly` ， :any:`dnssec-update-mode` ，
  :any:`sig-validity-interval` 和 :any:`update-check-ksk` 。
  :gl:`#3672`

- 增加和删除DNSKEY和NSEC3PARAM记录的动态更新不会触发密钥轮转和不存在
  的操作。这也意味 :any:`dnssec-secure-to-insecure` 已被废除。
  :gl:`#3686`

- ``glue-cache`` *选项* 已被移除。附加缓存 *特性* 仍然可以工作，并且
  现在已经永久 *开启* :gl:`#2147`

- 从BIND 9.18开始，配置控制通道使用一个Unix域套接字被当成一个致命错误。
  这个特性现已被完全去掉，并且 :iscman:`named-checkconf` 现在将其报告
  为一个配置错误。 :gl:`#4311`

- 为入向区传送设置替代的本地地址的命令（ ``alt-transfer-source`` ，
  ``alt-transfer-source-v6`` 和 ``use-alt-transfer-source`` ）已被移
  除。 :gl:`#3714`

- ``resolver-nonbackoff-tries`` 和 ``resolver-retry-interval`` 语句已
  被移除。现在使用它们将导致一个致命错误。 :gl:`#4405`

- BIND 9不再支持非0的 :any:`stale-answer-client-timeout` 值，当这个特
  性被开启时。如果使用了一个非0值， :iscman:`named` 现在会生成一条告警
  日志消息，并将值作为 ``0`` 对待。 :gl:`#4447`

- 差异化服务码点（Differentiated Services Code Point，DSCP）特性已被
  移除。在 ``named.conf`` 中配置DSCP值现在是一个配置错误。 :gl:`#3789`

- ``keep-response-order`` 选项已被宣布废弃并在功能上已经移除。
  :iscman:`named` 期望DNS客户端完全兼容 :rfc:`7766` 。 :gl:`#3140`

- 区类型 ``delegation-only`` ，以及 ``delegation-only`` 和
  ``root-delegation-only`` 语句，已被移除。使用它们将导致一个配置错误。

  创建这些语句是为了解决“站点查找器”（SiteFinder）争议，某些顶级域将
  错误拼写的查询重定向到其它网站，而不是返回NXDOMAIN响应。自从顶级域
  现在都已DNSSEC签名，缺省时，DNSSEC验证已经激活，不再需要这些语句了。
  :gl:`#3953`

- ``coresize`` ， ``datasize`` ， ``files`` 和 ``stacksize`` 选项已被
  移除。这些选项所设置的限制应当由外部强制施行，要么通过手动配置（例
  如，使用 ``ulimit`` ），要么使用进程管理器（例如， ``systemd`` ）。
  :gl:`#3676`

- 对使用AES作为DNS COOKIE算法（ ``cookie-algorithm aes;`` ）的支持已
  被移除。现在唯一支持的DNS COOKIE算法是当前的缺省值，SipHash-2-4。
  :gl:`#4421`

- TKEY模式2（Diffie-Hellman Exchanged Keying Mode）已被移除，现在使用
  TKEY模式2将是一个致命错误。建议用户切换到TKEY模式3（GSS-API）。
  :gl:`#3905`

- 原本为了让GSS-TSIG能够绕过Windows 2000的Active Directory的漏洞而添
  加的特殊代码已被移除，因为Windows 2000已经走完了生命周期。
  :option:`-o <nsupdate -o>` 选项和 :iscman:`nsupdate` 的
  ``oldgsstsig`` 命令已被废弃，现在分别被作为
  :option:`-g <nsupdate -g>` 和 ``gsstsig`` 命令的同义词对待。
  :gl:`#4012`

- 对 ``lock-file`` 语句和对 ``named -X`` 命令行选项的支持已被移除。应
  该使用一个外部进程管理器来替代。 :gl:`#4391`

  作为替代， ``flock`` 工具（util-linux的部份）在Linux系统中可以用于
  取得与 ``lock-file`` 或 ``named -X`` 同样的效果：

  ::

    flock -n -x <directory>/named.lock <path>/named <arguments>

- :iscman:`named` 命令行选项 :option:`-U <named -U>` ，用于指定UDP分
  发的数量，已被移除。现在使用它会返回一条警告信息。 :gl:`#1879`

- ``configure`` 的 ``--with-tuning`` 选项已被移除。在编译时设置中，基
  于“工作负载”需要不同值的设置（之前会受到 ``--with-tuning`` 选项值的
  影响）要么已被移除，要么已改为更合理的缺省值。 :gl:`#3664`

- 在 ``libbind9`` 共享库中的功能被移动到 ``libisc`` 和 ``libisccfg``
  库中了。现在已空的 ``libbind9`` 已被移除，不再安装。 :gl:`#3903`

- ``irs_resconf`` 模块已被移动到 ``libdns`` 共享库中。现在已空的
  ``libirs`` 库已被移除，不再安装。 :gl:`#3904`

.. _`jemalloc`: https://jemalloc.net/

废弃的特性
~~~~~~~~~~

本部份所列的特性仍然可以工作，但是计划最终被移除。

- 在 :namedconf:ref:`options` 和 :namedconf:ref:`zone` 块中使用
  :any:`max-zone-ttl` 选项已被废弃；它现在应该配置成
  :any:`dnssec-policy` 的一部分。如果这个选项用于
  :namedconf:ref:`options` 或 :any:`zone` 块中，将在日志中记录一条告
  警消息。在将来的版本中，它会成为非操作的。 :gl:`#2918`

- :any:`sortlist` 选项已被废弃，将在未来的BIND 9.21.x版本中被移除。用
  户不应该依赖于DNS消息中资源记录的特定顺序。 :gl:`#4593`

- :any:`rrset-order` 选项的 ``fixed`` 值和对应的 ``configure`` 脚本选
  项已被废弃，并将在未来的BIND 9.21.x版本被移除。用户不应该依赖于DNS
  消息中资源记录的特定顺序。 :gl:`#4446`

特性变化
~~~~~~~~

- BIND当前依赖于 `liburcu`_ ，Userspace RCU，以实现无锁数据结构。
  :gl:`#3934`

- 在Linux上， `libcap`_ 现在是要求的依赖，以帮助 :iscman:`named` 保持
  所需的特权。 :gl:`#3583`

- 编译BIND 9现在要求至少1.34.0或更高版本的libuv。libuv应该在所有支持
  的平台上可用，可以为原生包，也可以是移植版。 :gl:`#3567`

- 出向区传送缺省不再被开启。现在必须在 :any:`zone` ， :any:`view` 或
  者 :namedconf:ref:`options` 层级显式设置 :any:`allow-transfer` ACL
  才能开启出向区传送。 :gl:`#4728`

- :any:`dnssec-policy` 签名的DNS区现在自动地检测其父服务器，BIND查询
  它们以检查DS资源记录集的内容。当父区更新DNSSEC密钥时，例如使用
  CDS/CDNSKEY机制，DNSSEC密钥轮转能够安全和自动地进行。这个行为由于新
  的 :any:`checkds` 特性而更容易，它通过解析父区的NS记录而自动地添加
  :any:`parental-agents` 。在 :any:`dnssec-policy` 发起的KSK轮转期间，
  查询这些代理名字服务器以检查DS资源记录集。 :gl:`#3901`

- 在作为权威服务器服务于一个重度授权区时，加载这个区之后
  :iscman:`named` 的响应能力提升了。 :gl:`#4045`

- 为了降低在负载之下查询处理的延迟，花费在解决缓存域名的长链上不间断
  时间已被缩短。 :gl:`#4185`

- 在递归解析过程中，查询名字服务器的地址时，现在已使用了QNAME最小化。
  :gl:`#4209`

- BIND现在为过时或者有其它问题但格式正确的DNS服务器cookie而返回
  BADCOOKIE。 :gl:`#4194`

- BIND 9中所用的DNS名字压缩算法已被修订：它现在的压缩效果比以前更好，
  因此包含多个标记的名字形成的响应比以前更小。 :gl:`#3661`

- 对较大的增量区传送（IXFR）的处理已经卸载到一个独立的工作线程上，因
  此不会妨碍网络线程在此时处理普通网络流量。 :gl:`#4367`

- 对统计通道的查询不再阻塞在网络事件循环级别的DNS通信。 :gl:`#4680`

- 如没有给区配置 :any:`dnssec-policy` ，:any:`inline-signing` 区选
  项现在会被忽略。这意味着未签名的区不再为区创建冗余的签名版本。
  :gl:`#4349`

- :any:`inline-signing` 语句现在也能在 :any:`dnssec-policy`
  内设置。内置策略 ``default`` 和 ``insecure`` 都开启使用
  :any:`inline-signing` 。如果在 ``zone`` 级设置
  :any:`inline-signing` ，它会覆盖在 :any:`dnssec-policy` 中所设置的
  值。 :gl:`#3677`

- 遵循 :rfc:`9276` 的推荐， :any:`dnssec-policy` 现在为该策略所管理的、
  使用NSEC3进行DNSSEC签名的区设置NSEC3迭代次数为0。 :gl:`#4363`

- 为验证目的所允许的NSEC3最大迭代次数已从150降为50。包含迭代次数过50
  次的NSEC3记录的DNSSEC响应现在都被当成是不安全的。 :gl:`#4363`

- ``dnssec-validation yes`` 选项现在要求一个显式配置的
  :any:`trust-anchors` 语句。如果实际操作中不需要使用手工信任锚，那么
  请考虑使用 ``dnssec-validation auto`` 替代。 :gl:`#4373`

- 缺省时， :iscman:`named-compilezone` 不再执行区的完整性检查；这允许
  一个区文件从一种格式快速转换为另一种。 :gl:`#4364`

  区检查可以通过单独运行 :iscman:`named-checkzone` 来执行，或者通过使
  用下列命令了恢复之前的缺省行为：

  ::

    named-compilezone -i full -k fail -n fail -r warn -m warn -M warn -S warn -T warn -W warn -C check-svcb:fail

- 用于RBTDB（缓存和区数据库的缺省数据库实现）的红黑树数据库结构已被
  QP-tries所替换。这预计会提升性能和可扩展性，虽然在当前的实现中，大
  型区所需的内存比之前的红黑树数据结构大约多15%。

  这个变化的一个副作用是由 :any:`masterfile-style` ``relative`` 所创
  建的区 - 例如， :any:`dnssec-signzone` 的输出 - 将不再有多个不同的
  `$ORIGIN` 语句。对服务器的行为没有其它变化。

  现在，旧的基于RBT的数据库仍然存在，在 ``named.conf`` 的 ``zone`` 语
  句中指定 ``database rbt`` ，或者在编译时带上
  ``configure --with-zonedb=rbt --with-cachedb=rbt`` ，就可以使用。
  :gl:`#4411` :gl:`#4614`

- 当在单个TCP消息中发送时，现在会处理多个RNDC消息。

  ISC感谢Dominik Thalhammer报告这个问题并准备初始的补丁。 :gl:`#4416`

- 在区统计中包含的DNSSEC签名数据仅通过密钥ID标识密钥；当两个密钥使用
  不同的算法却有同样的ID时会导致混乱。区统计现在使用算法号，后跟"+"，
  后跟密钥ID来标识密钥：例如， ``8+54274`` 。 :gl:`#3525`

- 之前，每个NSEC3签名的区所对应的NSEC3PARAM记录的TTL值都被设置为0。现
  在已修改为与给定区的SOA MINIMUM值一致。 :gl:`#3570`

- 在启动时， :iscman:`named` 现在设置打开文件数的限制为操作系统允许的
  最大值，替代了试图将其设置为"unlimited"。 :gl:`#3676`

- 当一个国际化域名无法根据IDNA2008验证时， :iscman:`dig` 现在尝试根据
  IDNA2003规则转换它，或者原封不动地传递它，而不是输出一个错误消息后
  停止。 ``idna2`` 工具可用于检查IDNA语法。 :gl:`#3527`

- 内存统计减少到一个计数器， ``InUse`` ； ``Malloced`` 是其别名，含有
  同样的值。其它计数器用于旧版BIND 9的内部内存分配器，但是现在都不需
  要了，因此都被移除了。 :gl:`#3718`

- 日志消息 ``resolver priming query complete`` 已从INFO日志级改为
  DEBUG(1)日志级，以阻止 :iscman:`delv` 在设置其内部解析器时发送该消
  息。 :gl:`#3842`

- 工作线程的事件循环现在由一个新的“循环管理器”API管理，显著地改变了任
  务、计时器和网络子系统的架构，以实现性能提升和代码流程优化。
  :gl:`#3508`

- 关于DNS over TCP和 DNS over TLS传输的代码被替换为一个新的、统一的传
  输实现。 :gl:`#3374`

.. _`liburcu`: https://liburcu.org/
.. _`libcap`: https://sites.google.com/site/fullycapable/

漏洞修补
~~~~~~~~

- 当为多个目的地址和区配置了同样的 :any:`notify-source` 地址和端口号
  时，一个无响应的服务器可能占用相关的网络套接字直至超时；在此期间，
  到其它服务器的NOTIFY消息会无声的失败。 :iscman:`named` 现在会通过
  TCP重新发送这样的NOTIFY消息。此外，NOTIFY失败现在会以INFO级别写入
  日志。 :gl:`#4001` :gl:`#4002`

- DNS压缩不再应用于根名字(``.``)，如果其在同一个RRset中重复使用。
  :gl:`#3423`

- :iscman:`named` 可能为其大小接近UDP包大小限制的响应不正确地返回非截
  断、无附带引用的响应。这个问题已被修复。 :gl:`#1967`

已知问题
~~~~~~~~

- 在包括FreeBSD的某些平台， :iscman:`named` 必须使用root运行，以在一个
  特权端口（例如，小于1024的端口号；这包括缺省的
  :iscman:`rndc` :rndcconf:ref:`port` ，953）上使用 :iscman:`rndc` 控
  制通道。当前，使用 :option:`named -u` 选项切换到一个非特权用户使得
  :iscman:`rndc` 无法使用。这将会在将来的版本中修补；同时，
  ``mac_portacl`` 可用作一种替代方法，如在 
  https://kb.isc.org/docs/aa-00621 中所记录的。 :gl:`#4793`

- 关于影响这个BIND 9分支的所有已知问题的列表，参见
  :ref:`上文 <relnotes_known_issues>` 。
