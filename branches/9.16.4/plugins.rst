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

.. _module-info:

插件
-------

插件是一个实验动态加载库扩展 ``named`` 功能的机制。
通过使用插件，对多数用户，服务器的核心功能可以保持简单；
更复杂的代码实现可选的特性，只被那些需要这些特性的用户安装。

插件接口是一项正在进行中的工作，预期进化成添加更多的插件。
当前，仅支持“请求插件”；这些改变了名字服务器的请求逻辑。
未来可能增加其它的插件类型。

当前唯一包含进 BIND 的插件是 ``filter-aaaa.so`` ，它替代了先前已存在
的 ``named`` 自然组成部份的 ``filter-aaaa`` 特性。
这个特性的代码已经从 ``named`` 中去掉了，并且不再能使用标准的
``named.conf`` 语法配置，但是链接 ``filter-aaaa.so`` 插件提供同样的功能。

配置插件
~~~~~~~~~~~~~~~~~~~

插件通过在 ``named.conf`` 中使用 ``plugin`` 语句配置：

::

       plugin query "library.so" {
           parameters
       };

在这个例子中，文件 ``library.so`` 是插件库。
``query`` 指示这是一个请求插件。

可以指定多个 ``plugin`` 语句，以加载不同的插件
或者同一个插件的多个实例。

``parameters`` 会作为一个不透明的字符串传送给插件的初始化程序。
配置语法依不同的模块而有差异。

开发插件
~~~~~~~~~~~~~~~~~~

每个插件实现了四个功能：

-  plugin_register申请内存，配置一个插件实例，
   并绑定到named内的钩子点，
-  plugin_destroy拆卸插件实例并释放内存，
-  plugin_version检查插件是否兼容于当前版本的插件API，
-  plugin_check测试插件参数的语法正确性。

在 ``named`` 源代码的不同位置，有一些“钩子点”，插件在此注册自身。
在 ``named`` 运行时，当运行到钩子点，会检查是否有任何插件在此注册了
它们自身；如果注册过，就调用相应的“钩子动作” - 这是插件库中的一个
功能 - 例如，修改发送回一个客户端的响应或者强制终止一个请求。
更多细节可以在文件 ``lib/ns/include/ns/hooks.h`` 中找到。
