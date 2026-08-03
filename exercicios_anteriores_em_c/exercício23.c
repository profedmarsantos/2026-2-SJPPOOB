#include <stdio.h>
#include <stdlib.h>

#define TOTALVAGAS 10

int vagas[TOTALVAGAS];

void pausar() {
    system("pause");
}

void limparTela() {
    system("cls");
}

int contarVagasLivres() {
    int i;
    int livres = 0;

    for(i = 0; i < 10; i++) {
        if(vagas[i] == 0) {
            livres++;
        }
    }

    return livres;
}

void mostrarMapaVagas() {
    int i;

    printf("=====================================\n");
    printf("           MAPA DE VAGAS\n");
    printf("=====================================\n\n");

    for(i = 0; i < 10; i++) {

        if(vagas[i] == 0) {
            printf("Vaga %d -> Livre\n", i);
        } else {
            printf("Vaga %d -> Ocupada\n", i);
        }
    }

    printf("\n");
}

void exibirMenu() {
    int livres;

    livres = contarVagasLivres();

    printf("=====================================\n");
    printf("    CONTROLE DE ESTACIONAMENTO\n");
    printf("=====================================\n\n");

    if(livres == 0) {
        printf("Status: TODAS AS VAGAS OCUPADAS!\n\n");
    } else {
        printf("Status: Restam %d vagas!\n\n", livres);
    }

    printf(" [ E ] Entrada de Veiculo\n");
    printf(" [ S ] Saida de Veiculo\n");
    printf(" [ M ] Mostrar Vagas\n");
    printf(" [ F ] Finalizar Sistema\n\n");

    printf("=====================================\n");
    printf("Escolha uma opcao: ");
}

void entradaVeiculo() {

    int vaga;

    limparTela();

    //printf("ENTRADA DE VEICULO [ E ]\n\n");

    mostrarMapaVagas();

    printf("Digite a vaga desejada: ");
    scanf("%d", &vaga);

    if(vaga < 0 || vaga > 9) {

        limparTela();

        mostrarMapaVagas();

        printf("Numero de vaga invalido!\n\n");

    } else if(vagas[vaga] == 1) {

        limparTela();

        mostrarMapaVagas();

        printf("A vaga escolhida ja esta ocupada!\n\n");

    } else {

        vagas[vaga] = 1;

        limparTela();

        mostrarMapaVagas();

        printf("Veiculo estacionado na vaga %d.\n\n", vaga);
    }

    pausar();
    limparTela();
}

void saidaVeiculo() {

    int vaga;

    limparTela();

    //printf("SAIDA DE VEICULO [ S ]\n\n");

    mostrarMapaVagas();

    printf("Digite a vaga para saida: ");
    scanf("%d", &vaga);

    if(vaga < 0 || vaga > 9) {

        limparTela();

        mostrarMapaVagas();

        printf("Numero de vaga invalido!\n\n");

    } else if(vagas[vaga] == 0) {

        limparTela();

        mostrarMapaVagas();

        printf("Nao existe veiculo estacionado nessa vaga.\n\n");

    } else {

        vagas[vaga] = 0;

        limparTela();

        mostrarMapaVagas();

        printf("Veiculo removido da vaga %d.\n\n", vaga);
    }

    pausar();
    limparTela();
}

void mostrarVagas() {

    limparTela();

    //printf("MOSTRAR VAGAS [ M ]\n\n");

    mostrarMapaVagas();

    pausar();
    limparTela();
}

void tratarErro() {

    printf("\nOpcao invalida!\n\n");

    pausar();
    limparTela();
}

void encerrarSistema() {

    int contaVeiculos = TOTALVAGAS - contarVagasLivres();

    if (contaVeiculos > 0)
        printf("\nAtencao: Ainda existem %d veiculo(s) estacionados!\n\n");
    else
        printf("\nEstacionamento vazio!\n\n");

    printf("\nSistema encerrado com sucesso.\n\n");

    printf("***************************************************\n");
    printf("*      Desenvolvido por: NOME DO ALUNO            *\n");
    printf("***************************************************\n");
}

int main() {

    char opcao;
    int i;

    for(i = 0; i < 10; i++) {
        vagas[i] = 0;
    }

    do {

        exibirMenu();

        scanf(" %c", &opcao);

        switch(opcao) {

            case 'E':
            case 'e':
                entradaVeiculo();
                break;

            case 'S':
            case 's':
                saidaVeiculo();
                break;

            case 'M':
            case 'm':
                mostrarVagas();
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
