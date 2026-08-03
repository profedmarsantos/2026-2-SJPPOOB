using System;

class ExercicioCSharp08
{
    static void Main()
    {
        float precoOriginal, precoDesconto;

        Console.Write("Digite o preco da mercadoria: ");
        float.TryParse(Console.ReadLine(), out precoOriginal);

        precoDesconto = precoOriginal - (precoOriginal * 0.18f);

        Console.Write($"O preco com desconto e: {precoDesconto:F2}");
    }
}