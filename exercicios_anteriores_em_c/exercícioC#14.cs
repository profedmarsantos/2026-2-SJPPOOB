using System;

class ExercicioCSharp14
{
    static void Main()
    {
        int dia, h = 0, m = 0, t;

        Console.WriteLine("\nSJPALPR: Prova 1 - 22/04/2026");
        Console.WriteLine("\nPROBLEMA: O BOTECO DO JOAO");
        Console.Write("\nQue dia voce quer calcular? (1 - sab) ou (2 - dom) ");
        int.TryParse(Console.ReadLine(), out dia);

        if (dia == 1)
        {
            Console.Write("\nDigite o numero de mulheres no baile: ");
            int.TryParse(Console.ReadLine(), out m);
            h = (m * 3) / 4;
        }
        else if (dia == 2)
        {
            Console.Write("\nDigite o numero de homens no baile: ");
            int.TryParse(Console.ReadLine(), out h);
            m = (h * 8) / 5;
        }
        else
        {
            Console.WriteLine("\n\nEssa opcao nao existe! O boteco esta fechado!");
        }

        t = h + m;

        Console.WriteLine("\n\n======= TOTAL DE PESSOAS NO BAILE =======");
        if (dia == 1)
        {
            Console.WriteLine("\nSABADO:");
        }
        else if (dia == 2)
        {
            Console.WriteLine("\nDOMINGO:");
        }
        else
        {
            Console.WriteLine("\nDIA FECHADO");
        }

        Console.WriteLine($"\nO total de mulheres eh:             {m,5}");
        Console.WriteLine($"O total de homens eh:               {h,5}");
        Console.WriteLine("\nTOTAL:");
        Console.WriteLine($"O total de pessoas eh:              {t,5}");
        Console.WriteLine("\n=========================================\n");
    }
}