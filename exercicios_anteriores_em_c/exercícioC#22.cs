using System;

class ExercicioCSharp22
{
    const float PRECO_HAMBURGUER = 18.50f;
    const float PRECO_COMBO = 32.00f;
    const float PRECO_BATATA = 12.00f;
    const float PRECO_REFRIGERANTE = 6.50f;

    static void LimparTela()
    {
        Console.Clear();
    }

    static void PausarSistema()
    {
        Console.Write("\nPressione ENTER para continuar...");
        Console.ReadLine();
    }

    static bool ValidaQuantidade(int qtd)
    {
        return qtd > 0;
    }

    static float CalcularValorBruto(float preco, int qtd)
    {
        return preco * qtd;
    }

    static float CalcularDesconto(float valorBruto)
    {
        if (valorBruto > 60.00f)
        {
            return valorBruto * 0.10f;
        }
        return 0.0f;
    }

    static void Main()
    {
        char opcao;

        int totalItensVendidos = 0;
        int qtdDescontosAplicados = 0;
        float totalAcumuladoCaixa = 0.0f;

        float precoItem;
        int quantidade;
        float valorBruto;
        float desconto;
        float totalAPagar;

        do
        {
            LimparTela();

            Console.WriteLine("=====================================");
            Console.WriteLine("        HAMBURGUERIA CENTRAL         ");
            Console.WriteLine("=====================================");
            Console.WriteLine(" [ H ] Hamburguer Simples (R$ 18.50)");
            Console.WriteLine(" [ C ] Combo Completo (R$ 32.00)");
            Console.WriteLine(" [ B ] Batata Frita (R$ 12.00)");
            Console.WriteLine(" [ R ] Refrigerante (R$ 6.50)");
            Console.WriteLine(" [ F ] Finalizar Sistema ");
            Console.WriteLine("=====================================");
            Console.Write("Escolha uma opcao: ");
            opcao = Console.ReadKey().KeyChar;
            Console.WriteLine();

            if (opcao == 'F')
            {
                break;
            }

            precoItem = 0.0f;

            switch (opcao)
            {
                case 'H':
                    Console.WriteLine("\nHAMBURGUER SIMPLES [ H ]");
                    precoItem = PRECO_HAMBURGUER;
                    break;
                case 'C':
                    Console.WriteLine("\nCOMBO COMPLETO [ C ]");
                    precoItem = PRECO_COMBO;
                    break;
                case 'B':
                    Console.WriteLine("\nBATATA FRITA [ B ]");
                    precoItem = PRECO_BATATA;
                    break;
                case 'R':
                    Console.WriteLine("\nREFRIGERANTE [ R ]");
                    precoItem = PRECO_REFRIGERANTE;
                    break;
                default:
                    Console.WriteLine("\nOpcao invalida!");
                    PausarSistema();
                    continue;
            }

            Console.Write("Digite a quantidade que voce deseja: ");
            int.TryParse(Console.ReadLine(), out quantidade);

            if (!ValidaQuantidade(quantidade))
            {
                Console.WriteLine("\nErro: Quantidade invalida. Venda cancelada.");
                PausarSistema();
                continue;
            }

            valorBruto = CalcularValorBruto(precoItem, quantidade);
            desconto = CalcularDesconto(valorBruto);
            totalAPagar = valorBruto - desconto;

            Console.WriteLine($"\nValor Bruto: R$ {valorBruto:F2}");
            if (desconto > 0)
            {
                Console.WriteLine($"Desconto Aplicado (10%): -R$ {desconto:F2}");
            }
            else
            {
                Console.WriteLine("Desconto Aplicado (0%): R$ 0.00");
            }
            Console.WriteLine($"Total a Pagar: R$ {totalAPagar:F2}");

            totalItensVendidos += quantidade;
            totalAcumuladoCaixa += totalAPagar;
            if (desconto > 0)
            {
                qtdDescontosAplicados++;
            }

            PausarSistema();
        }
        while (opcao != 'F');

        LimparTela();
        Console.WriteLine("Sistema encerrado com sucesso.\n");
        Console.WriteLine("======= RELATORIO DO CAIXA =======\n");
        Console.WriteLine($"Total de itens vendidos: {totalItensVendidos}");
        Console.WriteLine($"Quantidade de descontos aplicados: {qtdDescontosAplicados}");
        Console.WriteLine($"Total acumulado em caixa: R$ {totalAcumuladoCaixa:F2}\n");
        Console.WriteLine("==================================\n");

        Console.WriteLine("***************************************************");
        Console.WriteLine("* Desenvolvido por: ifsp felipe                   *");
        Console.WriteLine("***************************************************");
    }
}