.. 
   Copyright (C) Internet Systems Consortium, Inc. ("ISC")
   
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, you can obtain one at https://mozilla.org/MPL/2.0/.
   
   See the COPYRIGHT file distributed with this work for additional
   information regarding copyright ownership.

BIND 9.16.11注记
----------------------

特性变化
~~~~~~~~~~~~~~~

- 在 BIND 9.16 中引入的新的网络代码(netmgr)被全面修改，以使其更稳定、
  可测试和容易维护。 [GL #2321]

- Earlier releases of BIND versions 9.16 and newer required the
  operating system to support load-balanced sockets in order for
  ``named`` to be able to achieve high performance (by distributing
  incoming queries among multiple threads). However, the only operating
  systems currently known to support load-balanced sockets are Linux and
  FreeBSD 12, which means both UDP and TCP performance were limited to a
  single thread on other systems. As of BIND 9.17.8, ``named`` attempts
  to distribute incoming queries among multiple threads on systems which
  lack support for load-balanced sockets (except Windows). [GL #2137]

- It is now possible to transition a zone from secure to insecure mode
  without making it bogus in the process; changing to ``dnssec-policy
  none;`` also causes CDS and CDNSKEY DELETE records to be published, to
  signal that the entire DS RRset at the parent must be removed, as
  described in RFC 8078. [GL #1750]

- When using the ``unixtime`` or ``date`` method to update the SOA
  serial number, ``named`` and ``dnssec-signzone`` silently fell back to
  the ``increment`` method to prevent the new serial number from being
  smaller than the old serial number (using serial number arithmetics).
  ``dnssec-signzone`` now prints a warning message, and ``named`` logs a
  warning, when such a fallback happens. [GL #2058]

漏洞修补
~~~~~~~~~

- Multiple threads could attempt to destroy a single RBTDB instance at
  the same time, resulting in an unpredictable but low-probability
  assertion failure in ``free_rbtdb()``. This has been fixed. [GL #2317]

- ``named`` no longer attempts to assign threads to CPUs outside the CPU
  affinity set. Thanks to Ole Bjørn Hessen. [GL #2245]

- When reconfiguring ``named``, removing ``auto-dnssec`` did not turn
  off DNSSEC maintenance. This has been fixed. [GL #2341]

- The report of intermittent BIND assertion failures triggered in
  ``lib/dns/resolver.c:dns_name_issubdomain()`` has now been closed
  without further action. Our initial response to this was to add
  diagnostic logging instead of terminating ``named``, anticipating that
  we would receive further useful troubleshooting input. This workaround
  first appeared in BIND releases 9.17.5 and 9.16.7. However, since
  those releases were published, there have been no new reports of
  assertion failures matching this issue, but also no further diagnostic
  input, so we have closed the issue. [GL #2091]
