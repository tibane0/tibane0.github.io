

In `glibc 2.34+`  gadgets like `pop rdi` are not present.

The `__libc_csu_init` function is not present in binaries compiled with `glibc 2.34+` therefore the  `pop rdi; ret` gadget  is not present, this is designed to remove useful ROP gadgets. 

address of `pop r15; ret` + 1 is equal to the address of `pop rdi; ret`



--- 



---
## Reference

[ret2gets](https://sashactf.gitbook.io/pwn-notes/pwn/rop-2.34+/ret2gets#exploit-techniques)
