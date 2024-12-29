// C Program to swap bits
// in a given number

// Fonte: https://www.geeksforgeeks.org/swap-bits-in-a-given-number/?ref=shm

#include <stdio.h>
 

/* Driver program to test above function*/
int main()
{


    unsigned int x = 28;
    unsigned int p1 = 0;
    unsigned int p2 = 3;
    unsigned int n = 2;

    /* Move all bits of first set to rightmost side */
    unsigned int set1 = (x >> p1) & ((1U << n) - 1);
 
    /* Move all bits of second set to rightmost side */
    unsigned int set2 = (x >> p2) & ((1U << n) - 1);
 
    /* XOR the two sets */
    unsigned int xor = (set1 ^ set2);
 
    /* Put the xor bits back to their original positions */
    xor = (xor << p1) | (xor << p2);
 
    /* XOR the 'xor' with the original number so that the 
       two sets are swapped */
    unsigned int result = x ^ xor;
    
    return 0;
}