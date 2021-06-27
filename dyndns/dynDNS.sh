#!/bin/bash
# Created by fibergames.net // Loranth Moroz // v.0.5
# Required tools to run this script as is: curl (https://curl.haxx.se/) & jq (https://stedolan.github.io/jq/)
# This only works for Digitalocean - 10$ credit referral link: https://m.do.co/c/fed75101475f
# Edit token, domain, subdomain to fit your needs
# Substitute ipinfo.io with your own ip-checker e.g. ipecho.net/plain
# This is to be used with crontab -> example entry to run it every 3hours:
# 0 */3 * * * sh /path/to/script/dnsupdater.sh
# Don't forget to make it executable: chmod +x /path/to/script/dnsupdater.sh

debug() {
  local msg="$1"
  local now="$(date '+%F_%T')"
  echo "$now > $msg"
}

token="$API_TOKEN"
domain="$DOMAIN"
subdomain="$SUBDOMAIN"

ip=$(curl --silent ipinfo.io/ip)
record=$(curl --silent --request GET --header "Content-Type: application/json" --header "Authorization: Bearer $token" \
	"https://api.digitalocean.com/v2/domains/$domain/records" | \
       	jq ".[] | . [] | select(.name==\"${subdomain}\")" 2>/dev/null)
record_data=$(echo "$record" | grep "data" | sed "s/[^0-9\.]//g")

if [ "$ip" == "$record_data" ]; then
	debug "* No DNS update is necessary"
else
	record_id=$(echo "$record" | grep "id" | sed "s/[^0-9]//g")
	curl --silent -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $token" -d '{"data":"'$ip'"}' "https://api.digitalocean.com/v2/domains/$domain/records/$record_id" > /dev/null;
	debug "* DNS updated with IP: $ip"
fi

