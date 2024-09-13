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

BIND 9.18.21注记
----------------

去掉的特性
~~~~~~~~~~

- 对使用AES作为DNS COOKIE算法（ ``cookie-algorithm aes;`` ）的支持已被
  废弃，并将在未来的某个版本中被删除。请使用当前的缺省值，SipHash-2-4，
  来替换它。 :gl:`#4421`

- :any:`resolver-nonbackoff-tries` 和 :any:`resolver-retry-interval`
  语句已被废弃。现在使用它们会记录一条告警到日志中。 :gl:`#4405`

已知问题
~~~~~~~~

- 本版本没有新的已知问题。关于影响这个BIND 9分支的所有已知问题的列表，
  参见 :ref:`上文 <relnotes_known_issues>` 。
