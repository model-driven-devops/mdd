#!/usr/bin/env bash

read -p "Enter password: " VPN_PASSWORD
echo $VPN_PASSWORD | sudo openconnect \
	--background \
	--no-dtls \
	--passwd-on-stdin \
	--protocol=anyconnect \
	--user=user01 \
	  devnetsandbox-usw1-reservation.cisco.com:20132
