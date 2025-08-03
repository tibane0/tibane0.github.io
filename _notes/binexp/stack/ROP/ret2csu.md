---
layout: default
title: Univeral ROP (ret2csu)
tags:
  - pwn
---
# Ret2csu 

`ret2csu` (return to `__libc_csu_init`) is an advanced ROP technique used when you have limited gadgets available in a binary. It leverages the initialization functions in the .init section of ELF binaries to construct ROP chains.


## How this technique works.
The technique exploits two useful functions in the `__libc_csu_init` section found in most linux binaries.
1. The functions contains a sequence of `pop` instructions that can set multiple registers.
2. It also contains useful `mov` instructions that can move values between registers

### Typical gadgets found

```
pop rbx
pop rbp
pop r12
pop r13
pop r14
pop r15
ret

 mov rdx, r15
mov rsi, r14
mov edi, r13d
call qword ptr [r12 + rbx*8]
```


## Why use this technique?

This technique is useful when:
- the binary is small with few gadgets
- aslr is enabled (but you have a libc leak)


## Example
