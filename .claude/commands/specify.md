---
description: Criar ou atualizar a especificação da feature a partir de uma descrição em linguagem natural.
argument-hint: descrição da feature em linguagem natural
allowed-tools: Bash, Read, Write, Edit
---

Leia `.claude/agents/specify.md` e adote a persona definida. Leia também `.claude/skills/product-spec-writer/SKILL.md` e `.claude/skills/ux-design-reviewer/SKILL.md` e aplique seus checklists. Em seguida execute os passos abaixo.

Com a descrição da feature fornecida como argumento, faça o seguinte:

1. Execute o script abaixo usando a ferramenta Bash a partir da raiz do repositório e interprete a saída JSON para obter BRANCH_NAME e SPEC_FILE. Todos os caminhos de arquivo devem ser absolutos.
   ```
   bash scripts/bash/create-new-feature.sh --json "$ARGUMENTS"
   ```
   **IMPORTANTE** Execute o script apenas uma vez. O JSON é exibido no terminal — use-o para obter o conteúdo real.
   - **Criar**: o script cria a branch nova a partir da `main` (não da branch atual) e o diretório da feature.
   - **Atualizar**: se o pedido for atualizar a spec da feature **atual** (já em branch de feature), rode com `--update` — o script reutiliza o diretório sem criar branch nem sobrescrever a spec preenchida; você então edita o SPEC_FILE existente.
2. Carregue `templates/spec-template.md` para entender as seções obrigatórias.
3. Escreva a especificação em SPEC_FILE usando a estrutura do template, substituindo os placeholders por detalhes concretos derivados da descrição da feature (argumentos), preservando a ordem e os títulos das seções.
   **IDIOMA**: Toda especificação e documentação gerada deve ser escrita em **português (pt-BR)**.
4. **Checkpoint de aprovação**: apresente um resumo da spec (valor de negócio, requisitos-chave, critérios de sucesso, `[PRECISA ESCLARECIMENTO]` pendentes) e **pergunte explicitamente se o usuário aprova**. Se houver marcadores pendentes, sugira `/clarify` como próxima etapa; senão, sugira `/plan`. Não inicie a próxima etapa sem aprovação.

5. **Ao finalizar:** Atualize `IMPLEMENTATION_STATUS.md` e `FEATURE_LIST.md` conforme as regras definidas nos próprios arquivos. Princípio 8 da Constitution.

**Gate**: antes de concluir, verifique o **Checklist obrigatório (gate)** definido em `.claude/agents/specify.md` — só reporte conclusão se todos os itens estiverem ok.

Observação: O script cria e faz checkout do novo branch e inicializa o arquivo da spec antes da escrita.
