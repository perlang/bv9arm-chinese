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

.. History:

DNS和BIND的简要历史
===================================

尽管域名系统“官方地”开始于1984年，随着 :rfc:`920` 的公布，但这个新系统
的核心是由1983年的 :rfc:`882` 和 :rfc:`883` 描述的。从1984年到1987年，
ARPAnet（今天的互联网的前身）成为一个在快速扩展的、运转中的网络环境中
开发新的命名/寻址机制的试验床。新的RFC于1987年被写作并出版，它们修改了
原始的文档以合并进基于这个工作模式的进展。 :rfc:`1034` ，
“域名 – 概念和设施”和 :rfc:`1035` ，“域名 – 实现和规范”出版并成为所有
DNS实现的标准。

第一个可以工作的域名服务器，名叫“Jeeves”，由Paul Mockapetris于1983-84
年在位于南加州大学信息科学研究所（USC-ISI）和SRI国际网络信息中心
（SRI-NIC）上的DEC Tops-20机器上写成的。一个在Unix上的DNS，伯克利互联
网名字域（Berkeley Internet Name Domain，BIND）包，是稍后由一组加州大
学伯克利分校的研究生在美国国防部高级研究项目管理局（DARPA）的资助下完
成的。

BIND版本直到4.8.3都是由在加州大学伯克利分校的计算机系统研究组（CSRG）
所维护。Douglas Terry，Mark Painter，David Riggle和Songnian Zhou组成
了最初的BIND项目组。之后，Ralph Campbell在软件包上做了一些增加的工作。
Kevin Dunlap，一个数字设备公司（DEC）的雇员，作为赞助给CSRG的资源，为
BIND工作了2年，从1985年到1987年，在此期间还有许多其他人也对BIND的开发
作出了贡献：Doug Kingston，Craig Partridge，Smoot Carl-Mitchell，
Mike Muuss，Jim Bloom和Mike Schwartz。BIND的维护随后被移交给了
Mike Karels和 Øivind Kure。

BIND版本4.9和4.9.1由数字设备公司发行（现在是Compaq计算机公司）。
Paul Vixie，那时是DEC的一名雇员，成为了BIND的主要日常维护者。他的助手
有Phil Almquist，Robert Elz，Alan Barrett，Paul Albitz，Bryan Beecher，
Andrew Partan，Andy Cherenson，Tom Limoncelli，Berthold Paffrath，
Fuat Baran，Anant Kumar，Art Harkin，Win Treese，Don Lewis，
Christophe Wolfhugel及其他一些人。

在1994年，BIND版本4.9.2由Vixie公司赞助。Paul Vixie成为BIND的首席架构
师/程序员。

BIND版本自4.9.3之后由互联网系统联盟及其前身互联网软件联盟进行开发和
维护，并由ISC的赞助商提供支持。

作为共同架构设计师和程序员，Bob Halley和Paul Vixie在1997年5月发布了
第一个BIND版本8的产品级版本。

BIND版本9于2000年9月发布，它几乎重写了BIND体系结构的各个方面。

BIND版本4和8已经正式被废弃了。不再在BIND版本4或BIND版本8上做进一步的
开发了。

今天，在从ISC（https://www.isc.org/contact/）购买专业支持服务和/或为
我们的任务捐款的一些公司的赞助下，并且经过许多人的不懈地努力工作，
BIND开发工作才成为可能。
