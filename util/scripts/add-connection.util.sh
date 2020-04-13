#!/usr/bin/env bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
# set -x # Uncomment for debugging

# see: https://askubuntu.com/a/1041742, for now the NetManProfile has to be given to the script
# to view available connections, use `nmcli -t  connection show --active | cut -f 01 -d ':'`

if [[ -z "${1-}" ]]; then
	echo "No connection name given"
	exit 1
else
    NetManProfile="$1"
    # remove, if exists, current dns servers
    nmcli con mod "$NetManProfile" ipv4.dns ""
    # set 'manual' dns server
    nmcli con mod "$NetManProfile" ipv4.ignore-auto-dns yes
    # set dnsmasq as manually set dns server
    nmcli con mod "$NetManProfile" ipv4.dns 127.0.0.1
    # i also disabled ip6, do what u want
    nmcli con mod "$NetManProfile" ipv6.method ignore
    # reconnect to take effect
    nmcli connection down "$NetManProfile"
    nmcli connection up "$NetManProfile"
fi

