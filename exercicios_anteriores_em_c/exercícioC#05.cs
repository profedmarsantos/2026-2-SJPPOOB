using System;

class ExercicioCSharp05
{
    static void Main()
    {
        int a, b, temp;

        Console.Write("Digite o valor de A: ");
        int.TryParse(Console.ReadLine(), out a);

        Console.Write("Digite o valor de B: ");
        int.TryParse(Console.ReadLine(), out b);

        temp = a;
        a = b;
        b = temp;

        Console.Write($"\nO valor de A: {a}");
        Console.Write($"\nO valor de B: {b}");
    }
}