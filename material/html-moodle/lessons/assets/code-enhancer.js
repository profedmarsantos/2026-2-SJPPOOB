(function () {
  "use strict";

  function escapeHtml(text) {
    return text
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
  }

  function tokenize(line) {
    var escaped = escapeHtml(line);

    escaped = escaped.replace(/(\/\/.*)$/g, '<span class="token-comment">$1</span>');
    escaped = escaped.replace(/("(?:[^"\\]|\\.)*")/g, '<span class="token-string">$1</span>');
    escaped = escaped.replace(/\b(\d+(?:\.\d+)?)\b/g, '<span class="token-number">$1</span>');
    escaped = escaped.replace(/\b(int|float|double|char|string|bool|void|class|struct|return|if|else|for|while|do|switch|case|break|continue|public|private|protected|static|new|using|namespace|const|virtual|override|abstract|interface|var|decimal)\b/g, '<span class="token-keyword">$1</span>');
    escaped = escaped.replace(/\b(Console|Math|List|SqlConnection|SqlCommand|Program|Main)\b/g, '<span class="token-type">$1</span>');
    escaped = escaped.replace(/\b([A-Za-z_][A-Za-z0-9_]*)\s*(?=\()/g, '<span class="token-func">$1</span>');

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
  });
})();
