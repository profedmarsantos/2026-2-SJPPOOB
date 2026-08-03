using System;

class ExercicioCSharp19
{
    static float totalCaixa = 0.0f;
    static int veiculos = 0;
    static int vouchers = 0;

    static void ExibirMenu()
    {
        Console.WriteLine("\n---- MENU POSTO -----");
        Console.WriteLine("A - Alcool");
        Console.WriteLine("G - Gasolina");
        Console.WriteLine("F - Finalizar Sistema");
        Console.WriteLine("---------------------");
        Console.Write("\nEscolha uma opcao: ");
    }

    static void GerenciarNavegacao()
    {
        Console.WriteLine("Pressione qualquer tecla para continuar...");
        Console.ReadKey();
        Console.Clear();
    }

    static void ProcessarAbastecimento(float preco, float limiteVoucher)
    {
        float litros, valorPagar;
        Console.Write("\nDigite a quantidade de litros: ");
        float.TryParse(Console.ReadLine(), out litros);

        valorPagar = litros * preco;
        totalCaixa += valorPagar;
        veiculos++;

        Console.WriteLine($"\nValor a pagar: R$ {valorPagar:F2}");
        if (litros >= limiteVoucher)
        {
            Console.WriteLine("Parabens! Voce ganhou um voucher de ducha.\n");
            vouchers++;
        }

        GerenciarNavegacao();
    }

    static void EncerrarSistema()
    {
        Console.WriteLine("\nSistema encerrado com sucesso!");
        Console.WriteLine($"Total de veiculos atendidos: {veiculos}");
        Console.WriteLine($"Total acumulado no caixa: R$ {totalCaixa:F2}");
        Console.WriteLine($"Total de vouchers concedidos: {vouchers}");
    }

    static void TratarErro()
    {
        Console.WriteLine("\nOpcao invalida! Tente novamente.\n");
        GerenciarNavegacao();
    }

    static void Main()
    {
        char opcao;
        do
        {
            ExibirMenu();
            opcao = Console.ReadKey().KeyChar;
            Console.WriteLine();

            switch (opcao)
            {
                case 'A':
                case 'a':
                    ProcessarAbastecimento(4.50f, 20.0f);
                    break;
                case 'G':
                case 'g':
                    ProcessarAbastecimento(5.80f, 10.0f);
                    break;
                case 'F':
                case 'f':
                    EncerrarSistema();
                    break;
                default:
                    TratarErro();
                    break;
            }
        }
        while (opcao != 'F' && opcao != 'f');
    }
}