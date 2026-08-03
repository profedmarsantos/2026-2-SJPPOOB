#include <stdio.h>

#define SIZE 5

int main()
{
    float media;
    float nota[SIZE];//vetor
    float soma = 0;

    printf("\n\n");

    for(int i=0; i<SIZE; i++)
    {
        printf("\nDigite n%d: ",i+1);
        scanf("%f",&nota[i]);
        soma += nota[i];
    }
    media = soma/SIZE;
    printf("\n\nA media eh: %.2f",media);
    if (media >= 6)
        printf("\n>> Aprovado :)");
    else if (media >=4)
        printf("\n>> Recuperacao :|");
    else
        printf("\n>> Nao foi dessa vez :(");
    printf("\n\n");
    return 0;
}
