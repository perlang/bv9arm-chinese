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

::

  zone <string> [ <class> ] {
  	type stub;
  	allow-query { <address_match_element>; ... };
  	allow-query-on { <address_match_element>; ... };
  	check-names ( fail | warn | ignore );
  	database <string>;
  	delegation-only <boolean>;
  	dialup ( notify | notify-passive | passive | refresh | <boolean> );
  	file <quoted_string>;
  	forward ( first | only );
  	forwarders [ port <integer> ] [ dscp <integer> ] { ( <ipv4_address> | <ipv6_address> ) [ port <integer> ] [ dscp <integer> ]; ... };
  	masterfile-format ( raw | text );
  	masterfile-style ( full | relative );
  	masters [ port <integer> ] [ dscp <integer> ] { ( <remote-servers> | <ipv4_address> [ port <integer> ] | <ipv6_address> [ port <integer> ] ) [ key <string> ] [ tls <string> ]; ... };
  	max-records <integer>;
  	max-refresh-time <integer>;
  	max-retry-time <integer>;
  	max-transfer-idle-in <integer>;
  	max-transfer-time-in <integer>;
  	min-refresh-time <integer>;
  	min-retry-time <integer>;
  	multi-master <boolean>;
  	primaries [ port <integer> ] [ dscp <integer> ] { ( <remote-servers> | <ipv4_address> [ port <integer> ] | <ipv6_address> [ port <integer> ] ) [ key <string> ] [ tls <string> ]; ... };
  	transfer-source ( <ipv4_address> | * ) [ port ( <integer> | * ) ] [ dscp <integer> ];
  	transfer-source-v6 ( <ipv6_address> | * ) [ port ( <integer> | * ) ] [ dscp <integer> ];
  	use-alt-transfer-source <boolean>;
  	zone-statistics ( full | terse | none | <boolean> );
  };
