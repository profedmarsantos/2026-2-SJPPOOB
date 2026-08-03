#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

/* Prototipos das Funcoes */
void exibirMenu();
float calcularValorBruto(char opcao, int quantidade);
float calcularDesconto(float valorBruto);
void exibirAutoria();

int main() {
    char opcao;
    int quantidade;
    
    /* Variaveis Acumuladoras (Estatisticas do Sistema) */
    int totalItensVendidos = 0;
    int totalDescontosConcedidos = 0;
    float totalCaixaAcumulado = 0.0;

    do {
        exibirMenu();
        scanf(" %c", &opcao);
        opcao = toupper(opcao); /* Converte para maiusculo para facilitar a checagem */

        switch (opcao) {
            case 'H':
                printf("\nHAMBURGUER SIMPLES [ H ]\n");
                break;
            case 'C':
                printf("\nCOMBO COMPLETO [ C ]\n");
                break;
            case 'B':
                printf("\nBATATA FRITA [ B ]\n");
                break;
            case 'R':
                printf("\nREFRIGERANTE [ R ]\n");
                break;
            case 'F':
                /* Opcao de saida - tratada apos o bloco switch */
                break;
            default:
                printf("\nOpcao invalida! Tente novamente.\n");
                printf("[Pressione ENTER para continuar]");
                getchar(); /* Captura o ENTER pendente */
                getchar(); /* Aguarda o usuario pressionar uma tecla */
                continue;  /* Volta para o inicio do loop */
        }

        /* Se o usuario escolheu um produto valido, processa a venda */
        if (opcao == 'H' || opcao == 'C' || opcao == 'B' || opcao == 'R') {
            printf("Digite a quantidade desejada: ");
            scanf("%d", &quantidade);

            /* Validacao da quantidade */
            if (quantidade <= 0) {
                printf("\nQuantidade invalida! Operacao cancelada.\n");
            } else {
                /* Chamada das funcoes para calculo */
                float bruto = calcularValorBruto(opcao, quantidade);
                float desconto = calcularDesconto(bruto);
                float liquido = bruto - desconto;

                /* Exibicao dos resultados do pedido atual */
                printf("\nValor Bruto: R$ %.2f\n", bruto);
                if (desconto > 0) {
                    printf("Desconto Applied (10%%): -R$ %.2f\n", desconto);
                } else {
                    printf("Desconto Applied (0%%): R$ 0.00\n");
                }
                printf("Total a Pagar: R$ %.2f\n", liquido);

                /* Atualizacao dos acumuladores gerais */
                totalItensVendidos += quantidade;
                totalCaixaAcumulado += liquido;
                if (desconto > 0) {
                    totalDescontosConcedidos++;
                }
            }

            printf("\n[Pressione ENTER para continuar]");
            getchar(); /* Limpa o buffer */
            getchar(); /* Aguarda interacao */
        }

    } while (opcao != 'F');

    /* Relatorio de Encerramento */
    printf("\nSistema encerrado com sucesso.\n");
    printf("\n======= RELATORIO DO CAIXA =======\n");
    printf("Total de itens vendidos: %d\n", totalItensVendidos);
    printf("Quantidade de descontos aplicados: %d\n", totalDescontosConcedidos);
    printf("Total acumulado em caixa: R$ %.2f\n", totalCaixaAcumulado);
    printf("==================================\n\n");

    exibirAutoria();

    return 0;
}

/* IMPLEMENTACAO DOS COMPONENTES / FUNCOES */

void exibirMenu() {
    #ifdef _WIN32
        system("cls"); /* Limpa a tela no Windows */
    #else
        system("clear"); /* Limpa a tela no Linux/macOS */
    #endif

    printf("=====================================\n");
    printf("        HAMBURGUERIA CENTRAL         \n");
    printf("=====================================\n");
    printf(" [ H ] Hamburguer Simples (R$ 18.50)\n");
    printf(" [ C ] Combo Completo   (R$ 32.00)\n");
    printf(" [ B ] Batata Frita     (R$ 12.00)\n");
    printf(" [ R ] Refrigerante     (R$  6.50)\n");
    printf(" [ F ] Finalizar Sistema             \n");
    printf("=====================================\n");
    printf("Escolha uma opcao: ");
}

float calcularValorBruto(char opcao, int quantidade) {
    float precoUnitario = 0.0;

    if (opcao == 'H') precoUnitario = 18.50;
    else if (opcao == 'C') precoUnitario = 32.00;
    else if (opcao == 'B') precoUnitario = 12.00;
    else if (opcao == 'R') precoUnitario = 6.50;

    return precoUnitario * quantidade;
}

float calcularDesconto(float valorBruto) {
    /* Regra de negocio: Se a compra atual passar de R$ 60.00, ganha 10% */
    if (valorBruto > 60.00) {
        return valorBruto * 0.10;
    }
    return 0.0;
}

void exibirAutoria() {
    printf("***************************************************\n");
    printf("* Desenvolvido por: NOME DO ALUNO                 *\n");
    printf("***************************************************\n");
}
