.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.23注记
----------------------

漏洞修补
~~~~~~~~~

- 重新加载一个引用了一个缺失/删除的成员区的目录区触发一个实时检查失败，
  导致 ``named`` 过早退出。这个已被解决。 :gl:`#2308`
