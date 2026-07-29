(function () {
  "use strict";

  var STORAGE_KEY_SCALE = "lesson-font-scale";
  var STORAGE_KEY_FONT = "lesson-font-choice";
  var MIN_SCALE = 0.85;
  var MAX_SCALE = 1.45;
  var STEP_SCALE = 0.05;

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
      var token = "__TOK" + placeholders.length + "__";
      placeholders.push({ token: token, html: '<span class="' + className + '">' + match + "</span>" });
      return token;
    }

    escaped = escaped.replace(/("(?:[^"\\]|\\.)*")/g, function (match) {
      return stash(match, "token-string");
    });

    escaped = escaped.replace(/(\/\/.*)$/g, function (match) {
      return stash(match, "token-comment");
    });

    escaped = escaped.replace(/\b(\d+(?:\.\d+)?)\b/g, '<span class="token-number">$1</span>');
    escaped = escaped.replace(/\b(int|float|double|char|string|bool|void|class|struct|return|if|else|for|while|do|switch|case|break|continue|public|private|protected|static|new|using|namespace|const|virtual|override|abstract|interface|var|decimal)\b/g, '<span class="token-keyword">$1</span>');
    escaped = escaped.replace(/\b(Console|Math|List|SqlConnection|SqlCommand|Program|Main)\b/g, '<span class="token-type">$1</span>');
    escaped = escaped.replace(/\b([A-Za-z_][A-Za-z0-9_]*)\s*(?=\()/g, '<span class="token-func">$1</span>');

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

  function copyCode(rawCode, button) {
    navigator.clipboard.writeText(rawCode).then(function () {
      var original = button.textContent;
      button.textContent = "Copiado";
      setTimeout(function () {
        button.textContent = original;
      }, 1300);
    }).catch(function () {
      button.textContent = "Falhou";
      setTimeout(function () {
        button.textContent = "Copiar";
      }, 1300);
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

  function enhancePre(pre) {
    if (pre.dataset.enhanced === "true") {
      return;
    }

    var code = pre.querySelector("code") || pre;
    var rawCode = code.textContent.replace(/\n$/, "");
    var lang = (code.dataset.lang || pre.dataset.lang || "codigo").toUpperCase();
    var lines = rawCode.split("\n");

    var figure = document.createElement("figure");
    figure.className = "code-block";

    var toolbar = document.createElement("div");
    toolbar.className = "code-toolbar";

    var langTag = document.createElement("span");
    langTag.className = "lang";
    langTag.textContent = lang;

    var copyButton = document.createElement("button");
    copyButton.className = "copy-btn";
    copyButton.type = "button";
    copyButton.textContent = "Copiar";
    copyButton.addEventListener("click", function () {
      copyCode(rawCode, copyButton);
    });

    toolbar.appendChild(langTag);
    toolbar.appendChild(copyButton);

    var table = document.createElement("table");
    table.className = "code-table";
    var tbody = document.createElement("tbody");

    lines.forEach(function (line, index) {
      tbody.appendChild(buildRow(index + 1, line));
    });

    table.appendChild(tbody);
    figure.appendChild(toolbar);
    figure.appendChild(table);

    pre.replaceWith(figure);
    pre.dataset.enhanced = "true";
  }

  document.addEventListener("DOMContentLoaded", function () {
    var blocks = document.querySelectorAll("pre");
    blocks.forEach(enhancePre);

    setScale(getStoredScale());
    createAccessibilityControls();

    var savedFontChoice = localStorage.getItem(STORAGE_KEY_FONT) || "A";
    applyFontChoice(savedFontChoice);
  });
})();
