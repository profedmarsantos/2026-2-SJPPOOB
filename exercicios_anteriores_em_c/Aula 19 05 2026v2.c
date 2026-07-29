#include <stdio.h>

struct dia{
    int min;
    int max;
};

int main()
{
    int tamanaho;
    struct dia penultimaSemana[7];


    for(int i=0; i<7; i++)
    {
        printf("========================");
        printf("\nLeitura do dia: %d", i);

        printf("\n---Digite a temp. min: ");
        scanf("%d",&penultimaSemana[i].min);

        printf("\n---Digite a temp. max: ");
        scanf("%d",&penultimaSemana[i].max);
    }


    //mostrar
    printf("\n\n");
    for(int i=0; i<7; i++)
    {
        printf("\n========================");
        printf("\nValores do dia: %d", i);

        printf("\n---Digite a temp. min: %d",penultimaSemana[i].min);

        printf("\n---Digite a temp. max: %d",penultimaSemana[i].max);
    }



    return 0;
}
