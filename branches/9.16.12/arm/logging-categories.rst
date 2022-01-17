.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

``client``
    对客户端请求的处理。

``cname``
    由于是一个 CNAME 记录而非一个 A/AAAA 记录而被跳过的名字服务器。
     
``config``
    配置文件分析及处理。

``database``
    与数据库相关的消息，数据库指名字服务器内部用于存储区和缓存数据。

``default``
    为没有被明确定义的配置的类别指定的日志选项。

``delegation-only``
    被强制成NXDOMAIN的请求，它是一个只授权区或一个转发、提示或存根区定义中有 ``delegation-only`` 的结果。

``dispatch``
    分发收到的包到将要处理它们的服务器模块。

``dnssec``
    DNSSEC 和 TSIG 协议处理。

``dnstap``
    “dnstap” DNS 流量捕获系统。

``edns-disabled``
    记录由于超时而被强制使用普通DNS的请求日志。这通常是因为远端服务器不是兼容 :rfc:`1034` （对 EDNS 请求和其不明白的 DNS 其它扩展并不总是返回 FORMERR 或类似的东西）。换句话说，这是瞄准服务器不能响应其不明白的 DNS 请求的。

    注意：日志消息也可能是因为包丢失。在报告服务器不兼容 :rfc:`1034` 之前，应该再测试它们以决定不兼容的类别。这个测试应当阻止或减少不正确报告的数目。

    注意：最后， ``named`` 必须不将这样的超时归咎为不兼容 :rfc:`1034` 而将其当作普通的包丢失。将包丢失错误地归咎为不兼容 :rfc:`1034` 会影响 DNSSEC 验证，后者要求对 DNSSEC 记录返回 EDNS。
    
``general``
    为许多仍未被分类到某个类别中的捕捉所有。

``lame-servers``
    远端服务器上的错误配置，是在解析过程中试图向其发请求时由BIND 9所发现的。

``network``
    网络操作。

``notify``
    NOTIFY协议。

``nsid``
    从上游服务器收到的NSID选项。

``queries``
    请求应当被记录的位置。
    
    在启动时，指定 ``queries`` 类别也会启动对请求的日志，除非设定 ``querylog`` 选项。

    请求日志条目首先以 @0x<十六进制数字> 格式报告一个客户端对象标识符。接下来，它报告客户端的IP地址和端口，请求的名字，类和类型。接下来，它报告是否设置了期望递归（Recursion Desired）的标志（如果设置是+，如果未设置是-），请求是否被签名（S），是否使用EDNS并伴随EDNS版本号（E(#)），是否使用TCP（T），DO位（DNSSEC Ok）是否被设置（D），CD位（Checking Disables）是否被设置（C），是否接收了一个有效的DNS服务器COOKIE（V），以及在没有出现一个有效的服务器COOKIE的情况下是否有一个DNS COOKIE选项（K）。在这之后，记录请求被发送到的目标地址。最后，如果客户端请求中存在任何CLIENT-SUBNET选项，它会以格式 [ECS address/source/scope] 被包含在方括号中。

    ``client 127.0.0.1#62536 (www.example.com):``
    ``query: www.example.com IN AAAA +SE``
    ``client ::1#62537 (www.example.net):
    ``query: www.example.net IN AAAA -SE``

    这条日志消息的第一部份，显示了客户端地址/端口号和请求名，在随后所有与同样请求相关的日志消息中都被重复。

``query-errors``
    关于导致失败的请求信息。

``rate-limit``
    一个响应流的比率限制的启动、周期性及结束通知将以 ``info`` 级别被写入这个类别。这些消息包含响应域名的一个散列值和域名自身，没有足够的内存来记录结束通知的名字这种情况除外。结束通知通常延迟到比率限制停止一分钟之后。内存不足可能导致仓促发出结束通知，这种情况以一个初始星号（\*）指明。各种内部事件以调试级别 1 或更高级别记录日志。

    对单个请求的比率限制记录在 ``query-errors`` 类别中。


``resolver``
    DNS解析，例如由缓存名字服务器所进行的递归查询给客户端的影响。

``rpz``
    关于响应策略区文件中错误，重写响应以及在最高级别的 ``debug`` 中的试图重写响应等的信息。

``security``
    同意和拒绝请求。

``serve-stale``
    指示是否一个旧的答复被用于跟随一个解析器失败。

``spill``
    被终止的请求，要么被丢弃，要么响应 SERVFAIL，是解析限制配额被超过后的结果。

``trust-anchor-telemetry``
    ``named`` 所收到的信任锚遥测（trust-anchor-telemetry）请求。

``unmatched``
    ``named`` 不能够决定的类别，或者没有合适的 ``view`` 与之匹配的消息。一个单行的摘要也记入 ``client`` 类别。这个类别最好发送到一个文件或标准错误；缺省时它被发送到 ``null`` 通道。

``update``
    动态更新。

``update-security``
    同意和拒绝更新请求。

``xfer-in``
    服务器所接受的区传送。

``xfer-out``
    服务器所发出的区传送。

``zoneload``
    装载区并创建自动的空区。
