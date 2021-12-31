#!/bin/bash

# -------------------------------------------------------
# no-ip + PushBullet notif v0.1 - 2021/09/25
# - moded version of : https://www.datenreise.de/bash-update-script-no-ip-com-dynamic-dns/
# - removed ip parse/request (noip api request don't need to provide ip)
# - Added PushBullet
# -------------------------------------------------------

USERNAME="XXX"
PASSWORD="XXX"
HOST="XXX.xxx.xxx"
#LOGFILE=/var/log/noip.log
USERAGENT="Datenreise NOIP Updater/0.4"
PUSHBULLETKEY="x.XXXXXXXXXXX"
TITLE="no-ip $HOST"

RESPONSE=$(curl -s -k -u $USERNAME:$PASSWORD --user-agent "$USERAGENT" "https://dynupdate.no-ip.com/nic/update?hostname=$HOST")
RESPONSE=$(echo $RESPONSE | tr -cd "[:print:]")

RESPONSE_A=$(echo $RESPONSE | awk '{ print $1 }')
case $RESPONSE_A in
	"good")
	RESPONSE_B=$(echo $RESPONSE | awk '{ print $2 }')
	LOGTEXT="(good) DNS hostname(s) successfully updated to $RESPONSE_B.";;
	"nochg")
	RESPONSE_B=$(echo $RESPONSE | awk '{ print $2 }')
	LOGTEXT="(nochg) IP address is current: $RESPONSE_B; no update performed.";;
	"nohost")
	LOGTEXT="(nohost) Hostname supplied does not exist under specified account. Revise config file.";;
	"badauth")
	LOGTEXT="(badauth) Invalid username password combination.";;
	"badagent")
	LOGTEXT="(badagent) Client disabled - No-IP is no longer allowing requests from this update script.";;
	"!donator")
	LOGTEXT="(!donator) An update request was sent including a feature that is not available.";;
	"abuse")
	LOGTEXT="(abuse) Username is blocked due to abuse.";;
	"911")
	LOGTEXT="(911) A fatal error on our side such as a database outage. Retry the update in no sooner than 30 minutes.";;
	*)
	LOGTEXT="(error) Could not understand the response from No-IP. The DNS update server may be down.";;
esac

# LOGDATE="[$(date +'%d.%m.%Y %H:%M:%S')]"
# echo "$LOGDATE $LOGTEXT" >> $LOGFILE

# Send PushBullet
curl -u "$PUSHBULLETKEY": -X POST https://api.pushbullet.com/v2/pushes -k -d type=note -d title="$TITLE" -d body="$LOGTEXT"
exit 0
