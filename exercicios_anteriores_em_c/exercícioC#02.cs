using System;

class ExercicioCSharp02
{
    static void Main()
    {
        int n, potencia;

        Console.Write("Digite um numero n: ");
        int.TryParse(Console.ReadLine(), out n);

        potencia = n * n * n;

        Console.Write($"A potencia e: {potencia}");
    }
}