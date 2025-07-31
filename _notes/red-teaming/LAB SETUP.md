---
layout: default
title: Red Team Lab
tags:
  - red-team
---



Target Company (fictional) called Red Team Labs.  
A company that performs red team exercises, vulnerability research and exploit development. 

Target Network Components (machines)
- DMZ Network:
	- 2 Machines
		- Standalone vulnerable machine (vulnhub)
		- linux server 
			- running vulnerable ctfs (pwn) from past events
			- vulnhub services from vulhub 
- (internal network) Active Directory:
	- 1 forest root (windows server 2019)
	- database server
	- 2 clients (1 windows 10 and 1 linux )
	- 1 server (database and file)
	- 1 Wazuh Siem




## Create  VMS

1. Setup DC
	- use setup script 
	- add users and groups (user script)
	- 