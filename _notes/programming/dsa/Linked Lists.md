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
			Node *node = new Node;
			if (head != nullptr) {
				node->next = head;
			}
			head = note;
		}
		
		void remove(int data) {
			if (head == nullptr) return; // if empty list
			if (head->data == value) {
	            Node* temp = head;
	            head = head->next;
	            delete temp;
	            return;
	        }
	
	        Node* current = head;
	        while (current->next && current->next->data != value) {
	            current = current->next;
	        }
	        if (current->next) {  // found
	            Node* temp = current->next;
	            current->next = current->next->next;
	            delete temp;
	        }
				
		}
		
		void print() const {
	        Node* current = head;
	        while (current) {
	            std::cout << current->data << " -> ";
	            current = current->next;
	        }
	        std::cout << "NULL\n";
	    }
	    
	    ~LinkedList() {
        while (head) {
            Node* temp = head;
            head = head->next;
            delete temp;
        }
    }
		
};

```

---
## C

--- 
## Python
