using System;

class Program
{
    static void Main()
    {
        Conta a = new Conta();
        a.Titular = "Fulano Silva";


        a.MostrarSaldo();

        a.Depositar(500);

        a.MostrarSaldo();

        a.Sacar(75);

        a.MostrarSaldo();
    }
}
