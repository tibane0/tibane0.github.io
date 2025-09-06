---
layout: default
title: Double Free
tags:
  - pwn
  - heap
---
# Double Free

This technique is used as part or a exploit technique
## Metadata corruption

heap chunk
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

in double free we attempt to control `fd`. By overwriting it with our desired memory address, we can tell `malloc()` where the next chunk is to be allocated.
Example : if we overwrote `fd` of `a` with `0xdeadbeef` ; one `a` is free, the next chunk on the list will be `0xdeadbeef`.

### Controlling `fd`
Vulnerable code
```c
#include <stdio.h>
#include <stdlib.h>


int main() {
	char *a, *b, *c;
	a = malloc(8);
	b = malloc(8);
	printf("a ptr : %p\nb ptr : %p\n", a, b);
	

	free(a);
	free(b);
	free(a);
	
	printf("Double free of a performend with b in between to bypass \"(double free or corruption) fasttop protection\"\n");
	
	c = malloc(8);
	printf("c ptr : %p\n", c);
	return 0;
}

```


```sh
./chall 
a ptr : 0x804b008
b ptr : 0x804b018
Double free of a performend with b in between to bypass "(double free or corruption) fasttop protection"
c ptr : 0x804b008
```
a is both freed and in use

The heap attempts to save as much space as possible and when the chunk is free the `fd` pointer is written **where the user data used to be**.

Allocated
```c
struct malloc_allocated_chunk {
INTERNAL_SIZE_T      mchunk_prev_size;
INTERNAL_SIZE_T      mchunk_size; 
void data; // mchunk_size
}
```

Freed
```c
struct malloc_free_chunk {
INTERNAL_SIZE_T      mchunk_prev_size;
INTERNAL_SIZE_T      mchunk_size;  
struct malloc_chunk* fd; // to next free chunk in list
struct malloc_chunk* bk; // prev free chunk in list
}
```

So when we write into the use data of `c` we are writing into the `fd` of `a` at the same time, and this means we control where the next chunks gets allocated.
### Exploiting 
#### steps
1. allocate 2 ptrs
2. free ptr a, then b, then a again
3. allocate ptr a (with fake metadata (addr))
4. allocate 2 chunks a, b
5. allocate 1 more (overwrite)

## User data corruption

Vulnerable code
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
	char *a, *b, *c, *d, *e, *f;
	a = malloc(8);
	b = malloc(8);
	c = malloc(8);

	printf("a PTR : %p\n", a);
	printf("b PTR : %p\n", b);
       	printf("c PTR : %p\n", c);

	free(a);
	free(b);
	free(a);
	printf("double free a and b in between to bypass \"double free or corruption (fasttop protection)\" \n");

	d = malloc(8);
	e = malloc(8);
	f = malloc(8);

	printf("d PTR : %p\n", d);
	printf("e PTR : %p\n", e);
	printf("f PTR : %p\n", f);
			

	return 0;
}
```

Output

```sh
./chall 
a PTR : 0x804b008
b PTR : 0x804b018
c PTR : 0x804b028
double free a and b in between to bypass "double free or corruption (fasttop protection)" 
d PTR : 0x804b008
e PTR : 0x804b018
f PTR : 0x804b008
```

Notice how d and f pointers point to the same memory address. any changes in one will affect the other

What happened

```
1. a is freed
   head -> a -> tail | fastbin
2. b is freed
   head -> b -> a -> tail | fastbin
3. a is freed again
   head -> a -> b -> a -> tail | fastbin
4. malloc request for d
   head -> b -> a -> tail | fastbin (a is returned)
5. malloc request for e
	head -> a -> tail | fastbin (b is returned)
6. malloc request for f 
	head -> tail | fastbin (a is returned)
```

