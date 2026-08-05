# 2026-2-SJPPOOB

Repositorio da disciplina com material de apoio e aulas em HTML.

## Estrutura principal

- `exercicios_anteriores_em_c/`: exercicios e exemplos em C.
- `material/html-moodle/lessons/`: 20 licoes em HTML para Moodle e Publicação web.
- `material/html-moodle/lessons/index.html`: pagina inicial com links e resumo das licoes.
- `.github/agents/modulo-writer.agent.md`: fonte oficial do agente didático deste projeto.
- `scripts/sync-modulo-writer-agent.ps1`: sincroniza o agente do projeto para a pasta global do Copilot.

## Agente do projeto (fonte unica)

Este repositorio adota fonte unica para o agente `modulo-writer`.

- Arquivo oficial: `.github/agents/modulo-writer.agent.md`
- Destino de uso local do Copilot: `C:/Users/<usuario>/.copilot/agents/modulo-writer.agent.md`

Sempre que o agente for alterado no repositorio, sincronize com:

```powershell
./scripts/sync-modulo-writer-agent.ps1
```

## Publicação GitHub Pages

A Publicação esta configurada para servir o conteúdo de:

- `material/html-moodle/lessons`

Workflows:

- `.github/workflows/lessons-quality.yml`: valida estrutura e links das licoes.
- `.github/workflows/pages-deploy.yml`: faz o deploy no GitHub Pages.
- `.github/workflows/Publicação-completa.yml`: aceita comando de Publicação completa e dispara deploy.

## Bootstrap do repositorio no GitHub

Se a pasta ainda não estiver como repositorio Git local, execute:

```powershell
./scripts/setup-repositorio-github.ps1 -GitHubOwner SEU_USUARIO_OU_ORG
```

Esse script:

1. Inicializa o Git local (se necessário).
2. Define o branch principal como `main`.
3. Configura o remote `origin` para `https://github.com/SEU_USUARIO_OU_ORG/2026-2-SJPPOOB.git`.

## Comando do projeto: Publicação completa

Sempre que for solicitado "Publicação completa", o fluxo esperado e:

1. Validar a estrutura da pasta `material/html-moodle/lessons`.
2. Atualizar o repositorio com todas as alteracoes.
3. Fazer push no branch principal (`main`).
4. Disparar Publicação no GitHub Pages.

Para executar localmente no PowerShell:

```powershell
./scripts/Publicação-completa.ps1
```

Para executar com sincronizacao automatica do agente modulo-writer antes do commit:

```powershell
./scripts/Publicação-completa.ps1 -SincronizarAgente
```

Opcionalmente, o workflow `Publicação Completa Command` também pode ser disparado manualmente no GitHub Actions.
