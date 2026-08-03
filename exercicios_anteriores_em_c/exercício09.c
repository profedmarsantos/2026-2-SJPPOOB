#include <stdio.h>
int main(){
    float vD, acrescimo, vA;

    printf("Digite o valor da divida: ");
    scanf("%f",&vD);

    printf("Digite o valor do acrescimo: ");
    scanf("%f",&acrescimo);

    vA = vD +(vD*(acrescimo/100));

    printf("O valor da divida atual e: %.2f",vA);


    return 0;
}
