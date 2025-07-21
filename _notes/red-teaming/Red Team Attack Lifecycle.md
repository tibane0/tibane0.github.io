---
layout: default
title: Introduction to Red Teaming
tags:
  - red-team
---
# Red Team Attack Lifecycle

## Attack Lifecycle Stages
- Stage 1
	- Information Gathering/Recon 
		- Passive
		- Active
- Stage 2
	- Initial Access & Execution
- Stage 3
	- Persistence & Privilege Escalation
- Stage 4
	- Lateral Movement with Defense Evasion
- Stage 5
	- Discovery, Data Collection
- Stage 6
	- Data Exfiltration & high level persistence
### Information Gathering [Stage 1]
This phase deals with gathering information about the target organization. Attackers try to find information that can be used for further exploitation purposes.
#### Passive Information Gathering
Gather information using public records which is called OSINT (Open Source Intelligence).
Public records can be found on:
- social 
#### Active Information Gathering

### Initial Access and Execution[Stage 2]
Initial access consists of using various entry vectors to gain access within the internal network. Exploitation of remote services that are available to the internet may lead to gaining access to internal network. Ways to get initial access can be identified in the previous stage.

Execution is attacker controlled code running on the target machine.

###  Persistence & Privilege Escalation [Stage 3]
Attackers always look for hidden techniques to keep access to systems across restarts, changed credentials, etc which could cut-off attacker access.

Privilege escalation is gaining higher-level permissions on a system or network. Common approaches are to take advantage of system weaknesses, misconfigurations and vulnerabilities.

Elavated Access Acounts:
- System/root level
- local admin
- user with admin-like capabilities
- privileged groups

### Lateral Movement and Defensive Evasion[Stage 4]
Lateral movement is when an attacker compromises or gains control of one asset within a network and then moves on from that device to others within the same network.

Threat actors might install their own remote access tools to accomplish lateral movement or use legitimate credentials with native network operating system tools, which may be stealthier.

Defensive Evasion deals with avoiding detection throughout the compromise. Attackers bypass detection by obfuscating malicious scripts, hiding in trusted processes, and disabling security software etc. Defensive evasion is more related to understanding how an attacker can avoid network defenders whether through certain processes or knowing which security tools are on a system.
### Discovery and Data collection [Stage 5]
Discovery:  
- Attackers try to figure out the organization's environment.
- Use techniques that help observe the environment and orient themselves before deciding how to act.
- Helps gather information about critical assets located in the network.

Data Collection:
- Process of gathering and measuring information from established system.

### Data Exfiltration
- Once all the critical data has been identified and packed, attacker will try to steal data from the computer/network.
