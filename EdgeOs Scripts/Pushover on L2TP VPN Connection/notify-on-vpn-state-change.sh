#!/bin/vbash
# This script goes in /config/scripts/post-config.d

# Variables you'll need to change
IPSegment='10.0.'  # The IP address segment your VPN is located on (i.e. '10.0.' or '192.168.1.')
PUSHOVER_USER_KEY="ENTER_YOUR_USER_KEY"
PUSHOVER_APP_KEY="ENTER_YOUR_API_APP_KEY"
CLIENT="ENTER_YOUR_CLIENT_LOCATION"
USE_HTML_FORMAT=1 # SET THIS TO 1 IF YOU ARE USING HTML IN YOUR MESSAGE BELOW.
USE_MONOSPACE_FORMAT=0 # SET THIS TO 1 IF YOU ARE USING MONOSPACE FORMAT.

#################################################################################
### Don't change anything beyond this point unless you know what you're doing ###
#################################################################################

echo "Starting..."

# Include some of the vyatta commands we'll need
source /opt/vyatta/etc/functions/script-template
run=/opt/vyatta/bin/vyatta-op-cmd-wrapper

# Init the temp files
touch /tmp/temp.vpnconnections
touch /tmp/temp.vpnconnections2

# Grab the full list of VPN connections
$run show vpn remote-access > /tmp/temp.vpnfulllist

# Parse out just the user and ip address
cat /tmp/temp.vpnfulllist|grep $IPSegment|awk -F' ' '{printf "%s %s\n", $1, $5}' > /tmp/temp.vpnconnections

# Check if they differ from the last time we checked
if ! cmp -s /tmp/temp.vpnconnections /tmp/temp.vpnconnections2
then
    # Someone connected to/disconnected from the VPN!  Send the notification
    echo "VPN Activity detected!  Sending notification..."

    connInfo=$(</tmp/temp.vpnfulllist)

    time=$(echo $(date +"%c"))

    if [ "$connInfo" = "No active remote access VPN sessions" ];
    then
        TITLE="VPN :: User DISCONNECTED FROM $CLIENT"
    else
        TITLE="VPN :: User CONNECTED to $CLIENT"
    fi

    MESSAGE=$connInfo

    wget https://api.pushover.net/1/messages.json --post-data="token=$PUSHOVER_APP_KEY&user=$PUSHOVER_USER_KEY&message=$MESSAGE&title=$TITLE&html=$USE_HTML_FORMAT&monospace=$USE_MONOSPACE_FORM$

    echo "Done!"

    # Back up this run so we can compare later
    cp /tmp/temp.vpnconnections /tmp/temp.vpnconnections2
else
    echo "No differences"
fi