#include <stdio.h>
int main(){
    float HT, VH, PD, SB, TD, SL;

    printf("Digite HT: ");
    scanf("%f",&HT);

    printf("Digite VH: ");
    scanf("%f",&VH);

    printf("Digite PD: ");
    scanf("%f",&PD);

    SB = HT * VH;
    TD = SB - (SB*(PD/100));
    SL = SB - TD;

    printf("\nO valor do SB: %.2f",SB);
    printf("\nO valor do TD: %.2f",TD);
    printf("\nO valor do SL: %.2f",SL);


    return 0;
}
