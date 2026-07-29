#include <stdio.h>
#include <stdlib.h>
float totalCaixa = 0.0;
int veiculos = 0;
int vouchers = 0;
void exibirMenu() {
    printf("\n---- MENU POSTO -----\n");
    printf("A - Alcool\n");
    printf("G - Gasolina\n");
    printf("F - Finalizar Sistema\n");
    printf("---------------------\n");
    printf("\nEscolha uma opcao: ");
}
void gerenciarNavegacao() {
    system("pause");
    system("cls");
}
void processarAbastecimento(float preco, float limiteVoucher) {
    float litros, valorPagar;
    printf("\nDigite a quantidade de litros: ");
    scanf("%f", &litros);
    valorPagar = litros * preco;
    totalCaixa += valorPagar;
    veiculos++;
    printf("\nValor a pagar: R$ %.2f\n", valorPagar);
    if (litros >= limiteVoucher) {
        printf("Parabens! Voce ganhou um voucher de ducha.\n\n");
        vouchers++;
    }
    gerenciarNavegacao();
}
void encerrarSistema() {
    printf("\nSistema encerrado com sucesso!\n");
    printf("Total de veiculos atendidos: %d\n", veiculos);
    printf("Total acumulado no caixa: R$ %.2f\n", totalCaixa);
    printf("Total de vouchers concedidos: %d\n", vouchers);
}
void tratarErro() {
    printf("\nOpcao invalida! Tente novamente.\n\n");
    gerenciarNavegacao();
}
int main() {
    char opcao;
    do {
        exibirMenu();
        scanf(" %c", &opcao);
        switch(opcao) {
            case 'A':
            case 'a':
                processarAbastecimento(4.50, 20.0);
                break;
            case 'G':
            case 'g':
                processarAbastecimento(5.80, 10.0);
                break;
            case 'F':
            case 'f':
                encerrarSistema();
                break;
            default:
                tratarErro();
        }
    } while(opcao != 'F' && opcao != 'f');
    return 0;
}
