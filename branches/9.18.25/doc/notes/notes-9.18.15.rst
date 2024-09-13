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

BIND 9.18.15注记
----------------

漏洞修补
~~~~~~~~

- 自从BIND 9网络堆栈在版本9.16中被重构之后，
  :any:`max-transfer-time-in` 和 :any:`max-transfer-idle-in` 再也没有
  生效。缺失的功能已经被重新实现，入向的区传送在没有进行处理时，现在
  能够正确地超时。 :gl:`#4004`

- 在 :iscman:`rndc` 中的读超时现在是60秒，与BIND 9.16和更早版本的行为
  一致。之前它被错误地降低成30秒。 :gl:`#4046`

- 当libuv返回了错误码 ``ISC_R_INVALIDPROTO`` （ ``ENOPROTOOPT`` ，
  ``EPROTONOSUPPORT`` ），后者现在被当做一个网络失败看待：对应于被返回
  的错误码的服务器被标明为损坏的，并在一个给定的解析过程中不会再次接触。
  :gl:`#4005`

- 当从一个opt-out范围中删除授权时，由这些授权所生成的空的非终端NSEC3记
  录未被清理。这个已被修复。 :gl:`#4027`

- 当日志 :any:`channel` 被配置成一个 ``file`` 目标并有一个绝对路径时，
  日志文件轮转的代码没有清理更旧版本的日志文件。这个已被修复。
  :gl:`#3991`

已知问题
~~~~~~~~

- 当在 :any:`notify-source` 语句中指定的源端口已被使用时，发送NOTIFY消
  息会静默地失败。例如，这可能会发生在当多个服务器被配置为一个区的
  NOTIFY目标，但其中一些却是没有响应时。这个问题可以通过在
  :any:`notify-source` 语句中不为NOTIFY消息指定源端口而绕过；注意源端
  口配置已被 `废弃`_ 并将在一个未来的版本中被一起去掉。 :gl:`#4002`

- 关于影响这个BIND 9分支的所有已知问题的列表，参见
  :ref:`上文 <relnotes_known_issues>` 。

.. _废弃: https://gitlab.isc.org/isc-projects/bind9/-/issues/3781
