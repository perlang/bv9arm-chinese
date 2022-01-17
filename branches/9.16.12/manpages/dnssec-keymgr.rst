.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

.. highlight: console

.. _man_dnssec-keymgr:

dnssec-keymgr - 为一个基于一个已定义策略的区确保正确的DNSKEY覆盖
-------------------------------------------------------------------------

概要
~~~~~~~~

:program:`dnssec-keymgr` [**-K**\ *directory*] [**-c**\ *file*] [**-f**] [**-k**] [**-q**] [**-v**] [**-z**] [**-g**\ *path*] [**-s**\ *path*] [zone...]

描述
~~~~~~~~~~~

``dnssec-keymgr`` 是一个高级Python外包装以使BIND处理区的密钥轮转
进程更加容易。它使用BIND命令操纵DNSSEC密钥元数据：
``dnssec-keygen`` 和 ``dnssec-settime`` 。

DNSSEC策略可以从一个配置文件（缺省是/etc/dnssec-policy.conf）
读取，从中任何给定区的密钥参数，发布和轮转时间表，以及期望的覆
盖时间段都可以被决定。这个文件可以用于基于每个区定义单独的
DNSSEC策略，或者为所有区设置一个“default”策略。

当运行 ``dnssec-keymgr`` 时，它检查一个或多个区的DNSSEC密钥，
将这些区的时间元数据与其策略进行对比。如果密钥设置不符合DNSSEC
策略（例如，由于策略被修改），他们就会被自动纠正。

一个区策略可以指定一段我们想要确保密钥正确性的持续时间
（ ``coverage`` ）。它也可以指定一个轮转周期（ ``roll-period`` ）。
如果策略指示一个密钥应当在覆盖周期结束之前轮转，就会自动创建一
个后继密钥并将其添加到密钥串的末尾。

如果在命令行指定了区， ``dnssec-keymgr`` 将只检查这些区。如果
一个指定的区没有在适当的地方有密钥，就会根据策略为其自动生成密
钥。

如果 **没有** 在命令行指定区， ``dnssec-keymgr`` 将搜索密钥目
录（要么是当前工作目录，要么是由 ``-K`` 选项设置的目录），并
检查出现在目录中的所有区的密钥。

密钥时间在过去的将不会被更新，除非使用了 ``-f`` （参见下面）。
密钥失活和删除时间小于五分钟之后的将会被延长五分钟。

预期这个工具将会自动地运行并无需人工照看（例如，通过 ``cron`` ）。

选项
~~~~~~~

**-c** *file*

   如果指定了 ``-c`` ，就从文件 ``file`` 读取DNSSEC策略。（如
   果未指定，就从文件/etc/dnssec-policy.conf读取策略；如果那个
   文件不存在，就使用一个内置的全局缺省策略。）

**-f**

   强制：允许密钥事件的更新，即使它们已经过时。不推荐在密钥已
   经发布的区使用这个。然而，如果一些密钥被生成，所有密钥的发
   布日期和激活日期都在过去，但是密钥还未在区中发布，这时这个
   选项可以用于清理它们并使用合适的轮转间隔将其变成一个适当的
   密钥集合。

**-g** *keygen-path*

   给 ``dnssec-keygen`` 二进制程序指定一个路径。用于测试。参见
   ``-s`` 选项。

**-h**

   输出 ``dnssec-keymgr`` 帮助概要并退出。

**-K** *directory*

   设置能够找到密钥的目录。缺省是当前工作目录。

**-k**

   仅应用策略到KSK密钥。参见 ``-z`` 选项。

**-q**

   安静：禁止 ``dnssec-keygen`` 和 ``dnssec-settime`` 的输出。

**-s** *settime-path*

   给 ``dnssec-settime`` 二进制文件指定一个路径。用于测试。参
   见 ``-g`` 选项。

**-v**

   输出 ``dnssec-keymgr`` 版本并退出。

**-z**

   仅应用策略到ZSK密钥。参见 ``-k`` 选项。

策略配置
~~~~~~~~~~~~~~~~~~~~

dnssec-policy.conf文件可以指定三种策略：

   . **策略类** （ ``policy``\ *name*\ ``{ ... };`` ）可以被区
   策略或者其它策略类继承；这些可以用于建议不同安全档案的集合。
   例如，一个策略类 ``normal`` 可能指定1024位的密钥长度，但是
   一个类 ``extra`` 可能指定2048位取代它； ``extra`` 用于那些
   有不一般的高安全需求的区。

..

   . **算法策略：** （``algorithm-policy``\ *algorithm*\ ``{ ...
   };`` ）覆盖缺省的按每个算法的设置。例如，缺省时，RSASHA256
   密钥对KSK和ZSK这两者都使用2048位密钥长度。这个可以使用
   ``algorithm-policy`` 修改，并且新的密钥长度就可以被用于任何
   RSASHA256类型的密钥。          

   . **区策略：** （ ``zone``\ *name*\ ``{ ... };`` ）按区名字
   为单一区设置策略。一个区策略可以通过包含一个 ``policy`` 选
   项继承一个策略类。以数字（即，0-9）开头的区名必须加引号。如
   果一个区没有自己的策略，就应用“default”策略。

可以在策略中指定的选项：

``algorithm`` *name*;

   密钥算法。如果未定义策略，缺省是RSASHA256。

``coverage`` *duration*;

   确保密钥正确的时间长度；在这个时间之后，将不采取措施建立并
   激活新密钥。这可以被表示为一个以秒为单位的数，或者使用人可
   读的单位表示的一段时间（例如：“1y”或者“6 months”）。这个选
   项的一个缺省值可以被设置在算法策略中，和在策略类或区策略中
   一样。如果未配置策略，缺省是六个月。

``directory`` *path*;

   指定密钥应该存放的目录。

``key-size`` *keytype* *size*;

   指定用于创建密钥的位数。keytype要么是“zsk”，要么是“ksk”。这
   个选项的一个缺省值可以设置在算法策略中，和在策略类或区策略
   中一样。如果没有配置策略，RSA密钥的缺省值是2048位。

``keyttl`` *duration*;

   密钥的TTL。如果没有定义策略，缺省是一小时。

``post-publish`` *keytype* *duration*;

   在一个密钥失活后多长时间应将其从区中删除。注意：如果未设置
   ``roll-period`` ，这个值将被忽略。keytype要么是“zsk”，要么
   是“ksk”。这个选项的一个缺省持续时间可以设置在算法策略中，和
   在策略类或区策略中一样。缺省值是一个月。

``pre-publish`` *keytype* *duration*;

   在一个密钥激活之前多长时间应该发布它。注意：如果未设置
   ``roll-period`` ，这个值将被忽略。keytype要么是“zsk”，要么
   是“ksk”。这个选项的一个缺省持续时间可以设置在算法策略中，和
   在策略类或区策略中一样。缺省值是一个月。

``roll-period`` *keytype* *duration*;

   密钥应以多大频率被轮转。keytype要么是“zsk”，要么是“ksk”。这
   个选项的一个缺省持续时间可以设置在算法策略中，和在策略类或
   区策略中一样。如果没有配置策略，对ZSK缺省值是一年。KSK缺省
   不轮转。

``standby`` *keytype* *number*;

   还未实现。

剩余工作
~~~~~~~~~~~~~~

   . 通过给 ``dnssec-keygen`` 和 ``dnssec-settime`` 使用
   ``-P sync`` 和 ``-D sync`` 选项打开KSK轮转的调度。检查父区
   （如同在 ``dnssec-checkds`` 中一样）以决定何时轮转密钥是安
   全的。

..

   . 允许为使用RFC 5011语义的密钥配置后备密钥和使用REVOKE位。

参见
~~~~~~~~

``dnssec-coverage``\ (8), ``dnssec-keygen``\ (8),
``dnssec-settime``\ (8), ``dnssec-checkds``\ (8)
