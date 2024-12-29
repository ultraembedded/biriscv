#include <stdio.h>


int main() {
    int vetor1[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 7};
    int vetor2[] = {7, 1, 8, 7, 6, 5, 4, 3, 2, 1};

    int vetor_soma[10];
    int vetor_produto[10];

    // Multiplicacao ingenua
    for (int i = 0; i < 10; i++) {
        vetor_produto[i] = vetor1[i] * vetor2[i];
    }

    // Soma
    for (int i = 0; i < 10; i++) {
        vetor_soma[i] = vetor1[i] + vetor2[i];
    }


    return 0;
}