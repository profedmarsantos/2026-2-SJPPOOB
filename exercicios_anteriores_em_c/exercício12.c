#include <stdio.h>
int main()
{
    int n, t, i,j;

    printf("Digite o n da tabuada: ");
    scanf("%d",&n);


    for(i = 0; i<= 10; i++)
    {
        t = n * i;
        printf("\n%d x %d = %d", n,i,t);
    }


    printf("\n\n");
    return 0;
}
