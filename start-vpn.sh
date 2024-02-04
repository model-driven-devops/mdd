#!/usr/bin/env bash

read -p "Enter password: " VPN_PASSWORD
printf "nsouser1\n$VPN_PASSWORD\ny" | /opt/cisco/secureclient/bin/vpn -s connect devnetsandbox-usw1-reservation.cisco.com:20397