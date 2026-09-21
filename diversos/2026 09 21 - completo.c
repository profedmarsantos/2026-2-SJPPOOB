using System;

namespace SimuladorUrna
{
    // ==========================================
    // CLASSE: CANDIDATO
    // ==========================================
    class Candidato
    {
        public int Numero { get; set; }
        public string Nome { get; set; }
        public int Votos { get; set; }

        public Candidato(int numero, string nome)
        {
            Numero = numero;
            Nome = nome;
            Votos = 0; // Todo candidato inicia a votação com zero votos
        }
    }

    // ==========================================
    // CLASSE: URNA ELETRÔNICA
    // ==========================================
    class UrnaEletronica
    {
        private Candidato[] listaCandidatos;
        private int votosBrancos;
        private int votosNulos;
        private string numeroDigitadoAtual;

        public UrnaEletronica()
        {
            votosBrancos = 0;
            votosNulos = 0;
            numeroDigitadoAtual = "";

            // Inicialização do vetor com candidatos estáticos para teste
            listaCandidatos = new Candidato[]
            {
                new Candidato(11, "Candidato A"),
                new Candidato(22, "Candidato B")
            };
        }

        // Simula o clique dos botões numéricos (0-9) do display
        public void PressionarBotaoNumerico(int numero)
        {
            // Limita o voto em até 2 dígitos para este exemplo
            if (numeroDigitadoAtual.Length < 2)
            {
                numeroDigitadoAtual += numero.ToString();
                AtualizarDisplay();
            }
        }

        // Simula o clique do botão BRANCO
        public void PressionarBotaoBranco()
        {
            numeroDigitadoAtual = "BRANCO";
            AtualizarDisplay();
        }

        // Simula o clique do botão CORRIGE
        public void PressionarBotaoCorrige()
        {
            numeroDigitadoAtual = "";
            AtualizarDisplay();
        }

        // Simula o clique do botão CONFIRMA (Verde)
        public void PressionarBotaoConfirma()
        {
            // Impede a confirmação se o display estiver totalmente vazio
            if (string.IsNullOrEmpty(numeroDigitadoAtual)) return;

            if (numeroDigitadoAtual == "BRANCO")
            {
                votosBrancos++;
            }
            else
            {
                int numeroVotado = int.Parse(numeroDigitadoAtual);
                bool candidatoEncontrado = false;

                // Percorre o vetor de objetos buscando correspondência do número
                for (int i = 0; i < listaCandidatos.Length; i++)
                {
                    if (listaCandidatos[i].Numero == numeroVotado)
                    {
                        listaCandidatos[i].Votos++;
                        candidatoEncontrado = true;
                        break;
                    }
                }

                // Se o número digitado não pertencer a nenhum candidato cadastrado
                if (!candidatoEncontrado)
                {
                    votosNulos++;
                }
            }

            Console.Beep(440, 400); // Emite o som de confirmação da urna
            numeroDigitadoAtual = ""; 
            Console.Clear();
            Console.WriteLine("=============================");
            Console.WriteLine("       VOTO COMPUTADO!       ");
            Console.WriteLine("=============================");
        }

        // Imprime o Boletim de Urna com a apuração dos resultados
        public void ExibirBoletimUrna()
        {
            Console.Clear();
            Console.WriteLine("========================================");
            Console.WriteLine("           BOLETIM DE URNA              ");
            Console.WriteLine("========================================");
            
            foreach (var candidato in listaCandidatos)
            {
                Console.WriteLine($"Nº {candidato.Numero} - {candidato.Nome}: {candidato.Votos} voto(s)");
            }

            Console.WriteLine("----------------------------------------");
            Console.WriteLine($"Votos em Branco: {votosBrancos}");
            Console.WriteLine($"Votos Nulos: {votosNulos}");
            Console.WriteLine("========================================");
        }

        private void AtualizarDisplay()
        {
            Console.Clear();
            Console.WriteLine("===== URNA ELETRÔNICA =====");
            Console.WriteLine($"Digitado: {numeroDigitadoAtual}");
            Console.WriteLine("===========================");
        }
    }

    // ==========================================
    // CLASSE DE ENTRADA: PROGRAM (CONTÉM O MAIN)
    // ==========================================
    class Program
    {
        static void Main(string[] args)
        {
            UrnaEletronica urna = new UrnaEletronica();
            bool continuarVotando = true;

            while (continuarVotando)
            {
                Console.Clear();
                Console.WriteLine("========================================");
                Console.WriteLine("     INTERFACE DE CONTROLE DO HARDWARE  ");
                Console.WriteLine("========================================");
                Console.WriteLine(" [0 a 9] - Digita o número");
                Console.WriteLine(" [B]     - Botão BRANCO");
                Console.WriteLine(" [C]     - Botão CORRIGE");
                Console.WriteLine(" [V]     - Botão CONFIRMA (Verde)");
                Console.WriteLine(" [S]     - Sair e Emitir Boletim de Urna");
                Console.WriteLine("========================================");
                Console.Write("\nPressione uma tecla para acionar a urna: ");
                
                ConsoleKeyInfo tecla = Console.ReadKey(true);
                char caractere = char.ToUpper(tecla.KeyChar);

                if (char.IsDigit(caractere))
                {
                    int numero = int.Parse(caractere.ToString());
                    urna.PressionarBotaoNumerico(numero);
                }
                else if (caractere == 'B')
                {
                    urna.PressionarBotaoBranco();
                }
                else if (caractere == 'C')
                {
                    urna.PressionarBotaoCorrige();
                }
                else if (caractere == 'V')
                {
                    urna.PressionarBotaoConfirma();
                    Console.WriteLine("\nLiberado para o próximo eleitor. Pressione qualquer tecla...");
                    Console.ReadKey();
                }
                else if (caractere == 'S')
                {
                    continuarVotando = false;
                }
            }

            // Exibe a apuração ao encerrar o sistema
            urna.ExibirBoletimUrna();
            Console.WriteLine("\nProcesso de votação encerrado.");
        }
    }
}
