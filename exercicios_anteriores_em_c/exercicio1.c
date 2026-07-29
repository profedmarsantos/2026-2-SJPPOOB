#include <stdio.h>
int main(){
    float total, preco;
    int paes;

    printf("Digite quantos paes vai levar: ");
    scanf("%d",&paes);

    printf("Digite qual o preço: ");
    scanf("%f",&preco);

    total = paes * preco;

    printf("O total e: %f",total);


    return 0;
}
