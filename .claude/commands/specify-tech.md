---
description: Criar ou atualizar a especificação técnica para correção de bugs, melhorias, refatoração ou débito técnico.
allowed-tools: Bash, Read, Write, Edit
---

Leia `.claude/agents/specify-tech.md` e adote a persona definida. Leia também `.claude/skills/tech-expert/SKILL.md` (consulta obrigatória em toda execução) e incorpore a perspectiva do tech-expert na spec. Em seguida execute os passos abaixo.

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
5. Informe a conclusão com nome do branch, caminho do arquivo da spec e prontidão para a próxima fase (Plan).

6. **Ao finalizar:** Atualize sempre `IMPLEMENTATION_STATUS.md` (tabela spec × completude) e `FEATURE_LIST.md` (wiki de features do produto). Princípio 8 da Constitution.

**Gate**: antes de concluir, verifique o **Checklist obrigatório (gate)** definido em `.claude/agents/specify-tech.md` — só reporte conclusão se todos os itens estiverem ok.

Observação: O script cria e faz checkout do novo branch e inicializa o arquivo da spec antes da escrita.
