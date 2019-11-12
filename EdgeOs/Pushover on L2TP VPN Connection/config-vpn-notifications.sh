#!/bin/vbash
# This script goes in /config/scripts/post-config.d

#################################################################################
### Don't change anything beyond this point unless you know what you're doing ###
#################################################################################
# Include some of the vyatta commands we'll need
source /opt/vyatta/etc/functions/script-template

# Add a scheduled task to send the e-mails every minute
configure
set system task-scheduler task check-vpn-connections executable path "/config/scripts/post-config.d/notify-on-vpn-state-change.sh"
set system task-scheduler task check-vpn-connections interval "1m"
commit
save
exit
