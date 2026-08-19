using System;
using System.Runtime.CompilerServices;

class Conta
{
    public string Titular = "";
    decimal Saldo = 0;

    public void MostrarSaldo()
    {
        Console.WriteLine();
        Console.WriteLine($"Titular: {Titular}");
        Console.WriteLine($"Conta Saldo: {Saldo}");
    }

    public void Depositar(decimal valor)
    {
        Saldo += valor;
    }
    
    public void Sacar(decimal valor)
    {
        if (valor <= 0)
        {
            Console.WriteLine();
            Console.WriteLine("Valor inválido. O valor deve ser maior que 0 (zero).");
        }
        else if (valor > Saldo)
        {
            Console.WriteLine();
            Console.WriteLine("Valor inválido. O valor deve ser menor ou igual ao saldo atual.");
        }
        else
        {
            Saldo -= valor;
            Console.WriteLine();
            Console.WriteLine($"O valor {valor} foi sacado com sucesso!");
        }
    }

}