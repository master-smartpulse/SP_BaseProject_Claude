# Status da Implementação

**Objetivo:** rastrear o estágio e a completude de cada spec/feature com critérios operacionais (não subjetivos).

**Fórmula da completude:** `Impl (%) = tasks marcadas [X] ÷ total de tasks do tasks.md` (arredondar para inteiro). Sem tasks.md ainda, a coluna fica `—`.

**Definição de Pronto (DoD):** uma feature está **PRONTA** quando, cumulativamente:
1. 100% das tasks do tasks.md marcadas [X];
2. `review.md` com resultado **APROVADO** (zero Crítico + zero Alto);
3. Verificação executável do review verde (typecheck, lint e testes).

**Quando atualizar:** ao finalizar os comandos que mudam estado de feature — `/specify`, `/specify-tech`, `/implement`, `/review` e `/specify-design` (quando cria/altera funcionalidade visível). `/plan`, `/tasks`, `/clarify` e `/analyze` não atualizam esta tabela; as colunas Plan/Tasks são preenchidas pelo próximo comando que atualizar a linha (o estágio é derivável da existência dos artefatos em `specs/`).

---

| Spec | Spec | Plan | Tasks | Impl (%) | Review | DoD |
|------|:----:|:----:|:-----:|:--------:|:------:|:---:|
| (nenhuma) | — | — | — | — | — | — |

**Legenda:** Spec/Plan/Tasks: ✓ = artefato existe e completo | Impl (%): fórmula acima | Review: APROVADO / REPROVADO / — | DoD: PRONTA / EM ANDAMENTO

---

**Última atualização:** (a definir)
