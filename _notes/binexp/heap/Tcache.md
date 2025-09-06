---
layout: default
title: Tcache
tags:
  - pwn
  - heap
---

# Tcache

Thread Local Caching in `ptmalloc`, to speed up repeated small allocations in a single threads

Implemented as a singly-linked list, with each thread having a list header for different-sized allocations

```c
typedef struct tcache_per_thread_struct {
char counts[TCACHE_MAX_BINS];
tcache_entry *entries[TCACHE_MAX_BINS];
tcache_perthread_struct;
} tcache_perthread_struc;
```


```c
typedef struct tcache_entry {
	struct tcache_entry *next; 
} tcache_entry;
```




