.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.24注记
----------------------

特性变化
~~~~~~~~~~~~~~~

- 以前，当一个进入的TCP连接因为客户端提前关闭连接而不被接受时，会记录一
  条错误消息 ``TCP connection failed: socket is not connected`` 。这条
  消息被改为 ``Accepting TCP connection failed: socket is not
  connected`` 。对于下列触发事件： ``socket is not connected`` ，
  ``quota reached`` 和 ``soft quota reached`` ，这种类型的消息在日志中
  的严重级别从 ``error`` 修改为 ``info`` 。 :gl:`#2700`

- ``dnssec-dsfromkey`` 不再从已撤销的密钥生成DS记录。 :gl:`#853`

漏洞修补
~~~~~~~~~

- 从配置中删除一个 ``catalog-zone`` 子句，运行 ``rndc reconfig`` ，将恢
  复已被删除的 ``catalog-zone`` 子句，再运行 ``rndc reconfig`` 子句导致
  ``named`` 崩溃。这个已被解决。 :gl:`#1608`
