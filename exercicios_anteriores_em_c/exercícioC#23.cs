using System;

class ExercicioCSharp23
{
    const int TOTALVAGAS = 10;
    static int[] vagas = new int[TOTALVAGAS];

    static void Pausar()
    {
        Console.WriteLine("Pressione qualquer tecla para continuar...");
        Console.ReadKey();
    }

    static void LimparTela()
    {
        Console.Clear();
    }

    static int ContarVagasLivres()
    {
        int livres = 0;

        for (int i = 0; i < 10; i++)
        {
            if (vagas[i] == 0)
            {
                livres++;
            }
        }

        return livres;
    }

    static void MostrarMapaVagas()
    {
        Console.WriteLine("=====================================");
        Console.WriteLine("           MAPA DE VAGAS");
        Console.WriteLine("=====================================\n");

        for (int i = 0; i < 10; i++)
        {
            if (vagas[i] == 0)
            {
                Console.WriteLine($"Vaga {i} -> Livre");
            }
            else
            {
                Console.WriteLine($"Vaga {i} -> Ocupada");
            }
        }

        Console.WriteLine();
    }

    static void ExibirMenu()
    {
        int livres = ContarVagasLivres();

        Console.WriteLine("=====================================");
        Console.WriteLine("    CONTROLE DE ESTACIONAMENTO");
        Console.WriteLine("=====================================\n");

        if (livres == 0)
        {
            Console.WriteLine("Status: TODAS AS VAGAS OCUPADAS!\n");
        }
        else
        {
            Console.WriteLine($"Status: Restam {livres} vagas!\n");
        }

        Console.WriteLine(" [ E ] Entrada de Veiculo");
        Console.WriteLine(" [ S ] Saida de Veiculo");
        Console.WriteLine(" [ M ] Mostrar Vagas");
        Console.WriteLine(" [ F ] Finalizar Sistema\n");
        Console.WriteLine("=====================================");
        Console.Write("Escolha uma opcao: ");
    }

    static void EntradaVeiculo()
    {
        LimparTela();
        MostrarMapaVagas();

        Console.Write("Digite a vaga desejada: ");
        int.TryParse(Console.ReadLine(), out int vaga);

        if (vaga < 0 || vaga > 9)
        {
            LimparTela();
            MostrarMapaVagas();
            Console.WriteLine("Numero de vaga invalido!\n");
        }
        else if (vagas[vaga] == 1)
        {
            LimparTela();
            MostrarMapaVagas();
            Console.WriteLine("A vaga escolhida ja esta ocupada!\n");
        }
        else
        {
            vagas[vaga] = 1;

            LimparTela();
            MostrarMapaVagas();
            Console.WriteLine($"Veiculo estacionado na vaga {vaga}.\n");
        }

        Pausar();
        LimparTela();
    }

    static void SaidaVeiculo()
    {
        LimparTela();
        MostrarMapaVagas();

        Console.Write("Digite a vaga para saida: ");
        int.TryParse(Console.ReadLine(), out int vaga);

        if (vaga < 0 || vaga > 9)
        {
            LimparTela();
            MostrarMapaVagas();
            Console.WriteLine("Numero de vaga invalido!\n");
        }
        else if (vagas[vaga] == 0)
        {
            LimparTela();
            MostrarMapaVagas();
            Console.WriteLine("Nao existe veiculo estacionado nessa vaga.\n");
        }
        else
        {
            vagas[vaga] = 0;

            LimparTela();
            MostrarMapaVagas();
            Console.WriteLine($"Veiculo removido da vaga {vaga}.\n");
        }

        Pausar();
        LimparTela();
    }

    static void MostrarVagas()
    {
        LimparTela();
        MostrarMapaVagas();
        Pausar();
        LimparTela();
    }

    static void TratarErro()
    {
        Console.WriteLine("\nOpcao invalida!\n");
        Pausar();
        LimparTela();
    }

    static void EncerrarSistema()
    {
        int contaVeiculos = TOTALVAGAS - ContarVagasLivres();

        if (contaVeiculos > 0)
            Console.WriteLine($"\nAtencao: Ainda existem {contaVeiculos} veiculo(s) estacionados!\n");
        else
            Console.WriteLine("\nEstacionamento vazio!\n");

        Console.WriteLine("\nSistema encerrado com sucesso.\n");
        Console.WriteLine("***************************************************");
        Console.WriteLine("*      Desenvolvido por: NOME DO ALUNO            *");
        Console.WriteLine("***************************************************");
    }

    static void Main()
    {
        for (int i = 0; i < 10; i++)
        {
            vagas[i] = 0;
        }

        char opcao;
        do
        {
            ExibirMenu();
            opcao = Console.ReadKey().KeyChar;
            Console.WriteLine();

            switch (opcao)
            {
                case 'E':
                case 'e':
                    EntradaVeiculo();
                    break;
                case 'S':
                case 's':
                    SaidaVeiculo();
                    break;
                case 'M':
                case 'm':
                    MostrarVagas();
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