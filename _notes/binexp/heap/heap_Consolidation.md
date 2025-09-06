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

