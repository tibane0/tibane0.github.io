---
layout: default
title: House-of-mind
tags:
  - pwn
---

# House of mind
This technique works by tricking the `glibc malloc` to use a fake arena. The fake arena is constructed in such a way that unsorted bins's `fd` contains the address of a `GOT` entry of free. Thus now when the program free's a chunk the `GOT` entry of free is overwritten. After the successful `GOT` overwrite, now when free is called, the address that overwrites the `GOT` entry will be executed.

### Conditions



```c
void public_fREe(Void_t* mem)
{
  mstate ar_ptr;
  mchunkptr p;                          /* chunk corresponding to mem */

  p = mem2chunk(mem);

  ar_ptr = arena_for_chunk(p);

  _int_free(ar_ptr, mem);
  (void)mutex_unlock(&ar_ptr->mutex);
}

#define HEAP_MAX_SIZE (1024*1024) /* must be a power of two */

#define heap_for_ptr(ptr) \
 ((heap_info *)((unsigned long)(ptr) & ~(HEAP_MAX_SIZE-1)))

/* check for chunk from non-main arena */
#define chunk_non_main_arena(p) ((p)->size & NON_MAIN_ARENA)

#define arena_for_chunk(ptr) \
 (chunk_non_main_arena(ptr) ? heap_for_ptr(ptr)->ar_ptr : &main_arena)
```



https://sivaramaaa.gitbooks.io/heap-vudo/content/chapter1.html

https://phrack.org/issues/66/10

https://sploitfun.wordpress.com/2015/02/10/understanding-glibc-malloc/

https://sploitfun.wordpress.com/2015/03/04/heap-overflow-using-malloc-maleficarum/

https://0x434b.dev/overview-of-glibc-heap-exploitation-techniques/