using System;

class ExercicioCSharp07
{
    static void Main()
    {
        float total, km;

        Console.Write("Digite quantos km rodou: ");
        float.TryParse(Console.ReadLine(), out km);

        total = 5.0f + (km * 0.80f);

        Console.Write($"O total e: {total:F2}");
    }
}