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


.. highlight: console

.. _man_nsec3hash:

nsec3hash - 生成NSEC3哈希
-------------------------------

概要
~~~~~~~~

:program:`nsec3hash` {salt} {algorithm} {iterations} {domain}

:program:`nsec3hash` **-r** {algorithm} {flags} {iterations} {salt} {domain}

描述
~~~~~~~~~~~

``nsec3hash`` 基于一个NSEC3参数集生成一个NSEC3哈希。这可以用于检查
一个签名区中NSEC3记录的有效性。

如果这个命令以 ``nsec3hash -r`` 的方式运行，它按照一个NSEC3记录的
头四个字段的顺序接受参数，后面跟着域名： ``algorithm`` ， ``flags`` ，
``iterations`` ， ``salt`` ， ``domain`` 。这就很方便地拷贝并粘贴一条
NSEC3或者NSEC3PARAM记录的一部分到一条命令行中确保了一个 NSEC3 hash
的正确性。

参数
~~~~~~~~~

``salt``
   这是提供给hash算法的salt值。

``algorithm``
   这是一个表示哈希算法的数字。当前对NSEC3唯一支持的哈希算法是SHA-1，由
   数字1表示；因此，“1”是这个参数唯一合法的值。

``flags``
   这提供与NSEC3记录表示格式的兼容性，但由于标志不影响哈希而被忽略。

``iterations``
   这是哈希应该额外执行的次数。

``domain``
   这是被哈希的域名。

参见
~~~~~~~~

BIND 9管理员参考手册， :rfc:`5155`.
