using System;

class ExercicioCSharp21
{
    static void ExibirMenu()
    {
        Console.Clear();
        Console.WriteLine("=====================================");
        Console.WriteLine("        HAMBURGUERIA CENTRAL         ");
        Console.WriteLine("=====================================");
        Console.WriteLine(" [ H ] Hamburguer Simples (R$ 18.50)");
        Console.WriteLine(" [ C ] Combo Completo   (R$ 32.00)");
        Console.WriteLine(" [ B ] Batata Frita     (R$ 12.00)");
        Console.WriteLine(" [ R ] Refrigerante     (R$  6.50)");
        Console.WriteLine(" [ F ] Finalizar Sistema             ");
        Console.WriteLine("=====================================");
        Console.Write("Escolha uma opcao: ");
    }

    static float CalcularValorBruto(char opcao, int quantidade)
    {
        float precoUnitario = 0.0f;

        if (opcao == 'H') precoUnitario = 18.50f;
        else if (opcao == 'C') precoUnitario = 32.00f;
        else if (opcao == 'B') precoUnitario = 12.00f;
        else if (opcao == 'R') precoUnitario = 6.50f;

        return precoUnitario * quantidade;
    }

    static float CalcularDesconto(float valorBruto)
    {
        if (valorBruto > 60.00f)
        {
            return valorBruto * 0.10f;
        }
        return 0.0f;
    }

    static void ExibirAutoria()
    {
        Console.WriteLine("***************************************************");
        Console.WriteLine("* Desenvolvido por: NOME DO ALUNO                 *");
        Console.WriteLine("***************************************************");
    }

    static void Main()
    {
        char opcao;
        int quantidade;

        int totalItensVendidos = 0;
        int totalDescontosConcedidos = 0;
        float totalCaixaAcumulado = 0.0f;

        do
        {
            ExibirMenu();
            opcao = char.ToUpper(Console.ReadKey().KeyChar);
            Console.WriteLine();

            switch (opcao)
            {
                case 'H':
                    Console.WriteLine("\nHAMBURGUER SIMPLES [ H ]");
                    break;
                case 'C':
                    Console.WriteLine("\nCOMBO COMPLETO [ C ]");
                    break;
                case 'B':
                    Console.WriteLine("\nBATATA FRITA [ B ]");
                    break;
                case 'R':
                    Console.WriteLine("\nREFRIGERANTE [ R ]");
                    break;
                case 'F':
                    break;
                default:
                    Console.WriteLine("\nOpcao invalida! Tente novamente.");
                    Console.Write("[Pressione ENTER para continuar]");
                    Console.ReadLine();
                    continue;
            }

            if (opcao == 'H' || opcao == 'C' || opcao == 'B' || opcao == 'R')
            {
                Console.Write("Digite a quantidade desejada: ");
                int.TryParse(Console.ReadLine(), out quantidade);

                if (quantidade <= 0)
                {
                    Console.WriteLine("\nQuantidade invalida! Operacao cancelada.");
                }
                else
                {
                    float bruto = CalcularValorBruto(opcao, quantidade);
                    float desconto = CalcularDesconto(bruto);
                    float liquido = bruto - desconto;

                    Console.WriteLine($"\nValor Bruto: R$ {bruto:F2}");
                    if (desconto > 0)
                    {
                        Console.WriteLine($"Desconto Applied (10%): -R$ {desconto:F2}");
                    }
                    else
                    {
                        Console.WriteLine("Desconto Applied (0%): R$ 0.00");
                    }
                    Console.WriteLine($"Total a Pagar: R$ {liquido:F2}");

                    totalItensVendidos += quantidade;
                    totalCaixaAcumulado += liquido;
                    if (desconto > 0)
                    {
                        totalDescontosConcedidos++;
                    }
                }

                Console.Write("\n[Pressione ENTER para continuar]");
                Console.ReadLine();
            }
        }
        while (opcao != 'F');

        Console.WriteLine("\nSistema encerrado com sucesso.");
        Console.WriteLine("\n======= RELATORIO DO CAIXA =======");
        Console.WriteLine($"Total de itens vendidos: {totalItensVendidos}");
        Console.WriteLine($"Quantidade de descontos aplicados: {totalDescontosConcedidos}");
        Console.WriteLine($"Total acumulado em caixa: R$ {totalCaixaAcumulado:F2}");
        Console.WriteLine("==================================\n");

        ExibirAutoria();
    }
}