using System;

class ExercicioCSharp17
{
    struct Dia
    {
        public int Min;
        public int Max;
    }

    static void Main()
    {
        int tamanaho;
        Dia[] penultimaSemana = new Dia[7];

        tamanaho = 0;

        for (int i = 0; i < 7; i++)
        {
            Console.Write("========================");
            Console.Write($"\nLeitura do dia: {i}");

            Console.Write("\n---Digite a temp. min: ");
            int.TryParse(Console.ReadLine(), out penultimaSemana[i].Min);

            Console.Write("\n---Digite a temp. max: ");
            int.TryParse(Console.ReadLine(), out penultimaSemana[i].Max);
        }

        Console.WriteLine("\n");
        for (int i = 0; i < 7; i++)
        {
            Console.Write("\n========================");
            Console.Write($"\nValores do dia: {i}");
            Console.Write($"\n---Digite a temp. min: {penultimaSemana[i].Min}");
            Console.Write($"\n---Digite a temp. max: {penultimaSemana[i].Max}");
        }
    }
}