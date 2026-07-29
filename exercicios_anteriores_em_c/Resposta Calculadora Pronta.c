#include <stdio.h>
#include <stdlib.h>

float a;
float b;
float resultado;

void gerenciarNavegacao() {
    system("pause");
    system("cls");
}

void exibirMenu() {
    printf("=====================================\n");
    printf("        CALCULADORA SIMPLES          \n");
    printf("=====================================\n");
    printf(" [ + ] Adicao\n");
    printf(" [ - ] Subtracao\n");
    printf(" [ * ] Multiplicacao\n");
    printf(" [ / ] Divisao\n");
    printf(" [ S ] Sair\n");
    printf("=====================================\n");
    printf("Escolha uma opcao: ");
}

void lerValores() {
    printf("\nDigite o primeiro valor: ");
    scanf("%f", &a);
    printf("Digite o segundo valor: ");
    scanf("%f", &b);
}

void tratarErro() {
    printf("\nOpcao invalida!\n");
    printf("Utilize apenas +, -, * ou /.\n\n");
    gerenciarNavegacao();
}

void encerrarSistema() {
    printf("\nCalculadora encerrada com sucesso.\n\n");
    printf("***************************************************\n");
    printf("*      Desenvolvido por: NOME DO ALUNO            *\n");
    printf("***************************************************\n");
}

float somar(float a, float b) {
    return a + b;
}

float subtrair(float a, float b) {
    return a - b;
}

float multiplicar(float a, float b) {
    return a * b;
}

float dividir(float a, float b) {
    return a / b;
}

int main() {
    char opcao;
    do {
        exibirMenu();
        scanf(" %c", &opcao);
        switch(opcao) {
            case '+':
                printf("\nADICAO [ + ]\n");
                lerValores();
                resultado = somar(a, b);
                printf("\nResultado: %.2f\n\n", resultado);
                gerenciarNavegacao();
                break;
            case '-':
                printf("\nSUBTRACAO [ - ]\n");
                lerValores();
                resultado = subtrair(a, b);
                printf("\nResultado: %.2f\n\n", resultado);
                gerenciarNavegacao();
                break;
            case '*':
                printf("\nMULTIPLICACAO [ * ]\n");
                lerValores();
                resultado = multiplicar(a, b);
                printf("\nResultado: %.2f\n\n", resultado);
                gerenciarNavegacao();
                break;
            case '/':
                printf("\nDIVISAO [ / ]\n");
                lerValores();
                if (b == 0) {
                    printf("\nErro: divisao por zero nao e permitida.\n\n");
                } else {
                    resultado = dividir(a, b);
                    printf("\nResultado: %.2f\n\n", resultado);
                }
                gerenciarNavegacao();
                break;
            case 'S':
            case 's':
                encerrarSistema();
                break;
            default:
                tratarErro();
        }
    } while(opcao != 'S' && opcao != 's');
    return 0;
}