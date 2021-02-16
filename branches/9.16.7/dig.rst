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

.. _man_dig:

dig - DNS查找工具
------------------

概要
~~~~~~~~
:program:`dig` [@server] [**-b** address] [**-c** class] [**-f** filename] [**-k** filename] [**-m**] [**-p** port#] [**-q** name] [**-t** type] [**-v**] [**-x** addr] [**-y** [hmac:]name:key] [ [**-4**] | [**-6**] ] [name] [type] [class] [queryopt...]

:program:`dig` [**-h**]

:program:`dig` [global-queryopt...] [query...]

描述
~~~~~~~~~~~

``dig`` 是一个查询DNS名字服务器的灵活工具。它执行DNS查找并显示从
所查找的名字服务器所返回的答案。由于其灵活性，容易使用和整洁的输
出，大多数DNS管理员使用 ``dig`` 来排除DNS问题。 ``dig`` 趋向于比
其它查找工具提供更多的功能。

虽然 ``dig`` 通常使用命令行参数，它也具有批处理模式的操作，从一
个文件读入查找请求。在使用 ``-h`` 选项时，会打印出其命令行参数的
一个简要总结。与早期的版本不同， ``dig`` 的BIND 9实现允许从命令
行发出多个查找。

``dig`` 将会试探 ``/etc/resolv.conf`` 中服务器列表中的每台机器，
除非让它查找一个指定的名字服务器。如果没有找到可用的服务器地址，
``dig`` 将会把请求发给本地主机。

在没有给出命令行参数或选项时， ``dig`` 将会执行一个对“.”（根）的
NS请求。

通过 ``${HOME}/.digrc`` 文件，可以为每个用户设置 ``dig`` 的缺省
参数。这个文件将被读入并在命令行参数之前应用其中的所有参数。
``-r`` 选项为那些需要可预测结果的脚本关闭这个特性。

IN和CH类名覆盖IN和CH顶级域名。使用 ``-t`` 和 ``-c`` 选项指定类型
和类，或者使用 ``-q`` 指定域名，或者在查找这些顶级域时使用“IN.”
和“CH.”。

简单用法
~~~~~~~~~~~~

一个典型的 ``dig`` 调用看起来是这样的：

::

    dig @server name type

在这里：

``server``
   是请求发往的名字服务器的名字或者IP地址。可以是点分十进制格式
   的IPv4地址或者冒号分隔形式的IPv6地址。当所提供的 ``server``
   参数是一个主机名， ``dig`` 在请求这个名字服务器之前先解析其名
   字。

   如果没有提供 ``server`` 参数， ``dig`` 查找 ``/etc/resolv.conf`` ；
   如果在其中发现一个地址，它就请求这个地址上的名字服务器。如果
   使用了 ``-4`` 或 ``-6`` 选项，就只会试探相关的传输层。如果没
   有找到可用的地址， ``dig`` 就会把请求发到本地主机。显示从名字
   服务器返回的响应信息。

``name``
   是要查找的资源记录的名字。

``type``
   指明所要的请求类型 ------ ANY，A，MX，SIG，等等。 ``type`` 可
   以是任何有效的请求类型。如果没有提供 ``type`` 参数， ``dig``
   将会执行对A记录的查找。

选项
~~~~~~~

**-4**
   仅使用IPv4。

**-6**
   仅使用IPv6。

**-b** address[#port]
   设置请求的源IP地址。 ``address`` 必须是主机的一个网络接口上的
   有效地址，或者为“0.0.0.0”，或者为“::”。可以通过附加“#<port>”
   指定一个可选的端口。

**-c** class
   设置请求类。缺省 ``class`` 是IN；其它类是HS，表示Hesiod记录，
   或CH，表示CHAOSNET记录。

**-f** file
   批处理模式： ``dig`` 从文件 ``file`` 中读入要查找请求的列表，
   并进行处理。文件中的每一行应该组织成与使用命令行提供请求给
   ``dig`` 的同样方式。

**-k** keyfile
   使用TSIG签名请求，TSIG使用一个从给定的文件中读到的一个密钥。
   密钥文件可以使用tsig-keygen8生成。在与 ``dig`` 之间使用TSIG认
   证时，被请求的名字服务器需要知道所使用的密钥和算法。在BIND中，
   通过在 ``named.conf`` 中指定合适的 ``key`` 和 ``server`` 语句
   来完成。

**-m**
   打开内存使用调试。

**-p** port
   发送请求到服务器的一个非标准端口，而不是缺省的53端口。这个选
   项可以用于测试一个名字服务器，将其配置成在一个非标准端口上监
   听请求。

**-q** name
   要查询的域名。这个用于区别 ``name`` 和其它参数。

**-r**
   不从 ``${HOME}/.digrc`` 读取选项。这对需要可预测结果的脚本非
   常有用。

**-t** type
   请求的资源记录类型。它可以是任何有效的请求类型。如果它是BIND 9
   中所支持的资源记录类型，它可以通过类型助记符（如‘NS’或‘AAAA’）
   给出。缺省请求类型为“A”，除非设定 ``-x`` 选项，它指定一个反向
   查找。可以通过指定AXFR的类型的请求进行区传送。当请求一个增量区
   传送（IXFR）时， ``type`` 被设为 ``ixfr=N`` 。增量区传送将包含
   区的变化，区的SOA记录中的序列号为 ``N`` 。

   所有的资源记录类型都可以表示为“TYPEnn”，这里“nn”是类型编号。如
   果资源类型是BIND 9中所不支持的，结果将会以 :rfc:`3597` 中描述
   的方式显示。

**-u**
   输出以微秒为单位而不是以毫秒为单位的请求时间。

**-v**
   打印出版本号并退出。

**-x** addr
   简化的反向查找，用于从地址映射到名字。 ``addr`` 是一个点分十进
   制形式的IPv4地址，或者一个以冒号分隔的IPv6地址。当使用 ``-x``
   时，不需要提供 ``name`` ， ``class`` 和 ``type`` 参数。 ``dig``
   自动执行一个类似 ``94.2.0.192.in-addr.arpa`` 的查找，并将请求
   类型和类分别设置为PTR和IN。IPv6地址使用半字节格式在IP6.ARPA域
   名下面查找。

**-y** [hmac:]keyname:secret
   使用TSIG并所给定的认证密钥签名请求。 ``keyname`` 是密钥的名字，
   ``secret`` 是base64编码的共享密码， ``hmac`` 是密钥算法的名字；
   有效的选择是 ``hmac-md5`` ， ``hmac-sha1`` ， ``hmac-sha224`` ，
   ``hmac-sha256`` ， ``hmac-sha384`` 或 ``hmac-sha512`` 。如果未
   指定 ``hmac`` ，缺省为 ``hmac-md5`` 或者如果MD5被禁止，则为
   ``hmac-sha256`` 。

.. note:: 你应该使用 ``-k`` 选项并避免 ``-y`` 选项，因为随着 ``-y``
   被提供的共享密码是以明文形式被用作一个命令行参数中。这在ps1的
   输出中，或在用户的shell中维护的一个历史文件中是可见的。

请求选项
~~~~~~~~~~~~~

``dig`` 提供许多查询选项，可以影响生成查询和显示结果的方式。其中一
些选项设置或清空请求头部的标志位，一些决定打印回答中的哪些部份，其
它的决定超时和重试策略。

每个请求选项由一个前导加号（ ``+`` ）和一个关键字标识。一些关键字
设置或清空一个选项。这些可能由前导字符串 ``no`` 来否定关键字的含义。
其它关键字给选项赋值，就像超时间隔。他们具有 ``+keyword=value`` 的
形式。关键字可以是缩写，前提是缩写是无歧义的；例如 ``+cd`` 等效于
``+cdflag`` 。请求选项是：

``+[no]aaflag``
   ``+[no]aaonly`` 的同义词。

``+[no]aaonly``
   在请求中设置“aa”标志。

``+[no]additional``
   显示[不显示]回复的附加部份。缺省是显示。

``+[no]adflag``
   设置[不设置]请求中的AD（可靠的数据）位。它要求服务器返回回答和
   权威部份的所有记录是否都已按照服务器的安全策略验证。AD=1指示所
   有记录都已被验证为安全并且回答不是来自于一个OPT-OUT范围。AD=0
   指示回答中的某些部份是不安全的或者没有验证的。这个位缺省是置位
   的。

``+[no]all``
   设置或清除所有显示标志。

``+[no]answer``
   显示[不显示]回复的回答部份。缺省是显示。

``+[no]authority``
   显示[不显示]回复的权威部份。缺省是显示。

``+[no]badcookie``
   如果收到一个BADCOOKIE响应，使用新的服务器cookie重试查找。

``+[no]besteffort``
   试图显示坏包消息的内容。缺省是不显示坏包回答。

``+bufsize=B``
   这个选项设置使用EDNS0公告的UDP消息缓冲大小为 ``B`` 字节。这个
   缓冲的最大值和最小值分别为65535和0。 ``+bufsize=0`` 关闭EDNS
   （使用 ``+bufsize=0 +edns`` 发送一个带有0字节公告大小的EDNS消
   息）。 ``+bufsize`` 恢复缺省的缓存大小。

``+[no]cdflag``
   设置[不设置]请求中的CD（关闭检查）位。这请求服务器不对响应执行
   DNSSEC验证。

``+[no]class``
   打印记录时显示[不显示]类。

``+[no]cmd``
   切换在输出中对初始注释的打印，它标识 ``dig`` 的版本和应用的请
   求选项。这个选项总是具有全局效果；它不能被全局设置并被一个基于
   每个查询所覆盖。缺省时打印这个注释。

``+[no]comments``
   切换在输出中对某些注释行的显示，包含关于包头部和OPT伪部份的信
   息，以及响应部份的名字。缺省是打印这些注释。

   输出中其它类型的注释不受这个选项的影响，但可以使用其它命令行选
   项进行控制。这些选项包括 ``+[no]cmd`` ， ``+[no]question`` ，
   ``+[no]stats`` 和 ``+[no]rrcomments`` 。

``+[no]cookie=####``
   带可选值发送一个COOKIE EDNS选项。从先前的响应重放一个COOKIE将
   允许服务器标识一个先前的客户端。缺省值是 ``+cookie`` 。

   当设置了+trace时，也设置 ``+cookie`` ，这样能更好地模拟来自一
   个名字服务器的缺省请求。

``+[no]crypto``
   切换对DNSSEC记录中加密字段的显示。这些字段在诊断大多数DNSSEC验
   证失败时不是必须的，去掉它们使得查看普通失败更容易。缺省是显示
   这些字段。当被省略时，它们被字符串"[omitted]"替代，或者在DNSKEY
   情况，显示密钥标识号作为替代，例如"[ key id = value ]"。

``+[no]defname``
   废弃，作为 ``+[no]search`` 的同义词对待。

``+[no]dnssec``
   通过在请求的附加部份放置OPT记录，并设置DNSSEC OK位（DO）来请求
   发送DNSSEC记录。

``+domain=somename``
   设置搜索列表使包含唯一域名 ``somename`` ，就像在
   ``/etc/resolv.conf`` 中 ``domain`` 命令中指定一样，如果给出
   ``+search`` 选项，就打开搜索列表处理。

``+dscp=value``
   在发送请求时，设置使用的DSCP码点。有效的DSCP码点在[0..63]的范围。
   缺省时不显式设定码点。

``+[no]edns[=#]``
   指定请求所带的EDNS的版本。有效值为0到255。设置EDNS版本会导致发
   出一个EDNS请求。 ``+noedns`` 清除所记住的EDNS版本。缺省时EDNS被
   设置为0。

``+[no]ednsflags[=#]``
   设置必须为0的EDNS标志位（Z位）为指定的值。十进制，十六进制和八
   进制都是可以的。设置一个命名标志（例如 DO）将被静默地忽略。缺省
   时，不设置Z位。

``+[no]ednsnegotiation``
   打开/关闭EDNS版本协商。缺省时EDNS版本协商为打开。

``+[no]ednsopt[=code[:value]]``
   使用码点 ``code`` 和可选荷载 ``value`` 指定EDNS选项为一个十六进
   制字符串。 ``code`` 可以为一个EDNS选项名（例如， ``NSID`` 或
   ``ECS`` ）或一个任意数字值这两者之一。 ``+noednsopt`` 清除将发
   送的EDNS选项。

``+[no]expire``
   发送一个EDNS过期选项。

``+[no]fail``
   如果收到了一个SERVFAIL不会重试下一个服务器。缺省是不重试下一个
   服务器，这与普通的存根解析器行为相反。

``+[no]header-only``
   发送一个带有DNS头部但不带问题部分的请求。缺省是要添加一个问题部
   分。当设置这个选项时，请求类型和请求名被忽略。

``+[no]identify``
   在 ``+short`` 选项打开时，显示[不显示]用于补充回答的IP地址和端
   口号。如果要求短格式回答，缺省是不显示提供回答的服务器的源地址
   和端口号。

``+[no]idnin``
   处理[不处理]输入中的IDN域名。这个要求在编译时打开IDN SUPPORT。

   当标准输出是一个tty时，缺省是要处理IDN输入。当dig输出被重定向到
   文件，管道以及其它非tty文件描述符时，对IDN处理是被禁止的。

``+[no]idnout``
   转换[不转换]输出上的puny code。这要求在编译时打开IDN支持。

   当标准输出是一个tty时，缺省是要处理输出的 puny code。当dig输出
   被重定向到文件，管道以及其它非tty文件描述符时，对输出的
   puny code处理是被禁止的。

``+[no]ignore``
   忽略UDP响应中的截断而不用TCP重试。缺省情况要用TCP重试。

``+[no]keepalive``
   发送[或不发送]一个EDNS保活选项。

``+[no]keepopen``
   在两次或多次请求之间保持TCP套接字打开，这样可以重用而不是每次查
   找时都建立一个新的TCP套接字。缺省是 ``+nokeepopen`` 。

``+[no]mapped``
   允许使用映射IPv4到IPv6地址。缺省是 ``+mapped`` 。

``+[no]multiline``
   以详细的多行格式并附带人所易读的注释打印如SOA这样的记录。缺省是
   将每个记录打印在一行中，以适应机器分析 ``dig`` 的输出。

``+ndots=D``
   设置在 ``name`` 中必须出现的点的数目为 ``D`` 以使其被当成绝对名
   字。缺省值是在 ``/etc/resolv.conf`` 中用ndots语句定义的值，或者
   为1，如果没有使用ndots语句。少于这个数目的点的名字会被解释为相
   对名字，如果设置了 ``+search`` ，就会在 ``/etc/resolv.conf`` 中
   的 ``search`` 或 ``domain`` 指令所列的域名中搜索。

``+[no]nsid``
   在发送一个请求时包含一个EDNS名字服务器ID请求。

``+[no]nssearch``
   在设置了这个选项时， ``dig`` 试图找到包含所查找名字的区的权威名
   字服务器并显示这个区的每个名字服务器都有的SOA记录。没有响应的服
   务器的地址也会被打印。

``+[no]onesoa``
   在执行一个AXFR时，仅打印一个（开始的）SOA记录。缺省是打印开始的
   和结尾的SOA记录。

``+[no]opcode=value``
   设置[恢复]DNS消息操作码为指定值。缺省值是QUERY（0）。

``+padding=value``
   使用EDNS填充选项将请求包填充到 ``value`` 字节对齐的块。例如，
   ``+padding=32`` 将使一个48字节的请求被填充到64字节。缺省的块大
   小为0，即关闭填充。最大是512。填充值一般是2的幂，例如128；然而，
   这不是硬性规定。对填充请求的响应也会被填充，但仅当请求使用TCP或
   者DNS COOKIE时。

``+[no]qr``
   切换对所发出的请求消息的显示。缺省情况，不打印请求。

``+[no]question``
   切换当一个回答返回时对一个请求的问题部份的显示。缺省是将问题部
   份作为一个注释打印。

``+[no]raflag``
   设置[不设置]请求中的RA（Recursion Available，递归可用）位。缺省
   是+noraflag。对于请求，这个位应当被服务器忽略。

``+[no]rdflag``
   一个 ``+[no]recurse`` 的同义词。

``+[no]recurse``
   切换请求中的RD（期望递归）位设置。这个位缺省是置位的，意谓着
   ``dig`` 普通情况是发送递归的请求。在使用了 ``+nssearch`` 或
   ``+trace`` 选项时，递归是自动关闭的。

``+retry=T``
   设置向服务器重新进行UDP请求的次数为 ``T`` 次，取代缺省的2次。与
   ``+tries`` 不同，这个不包括初始请求。

``+[no]rrcomments``
   切换在输出中显示每记录注释的状态（例如，便于人阅读的关于DNSKEY
   记录的密钥信息）。缺省是不打印记录注释，除非多行模式被激活。

``+[no]search``
   使用[不使用]在 ``resolv.conf`` （如果存在）中由searchlist或者
   domain命令所定义的搜索列表。缺省是不使用搜索列表。

   ``resolv.conf`` 中的 ‘ndots’ （缺省为1），可以被 ``+ndots`` 覆
   盖，决定名字是否被当成绝对名字以及是否最终执行一个查找。

``+[no]short``
   提供一个简洁的回答。缺省是以明细形式打印回答。这个选项总是具有
   全局效果；它不能被全局设置并被一个基于每个查询所覆盖。

``+[no]showsearch``
   执行[不执行]立即显示结果的搜索。

``+[no]sigchase``
   这个特性现在被废弃并被去掉了；使用 ``delv`` 替代。

``+split=W``
   将资源记录中较长的hex-或base64-格式的字段分割为 ``W`` 个字符的
   块（ ``W`` 被向上取整到距其最近的4的倍数上）。 ``+nosplit`` 或
   ``+split=0`` 导致字段完全不被分割。缺省为56个字符，或者在多行
   模式时为44个字符。

``+[no]stats``
   切换对统计的打印：请求完成的时间，响应的大小等等。缺省行为是在
   每次查询之后以一个注释打印请求统计。

``+[no]subnet=addr[/prefix-length]``
   发送（不发送）一个EDNS客户端子网选项，带有指定的IP地址或网络前
   缀。

   ``dig +subnet=0.0.0.0/0`` ，或简写为 ``dig +subnet=0`` ，发送
   一个EDNS client-subnet选项，附带一个空地址和一个为0的源前缀，
   它发信号给一个解析器，在解析这个请求时，必须不能使用客户端的地
   址信息。

``+[no]tcflag``
   在请求中设置[不设置]TC（TrunCation，截断）位。缺省是+notcflag。
   对于请求，这个位应当被服务器忽略。

``+[no]tcp``
   在请求名字服务器时使用[不使用]TCP。缺省行为是使用UDP，除非一个
   类型 ``any`` 或者 ``ixfr=N`` 的查询被请求，这种情况下缺省是TCP。
   AXFR请求总是使用TCP。

``+timeout=T``
   设置一个请求的超时为 ``T`` 秒。缺省超时是5秒。试图将 ``T`` 设
   置成小于1将会得到请求超时为1秒的结果。

``+[no]topdown``
   这个特性与 ``dig +sigchase`` 相关，后者已过时并被去掉了。使用
   ``delv`` 替代。

``+[no]trace``
   切换对从根名字服务器到要查找名字的授权路径的跟踪状态。缺省是关
   闭跟踪的。当打开跟踪时， ``dig`` 迭代发送请求来解析要查找的名
   字。它会跟随自根服务器起所给出的参考信息，显示出来自每个解析用
   到的服务器的回答。

   如果指定了@server，它仅影响根区名字服务区的初始请求。

   当设置了+trace时，也会设置 ``+dnssec`` ，来更好地模仿来自某个
   名字服务器的缺省请求。

``+tries=T``
   设置向服务器进行UDP请求的重试次数为 ``T`` 次，取代缺省的3次。
   如果 ``T`` 小于或等于0，重试次数就静默地回归为1。

``+trusted-key=####``
   和 ``dig +sigchase`` 一起使用的之前指定的受信任密钥。这个特性
   现在已过时并被去掉了；使用 ``delv`` 替代。

``+[no]ttlid``
   在打印记录时显示[不显示]TTL。

``+[no]ttlunits``
   显示[不显示]TTL，以友好地人可读时间单位“s”，“m”，“h”，“d”和“w”，
   分别代表秒，分，小时，天和周。隐含为+ttlid。

``+[no]unexpected``
   接受[不接受]来自意外源地址的回答。缺省时， ``dig`` 将不会接受
   一个源地址不是其所请求的地址发来的响应。

``+[no]unknownformat``
   以未知RR类型表示格式（ :rfc:`3597` ）打印所有RDATA。缺省是以
   类型的表示格式打印已知类型的RDATA。

``+[no]vc``
   在请求名字服务器时使用[不使用]TCP。这是为 ``+[no]tcp`` 提供向
   后兼容性而使用的替换语法。“vc”表示“virtual circuit”。

``+[no]yaml``
   以一个详细的YAML格式打印响应（并且，如果使用了<option>+qr</option>，
   也包括发出的请求）。

``+[no]zflag``
   设置[不设置]一个DNS请求中最后未赋值的DNS头部标志。这个标志缺
   省是关闭。

多个请求
~~~~~~~~~~~~~~~~

BIND 9的 ``dig`` 实现支持在命令行（另外还支持 ``-f`` 批文件选项
）指定多个请求。每个这样的请求可以带有自己的标志、选项和请求选项
集合。

在这种情况下，每个 ``query`` 参数代表一个上述命令行语法中的单独
请求。每个都是由标准选项和标志，待查找名字，可选的请求类型和类以
及任何应该应用于这个请求的请求选项所组成。

也可以采用一个请求选项的全局集，它将应用到所有请求上。这些全局请
求选项必须在命令行中先于第一个名字、类、类型、选项、标志和请求选
项的元组之前。任何全局请求选项（ ``+[no]cmd`` 和 ``+[no]short``
选项除外）都可以被某个请求专用的请求选项所覆盖。例如：

::

   dig +qr www.isc.org any -x 127.0.0.1 isc.org ns +noqr

显示怎样在命令行使用 ``dig`` 完成三个查找：一个对 ``www.isc.org``
的ANY的查找，一个对127.0.0.1的反向查找和一个对 ``isc.org`` 的NS
记录的查找。应用了一个全局请求选项 ``+qr`` ，这样 ``dig`` 显示它
所进行的每个查找的初始请求。最终的请求有一个局部请求选项
``+noqr`` ，表示 ``dig`` 不会打印它在查找 ``isc.org`` 的NS记录时
的初始请求。

IDN支持
~~~~~~~~~~~

如果编译 ``dig`` 时带有IDN（internationalized domain name，国际
化域名）支持，它可以接受和显示非ASCII域名。 ``dig`` 会在发送一
个请求到DNS服务器或显示一个来自服务器的回复之前正确地转换域名的
字符编码。如果由于某种原因你想关闭IDN支持，使用参数 ``+noidnin``
和 ``+noidnout`` ，或者定义IDN_DISABLE环境变量。

文件
~~~~~

``/etc/resolv.conf``

``${HOME}/.digrc``

参见
~~~~~~~~

:manpage:`delv(1)`, :manpage:`host(1)`, :manpage:`named(8)`, :manpage:`dnssec-keygen(8)`, :rfc:`1035`.

缺陷
~~~~

具有可能是太多的请求选项。
