using System;

class ExercicioCSharp16
{
    static int[] notas = new int[3];

    static void MostraVetor()
    {
        for (int i = 0; i < 3; i++)
        {
            Console.Write($"\nO valor da posicao: notas[{i}]={notas[i]}");
        }
    }

    static void InsereVetor()
    {
        for (int i = 0; i < 3; i++)
        {
            Console.Write($"\nDigite o numero {i + 1}: ");
            int.TryParse(Console.ReadLine(), out notas[i]);
        }
    }

    static void InitVetor()
    {
        for (int i = 0; i < 3; i++)
        {
            notas[i] = 0;
        }
    }

    static void Main()
    {
        InitVetor();
        MostraVetor();
        InsereVetor();
        MostraVetor();
    }
}