---
layout: default
title: Linked Lists
tags:
  - Data-Structures
---

A linked list is a list where the nodes are linked together.
Each node contains data and a pointer.
They are linked together in a way that each node points to where in memory the next node is placed.

A big benefit with using linked lists is that nodes are stored wherever there is free memory, the nodes do not have to be stored contiguously right after each other like in an array.

### Advantages
- Linked list have dynamic size, which allows them to grow or shrink during runtime
- 

---
## C++

```cpp
struct Node {
	int data;
	Node* next;
};

class LinkedList {
	private:
		Node* head; // first node
	public:
		LinkedList() : head(nullptr) {} // empty list
		
		void insert(int data) {
			Node *node new Node(data);
			if (!head) {
				head = node; // set head if list is empty
			} else {
				Node* last = head;
				while (last->next) {
					last = last->next; // traverse to end
				}
				last-next = node; // append new node
			}
		}
		
		void push_front(int data) {
			Node *node = new Node(data);
			if (head != nullptr) {
				node->next = head;
			}
			head = note;
		}
		
		void delete(int data) {
			if (head == nullptr) return; // if empty list
		}
		
		
};

```

---
## C

--- 
## Python
