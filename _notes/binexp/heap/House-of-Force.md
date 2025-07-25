
# House of Force


The following conditions must be met:
- Glibc version < 2.27
- heap based overflow to overwrite the top chunks size field
- malloc call with a controlled size
- another malloc call where data is controlled


This technique is dependent on the top chunk. 
The top chunk is the end of the heap and it is the only heap chunk that can be extended or shortened, so the top chunks must always exist. (cant be freed)

Vulnerable code

```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void vuln();
void win();
int main() {
	vuln();
}
void win() {
	system("/bin/sh");
}

void vuln() {
	char *ptr1, *ptr2, *ptr3;
	// malloc 1 and overflow
	ptr1 = malloc(0x20);
	printf("PTR1 = [%p] : ", ptr1);
	fflush(stdout);
	fgets(ptr1, 0x200, stdin);
	
	// malloc with controlled size
	char len[4];
	printf("Enter len: ");
	fflush(stdout);
	fgets(len, 4, stdin);
	ptr2 = malloc(atoi(len));
	printf("Allocated MEM: %lu bytes as [%p]\n", atoi(len), ptr2);
	fflush(stdout);
	// malloc with attacker controlled data
	ptr3 = malloc(0x20);
	printf("PTR3 = [%p] : ", ptr3);
	fflush(stdout);
	fgets(ptr3, 0x200, stdin);
}
```

```sh
gcc -m32 -fno-stack-protector -z execstack -no-pie -Wl,-z,norelro -o hof hof.c
```


The aim of this techniqure is to overwrite 

The top chunk size field should have the highest size possible (0xffffffff), 


## Steps
1. Overwrite the top chunk
	- malloc 1 (buffer overflow)
	- overflow into the top chunk size field with a large value (0xffffffffffff)
	- random data (size of malloc called) + 0xffffffff (largest possible value)
2. Calculate distance 
	- calculate the distance between the current heap location and the target address we want to overwrite. 
	- this allows the shift the top chunk address near the target address that has to be overwritten
3. Overwrite the target address
	- Enter data from current chunk until overflow into target address.




## Resources 
https://gbmaster.wordpress.com/2015/06/28/x86-exploitation-101-house-of-force-jedi-overflow/

https://ctf-wiki.mahaloz.re/pwn/linux/glibc-heap/house_of_force/

https://ctf-wiki.mahaloz.re/pwn/

https://www.bordergate.co.uk/heap-exploitation-the-house-of-force/