#include <stdio.h>
int main(){
    int min;
    float litros;

    printf("Digite quantos minutos a torneira ficou aberta: ");
    scanf("%d",&min);

    litros = min*30;

    printf("\nO total de litros e: %.2f",litros);

    return 0;
}
