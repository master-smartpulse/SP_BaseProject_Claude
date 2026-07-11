---
description: Resolver ambiguidades da spec ativa com perguntas objetivas ao usuário, registrando as respostas na própria spec. Rodar entre /specify e /plan.
argument-hint: foco opcional (ex. permissões, retenção de dados, performance)
allowed-tools: Bash, Read, Write, Edit
---

Você vai resolver as ambiguidades da spec ativa **com o usuário** — decisões de produto pertencem a ele, não à pesquisa técnica. Execute os passos abaixo.

Foco opcional indicado pelo usuário: $ARGUMENTS

1. Execute o script abaixo usando a ferramenta Bash a partir da raiz do repositório e interprete FEATURE_DIR e FEATURE_SPEC. Todos os caminhos devem ser absolutos.
   ```
   bash scripts/bash/check-spec-prerequisites.sh --json
   ```
   **IMPORTANTE**: Execute o script apenas uma vez. O JSON é exibido no terminal — use-o para obter o conteúdo real.

2. Leia a spec (FEATURE_SPEC) e identifique as ambiguidades, em duas fontes:
   - Marcadores explícitos `[PRECISA ESCLARECIMENTO: ...]`
   - Áreas frequentemente subespecificadas mesmo sem marcador: tipos de usuário e permissões; retenção/exclusão de dados; metas de performance e escala; tratamento de erros; integrações; segurança/conformidade; estados de UX (vazio, erro, offline)

3. Se **não houver ambiguidades materiais** (nenhum marcador e nenhuma área subespecificada que mude escopo/comportamento), reporte "spec sem ambiguidades relevantes", sugira `/plan` e encerre — **não invente perguntas para preencher cota**. Caso contrário, priorize e formule **no máximo 5 perguntas**, uma de cada vez, na ordem de maior impacto sobre escopo e comportamento:
   - Cada pergunta deve ser **objetiva e fechada** sempre que possível: ofereça 2 a 4 opções concretas com as implicações de cada uma (a opção recomendada primeiro), ou peça uma resposta curta.
   - Não pergunte o que já está definido na spec, o que é decisão técnica (isso é do /plan) ou o que não muda materialmente o escopo.
   - Se o usuário indicou um foco em $ARGUMENTS, comece por ele.

4. Registre cada resposta imediatamente na spec:
   - Crie (ou estenda) a seção `## Esclarecimentos` na spec, com subseção `### Sessão [DATA]` listando `- P: [pergunta] → R: [resposta]`.
   - **Atualize o texto afetado da spec**: remova o marcador `[PRECISA ESCLARECIMENTO]` resolvido e reescreva o requisito/cenário com a decisão tomada (a spec deve ficar consistente sozinha, sem depender da seção de esclarecimentos).

5. Ao final, reporte: número de perguntas respondidas, marcadores restantes (se o usuário adiou alguma decisão, mantenha o marcador com nota "adiado em [DATA]") e prontidão para o `/plan`.

**IDIOMA**: Perguntas, respostas registradas e edições na spec em **português (pt-BR)**.

**Checklist antes de concluir (gate)** — só reporte conclusão se todos estiverem ok:
- [ ] Máximo de 5 perguntas, uma por vez, com opções concretas quando possível
- [ ] Toda resposta registrada em `## Esclarecimentos` E refletida no texto da spec (requisitos/cenários atualizados)
- [ ] Nenhum `[PRECISA ESCLARECIMENTO]` restante sem resolução ou nota de adiamento explícita
- [ ] Nenhuma decisão técnica tomada aqui (stack, arquitetura, APIs → /plan)

Observação: Este comando **não** cria specs (use /specify ou /specify-tech) nem toma decisões técnicas. Se a spec não existir, sugira /specify primeiro.
