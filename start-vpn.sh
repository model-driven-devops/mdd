#!/usr/bin/env bash

echo $POD_PASSWORD | sudo openconnect \
	--background \
	--no-dtls \
	--passwd-on-stdin \
	--protocol=anyconnect \
	--user=user01 \
	  devnetsandbox-usw1-reservation.cisco.com:20287
