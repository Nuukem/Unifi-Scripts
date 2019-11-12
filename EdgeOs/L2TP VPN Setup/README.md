#### WARNING: While I've made every effort to ensure these scripts work properly on my test device, use of these scripts are at your own risk. I will not be held liable for any damages caused directly/indirectly by their usage.

## VPN L2TP Setup on EdgeRouter (EdgeOS)

- Connect to the router via SSH and run the following commands.
- Be sure to change the `client-ip-pool` below.
- Also update the username and password values below for
    - PUT-PRE-SHARED-KEY-HERE
    - PUT-USERNAME-HERE
    - PUT-USER-PASSWORD-HERE

<pre>
configure

set firewall name WAN_LOCAL rule 30 action accept
set firewall name WAN_LOCAL rule 30 description ike
set firewall name WAN_LOCAL rule 30 destination port 500
set firewall name WAN_LOCAL rule 30 log disable
set firewall name WAN_LOCAL rule 30 protocol udp

set firewall name WAN_LOCAL rule 40 action accept
set firewall name WAN_LOCAL rule 40 description esp
set firewall name WAN_LOCAL rule 40 log disable
set firewall name WAN_LOCAL rule 40 protocol esp

set firewall name WAN_LOCAL rule 50 action accept
set firewall name WAN_LOCAL rule 50 description nat-t
set firewall name WAN_LOCAL rule 50 destination port 4500
set firewall name WAN_LOCAL rule 50 log disable
set firewall name WAN_LOCAL rule 50 protocol udp

set firewall name WAN_LOCAL rule 60 action accept
set firewall name WAN_LOCAL rule 60 description l2tp
set firewall name WAN_LOCAL rule 60 destination port 1701
set firewall name WAN_LOCAL rule 60 ipsec match-ipsec
set firewall name WAN_LOCAL rule 60 log disable
set firewall name WAN_LOCAL rule 60 protocol udp

set vpn l2tp remote-access ipsec-settings authentication mode pre-shared-secret

<font color="#17579f"># update pre-shared-secret here.</font>
set vpn l2tp remote-access ipsec-settings authentication pre-shared-secret <b>PUT-PRE-SHARED-KEY-HERE</b>
set vpn l2tp remote-access authentication mode local

<font color="#17579f"># update username and password here</font>
set vpn l2tp remote-access authentication local-users username <b>PUT-USERNAME-HERE</b> password '<b>PUT-USER-PASSWORD-HERE</b>'

<font color="#17579f"># update the client-ip-pool here</font>
set vpn l2tp remote-access client-ip-pool start <b>192.168.1.240</b>
set vpn l2tp remote-access client-ip-pool stop <b>192.168.1.244</b>

set vpn l2tp remote-access dns-servers server-1 8.8.8.8
set vpn l2tp remote-access dns-servers server-2 8.8.4.4

<font color="#17579f"># address of the WAN interface</font>
set vpn l2tp remote-access dhcp-interface <b>eth0</b>

<font color="#17579f"># address of the WAN interface</font>
set vpn ipsec ipsec-interfaces interface <b>eth0</b>

set vpn ipsec auto-firewall-nat-exclude disable
set vpn l2tp remote-access ipsec-settings ike-lifetime 3600

commit
save
</pre>

## These commands can be run to show connected users
```
show vpn remote-access 
```
and
```
show vpn ipsec sa
```