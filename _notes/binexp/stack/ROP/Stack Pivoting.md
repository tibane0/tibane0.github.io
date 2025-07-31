---
layout: default
title: Stack Pivoting
tags:
  - pwn
---


# Stack Pivoting

## Overview

Stack Pivoting is a technique used when there is a lack of space on the stack and the we full ROP chain cannot be completed.

To `stack pivot` just means to move the stack pointer elsewhere. 

To accomplish this technique we take control of the `RSP` register and fake the location of the stack. Here are a few ways to do this:
- `pop rsp` gadget : simplest, but least likely to exist gadget.
- `xchg <reg>, rsp`: use this gadget to swap the values with ones in `RSP`. Requires 16 bytes of stack space after saved return pointer
	- `pop <reg>; <reg value>; xchg <reg>, rsp`
- `leave; ret` 
	- requires only 8 bytes
	- every function (except main) is ended with a `leave; ret` gadget.
	- `leave` is equivalent to `mov rsp, rbp; pop rbp` therefore functions end like this `mov rsp, rbp;pop rbp; pop rip`
	- This mean that when we overwrite `RIP` the 8 bytes before that overwrite `RBP`.
	- Well if we look at `leave` again, we noticed the value in RBP gets moved to RSP! So if we call overwrite RBP then overwrite RIP with the address of `leave; ret` again, the value in RBP gets moved to RSP. And, even better, we don't need any more stack space than just overwriting RIP, making it _very_ compressed.

