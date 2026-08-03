#include <stdio.h>
int main(){
    float x, y, w, juros, montante;

    printf("Digite o capital (X): ");
    scanf("%f",&x);
    printf("Digite o taxa (Y): ");
    scanf("%f",&y);
    printf("Digite o meses (W): ");
    scanf("%f",&w);

    juros = x * (y/100) * w;
    montante = x + juros;

    printf("\nCapital (x): %.2f",x);
    printf("\nJuros Simples: %.2f",juros);
    printf("\nMontante: %.2f",montante);
    printf("\n\n");
    return 0;
}
