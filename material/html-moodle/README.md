# Material de Programação Orientada a Objetos em C#

Este diretório guarda as 20 aulas em HTML simples, prontas para colar no TinyMCE do Moodle.

## Estrutura dos arquivos

- `lesson001.html` até `lesson020.html`
- `index.html` com índice navegável das aulas para publicação no GitHub Pages
- `assets/theme.css` com tema visual do material
- `assets/code-enhancer.js` para numeracao, destaque e copia de codigos
- HTML simples, sem dependências externas
- Um arquivo por aula

## Publicação no GitHub Pages

- A publicação usa a pasta `material/html-moodle/lessons` como artefato.
- O deploy é automático no push para `main` quando houver mudanças em `lessons`.
- Também é possível disparar manualmente o workflow de publicação completa.

Workflows configurados:

- `Validate Lessons Structure`: valida presença das 20 aulas e links no `index.html`.
- `Deploy Lessons to GitHub Pages`: publica o conteúdo de `lessons` no Pages.
- `Publicacao Completa Command`: aceita o comando de disparo e aciona o deploy.

## Regras editoriais do projeto

1. A aula 1 é a transição de C para C#.
2. A orientação a objetos começa somente na aula 2.
3. O texto da aula não deve usar a palavra `lesson` em inglês.
4. O texto deve ser simples, direto e sem analogias.
5. Todo conceito novo deve ser definido antes de aparecer no exemplo.
6. Cada aula deve ter objetivo, definições, explicação curta, exemplo, resumo e atividade.
7. Sempre padronizar os nomes dos exercícios em C no formato `Exercício NN`.
8. Todo codigo deve ser exibido com numeracao de linhas, destaque de sintaxe e botao de copia.
9. O estilo visual deve seguir padrao de livro digital legivel e profissional.

## Ordem atual das aulas

1. Transição de C para C#
2. Introdução à programação orientada a objetos
3. Classe e objeto
4. Atributos e estado
5. Métodos
6. Encapsulamento
7. Construtores
8. Propriedades
9. Modificadores de acesso
10. Herança
11. Polimorfismo
12. Abstração
13. Interfaces
14. Coleções e listas
15. Acesso a banco de dados - conceitos
16. Conexão com banco em C#
17. CRUD básico
18. Geração de relatórios
19. Distribuição do aplicativo
20. Implantação e revisão final
