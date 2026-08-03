(function () {
  "use strict";

  var STORAGE_KEY_SCALE = "lesson-font-scale";
  var STORAGE_KEY_FONT = "lesson-font-choice";
  var STORAGE_KEY_THEME = "lesson-theme";
  var tabCounter = 0;
  var MIN_SCALE = 0.85;
  var MAX_SCALE = 1.45;
  var STEP_SCALE = 0.05;

  var ICONS = {
    copy: '<svg viewBox="0 0 24 24" aria-hidden="true"><rect x="9" y="9" width="11" height="11" rx="2"></rect><rect x="4" y="4" width="11" height="11" rx="2"></rect></svg>',
    download: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 3v10"></path><path d="M8 9l4 4 4-4"></path><path d="M4 17v2h16v-2"></path></svg>',
    index: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 6h12"></path><path d="M8 12h12"></path><path d="M8 18h12"></path><circle cx="4" cy="6" r="1"></circle><circle cx="4" cy="12" r="1"></circle><circle cx="4" cy="18" r="1"></circle></svg>',
    prev: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M15 18l-6-6 6-6"></path></svg>',
    next: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9 18l6-6-6-6"></path></svg>',
    circlePlus: '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="9"></circle><path d="M12 8v8"></path><path d="M8 12h8"></path></svg>',
    circleMinus: '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="9"></circle><path d="M8 12h8"></path></svg>'
  };

  var fontMap = {
    A: '"Atkinson Hyperlegible", "Calibri", "Verdana", "Helvetica", "Arial", sans-serif',
    B: '"OpenDyslexic", "Atkinson Hyperlegible", "Verdana", "Arial", sans-serif',
    C: '"Calibri", "Atkinson Hyperlegible", "Verdana", "Helvetica", "Arial", sans-serif',
    D: '"Verdana", "Calibri", "Helvetica", "Arial", sans-serif',
    E: '"Helvetica", "Arial", "Verdana", sans-serif',
    F: '"Arial", "Helvetica", "Verdana", sans-serif'
  };

  var fontHint = {
    A: "Atkinson Hyperlegible",
    B: "OpenDyslexic",
    C: "Calibri",
    D: "Verdana",
    E: "Helvetica",
    F: "Arial"
  };

  function escapeHtml(text) {
    return text
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
  }

  function tokenize(line) {
    var escaped = escapeHtml(line);
    var placeholders = [];

    function stash(match, className) {
      var token = "@@TOK" + placeholders.length + "@@";
      placeholders.push({ token: token, html: '<span class="' + className + '">' + match + "</span>" });
      return token;
    }

    escaped = escaped.replace(/("(?:[^"\\]|\\.)*")/g, function (match) {
      return stash(match, "token-string");
    });

    escaped = escaped.replace(/(\/\/.*)$/g, function (match) {
      return stash(match, "token-comment");
    });

    escaped = escaped.replace(/\b(\d+(?:\.\d+)?)\b/g, function (match) {
      return stash(match, "token-number");
    });

    escaped = escaped.replace(/\b(int|float|double|char|string|bool|void|class|struct|return|if|else|for|while|do|switch|case|break|continue|public|private|protected|static|new|using|namespace|const|virtual|override|abstract|interface|var|decimal)\b/g, function (match) {
      return stash(match, "token-keyword");
    });

    escaped = escaped.replace(/\b(Console|Math|List|SqlConnection|SqlCommand|Program|Main)\b/g, function (match) {
      return stash(match, "token-type");
    });

    escaped = escaped.replace(/\b([A-Za-z_][A-Za-z0-9_]*)\s*(?=\()/g, function (match) {
      return stash(match, "token-func");
    });

    placeholders.forEach(function (item) {
      escaped = escaped.replace(item.token, item.html);
    });

    return escaped;
  }

  function buildRow(lineNo, lineText) {
    var tr = document.createElement("tr");
    var tdNo = document.createElement("td");
    var tdCode = document.createElement("td");

    tdNo.className = "line-no";
    tdNo.textContent = lineNo;

    tdCode.className = "line-code";
    tdCode.innerHTML = tokenize(lineText);

    tr.appendChild(tdNo);
    tr.appendChild(tdCode);
    return tr;
  }

  function buildCodeTable(rawCode) {
    var lines = rawCode.split("\n");
    var table = document.createElement("table");
    table.className = "code-table";
    var tbody = document.createElement("tbody");

    lines.forEach(function (line, index) {
      tbody.appendChild(buildRow(index + 1, line));
    });

    table.appendChild(tbody);

    var scroll = document.createElement("div");
    scroll.className = "code-container-scroll";
    scroll.appendChild(table);
    return scroll;
  }

  function flashButtonState(button, message) {
    button.dataset.state = message;
    button.title = message;
    setTimeout(function () {
      button.removeAttribute("data-state");
      button.title = button.getAttribute("aria-label") || "";
    }, 1200);
  }

  function copyCode(rawCode, button) {
    navigator.clipboard.writeText(rawCode).then(function () {
      flashButtonState(button, "Copiado");
    }).catch(function () {
      flashButtonState(button, "Falhou");
    });
  }

  function extensionByLang(lang) {
    var map = {
      C: "c",
      CSHARP: "cs",
      CODIGO: "txt"
    };

    return map[lang] || "txt";
  }

  async function saveCode(rawCode, lang, button) {
    var fallbackName = "codigo." + extensionByLang(lang);

    try {
      if (window.showSaveFilePicker) {
        var handle = await window.showSaveFilePicker({
          suggestedName: fallbackName,
          types: [{
            description: "Arquivo de código",
            accept: { "text/plain": ["." + extensionByLang(lang)] }
          }]
        });

        var writable = await handle.createWritable();
        await writable.write(rawCode);
        await writable.close();
        flashButtonState(button, "Salvo");
        return;
      }

      var blob = new Blob([rawCode], { type: "text/plain;charset=utf-8" });
      var url = URL.createObjectURL(blob);
      var link = document.createElement("a");
      link.href = url;
      link.download = fallbackName;
      document.body.appendChild(link);
      link.click();
      link.remove();
      URL.revokeObjectURL(url);
      flashButtonState(button, "Baixado");
    } catch (error) {
      flashButtonState(button, "Falhou");
    }
  }

  function enhanceExerciseNavigationIcons() {
    var groups = document.querySelectorAll(".exercise-links");
    groups.forEach(function (group) {
      var controls = group.querySelectorAll("a, span.nav-disabled");
      controls.forEach(function (control) {
        var text = (control.textContent || "").trim().toLowerCase();
        var icon = "";
        var label = "";

        if (text.indexOf("indice") >= 0 || text.indexOf("índice") >= 0) {
          icon = ICONS.index;
          label = "Indice";
        } else if (text.indexOf("anterior") >= 0) {
          icon = ICONS.prev;
          label = "Anterior";
        } else if (text.indexOf("proximo") >= 0 || text.indexOf("próximo") >= 0) {
          icon = ICONS.next;
          label = "Proximo";
        }

        if (!icon) {
          return;
        }

        control.classList.add("icon-nav");
        control.innerHTML = icon;
        control.setAttribute("aria-label", label);
        if (control.tagName === "A") {
          control.title = label;
        }
      });
    });
  }

  function normalizeText(text) {
    return (text || "")
      .toLowerCase()
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .trim();
  }

  function preserveWordCase(original, replacement) {
    if (!original) {
      return replacement;
    }

    if (original === original.toUpperCase()) {
      return replacement.toUpperCase();
    }

    var first = original.charAt(0);
    if (first === first.toUpperCase()) {
      return replacement.charAt(0).toUpperCase() + replacement.slice(1);
    }

    return replacement;
  }

  function applyPtBrOrthography(text) {
    var value = text;
    var orthographyRules = [
      { pattern: /\bprogramacao\b/gi, replacement: "programação" },
      { pattern: /\blicoes\b/gi, replacement: "lições" },
      { pattern: /\bindice\b/gi, replacement: "índice" },
      { pattern: /\bobjetos\b/gi, replacement: "objetos" },
      { pattern: /\bsituacoes\b/gi, replacement: "situações" },
      { pattern: /\bdefinicao\b/gi, replacement: "definição" },
      { pattern: /\binformacao\b/gi, replacement: "informação" },
      { pattern: /\bacao\b/gi, replacement: "ação" },
      { pattern: /\bacoes\b/gi, replacement: "ações" },
      { pattern: /\bmanutencao\b/gi, replacement: "manutenção" },
      { pattern: /\bcriacao\b/gi, replacement: "criação" },
      { pattern: /\bconstrucao\b/gi, replacement: "construção" },
      { pattern: /\bvalidacoes\b/gi, replacement: "validações" },
      { pattern: /\bconsistencia\b/gi, replacement: "consistência" },
      { pattern: /\binicializacao\b/gi, replacement: "inicialização" },
      { pattern: /\bprotecao\b/gi, replacement: "proteção" },
      { pattern: /\bvariaveis\b/gi, replacement: "variáveis" },
      { pattern: /\bvarios\b/gi, replacement: "vários" },
      { pattern: /\bnecessarios\b/gi, replacement: "necessários" },
      { pattern: /\breutilizavel\b/gi, replacement: "reutilizável" },
      { pattern: /\binstancia\b/gi, replacement: "instância" },
      { pattern: /\bmetodo\b/gi, replacement: "método" },
      { pattern: /\bmetodos\b/gi, replacement: "métodos" },
      { pattern: /\bconexao\b/gi, replacement: "conexão" },
      { pattern: /\bgeracao\b/gi, replacement: "geração" },
      { pattern: /\bdistribuicao\b/gi, replacement: "distribuição" },
      { pattern: /\brevisao\b/gi, replacement: "revisão" },
      { pattern: /\bcomparacao\b/gi, replacement: "comparação" },
      { pattern: /\bpratica\b/gi, replacement: "prática" },
      { pattern: /\bvoce\b/gi, replacement: "você" },
      { pattern: /\bja\b/gi, replacement: "já" },
      { pattern: /\bnao\b/gi, replacement: "não" },
      { pattern: /\bsera\b/gi, replacement: "será" },
      { pattern: /\bexercicios\b/gi, replacement: "exercícios" },
      { pattern: /\bate\b/gi, replacement: "até" },
      { pattern: /\bfisica\b/gi, replacement: "física" },
      { pattern: /\btecnica\b/gi, replacement: "técnica" },
      { pattern: /\bSintese\b/g, replacement: "Síntese" },
      { pattern: /\batualizacao\b/gi, replacement: "atualização" },
      { pattern: /Ultima atualizacao/gi, replacement: "Última atualização" },
      { pattern: /Ultima atualização/gi, replacement: "Última atualização" },
      { pattern: /Última atualizacao/gi, replacement: "Última atualização" }
    ];

    orthographyRules.forEach(function (rule) {
      value = value.replace(rule.pattern, function (match) {
        return preserveWordCase(match, rule.replacement);
      });
    });

    return value;
  }

  function normalizeLessonHeroPattern() {
    var file = (window.location.pathname.split("/").pop() || "").toLowerCase();
    var match = file.match(/^lesson(\d{3})\.html$/);
    if (!match) {
      return;
    }

    var lessonNumber = parseInt(match[1], 10);
    if (Number.isNaN(lessonNumber)) {
      return;
    }

    var lessonLabel = "Módulo " + String(lessonNumber).padStart(2, "0");
    var hero = document.querySelector(".lesson-hero") || document.querySelector("header");
    if (!hero) {
      return;
    }

    var title = hero.querySelector(".hero-title") || hero.querySelector("h1");
    if (!title) {
      return;
    }

    var rawTitle = title.textContent.trim();
    var topic = rawTitle.replace(/^(Aula|Módulo)\s*\d+\s*-\s*/i, "").trim();
    if (!topic) {
      topic = rawTitle;
    }

    title.classList.add("hero-title");
    title.textContent = topic;

    var kicker = hero.querySelector(".hero-kicker");
    if (!kicker) {
      kicker = document.createElement("p");
      kicker.className = "hero-kicker";
      hero.insertBefore(kicker, title);
    }
    kicker.innerHTML = "<strong>" + lessonLabel + "</strong>";

    if (document.title) {
      document.title = lessonLabel + " - " + topic;
    }
  }

  function shouldSkipTextNode(node) {
    var parent = node.parentElement;
    if (!parent) {
      return true;
    }

    if (parent.closest("pre, code, script, style, textarea, .code-block")) {
      return true;
    }

    if (parent.closest("h1, h2, h3, h4, h5, h6, .hero-title, .hero-kicker, .list-title, .section-title")) {
      return true;
    }

    if (parent.closest(".term-label, .keyword-highlight")) {
      return true;
    }

    return false;
  }

  function applyTextHighlightRules() {
    var keywordList = [
      "Objetivo",
      "Conceito",
      "Conceitos",
      "Definição",
      "Definições",
      "Exemplo",
      "Exemplos",
      "Resumo",
      "Atividade",
      "Síntese",
      "Classe",
      "Objeto",
      "Atributo",
      "Método",
      "Herança",
      "Polimorfismo",
      "Encapsulamento",
      "Abstração",
      "Interface",
      "Interfaces",
      "CRUD"
    ];

    var escapedKeywords = keywordList.map(function (word) {
      return word.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    });

    var tokenRegex = new RegExp(
      "([A-ZÁÀÂÃÉÊÍÓÔÕÚÇ][A-Za-zÀ-ÿ0-9#\\/\\- ]{1,40}:)|\\b(" + escapedKeywords.join("|") + ")\\b",
      "gu"
    );

    var walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
    var nodes = [];

    while (walker.nextNode()) {
      var current = walker.currentNode;
      if (!current.nodeValue || !current.nodeValue.trim()) {
        continue;
      }
      if (!shouldSkipTextNode(current)) {
        nodes.push(current);
      }
    }

    nodes.forEach(function (node) {
      var correctedText = applyPtBrOrthography(node.nodeValue);
      tokenRegex.lastIndex = 0;

      var matches = [];
      var match;
      while ((match = tokenRegex.exec(correctedText)) !== null) {
        matches.push({
          index: match.index,
          text: match[0],
          isLabel: !!match[1]
        });
      }

      if (matches.length === 0) {
        if (correctedText !== node.nodeValue) {
          node.nodeValue = correctedText;
        }
        return;
      }

      var fragment = document.createDocumentFragment();
      var cursor = 0;

      matches.forEach(function (item) {
        if (item.index > cursor) {
          fragment.appendChild(document.createTextNode(correctedText.slice(cursor, item.index)));
        }

        var span = document.createElement("span");
        span.className = item.isLabel ? "term-label" : "keyword-highlight";
        span.textContent = item.text;
        fragment.appendChild(span);
        cursor = item.index + item.text.length;
      });

      if (cursor < correctedText.length) {
        fragment.appendChild(document.createTextNode(correctedText.slice(cursor)));
      }

      node.parentNode.replaceChild(fragment, node);
    });
  }

  function buildConceptNote(title, description) {
    var article = document.createElement("article");
    article.className = "concept-note";
    article.setAttribute("role", "listitem");

    var h3 = document.createElement("h3");
    h3.textContent = title;

    var p = document.createElement("p");
    p.textContent = description;

    article.appendChild(h3);
    article.appendChild(p);
    return article;
  }

  function normalizeConceptSections() {
    var sections = document.querySelectorAll("section");

    sections.forEach(function (section) {
      var heading = section.querySelector("h2");
      if (!heading) {
        return;
      }

      var headingText = normalizeText(heading.textContent);
      if (headingText.indexOf("conceito") === -1) {
        return;
      }

      if (section.querySelector(".concept-board")) {
        return;
      }

      var keywords = section.querySelectorAll(".keywords > span");
      var listItems = section.querySelectorAll("ul li");
      var concepts = [];
      var conceptKeys = new Set();

      function pushConcept(text) {
        var clean = (text || "").trim();
        if (!clean) {
          return;
        }

        var key = normalizeText(clean);
        if (!key || conceptKeys.has(key)) {
          return;
        }

        conceptKeys.add(key);
        concepts.push(clean);
      }

      if (keywords.length > 0) {
        keywords.forEach(function (item) {
          pushConcept(item.textContent);
        });
      } else if (listItems.length > 0) {
        listItems.forEach(function (item) {
          pushConcept(item.textContent);
        });
      }

      if (concepts.length === 0) {
        return;
      }

      var paragraphs = Array.from(section.querySelectorAll("p"));
      var usedParagraphs = new Set();
      var board = document.createElement("div");
      board.className = "concept-board";
      board.setAttribute("role", "list");
      board.setAttribute("aria-label", "Painel de conceitos desta aula");

      concepts.forEach(function (concept) {
        var conceptKey = normalizeText(concept);
        var best = null;
        var bestScore = -1;

        paragraphs.forEach(function (paragraph) {
          if (usedParagraphs.has(paragraph)) {
            return;
          }

          var pText = normalizeText(paragraph.textContent);
          if (!pText) {
            return;
          }

          var score = -1;
          if (pText.indexOf(conceptKey + ":") === 0 || pText.indexOf(conceptKey + " ") === 0 || pText === conceptKey) {
            score = 3;
          } else if (pText.indexOf(conceptKey) !== -1) {
            score = 1;
          }

          if (score > bestScore) {
            best = paragraph;
            bestScore = score;
          }
        });

        var description = "Conceito central desta aula que será aplicado nos exemplos e atividades.";
        if (best) {
          description = best.textContent.trim();
          usedParagraphs.add(best);
        }

        board.appendChild(buildConceptNote(concept, description));
      });

      heading.insertAdjacentElement("afterend", board);

      var oldKeywords = section.querySelector(".keywords");
      if (oldKeywords) {
        oldKeywords.remove();
      }

      var oldList = section.querySelector("ul");
      if (oldList) {
        oldList.remove();
      }

      usedParagraphs.forEach(function (paragraph) {
        paragraph.remove();
      });

      var escapedConcepts = concepts.map(function (concept) {
        return normalizeText(concept).replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
      }).filter(Boolean);

      if (escapedConcepts.length > 0) {
        var leftoverConceptRule = new RegExp("^(" + escapedConcepts.join("|") + ")(\\b|\\s|:)", "i");
        Array.from(section.querySelectorAll("p")).forEach(function (paragraph) {
          if (paragraph.classList.contains("concept-summary")) {
            return;
          }

          var pText = normalizeText(paragraph.textContent);
          if (leftoverConceptRule.test(pText)) {
            paragraph.remove();
          }
        });
      }

      if (!section.querySelector(".concept-summary")) {
        var summary = document.createElement("p");
        summary.className = "concept-summary";
        summary.innerHTML = "<strong>Síntese:</strong> estes conceitos formam a base da aula e devem ser usados em conjunto durante os exercícios.";
        board.insertAdjacentElement("afterend", summary);
      }
    });
  }

  function clamp(value, min, max) {
    return Math.min(max, Math.max(min, value));
  }

  function setScale(value) {
    var next = clamp(value, MIN_SCALE, MAX_SCALE);
    document.documentElement.style.setProperty("--font-scale", next.toFixed(2));
    localStorage.setItem(STORAGE_KEY_SCALE, String(next));
  }

  function getStoredScale() {
    var raw = parseFloat(localStorage.getItem(STORAGE_KEY_SCALE));
    if (Number.isNaN(raw)) {
      return 1;
    }
    return clamp(raw, MIN_SCALE, MAX_SCALE);
  }

  function applyFontChoice(choice) {
    var body = document.body;
    var keys = Object.keys(fontMap);
    keys.forEach(function (key) {
      body.classList.remove("font-" + key);
    });

    var selected = fontMap[choice] ? choice : "A";
    body.classList.add("font-" + selected);
    document.documentElement.style.setProperty("--chosen-font", fontMap[selected]);
    localStorage.setItem(STORAGE_KEY_FONT, selected);

    var buttons = document.querySelectorAll(".access-btn[data-font-key]");
    buttons.forEach(function (button) {
      if (button.dataset.fontKey === selected) {
        button.classList.add("active");
      } else {
        button.classList.remove("active");
      }
    });
  }

  function createButton(text, title) {
    var button = document.createElement("button");
    button.type = "button";
    button.className = "access-btn";
    button.textContent = text;
    button.title = title;
    button.setAttribute("aria-label", title);
    return button;
  }

  function createAccessibilityControls() {
    if (document.querySelector(".access-controls")) {
      return;
    }

    var panel = document.createElement("div");
    panel.className = "access-controls";

    var plus = createButton("+", "Aumentar fonte");
    var minus = createButton("-", "Reduzir fonte");

    plus.innerHTML = ICONS.circlePlus;
    plus.classList.add("access-icon-btn");
    minus.innerHTML = ICONS.circleMinus;
    minus.classList.add("access-icon-btn");

    plus.addEventListener("click", function () {
      setScale(getStoredScale() + STEP_SCALE);
    });

    minus.addEventListener("click", function () {
      setScale(getStoredScale() - STEP_SCALE);
    });

    panel.appendChild(plus);
    panel.appendChild(minus);

    Object.keys(fontMap).forEach(function (key) {
      var fontName = fontHint[key];
      var btn = createButton(key, fontName);
      btn.dataset.fontKey = key;
      btn.addEventListener("click", function () {
        applyFontChoice(key);
      });
      panel.appendChild(btn);
    });

    document.body.appendChild(panel);
  }

  function applyTheme(theme) {
    var resolved = theme === "light" ? "light" : "dark";
    document.documentElement.setAttribute("data-theme", resolved);
    localStorage.setItem(STORAGE_KEY_THEME, resolved);

    var button = document.querySelector(".theme-toggle");
    if (button) {
      button.setAttribute("aria-checked", String(resolved === "dark"));
      button.setAttribute(
        "aria-label",
        resolved === "dark" ? "Alternar para tema claro" : "Alternar para tema escuro"
      );
    }
  }

  function toggleTheme() {
    var current = document.documentElement.getAttribute("data-theme") || "dark";
    var next = current === "dark" ? "light" : "dark";
    applyTheme(next);
  }

  function createThemeToggle() {
    if (document.querySelector(".theme-toggle")) {
      return;
    }

    var host = document.querySelector("header") || document.querySelector(".hero");
    if (!host) {
      return;
    }

    var button = document.createElement("button");
    button.type = "button";
    button.className = "theme-toggle";
    button.setAttribute("role", "switch");
    button.setAttribute("aria-checked", "false");
    button.innerHTML = [
      '<span class="theme-toggle-icon" aria-hidden="true">',
      '<span class="icon-sun-circle"></span>',
      '<svg class="icon-sun" viewBox="0 0 24 24">',
      '<circle cx="12" cy="12" r="4"></circle>',
      '<path d="M12 2v2"></path><path d="M12 20v2"></path>',
      '<path d="M4.93 4.93l1.41 1.41"></path><path d="M17.66 17.66l1.41 1.41"></path>',
      '<path d="M2 12h2"></path><path d="M20 12h2"></path>',
      '<path d="M6.34 17.66l-1.41 1.41"></path><path d="M19.07 4.93l-1.41 1.41"></path>',
      '</svg>',
      '<svg class="icon-moon" viewBox="0 0 24 24">',
      '<path d="M21 12.79A9 9 0 1 1 11.21 3a7 7 0 0 0 9.79 9.79z"></path>',
      '</svg>',
      '</span>'
    ].join("");
    button.setAttribute("aria-label", "Alternar tema claro e escuro");
    button.addEventListener("click", toggleTheme);

    host.insertBefore(button, host.firstChild);

    var active = localStorage.getItem(STORAGE_KEY_THEME) || "light";
    applyTheme(active);
  }

  function applyExerciseAlternatingBackgrounds() {
    var exercises = document.querySelectorAll(".exercise-container");
    exercises.forEach(function (section, index) {
      if ((index + 1) % 2 === 0) {
        section.classList.add("exercise-even");
      } else {
        section.classList.remove("exercise-even");
      }
    });
  }

  function enhanceExercisePairsWithTabs() {
    var pairs = document.querySelectorAll(".exercise-pair");
    pairs.forEach(function (pair) {
      var cCode = pair.querySelector("code[data-lang='c']");
      var csCode = pair.querySelector("code[data-lang='csharp']");

      if (!cCode || !csCode) {
        return;
      }

      var rawC = cCode.textContent.replace(/\n$/, "");
      var rawCs = csCode.textContent.replace(/\n$/, "");

      tabCounter += 1;
      var tabIdC = "pair-" + tabCounter + "-c";
      var tabIdCs = "pair-" + tabCounter + "-cs";

      var container = document.createElement("div");
      container.className = "code-tabs-container";

      var tabsHeader = document.createElement("div");
      tabsHeader.className = "tabs-header";

      var tabsGroup = document.createElement("div");
      tabsGroup.className = "tabs-group";

      var cTabBtn = document.createElement("button");
      cTabBtn.type = "button";
      cTabBtn.className = "tab-btn c-tab active";
      cTabBtn.textContent = "Linguagem C";
      cTabBtn.dataset.target = tabIdC;

      var csTabBtn = document.createElement("button");
      csTabBtn.type = "button";
      csTabBtn.className = "tab-btn cs-tab";
      csTabBtn.textContent = "Linguagem C#";
      csTabBtn.dataset.target = tabIdCs;

      tabsGroup.appendChild(cTabBtn);
      tabsGroup.appendChild(csTabBtn);

      var actions = document.createElement("div");
      actions.className = "toolbar-actions";

      var copyButton = document.createElement("button");
      copyButton.type = "button";
      copyButton.className = "copy-btn icon-only-btn";
      copyButton.innerHTML = ICONS.copy;
      copyButton.setAttribute("aria-label", "Copiar codigo");
      copyButton.title = "Copiar codigo";

      var saveButton = document.createElement("button");
      saveButton.type = "button";
      saveButton.className = "copy-btn download-btn icon-only-btn";
      saveButton.innerHTML = ICONS.download;
      saveButton.setAttribute("aria-label", "Salvar codigo");
      saveButton.title = "Salvar codigo";

      actions.appendChild(copyButton);
      actions.appendChild(saveButton);

      tabsHeader.appendChild(tabsGroup);
      tabsHeader.appendChild(actions);

      var cTabContent = document.createElement("div");
      cTabContent.id = tabIdC;
      cTabContent.className = "tab-content active";
      cTabContent.dataset.rawCode = rawC;
      cTabContent.appendChild(buildCodeTable(rawC));

      var csTabContent = document.createElement("div");
      csTabContent.id = tabIdCs;
      csTabContent.className = "tab-content";
      csTabContent.dataset.rawCode = rawCs;
      csTabContent.appendChild(buildCodeTable(rawCs));

      function activateTab(button) {
        container.querySelectorAll(".tab-btn").forEach(function (btn) {
          btn.classList.remove("active");
        });
        container.querySelectorAll(".tab-content").forEach(function (content) {
          content.classList.remove("active");
        });

        button.classList.add("active");
        var target = container.querySelector("#" + button.dataset.target);
        if (target) {
          target.classList.add("active");
        }
      }

      cTabBtn.addEventListener("click", function () {
        activateTab(cTabBtn);
      });

      csTabBtn.addEventListener("click", function () {
        activateTab(csTabBtn);
      });

      copyButton.addEventListener("click", function () {
        var activeTab = container.querySelector(".tab-content.active");
        var code = activeTab ? activeTab.dataset.rawCode : "";
        copyCode(code, copyButton);
      });

      saveButton.addEventListener("click", function () {
        var activeTab = container.querySelector(".tab-content.active");
        var code = activeTab ? activeTab.dataset.rawCode : "";
        var lang = activeTab && activeTab.id === tabIdC ? "C" : "CSHARP";
        saveCode(code, lang, saveButton);
      });

      container.appendChild(tabsHeader);
      container.appendChild(cTabContent);
      container.appendChild(csTabContent);

      pair.innerHTML = "";
      pair.appendChild(container);
    });
  }

  function enhancePre(pre) {
    if (pre.dataset.enhanced === "true") {
      return;
    }

    var code = pre.querySelector("code") || pre;
    var rawCode = code.textContent.replace(/\n$/, "");
    var lang = (code.dataset.lang || pre.dataset.lang || "codigo").toUpperCase();
    var figure = document.createElement("figure");
    figure.className = "code-block";

    var toolbar = document.createElement("div");
    toolbar.className = "code-toolbar";

    var langTag = document.createElement("span");
    langTag.className = "lang";
    langTag.textContent = lang;

      var actions = document.createElement("div");
      actions.className = "toolbar-actions";

      var copyButton = document.createElement("button");
      copyButton.className = "copy-btn icon-only-btn";
      copyButton.type = "button";
      copyButton.innerHTML = ICONS.copy;
      copyButton.setAttribute("aria-label", "Copiar codigo");
      copyButton.title = "Copiar codigo";
      copyButton.addEventListener("click", function () {
        copyCode(rawCode, copyButton);
      });

      var saveButton = document.createElement("button");
      saveButton.className = "copy-btn download-btn icon-only-btn";
      saveButton.type = "button";
      saveButton.innerHTML = ICONS.download;
      saveButton.setAttribute("aria-label", "Salvar codigo");
      saveButton.title = "Salvar codigo";
      saveButton.addEventListener("click", function () {
        saveCode(rawCode, lang, saveButton);
      });

      actions.appendChild(copyButton);
      actions.appendChild(saveButton);

    toolbar.appendChild(langTag);
      toolbar.appendChild(actions);

    var table = buildCodeTable(rawCode);
    figure.appendChild(toolbar);
    figure.appendChild(table);

    pre.replaceWith(figure);
    pre.dataset.enhanced = "true";
  }

  document.addEventListener("DOMContentLoaded", function () {
    var savedTheme = localStorage.getItem(STORAGE_KEY_THEME) || "light";
    applyTheme(savedTheme);

    normalizeLessonHeroPattern();
    applyTextHighlightRules();

    createThemeToggle();

    enhanceExercisePairsWithTabs();
    applyExerciseAlternatingBackgrounds();
    enhanceExerciseNavigationIcons();
    normalizeConceptSections();

    var blocks = document.querySelectorAll("pre");
    blocks.forEach(enhancePre);

    setScale(getStoredScale());
    createAccessibilityControls();

    applyFontChoice("A");
  });
})();
