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

BIND 9.18.0注记
---------------------

.. note:: 本部份仅列出自BIND 9.16.25以来的变化，它是在BIND 9.18.0发布
          之前的上一个BIND的稳定分支的最新版本。

已知问题
~~~~~~~~~~~~

- ``rndc`` 已被更新使用新的BIND网络管理器API。因为当前的网络管理器没有
  对UNIX域套接字的支持，它们现在不能再用于 ``rndc`` 。这个问题将在未来
  的版本中得到解决，要么恢复UNIX域套接字支持，要么在控制通道中正式宣布
  它们过时。 :gl:`#1759`

新特性
~~~~~~~~~~~~

- ``named`` 现在支持使用传输层安全（Transport Layer Security, TLS）保护
  DNS流量。TLS用于DNS over TLS(DoT)和DNS over HTTPS(DoH)。

  ``named`` 可以使用用户提供的证书，也可使用启动时自动生成的临时证书。
  :ref:`tls statement <tls>` 允许对TLS参数进行细粒度的控制。
  :gl:`#1840` :gl:`#2795` :gl:`#2796`

  为调试目的，在设置了 ``SSLKEYLOGFILE`` 环境变量时， ``named`` 记录TLS
  pre-master secrets日志。这启用了对加密流量问题的故障排除。
  :gl:`#2723`

- 对DNS over TLS (DoT)的支持被增加到 ``named`` 中。DoT的网络接口使用现
  存的 :ref:`listen-on <interfaces>` 指令，而TLS参数使用新的
  :ref:`tls statement <tls>` 配置。 :gl:`#1840`

  对于入向和出向区传送， ``named`` 支持
  :rfc:`zone transfers over TLS <9103>` (XFR-over-TLS, XoT)。

  经由TLS的入向区传送通过增加 ``tls`` 关键字，后跟一个先前
  :ref:`tls statement <tls>` 配置的名字，或者后跟字符串
  ``ephemeral`` ，到 :ref:`primaries <primaries_grammar>` 列表所包含的
  地址来开启。 :gl:`#2392`

  类似地， :ref:`allow-transfer <allow-transfer-access>` 选项也被扩展以
  接受额外的 ``port`` and ``transport`` 参数，进一步限制出向区传输到特
  定的端口和/或DNS传输协议。 :gl:`#2776`

  注意经由TLS的区传送（zone transfers over TLS，XoT）在TLS握手时，要求
  选择应用层协议协商（Application-Layer Protocol Negotiation，ALPN）符
  号 ``dot`` ，也是 :rfc:`9103` 第7.1节所要求的。这个可能导致与XoT服务
  器不兼容的问题。 :gl:`#2794`

  ``dig`` 工具现在能够发送DoT请求（ ``+tls`` 选项）。 :gl:`#1840`

  当前不支持经由DoT转发DNS请求。

- 对DNS over HTTPS (DoH)的支持被增加到 ``named`` 中。TLS加密和不加密两
  种连接都支持（后者可能用于将加密卸载给其它软件）。DoH的网络接口使用现
  存的 :ref:`listen-on <interfaces>` 指令配置，而TLS参数使用新的
  :ref:`tls statement <tls>` 配置，HTTP参数使用新的
  :ref:`http statement <http>` 配置。 :gl:`#1144` :gl:`#2472`

  对服务器侧的并发DoH连接数和每个连接中活跃HTTP/2流数目的限额可以使用
  全局的 ``http-listener-clients`` 和 ``http-streams-per-connection``
  选项，或者在 :ref:`http statement <http>` 中的 ``listener-clients``
  和 ``streams-per-connection`` 参数来配置。 :gl:`#2809`

  ``dig`` 工具现在能够发送DoH请求（ ``+https`` 选项）。 :gl:`#1641`

  当前不支持经由DoH转发DNS请求。

  可以在编译时使用一个新的编译时选项 ``--disable-doh`` 来禁用DoH支持。
  这允许在没有 `libnghttp2`_ 库的情况下构建BIND 9。 :gl:`#2478`

- 增加了一个新的日志类别 ``rpz-passthru`` ，它允许RPZ passthru动作被记
  录到一个独立的通道。 :gl:`#54`

- 配置文件的 ``response-policy`` 子句中增加了一个新选项
  ``nsdname-wait-recurse`` 。当设置为 ``no`` 时，RPZ NSDNAME规则只适用
  于查询名的权威命名服务器已经被查找并存在于缓存时。如果此信息不存在，
  则忽略RPZ NSDNAME规则，但在后台查找该信息并应用于后续查询。缺省是
  ``yes`` ，意谓着总是应用RPZ NSDNAME规则，即使信息需要先被查找。
  :gl:`#1138`

- 对HTTPS何SVCB记录类型的支持现在也包括在ADDITIONAL部份对这些记录类型的
  处理。 :gl:`#1132`

- 增加了新的配置选项， ``tcp-receive-buffer`` ， ``tcp-send-buffer`` ，
  ``udp-receive-buffer`` 和 ``udp-send-buffer`` 。这些选项允许操作者微
  调操作系统中的接收和发送缓冲区。在繁忙的服务器上，增加接收缓冲区的大
  小可以阻止服务器在短暂的流量峰值时丢包，减少它可以防止服务器因太旧或
  已经超时的查询而阻塞。 :gl:`#2313`

- 增加了新的细粒度的 ``update-policy`` 规则类型
  ``krb5-subdomain-self-rhs`` 和 ``ms-subdomain-self-rhs`` ，这些规则类
  型限制对SRV和PTR记录的更新，因此它们的内容只能匹配进行更改的Kerberos
  主体中嵌入的机器名。 :gl:`#481`

- 每个类型的记录计数限制现在可以在 ``update-policy`` 语句中指定，以限制
  可以通过动态更新添加到域名的特定类型的记录的数量。 :gl:`#1657`

- 增加了对OpenSSL 3.0 API的支持。 :gl:`#2843` :gl:`#3057`

- 如果特定客户端的访问请求被拒绝，现在会设置扩展DNS错误码18 -
  Prohibited（参见 :rfc:`8914` 第4.19部份）。 :gl:`#1836`

- 当配置了DNS64时， ``ipv4only.arpa`` 现在提供服务。 :gl:`#385`

- ``dig`` 现在可以报告正在使用的DNS64前缀（ ``+dns64prefix`` ）。这在运
  行 ``dig`` 的主机位于IPv6-only链路后，使用DNS64/NAT64或464XLAT实现
  IPv4aaS（IPv4作为服务）时是非常有用的。 :gl:`#1154`

- ``dig`` 的输出现在包括使用的传输协议（UDP，TCP，TLS，HTTPS）。
  :gl:`#1144` :gl:`#1816`

- ``dig +qid=<num>`` 允许用户为测试目的而指定一个特定的请求ID。
  :gl:`#1851`

.. _libnghttp2: https://nghttp2.org/

去掉的特性
~~~~~~~~~~~~~~~~

- 对 ``map`` 区文件格式(``masterfile-format map;``)的支持已被移除。建议
  依赖 ``map`` 格式的用户在升级BIND 9之前，使用 ``named-compilezone``
  将区转换为 ``raw`` 格式，并适当地修改配置。 :gl:`#2882`

- 旧式风格的动态加载区（Dynamically Loadable Zones, DLZ）必须在
  ``named`` 构建时开启，现已被移除。新式的DLZ模块可用作其替代。
  :gl:`#2814`

- 在Windows上编译和运行BIND 9的支持已经被完全移除。最后一个支持Windows
  的、可工作的稳定发布分支是BIND 9.16。 :gl:`#2690`

- 原生PKCS#11支持已被移除。 :gl:`#2691`

  当带有OpenSSL 1.x构建时，BIND现在
  :ref:`为PKCS#11使用engine_pkcs11 <pkcs11>` 。engine_pkcs11是一个
  OpenSSL引擎，它是 `OpenSC`_ 项目的一部份。

  因为对所谓“engines”的支持在OpenSSL 3.x中已被弃用，伴随OpenSSL 3.x编译
  的BIND 9，由于前者的构建中已不再保留对废弃API的支持，因此不可能再使用
  PKCS#11。使用OpenSSL 3.x中引入的新“provider”方法的engine_pkcs11的替代
  品正在酝酿中。 :gl:`#2843`

- 由于旧的套接字管理器API已被移除，
  :ref:`statistics channel <statschannels>` 不再报告“socketmgr”统计。
  :gl:`#2926`

- ``glue-cache`` **选项** 被标记为废弃。粘合缓存 **特性** 仍然有效，并
  将在未来的版本中永久 **启用** 。 :gl:`#2146`

- 一些在先前版本中被标记为废弃的非网络配置选项现在已被完全移除了。使用
  下列任何选项现在都被当做一个配置失败：
  ``acache-cleaning-interval`` ， ``acache-enable`` ，
  ``additional-from-auth`` ， ``additional-from-cache`` ，
  ``allow-v6-synthesis`` ， ``cleaning-interval`` ，
  ``dnssec-enable`` ， ``dnssec-lookaside`` ， ``filter-aaaa`` ，
  ``filter-aaaa-on-v4`` ， ``filter-aaaa-on-v6`` ，
  ``geoip-use-ecs`` ， ``lwres`` ， ``max-acache-size`` ，
  ``nosit-udp-size`` ， ``queryport-pool-ports`` ，
  ``queryport-pool-updateinterval`` ， ``request-sit`` ，
  ``sit-secret`` ， ``support-ixfr`` ， ``use-queryport-pool`` ，
  ``use-ixfr`` 。 :gl:`#1086`

- ``dig`` 的选项 ``+unexpected`` 已被移除。 :gl:`#2140`

- IPv6套接字现在显式地限制为只发送和接收IPv6包。由于这破坏了 ``dig``
  的 ``+mapped`` 选项，这个选项已被移除。 :gl:`#3093`

- 禁用和禁止BIND 9二进制文件和库的静态链接，因为BIND 9模块需要
  ``dlopen()`` 支持，并且静态链接还阻止使用像只读重定位(RELRO)或地址空
  间布局随机化(address space layout randomization, ASLR)这样的安全特
  性，这些特性对于与网络交互和处理任意用户输入的程序来说很重要。
  :gl:`#1933`

- ``configure`` 选项 ``--with-gperftools-profiler`` 被移除了。要使用
  gperftools剖析器，需要手工在 ``CFLAGS`` 中设置
  ``HAVE_GPERFTOOLS_PROFILER`` 宏和在 ``LDFLAGS`` 中提供
  ``-lprofiler`` 。 :gl:`!4045`

.. _OpenSC: https://github.com/OpenSC/libp11

特性变化
~~~~~~~~~~~~~~~

- 激进使用DNSSEC已验证缓存（ ``synth-from-dnssec`` ，参见 :rfc:`8198`
  ）现在缺省又是开启的，这是在BIND 9.14.8中被禁用之后的状态。这个特性的
  实现被重新修改，以实现更好的效率，并调整为忽略某些类型的损坏的NSEC记
  录。否定答复的合成当前仅支持使用NSEC的区。 :gl:`#1265`

- ``dnssec-policy`` 的缺省NSEC3参数被更新为没有额外的SHA-1迭代和没有盐
  （ ``NSEC3PARAM 1 0 0 -`` ）。这一变化符合 `最新的NSEC3建议`_ 。
  :gl:`#2956`

- ``dnssec-dnskey-kskonly`` 的缺省值改为 ``yes`` 。这意谓现在DNSKEY，
  CDNSKEY和CDS资源记录集缺省制备KSK签名。当选项设置为 ``no`` 时，使用
  ZSK准备的附加签名将被添加到DNS响应的荷载中，而不提供增加的值。
  :gl:`#1316`

- ``dnssec-cds`` 现在在缺省时只生成SHA-2 DS记录，避免从子区复制已废弃的
  SHA-1记录到父区对自身的委托中。如果子区没有发布SHA-2 CDS记录，
  ``dnssec-cds`` 将从CDNSKEY记录生成它们。 ``-a algorithm`` 选项现在影
  响从CDS和CDNSKEY记录生成DS摘要记录的过程。感谢Tony Finch。
  :gl:`#2871`

- 先前， ``named`` 接受带有或不带有OPT记录的FORMERR响应，这表明给定的服
  务器不支持EDNS。要实现对 :rfc:`6891` 的完全兼容，现在只接受没有OPT记
  录的FORMERR响应。这有意地中断了与不支持EDNS的服务器的通信，并且不正确
  地回应了将RCODE字段设置为FORMERR和QR位设置为1的查询消息。 :gl:`#2249`

- 现在，当进行一个入向区传送时，在处理AXFR、IXFR和SOA答复时，将检查问题
  部份。 :gl:`#1683`

- DNS标志节2020：EDNS缓冲区大小探测代码被删除了，它使解析器基于观察到的
  成功的查询响应和超时调整用于出向请求的EDNS缓冲区大小。解析器现在总是
  使用在 ``edns-udp-size`` 中为所有出向请求而设置的EDNS缓冲区大小。
  :gl:`#2183`

- 在缓存中保持过时答案 (``stale-cache-enable``) 缺省是被关闭的。
  :gl:`#1712`

- ``named`` 使用的总内存被优化并显著减少，特别是在解析器工作负载下。
  :gl:`#2398` :gl:`#3048`

- 在可用的平台上，内存分配现在基于 `jemalloc`_ 库提供的内存分配API。在
  构建BIND 9时现在推荐使用这个库；虽然这是可选的，它缺省是开启的。
  :gl:`#2433`

- 当需要扩展时，为每个缓存数据库维护的内部数据结构现在会递增增长。当这
  些内部数据结构被调整时，这有助于在加载的解析器上保持稳定的响应速率。
  :gl:`#2941`

- 接口处理代码已经被重构为使用更少的资源，这应该会导致更少的内存碎片和
  更好的启动性能。 :gl:`#2433`

- 在统计通道中报告区类型时，现在分别使用术语 ``primary`` 和
  ``secondary`` 替代 ``master`` 和 ``slave`` 。 :gl:`#1944`

- ``rndc nta -dump`` 和 ``rndc secroots`` 命令现在在列出否定信任锚时都
  包含 ``validate-except`` 条目。这些都是通过关键字 ``permanent`` 代替
  过期日期来指明的。 :gl:`#1532`

- ``rndc serve-stale status`` 的输出已被澄清。它现在显式地报告是否开启
  将过时的数据保留在缓存中（ ``stale-cache-enable`` ），以及是否开启在
  响应中返回这样的数据（ ``stale-answer-enable`` ）。 :gl:`#2742`

- 先前，使用 ``dig +bufsize=0`` 有禁用EDNS的副作用，并且没有办法测试远
  程服务器收到EDNS0缓冲区大小设置为0的数据包时的行为。现在情况不再是这
  样了； ``dig +bufsize=0`` 现在发送一个EDNS版本为0且缓冲区大小设置为0
  的DNS消息。要禁用EDNS，使用 ``dig +noedns`` 。 :gl:`#2054`

- 既非守护进程也非管理程序的BIND 9二进制代码被移动到 ``$bindir`` 。只有
  ``ddns-confgen`` ， ``named`` ， ``rndc`` ， ``rndc-confgen`` 和
  ``tsig-confgen`` 留在 ``$sbindir`` 。 :gl:`#1724`

- BIND 9构建系统有了变化，使用一个典型的 autoconf+automake+libtool栈。
  这对从发布的tar包来构建BIND 9的人没有任何差别，但是从Git仓库来构建
  BIND 9时，需要首先运行 ``autoreconf -fi`` 。当使用非标准的
  ``configure`` 选项时，还需要额外的注意事项。 :gl:`#4`

.. _`最新的NSEC3建议` : https://datatracker.ietf.org/doc/html/draft-ietf-dnsop-nsec3-guidance-02

.. _jemalloc: http://jemalloc.net/

漏洞修补
~~~~~~~~~

- 当文件数量超过 ``versions`` 所设置的限制时，使用 ``timestamp`` 风格后
  缀的日志文件总被错误地删除。这个已被解决。 :gl:`#828`
