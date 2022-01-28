.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

前言
----

.. _preface_organization:

文档组织
~~~~~~~~

本文档提供了关于 DNSSEC 如何工作，如何配置 BIND 9 以支持某些通常的的
DNSSEC 特性，以及一些基本的故障处理技巧的介绍信息。本章是如下组织的：

:ref:`dnssec_guide_introduction` 涵盖了本文档的预期受众，假定的背景知识，
以及对DNSSEC主题的基本介绍。

:ref:`getting_started` 涵盖了实现DNSSEC之前的各种要求，如软件版本、硬件
容量、网络要求和安全更改。

:ref:`dnssec_validation` 遍历了设置一个验证解析器，并给出了更多关于验证
过程的信息和一些验证解析器是否正确验证答复的工具示例。

:ref:`dnssec_signing` 解释了如何建立一个基本的签名权威区，详细说明了子
区和父区之间的关系，并讨论了正在进行的维护任务。

:ref:`dnssec_troubleshooting` 提供了一些提示如何分析和诊断DNSSEC相关的
问题。

:ref:`dnssec_advanced_discussions` 涵盖了几个主题，包括密钥生成、密钥存
储、密钥管理、NSEC和NSEC3，以及DNSSEC的一些缺点。

:ref:`dnssec_recipes` 提供了几个常见的DNSSEC解决方案的工作示例，带有逐
步的细节。

:ref:`dnssec_commonly_asked_questions` 列出了一些关于DNSSEC的常见问题和
答案。

.. _preface_acknowledgement:

致谢
~~~~

本文档的最初作者是
`DeepDive Networking <https://www.deepdivenetworking.com/>`__ 的i
Josh Kuo。可以通过 josh@deepdivenetworking.com 联系到他。

感谢下列帮助完成本文档的个人（排名不分先后）：Jeremy C. Reed，
Heidi Schempf，Stephen Morris，Jeff Osborn，Vicky Risk，Jim Martin，
Evan Hunt，Mark Andrews，Michael McNally，Kelli Blucher，Chuck Aurora，
Francis Dupont，Rob Nagy，Ray Bellis，Matthijs Mekking 和
Suzanne Goldlust。

特别感谢 Cricket Liu 和 Matt Larson 对其知识的无私分享。

感谢所有的复核人和贡献者，包括 John Allen，Jim Young，Tony Finch，
Timothe Litt 和 Jeffry A. Spain 博士。

关于密钥轮转和密钥定时元数据的章节大量借鉴了互联网工程任务组(Internet
Engineering Task Force)的，由S. Morris、J. Ihren、J. Dickinson和
W. Mekking写作的题为“DNSSEC Key Timing Considerations”的草案，随后发布
为 :rfc:`7583` 。

图标来自 `Flaticon <https://www.flaticon.com/>`__ ，通过
`Freepik <https://www.freepik.com/>`__ 和
`SimpleIcon <https://www.simpleicon.com/>`__ 制作，遵循
`Creative Commons BY 3.0 <https://creativecommons.org/licenses/by/3.0/>`__
许可证。
