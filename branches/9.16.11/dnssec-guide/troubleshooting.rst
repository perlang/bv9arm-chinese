.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

.. _dnssec_troubleshooting:

基本的DNSSEC排错
----------------

在本章中，我们将介绍一些基本的排障技术，一些常见的DNSSEC症状，以及它们
的原因和解决方案。这不是一个全面的“如何排除任何DNS或DNSSEC问题”指南，因
为它本身很容易成为一本书。

.. _troubleshooting_query_path:

查询路径
~~~~~~~~~~

排除DNS或DNSSEC故障的第一步应该是确定查询路径。无论何时处理与dns相关的
问题，确定准确的查询路径以确定问题的根源总是一个好主意。

终端客户端(如笔记本电脑或移动电话)被配置为与递归名字服务器通信，而递归
名字服务器在到达权威名字服务器之前，可能转而将请求转发给其它递归名字服
务器。附属品是在查询响应中出现了权威答案(``aa``)标志：当出现这个标志时，
我们知道我们正在与权威服务器通信；当没有这个标志时，我们正在与递归服务
器通信。下面的例子显示了一个对 ``www.example.com`` 查询的答案不带权威答
案标志：

::

   $ dig @10.53.0.3 www.example.com A

   ; <<>> DiG 9.16.0 <<>> @10.53.0.3 www.example.com a
   ; (1 server found)
   ;; global options: +cmd
   ;; Got answer:
   ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 62714
   ;; flags: qr rd ra ad; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

   ;; OPT PSEUDOSECTION:
   ; EDNS: version: 0, flags:; udp: 4096
   ; COOKIE: c823fe302625db5b010000005e722b504d81bb01c2227259 (good)
   ;; QUESTION SECTION:
   ;www.example.com.       IN  A

   ;; ANSWER SECTION:
   www.example.com.    60  IN  A   10.1.0.1

   ;; Query time: 3 msec
   ;; SERVER: 10.53.0.3#53(10.53.0.3)
   ;; WHEN: Wed Mar 18 14:08:16 GMT 2020
   ;; MSG SIZE  rcvd: 88

我们不仅没有看到 ``aa`` 标志，还看到 ``ra`` 标志，表明递归可用。这表明
我们正在与之通信的服务器(在本例中为10.53.0.3)是一个递归名字服务器：尽管
我们能够获得 ``www.example.com`` 的答案，但我们知道答案来自其它地方。

如果我们直接查询权威服务器，我们得到：

::

   $ dig @10.53.0.2 www.example.com A

   ; <<>> DiG 9.16.0 <<>> @10.53.0.2 www.example.com a
   ; (1 server found)
   ;; global options: +cmd
   ;; Got answer:
   ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 39542
   ;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
   ;; WARNING: recursion requested but not available
   ...

``aa`` 标志告诉我们，我们现在正在与 ``www.example.com`` 的权威名字服务
器进行对话，并且这不是它从其它名字服务器获取的缓存答案；它从自己的数据
库向我们提供了这个答案。事实上，没有递归可用(``ra``)标志，这意味着这个
名字服务器没有被配置为执行递归(至少对这个客户机没有)，所以它不可能查询
另一个名字服务器以获得缓存结果。

.. _troubleshooting_visible_symptoms:

可见的DNSSEC验证症状
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

确定查询路径后，需要确定问题是否实际与DNSSEC验证有关。你可以在 ``dig``
中使用 ``+cd`` 标志来禁用验证，如
:ref:`how_do_i_know_validation_problem` 中所述。

当确实存在DNSSEC验证问题时，不幸的是，可见的症状非常有限。启用了DNSSEC
验证后，如果没有完全验证DNS响应，就会产生一个通用的SERVFAIL消息，如下所
示的查询位于192.168.1.7的递归名字服务器：

::

   $ dig @10.53.0.3 www.example.org. A

   ; <<>> DiG 9.16.0 <<>> @10.53.0.3 www.example.org A
   ; (1 server found)
   ;; global options: +cmd
   ;; Got answer:
   ;; ->>HEADER<<- opcode: QUERY, status: SERVFAIL, id: 28947
   ;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1

   ;; OPT PSEUDOSECTION:
   ; EDNS: version: 0, flags:; udp: 4096
   ; COOKIE: d1301968aca086ad010000005e723a7113603c01916d136b (good)
   ;; QUESTION SECTION:
   ;www.example.org.       IN  A

   ;; Query time: 3 msec
   ;; SERVER: 10.53.0.3#53(10.53.0.3)
   ;; WHEN: Wed Mar 18 15:12:49 GMT 2020
   ;; MSG SIZE  rcvd: 72

使用 ``delv`` ，将输出一条“解析失败”消息：

::

   $ delv @10.53.0.3 www.example.org. A +rtrace
   ;; fetch: www.example.org/A
   ;; resolution failed: SERVFAIL
   
在试图识别DNSSEC错误时，BIND 9的日志特性可能是有用的。

.. _troubleshooting_logging:

基本的日志
~~~~~~~~~~~~~

DNSSEC验证错误消息缺省是作为一个查询错误显示在 ``syslog`` 中。下面是一
个可能的例子：

::

   validating www.example.org/A: no valid signature found
   RRSIG failed to verify resolving 'www.example.org/A/IN': 10.53.0.2#53

通常，这种级别的错误日志记录就足够了。在
:ref:`troubleshooting_logging_debug` 中描述的调试日志提供了如何获得更多
关于为什么DNSSEC验证可能失败的细节信息。

.. _troubleshooting_logging_debug:

BIND DNSSEC调试日志
~~~~~~~~~~~~~~~~~~~~~~~~~

警告：在启用调试日志之前，请注意这可能会极大地增加名称服务器的负载。因
此，不建议在生产服务器上启用调试日志。

虽然如此，有时需要临时开启BIND调试日志，以查看DNSSEC如何验证以及是否验
证的更多细节。DNSSEC相关的消息缺省不记录在 ``syslog`` 中，即使启用了查
询日志；只有DNSSEC错误显示在 ``syslog`` 中。

下面的示例展示了如何在BIND 9中启用调试级别3(查看完整的DNSSEC验证消息)，
并将其发送到 ``syslog`` ：

::

   logging {
      channel dnssec_log {
           syslog daemon;
           severity debug 3;
           print-category yes;
       };
       category dnssec { dnssec_log; };
   };

下面这个例子展示了如何将DNSSEC消息记录到自己的文件中（这里是
``/var/log/dnssec.log`` ）：

::

   logging {
       channel dnssec_log {
           file "/var/log/dnssec.log";
           severity debug 3;
       };
       category dnssec { dnssec_log; };
   };

打开调试日志并重新启动BIND后，大量的日志消息出现在 ``syslog`` 中。下面
的例子显示了成功查找和验证域名 ``ftp.isc.org`` 后的日志消息。

::

   validating ./NS: starting
   validating ./NS: attempting positive response validation
     validating ./DNSKEY: starting
     validating ./DNSKEY: attempting positive response validation
     validating ./DNSKEY: verify rdataset (keyid=20326): success
     validating ./DNSKEY: marking as secure (DS)
   validating ./NS: in validator_callback_dnskey
   validating ./NS: keyset with trust secure
   validating ./NS: resuming validate
   validating ./NS: verify rdataset (keyid=33853): success
   validating ./NS: marking as secure, noqname proof not needed
   validating ftp.isc.org/A: starting
   validating ftp.isc.org/A: attempting positive response validation
   validating isc.org/DNSKEY: starting
   validating isc.org/DNSKEY: attempting positive response validation
     validating isc.org/DS: starting
     validating isc.org/DS: attempting positive response validation
   validating org/DNSKEY: starting
   validating org/DNSKEY: attempting positive response validation
     validating org/DS: starting
     validating org/DS: attempting positive response validation
     validating org/DS: keyset with trust secure
     validating org/DS: verify rdataset (keyid=33853): success
     validating org/DS: marking as secure, noqname proof not needed
   validating org/DNSKEY: in validator_callback_ds
   validating org/DNSKEY: dsset with trust secure
   validating org/DNSKEY: verify rdataset (keyid=9795): success
   validating org/DNSKEY: marking as secure (DS)
     validating isc.org/DS: in fetch_callback_dnskey
     validating isc.org/DS: keyset with trust secure
     validating isc.org/DS: resuming validate
     validating isc.org/DS: verify rdataset (keyid=33209): success
     validating isc.org/DS: marking as secure, noqname proof not needed
   validating isc.org/DNSKEY: in validator_callback_ds
   validating isc.org/DNSKEY: dsset with trust secure
   validating isc.org/DNSKEY: verify rdataset (keyid=7250): success
   validating isc.org/DNSKEY: marking as secure (DS)
   validating ftp.isc.org/A: in fetch_callback_dnskey
   validating ftp.isc.org/A: keyset with trust secure
   validating ftp.isc.org/A: resuming validate
   validating ftp.isc.org/A: verify rdataset (keyid=27566): success
   validating ftp.isc.org/A: marking as secure, noqname proof not needed

请注意，这些日志消息表明信任链已经建立，并且 ``ftp.isc.org`` 已经成功验
证。

如果验证失败，您将看到指示错误的日志消息。我们将在下一节中讨论一些最重
要的验证问题。

.. _troubleshooting_common_problems:

普通问题
~~~~~~~~~~~~~~~

.. _troubleshooting_security_lameness:

安全性残缺
^^^^^^^^^^^^^^^^^

与传统DNS中的残缺授权类似，安全残缺是指父区持有一组DS记录，它们指向子区
中不存在的东西。结果，整个子区域可能“消失”，因为验证解析器将其标记为伪
区。

下面是一个尝试解析测试域名 ``www.example.net`` 的A记录的示例。从用户的
角度来看，如在 :ref:`how_do_i_know_validation_problem` 中所述，只返回一
个SERVFAIL消息。在验证解析器上，我们在 ``syslog`` 中看到以下消息：

::

   named[126063]: validating example.net/DNSKEY: no valid signature found (DS)
   named[126063]: no valid RRSIG resolving 'example.net/DNSKEY/IN': 10.53.0.2#53
   named[126063]: broken trust chain resolving 'www.example.net/A/IN': 10.53.0.2#53

这给了我们一个提示，这是一个破裂的信任链问题。让我们看一下为该区发布的
DS记录(为了便于显示，将密钥缩短)：

::

   $ dig @10.53.0.3 example.net. DS

   ; <<>> DiG 9.16.0 <<>> @10.53.0.3 example.net DS
   ; (1 server found)
   ;; global options: +cmd
   ;; Got answer:
   ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 59602
   ;; flags: qr rd ra ad; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

   ;; OPT PSEUDOSECTION:
   ; EDNS: version: 0, flags:; udp: 4096
   ; COOKIE: 7026d8f7c6e77e2a010000005e735d7c9d038d061b2d24da (good)
   ;; QUESTION SECTION:
   ;example.net.           IN  DS

   ;; ANSWER SECTION:
   example.net.        256 IN  DS  14956 8 2 9F3CACD...D3E3A396

   ;; Query time: 0 msec
   ;; SERVER: 10.53.0.3#53(10.53.0.3)
   ;; WHEN: Thu Mar 19 11:54:36 GMT 2020
   ;; MSG SIZE  rcvd: 116

接下来，我们查询 ``example.net`` 的DNSKEY和RRSIG，看看是否有什么错误。
由于在验证时遇到了问题，我们可以使用 ``+cd`` 选项暂时禁用检查并返回结果，
即使这些结果没有通过验证测试。 ``+multiline`` 选项告诉 ``dig`` 打印
DNSKEY记录的类型、算法类型和密钥id。同样，一些长字符串被缩短以方便显示：

::

   $ dig @10.53.0.3 example.net. DNSKEY +dnssec +cd +multiline

   ; <<>> DiG 9.16.0 <<>> @10.53.0.3 example.net DNSKEY +cd +multiline +dnssec
   ; (1 server found)
   ;; global options: +cmd
   ;; Got answer:
   ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 42980
   ;; flags: qr rd ra cd; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 1

   ;; OPT PSEUDOSECTION:
   ; EDNS: version: 0, flags: do; udp: 4096
   ; COOKIE: 4b5e7c88b3680c35010000005e73722057551f9f8be1990e (good)
   ;; QUESTION SECTION:
   ;example.net.       IN DNSKEY

   ;; ANSWER SECTION:
   example.net.        287 IN DNSKEY 256 3 8 (
                   AwEAAbu3NX...ADU/D7xjFFDu+8WRIn
                   ) ; ZSK; alg = RSASHA256 ; key id = 35328
   example.net.        287 IN DNSKEY 257 3 8 (
                   AwEAAbKtU1...PPP4aQZTybk75ZW+uL
                   6OJMAF63NO0s1nAZM2EWAVasbnn/X+J4N2rLuhk=
                   ) ; KSK; alg = RSASHA256 ; key id = 27247
   example.net.        287 IN RRSIG DNSKEY 8 2 300 (
                   20811123173143 20180101000000 27247 example.net.
                   Fz1sjClIoF...YEjzpAWuAj9peQ== )
   example.net.        287 IN RRSIG DNSKEY 8 2 300 (
                   20811123173143 20180101000000 35328 example.net.
                   seKtUeJ4/l...YtDc1rcXTVlWIOw= )

   ;; Query time: 0 msec
   ;; SERVER: 10.53.0.3#53(10.53.0.3)
   ;; WHEN: Thu Mar 19 13:22:40 GMT 2020
   ;; MSG SIZE  rcvd: 962

这里有一个问题：父区告诉世界 ``example.net`` 正在使用密钥14956，但是权
威服务器指出它正在使用密钥27247和35328。造成这种不匹配的潜在原因有几个：
一种可能是恶意攻击者破坏了其中一方并更改了数据。更可能的情况是，子区的
DNS管理员没有将正确的密钥信息上载到父区。

.. _troubleshooting_incorrect_time:

不正确的时间
^^^^^^^^^^^^^^

在DNSSEC中，每个记录至少有一个RRSIG，每个RRSIG包含两个时间戳：一个指示
它何时生效，另一个指示它何时过期。如果验证解析器的当前系统时间不在两个
RRSIG时间戳之间，则错误消息将出现在BIND调试日志中。

下面的示例显示了RRSIG似乎已经过期时的一条日志消息。这可能意味着验证解析
器系统时间设置得不正确，在太远的将来时间，或者区管理员没有保持RRSIG的维
护。

::

   validating example.com/DNSKEY: verify failed due to bad signature (keyid=19036): RRSIG has expired

下面的日志显示RRSIG的有效期还没有开始。这可能意味着验证解析器的系统时间
设置得不正确，在太远的过去时间，或者区管理员错误地为该域名生成了签名。

::

   validating example.com/DNSKEY: verify failed due to bad signature (keyid=4521): RRSIG validity period has not begun

.. _troubleshooting_unable_to_load_keys:

无法加载密钥
^^^^^^^^^^^^^^^^^^^

这是一个简单但普遍的问题。如果存在密钥文件，但由于某种原因 ``named`` 无
法读取， ``syslog`` 将返回明确的错误消息，如下所示：

::

   named[32447]: zone example.com/IN (signed): reconfiguring zone keys
   named[32447]: dns_dnssec_findmatchingkeys: error reading key file Kexample.com.+008+06817.private: permission denied
   named[32447]: dns_dnssec_findmatchingkeys: error reading key file Kexample.com.+008+17694.private: permission denied
   named[32447]: zone example.com/IN (signed): next key event: 27-Nov-2014 20:04:36.521

但是，如果没有找到密钥，错误就不那么明显了。下面显示了在密钥目录中缺少
密钥文件时，执行 ``rndc reload`` 后， ``syslog`` 的消息：

::

   named[32516]: received control channel command 'reload'
   named[32516]: loading configuration from '/etc/bind/named.conf'
   named[32516]: reading built-in trusted keys from file '/etc/bind/bind.keys'
   named[32516]: using default UDP/IPv4 port range: [1024, 65535]
   named[32516]: using default UDP/IPv6 port range: [1024, 65535]
   named[32516]: sizing zone task pool based on 6 zones
   named[32516]: the working directory is not writable
   named[32516]: reloading configuration succeeded
   named[32516]: reloading zones succeeded
   named[32516]: all zones loaded
   named[32516]: running
   named[32516]: zone example.com/IN (signed): reconfiguring zone keys
   named[32516]: zone example.com/IN (signed): next key event: 27-Nov-2014 20:07:09.292

这恰好与密钥存在且可读的情况完全相同，并且似乎表明 ``named`` 加载了密钥
并签名了区。它甚至会生成内部(原始)文件：

::

   # cd /etc/bind/db
   # ls
   example.com.db  example.com.db.jbk  example.com.db.signed

如果 ``named`` 真的加载了密钥并签名了区，您应该会看到以下文件：

::

   # cd /etc/bind/db
   # ls
   example.com.db  example.com.db.jbk  example.com.db.signed  example.com.db.signed.jnl

所以，除非你看到 ``*.signed.jnl`` 文件，您的区还未签名。

.. _troubleshooting_invalid_trust_anchors:

无效的信任锚
^^^^^^^^^^^^

在大多数情况下，您从不需要显式配置信任锚。 ``named`` 提供了当前的根信任
锚，通过缺省的 ``dnssec-validation`` 设置，当根变化时，也会更新这个信任
链，这种情况很少发生。

然而，在某些情况下，您可能需要显式地配置自己的信任锚。正如我们在
:ref:`trust_anchors_description` 一节中看到的，每当验证解析器接收到一条
DNSKEY时，它就会与解析器显式信任的密钥列表进行比较，以确定是否需要进一
步的操作。如果这两个密钥匹配，验证解析器将停止执行进一步的验证，并返回
经过验证的答案。

但是，如果验证解析器上的密钥文件配置错误或丢失怎么办？下面我们展示一些
当情况不支持时的日志消息的 例子。

首先，如果您复制的密钥格式不正确，BIND甚至无法启动，您可能会在syslog中
发现此错误消息：

::

   named[18235]: /etc/bind/named.conf.options:29: bad base64 encoding
   named[18235]: loading configuration: failure

如果密钥是一个有效的base64字符串但密钥算法是不正确的，或者安装了错误的
密钥，您首先注意到的就是几乎你所有的DNS查找都导致SERVFAIL，甚至当你查找
没有开启DNSSEC的域名。下面是查询递归服务器10.53.0.3的示例：

::

   $ dig @10.53.0.3 www.example.com. A

   ; <<>> DiG 9.16.0 <<>> @10.53.0.3 www.example.org A +dnssec
   ; (1 server found)
   ;; global options: +cmd
   ;; Got answer:
   ;; ->>HEADER<<- opcode: QUERY, status: SERVFAIL, id: 29586
   ;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1

   ;; OPT PSEUDOSECTION:
   ; EDNS: version: 0, flags: do; udp: 4096
   ; COOKIE: ee078fc321fa1367010000005e73a58bf5f205ca47e04bed (good)
   ;; QUESTION SECTION:
   ;www.example.org.       IN  A

``delv`` 显示了类似的结果：

::

   $ delv @192.168.1.7 www.example.com. +rtrace
   ;; fetch: www.example.com/A
   ;; resolution failed: SERVFAIL

您看到的下一个症状是在DNSSEC日志消息中：

::

   managed-keys-zone: DNSKEY set for zone '.' could not be verified with current keys
   validating ./DNSKEY: starting
   validating ./DNSKEY: attempting positive response validation
   validating ./DNSKEY: no DNSKEY matching DS
   validating ./DNSKEY: no DNSKEY matching DS
   validating ./DNSKEY: no valid signature found (DS)

这些错误表明信任锚存在问题。

.. _troubleshooting_nta:

否定的信任锚
~~~~~~~~~~~~

BIND 9.11引入了否定信任锚(Negative Trust Anchor, NTA)，当你知道区的
DNSSEC配置错误时，作为一种方法 *临时* 禁用区的DNSSEC验证。

NTA是使用 ``rndc`` 命令添加的，例如：

::

   $ rndc nta example.com
    Negative trust anchor added: example.com/_default, expires 19-Mar-2020 19:57:42.000

还可以使用 ``rndc`` 检查当前配置的NTA列表，例如：

::

   $ rndc nta -dump
    example.com/_default: expiry 19-Mar-2020 19:57:42.000

NTA的缺省生命周期是1小时，不过在缺省情况下，BIND每5分钟轮询一次区域，以
查看区是否正确验证，此时NTA将自动过期。缺省的生命周期和轮询间隔都可以通
过 ``named.conf`` 来配置，并且生命周期可以使用 ``rndc nta`` 的
``-lifetime duration`` 参数在区的粒度上覆盖缺省值。两个计时器值可允许的
最大值都为一周。

.. _troubleshooting_nsec3:

NSEC3排错
~~~~~~~~~

BIND包含一个名为 ``nsec3hash`` 的工具，它与验证解析器运行相同的步骤，根
据NSEC3PARAM参数生成正确的散列名称。该命令按顺序接受以下参数：salt、
algorithm、iterations和domain。例如，如果salt是1234567890ABCDEF，散列算
法是1，迭代次数是10，为了获得 ``www.example.com`` 的NSEC3散列名称，我们
将执行如下命令：

::

   $ nsec3hash 1234567890ABCEDF 1 10 www.example.com
   RN7I9ME6E1I6BDKIP91B9TCE4FHJ7LKF (salt=1234567890ABCEDF, hash=1, iterations=10)

虽然不太可能为自己的区数据构造一个彩虹表，但这个工具在诊断NSEC3问题时可
能很有用。
