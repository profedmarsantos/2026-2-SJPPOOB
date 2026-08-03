#include <stdio.h>
int main()
{
    int dia, h = 0, m = 0, t = 0;

    printf("\nSJPALPR: Prova 1 - 22/04/2026");
    printf("\n\nPROBLEMA: O BOTECO DO JOAO");
    printf("\n\nQue dia voce quer calcular? (1 - sab) ou (2 - dom) ");
    scanf("%d",&dia);

    if (dia == 1)
    {
        printf("\nDigite o numero de mulheres no baile: ");
        scanf("%d",&m);
        h = (m * 3) / 4;
    }
    else if (dia == 2)
    {
        printf("\nDigite o numero de homens no baile: ");
        scanf("%d",&h);
        m = (h * 8) / 5;
    }
    else
    {
        printf("\n\nEssa opcao nao existe! O boteco esta fechado!");
    }

    t = h + m;

    printf("\n\n");
    printf("\n======= TOTAL DE PESSOAS NO BAILE =======");
    if (dia == 1)
    {
        printf("\n\nSABADO:");
    }
    else if (dia == 2)
    {
        printf("\n\nDOMINGO:");
    }
    else
    {
        printf("\n\nDIA FECHADO");
    }

    printf("\n");
    printf("\nO total de mulheres eh:             %5d",m);
    printf("\nO total de homens eh:               %5d",h);
    printf("\n");
    printf("\nTOTAL:                                   ");
    printf("\nO total de pessoas eh:              %5d",t);
    printf("\n");
    printf("\n=========================================");
    printf("\n\n");

    return 0;
}
