#include <stdio.h>
int main(){
    float total, km;

    printf("Digite quantos km rodou: ");
    scanf("%f",&km);

    total = 5.0 + (km * 0.80);

    printf("O total e: %.2f",total);


    return 0;
}
