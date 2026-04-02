#include <stdio.h>
#include <stdlib.h>

// 1. Define the struct
struct Node {
    int val;
    struct Node* left;
    struct Node* right;
};

// 2. Import your Assembly functions
extern struct Node* make_node(int val);
extern struct Node* insert(struct Node* root, int val);
extern struct Node* get(struct Node* root, int val);
extern int getAtMost(int val, struct Node* root);

int main() {
    printf("--- Testing make_node & insert ---\n");
    struct Node* root = NULL;
    
    // Insert values
    root = insert(root, 10);
    root = insert(root, 5);
    root = insert(root, 15);
    root = insert(root, 3);
    root = insert(root, 7);

    if (root != NULL && root->val == 10) {
        printf("SUCCESS: Root is %d\n", root->val);
        printf("SUCCESS: Left child is %d\n", root->left->val);
        printf("SUCCESS: Right child is %d\n", root->right->val);
    } else {
        printf("FAILED: Tree was not built correctly.\n");
    }

    printf("\n--- Testing get ---\n");
    struct Node* target = get(root, 7);
    if (target != NULL) {
        printf("SUCCESS: get(7) found node at memory %p with val %d\n", (void*)target, target->val);
    } else {
        printf("FAILED: get(7) returned NULL\n");
    }

    struct Node* missing = get(root, 99);
    if (missing == NULL) {
        printf("SUCCESS: get(99) correctly returned NULL\n");
    } else {
        printf("FAILED: get(99) hallucinated a node!\n");
    }

    printf("\n--- Testing getAtMost ---\n");
    // Should find exact match (10)
    printf("getAtMost(10): %d (Expected: 10)\n", getAtMost(10, root)); 
    
    // Should go left of 10, then right of 5, then hit NULL, keeping 7
    printf("getAtMost(8): %d (Expected: 7)\n", getAtMost(8, root));  
    
    // Way too small, should return -1
    printf("getAtMost(1): %d (Expected: -1)\n", getAtMost(1, root)); 

    return 0;
}