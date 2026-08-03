using System;

class ExercicioCSharp03
{
    static void Main()
    {
        float HT, VH, PD, SB, TD, SL;

        Console.Write("Digite HT: ");
        float.TryParse(Console.ReadLine(), out HT);

        Console.Write("Digite VH: ");
        float.TryParse(Console.ReadLine(), out VH);

        Console.Write("Digite PD: ");
        float.TryParse(Console.ReadLine(), out PD);

        SB = HT * VH;
        TD = SB - (SB * (PD / 100));
        SL = SB - TD;

        Console.Write($"\nO valor do SB: {SB:F2}");
        Console.Write($"\nO valor do TD: {TD:F2}");
        Console.Write($"\nO valor do SL: {SL:F2}");
    }
}