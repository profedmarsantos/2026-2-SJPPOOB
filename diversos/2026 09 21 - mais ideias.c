using System;

namespace SimuladorUrna
{
    // ==========================================
    // CLASSE BASE (MÃE): CANDIDATO
    // ==========================================
    class Candidato
    {
        public int Numero { get; set; }
        public string Nome { get; set; }
        public int Votos { get; set; }
        public string Cargo { get; protected set; } // Protected permite que as classes filhas alterem

        public Candidato(int numero, string nome)
        {
            Numero = numero;
            Nome = nome;
            Votos = 0;
            Cargo = "Candidato";
        }

        // Método virtual que poderá ser customizado (polimorfismo) se quisermos fotos diferentes
        public virtual void DesenharFoto()
        {
            Console.WriteLine("     +-------+ ");
            Console.WriteLine("     |  (o)  | ");
            Console.WriteLine("     |  /|\\  | ");
            Console.WriteLine("     +-------+ ");
        }
    }

    // ==========================================
    // CLASSE FILHA: VEREADOR (HERANÇA)
    // ==========================================
    class Vereador : Candidato
    {
        // O construtor chama o construtor da classe mãe usando o 'base'
        public Vereador(int numero, string nome) : base(numero, nome)
        {
            Cargo = "Vereador"; // Define o cargo específico
        }

        // Sobrescreve o desenho da foto com um detalhe diferente (ex: usando óculos)
        public override void DesenharFoto()
        {
            Console.WriteLine("     +-------+ [VEREADOR]");
            Console.WriteLine("     |  [oO] | ");
            Console.WriteLine("     |  /|\\  | ");
            Console.WriteLine("     +-------+ ");
        }
    }

    // ==========================================
    // CLASSE FILHA: PREFEITO (HERANÇA)
    // ==========================================
    class Prefeito : Candidato
    {
        public Prefeito(int numero, string nome) : base(numero, nome)
        {
            Cargo = "Prefeito";
        }

        // Sobrescreve o desenho da foto (ex: usando gravata/paletó)
        public override void DesenharFoto()
        {
            Console.WriteLine("     +-------+ [PREFEITO]");
            Console.WriteLine("     |  (o)  | ");
            Console.WriteLine("     |  <|>  | ");
            Console.WriteLine("     +-------+ ");
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

            // O vetor aceita tanto Prefeito quanto Vereador porque ambos SÃO Candidatos (Polimorfismo!)
            listaCandidatos = new Candidato[]
            {
                new Vereador(111, "Chiquinho do Bairro"),
                new Prefeito(22, "Dra. Helena Maria")
            };
        }

        public void PressionarBotaoNumerico(int numero)
        {
            // Aumentamos o limite para 3 dígitos para aceitar o Vereador (111)
            if (numeroDigitadoAtual.Length < 3)
            {
                numeroDigitadoAtual += numero.ToString();
                AtualizarDisplay();
            }
        }

        public void PressionarBotaoBranco()
        {
            numeroDigitadoAtual = "BRANCO";
            AtualizarDisplay();
        }

        public void PressionarBotaoCorrige()
        {
            numeroDigitadoAtual = "";
            AtualizarDisplay();
        }

        public void PressionarBotaoConfirma()
        {
            if (string.IsNullOrEmpty(numeroDigitadoAtual)) return;

            if (numeroDigitadoAtual == "BRANCO")
            {
                votosBrancos++;
            }
            else
            {
                int numeroVotado = int.Parse(numeroDigitadoAtual);
                bool candidatoEncontrado = false;

                for (int i = 0; i < listaCandidatos.Length; i++)
                {
                    if (listaCandidatos[i].Numero == numeroVotado)
                    {
                        listaCandidatos[i].Votos++;
                        candidatoEncontrado = true;
                        break;
                    }
                }

                if (!candidatoEncontrado)
                {
                    votosNulos++;
                }
            }

            Console.Beep(440, 400);
            numeroDigitadoAtual = ""; 
            Console.Clear();
            Console.WriteLine("=============================");
            Console.WriteLine("       VOTO COMPUTADO!       ");
            Console.WriteLine("=============================");
        }

        public void ExibirBoletimUrna()
        {
            Console.Clear();
            Console.WriteLine("========================================");
            Console.WriteLine("           BOLETIM DE URNA              ");
            Console.WriteLine("========================================");
            
            foreach (var candidato in listaCandidatos)
            {
                // Mostra o cargo dinamicamente graças à herança
                Console.WriteLine($"[{candidato.Cargo}] Nº {candidato.Numero} - {candidato.Nome}: {candidato.Votos} voto(s)");
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
            Console.WriteLine("---------------------------");

            // Se não for branco nem estiver vazio, tenta buscar o candidato para exibir os dados antes de confirmar
            if (!string.IsNullOrEmpty(numeroDigitadoAtual) && numeroDigitadoAtual != "BRANCO")
            {
                int numeroVotado = int.Parse(numeroDigitadoAtual);
                Candidato candidatoEncontrado = null;

                for (int i = 0; i < listaCandidatos.Length; i++)
                {
                    if (listaCandidatos[i].Numero == numeroVotado)
                    {
                        candidatoEncontrado = listaCandidatos[i];
                        break;
                    }
                }

                if (candidatoEncontrado != null)
                {
                    Console.WriteLine($"Cargo: {candidatoEncontrado.Cargo}");
                    Console.WriteLine($"Nome:  {candidatoEncontrado.Nome}");
                    Console.WriteLine("FOTO:");
                    candidatoEncontrado.DesenharFoto(); // Desenha a foto correspondente à classe filha
                }
                else
                {
                    // Regra de negócio: se digitou a quantidade máxima de dígitos e não achou ninguém
                    if (numeroDigitadoAtual.Length >= 2)
                    {
                        Console.WriteLine("\n[VOTO NULO]");
                        Console.WriteLine("Número não correspondente a nenhum candidato.");
                    }
                }
            }
            else if (numeroDigitadoAtual == "BRANCO")
            {
                Console.WriteLine("\n[VOTO EM BRANCO]");
            }

            Console.WriteLine("===========================");
        }
    }

    // ==========================================
    // CLASSE DE ENTRADA: PROGRAM
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

            urna.ExibirBoletimUrna();
