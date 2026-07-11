---
name: specify-design
description: Especifica e gera design de interface com craft e direção autoral. Faz triagem automática entre dois modos — Interface (dashboards, painéis, SaaS, ferramentas, telas internas, dados) e Frontend (landing pages, sites de marketing, campanhas, portfólios, páginas institucionais). Aplica princípios distintos para cada modo. Use ao desenhar ou implementar UI, propor direção visual, revisar craft de interface ou quando o usuário pedir "design", "tela", "landing", "dashboard", "site" — nunca para definir arquitetura de backend, escrever testes ou modelar dados.
---

# Specify Design

Skill unificada para design de produto digital. Combina duas disciplinas complementares e escolhe a abordagem certa antes de propor qualquer direção.

---

## 1. Triagem (obrigatória antes de qualquer proposta)

Antes de pensar em paleta, layout ou componente, **classifique o pedido** em um dos dois modos. A escolha define todo o restante do processo.

### Modo INTERFACE — aplicações, ferramentas, dados

Use quando o pedido envolve:

- Dashboards, painéis administrativos, BI, relatórios
- SaaS internos ou voltados a operadores (CRM, ERP, sistemas)
- Telas de configurações, perfil, billing, settings
- Ferramentas (editores, terminais, IDEs, consoles)
- Listagens, tabelas, formulários complexos
- Aplicativos web autenticados de uso recorrente
- Qualquer tela onde o usuário **trabalha** dentro do produto

**Objetivo central:** densidade informacional, clareza, consistência, craft invisível. O design deve sumir para deixar o trabalho aparecer.

### Modo FRONTEND — marketing, narrativa, conversão

Use quando o pedido envolve:

- Landing pages, sites institucionais, hot sites
- Páginas de produto público, lançamento, campanha
- Portfólios, sites de agência, marcas
- Hero sections, "above the fold", páginas de venda
- Sites com narrativa, storytelling, scroll experiences
- Páginas onde o objetivo é **impressionar**, converter ou comunicar marca

**Objetivo central:** memorabilidade, distinção visual, direção autoral ousada. O design deve ser a primeira coisa que se nota.

### Como decidir quando estiver ambíguo

- O usuário **já está logado** e usa de forma recorrente? → Interface.
- A página existe para **trazer** o usuário ou **convencer**? → Frontend.
- Se o pedido mistura (ex.: SaaS com landing pública), **separe**: landing em modo Frontend, dashboard interno em modo Interface. Não use a mesma direção visual para os dois.
- Em caso de dúvida real, **pergunte** ao usuário uma única vez antes de prosseguir. Não chute.

Declare o modo escolhido em uma linha curta antes de qualquer proposta:

```
Modo: INTERFACE — dashboard administrativo de pedidos.
```

ou

```
Modo: FRONTEND — landing institucional para produto SaaS B2B.
```

---

## 2. Princípio comum aos dois modos

**Defaults vencem por padrão.** Você foi treinado em milhares de dashboards e landings. Os padrões são fortes. Você pode seguir todo o processo abaixo e ainda produzir um template.

Para cada decisão você precisa ser capaz de explicar **por quê**. Se a resposta é "é comum", "é limpo" ou "funciona" — você não escolheu, você defaultou.

**Teste da troca:** se você trocasse suas escolhas pelas mais comuns e o design não parecesse meaningfully diferente, você não fez escolhas reais.

**Teste da identidade:** leia o resultado removendo o nome do produto. Alguém saberia dizer para que serve? Se não, está genérico.

---

## 3. Modo INTERFACE — princípios de craft

Foco em **sistema, consistência e camadas sutis**. O usuário deve sentir a hierarquia sem perceber.

### Antes de qualquer tela, responda:

- **Quem é a pessoa?** Não "usuários". A pessoa real. Onde está, com o que se preocupa, o que fez 5 minutos antes.
- **Qual é o verbo central?** Não "usar o dashboard". *Aprovar* pedidos. *Encontrar* o deploy quebrado. *Conciliar* a fatura.
- **Como isso deve parecer?** Não "moderno e limpo". Quente como caderno? Frio como terminal? Denso como mesa de operações? Calmo como leitura?

### Exploração de domínio (obrigatória)

Antes de propor direção, produza:

1. **Domínio** — 5+ conceitos, metáforas e vocabulário do mundo do produto. Não features — território.
2. **Mundo de cor** — 5+ cores que existiriam fisicamente nesse mundo. Se o produto fosse um espaço físico, o que veríamos?
3. **Assinatura** — um elemento visual, estrutural ou de interação que só faria sentido para ESTE produto.
4. **Defaults a rejeitar** — 3 escolhas óbvias para esse tipo de interface, e o que substitui cada uma.

### Fundamentos de craft (resumo — detalhes e valores em `references/principles.md`, fonte única)

- **Camadas sutis**: elevação por poucos pontos percentuais de luminância (sente, não vê); bordas rgba de baixa opacidade com progressão (padrão/sutil/ênfase/foco); sidebar com o mesmo fundo da canvas; inputs encaixados (mais escuros que o entorno); dropdowns um nível acima do pai.
- **Tokens**: toda cor mapeia em primitivos — foreground em 4 níveis, background (base/elevated/overlay), border, brand único, semantic, control dedicado para formulários. Teste dos tokens: lendo só os nomes das variáveis, dá pra adivinhar de que produto é?
- **Espaço e raio**: unidade base (4 ou 8px) e múltiplos em tudo; padding simétrico salvo necessidade real; escala de raio consistente (agudo = técnico, redondo = amistoso — não misture).
- **Profundidade**: escolha UMA estratégia (borders-only, sombra única sutil, sombras em camadas ou shift de cor de superfície) e comprometa-se — não misture.
- **Tipografia**: hierarquia por peso + tracking + opacidade, não só tamanho; dados em monospace com `tabular-nums`.
- **Componentes nativos**: nunca `<select>` ou `<input type="date">` para UI estilizada — construa custom (trigger + popover, calendar popover).

### Estados (não opcionais)

Todo interativo precisa de: default, hover, active, focus, disabled.
Todo dado precisa de: loading, vazio, erro.
Estados ausentes fazem a interface parecer quebrada.

### Checks antes de mostrar (modo Interface)

- **Teste da troca:** se eu trocasse a tipografia pela usual, alguém notaria? Onde a troca não importa, eu defaultei.
- **Teste do squint:** desfoque a vista. Hierarquia ainda é perceptível? Algo está jumping out de forma agressiva?
- **Teste da assinatura:** aponte 5 elementos específicos onde a assinatura aparece. Se não consegue localizar, ela não existe.
- **Teste dos tokens:** as variáveis sugerem o mundo do produto ou poderiam pertencer a qualquer projeto?

### Antes de cada componente, declare

```
Intent: [pessoa, verbo, sensação]
Palette: [cores e por que pertencem a este mundo]
Depth: [estratégia de profundidade e por quê]
Surfaces: [escala de elevação]
Typography: [fonte e por que cabe na intenção]
Spacing: [unidade base]
```

### Após construir

- Rode os checks **antes** de mostrar.
- Ofereça salvar o sistema em `.specify-design/system.md` (direção, depth, spacing, padrões reusáveis com 2+ ocorrências).

---

## 4. Modo FRONTEND — princípios de direção autoral

Foco em **direção visual ousada, memorabilidade e diferenciação**. Aqui o design **é** o produto comunicando-se.

### Antes de qualquer página, comprometa-se com:

- **Propósito:** que problema essa página resolve? Quem chega aqui e o que precisa sentir?
- **Tom:** escolha um extremo concreto, não rótulos genéricos. Brutalist, maximalista caótico, retro-futurista, orgânico/natural, luxo refinado, lúdico, editorial/revista, art déco, soft/pastel, industrial. Inspire-se nessas categorias, mas desenhe um que seja **fiel ao contexto específico**.
- **Restrições:** stack, performance, acessibilidade.
- **Diferenciação:** o que ninguém vai esquecer? Uma coisa específica.

**"Limpo e moderno" não é uma direção.** Toda IA fala isso. Vá para o concreto: editorial denso, brutalist com serifa pesada, retro-futurista com grain, vidro líquido sobre noise — alguma direção com nome próprio.

### Estética e detalhes

- **Tipografia:** evite Inter, Roboto, Arial, system-ui. Combine uma display distinta com uma body refinada. A escolha de fonte muda mais a percepção que qualquer outra decisão.
- **Cor:** paleta coesa via CSS variables. Cores dominantes com acentos afiados superam paletas tímidas e distribuídas. Evite gradiente roxo em fundo branco — virou cliché de IA.
- **Movimento:** animações com propósito. Para HTML puro, prefira CSS-only. Para React, use Motion quando disponível. Um page load orquestrado com staggered reveals supera vários micro-interactions dispersos. Hover surpreendente, scroll-triggers com intenção.
- **Composição espacial:** layouts inesperados, assimetria, sobreposição, fluxo diagonal, grid-breaking, whitespace generoso OU densidade controlada — não meio-termo morno.
- **Atmosfera:** vá além de cor sólida. Gradient mesh, noise/grain, padrões geométricos, transparências em camadas, sombras dramáticas, bordas decorativas, cursor custom, overlays.

### Coerência radical

Maximalismo audacioso e minimalismo refinado **ambos funcionam** — a chave é **intencionalidade, não intensidade**. O que falha é o morno.

Se o tom é maximalista: o código precisa ser elaborado, animações abundantes, efeitos densos.
Se o tom é minimalista: o código precisa de restrição, precisão obsessiva em espaço e tipografia, detalhes sutis impecáveis.

A complexidade da implementação **acompanha** a visão estética. Minimalismo mal feito = preguiça. Maximalismo mal feito = ruído.

### Nunca

- Convergir em escolhas comuns (Space Grotesk, Inter, fundo branco com roxo gradiente, sidebar de SaaS)
- Repetir a mesma direção entre projetos diferentes
- Camuflar falta de direção atrás de "neutralidade"
- Misturar 5 cores sem motivo (cor que não significa nada é ruído)

### Checks antes de mostrar (modo Frontend)

- **Teste da memória:** alguém que viu por 3 segundos consegue descrever uma coisa específica depois? Se não, está esquecível.
- **Teste do swap de fonte:** se eu trocasse a display por Inter, ainda sobraria identidade? Se não, a identidade estava só na fonte — explore mais.
- **Teste do screenshot único:** um print da hero, fora de contexto, diz para que produto é? Se poderia ser qualquer SaaS, está genérico.
- **Teste da coerência:** maximalismo é maximalismo em tudo (tipografia, espaço, efeitos)? Ou você prometeu uma coisa e entregou outra?

---

## 5. Princípios compartilhados (independente do modo)

### Cor carrega significado

Cinza estrutura. Cor comunica. Cor sem motivo é ruído. Um acento usado com intenção bate cinco usados sem pensar.

### Ícones esclarecem, não decoram

Se remover o ícone não perde significado, remova. Um único set, consistente. Ícones isolados ganham presença com container sutil.

### Acessibilidade não é etapa final

Contraste suficiente nos 4 níveis de texto. Focus visível (sutil mas localizável). Labels semânticos. Teclado funcional. Estados não dependentes apenas de cor.

### Conteúdo coerente

Strings reais, não lorem. Números plausíveis para o domínio. Nada quebra a ilusão mais rápido que um título de um produto, body de outro e dados de um terceiro.

---

## 6. Saída esperada

Independentemente do modo, a resposta deve incluir:

1. **Modo identificado** (uma linha)
2. **Direção proposta** com:
   - Para Interface: domínio (5+), mundo de cor (5+), assinatura, defaults rejeitados
   - Para Frontend: tom escolhido (extremo concreto), diferenciador, decisão tipográfica e cromática
3. **Pergunta de confirmação** antes de implementar ("Essa direção faz sentido?")
4. **Implementação** com código produção quando confirmada, declarando intent antes de cada componente (modo Interface)
5. **Self-critique** antes de mostrar (checks aplicáveis ao modo)
6. **Oferta de salvar** padrões reusáveis (modo Interface) ou registrar a direção (modo Frontend)

---

## 7. O que esta skill NÃO faz

- Definir arquitetura de backend, modelagem de dados, endpoints
- Escrever testes ou definir estratégia de testes
- Decisões de stack que não impactem o design (banco, autenticação interna, infraestrutura)
- Criar layouts mornos, neutros ou "clean and modern" sem direção
- Produzir o mesmo resultado para pedidos diferentes — variar entre projetos é obrigatório

---

## 8. Deep dives

Para aprofundar princípios do modo Interface, consulte:

- `references/principles.md` — Fonte única dos detalhes de craft: tokens, escalas, profundidade, tipografia, dark mode
- `references/example.md` — Subtle layering aplicado
- `references/critique.md` — Protocolo de crítica pós-build
- `references/validation.md` — Verificações de consistência contra o system.md do projeto
- `references/memory.md` — Quando e como atualizar o system.md do projeto

---

## 9. Comunicação

- Não anuncie modos internos ("Estou em modo X..."). Apenas declare o modo identificado em uma linha e prossiga.
- Lidere com exploração e recomendação concretas. Confirme com uma pergunta direta.
- Documentação e specs em **português (pt-BR)**. Código segue convenções do projeto.
- Após terminar, ofereça salvar padrões para sessões futuras.

---

## Checklist obrigatório (gate)

Antes de dar o trabalho por concluído, verifique (fonte única deste gate — o comando /specify-design apenas referencia):

- [ ] Modo identificado e declarado (Interface ou Frontend)
- [ ] Intent / propósito explícito com pessoa, verbo e sensação (Interface) ou tom extremo e diferenciador (Frontend)
- [ ] Paleta e tipografia justificadas a partir do mundo do produto, sem defaults genéricos
- [ ] Estratégia de profundidade única e declarada (Interface) ou comprometimento coerente com o tom estético (Frontend)
- [ ] Estados de interação e de dados implementados (hover/focus/loading/vazio/erro quando aplicável)
- [ ] Auto-crítica rodada (swap/squint/signature/token no Interface; memory/font-swap/screenshot/coherence no Frontend)
- [ ] Acessibilidade básica garantida (contraste, foco, semântica, teclado)
- [ ] Conteúdo coerente com o domínio (sem lorem, sem strings genéricas)
- [ ] Oferta de salvar padrões reusáveis feita
