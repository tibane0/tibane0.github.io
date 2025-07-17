---
layout: default
title: Network Pivoting
permalink: /notes/red-teaming/Red%20Team%20Attack%20Lifecycle.html
tags:
  - red-team
---

# What is Pivoting in Red Teaming?
During red team engagements or real cyberattacks, the threat actors often gain access to a network via a single weak point (Compromised machine is sometimes call as the foothold), once inside the network, the threat actors attempt to hide hide themselves while moving to other systems connected to the compromised machine. Pivoting is the act of using a compromised system to spread between different systems once inside the network. After obtaining foothold, threat actors scan the network for other subnets and machines, looking for the most valuable and/or vulnerable points of attack. Gaining access to connected systems is easier from the inside because penetration testers use the compromised machine's to try and disguise their behavior as legitimate network traffic.

The goal of pivoting is to remain undetected.

## Different Types of Pivoting.

### Port Forwarding: 
The attacker creates a tunnel between two machines via open TCP/IP ports, forwarding packages traffic from one to another. There are multiple types of port forwarding.
- Local Port Forwarding: The compromised machine "listens" for data instructions from the attacker's machine, allowing the attacker to access internal services.
- Remote Port Forwarding: The attacker maps ports on their machine to local ports on the compromised machine, allowing them to reach internal services through ssh connection.
- Dynamic Port Forwarding: Uses SOCKS proxy server for tunnelling traffic, with the compromised machine acting as a middleman.
### VPN pivoting:
Uses a vpn client of the compromised machine to access a remote vpn server.

### Proxy pivoting/SSH pivoting
Uses local proxy server through ssh.

### Routing Tables:
Modify routing tables of compromised machine so that traffic sent to the machine will tunnel through the defined gateway.

## How do threat actors pivot?

### Proxychains
proxychains is a tool for Unix systems that allows users to route any TCP connection through HTTP or a SOCKS proxy

### sshuttle
The sshuttle tool describes itself as “where transparent proxy meets VPN meets ssh.” sshuttle takes a hybrid approach, combining elements of both VPNs and SSH port forwarding to create a tunnel for exchanging network packets.

### Meterpreter
gives the attacker an interactive, invisible shell for running commands and controlling the compromised machine. Can be used to modify route tables via the autoroute command.
