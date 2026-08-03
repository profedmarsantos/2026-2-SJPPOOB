using System;

class ExercicioCSharp15
{
    static void Main()
    {
        const int SIZE = 5;
        float media;
        float[] nota = new float[SIZE];
        float soma = 0;

        Console.WriteLine();

        for (int i = 0; i < SIZE; i++)
        {
            Console.Write($"\nDigite n{i + 1}: ");
            float.TryParse(Console.ReadLine(), out nota[i]);
            soma += nota[i];
        }

        media = soma / SIZE;
        Console.Write($"\n\nA media eh: {media:F2}");
        if (media >= 6)
            Console.Write("\n>> Aprovado :)");
        else if (media >= 4)
            Console.Write("\n>> Recuperacao :|");
        else
            Console.Write("\n>> Nao foi dessa vez :(");

        Console.WriteLine("\n");
    }
}