.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.0注记
---------------------

**注意：这个部份仅列出自BIND 9.14（上一个稳定的 BIND分支）以来的
变化。**

新特性
~~~~~~~~~~~~

-  一种基于 ``libuv`` 的新的异步网络通信系统现在用于 ``named`` 中监听
   进入的请求和对其响应。这个变化将使提升性能和在未来实现新的协议层（
   例如，DNS over TLS）更容易。 [GL #29]

-  新的 ``dnssec-policy`` 选项允许为区配置一个密钥和签名策略（KASP）。
   这个选项使 ``named`` 能够按需生成新密钥并自动轮转ZSK和KSK密钥。（注
   意这个语句的语法与 ``dnssec-keymgr`` 所用的DNSSEC策略不同。） [GL #1134]

-  为了使DNSSEC密钥的配置更清晰， ``trusted-keys`` 和 ``managed-keys``
   语句都被作废了，而新的 ``trust-anchors`` 语句现在应该可以用于两种
   类型的密钥。

   当与关键字 ``initial-key`` 一起使用时， ``trust-anchors`` 具有与
   ``managed-keys`` 同样的特性，即它配置一个通过RFC 5011维护的信任锚。

   当与新的关键字 ``static-key`` 一起使用时， ``trust-anchors`` 具有与
   ``trusted-keys`` 同样的特性，即它配置一个永久信任锚，不会自动更新。
   这个用法不推荐用于根密钥。） [GL #6]

-  ``trust-anchors`` 语句中增加了两个新的关键字： ``initial-ds`` 和
   ``static-ds`` 。这些允许在使用信任锚时以DS格式替代DNSKEY格式。DS格
   式允许信任锚配置还没有发布的密钥；这是IANA宣布未来根密钥所用的格式。

   与关键字 ``initial-key`` 和 ``static-key`` 一样， ``initial-ds``
   配置一个由RFC 5011维护的动态信任锚，而 ``static-ds`` 配置一个永久信
   任锚。 [GL#6] [GL #622]

-  ``dig`` ， ``mdig`` 和 ``delv`` 现在都可以接受一个 ``+yaml`` 选项并
   以一个详细的 YAML 格式打印输出。 [GL #1145]

-  ``dig`` 现在有了一个新的命令行选项： ``+[no]unexpected`` 。缺省时，
   ``dig`` 不会接受一个源地址不是它所请求的地址的回复。增加 ``+unexpected``
   参数使其可以处理来自非预期源地址来的回复。 [RT #44978]

-  ``dig`` 现在接受一个新的命令行选项， ``+[no]expandaaaa`` ，它使AAAA
   记录中的IPv6地址以完整的128-位符号输出，而不是缺省的RFC 5952格式。 [GL #765]

-  统计通道组现在可以被切换了。 [GL #1030]

特性变化
~~~~~~~~~~~~~~~

-  当同一个名字配置了静态和受管理的DNSSEC密钥，或者当一个静态密钥被用
   于配置一个根区的信任锚并且 ``dnssec-validation`` 被设置成缺省值
   ``auto`` ，自动RFC 5011密钥轮转将被关闭。这个组合设置永远不会工作，
   但是在语法分析时却没有检查。这个已经被纠正，现在它是一个致命的配置
   错误。 [GL #868]

-  DS和CDS记录现在只使用SHA-256摘要生成，取代了使用SHA-1和SHA-256。这
   影响 ``dnssec-dsfromkey`` 的缺省输出、 ``dnssec-signzone`` 生成的
   ``dsset`` 文件、基于 ``keyset`` 文件由 ``dnssec-signzone`` 添加到
   一个区的DS记录、基于密钥文件中的“sync”时间参数由 ``named`` 和
   ``dnssec-signzone`` 添加到一个区的CDS记录以及 ``dnssec-checkds``
   执行的检查。 [GL #1015]

-  如果为根区配置了一个静态密钥， ``named`` 将会记录一条警告日志。 [GL #6]

-  增加了一个基于SipHash 2-4的DNS Cookie (RFC 7873)算法，并作为缺省的。
   旧的非缺省基于HMAC-SHA的DNS Cookie算法被去掉了，只有缺省的AES算法
   因为遗留（legacy）的原因而被保留。这个变化对大多数普通场景没有操作
   上的影响。 [GL #605]

   如果你运行着多个DNS服务器（BIND 9的不同版本或者来自多个厂商的DNS服务
   器），响应来自于同一个IP地址（anycast或者负载均衡场景），要确认所有
   的服务器配置成同样的DNS Cookie算法和同一个服务器密码，以获得最好的性
   能。

-  来自 ``dnssec-signzone`` 和 ``dnssec-verify`` 的信息现在被输出到标准
   输出。标准错误输出仅用于输出警告和错误，以及用户请求使用 ``-f -`` 选
   项将签名区输出到标准输出。增加了一个新的配置选项 ``-q`` ，以关闭标准
   输出上的所有输出，除了签名区的名字。 [GL #1151]

-  DNSSEC验证代码已被重构，为了更加清晰和减少代码重复。 [GL #622]

-  ``configure`` 的 ``--with-tuning=large`` 选项所开启的编译时设置现
   在已经缺省生效。之前使用的缺省编译时设置可以在 ``configure`` 时使
   用 ``--with-tuning=small`` 来开启。 [GL !2989]

-  JSON-C是BIND统计中唯一支持的JSON库。 ``configure`` 选项从
   ``--with-libjson`` 改名为 ``--with-json-c`` 。需要根据 ``json-c``
   库的定制路径相应设置 ``PKG_CONFIG_PATH`` 环境变量，因为新的
   ``configure`` 选项不会将库安装路径作为一个可选参数。 [GL #855]

-  当没有指定 ``--prefix`` 并且没有显式指定 ``--sysconfdir`` 和
   ``--localstatedir`` 时， ``./configure`` 不会将 ``--sysconfdir``
   设置为 ``/etc`` ，或将 ``--localstatedir`` 设置为 ``/var`` 。作为
   替代，两者将分别被设置为Autoconf的缺省值 ``$prefix/etc`` 和
   ``$prefix/var`` 。 [GL #658]

去掉的特性
~~~~~~~~~~~~~~~~

-  ``dnssec-enable`` 选项已被作废并不再有效了。如果签名并且具有其它的
   DNSSEC数据，DNSSEC响应总是被开启。 [GL #866]

-  DNSSEC后备验证（DLV）现已被作废。 ``dnssec-lookaside`` 被标记为废弃；
   当用于 ``named.conf`` 时，它将生成一个警告并被忽略。所有开启了使用
   后备验证的代码都已从验证器， ``delv`` 和DNSSEC工具中删除了。 [GL #7]

-  ``cleaning-interval`` 选项已被删除。 [GL !1731]
