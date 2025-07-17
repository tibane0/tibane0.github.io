---
layout: default
title: Red Teaming Infrastructure
permalink: /notes/red-teaming/Red%20Team%20Attack%20Lifecycle.html
tags:
  - red-team
red-team-infrastructure:
---
# Red Team Infrastructure

**Command and Control Server** (C2)
- These are used by attackers to maintain communications with compromised systems within a target network.
**Payload Server**
- This is a dedicated server hosting all the malicious scrips, executable etc and this is accessible from both attacker and victim network
**Redirector Server**
- A redirector is a system that proxies all traffic to your command and control server
- Attackers dont use use one system to launch attacks and get shells. They setup multiple systems to act as pivots points (redirectors) back to their C2 servers.
- These prevent the client from being able to see our actual C2, and should be easy to spin up and tear down.
- Protects the original location of the team server.
 