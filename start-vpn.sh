#!/usr/bin/env bash

echo $POD_PASSWORD | sudo openconnect \
	--background \
	--no-dtls \
	--passwd-on-stdin \
	--protocol=anyconnect \
	--user=$POD_NAME@vpn.colab.ciscops.net \
	 cpn-vpn-mkdqgqzprv.dynamic-m.com
