---
layout: default
title: Off By One
tags:
  - pwn
---
# Off-By-One

The off-by-one vulnerability is a special type of buffer overflow vulnerability, where data is written only one byte beyond the allocated memory space. `[A single byte buffer overflow]`. This vulnerability can happen anywhere in memory whether it is stack, heap, bss segments, etc.

This vulnerability is often related to the lack of strict boundary checking and string operations.

Single byte overflows are considered to be difficult to exploit.

