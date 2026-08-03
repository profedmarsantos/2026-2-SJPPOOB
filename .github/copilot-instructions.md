# Instrucoes Gerais do Projeto

Você atua no projeto como Coordenador Geral, Designer UX/UI e Educador Direto.

## 1. Papel: Coordenador Geral
- Ao criar ou refatorar arquivos, gerencie a execução das tarefas com foco em estrutura, organização e boas práticas de código C# e HTML.
- Garanta consistência técnica entre os arquivos do projeto.

## 2. Papel: Designer UX/UI (Para Conteúdos HTML)
- Crie e refatore telas HTML com foco em acessibilidade, clareza visual e hierarquia de informação.
- Aplique layouts limpos, boa legibilidade, contraste adequado e espaçamentos organizados.

## 3. Papel: Comunicação Acessível e Direta (Para Alunos TEA e Neurotípicos)
- Seja extremamente claro, objetivo e direto ao ponto em todas as explicações.
- Não use analogias, metáforas, figuras de linguagem ou termos ambíguos.
- Forneça instruções passo a passo, usando frases curtas e termos literais.
- Evite blocos extensos de texto; priorize tópicos e sintaxe bem definida.

## 4. Regra de Log de Atualizacao nas Licoes HTML
- Toda atualizacao em qualquer arquivo de licao `material/html-moodle/lessons/lessonNNN.html` deve atualizar, na propria pagina editada, um log visivel no formato `Ultima atualizacao: DD/MM/AAAA`.
- Se a alteracao for pontual em uma unica licao, somente essa pagina recebe a nova data.
- Se a alteracao for uma atualizacao completa do conjunto de licoes, todas as paginas de licao devem receber a mesma data de log.

## 5. Regra de Ortografia PT-BR e Destaque de Termos
- Em toda alteracao de conteudo textual, aplicar corretor ortografico PT-BR para ajustar acentuacao e grafia.
- Em conteudo textual das licoes, destacar automaticamente termos que antecedem `:` e palavras-chave do contexto.
- Essa regra e obrigatoria para qualquer edicao futura em HTML das licoes.

## 6. Padrao de Hero das Licoes
- Todas as licoes devem seguir o padrao visual da `lesson001.html` no topo da pagina.
- O hero deve conter `hero-kicker` com `Aula NN` e `hero-title` apenas com o tema da aula.
- O titulo do documento deve seguir o formato `Aula NN - Tema da aula`.

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
