.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

..
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")

   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/.

   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

.. _dyndb-info:

DynDB（动态数据库）
------------------------

动态数据库是一个对BIND 9的扩展，如同DLZ（参见 :ref:`dlz-info` ）一样，
它允许从一个外部数据库中提取区数据。与DLZ不一样的是，一个DynDB模块提供
了一个全功能的BIND区数据库接口。DLZ将DNS请求翻译成实时数据库查找，导致
相对低下的请求性能，并且由于其有限的API而无法处理DNSSEC签名数据，而一
个DynDB模块可以从外部数据源中预装载到一个内存数据库，可以提供由原生
BIND服务的区一样的性能和功能。

红帽建立了一个支持LDAP的DynDB模块，可以在
https://pagure.io/bind-dyndb-ldap 找到。

一个用于测试和开发者指导的样例DynDB模块被包含在BIND源代码中，在目录
``bin/tests/system/dyndb/driver`` 中。

配置DynDB
~~~~~~~~~~~~~~~~~

一个DynDB数据库是在 ``named.conf`` 中使用一个``dyndb`` 语句来配置：

::

       dyndb example "driver.so" {
           parameters
       };

文件 ``driver.so`` 是一个DynDB模块，它实现了全部DNS数据库API。可以指定
多条 ``dyndb`` 语句，以装载不同的驱动或者同一个驱动的多个实例。由一个
DynDB模块提供的区被添加到视图的区表中，并且在BIND响应请求时被当成一个
普通的权威区。区配置由DynDB模块内部进行处理。

parameters被作为一个不透明的字符串传递给DynDB模块的初始化程序。配置语
法依赖于驱动的不同而有所差别。

样例DynDB模块
~~~~~~~~~~~~~~~~~~~

为指导DynDB模块的实现，目录 ``bin/tests/system/dyndb/driver`` 含有一个
基本的DynDB模块。这个例子建立两个区，其名字被 ``dyndb`` 语句中的参数传
送给模块，

::

       dyndb sample "sample.so" { example.nil. arpa. };

在上述的例子中，模块被配置以建立一个区“example.nil”，它可以响应查询请
求和AXFR请求，并接受DDNS更新。运行时，在任何更新之前，区的顶点包含一个
SOA、NS和一个A记录。

::

    example.nil.  86400    IN      SOA     example.nil. example.nil. (
                                                  0 28800 7200 604800 86400
                                          )
    example.nil.  86400    IN      NS      example.nil.
    example.nil.  86400    IN      A       127.0.0.1

当区被动态更新时，DynDB模块将决定被更新的资源记录是否是一个地址（如，
类型A或者AAAA），如果是，它将自动更新一个反向区中对应的PTR记录。注意
更新不会永久保存；所有的更新在服务器重启时会丢失。
