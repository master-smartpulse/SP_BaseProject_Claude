---
description: Revisar código e artefatos da sessão contra constitution, arquitetura e padrões do projeto. Gera relatório de conformidade.
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

Leia `.claude/agents/review.md` e adote a persona definida. Leia também `.claude/skills/backend-architect/SKILL.md`, `.claude/skills/security-reviewer/SKILL.md`, `.claude/skills/test-designer/SKILL.md` e `.claude/skills/performance-concurrency-analyst/SKILL.md` e aplique os checklists de todas essas skills.

**Skills condicionais por plataforma** (verifique os arquivos em CHANGED_FILES):
- Se houver código de **frontend web** alterado: leia também `.claude/skills/frontend-engineer/SKILL.md`
- Se houver código **mobile** (React Native/Expo) alterado: leia também `.claude/skills/mobile-engineer/SKILL.md`

Em seguida execute os passos abaixo.

Com o contexto da sessão atual, faça o seguinte:

1. Execute o script abaixo usando a ferramenta Bash a partir da raiz do repositório e interprete a saída JSON para obter FEATURE_DIR, AVAILABLE_DOCS e CHANGED_FILES. Todos os caminhos devem ser absolutos.
   ```
   bash scripts/bash/check-review-prerequisites.sh --json
   ```
   **IMPORTANTE**: Execute o script apenas uma vez. O JSON é exibido no terminal — use-o para obter o conteúdo real.

2. Carregue **contexto obrigatório**:
   - **OBRIGATÓRIO**: `memory/constitution.md` — princípios e regras gerais
   - **OBRIGATÓRIO**: `docs/arquitetura.md` — padrões arquiteturais e convenções
   - SE EXISTIR em AVAILABLE_DOCS: spec da feature (para validar aderência funcional)
   - SE EXISTIR em AVAILABLE_DOCS: plan da feature (para validar aderência técnica)

3. Carregue `templates/review-template.md` para entender o formato de saída do relatório.

4. Identifique **todos os arquivos a revisar**:
   - Use CHANGED_FILES retornado pelo script
   - Se o usuário especificar arquivos ou escopo adicional, inclua-os
   - Se CHANGED_FILES estiver vazio, peça ao usuário para indicar os arquivos a revisar

5. Para cada arquivo alterado, leia o conteúdo e aplique os **checklists das skills carregadas**:
   - **backend-architect**: camadas, SOLID, contratos, dependências injetadas
   - **security-reviewer**: validação de entrada, dados sensíveis, auth/authz, logging seguro
   - **test-designer**: cobertura de testes, happy path, erro, edge cases, mocks
   - **performance-concurrency-analyst**: N+1, async/await, event loop, memória
   - **frontend-engineer** (se carregada): repository hooks, estados loading/erro/vazio, cache coerente
   - **mobile-engineer** (se carregada): secure store, offline, permissões, performance de listas

6. Aplique também as **regras gerais da constitution**:
   - TypeScript strict; sem `any` sem justificativa
   - Comentários apenas quando essenciais
   - Sem arquivos .md não solicitados
   - Conventional Commits (se houver commits)
   - Documentação Swagger atualizada (se endpoints novos)
   - Aderência à spec e ao plan (se existirem)

7. Gere o **relatório de revisão** usando a estrutura do `templates/review-template.md`:
   - Classifique cada achado: Crítico / Alto / Médio / Baixo
   - Inclua: arquivo, regra violada, problema e correção sugerida
   - Tabela de conformidade por área
   - Resultado final: Aprovado (zero Crítico + zero Alto) ou Reprovado

8. Se houver achados Críticos ou Altos, sugira próximos passos (quais arquivos corrigir primeiro).

9. **Ao finalizar:** Atualize sempre `IMPLEMENTATION_STATUS.md` (tabela spec × completude) e `FEATURE_LIST.md` (wiki de features do produto). Princípio 8 da Constitution.

**IDIOMA**: Todo o relatório e comunicação em **português (pt-BR)**.

**Gate**: antes de concluir, verifique o **Checklist obrigatório (gate)** definido em `.claude/agents/review.md` — só reporte conclusão se todos os itens estiverem ok.
