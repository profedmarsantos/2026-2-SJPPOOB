#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script de Pré-processamento Local de Submissões (C#/POO) - Curso SJPPOOB
Python 3.13+

Objetivo:
- Escanear submissões de alunos na pasta 'avaliacoes/<pasta>/atividades/'.
- Identificar submissões por ID do participante Moodle.
- Isolar e compilar cada submissão via `dotnet build` em pasta temporária.
- Executar suíte de testes (`dotnet test`), se aplicável.
- Filtrar e resumir logs de erro/warning de compilação sem carregar o código-fonte inteiro no LLM.
- Gerar o arquivo `_diagnostico_local.json` com custo ZERO de tokens para o modelo.
"""

import os
import re
import json
import csv
import shutil
import subprocess
import argparse
from pathlib import Path

PROCESS_TIMEOUT_SECONDS = 90

def parse_arguments():
    parser = argparse.ArgumentParser(description="Pré-processador local de submissões de C#.")
    parser.add_argument("--avaliacao", required=True, help="Caminho da pasta da avaliação (ex.: avaliacoes/A2N1)")
    return parser.parse_args()

def extrair_participante_id(filename: str) -> str | None:
    match = re.search(r'_(\d+)_assignsubmission_file_', filename)
    if match:
        return match.group(1)
    return None

def mapear_submissoes(pasta_atividades: Path) -> dict[str, list[Path]]:
    submissoes = {}
    if not pasta_atividades.exists():
        return submissoes

    for file_path in pasta_atividades.rglob('*'):
        if file_path.is_file():
            p_id = extrair_participante_id(file_path.name)
            if p_id:
                if p_id not in submissoes:
                    submissoes[p_id] = []
                submissoes[p_id].append(file_path)
    return submissoes

def carregar_participantes(csv_path: Path) -> list[dict[str, str]]:
    with csv_path.open('r', encoding='utf-8-sig', newline='') as arquivo:
        registros = list(csv.DictReader(arquivo))

    participantes = []
    for registro in registros:
        identificador = (registro.get('Identificador') or '').strip()
        match = re.fullmatch(r'Participante(\d+)', identificador)
        if match:
            participantes.append({
                'participante_id': identificador,
                'participante_id_numerico': match.group(1),
                'status_csv': (registro.get('Status') or '').strip(),
            })
    if not participantes:
        raise ValueError(f'Nenhum participante no formato Participante<id> foi encontrado em {csv_path}')
    return participantes

def criar_projeto_temp(scratch_dir: Path, arquivos: list[Path]) -> Path:
    if scratch_dir.exists():
        shutil.rmtree(scratch_dir)
    scratch_dir.mkdir(parents=True, exist_ok=True)

    project_file = scratch_dir / "Submissao.csproj"
    project_file.write_text(
        "<Project Sdk=\"Microsoft.NET.Sdk\">\n"
        "  <PropertyGroup>\n"
        "    <OutputType>Exe</OutputType>\n"
        "    <TargetFramework>net8.0</TargetFramework>\n"
        "    <ImplicitUsings>disable</ImplicitUsings>\n"
        "    <Nullable>disable</Nullable>\n"
        "  </PropertyGroup>\n"
        "</Project>\n",
        encoding="utf-8"
    )

    program_default = scratch_dir / "Program.cs"
    if program_default.exists() and len(arquivos) > 0:
        program_default.unlink()

    nomes_usados = set()
    for arq in arquivos:
        if arq.suffix.lower() in ['.cs', '.txt']:
            if '_assignsubmission_file_' in arq.name:
                dest_name = arq.name.split('_assignsubmission_file_', 1)[1]
            else:
                dest_name = arq.name
            if not dest_name.endswith('.cs'):
                dest_name += '.cs'
            base_name = Path(dest_name).stem
            extension = Path(dest_name).suffix
            candidate = dest_name
            index = 2
            while candidate in nomes_usados:
                candidate = f'{base_name}_{index}{extension}'
                index += 1
            dest_name = candidate
            nomes_usados.add(dest_name)
            shutil.copy(arq, scratch_dir / dest_name)

    return scratch_dir

def executar_build(scratch_dir: Path) -> dict:
    try:
        res = subprocess.run(
            ["dotnet", "build"],
            cwd=scratch_dir,
            capture_output=True,
            text=True,
            timeout=PROCESS_TIMEOUT_SECONDS,
            check=False
        )
        erros = []
        for line in (res.stdout + '\n' + res.stderr).splitlines():
            if ": error " in line or ": warning " in line:
                erros.append(line.strip())
        
        return {
            "compilou": res.returncode == 0,
            "codigo_saida": res.returncode,
            "mensagens_diagnostico": erros if erros else ["Compilação concluída sem erros."]
            ,"testes": {
                "executado": False,
                "motivo": "Nenhuma suíte de testes foi fornecida pela submissão; o projeto temporário executa apenas dotnet build."
            }
        }
    except subprocess.TimeoutExpired:
        return {
            "compilou": False,
            "codigo_saida": -2,
            "mensagens_diagnostico": [f"dotnet build excedeu o limite de {PROCESS_TIMEOUT_SECONDS} segundos."],
            "testes": {
                "executado": False,
                "motivo": "A compilação excedeu o tempo limite."
            }
        }
    except Exception as e:
        return {
            "compilou": False,
            "codigo_saida": -1,
            "mensagens_diagnostico": [f"Erro na execução do dotnet build: {str(e)}"],
            "testes": {
                "executado": False,
                "motivo": "A compilação não pôde ser iniciada."
            }
        }

def processar_avaliacao(pasta_eval: Path):
    pasta_atividades = pasta_eval / "atividades"
    scratch_base = Path("_scratch")
    csv_paths = sorted(pasta_eval.glob('Notas-*.csv'))
    if len(csv_paths) != 1:
        raise ValueError(f'Esperado exatamente um CSV Notas-*.csv em {pasta_eval}; encontrados {len(csv_paths)}')

    participantes = carregar_participantes(csv_paths[0])
    submissoes_mapeadas = mapear_submissoes(pasta_atividades)
    diagnostico_final = {
        "avaliacao": str(pasta_eval),
        "csv_roster": str(csv_paths[0]),
        "total_participantes": len(participantes),
        "total_submissoes": len(submissoes_mapeadas),
        "resultados": []
    }

    for participante in participantes:
        p_id = participante['participante_id_numerico']
        arquivos = submissoes_mapeadas.get(p_id, [])
        if not arquivos:
            diagnostico_final["resultados"].append({
                **participante,
                "status_envio": "Sem envio",
                "qtd_arquivos": 0,
                "arquivos": [],
                "compilacao": None,
            })
            continue

        scratch_dir = scratch_base / f"p_{p_id}"
        try:
            criar_projeto_temp(scratch_dir, arquivos)
            build_res = executar_build(scratch_dir)
        except subprocess.TimeoutExpired:
            build_res = {
                "compilou": False,
                "codigo_saida": -2,
                "mensagens_diagnostico": [f"dotnet new excedeu o limite de {PROCESS_TIMEOUT_SECONDS} segundos."],
                "testes": {
                    "executado": False,
                    "motivo": "A preparação da compilação excedeu o tempo limite."
                }
            }
        except Exception as erro:
            build_res = {
                "compilou": False,
                "codigo_saida": -1,
                "mensagens_diagnostico": [f"Falha ao preparar a submissão: {erro}"],
                "testes": {
                    "executado": False,
                    "motivo": "A preparação da compilação falhou."
                }
            }

        diagnostico_final["resultados"].append({
            **participante,
            "status_envio": "Com envio",
            "qtd_arquivos": len(arquivos),
            "arquivos": [a.name for a in arquivos],
            "compilacao": build_res
        })

        if scratch_dir.exists():
            shutil.rmtree(scratch_dir, ignore_errors=True)

    out_file = pasta_eval / "_diagnostico_local.json"
    with open(out_file, "w", encoding="utf-8") as f:
        json.dump(diagnostico_final, f, indent=2, ensure_ascii=False)

    resultados = diagnostico_final["resultados"]
    com_envio = [r for r in resultados if r["status_envio"] == "Com envio"]
    sem_envio = [r for r in resultados if r["status_envio"] == "Sem envio"]
    builds_aprovados = [r for r in com_envio if r["compilacao"] and r["compilacao"]["compilou"]]
    builds_reprovados = [r for r in com_envio if not r["compilacao"] or not r["compilacao"]["compilou"]]
    ids = {r["participante_id"] for r in resultados}
    print(f"DIAGNOSTICO_GERADO|CAMINHO={out_file}")
    print(f"CONTADORES|IDS_CSV={len(participantes)}|RESULTADOS={len(resultados)}|COM_ENVIO={len(com_envio)}|SEM_ENVIO={len(sem_envio)}|BUILD_APROVADO={len(builds_aprovados)}|BUILD_REPROVADO={len(builds_reprovados)}|IDS_UNICOS={len(ids)}")
    print("PREPROCESSAMENTO_CONCLUIDO|STATUS=SUCESSO")

if __name__ == "__main__":
    args = parse_arguments()
    processar_avaliacao(Path(args.avaliacao))
