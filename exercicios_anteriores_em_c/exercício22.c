#include <stdio.h>
#include <stdlib.h>

// Definicao dos precos dos produtos
#define PRECO_HAMBURGUER 18.50
#define PRECO_COMBO 32.00
#define PRECO_BATATA 12.00
#define PRECO_REFRIGERANTE 6.50


void limpar_tela();
void pausar_sistema();
int valida_quantidade(int qtd);
float calcular_valor_bruto(float preco, int qtd);
float calcular_desconto(float valor_bruto);

int main() {
    char opcao;
    
    // Acumuladores estatisticos e financeiros
    int total_itens_vendidos = 0;
    int qtd_descontos_aplicados = 0;
    float total_acumulado_caixa = 0.0;
    
    // Variaveis de controle declaradas no inicio para evitar erros em C puro
    float preco_item;
    int quantidade;
    float valor_bruto;
    float desconto;
    float total_a_pagar;

    do {
        limpar_tela();
        
        // Exibicao do Menu Principal
        printf("=====================================\n");
        printf("        HAMBURGUERIA CENTRAL         \n");
        printf("=====================================\n");
        printf(" [ H ] Hamburguer Simples (R$ 18.50)\n");
        printf(" [ C ] Combo Completo (R$ 32.00)\n");
        printf(" [ B ] Batata Frita (R$ 12.00)\n");
        printf(" [ R ] Refrigerante (R$ 6.50)\n");
        printf(" [ F ] Finalizar Sistema \n");
        printf("=====================================\n");
        printf("Escolha uma opcao: ");
        scanf(" %c", &opcao);

        // Se a opcao for finalizar, sai do laco imediatamente
        if (opcao == 'F') {
            break;
        }

        preco_item = 0.0;

        // Switch para identificar o produto selecionado
        switch (opcao) {
            case 'H':
                printf("\nHAMBURGUER SIMPLES [ H ]\n");
                preco_item = PRECO_HAMBURGUER;
                break;
            case 'C':
                printf("\nCOMBO COMPLETO [ C ]\n");
                preco_item = PRECO_COMBO;
                break;
            case 'B':
                printf("\nBATATA FRITA [ B ]\n");
                preco_item = PRECO_BATATA;
                break;
            case 'R':
                printf("\nREFRIGERANTE [ R ]\n");
                preco_item = PRECO_REFRIGERANTE;
                break;
            default:
                printf("\nOpcao invalida!\n");
                pausar_sistema();
                continue; // Volta para o inicio do laco
        }

        // Solicitacao da quantidade
        printf("Digite a quantidade que voce deseja: ");
        scanf("%d", &quantidade);

        // Validacao da quantidade por meio de funcao dedicada
        if (!valida_quantidade(quantidade)) {
            printf("\nErro: Quantidade invalida. Venda cancelada.\n");
            pausar_sistema();
            continue; // Ignora o calculo e volta ao menu
        }

        // Calculos financeiros utilizando as funcoes exigidas
        valor_bruto = calcular_valor_bruto(preco_item, quantidade);
        desconto = calcular_desconto(valor_bruto);
        total_a_pagar = valor_bruto - desconto;

        // Exibicao do resultado da venda atual
        printf("\nValor Bruto: R$ %.2f\n", valor_bruto);
        if (desconto > 0) {
            printf("Desconto Aplicado (10%%): -R$ %.2f\n", desconto);
        } else {
            printf("Desconto Aplicado (0%%): R$ 0.00\n");
        }
        printf("Total a Pagar: R$ %.2f\n", total_a_pagar);

        // Atualizacao dos acumuladores gerais solicitados
        total_itens_vendidos += quantidade;
        total_acumulado_caixa += total_a_pagar;
        if (desconto > 0) {
            qtd_descontos_aplicados++;
        }
        
        pausar_sistema();
        
    } while (opcao != 'F');

    // Tela de encerramento do sistema e relatorios finais
    limpar_tela();
    printf("Sistema encerrado com sucesso.\n\n");
    printf("======= RELATORIO DO CAIXA =======\n\n");
    printf("Total de itens vendidos: %d\n", total_itens_vendidos);
    printf("Quantidade de descontos aplicados: %d\n", qtd_descontos_aplicados);
    printf("Total acumulado em caixa: R$ %.2f\n\n", total_acumulado_caixa);
    printf("==================================\n\n");

    // Bloco de autoria do projeto
    printf("***************************************************\n");
    printf("* Desenvolvido por: ifsp felipe                   *\n");
    printf("***************************************************\n");

    return 0;
}


// Limpa a tela de forma compativel com Windows e Linux/macOS
void limpar_tela() {
    #ifdef _WIN32
        system("cls");
    #else
        system("clear");
    #endif
}

// Pausa o sistema de forma multiplataforma (sem usar o problematico system("pause"))
void pausar_sistema() {
    printf("\nPressione ENTER para continuar...");
    getchar(); // Limpa residuo do buffer
    getchar(); // Aguarda o clique
}

// Retorna 1 se a quantidade for valida (>0) e 0 caso contrario
int valida_quantidade(int qtd) {
    if (qtd > 0) {
        return 1;
    }
    return 0;
}

// Calcula e retorna o valor bruto da compra
float calcular_valor_bruto(float preco, int qtd) {
    return preco * (float)qtd;
}

// Aplica a regra de 10% para compras acima de R$ 60.00
float calcular_desconto(float valor_bruto) {
    if (valor_bruto > 60.00) {
        return valor_bruto * 0.10;
    }
    return 0.0;
}
