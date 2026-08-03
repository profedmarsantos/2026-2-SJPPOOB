#include <stdio.h>

int notas[3];

void mostraVetor()
{
    for(int i=0; i<3; i++)
    {
        printf("\nO valor da posicao: notas[%d]=%d",i,notas[i]);
    }
}

void insereVetor()
{
    for(int i=0; i<3; i++)
    {
        int x;
        printf("\nDigite o numero %d: ",i+1);
        scanf("%d",&x);
        notas[i]=x;
    }
}

void initVetor()
{
    for(int i=0; i<3; i++)
    {
        notas[i]=0;
    }
}

int main()
{

    initVetor();

    mostraVetor();

    insereVetor();

    mostraVetor();

    return 0;
}
