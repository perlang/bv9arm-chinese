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

.. _relnotes_known_issues:

已知问题
--------

- 从BIND 9.16.32，9.18.6或更旧的版本升级可能需要手工修改配置。下列配置
  会受影响：

  - 配置了 :any:`dnssec-policy` 但没有 :any:`allow-update` 或
    :any:`update-policy` 的 :any:`type primary` 区。
  - 配置了 :any:`dnssec-policy` 的 :any:`type secondary` 区。

  在这些情况，请将 :namedconf:ref:`inline-signing yes; <inline-signing>`
  增加到各个区配置中。如果没有这个变化， :iscman:`named` 启动将会失败。
  更多详细信息参见
  https://kb.isc.org/docs/dnssec-policy-requires-dynamic-dns-or-inline-signing

- 当与在TLS上的区传送（XoT）相配合时，BIND 9.18不支持动态更新的转发（
  参见 :any:`allow-update-forwarding` ）。 :gl:`#3512`

- 根据 :rfc:`8310`, 第 8.1 部份，在建立一个DNS-over-TLS链接，验证一个
  远程证书时，必须不能检查 ``Subject`` 字段。作为替代，只有 
  ``subjectAltName`` 字段必须被检查。很遗憾，一些相当老版本的加密库可
  能缺乏忽略 ``Subject`` 字段的能力。这应当具有最小的生产使用后果，因
  为证书权威所发放的大多数生产达标证书都会设置 ``subjectAltName`` 。在
  这种情况， ``Subject`` 会被忽略。只有旧平台会受此影响，例如，那些使
  用OpenSSL版本早于1.1.1的。 :gl:`#3163`

- ``rndc`` 已被更新使用新的BIND网络管理器API。因为当前的网络管理器没有
  对UNIX域套接字的支持，它们现在不能再用于 ``rndc`` 。这个问题将在未来
  的版本中得到解决，要么恢复UNIX域套接字支持，要么在控制通道中正式宣布
  它们过时。 :gl:`#1759`

- 当在 :any:`notify-source` 语句中指定的源端口已被使用时，发送NOTIFY消
  息会静默地失败。例如，这可能会发生在当多个服务器被配置为一个区的
  NOTIFY目标，但其中一些却是没有响应时。这个问题可以通过在
  :any:`notify-source` 语句中不为NOTIFY消息指定源端口而绕过；注意源端
  口配置已被 `废弃`_ 并将在一个未来的版本中被一起去掉。 :gl:`#4002`

.. _废弃: https://gitlab.isc.org/isc-projects/bind9/-/issues/3781
