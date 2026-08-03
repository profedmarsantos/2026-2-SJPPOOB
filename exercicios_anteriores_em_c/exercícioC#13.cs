using System;

class ExercicioCSharp13
{
    static void BomDia()
    {
        Console.Clear();
        Console.WriteLine("\n===============");
        Console.WriteLine("     Bom dia!   ");
        Console.WriteLine("===============\n");
    }

    static void BoaNoite()
    {
        Console.Clear();
        Console.WriteLine("\n===============");
        Console.WriteLine("   Boa noite!   ");
        Console.WriteLine("===============\n");
    }

    static void Menu()
    {
        Console.WriteLine("\nD - Bom dia");
        Console.WriteLine("N - Boa noite");
        Console.WriteLine("S - Fecha o programa\n");
    }

    static void Pausar()
    {
        Console.WriteLine("Pressione qualquer tecla para continuar...");
        Console.ReadKey();
    }

    static void Main()
    {
        while (true)
        {
            Console.Clear();
            Menu();
            Console.Write("Digite a opcao desejada: ");
            char opcao = Console.ReadKey().KeyChar;
            Console.WriteLine();

            switch (opcao)
            {
                case 'D':
                case 'd':
                    BomDia();
                    Pausar();
                    break;
                case 'N':
                case 'n':
                    BoaNoite();
                    Pausar();
                    break;
                case 'S':
                case 's':
                    return;
                default:
                    Console.WriteLine("\nOpcao invalida!!!\n");
                    Pausar();
                    break;
            }
        }
    }
}