#include <stdio.h>

int produto_escalar(const int *vetor1, const int *vetor2) {
    int resultado = 0;
    for (int i = 0; i < 7; i++) {
        resultado += vetor1[i] * vetor2[i];
    }
    return resultado;
}

int main() {
    int n;

    int vector1[] = {5, 8, 0, 2, 1, 5,3};

    int vector2[] = {7, 6, 1, 0, 4, 1,2};

    int resultado = produto_escalar(vector1, vector2);

    return 0;
}
