using System;

class ExercicioCSharp06
{
    static void Main()
    {
        int min;
        float litros;

        Console.Write("Digite quantos minutos a torneira ficou aberta: ");
        int.TryParse(Console.ReadLine(), out min);

        litros = min * 30;

        Console.Write($"\nO total de litros e: {litros:F2}");
    }
}