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

- 在某些平台上，包括FreeBSD， :iscman:`named` 必须作为root运行，以便在
  一个特权端口上使用 :iscman:`rndc` 控制通道（例如，使用一个小于1024
  的端口号；这包括缺省的 :iscman:`rndc` :rndcconf:ref:`port` ，953）。
  当前，使用 :option:`named -u` 选项切换到一个非特权用户将使得
  :iscman:`rndc` 不可用。这将在未来的版本中修订；同时，
  ``mac_portacl`` 可以用作一个替代方法，如在文档
  https://kb.isc.org/docs/aa-00621 中所述。 :gl:`#4793`
