---
layout: default
title: Heap
tags:
  - pwn
---
# Heap
The heap is an area of memory that can be dynamically allocated. This means the program can request and release memory from the heap whenever it requires. Heap memory is global (it can be accessed and modified from anywhere within a program) and this is accomplished using pointers to reference dynamic allocated memory.

In C, the `stdlib.h` provides functions to access, modify, and manage dynamic memory.

- `malloc(size_t n)` : used to request heap memory and returns a pointer to a the allocated chunk of n bytes or null if no space is available.
- `free(void* p)` : releases the chunk of memory pointed to by p.

## `Glibc heap`

### Chunks
Every chunk whether free or allocated is stored in a `malloc_chunk` structure, the difference is how the memory is used. Each chunk as additional metadata that is has to store in both its used and free states.

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


#### Allocated Chunks

```c
struct malloc_allocated_chunk {
INTERNAL_SIZE_T      mchunk_prev_size;
INTERNAL_SIZE_T      mchunk_size;  
void data; // mchunk_size
}
```

#### Free chunks
Free chunks maintain themselves in a circular doubly linked list.
```c
struct malloc_free_chunk {
INTERNAL_SIZE_T      mchunk_prev_size;
INTERNAL_SIZE_T      mchunk_size;  
struct malloc_chunk* fd; // to next free chunk in list
struct malloc_chunk* bk; // prev free chunk in list
}
```

#### Top chunk (Wilderness)
The top chunk is the topmost available chunk (the one bordering the end of available memory).  After a new arena is initialised a top chunk always exists and there is only ever one per arena. Requests for heap memory are only serviced from a top chunk when they can't be serviced from any other bins in the same arena.

`Malloc` keeps track of the remaining memory in a top chunk using it's size field, the `prev_inuse` bit of which is always set. A top chunk always contains enough memory to allocate a minimum-sized chunk.

#### Bins
Free chunks are stored in various lists (bins) based on size and history, so that the library can quickly find suitable chunks to satisfy allocation requests. 
##### Fast bins
- Single linked list (LIFO)
- There are 10 fast bins.

Each bin has chunks of the same size (including metadata[`prev_size`, size]).
10 bins each have chunks of sizes:  16, 24, 32, 40, 48, 56, 64, 72, 80 and 88. 

##### Unsorted bins
- There is only 1 unsorted bin.

Small and large chunks, when freed, end up in this bin. The purpose of his bin is to ac as a cache layer to speed p allocation and deallocation requests.

##### Small bins
- There are 62 small bins. 
- Doubly linked list. (FIFO)

Each bin has chunks of the same size. 
62 bins each have chunks of sizes: 16, 24, ..., 504 bytes.

##### Large bins
- There are 63 large bins.
- Doubly linked list. (FIFO)

holds large chunks with sizes greater 512.

### `malloc_state`
This is a structure that represents the header details of an arena. 

```c
struct malloc_state
{
  /* Serialize access.  */
  __libc_lock_define (, mutex);
  /* Flags (formerly in max_fast).  */
  int flags;

  /* Fastbins */
  mfastbinptr fastbinsY[NFASTBINS];
  /* Base of the topmost chunk -- not otherwise kept in a bin */
  mchunkptr top;
  /* The remainder from the most recent split of a small request */
  mchunkptr last_remainder;
  /* Normal bins packed as described above */
  mchunkptr bins[NBINS * 2 - 2];

  /* Bitmap of bins */
  unsigned int binmap[BINMAPSIZE];

  /* Linked list */
  struct malloc_state *next;
  /* Linked list for free arenas.  Access to this field is serialized
     by free_list_lock in arena.c.  */
  struct malloc_state *next_free;
  /* Number of threads attached to this arena.  0 if the arena is on
     the free list.  Access to this field is serialized by
     free_list_lock in arena.c.  */

  INTERNAL_SIZE_T attached_threads;
  /* Memory allocated from the system in this arena.  */
  INTERNAL_SIZE_T system_mem;
  INTERNAL_SIZE_T max_system_mem;
};

typedef struct malloc_state *mstate;
```


### `Arena`
An arena is a self-contained heap management structure that tracks free and allocated chunks.
##### Components of an Arena
Each arena (`malloc_state` struct) manages: 
- [Top chunk (Wilderness).](#### Top chunk (Wilderness)) : The topmost free chunk.
- [Bins]() : Free lists for recycled chunks
- Heap Segments

---
---
# Heap Exploitation

many heap exploitation use the same core concepts
- use after free
- double free 
- buffer overflow
- corrupting heap metadata
- overlapping allocations

Taking advantage of consolidation
chunks that go to the unsorted bin
-   a correctly sized large malloc can clear fastbin and cause consolidation
- 