using System;

class ExercicioCSharp18
{
    static void Menu()
    {
        Console.Clear();
        Console.WriteLine("\nD - Bom dia!");
        Console.WriteLine("T - Boa tarde!");
        Console.WriteLine("N - Boa noite!");
        Console.WriteLine("- - - - - - - -");
        Console.WriteLine("F - Boa noite!\n");
    }

    static void Bd()
    {
        Console.Clear();
        Console.WriteLine("\nVoce escolheu bom dia!\n");
    }

    static void Bt()
    {
        Console.Clear();
        Console.WriteLine("\nVoce escolheu boa tarde!\n");
    }

    static void Bn()
    {
        Console.WriteLine("\nVoce escolheu boa noite!\n");
    }

    static int Dobro(int n)
    {
        int total;
        total = n * 2;
        return total;
    }

    static int Soma(int a, int b)
    {
        return a + b;
    }

    static void Pausar()
    {
        Console.WriteLine("Pressione qualquer tecla para continuar...");
        Console.ReadKey();
    }

    static void Main()
    {
        char opcao;
        do
        {
            Menu();
            Console.Write("\nEscolha uma letra: ");
            opcao = Console.ReadKey().KeyChar;
            Console.WriteLine();

            switch (opcao)
            {
                case 'd':
                case 'D':
                    Bd();
                    break;
                case 't':
                case 'T':
                    Bt();
                    break;
                case 'N':
                case 'n':
                    Bn();
                    break;
                case 'F':
                case 'f':
                    Console.WriteLine("\nSaindo...!\n");
                    break;
                default:
                    Console.WriteLine("\nOpcao invalida!\n");
                    break;
            }

            Pausar();
        }
        while (opcao != 'F' && opcao != 'f');
    }
}