#include <stdio.h>
#include <stdlib.h>

void menu()
{
    system("cls");
    printf("\nD - Bom dia!");
    printf("\nT - Boa tarde!");
    printf("\nN - Boa noite!");
    printf("\n- - - - - - - -");
    printf("\nF - Boa noite!\n\n");
}

//procedimento
void bd()
{
    system("cls");
    printf("\nVoce escolheu bom dia!\n\n");
}

void bt()
{
    system("cls");
    printf("\nVoce escolheu boa tarde!\n\n");
}

void bn()
{
    printf("\nVoce escolheu boa noite!\n\n");
}

int dobro(int n)
{
    int total;
    total = n * 2;
    return total;
}

int soma(int a,int b)
{
    return a+b;
}

int main()
{
    char opcao;
    do
    {
        menu();
        //perguntar que letra escolher
        printf("\nEscolha uma letra: ");
        scanf(" %c",&opcao);
        //???
        switch (opcao)
        {
        case 'd':
        case 'D':
        {
            //fazer
            bd();
            break;
        }
        case 't':
        case 'T':
        {
            //fazer
            bt();
            break;
        }
        case 'N':
        case 'n':
        {
            //fazer
            bn();
;
            break;
        }
        case 'F':
        case 'f':
        {
            //fazer
            printf("\nSaindo...!\n\n");
            break;
        }
        default:
        {
            printf("\nOpcao invalida!\n\n");
            break;
        }
        }

        system("pause");
    }
    while (opcao != 'F' && opcao!='f');

    return 0;
}
