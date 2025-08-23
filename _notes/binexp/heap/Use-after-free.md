---
layout: default
title: use-after-free
tags:
  - pwn
---
# Use after free

Much like the name suggests, this technique involves us _using data once it is freed_. The weakness here is that programmers often wrongly assume that once the chunk is freed it cannot be used and don't bother writing checks to ensure data is not freed. This means it is possible to write data to a free chunk, which is very dangerous.

`UAF`  happens when a program continues to use a pointer after the memory it points to has been freed. can lead to 
- Crashes
- arbitrary code execution
- information disclosure
##  Typical `UAF` Flow
1. Allocate memory (`malloc`, `new`)
2. Use it normally
3. Free it (`free`, `delete`)
4. Use it again! 


## HOW `UAF` is exploited
- reallocated the freed chunk with attacker-controlled data
- overwrite function pointers, vtables, hooks, etc
- hijack execution flow


---
## `UAF` to Code Execution


