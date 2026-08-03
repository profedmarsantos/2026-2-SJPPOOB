using System;

class ExercicioCSharp11
{
    static void Main()
    {
        float x, y, w, juros, montante;

        Console.Write("Digite o capital (X): ");
        float.TryParse(Console.ReadLine(), out x);
        Console.Write("Digite o taxa (Y): ");
        float.TryParse(Console.ReadLine(), out y);
        Console.Write("Digite o meses (W): ");
        float.TryParse(Console.ReadLine(), out w);

        juros = x * (y / 100) * w;
        montante = x + juros;

        Console.Write($"\nCapital (x): {x:F2}");
        Console.Write($"\nJuros Simples: {juros:F2}");
        Console.Write($"\nMontante: {montante:F2}");
        Console.Write("\n\n");
    }
}