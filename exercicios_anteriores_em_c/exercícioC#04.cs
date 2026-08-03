using System;

class ExercicioCSharp04
{
    static void Main()
    {
        float d, v, t;

        Console.Write("Digite o valor da velocidade: ");
        float.TryParse(Console.ReadLine(), out v);

        Console.Write("Digite o valor do tempo: ");
        float.TryParse(Console.ReadLine(), out t);

        d = v * t;

        Console.Write($"\nO valor da distancia e: {d:F2}");
    }
}