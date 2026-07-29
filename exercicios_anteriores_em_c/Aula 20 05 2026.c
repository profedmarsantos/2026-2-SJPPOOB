#include <stdio.h>
#include <stdlib.h>
void bom_dia()//D ou d
{
    system("cls");
    printf("\n===============");
    printf("\n     Bom dia!   ");
    printf("\n===============");
    printf("\n\n");
}

void boa_noite()//N ou n
{
    system("cls");
    printf("\n===============");
    printf("\n   Boa noite!   ");
    printf("\n===============");
    printf("\n\n");
}

void menu()
{
    printf("\nD - Bom dia");
    printf("\nN - Boa noite");
    printf("\nS - Fecha o programa\n");
}

int main()
{
    char opcao;
    do
    {
        system("cls");
        menu();
        printf("\nDigite a opcao desejada: ");
        scanf(" %c", &opcao);
        switch (opcao)
        {
            case 'D':
            case 'd':
                {
                    bom_dia();
                    system("pause");
                    break;
                }
            case 'N':
            case 'n':
                {
                    boa_noite();
                    system("pause");
                    break;
                }
            case 'S':
            case 's':
                {
                    return 0;
                }
            default:
                {
                    printf("\nOpcao invalida!!!\n\n");
                    system("pause");
                    break;
                }
        }
    }
    while (1);
    return 0;
}
