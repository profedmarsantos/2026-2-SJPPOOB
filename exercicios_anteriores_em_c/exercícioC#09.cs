using System;

class ExercicioCSharp09
{
    static void Main()
    {
        float vD, acrescimo, vA;

        Console.Write("Digite o valor da divida: ");
        float.TryParse(Console.ReadLine(), out vD);

        Console.Write("Digite o valor do acrescimo: ");
        float.TryParse(Console.ReadLine(), out acrescimo);

        vA = vD + (vD * (acrescimo / 100));

        Console.Write($"O valor da divida atual e: {vA:F2}");
    }
}