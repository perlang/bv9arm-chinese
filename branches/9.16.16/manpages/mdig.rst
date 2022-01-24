.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
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

.. _man_mdig:

mdig - DNS流水线查找工具
-----------------------------------

概要
~~~~~~~~

:program:`mdig` {@server} [**-f** filename] [**-h**] [**-v**] [ [**-4**] | [**-6**] ] [**-m**] [**-b** address] [**-p** port#] [**-c** class] [**-t** type] [**-i**] [**-x** addr] [plusopt...]

:program:`mdig` {**-h**}

:program:`mdig` [@server] {global-opt...} { {local-opt...} {query} ...}

描述
~~~~~~~~~~~

``mdig`` 是一个多个/流水线式的 ``dig`` 查询版本：作为在发出每个请求
之后等待一个响应的替代，它一开始就发出所有请求。响应是以收到的顺序
被显示，而不是请求发出的顺序。

``mdig`` 的选项是 ``dig`` 的选项的一个子集，被分成“任意位置选项”，
可以用于任意位置，“全局选项”，必须放在请求名之前（否则它们将被忽略
并带有一条警告），和“本地选项”，应用在命令行的下一个请求。

@server选项是一个强制的全局选项。它是要请求的名字服务器的名字或IP
地址。（与 ``dig`` 不同，这个值不是取自 ``/etc/resolv.conf`` 。）
它可以是一个点分十进制格式的IPv4地址，也可以是一个冒号分隔格式的
IPv6地址，或者是一个主机名。当所提供的 ``server`` 参数是一个主机
名时， ``mdig`` 在请求这个名字服务器之前先解析这个名字。

``mdig`` 提供了一些请求选项，它们影响了查询和显示结果的方式。其中
一些设置或重置请求头部中的标志位，一些决定输出响应的哪些部份，其
它的决定超时和重试策略。

每个请求选项由一个带一个前导加号（ ``+`` ）的关键字来标识。某些关
键字设置或者重置一个选项。这些可以由字符串 ``no`` 来否定关键字的
含义。其它关键字给选项赋值，例如超时间隔。他们具有如 ``+keyword=value``
的形式。

任意位置选项
~~~~~~~~~~~~~~~~

``-f``
   本选项使 ``mdig`` 运行在批处理模式，通过从文件 ``filename`` 读入一个
   要查找的请求的列表进行处理。这个文件包含一些请求，每行一个。文件中的
   每个条目应当以它们被作为请求提交给 ``mdig`` 使用命令行接口同样的方式
   组织。

``-h``
   本选项使 ``mdig`` 打印出详细的帮助信息，包括全部选项的清单，并退出。

``-v``
   本选项使 ``mdig`` 打印出版本号并退出。

全局选项
~~~~~~~~~~~~~~

``-4``
   本选项强制 ``mdig`` 仅使用IPv4请求传输。

``-6``
   本选项强制 ``mdig`` 仅使用IPv6请求传输。

``-b``
   本选项设置请求的源IP地址为 ``address`` 。这必须是主机的一个网络接口
   上的一个有效地址，或者“0.0.0.0”，或者“::”。可以在其后添加“#<port>”指
   定一个可选的端口。

``-m``
   本选项开启内存使用调试。

``-p``
   本选项用于请求一个非标准端口。 ``port#`` 是 ``mdig`` 以其作为替代标
   准的DNS端口53发送请求的端口号。这个选项是用于测试一个配置成在一个非
   标准端口监听请求的名字服务器。

全局请求选项是：

``+[no]additional``
   本选项显示[或不显示]回复的附加部份。缺省是显示。

``+[no]all``
   本选项设置或清除所有显示标志。

``+[no]answer``
   本选项显示[或不显示]回复的回答部份。缺省是显示。

``+[no]authority``
   本选项显示[或不显示]回复的权威部份。缺省是显示。

``+[no]besteffort``
   本选项试图显示[或不显示]坏包消息的内容。缺省是不显示坏包回答。

``+burst``
   本选项将请求延迟到下一秒开始时。

``+[no]cl``
   本选项在打印记录时显示[或不显示]类（CLASS）。

``+[no]comments``
   本选项切换在输出中显示注释行的状态。缺省是打印注释。

``+[no]continue``
   本选项切换错误时是否继续（如，超时）。

``+[no]crypto``
   本选项切换DNSSEC记录中加密字段的显示。在调试大多数DNSSEC验证失败时这
   些字段的内容不是必须的，删除它们更容易查看通常的失败。缺省是显
   示这些字段。当省略时，它们被字符串“[omitted]”替代，在DNSKEY
   的情况下，显示密钥id作为替代，例如， ``[ key id = value ]`` 。

``+dscp[=value]``
   本选项设置发送请求时用到的DSCP码点。有效的DSCP码点范围是[0...63]。
   缺省没有显式设置码点。

``+[no]multiline``
   本选项切换以详细的多行格式并附带人所易读的注释打印如SOA这样的记录。
   缺省是将每个记录打印在一行中，以适应机器分析 ``mdig`` 的输出。

``+[no]question``
   当一个回答返回时，本选项打印[或不打印]请求的问题部份。缺省是将问题部
   份作为一个注释打印。

``+[no]rrcomments``
   本选项切换在输出中显示每记录注释的状态（例如，便于人阅读的关于DNSKEY
   记录的密钥信息）。缺省是不打印记录注释，除非多行模式被激活。

``+[no]short``
   本选项提供[或不提供]一个简洁的回答。缺省是以冗长形式打印回答。

``+split=W``
   本选项将资源记录中较长的hex-或base64-格式的字段分割为 ``W`` 个字符的
   块（ ``W`` 被向上取整到距其最近的4的倍数上）。 ``+nosplit`` 或
   ``+split=0`` 导致字段不被分割。缺省为56个字符，或者在多行
   模式时为44个字符。

``+[no]tcp``
   本选项在请求名字服务器时使用[或不使用]TCP。缺省行为是使用UDP。

``+[no]ttlid``
   本选项输出记录时显示[或不显示]TTL。

``+[no]ttlunits``
   本选项显示[或不显示]TTL单位，即友好的、人可读时间单位“s”，“m”，“h”，
   “d”和“w”，分别代表秒，分，小时，天和周。隐含带+ttlid。

``+[no]vc``
   本选项在请求名字服务器时使用[或不使用]TCP。这是为 ``+[no]tcp`` 提供
   向后兼容性而使用的替换语法。 ``vc`` 表示“virtual circuit”。

本地选项
~~~~~~~~~~~~~

``-c``
   本选项设置请求类为 ``class`` 。它可以是BIND 9所支持的任何有效请求
   类。缺省请求类是“IN”。

``-t``
   本选项设置请求类型为 ``type`` 。它可以是BIND 9支持的任何有效请求类
   型。缺省请求类型是“A”，除非提供了 ``-x`` 选项，指定带有“PTR”请求类
   型的一个反向查找。

``-x addr``
   反向查找 - 将地址映射到名字 - 是由本选项简化。 ``addr`` 是一个点分
   十进制形式的IPv4地址，或者是一个冒号分隔的IPv6地址。 ``mdig`` 自动
   执行一个请求名类似 ``11.12.13.10.in-addr.arpa`` 的查找，并将请求类
   型和类分别设置为PTR和IN。缺省时，IPv6地址使用IP6.ARPA域下的半字节格
   式查找。

本地请求选项是：

``+[no]aaflag``
   这是 ``+[no]aaonly`` 的同义词。

``+[no]aaonly``
   这在请求中设置 ``aa`` 标志。

``+[no]adflag``
   这设置[或不设置]请求中的AD（可靠的数据）位。它要求服务器返回在回答和
   权威部份的所有记录是否都已按照服务器的安全策略验证。AD=1指示所
   有记录都已被验证为安全并且回答不是来自于一个OPT-OUT范围。AD=0
   指示回答中的某些部份是不安全的或者没有验证的。这个位缺省是置位
   的。

``+bufsize=B``
   这设置使用EDNS0公告的UDP消息缓冲大小为 ``B`` 字节。这个缓冲的最
   大值和最小值分别为65535和0。在这个范围之外的值会被适当地调整到
   高或低。0之外的值会发送出一个EDNS请求。

``+[no]cdflag``
   这设置[或不设置]请求中的CD（关闭检查）位。这要求服务器不对响应执行
   DNSSEC验证。

``+[no]cookie=####``
   这发送[或不发送]一个COOKIE EDNS选项，并带有选项值。从先前的响应重放
   一个COOKIE将
   允许服务器标识一个先前的客户端。缺省值是 ``+nocookie`` 。

``+[no]dnssec``
   它请求发送DNSSEC记录，通过在请求的附加部份中的OPT记录中设置DNSSEC OK
   （DO）位。

``+[no]edns[=#]``
   这指定[或不指定]请求所带的EDNS的版本。有效值为0到255。设置EDNS版本
   导致发出一个EDNS请求。 ``+noedns`` 清除所记住的EDNS版本。缺省时EDNS
   被设置为0。

``+[no]ednsflags[=#]``
   这设置必须为0的EDNS标志位（Z位）为指定的值。十进制，十六进制和八
   进制都是可以的。设置一个命名标志（例如 DO）将被静默地忽略。缺
   省时，不设置Z位。

``+[no]ednsopt[=code[:value]]``
   这指定[或不指定]一个EDNS选项，使用码点 ``code`` 和一个十六进制字符串
   的选项荷载 ``value`` 。 ``+noednsopt`` 清除将发送的EDNS选项。

``+[no]expire``
   这切换是否发送一个EDNS过期选项。

``+[no]nsid``
   在发送一个请求时，这切换是否包含一个EDNS名字服务器ID请求。

``+[no]recurse``
   这切换请求中的RD（期望递归）位设置。这个位缺省是置位的，意谓着
   ``mdig`` 普通情况是发送递归的请求。

``+retry=T``
   这设置向服务器重新进行UDP请求的次数为 ``T`` 次，取代缺省的2次。
   与 ``+tries`` 不同，这个不包括初始请求。

``+[no]subnet=addr[/prefix-length]``
   这发送[或不发送]一个EDNS客户端子网选项，带有指定的IP地址或网络前
   缀。

``mdig +subnet=0.0.0.0/0`` ，或简写为 ``mdig +subnet=0``
   这发送一个EDNS client-subnet选项，使用一个空地址和一个为0的源前缀，
   它发信号给一个解析器，在解析这个请求时，必须 **不能** 使用客户端
   的地址信息。

``+timeout=T``
   这设置一个请求的超时为 ``T`` 秒。UDP传输的缺省超时是5秒，TCP是10
   秒。试图将 ``T`` 设置成小于1会得到请求超时为1秒的结果。

``+tries=T``
   这设置向服务器进行UDP请求的重试次数为 ``T`` 次，取代缺省的3次。
   如果 ``T`` 小于或等于0，重试次数就静默地向上取整为1。

``+udptimeout=T``
   这设置在UDP请求重试之间的超时。

``+[no]unknownformat``
   这以未知RR类型表示格式（ :rfc:`3597` ）打印[或不打印]所有RDATA。缺
   省是以类型的表示格式打印已知类型的RDATA。

``+[no]yaml``
   这切换是否以详细的YAML格式打印响应。

``+[no]zflag``
   设置[或不设置]一个DNS请求中最后未赋值的DNS头部标志。这个标志缺省
   是关闭。

参见
~~~~~~~~

:manpage:`dig(1)`, :rfc:`1035`.
