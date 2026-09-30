class Urna
{
    private string[] candidatoNome;
    private int[] candidatoNumero;
    private int[] candidatoVotos;

    private int contaVotosNulos;
    private int contaVotosBrancos;
    private int contaVotosValidos;
    private int indexCandidato;

    public Urna(int max_candidato)
    {
        candidatoNome = new string[max_candidato];
        candidatoNumero = new int[max_candidato];
        candidatoVotos = new int[max_candidato];
        contaVotosNulos = 0;
        contaVotosBrancos = 0;
        contaVotosValidos = 0;
        indexCandidato = 0;
    }

    public void CadastroCandidato(string nome, int numero)
    {
        if (indexCandidato < candidatoNome.Length)
        {
            candidatoNome[indexCandidato] = nome;
            candidatoNumero[indexCandidato] = numero;
            indexCandidato++;
        }
    }

    public int[] GetNumCandidatos()
    {
        int[] listaCandidatos = new int[indexCandidato];
        for(int i = 0; i < indexCandidato; i++)
        {
            listaCandidatos[i] = candidatoNumero[i];
        }
        return listaCandidatos;
    }

    public string GetCandidato(int numero)
    {
        if (numero == -1)
        {
            return "VOTO EM BRANCO";
        }

        for (int i = 0; i < indexCandidato; i++)
        {
            if (candidatoNumero[i] == numero)
            {
                return candidatoNome[i];
            }
        }

        return "VOTO NULO";
    }

    public int GetVotos(int numero)
    {
        if (numero == -1)
        {
            return contaVotosBrancos;
        }

        for (int i = 0; i < indexCandidato; i++)
        {
            if (candidatoNumero[i] == numero)
            {
                return candidatoVotos[i];
            }
        }

        return contaVotosNulos;
    }

    public void Votar(int numeroVoto)
    {
        bool achou = false;       
        if (numeroVoto == -1)
        {
            contaVotosBrancos++;
        }
        else
        {
            for(int i = 0; i < indexCandidato; i++)
            {
                if (numeroVoto == candidatoNumero[i])
                {
                    candidatoVotos[i]++;
                    contaVotosValidos++;
                    achou = true;
                    break;
                }
            }

            if (achou == false)
            {
                contaVotosNulos++;
            }
        }
    }
}