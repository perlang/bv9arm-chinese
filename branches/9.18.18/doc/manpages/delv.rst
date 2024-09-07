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

.. iscman:: delv
.. program:: delv
.. _man_delv:

delv - DNS查找和验证工具
----------------------------------------

概要
~~~~~~~~

:program:`delv` [@server] [ [**-4**] | [**-6**] ] [**-a** anchor-file] [**-b** address] [**-c** class] [**-d** level] [**-i**] [**-m**] [**-p** port#] [**-q** name] [**-t** type] [**-x** addr] [name] [type] [class] [queryopt...]

:program:`delv` [**-h**]

:program:`delv` [**-v**]

:program:`delv` [queryopt...] [query...]

描述
~~~~~~~~~~~

:program:`delv` 是一个发送DNS请求并验证结果的工具，它使用与 :iscman:`named` 同样
的内部解析器和验证器逻辑。

:program:`delv` 将所有需要获取的请求发向一个指定的名字服务器并验证请求到的
数据；这包含原始请求，跟随CNAME或DNAME链的后续请求，为建立一个
用于DNSSEC验证的信任链的对 DNSKEY 和 DS记录的请求。它不执行迭代解析，
但是模仿一个配置为DNSSEC验证和转发的名字服务器的行为。

缺省时，响应使用内置的根区（"."）DNSSEC信任锚点进行验证。 :program:`delv`
返回的记录要么是完全验证的，要么是没有签名的。如果验证失败，输出中
会包含一个对失败的解释；验证过程可被详细跟踪。由于 :program:`delv` 不依赖
一个外部服务器来执行验证，它可以用于本地名字服务器不可信的环境中来
检查DNS响应的有效性。

除非其被告知去请求一个特定的名字服务器， :program:`delv` 试探
``/etc/resolv.conf`` 中列出的每个服务器。如果没有发现可用的服务器地
址， :program:`delv` 发请求到环回地址（IPv4为127.0.0.1，IPv6为::1）。

当没有给出命令行参数或选项时， :program:`delv` 执行对"."（根区）的NS查询。

简单用法
~~~~~~~~~~~~

一个典型的 :program:`delv` 调用看起来像：

::

    delv @server name type

其中:

.. option:: server

   是要请求的名字服务器的名字或IP地址。这可以是一个点分十进制表示的
   IPv4地址或一个冒号分隔表示的IPv6地址。当所提供的 ``server`` 参数
   是一个主机名时， :program:`delv` 在请求那个名字服务器之前先解析那个名字
   （注意，那个初始查询 **不** 被DNSSEC验证）。

   如果没有提供 ``server`` 参数， :program:`delv` 会查找 ``/etc/resolv.conf`` ；
   如果在其中发现一个地址，它会请求那个地址上的名字服务器。如果使用
   了 :option:`-4` 或 :option:`-6` 选项，则只有相关传输协议的地址才会被试探。如
   果没有发现可用的地址， :program:`delv` 就向本地地址（对IPv4为127.0.0.1，
   对IPv6为::1）发送请求。

.. option:: name

   是被查找的域名。

.. option:: type

   指明需要请求那种类型 - ANY，A，MX，等。 ``type`` 可以是任何
   有效的请求类型。如果没有提供 ``type`` 参数， :program:`delv` 执行一个
   对A记录的查找。

选项
~~~~~~~

.. option:: -a anchor-file

   本选项指定从中读取DNSSEC信任锚点的文件。缺省为 |bind_keys| ，
   它被包含在BIND 9中，并含有一个或多个根区（"."）的信任锚点。

   与根区名字不匹配的密钥会被忽略；一个替换的密钥名可以使用
   :option:`+root` 选项指定。

   注意：在读取信任锚点文件时， :program:`delv` 同等对待 ``trust-anchors`` ，
   ``initial-key`` 和 ``static-key`` 。即，对于一个被管理的密钥，受
   信任的是 **初始的** 密钥， :rfc:`5011` 密钥管理是不支持的。 :program:`delv`
   不会询问由 :iscman:`named` 维护的被管理密钥数据库，这意谓着，如果
   |bind_keys| 中有一个密钥被撤销和轮转，必须更新
   |bind_keys| 以便在 :program:`delv` 中使用DNSSEC验证。

.. option:: -b address

   本选项设置请求的源IP地址为 ``address`` 。这必须是一个主机网络接口上
   的有效地址，或者 ``0.0.0.0`` ，或者 ``::`` 。可以通过附加
   ``#<port>`` 指定一个可选的源端口。

.. option:: -c class

   本选项为请求数据设置请求类。当前，在 :program:`delv` 中只支持类"IN"，任何其
   它值将被忽略。

.. option:: -d level

   本选项设置系统范围的调试级别为 ``level`` 。允许的范围为0到99。缺省是0
   （关闭调试）。调试级别越高，从 :program:`delv` 调试跟踪得到的信息越多。
   参见下列 :option:`+mtrace` ， :option:`+rtrace` 和 :option:`+vtrace` 选项以获得关
   于调试的详细信息。

.. option:: -h

   本选项显示 :program:`delv` 使用帮助并退出。

.. option:: -i

   本选项设置非安全模式。这个关闭内部DNSSEC验证。（注意，这不会在向上游
   查询时设置CD位。如果被查询的服务器正在执行DNSSEC验证，它将会返回无
   效数据；这导致 :program:`delv` 超时。当必须检查无效数据以调试一个
   DNSSEC问题时，使用 :option:`dig +cd` 。）

.. option:: -m

   本选项打开内存使用调试。

.. option:: -p port#

   本选项指定一个用于请求的目的端口，而不是使用标准的DNS端口号53。这个
   选项用于同一个被配置为在一个非标准端口号监听请求的名字服务器通信时。

.. option:: -q name

   本选项设置请求名为 ``name`` 。虽然指定请求名可以不需要使用 :option:`-q` ，
   但是某些时候必须使用这个选项来将请求名与类型和类区别开来（例如，
   在查找名字"ns"时，可能被错误解释为类型NS，或者查找"ch"，可能被
   错误解释为类CH）。

.. option:: -t type

   本选项设置请求类型为 ``type`` ，它可以是除区传送类型AXFR和IXFR之外
   BIND 9所支持的任何有效类型。与 :option:`-q` 一样，当query-name类型或类
   有二义性时，这有助于区分它们。在某些时候必须将名字从类型中区别
   出来。

   缺省请求类型是"A"，除非提供了 :option:`-x` 指定一个反向查找，这种情况
   类型是"PTR"。

.. option:: -v

   本选项打印 :program:`delv` 版本并退出。

.. option:: -x addr

   本选项执行一个反向查找，映射一个地址到一个名字。 ``addr`` 是一个点分
   十进制表示的IPv4地址，或者一个冒号分隔的IPv6地址。当使用了
   :option:`-x` ，不需要提供 ``name`` 或 ``type`` 参数； :program:`delv` 自动执
   行对一个类似 ``11.12.13.10.in-addr.arpa`` 的名字的查找，并设置
   请求类型为PTR。IPv6地址是以半字节格式在IP6.ARPA域下查找。

.. option:: -4

   本选项强制 :program:`delv` 使用IPv4。

.. option:: -6

   本选项强制 :program:`delv` 使用IPv6。

请求选项
~~~~~~~~~~~~~

:program:`delv` 提供一些请求选项，它们影响结果的显示方式，在某些情况它们
也影响请求执行的方式。

每个请求由一个加号（ ``+`` ）引导的关键字所标识。一些关键字设置或
清除一个选项。这些可以由前导的 ``no`` 字符串反转关键字的含义。其它
关键字给选项赋值，如超时间隔。它们具有 ``+keyword=value`` 的形式。
请求选项为：

.. option:: +cdflag, +nocdflag

   本选项控制是否在由 :program:`delv` 发出的请求中设置CD（checking disabled，
   关闭验证）位。这个可以用于从一个验证解析器后端进行DNSSEC问题排查。
   一个验证解析器将阻塞无效响应，就使获取它们进行分析变得很困难。
   在请求中设置CD标志将使解析器返回无效响应， :program:`delv` 可以在内部
   验证并详细报告错误。

.. option:: +class, +noclass

   本选项控制在打印一个记录时是否显示类。缺省是显示类。

.. option:: +ttl, +nottl

   本选项控制在打印一个记录时是否显示TTL。缺省是显示TTL。

.. option:: +rtrace, +nortrace

   本选项切换解析器取动作的日志。这报告了在执行解析和验证过程中每个由
   :program:`delv` 发送的请求的名字和类型，包含了原始请求和跟随CNAME记
   录和为DNSSEC验证建立信任链的随后请求。

   这和在"resolver"日志类别中设置调试级别为1是等效的。使用 :option:`-d`
   选项在系统范围设置调试级别为1会得到同样的输出，但是也会影响其
   它日志类别。

.. option:: +mtrace, +nomtrace

   本选项切换消息日志。这产生 :program:`delv` 在执行解析和验证过程中收到的响应
   的详细导出结果。

   这和在"resolver"日志类别的"packets"模块中设置调试级别为10是等
   效的。使用 :option:`-d` 选项在系统范围设置调试级别为10会得到同样的输
   出，但是也会影响其它日志类别。

.. option:: +vtrace, +novtrace

   本选项切换验证日志。这显示验证器的内部进程，它决定一个答复是否是有效
   签名、未签名或者无效的。

   这和在"dnssec"日志类别的"validator"模块中设置调试级别为3是等效
   的。使用 :option:`-d` 选项在系统范围设置调试级别为3会得到同样的输出，
   但是也会影响其它日志类别。

.. option:: +short, +noshort

   本选项在详细答复和简洁答复之间切换。缺省是以详细形式输出答复。

.. option:: +comments, +nocomments

   本选项切换在输出中显示注释。缺省是打印注释。

.. option:: +rrcomments, +norrcomments

   本选项切换对输出中每个记录注释的显示状态（例如，关于DNSKEY的人可读的
   密钥信息）。缺省是打印每个记录的注释。

.. option:: +crypto, +nocrypto

   本选项切换DNSSEC记录中加密字段的显示。这些字段的内容对于调试大多数
   DNSSEC验证失败不是必须的，并且去掉它们会使查看通常的失败更容易。
   缺省是显示这些字段。如果省略，它们被字符串 ``[omitted]`` 所替代，
   或者，在DNSKEY的情况下，作为替代，显示密钥的id，例如
   ``[ key id = value ]`` 。

.. option:: +trust, +notrust

   本选项控制在打印一个记录时是否显示信任级别。缺省是显示信任级别。

.. option:: +split[=W], +nosplit

   本选项分割资源记录中的长的hex-或base64-格式的字段为 ``W`` 个字符大小
   的块。（这里 ``W`` 是最接近的4的倍数）。 ``+nosplit`` 或
   ``+split=0`` 使字段完全不被分割。缺省是56个字符，或者在打开多
   行模式时为44个字符。

.. option:: +all, +noall

   本选项设置或清除显示选项 :option:`+comments` ， :option:`+rrcomments` 和
   :option:`+trust` 作为一个组。

.. option:: +multiline, +nomultiline

   本选项以冗长多行格式并附带人可读的注释打印长记录（诸如RRSIG，DNSKEY
   和SOA记录）。缺省是将每条记录打印在一行上，以便 :program:`delv` 的输
   出更容易被机器分析。

.. option:: +dnssec, +nodnssec

   本选项指示是否在 :program:`delv` 的输出中显示RRSIG记录。缺省是显示。注意（
   与 :iscman:`dig` 不同）这 *不* 控制是否请求DNSSEC记录或者验证它们。
   总是请求DNSSEC记录，并总是进行验证，除非使用 :option:`-i` 或
   :option:`+noroot` 禁止。

.. option:: +root[=ROOT], +noroot

   本选项指示是否执行传统的DNSSEC验证，如果是，指定信任锚点的名字。缺
   省是使用一个"."（根区）的信任锚点，对此有一个内置密钥。如果指
   定一个不同的信任锚点，必须使用 :option:`-a` 指定一个包含这个密钥的
   文件。

.. option:: +tcp, +notcp

   本选项控制在发送请求时是否使用TCP。缺省是使用UDP，除非收到一个被截
   断的响应。

.. option:: +unknownformat, +nounknownformat

   本选项以未知RR类型表示格式（ :rfc:`3597` ）打印所有RDATA。缺省是以
   类型的表示格式打印已知类型的RDATA。

.. option:: +yaml, +noyaml

   本选项以YAML格式打印响应数据。

文件
~~~~~

|bind_keys|

``/etc/resolv.conf``

参见
~~~~~~~~

:iscman:`dig(1) <dig>`, :iscman:`named(8) <named>`, :rfc:`4034`, :rfc:`4035`, :rfc:`4431`, :rfc:`5074`, :rfc:`5155`.
