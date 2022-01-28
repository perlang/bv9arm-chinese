.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.18注记
----------------------

漏洞修补
~~~~~~~~~

- 在准备DNS响应时， ``named`` 可能使用 ``\000`` 替代字母 ``W`` （大写）
  和 ``w`` （小写）。这个已被解决。 :gl:`#2779`

- 配置检查代码无法说明 ``key-directory`` 选项的继承规则。作为这一缺陷
  的副作用，为使用KASP的区检查 ``key-directory`` 冲突的代码会错误地报
  告单一的密钥目录被重复使用。这个已被解决。 :gl:`#2778`
