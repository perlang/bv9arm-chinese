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

BIND 9.18.27注记
----------------

新特性
~~~~~~

- :any:`dnssec-policy` 中增加了一个新选项 :any:`signatures-jitter` ，以允许
  签名的过期时间分散在一小段时间内。 :gl:`#4554`

特性变化
~~~~~~~~

- 由于当前时间落在签名开始时间与过期时间之外而导致的DNSSEC签名无效已被跳过，
  而不是立即导致验证失败。
  :gl:`#4586`

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
