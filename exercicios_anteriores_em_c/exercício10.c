#include <stdio.h>
int main(){
    int meninas, meninos, total;

    printf("Digite quantas meninas estao na sala: ");
    scanf("%d",&meninas);

    meninos = meninas / (80/20);

    total = meninas + meninos;

    printf("\nMeninas: %d",meninas);
    printf("\nMeninos: %d",meninos);
    printf("\nTotal: %d",total);


    return 0;
}
