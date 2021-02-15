.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

.. Troubleshooting:

排除故障
===============

.. _common_problems:

常见问题
---------------

它不工作；我如何判定哪里出错了？
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

解决安装和配置问题的最好方法是通过预先设置日志文件来采取预防性的措
施。日志文件提供了暗示和信息的源头，后者用于识别哪里出现了错误以及
如何来解决问题。

EDNS合规性问题
~~~~~~~~~~~~~~~~~~~~~~

EDNS（扩展的DNS）是一项最早在1999年指定的标准。它是DNSSEC验证，
DNS COOKIE选项以及其它特性的基础。仍然有一些故障的或者过时的DNS服
务器和防火墙在使用，它们在收到带EDNS的请求时会产生错误的行为；例如，
它们会丢弃EDNS请求而不是回复FORMERR。BIND和其它递归名字服务器在面
对这个情况时，习惯上采用变通的方法，以不同方式重试，最终回退到不带
EDNS的普通DNS请求。

这样的变通方法导致不必要的解析延迟，增加代码复杂性，并阻碍开发新的
DNS特性。2019年2月，所有主流的DNS软件开发商都同意去除这些变通方法；
参见https://dnsflagday.net以获取更多细节。这个变化在BIND的9.14.0版
本开始实现。

作为一种结果，在没有人工干预时，某些域名可能不能解析。在这种情况下，
可以针对有问题的服务器添加 ``server`` 子句来恢复解析，指定
``edns no`` 或 ``send-cookie no`` ，依赖于具体的不合规情况。

要决定使用哪个 ``server`` 子句，运行下列命令发送请求给有问题域名的
权威服务器：

::

           dig soa <zone> @<server> +dnssec
           dig soa <zone> @<server> +dnssec +nocookie
           dig soa <zone> @<server> +noedns

如果第一条命令失败但是第二条成功，服务器很可能需要
``send-cookie no`` 。如果头两条失败但是第三条成功，服务器需要通过
``edns no`` 将EDNS完全关闭。

请联系不合规域名的管理员，并鼓励他们升级他们的有问题的DNS服务器。

增加和修改序列号
-------------------------------------------

区的序列号只是数字 — 它们与日期没有联系。大多数人将它们设置成表示
日期的一个数，通常是YYYYMMDDRR的格式。偶尔地，他们会错误地将它们设
置为一个“未来的日期”然后试图通过将其设置为“当前的日期”来纠正错误。
这就产生了问题，因为序列号是用来指示一个区被更新了。如果一个辅服务
器上的序列号小于主服务器上的序列号，辅服务器将试图更新它的区拷贝。

将主服务器的序列号设置成为一个比辅服务器上更小的数意味着辅服务器将
不会执行对它的区拷贝的更新。

解决方案是将数字增加2147483647（2^31-1），重新装载区并确保所有的辅
服务器都更新为新的区序列号，然后重新设置数字为你想要的，再重新装载
一次区。

.. _more_help:

从哪里获得帮助？
---------------------
BIND用户邮件列表，在 https://lists.isc.org/mailman/listinfo/bind-users ，
是用户间互相支持的优秀资源。另外，ISC维护了一个有帮助文档的知识库，
在 https://kb.isc.org 。

互联网系统联盟（Internet Systems Consortium，ISC）提供了对BIND 9，
ISC DHCP和Kea DHCP的年度支持协议。所有付费支持合同包括高级安全通知；
一些级别包含服务级别协议（service level agreements，SLA），优质软
件特性，以补丁修补和特性需求的增强优先级。

更多信息，请联系 info@isc.org 或访问 https://www.isc.org/contact/ 。
