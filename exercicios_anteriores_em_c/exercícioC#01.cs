using System;

class ExercicioCSharp01
{
    static void Main()
    {
        float total, preco;
        int paes;

        Console.Write("Digite quantos paes vai levar: ");
        int.TryParse(Console.ReadLine(), out paes);

        Console.Write("Digite qual o preco: ");
        float.TryParse(Console.ReadLine(), out preco);

        total = paes * preco;

        Console.Write($"O total e: {total}");
    }
}