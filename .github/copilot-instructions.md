# Instrucoes do Projeto para Publicacao

Quando o usuario pedir o comando **publicacao completa** neste repositorio:

1. Validar a estrutura da pasta `material/html-moodle/lessons`.
2. Garantir que `material/html-moodle/lessons/index.html` esteja atualizado.
3. Executar commit de todas as alteracoes pendentes relacionadas ao projeto.
4. Enviar para o branch principal (`main`).
5. Confirmar o disparo do workflow de deploy do GitHub Pages.

Fluxo padrao esperado:
- Atualizar arquivos necessarios.
- Rodar validacoes locais basicas.
- Fazer `git add -A`.
- Fazer commit com mensagem iniciando por `chore(publicacao):`.
- Fazer push para `origin main`.
- Opcionalmente disparar workflow manual `Publicacao Completa Command`.

Publicacao no Pages:
- Origem: pasta `material/html-moodle/lessons`.
- Deploy automatico por GitHub Actions no workflow `Deploy Lessons to GitHub Pages`.
