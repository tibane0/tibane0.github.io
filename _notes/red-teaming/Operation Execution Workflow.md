---
layout: default
title: Operation Execution Workflow
tags:
  - red-team
---
# Operation Execution Workflow
It describes the structured approach to executing red team operations, including key stages, methodologies, and operational safeguards to maintain stealth, impact realism and control.

## Execution Stages

### 1. Reconnaissance 
Initial Information gathering to identify:
- external attack surface (domains, IPs, open services)
- Employee names, emails, organizational structure
- Publicly exposed assets
Tools and techniques:
- Passive: OSINT, WHOIS, certificate transparency, social media scraping.
- Active: Nmap, masscan, dnsrecon, aquatone

### 2. Initial Access
Gaining a foothold using TTPs aligned to the selected threat actor.

Common methods:
- Phishing
- HTML smuggling, malicious documents
- valid accounts or credentials stuffing
- exploiting externally exposed services
Payloads must:
- be obfuscated
- evade MOTW and EDR detection
- communicate with established C2 infrastructure

### 3. Post-Exploitation
Establish internal situational awareness and validate access.

Key actions:
- Enumeration: network shares, users, domain trust, installed software
- Credential access: dumping hashes, abusing LSASS, extracting tokens
- Privilege escalation: bypass UAC, token impersonation, service misconfiguration

All actions must observe OPSEC:
- minimize noise
- avoid triggering EDR heuristics
- Use in-memory or reflective loaders

### 4. Lateral Movement and Persistence
Extend access across systems or elevate privileges.

TTPs:

- Lateral movement: RDP, WMI, SMB, WinRM, PsExec, remote services
- Persistence: scheduled tasks, startup registry keys, service hijacking
- Domain-wide attacks: DCSync, Kerberoasting, AS-REP Roasting

Ensure persistence methods do not violate RoE. If persistence is out of scope, use beacon-only presence without modification of registry or startup artifacts.

### 5. Actions on Objectives
Demonstrate impact while minimizing business risk
