#include <stdio.h>
int main(){
    float precoOriginal, precoDesconto;

    printf("Digite o preco da mercadoria: ");
    scanf("%f",&precoOriginal);

    precoDesconto = precoOriginal-(precoOriginal*(0.18));

    printf("O preco com desconto e: %.2f",precoDesconto);


    return 0;
}
