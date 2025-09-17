---
layout: default
title:
tags: 

---
# Heap Consolidation


This is the process of combining adjacent free chunks, and used to prevent fragmentation

- This does not happen with `tcache` and `fastbin`

## Process 
- Removes chunks from other bins `(unlink)`
- combines chunks
- add new combined chunk back into a bin

This is determined by  the `prev_inuse` bit on the metadata of the chunk

---


```c

#include <stdio.h>
#include <stdlib.h>


int main() {
	char *a, *b;
	a = malloc(0x88);
	b = malloc(0x88);

	free(b);
	
	b = malloc(0x88)
	return 0;
}
```

Often freed chunks that adjacent to the top chunk are combined to the top chunk

