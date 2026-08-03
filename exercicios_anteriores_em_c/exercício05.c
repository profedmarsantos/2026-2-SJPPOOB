#include <stdio.h>
int main(){
    int a, b, temp;

    printf("Digite o valor de A: ");
    scanf("%d",&a);

    printf("Digite o valor de B: ");
    scanf("%d",&b);

    temp = a;
    a = b;
    b = temp;

    printf("\nO valor de A: %d",a);
    printf("\nO valor de B: %d",b);

    return 0;
}
