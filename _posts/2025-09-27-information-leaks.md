---
layout: post
title: Information Disclosure
description:
date: 2025-09-27
categories:
  - pwn
  - notes
  - info-leaks
tags:
  - info-leak
---
# Information/Memory Leaks In Binary Exploitation


## What is a memory leak?
A **information/memory leak** is any primitive in a binary that reveals bytes from the program's memory such as addresses, pointers, strings and even metadata. Information leaks help bypass security mitigations such as Address Space Layout Randomiation (ASLR), Position Independent Executable (PIE), etc. by giving you an pointer that you can use to compute a base address such libc, PIE, heap, etc. base addresses

## Why do they matter?

- The can be used to bypass exploit mitigations that depend on randomization such as ASLR or stack canaries.
- They can disclose information meant to be secrets in memory.

## Common leak Primitives

### Uninitialized Data Access (UDA)

When a program uses a local variable that has not been explicitly initialized, it may contain data left over from previous stack frames. If this initialized variable is used and printed to the user, it can leak information like memory addresses or user data.
### Format String Read

### Return Oriented Programming (ROP)

#### Ret2plt
The goal of this technique is to call `puts` or `printf` with the Global Offset Table (GOT) entry of a libc function to print its resolved address. The leaked address/pointer can be used to compute `libc_base` address. 

Process:
1. Overflow into saved return address.
2. Call `puts@plt` or `printf@plt` with GOT entry.
3. Return to main.
4. Use leak to compute `libc_base` address
	- e.g. lets say we leaked the GOT entry for `puts` then `libc_base = leaked_address - libc.symbols['puts]`
5. Use leak to pwn the binary.

Payload Example (pwntools)

```python
payload = flat(
	cyclic(offset), # offset = overflow offset to saved return address
	pop_rdi, # 'pop rdi; ret' gadget
	puts_got, # puts GOT entry | into rdi register
	puts_plt, # call puts 
	main_addr, # return to main to send second stage
)
# recv leak and unpack
leak = u64(io.recvline().strip().ljust(8, b"\x00"))
# compute libc base
libc.address = leak - libc.symbols['puts']
# from here use libc base to get shell
second_stage_payload = flat(
	cyclic(offset),
	pop_rdi,
	next(libc.search(b"/bin/sh")),
	libc.symbols['system']
)
# send second stage and get shell
```

#### Write Syscall
If a binary exports a `write` or has the `syscall` gadget, you can directly write raw memory to standard output `stdout`. This is useful when RELRO prevents GOT modification or when you want to avoid PLT resolution issues.

This technique needs the following gadgets:
- `pop rdi` -> 1 (stdout)
- `pop rsi` -> target address
- `pop rdx` -> size

If the gadgets are not available you can use the [ret2csu](https://ir0nstone.gitbook.io/notes/binexp/stack/ret2csu) technique to populate those registers.

Process:
- Overflow into saved return address
- populate the registers.
- call `write`. If `write` is not exported the populate the `rax/eax` registers with correct system call number and call the `syscall` gadget.

Example

```python
# if write plt is available
payload = flat(
	cyclic(offset), #  offset = overflow offset to saved return address
	pop_rdi_rsi_rdx, # `pop rdi; pop rsi; pop rdx` gadgets
	0x1, #rdi
	target_addr, #rsi
	0x20, # rdx
	write_plt 
)
# or
payload = flat(
	cyclic(offset), #  offset = overflow offset to saved return address
	pop_rdi_rsi_rdx, # `pop rdi; pop rsi; pop rdx` gadgets
	0x1, #rdi
	target_addr, #rsi
	0x20, # rdx
	pop_rax,
	syscall_write_num,
	syscall_gadget
)
```

### Use-After-Free

#### Libc leak via unsorted bin

A common technique to get libc leak is to free a big chunk (larger than 0x400 bytes) so it gets into the unsorted bin. The unsorted bin is a doubly linked list and its list head is stored in the libc's data section, when we free a chunk into the unsorted bin for the first time, its backward pointer (`bk`) then points into the libc, at a known offset. If we can leak this pointer, than we can compute the base address of libc.

**What If we do not control the size of the heap memory allocations?**

A double free vulnerability would be used to get an chunk that overlaps with another chunk's metadata, this way we can modify the chunk's metadata to make the allocator think it is a big chunk and place it in the unsorted bin upon freeing it.

A small problem is that when a chunk is allocated if it borders the top chunk of the heap, it is placed back into the top chunk when we free it. We can prevent this by placing a another chunk (often called a guard chunk) between our big chunk and the top chunk without freeing it, this prevent the allocator from returning the big chunk to the top of the heap, thus placing it in a bin.

free chunk structure

```c
struct malloc_chunk {
  INTERNAL_SIZE_T      mchunk_prev_size;  /* Size of previous chunk, if it is free. */
  INTERNAL_SIZE_T      mchunk_size;       /* Size in bytes, including overhead. */
  struct malloc_chunk* fd;                /* double links -- used only if this chunk is free. */
  struct malloc_chunk* bk;
  /* Only used for large blocks: pointer to next larger size.  */
  struct malloc_chunk* fd_nextsize; /* double links -- used only if this chunk is free. */
  struct malloc_chunk* bk_nextsize;
};

typedef struct malloc_chunk* mchunkptr;
```

The address/pointer that will help compute the libc base address is at offset :

 **32 bit**
  
```c
// metadata
prev_size; // -0x8
size; // -0x4
// end metadata
fd; // 0x0
bk; // 0x4
fd_nextsize; // 0x8
bk_nextsize; // 0xc
```

At offset `0xc`

**64 bit**
```c
prev_size; // -0x10
size; // -0x8
// end metadata
fd; // 0x0
bk; // 0x8
fd_nextsize; // 0x10
bk_nextsize; // 0x18
```

At offset `0x18`

Steps:
- Allocate 9 chunks 
	- chunks from 1 to 7 will be used to fill tcache
	- chunk 8 will be placed in unsorted bin when freed
	- chunk 9 prevents top chunk consolidation
- Free the first 8 chunks
- Use a use after free of the chunk that is in the unsorted bin to leak the `bk` pointer which will be a libc addres
- Use the libc address to calculate libc base address.


Example

```c

```


### Stack/Heap Over-read
- 

### Out-Of-Bounds Read
- 