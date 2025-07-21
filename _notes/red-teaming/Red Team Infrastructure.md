---
layout: default
title: Red Teaming Infrastructure
tags:
  - red-team
red-team-infrastructure:
---
# Red Team Infrastructure

Red team infrastructure is the backbone of all offensive operations. It must:
- support stealthy and reliable command and control (C2).
- enable flexible payload delivery and staging
- prevent attribution or accidental disruption
- comply with opsec and engagement scoping constraints.

Red team environments are typically multi-tier architecture, divided into the following layers:

1. **Command and Control Server** (C2)
	- These are used by attackers to maintain communications with compromised systems within a target network.
2. **Payload Server**
	- This is a dedicated server hosting all the malicious scrips, executable etc and this is accessible from both attacker and victim network
3. **Redirector Server**
	- A redirector is a system that proxies all traffic to your command and control server
	- Attackers dont use use one system to launch attacks and get shells. They setup multiple systems to act as pivots points (redirectors) back to their C2 servers.
	- These prevent the client from being able to see our actual C2, and should be easy to spin up and tear down.
	- Protects the original location of the team server.
 4. Operator Layer
	 Attackers control point
	 - Used for issuing commands and managing sessions.
	 - Must be isolate and hardened.

## OPSEC in infrastructure

Stealth and survivability are critical. Techniques include
- Domain Aging and Reputation Management
	- Register domains weeks or months in advance.
	- Use services with legitimate-looking WHOIS records and SSL certificates
- TLS Certificate Matching
	- Clone legitamate TLS certificates parameters
- c2 variability 
	- Implement multiple communication channels (HTTPS, DNS, SMB) and fallbacks (beacons with jitter, alternate sleep misdirection domains).
- Failover strategy
	- include dead-drop resolvers or backup redirectors to maintain control if infrastructure is blocked or discovered


## Testing
#### Before deploying
- Test all c2 channels in simulated soc env
- ensure payload signatures do not trigger command EDR/AV platforms
- Validate egrees paths
- maintain audit logs and versioning of deployed payloads

#### During operations
- Monitor c2 traffic for anomalies or signs of detection.
- ensure payloads maintain persistence only as permitted as ROE

## Documentation
Ensure the infrastructure is fully documented.
- hostnames, ips, domain registration
- c2 protocols and beaconing schedules
- emergency teardown or cut-off procedures
- opsec strategy for each component
