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

.. _introduction:

DNS和BIND 9介绍
===============

互联网域名系统（DNS）由以下几个部份组成：

- 以一个层次体系的方式指定互联网中实体名字的语法，
- 用于在名字之间授权的规则，和
- 实际完成从名字到互联网地址映射的系统实现。

DNS 数据是维护在一组分布式层次数据库中。

.. _doc_scope:

文档范围
-----------------

伯克利互联网名字域（Berkeley Internet Name Domain，BIND）软件
在一些操作系统上实现了一个名字服务器。
本文档为系统管理员提供了安装和维护互联网系统联盟
（Internet Systems Consortium，ISC）
的BIND版本9软件包的基本信息。

本手册涵盖了BIND版本 |release| 。

.. _organization:

本文档的组织
-----------------------------

:ref:`introduction` 介绍 DNS 和 BIND 的基本概念。在 :ref:`dns_overview`
中为不熟悉DNS的人提供了一些教学材料。并提供 :ref:`intro_dns_security`
允许BIND操作员为其运行环境实现合适的安全性。

:ref:`requirements` 描述了BIND 9的硬件和环境要求，并列出了支持和不支持
的平台。

:ref:`configuration` 的目标是为新用户提供一个快速入门参考。包括
:ref:`config_auth_samples` （包括 :ref:`主<sample_primary>` 和
:ref:`辅<sample_secondary>` ）的一些例子文件，以及一个简单的
:ref:`config_resolver_samples` 和 :ref:`sample_forwarding` 例子。还包
括关于 :ref:`区文件<zone_file>` 的参考材料。

:ref:`ns_operations` 覆盖了基本的BIND 9软件和DNS操作，包括一些有用的工
具，Unix信号，以及插件。

:ref:`advanced` 依赖于 :ref:`configuration` 的配置，增加了系统管理员可
能需要的功能和特性。

:ref:`security` 覆盖了BIND 9安全的大多数方面，包括文件权限，在一个“监
狱”中运行BIND 9，以及保护文件传输和动态更新。

:ref:`dnssec` 描述了DNS信息加密认证的理论和实践。 :ref:`dnssec_guide`
是实现DNSSEC的实用指南。

:ref:`Reference` 给出了用于BIND 9的 ``named.conf`` 配置文件中的所有支
持的块，语句和语法的详尽描述。

:ref:`troubleshooting` 提供了关于识别和解决BIND 9和DNS问题的信息。还提
供了关于错误报告程序的信息。

:ref:`build_bind` 是针对那些用户需要而标准Linux或Unix发行版中没有提供
的特殊选项的情况的权威指南。

**附录** 包含了一些有用的参考信息，例如一个与BIND和域名系统相关
的参考书目和历史信息，以及当前所有已发布工具的 *手册* 页。

.. _conventions:

本文档中的惯例
---------------------------------

在本文档中，我们通常使用 ``fixed width`` 文本来指示下列信息类型：

- 路径名
- 文件名
- 网页地址
- 主机名
- 邮件列表名
- 新术语或新概念
- 字面上的用户输入
- 程序输出
- 关键字
- 变量

"引用", **粗体** 或 *斜体* 格式的文本也用于强调或澄清。
