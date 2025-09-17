---
layout: default
title: Tcache
tags:
  - pwn
  - heap
---

# Tcache
Thread Local Caching in `ptmalloc`, was introduced  to speed up repeated small allocations `(up to size 0x410)` which has its own `tcache` bin, which stores up to 7 chunks in a single thread. When chunks that fall within size of `tcache` bins are freed, they are added to the `tcache` bins,  if the `tcache` bins are full then the chunks go to the standard bins. 


Implemented as a singly-linked list, with each thread having a list header for different-sized allocations

```c
typedef struct tcache_perthread_struct {
	char counts[TCACHE_MAX_BINS];
	tcache_entry *entries[TCACHE_MAX_BINS];
	
} tcache_perthread_struct;
```


```c
typedef struct tcache_entry {
	struct tcache_entry *next; 
	/* This field exists to detect double frees. */  
	uintptr_t key;_
} tcache_entry;
```


`tcache_entry` structures are created and placed inside heap chunks when the chunks are freed.  New `tcache` entries are added onto the start of the singly linked list. `LIFO`



--- 
## Tcache Corruption

1. Heap setup 
	- allocate several chunks of the same size and free them. `tcache size`
2. Corruption
	- Use a vulnerability to overwrite the `tcache_entry's` next pointer inside one of the freed chunks. 
	- Overwrite and change to target memory location.
3. Controlled allocation
	- `malloc` 1 is normal
	- `malloc` 2 follows the corrupted next pointer and returns a chunk corresponding to the attacker's chosen target address
4. Hijack execution 
	- write data at the target address

--- 
## Tcache poisioning

- allocate 2 or more heap buffers (within tcache bin)
- free the buffers
	- tcache bin `[ buffer_addr1 -> buffer_addr2 ]` 
- overwrite first 8 bytes (fd) of `buffer_addr1` to point to target address
	- tcache bin `[ buffer_addr1 -> (target_addr) ]`
- allocate first buffer
	- tcache bin `[ target_addr ]`
- allocate second buffer
	- now you get control