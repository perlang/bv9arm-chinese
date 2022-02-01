.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.1注记
---------------------

已知问题
~~~~~~~~~~~~

-  用于监听的UDP网络端口不能再同时用于发送流量。一个会触发这个问题
   的例子配置可能会是一个将同样的address:port对用于 ``listen-on(-v6)``
   语句且用于 ``notify-source(-v6)`` 或 ``transfer-source(-v6)``
   语句。而这个问题会影响到所有操作系统，在其中一些系统上它只会记录
   日志（例如，“unable to create dispatch for reserved port”）。当
   前还没有计划使这样的组合设置能够重新工作。

特性变化
~~~~~~~~~~~~~~~

-  系统所提供的 POSIX 线程读写锁实现现在作为缺省项，替代了原生的
   BIND 9实现。请注意glibc版本2.26到2.29有一个
   `bug <https://sourceware.org/bugzilla/show_bug.cgi?id=23844>`__
   ，可能导致BIND 9死锁。对此的修补发布在glibc 2.30中，并且当前大
   多数Linux发行都已修补或更新了glibc，但有一个值得注意的例外，
   Ubuntu 18.04 (Bionic)正在修补中。如果你在一个受影响的操作系统
   上运行，编译 BIND 9 时带上 ``--disable-pthread-rwlock`` ，直到
   一个glibc的修补版本可用为止。 :gl:`!3125`

漏洞修补
~~~~~~~~~

-  修正了在内联区中重签的问题，即导致签名延迟或者完全没有签名。
