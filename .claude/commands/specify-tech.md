---
description: Criar ou atualizar a especificação técnica para correção de bugs, melhorias, refatoração ou débito técnico.
argument-hint: descrição do bug, melhoria ou refatoração
allowed-tools: Bash, Read, Write, Edit, Task
---

Leia `.claude/agents/specify-tech.md` e adote a persona definida. O agente define as skills a carregar (tech-expert sempre; security-reviewer, performance-concurrency-analyst ou data-modeler conforme a categoria do problema) — siga-o. Em seguida execute os passos abaixo.

Com a descrição de correção de bug, melhoria técnica ou refatoração fornecida como argumento, faça o seguinte:

1. Execute o script abaixo usando a ferramenta Bash a partir da raiz do repositório e interprete a saída JSON para obter BRANCH_NAME e SPEC_FILE. Todos os caminhos de arquivo devem ser absolutos.
   ```
   bash scripts/bash/create-tech-spec.sh --json "$ARGUMENTS"
   ```
   **IMPORTANTE** Execute o script apenas uma vez. O JSON é exibido no terminal — use-o para obter o conteúdo real.
2. Carregue `templates/spec-template-tech.md` para entender as seções obrigatórias.
3. **OBRIGATÓRIO — Perspectiva tech-expert**: Com base na skill `.claude/skills/tech-expert/SKILL.md`, avalie a descrição fornecida: sugira abordagem técnica, padrões aplicáveis, riscos arquiteturais e conformidade com `memory/constitution.md` e `docs/arquitetura.md`. Use essa avaliação para enriquecer a spec.
4. Escreva a especificação técnica em SPEC_FILE usando a estrutura do template, incorporando a orientação do tech-expert. Substitua os placeholders por detalhes concretos derivados da descrição (argumentos). Preserve a ordem e os títulos das seções.
   **IDIOMA**: Toda especificação e documentação deve ser escrita em **português (pt-BR)**.
5. **Checkpoint de aprovação**: apresente um resumo da spec técnica (problema, causa raiz ou hipóteses, critérios de aceite, escopo) e **pergunte explicitamente se o usuário aprova** antes de sugerir `/plan`. Se restar `[PRECISA INVESTIGAÇÃO]`, informe as hipóteses do agente debugger (quando despachado) e o que faltou para concluir; se restar `[PRECISA ESCLARECIMENTO]` de decisão do usuário, sugira `/clarify` antes do `/plan`.

6. **Ao finalizar:** Atualize `IMPLEMENTATION_STATUS.md` e `FEATURE_LIST.md` conforme as regras definidas nos próprios arquivos. Princípio 8 da Constitution.

**Gate**: antes de concluir, verifique o **Checklist obrigatório (gate)** definido em `.claude/agents/specify-tech.md` — só reporte conclusão se todos os itens estiverem ok.

Observação: O script cria e faz checkout do novo branch e inicializa o arquivo da spec antes da escrita.
