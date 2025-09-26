---
layout: default
title: Partial Overwrite
tags:
  - pwn
  - roip
---

# What is a partial overwrite?
Instead of overwriting all bytes of a target address, you overwrite only the lowest few bytes to redirect execution to a nearby location without needing the full 8 byte overwrite.

## Why use it

A partial overwrite avoids needing the full pointer value.
#### Bypass `ASLR` 
- `ASLR` randomises the higher bytes of addresses but keep the lower bytes predictable.

