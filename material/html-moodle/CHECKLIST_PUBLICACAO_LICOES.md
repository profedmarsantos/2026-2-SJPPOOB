# Checklist de Publicacao das Licoes HTML

Use este checklist sempre que fizer publicacao das licoes em `material/html-moodle/lessons`.

## 1. Escopo da atualizacao

- [ ] Confirmar se a alteracao foi pontual (uma ou poucas licoes) ou completa (todas as licoes).

## 2. Log de ultima atualizacao

Formato obrigatorio em cada licao:

`Ultima atualizacao: DD/MM/AAAA`

- [ ] Em alteracao pontual: atualizar somente o log das licoes alteradas.
- [ ] Em alteracao completa: atualizar o log de `lesson001.html` ate `lesson020.html` com a mesma data.
- [ ] Confirmar que todas as licoes possuem o bloco visivel `Ultima atualizacao`.

## 3. Verificacao tecnica

- [ ] Validar que `index.html` existe e abre os links das 20 licoes.
- [ ] Validar que cada licao inclui `assets/theme.css` e `assets/code-enhancer.js`.
- [ ] Validar que nao ha erros de estrutura HTML nas paginas alteradas.

## 4. Fluxo de publicacao

- [ ] Rodar o script `scripts/publicacao-completa.ps1` quando for publicacao completa.
- [ ] Confirmar commit com mensagem iniciando por `chore(publicacao):`.
- [ ] Confirmar push para `origin main`.
- [ ] Confirmar disparo do workflow de deploy do GitHub Pages.
