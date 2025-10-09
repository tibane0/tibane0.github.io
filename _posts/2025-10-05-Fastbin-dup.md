---
layout: post
title: Fastbin Exploitation
description: Explanation of the `fastbin dup` heap exploitation technique
date: 2025-10-05
categories:
  - pwn
  - notes
  - heap-exploitation
tags:
  - fastbin-dup
  - fastbin
---
# Fastbin Exploitation

### Overview

This heap exploitation technique leverages a double free vulnerability to trick the allocator into returning the same chunk twice, without freeing it in between. This technique is used to corrupt a chunk's metadata to link a fake chunk(target address) into a fastbin list.  This can be used to gain arbitrary read/write primitive.

### Fastbin Review

There are 10 fastbins which are maintained using a singly linked list. The linked list uses a Last In First Out (LIFO) manner. Each bin has chunks of the same size and the sizes are : 16, 24, 32, 40, 48, 56, 64, 72, 80 and 88. The sizes include metadata (`prev_size` and `size`). 
Consolidation does NOT happen with free fastbin size chunks.
### Double Free Vulnerability

A double free vulnerability occurs when a chunk of memory that was previously allocated is freed more than once. This is dangerous because it corrupts the allocato's data structures.

#### Mitigation

- `Fasttop` check: If the chunk being freed is at the top of the fastbin list `GLIBC` will throw an error (`double free or corruption (fasttop)`).  

```c
if (__builtin_expect (old == p, 0)) malloc_printerr ("double free or corruption (fasttop)");
```

 This is bypassed by freeing a different chunk in between the one that will be freed twice.

### Exploitation

Exploiting Double Free in fastbins. 

Fastbins are singly-linked lists used by the allocator to manage small, recently freed chunks efficiently. The progression of the fastbin list state during double free attack:
- `a` is freed: `head -> a -> tail`
- `b` is freed: `head -> b -> a -> tail` (used to bypass double free protection).
- `a` is freed again : `head -> a -> b -> a -> tail`. (chunk pointer a is now duplicated)

Because the chunk pointer for a has been duplicated in the free list, the heap allocater will hand out the same memory address multiple times when more chunks of the same size are allocated. 

if subsequent allocations are requested, the allocator will hand out chunks like this:

- `c = malloc(size)` returns chunk `a`
- `d = malloc(size)` returns chunk`b`
- `e = malloc(size)` returns chunk `a` again (same address as `c`)

Since two pointers now point to the same exact location in memory, an attacker can manipulate the content of that memory through one pointer, while the allocator still manages the block via the other pointer.

#### Arbitrary Write/Read

The goal of the fastbin dup technique is to achieve arbitrary read/write primitive, which is often achieved through fastbin corruption.

When a chunk is freed, its forward pointer (`fd`) points to the next free chunk in the list. By controlling a chunk that is in the fastbin list, you can overwrite the `fd` pointer to point to an arbitrary, controlled memory address.

When a new allocation of that size is made, the allocator will return the applied arbitrary memory address. 

#### Code Execution



## Write Targets
So which targets would we wish to overwrite?
- `__free_hook`
- `__malloc_hook`
- Global Offset Table (GOT)