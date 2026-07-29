#include <stdio.h>
int main(){
    float d, v, t;

    printf("Digite o valor da velocidade: ");
    scanf("%f",&v);

    printf("Digite o valor do tempo: ");
    scanf("%f",&t);

    d = v * t;

    printf("\nO valor da distancia e: %.2f",d);

    return 0;
}
