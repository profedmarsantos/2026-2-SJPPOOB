using System;

class ExercicioCSharp20
{
    static float a;
    static float b;
    static float resultado;

    static void GerenciarNavegacao()
    {
        Console.WriteLine("Pressione qualquer tecla para continuar...");
        Console.ReadKey();
        Console.Clear();
    }

    static void ExibirMenu()
    {
        Console.WriteLine("=====================================");
        Console.WriteLine("        CALCULADORA SIMPLES          ");
        Console.WriteLine("=====================================");
        Console.WriteLine(" [ + ] Adicao");
        Console.WriteLine(" [ - ] Subtracao");
        Console.WriteLine(" [ * ] Multiplicacao");
        Console.WriteLine(" [ / ] Divisao");
        Console.WriteLine(" [ S ] Sair");
        Console.WriteLine("=====================================");
        Console.Write("Escolha uma opcao: ");
    }

    static void LerValores()
    {
        Console.Write("\nDigite o primeiro valor: ");
        float.TryParse(Console.ReadLine(), out a);
        Console.Write("Digite o segundo valor: ");
        float.TryParse(Console.ReadLine(), out b);
    }

    static void TratarErro()
    {
        Console.WriteLine("\nOpcao invalida!");
        Console.WriteLine("Utilize apenas +, -, * ou /.\n");
        GerenciarNavegacao();
    }

    static void EncerrarSistema()
    {
        Console.WriteLine("\nCalculadora encerrada com sucesso.\n");
        Console.WriteLine("***************************************************");
        Console.WriteLine("*      Desenvolvido por: NOME DO ALUNO            *");
        Console.WriteLine("***************************************************");
    }

    static float Somar(float x, float y) => x + y;
    static float Subtrair(float x, float y) => x - y;
    static float Multiplicar(float x, float y) => x * y;
    static float Dividir(float x, float y) => x / y;

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
                case '+':
                    Console.WriteLine("\nADICAO [ + ]");
                    LerValores();
                    resultado = Somar(a, b);
                    Console.WriteLine($"\nResultado: {resultado:F2}\n");
                    GerenciarNavegacao();
                    break;
                case '-':
                    Console.WriteLine("\nSUBTRACAO [ - ]");
                    LerValores();
                    resultado = Subtrair(a, b);
                    Console.WriteLine($"\nResultado: {resultado:F2}\n");
                    GerenciarNavegacao();
                    break;
                case '*':
                    Console.WriteLine("\nMULTIPLICACAO [ * ]");
                    LerValores();
                    resultado = Multiplicar(a, b);
                    Console.WriteLine($"\nResultado: {resultado:F2}\n");
                    GerenciarNavegacao();
                    break;
                case '/':
                    Console.WriteLine("\nDIVISAO [ / ]");
                    LerValores();
                    if (b == 0)
                    {
                        Console.WriteLine("\nErro: divisao por zero nao e permitida.\n");
                    }
                    else
                    {
                        resultado = Dividir(a, b);
                        Console.WriteLine($"\nResultado: {resultado:F2}\n");
                    }
                    GerenciarNavegacao();
                    break;
                case 'S':
                case 's':
                    EncerrarSistema();
                    break;
                default:
                    TratarErro();
                    break;
            }
        }
        while (opcao != 'S' && opcao != 's');
    }
}