---
description: Criar ou atualizar a constituição do projeto a partir de entradas interativas ou de princípios fornecidos, mantendo os templates dependentes sincronizados.
allowed-tools: Read, Write, Edit
---

Você está atualizando a constituição do projeto em `memory/constitution.md`. Esse arquivo é um TEMPLATE com tokens placeholder entre colchetes (ex.: `[PROJECT_NAME]`, `[PRINCIPLE_1_NAME]`). Sua tarefa é (a) coletar/derivar valores concretos, (b) preencher o template com precisão e (c) propagar alterações nos artefatos dependentes.

**IDIOMA**: O documento da constituição e todo o seu conteúdo devem ser escritos em **português (pt-BR)**.

Siga este fluxo de execução:

1. Carregue o template existente da constituição em `memory/constitution.md`.
   - Identifique todos os tokens placeholder no formato `[IDENTIFICADOR_EM_MAIÚSCULAS]`.
     **IMPORTANTE**: O usuário pode pedir menos ou mais princípios que os do template. Se um número for especificado, respeite — siga o template geral. Atualize o documento de acordo.

2. Colete/derive valores para os placeholders:
   - Se a entrada do usuário (conversa) fornecer um valor, use-o.
   - Caso contrário, infira a partir do contexto do repositório (README, docs, versões anteriores da constitution se houver).
   - Para datas de governança: `RATIFICATION_DATE` é a data de adoção original (se desconhecida, pergunte ou marque TODO), `LAST_AMENDED_DATE` é hoje se houver alterações, senão mantenha a anterior.
   - `CONSTITUTION_VERSION` deve ser incrementada conforme versionamento semântico:
     - MAJOR: Remoções ou redefinições de princípios/governança incompatíveis com versões anteriores.
     - MINOR: Novo princípio/seção ou orientação materialmente ampliada.
     - PATCH: Esclarecimentos, redação, correções de typo, refinamentos não semânticos.
   - Se o tipo de incremento for ambíguo, proponha o raciocínio antes de finalizar.

3. Rascunhe o conteúdo atualizado da constituição:
   - Substitua cada placeholder por texto concreto (não deixe tokens entre colchetes, exceto slots intencionalmente mantidos — justifique explicitamente qualquer exceção).
   - Preserve a hierarquia de títulos; comentários podem ser removidos após substituição, salvo se ainda acrescentarem clareza.
   - Garanta que cada seção de Princípio tenha: linha de nome sucinta, parágrafo (ou lista) com regras não negociáveis, justificativa explícita se não óbvia.
   - Garanta que a seção de Governança liste procedimento de emenda, política de versionamento e expectativas de revisão de conformidade.

4. Checklist de propagação de consistência (converta em validações ativas):
   - Leia `templates/plan-template.md` e garanta que "Constitution Check" ou regras estejam alinhados aos princípios atualizados.
   - Leia `templates/spec-template.md` para alinhamento de escopo/requisitos — atualize se a constitution adicionar/remover seções ou restrições obrigatórias.
   - Leia `templates/tasks-template.md` e garanta que a categorização de tasks reflita tipos impulsionados por princípios novos ou removidos.
   - Leia cada arquivo de command em `.claude/commands/*.md` para verificar referências desatualizadas. Atualize referências a princípios alterados.
   - Leia documentação de orientação em tempo de execução (ex.: `README.md`, `docs/arquitetura.md`). Atualize referências a princípios alterados.

5. Produza um Relatório de Impacto de Sincronização (insira como comentário HTML no topo do arquivo da constitution após a atualização):
   - Mudança de versão: antiga → nova
   - Lista de princípios modificados (título antigo → novo se renomeado)
   - Seções adicionadas
   - Seções removidas
   - Templates que exigem atualização (✅ atualizado / ⚠ pendente) com caminhos
   - TODOs de acompanhamento se houver placeholders intencionalmente adiados

6. Validação antes da saída final:
   - Nenhum token entre colchetes sem explicação.
   - Linha de versão confere com o relatório.
   - Datas no formato ISO AAAA-MM-DD.
   - Princípios são declarativos, testáveis e sem linguagem vaga ("should" → substitua por MUST/SHOULD com justificativa quando apropriado).

7. Escreva a constituição concluída de volta em `memory/constitution.md` (sobrescrever).

8. **Atualizar documentação de estado:** Ao finalizar, atualize sempre `IMPLEMENTATION_STATUS.md` (tabela spec × completude) e `FEATURE_LIST.md` (wiki de features do produto). Princípio 8 da Constitution.

9. Informe um resumo final ao usuário com:
   - Nova versão e razão do incremento.
   - Arquivos sinalizados para acompanhamento manual.
   - Sugestão de mensagem de commit (ex.: `docs: emenda à constitution para vX.Y.Z (adição de princípios + atualização de governança)`).

Requisitos de formatação e estilo:

- Use os títulos em Markdown exatamente como no template (não rebaixe ou promova níveis).
- Quebre linhas longas de justificativa para manter legibilidade (<100 caracteres idealmente), sem quebras forçadas.
- Mantenha uma linha em branco entre seções.
- Evite espaços em branco no fim da linha.

Se o usuário fornecer atualizações parciais (ex.: apenas uma revisão de princípio), ainda assim execute as etapas de validação e decisão de versão.

Se informações críticas estiverem faltando (ex.: data de ratificação realmente desconhecida), insira `TODO(<CAMPO>): explicação` e inclua no Relatório de Impacto de Sincronização em itens adiados.

Não crie um novo template; sempre opere sobre o arquivo existente `memory/constitution.md`.
