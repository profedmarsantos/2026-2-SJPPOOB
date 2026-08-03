using System;

class ExercicioCSharp12
{
    static void Main()
    {
        int n, t;

        Console.Write("Digite o n da tabuada: ");
        int.TryParse(Console.ReadLine(), out n);

        for (int i = 0; i <= 10; i++)
        {
            t = n * i;
            Console.Write($"\n{n} x {i} = {t}");
        }

        Console.Write("\n\n");
    }
}