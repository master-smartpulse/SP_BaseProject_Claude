---
description: Executar o plano de implementação processando e executando todas as tasks definidas no tasks.md
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

Leia `.claude/agents/implement.md` e adote a persona definida. Leia também `.claude/skills/implementation-engineer/SKILL.md` e `.claude/skills/test-designer/SKILL.md` e aplique seus checklists durante a implementação.

**Skills condicionais por plataforma** (verifique o Tipo de Projeto no plan.md e as tasks da feature):
- Se a feature envolver **frontend web** (React, Next.js, Vite): leia também `.claude/skills/frontend-engineer/SKILL.md`
- Se a feature envolver **mobile** (React Native, Expo): leia também `.claude/skills/mobile-engineer/SKILL.md`
- Se a feature for apenas backend, não carregue nenhuma das duas.

Em seguida execute os passos abaixo.

Com o contexto atual da feature, faça o seguinte:

1. Execute o script abaixo usando a ferramenta Bash a partir da raiz do repositório e interprete a lista FEATURE_DIR e AVAILABLE_DOCS. Todos os caminhos devem ser absolutos.
   ```
   bash scripts/bash/check-implementation-prerequisites.sh --json
   ```

2. Carregue **contexto completo** (máximo contexto) — não pule nenhum artefato disponível. Carregue e analise:
   - **OBRIGATÓRIO**: **Spec** da feature (ex.: spec.md em FEATURE_DIR) — para alinhar implementação aos requisitos
   - **OBRIGATÓRIO**: **plan.md** — stack, arquitetura, estrutura de arquivos
   - **OBRIGATÓRIO**: **tasks.md** — lista completa de tasks e plano de execução
   - **OBRIGATÓRIO**: **memory/constitution.md** e **docs/arquitetura.md** (sempre ler; caminho a partir da raiz do repo)
   - SE EXISTIR: data-model.md (entidades e relacionamentos)
   - SE EXISTIR: contracts/ (especificações da API e requisitos de teste)
   - SE EXISTIR: research.md (decisões técnicas e restrições)
   - SE EXISTIR: quickstart.md (cenários de integração)

3. Interprete a estrutura do tasks.md e extraia:
   - **Fases das tasks**: Setup, Testes, Núcleo, Integração, Polish
   - **Dependências**: Regras de execução sequencial vs paralela
   - **Detalhes**: ID, descrição, caminhos de arquivo, marcadores [P]
   - **Fluxo de execução**: Ordem e requisitos de dependência

4. Execute a implementação seguindo o plano de tasks:
   - **Execução por fases**: Conclua cada fase antes de passar à próxima
   - **Respeite dependências**: Execute tasks sequenciais na ordem; tasks [P] podem rodar em paralelo
   - **Siga TDD**: Execute tasks de teste antes das tasks de implementação correspondentes
   - **Coordenação por arquivo**: Tasks que afetam os mesmos arquivos devem rodar em sequência
   - **Pontos de validação**: Verifique a conclusão de cada fase antes de avançar

5. Regras de execução da implementação:
   - **Setup primeiro**: Inicialize estrutura do projeto, dependências, configuração
   - **Testes antes do código**: Escreva testes para contratos, entidades e cenários de integração quando necessário
   - **Desenvolvimento do núcleo**: Implemente modelos, serviços, comandos CLI, endpoints
   - **Integração**: Conexões com banco, middleware, logging, serviços externos
   - **Polish e validação**: Testes unitários, otimização de performance, documentação

6. Acompanhamento de progresso e tratamento de erros:
   - Informe o progresso após cada task concluída
   - Interrompa a execução se alguma task não paralela falhar
   - Para tasks [P], continue com as que tiverem sucesso e informe as que falharem
   - Forneça mensagens de erro claras com contexto para depuração
   - Sugira próximos passos se a implementação não puder prosseguir
   - **IMPORTANTE** Para tasks concluídas, marque como [X] no arquivo tasks.md.

7. Validação de conclusão:
   - Verifique se todas as tasks obrigatórias foram concluídas
   - Confira se a implementação corresponde à especificação original
   - Valide se os testes passam e a cobertura atende aos requisitos
   - Confirme se a implementação segue o plano técnico
   - Informe o status final com resumo do trabalho concluído

8. **Ao finalizar:** Atualize sempre `IMPLEMENTATION_STATUS.md` (tabela spec × completude) e `FEATURE_LIST.md` (wiki de features do produto). Princípio 8 da Constitution.

**IDIOMA**: Documentação, specs e mensagens ao usuário em **português (pt-BR)**. Código, comentários no código e commits em **inglês** (constitution, Regra Geral 5).

**Gate**: antes de concluir, verifique o **Checklist obrigatório (gate)** definido em `.claude/agents/implement.md` — só reporte conclusão se todos os itens estiverem ok.

Observação: Este comando assume que existe um tasks.md completo. Se as tasks estiverem incompletas ou ausentes, sugira executar `/tasks` primeiro para regenerar a lista.
