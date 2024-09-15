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

BIND 9.18.13注记
----------------

新特性
~~~~~~

- RPZ更新现在运行在特定的“卸载”线程上，以减少它们阻塞运行在主网络线程
  上的查询处理。这增加了在一个RPZ区被成功传送之后应用RPZ更新时
  :iscman:`named` 的响应能力。 :gl:`#3190`

特性变化
~~~~~~~~

- 目录区更新现在运行在特定的“卸载”线程上，以减少它们阻塞运行在主网络线
  程上的查询处理。这增加了在一个目录区被成功传送之后应用目录区更新时
  :iscman:`named` 的响应能力。 :gl:`#3881`

- libuv的对在一个 ``recvmmsg()`` 系统调用中接收多个UDP消息的支持，在
  1.35.0版本和1.40.0版本之间做了调整；当前推荐的libuv版本是1.40.0或更高
  版本。新的规则现在适用于在编译时使用一个libuv版本而在运行时使用另一个
  版本。这些规则可能在启动时触发一个致命错误：

  - 以libuv 1.35.0和1.36.0版本编译或者运行现在是一个致命错误。

  - 当 :iscman:`named` 以libuv 1.34.2或更低版本编译并以高于1.34.2的版本
    运行时现在是一个致命错误。

  - 当 :iscman:`named` 以1.37.0，1.38.0，1.38.1或1.39.0版本编译并以高于
    1.39.0的版本运行时现在是一个致命错误。

  这些被阻止使用的libuv版本可能在一个系统调用中接收多个UDP消息时触发一
  个断言失败。 :gl:`#3840`

漏洞修补
~~~~~~~~

- 在将一个已经作为目录区的成员区而配置的名字作为新区添加到配置文件中时，
  :iscman:`named` 可能因一个断言失败而崩溃。这个已被修复。 :gl:`#3911`

- 当 :iscman:`named` 启动时，它会为每一个已经配置的信任锚发送一个对
  DNSSEC密钥的查询，以决定密钥是否有变化。在某些特定情形，这个查询所依
  赖的区的权威服务器恰好是它自身，且在区完全装载之前发送出查询时，它就
  可能失败。通过延迟对密钥的查询，直到所有的区都已完成装载，这个问题现
  已被修复。 :gl:`#3673`

已知问题
~~~~~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
    参见 :ref:`上文 <relnotes_known_issues>` 。
