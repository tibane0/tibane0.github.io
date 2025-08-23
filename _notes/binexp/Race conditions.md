---
layout: default
title: Race Conditions
tags:
  - pwn
---
# Race Condition
A race condition is where the system's substantive behavior is dependent on the sequence of timing of other uncontrollable events

**Security Vulnerability Race condition:** when the system's substantive behavior is dependent on the sequence or timing of attacker-controllable events

Attackers exploit race conditions  by changing the state that a program is running in while the program assumes that the state has not been changed
## Root causes for race conditions
- Shared resources
	- Volatile memory (DRAM)
	- Non-Volatile Memory (filesystem, etc) 
- Parallelism
	- The faux-parallelism (multi-threading)
		- 2+ clients talking to the same server
		- 2+ tabs executing javascript in the same browser
		- 2+ userspace threads/apps executing syscalls in same OS
		- 2+ OSes running in the same hypervisor
	- The true-parallelism (multi-processing)
		- 2+ CPU cores executing in parallel in the same System on a Chip
		- 2+ chips on a shared bus
## Double fetch 
A vulnerability when data is accessed multiple times. 

### TOCTOU Vulnerability
Not all TOCTOU vulnerabilities are Double fetch

TOCTOU (Time of check / Time of use) is a class of software bugs caused by race conditions involving the checking of the state of a part of a system and the use of the results of that check.

TOCTOU race conditions are common in Unix between operations on the file system but can occur in other contexts, including local sockets and improper use of database transactions. 

```c
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>

void check_input(char *filename) {
	int i;
	FILE *fp = fopen(filename, "r");
	fscanf(fp, "%d", &i);
	fclose(fp);
	assert(i == 0);
}

void do_action(char *filename) {
	int i;
	FILE *fp = fopen(filename, "r");
	fscanf(fp, "%d", &i);
	fclose(fp);
	
	i++;
	fp = fopen(filename, "w");
	fprintf(fp, "%d\n", i);
	printf("Wrote %d.\n", i);
	fclose(fp);
}

int main(int argc, char **argv) {
	check_input(argv[1]);
	do_action(argv[1]);
	return 0;
}
```

run on loop
```sh
while :; do ./toctou num; done 2>/dev/null
```

other terminal

```sh
while :; do echo 0 > num ; done 2>/dev/null
```

```sh
while :; do echo 1 > num ; done 2>/dev/null
```

---
## Races in the filesystem
---
## Races in Memory
memory is a shared resource between threads.

--- 
## Resources
- [Samclass on Race conditions](https://samsclass.info/127/proj/ED210.htm) 
- [pwn college](https://pwn.college/system-security/race-conditions/)

