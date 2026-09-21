#!/usr/bin/env python3
"""Gera evidencia reproduzivel de semelhanca entre submissaoes, sem atribuir autoria."""
import hashlib
import json
import re
import sys
from collections import defaultdict
from pathlib import Path


def participant_id(path: Path) -> str | None:
    match = re.search(r"_(\d+)_assignsubmission_file_", path.name)
    return match.group(1) if match else None


def normalized_lines(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8", errors="replace")
    lines = []
    for line in text.splitlines():
        line = re.sub(r"//.*$", "", line).strip()
        line = re.sub(r"\s+", " ", line)
        if line:
            lines.append(line)
    return lines


def main() -> int:
    if len(sys.argv) != 2:
        print("Uso: python analisar-indicios-submissoes.py <pasta-avaliacao>", file=sys.stderr)
        return 2
    root = Path(sys.argv[1]) / "atividades"
    files = sorted(path for path in root.rglob("*.cs") if participant_id(path))
    hashes = defaultdict(list)
    blocks = defaultdict(list)
    participants = defaultdict(list)
    for path in files:
        pid = participant_id(path)
        content = path.read_bytes()
        digest = hashlib.sha256(content).hexdigest()
        hashes[digest].append({"participante_id": pid, "arquivo": path.name})
        lines = normalized_lines(path)
        participants[pid].append(path.name)
        for index in range(len(lines) - 7):
            block = "\n".join(lines[index:index + 8])
            blocks[block].append({"participante_id": pid, "arquivo": path.name, "linha_inicial": index + 1})

    exact = [group for group in hashes.values() if len({item["participante_id"] for item in group}) > 1]
    repeated = [group for group in blocks.values() if len({item["participante_id"] for item in group}) > 1]
    stylized = []
    for path in files:
        text = path.read_text(encoding="utf-8", errors="replace")
        markers = [marker for marker in ("///", "#region", "#nullable", "record ") if marker in text]
        if markers:
            stylized.append({"participante_id": participant_id(path), "arquivo": path.name, "marcas": markers})

    if exact or repeated:
        status = "Indicio a revisar"
    elif files:
        status = "Nenhum indicio concreto"
    else:
        status = "Analise nao conclusiva"
    report = {
        "schema": "sjppooob.indicios.v1",
        "status": status,
        "arquivos_analisados": len(files),
        "hashes_identicos_entre_participantes": exact,
        "trechos_normalizados_identicos_entre_participantes": repeated[:100],
        "marcas_estilisticas_atipicas": stylized,
        "observacao": "Indicios nao alteram a nota automaticamente e exigem revisao docente.",
    }
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
