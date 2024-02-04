#!/usr/bin/env bash

echo $VPN_PASSWORD | sudo openconnect \
	--background \
	--no-dtls \
	--passwd-on-stdin \
	--protocol=anyconnect \
	--user=nsouser01 \
	  devnetsandbox-usw1-reservation.cisco.com:20287