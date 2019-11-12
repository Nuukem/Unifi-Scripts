### WARNING: While I've made every effort to ensure these scripts work properly on my test device, use of these scripts are at your own risk. I will not be held liable for any damages caused directly/indirectly by their usage.

# VPN L2TP Pushover Notifications

The scripts in this directory will poll the EdgeRouter VPN connection list every minute and report any VPN connectivity changes.

# Installation
- Install `wget` if not already installed.
```
sudo apt-get install wget
```
- Modify the settings at the top of `notify-on-vpn-state-change.sh`
- Push the scripts to your router via `scp`, replacing the username and ip address with your own:
```
scp config-vpn-notifications.sh admin@192.168.0.1:/config/scripts/post-config.d/
scp notify-on-vpn-state-change.sh admin@192.168.0.1:/config/scripts/post-config.d/
```
- Once the script has been copied, change the scripts to executable
```
cd /config/scripts/post-config.d
chmod a+x config-vpn-notifications.sh notify-on-vpn-state-change.sh
```

To start the script, execute `config-vpn-notifications.sh` for the first time via `sudo`.  After that, the script will be set up as a scheduled task, and will persist after reboots.  On upgrades, both scripts will be executed once the upgrade is complete, re-establishing the scheduled task:
```
sudo ./config-vpn-notifications.sh
```

# Removal
- Connect to the router via SSH, and run the following commands:
```
configure
delete system task-scheduler task check-vpn-connections
commit
save
exit
cd /config/scripts/post-config.d
rm config-vpn-notifications.sh
rm notify-on-vpn-state-change.sh
```

That will remove the scheduled task, and remove the scripts from the router.


# Example Output Output

When users connect:

```
VPN connection activity was detected on your network:

Active remote access VPN sessions:

User       Time      Proto Iface   Remote IP       TX pkt/byte   RX pkt/byte  
---------- --------- ----- -----   --------------- ------ ------ ------ ------
some.user  00h00m12s L2TP  l2tp0   10.0.0.1           56  11.6K     70   8.3K

Total sessions: 1
```

When the last user has disconnected:
```
No active remote access VPN sessions
```
