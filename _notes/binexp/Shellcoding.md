---
layout: default
title: Shellcoding
tags:
  - pwn
  - maldev
---
# Shellcode
Shellcode is a little piece of binary data that is meant to be executed by a process as part of an attack vector. The shellcode is usually placed in the process' memory and the aim is to execute that shellcode.

Shellcode is typically written in assembly language and then compiled into binary object code and fed to a vulnerable program. 

Three actions to perform in order to run shellcode in a vulnerable binary:
1. Write the shellcode
2. inject the shellcode into the memory address space of the vulnerable process.
3. Trigger the running of the shellcode by jumping to the shellcode address.

