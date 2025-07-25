---
layout: default
title: Out of bounds
tags:
  - pwn
---



# Out of bounds vulnerability
An out-of-bounds vulnerability is a security bug in software that occurs when a program tries to read or write data to a memory that falls outside the designated boundaries of a array or buffer.

## Out of Bounds Writes
Happens when a program writes outside the designated boundaries of the array or buffer. This security vulnerability can lead the following:
- Arbitrary Code Execution
- Denial of Service
- Data Corruption
- Simple Program Crash

### Exploiting Out-of-Bounds Write
>  Consider the following code snippet

```c
void wunsafe() {
    int x;
    char names[5][32] = {0};
    int index;
    char buffer[32];
    for (int i = 0; i < sizeof(names)/sizeof(names[0]);i++) {
        memset(buffer, 0 , sizeof(buffer));
        printf("Index to store name: ");
        fflush(stdout);
        fgets(buffer, sizeof(buffer) -1 , stdin);
        index = atoi(buffer);
        memset(buffer, 0, sizeof(buffer));
        printf("Enter Name: ");
        fflush(stdout);
        fgets(buffer, sizeof(buffer) -1, stdin);
        buffer[strcspn(buffer, "\n")] = 0;
        strncpy(names[index], buffer, sizeof(buffer)); 
    }
    // print all names
    puts("Names");
    for (int i = 0; i < sizeof(names)/sizeof(names[0]);i++) {
        printf("%d. %s \n", i+1, names[i]);
    }
    if (x == 0xdeadbeef) {
        puts("Here is a shell");
        win();
    } else {
        puts("You lose");
    }
}
```

compile with `gcc -O0 -fno-stack-protector -fPIE -no-pie -z execstack -m32 oob.c `

> Stack before input

![](/assets/images/oob-write-stack.jpg)



### Mitigation

## Out of Bounds Reads
Happens when a program reads data from a memory location that is beyond the end of an array. This is a information disclosure vulnerability as it can lead to attackers reading sensitive information. 
### Exploiting Out-of-Bounds Read 

> Consider the following code snippet

```c
char password[32] = "supersecretpassword"; 
char names[5][32] = {"john", "kevin", "Neo", "Tim", "Mia"};
int index;
puts("Enter Index: ");
scanf("%d", &index);
printf("Name: %s\n", names[index]);
```

Since the user controls the what index to print out the user can leak the password by entering a index greater than 4.

```sh
./a.out 
Enter Index: 
5
Name: supersecretpassword
```

if i enter 5 as index I get the password.


> Stack layout

![Out-of-bounds stack](/assets/images/oob-read-stack.jpg)

### Mitigation
To mitigate this vulnerability the program should check that the index (user input) is within the bounds of the array.

Correct way to implement 

```c
char password[32] = "supersecretpassword"; 
char names[5][32] = {"john", "kevin", "Neo", "Tim", "Mia"};
int index;
puts("Enter Index: ");
scanf("%d", &index);
if (index > 4 || index < 0) {
	puts("Invalid Index");
	return;
}
printf("Name: %s\n", names[index]);
```
