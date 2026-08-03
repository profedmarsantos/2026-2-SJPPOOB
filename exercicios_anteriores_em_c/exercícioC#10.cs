using System;

class ExercicioCSharp10
{
    static void Main()
    {
        int meninas, meninos, total;

        Console.Write("Digite quantas meninas estao na sala: ");
        int.TryParse(Console.ReadLine(), out meninas);

        meninos = meninas / (80 / 20);

        total = meninas + meninos;

        Console.Write($"\nMeninas: {meninas}");
        Console.Write($"\nMeninos: {meninos}");
        Console.Write($"\nTotal: {total}");
    }
}