---
layout: page
title: Linux Privilege Escalation
permalink: /notes/linux/
---

# 🐧 Linux Privilege Escalation

Cheat sheet for escalating privileges on Linux systems.

## 🔍 Enumeration

- `sudo -l`
- `find / -perm -4000 2>/dev/null`
- `getcap -r / 2>/dev/null`

## 🧪 Exploits

- Sudo misconfigs (e.g. `nano`, `less`, `python`)
- SUID abuse (e.g. `nmap`, `vim`)
- Kernel exploits (e.g. DirtyCow)

## 🛠️ Tools

- LinPEAS
- pspy
- GTFOBins
