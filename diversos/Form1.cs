namespace _2026_09_30___WinFormsApp1
{
    public partial class Form1 : Form
    {
        Urna urnaIFSP;

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            urnaIFSP = new Urna(4);
            urnaIFSP.CadastroCandidato("Fulano", 11);
            urnaIFSP.CadastroCandidato("Ciclano", 22);
            urnaIFSP.CadastroCandidato("Beltrano", 33);
            urnaIFSP.CadastroCandidato("Deu Cano", 44);
            label2.Text = "";


        }

        private void AdicionarDigito(string digito)
        {
            if (textBox1.Text == "BRANCO")
            {
                textBox1.Text = digito;
            }
            else
            {
                textBox1.Text += digito;
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            AdicionarDigito("1");
        }

        private void button2_Click(object sender, EventArgs e)
        {
            AdicionarDigito("2");
        }

        private void button3_Click(object sender, EventArgs e)
        {
            AdicionarDigito("3");
        }

        private void button4_Click(object sender, EventArgs e)
        {
            AdicionarDigito("4");
        }

        private void button5_Click(object sender, EventArgs e)
        {
            AdicionarDigito("5");
        }

        private void button6_Click(object sender, EventArgs e)
        {
            AdicionarDigito("6");
        }

        private void button7_Click(object sender, EventArgs e)
        {
            AdicionarDigito("7");
        }

        private void button8_Click(object sender, EventArgs e)
        {
            AdicionarDigito("8");
        }

        private void button9_Click(object sender, EventArgs e)
        {
            AdicionarDigito("9");
        }

        private void button10_Click(object sender, EventArgs e)
        {
            AdicionarDigito("0");
        }

        private void button12_Click(object sender, EventArgs e)
        {
            textBox1.Text = "BRANCO";
            label2.Text = urnaIFSP.GetCandidato(-1);
        }

        private void button11_Click(object sender, EventArgs e)
        {
            textBox1.Text = "";
            label2.Text = "";
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

            int x;
            if (int.TryParse(textBox1.Text, out x))
            {
                label2.Text = urnaIFSP.GetCandidato(x);
            }
        }

        private void button13_Click(object sender, EventArgs e)
        {
            int numeroVoto;
            if (int.TryParse(textBox1.Text, out numeroVoto))
            {
                urnaIFSP.Votar(numeroVoto);
            }
            else
            {
                urnaIFSP.Votar(-1);
            }
            textBox1.Text = "";
            label2.Text = "";
        }

        private void button14_Click(object sender, EventArgs e)
        {
            string msg = "";

            int[] num = urnaIFSP.GetNumCandidatos();

            for (int i = 0; i < num.Length; i++)
            {
                msg += $"Nome: {urnaIFSP.GetCandidato(num[i])} n°{num[i]}\n";
                msg += $"Votos: {urnaIFSP.GetVotos(num[i])}\n";
                msg += $"--\n";
            }

            msg += $"Votos Brancos: {urnaIFSP.GetVotos(-1)}\n";
            msg += $"Votos Nulos: {urnaIFSP.GetVotos(0)}\n";

            MessageBox.Show(msg);
        }
    }
}
