#!/usr/bin/env bash

echo $VPN_PASSWORD | sudo openconnect \
	--background \
	--no-dtls \
	--passwd-on-stdin \
	--protocol=anyconnect \
	--user=$VPN_USERNAME \
    $VPN_URL
