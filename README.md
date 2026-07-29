# 2026-2-SJPPOOB

Repositorio da disciplina com material de apoio e aulas em HTML.

## Estrutura principal

- `exercicios_anteriores_em_c/`: exercicios e exemplos em C.
- `material/html-moodle/lessons/`: 20 licoes em HTML para Moodle e publicacao web.
- `material/html-moodle/lessons/index.html`: pagina inicial com links e resumo das licoes.

## Publicacao GitHub Pages

A publicacao esta configurada para servir o conteudo de:

- `material/html-moodle/lessons`

Workflows:

- `.github/workflows/lessons-quality.yml`: valida estrutura e links das licoes.
- `.github/workflows/pages-deploy.yml`: faz o deploy no GitHub Pages.
- `.github/workflows/publicacao-completa.yml`: aceita comando de publicacao completa e dispara deploy.

## Bootstrap do repositorio no GitHub

Se a pasta ainda nao estiver como repositorio Git local, execute:

```powershell
./scripts/setup-repositorio-github.ps1 -GitHubOwner SEU_USUARIO_OU_ORG
```

Esse script:

1. Inicializa o Git local (se necessario).
2. Define o branch principal como `main`.
3. Configura o remote `origin` para `https://github.com/SEU_USUARIO_OU_ORG/2026-2-SJPPOOB.git`.

## Comando do projeto: publicacao completa

Sempre que for solicitado "publicacao completa", o fluxo esperado e:

1. Validar a estrutura da pasta `material/html-moodle/lessons`.
2. Atualizar o repositorio com todas as alteracoes.
3. Fazer push no branch principal (`main`).
4. Disparar publicacao no GitHub Pages.

Para executar localmente no PowerShell:

```powershell
./scripts/publicacao-completa.ps1
```

Opcionalmente, o workflow `Publicacao Completa Command` tambem pode ser disparado manualmente no GitHub Actions.
