---
description: Criar ou atualizar a especificação da feature a partir de uma descrição em linguagem natural.
allowed-tools: Bash, Read, Write, Edit
---

Leia `.claude/agents/specify.md` e adote a persona definida. Leia também `.claude/skills/product-spec-writer/SKILL.md` e `.claude/skills/ux-design-reviewer/SKILL.md` e aplique seus checklists. Em seguida execute os passos abaixo.

Com a descrição da feature fornecida como argumento, faça o seguinte:

1. Execute o script abaixo usando a ferramenta Bash a partir da raiz do repositório e interprete a saída JSON para obter BRANCH_NAME e SPEC_FILE. Todos os caminhos de arquivo devem ser absolutos.
   ```
   bash scripts/bash/create-new-feature.sh --json "$ARGUMENTS"
   ```
   **IMPORTANTE** Execute o script apenas uma vez. O JSON é exibido no terminal — use-o para obter o conteúdo real.
2. Carregue `templates/spec-template.md` para entender as seções obrigatórias.
3. Escreva a especificação em SPEC_FILE usando a estrutura do template, substituindo os placeholders por detalhes concretos derivados da descrição da feature (argumentos), preservando a ordem e os títulos das seções.
   **IDIOMA**: Toda especificação e documentação gerada deve ser escrita em **português (pt-BR)**.
4. Informe a conclusão com nome do branch, caminho do arquivo da spec e prontidão para a próxima fase.

5. **Ao finalizar:** Atualize sempre `IMPLEMENTATION_STATUS.md` (tabela spec × completude) e `FEATURE_LIST.md` (wiki de features do produto). Princípio 8 da Constitution.

**Gate**: antes de concluir, verifique o **Checklist obrigatório (gate)** definido em `.claude/agents/specify.md` — só reporte conclusão se todos os itens estiverem ok.

Observação: O script cria e faz checkout do novo branch e inicializa o arquivo da spec antes da escrita.
