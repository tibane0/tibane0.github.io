
# Attack cycle
1. Recon
2. domain enum
3. local priv esc
4. admin recon
5. lateral movement
6. domain admin priv
7. cross domain attacks
8. persist and exfiltrate


## 1. Recon
#### Network discovery 
Find live machines within the network
- Arp scanning
	- windows `arp -a`
	- linux `arp-scan -l`
- Ping sweeps
	- windows :
	- linux : `nmap -sn <ip>/24`
- net view

### Port scanning
Scan for open ports and services of a host
Use nmap

### Service Enumeration

### Host Information Gathering
