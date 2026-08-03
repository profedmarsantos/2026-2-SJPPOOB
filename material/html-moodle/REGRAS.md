# Regras do projeto

- A aula 1 faz a transição de C para C#.
- A orientação a objetos começa na aula 2.
- O texto das aulas não usa a palavra `lesson` em inglês.
- O conteúdo deve ser simples, direto e sem analogias.
- Cada conceito novo precisa ser definido antes do uso.
- Cada aula precisa seguir a mesma estrutura editorial.
- Os arquivos continuam com nome `lesson001.html` até `lesson020.html`.
- Os exercícios em C devem ser nomeados no padrão `Exercício NN` dentro das aulas.
- Todo bloco de código deve usar formatacao com destaque de sintaxe, numeracao de linhas e botao de copia.
- O tema visual das paginas deve seguir o estilo livro digital: legivel, moderno e não cansativo.
- Palavras importantes e conceitos-chave devem ser destacados no texto para facilitar estudo.
- A linguagem deve ser natural, clara, direta e adequada para alunos do 1o ano do ensino medio.
- Sempre que redigir, incluir ou editar qualquer texto, realizar verificacao ortografica e gramatical antes de finalizar.
- Sempre que surgir nova determinacao pedagogica ou tecnica, este arquivo de regras deve ser atualizado.
- Paleta base do projeto: lavanda `#D3D3FF`, com variacoes suaves para ambiente relaxante.
- Para dinamismo visual, combinar lavanda com toques de amarelo/verde e azul claro, sem prejudicar leitura.
- Garantir contraste alto entre texto e fundo (preferencia por texto escuro para conteúdo longo).
- Fonte padrao do projeto: Atkinson Hyperlegible.
- Incluir painel vertical no canto inferior direito com botoes: +, -, A, B, C, D, E, F.
- Botoes circulares de acessibilidade devem permanecer pequenos (referencia atual: cerca de 12px de diametro) para não poluir a tela.
- Botoes de fonte devem mapear para: A Atkinson Hyperlegible, B OpenDyslexic, C Calibri, D Verdana, E Helvetica, F Arial.
- Cada botao de fonte deve exibir hint com o nome da fonte no hover e aplicar mudanca no clique.
- Ao clicar em cada botao de fonte, a familia selecionada deve ser aplicada de forma deterministica ao texto da pagina.
- Botoes + e - devem aumentar/reduzir o tamanho da fonte de forma progressiva por cliques sucessivos.
- Todas as seções das aulas devem ser numeradas ou hierarquizadas para facilitar referencia do aluno.
- Toda pagina de licao em `material/html-moodle/lessons/lessonNNN.html` deve exibir na propria pagina um log visivel de ultima atualizacao no formato `Ultima atualizacao: DD/MM/AAAA`.
- Ao editar apenas uma licao, atualizar somente o log dessa pagina.
- Ao realizar atualizacao completa do projeto de licoes, atualizar o log de todas as paginas de licao para a mesma data.

## Responsividade obrigatoria

- Toda alteracao visual deve preservar leitura e uso em desktop, tablet e mobile sem sobreposição de elementos.
- Nao usar larguras fixas que gerem rolagem horizontal em telas pequenas.
- Hero com botao de tema deve manter espaco reservado para o botao em telas medias e grandes.
- Em telas pequenas, componentes de cabecalho e abas devem quebrar linha de forma controlada.
- Botoes iconicos devem manter area de toque minima de 32x32.
- Tabelas e conteudos longos devem quebrar texto ou permitir rolagem local, nunca estourar o layout da pagina.
- Antes de concluir qualquer ajuste de UI, validar no minimo em 1280px, 768px e 360px.

## Estrutura padrão da aula

1. Título
2. Objetivo
3. Conceitos da aula
4. Definições
5. Explicação curta
6. Exemplo curto
7. Resumo
8. Atividade

## Padrao técnico de apresentacao

1. Incluir `assets/theme.css` em todas as paginas de aulas.
2. Incluir `assets/code-enhancer.js` em todas as paginas de aulas.
3. Garantir consistencia visual entre as 20 aulas e o indice.
4. Incluir e manter o log `Ultima atualizacao: DD/MM/AAAA` em cada pagina de licao.