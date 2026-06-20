# Princípios Fundamentais de Craft

Estes princípios se aplicam independentemente da direção de design. Este é o piso de qualidade.

---

## Arquitetura de Surfaces e Tokens

Interfaces profissionais não escolhem cores aleatoriamente — elas constroem sistemas. Entender essa arquitetura é a diferença entre "parece ok" e "parece um produto de verdade".

### A Fundação de Primitivos

Toda cor da sua interface deve remeter a um pequeno conjunto de primitivos:

- **Foreground** — cores de texto (primary, secondary, muted)
- **Background** — cores de surface (base, elevated, overlay)
- **Border** — cores de borda (default, subtle, strong)
- **Brand** — seu accent principal
- **Semantic** — cores funcionais (destructive, warning, success)

Não invente cores novas. Mapeie tudo para esses primitivos.

### Hierarquia de Elevação de Surfaces

Surfaces se empilham. Um dropdown fica acima de um card, que fica acima da página. Construa um sistema numerado:

```
Level 0: Base background (the app canvas)
Level 1: Cards, panels (same visual plane as base)
Level 2: Dropdowns, popovers (floating above)
Level 3: Nested dropdowns, stacked overlays
Level 4: Highest elevation (rare)
```

No dark mode, elevação maior = ligeiramente mais claro. No light mode, elevação maior = ligeiramente mais claro ou usa sombra. O princípio: **surfaces elevadas precisam de distinção visual em relação ao que está abaixo delas.**

### O Princípio da Sutileza

É aqui que a maioria das interfaces falha. Estude Vercel, Supabase, Linear — as surfaces deles são **quase iguais**, mas ainda distinguíveis. As bordas são **leves, mas não invisíveis**.

**Para surfaces:** A diferença entre níveis de elevação deve ser sutil — alguns pontos percentuais de luminosidade, não saltos dramáticos. No dark mode, surface-100 pode ser 7% mais clara que a base, surface-200 pode ser 9%, surface-300 pode ser 12%. Você mal consegue ver, mas sente.

**Para bordas:** Bordas devem definir regiões sem exigir atenção. Use opacidade baixa (alpha de 0.05-0.12 para dark mode, um pouco mais alto para light mode). A borda deve desaparecer quando você não está procurando por ela, mas ser encontrável quando você precisa entender a estrutura.

**O teste:** Semicerre os olhos olhando para a sua interface. Você ainda deve perceber a hierarquia — o que está acima do quê, onde regiões começam e terminam. Mas nenhuma borda ou surface isolada deve saltar aos seus olhos. Se as bordas são a primeira coisa que você nota, elas estão fortes demais. Se você não consegue encontrar onde uma região termina e outra começa, elas estão sutis demais.

**Erros comuns de IA a evitar:**
- Bordas visíveis demais (1px sólido cinza em vez de rgba sutil)
- Saltos de surface dramáticos demais (ir do escuro para o claro em vez de escuro para um pouco-menos-escuro)
- Usar matizes (hues) diferentes para surfaces diferentes (card cinza sobre fundo azul)
- Divisores duros onde bordas sutis bastariam

### Hierarquia de Texto via Tokens

Não tenha apenas "texto" e "texto cinza". Construa quatro níveis:

- **Primary** — texto padrão, contraste mais alto
- **Secondary** — texto de apoio, levemente atenuado
- **Tertiary** — metadados, timestamps, menos importante
- **Muted** — desabilitado, placeholder, contraste mais baixo

Use os quatro de forma consistente. Se você está usando apenas dois, sua hierarquia está plana demais.

### Progressão de Bordas

Bordas não são binárias. Construa uma escala:

- **Default** — bordas padrão
- **Subtle/Muted** — separação mais suave
- **Strong** — ênfase, estados de hover
- **Stronger** — ênfase máxima, anéis de focus

Combine a intensidade da borda com a importância do limite.

### Tokens Dedicados para Controles

Controles de formulário (inputs, checkboxes, selects) têm necessidades específicas. Não apenas reutilize tokens de surface — crie tokens dedicados:

- **Background de controle** — frequentemente diferente dos backgrounds de surface
- **Borda de controle** — precisa parecer interativa
- **Focus de controle** — indicação clara de focus

Essa separação permite ajustar controles de forma independente das surfaces de layout.

### Bases Sensíveis ao Contexto

Áreas diferentes do seu app podem precisar de surfaces base diferentes:

- **Páginas de marketing** — podem usar backgrounds mais escuros/ricos
- **Dashboard/app** — pode usar backgrounds neutros de trabalho
- **Sidebar** — pode diferir do canvas principal

A hierarquia de surfaces funciona da mesma forma — apenas parte de uma base diferente.

### Backgrounds Alternativos para Depth

Além de sombras, use backgrounds contrastantes para criar depth. Um background "alternativo" ou "inset" faz o conteúdo parecer rebaixado. Útil para:

- Empty states em data grids
- Blocos de código
- Painéis inset
- Agrupamento visual sem bordas

---

## Sistema de Espaçamento

Escolha uma unidade base (4px e 8px são comuns) e use múltiplos em todo lugar. O número específico importa menos que a consistência — todo valor de espaçamento deve ser explicável como "X vezes a unidade base".

Construa uma escala para contextos diferentes:
- Microespaçamento (gaps de ícones, pares de elementos justos)
- Espaçamento de componente (dentro de botões, inputs, cards)
- Espaçamento de seção (entre grupos relacionados)
- Separação maior (entre seções distintas)

## Padding Simétrico

TLBR (top/left/bottom/right) devem coincidir. Se o padding superior é 16px, esquerda/inferior/direita também devem ser 16px. Exceção: quando o conteúdo naturalmente cria equilíbrio visual.

```css
/* Good */
padding: 16px;
padding: 12px 16px; /* Only when horizontal needs more room */

/* Bad */
padding: 24px 16px 12px 16px;
```

## Consistência de Border Radius

Cantos mais retos parecem técnicos, cantos mais arredondados parecem amigáveis. Escolha uma escala que combine com a personalidade do seu produto e use-a de forma consistente.

A chave é ter um sistema: radius pequeno para inputs e botões, médio para cards, grande para modais ou containers. Não misture reto e suave aleatoriamente — radius inconsistente é tão incômodo quanto espaçamento inconsistente.

## Estratégia de Depth e Elevação

Alinhe sua abordagem de depth à sua direção de design. Escolha UMA e comprometa-se:

**Apenas bordas (borders-only, flat)** — Limpo, técnico, denso. Funciona para ferramentas utilitárias onde densidade de informação importa mais que elevação visual. Linear, Raycast e muitas ferramentas de desenvolvedor quase não usam sombras — apenas bordas sutis para definir regiões.

**Sombras únicas sutis** — Elevação suave sem complexidade. Um simples `0 1px 3px rgba(0,0,0,0.08)` pode ser suficiente. Funciona para produtos acessíveis que querem depth delicado.

**Sombras em camadas** — Rico, premium, dimensional. Múltiplas camadas de sombra criam depth realista. Stripe e Mercury usam essa abordagem. Melhor para cards que precisam parecer objetos físicos.

**Mudanças de cor de surface** — Tons de background estabelecem hierarquia sem nenhuma sombra. Um card em `#fff` sobre um background `#f8fafc` já parece elevado.

```css
/* Borders-only approach */
--border: rgba(0, 0, 0, 0.08);
--border-subtle: rgba(0, 0, 0, 0.05);
border: 0.5px solid var(--border);

/* Single shadow approach */
--shadow: 0 1px 3px rgba(0, 0, 0, 0.08);

/* Layered shadow approach */
--shadow-layered:
  0 0 0 0.5px rgba(0, 0, 0, 0.05),
  0 1px 2px rgba(0, 0, 0, 0.04),
  0 2px 4px rgba(0, 0, 0, 0.03),
  0 4px 8px rgba(0, 0, 0, 0.02);
```

## Layouts de Cards

Layouts de cards monótonos são design preguiçoso. Um card de métrica não precisa se parecer com um card de plano, que não precisa se parecer com um card de configurações.

Desenhe a estrutura interna de cada card para seu conteúdo específico — mas mantenha o tratamento de surface consistente: mesmo peso de borda, profundidade de sombra, raio de canto, escala de padding, tipografia.

## Controles Isolados

Controles de UI merecem tratamento de container. Date pickers, filtros, dropdowns — eles devem parecer objetos trabalhados com craft.

**Nunca use elementos de formulário nativos para UI estilizada.** `<select>` nativo, `<input type="date">` e elementos similares renderizam dropdowns nativos do sistema operacional que não podem ser estilizados. Construa componentes customizados em vez disso:

- Select customizado: botão trigger + menu dropdown posicionado
- Date picker customizado: input + popover de calendário
- Checkbox/radio customizado: div estilizada com gerenciamento de estado

Triggers de select customizado devem usar `display: inline-flex` com `white-space: nowrap` para manter o texto e os ícones de chevron na mesma linha.

## Hierarquia Tipográfica

Construa níveis distintos que sejam visualmente distinguíveis à primeira vista:

- **Headlines** — peso mais pesado, letter-spacing mais justo para presença
- **Body** — peso confortável para legibilidade
- **Labels/UI** — peso médio, funciona em tamanhos menores
- **Dados** — frequentemente monospace, precisa de `tabular-nums` para alinhamento

Não dependa apenas do tamanho. Combine tamanho, peso e letter-spacing para criar hierarquia clara. Se você semicerrar os olhos e não conseguir distinguir headline de body, a hierarquia está fraca demais.

## Monospace para Dados

Números, IDs, códigos, timestamps pertencem ao monospace. Use `tabular-nums` para alinhamento em colunas. Mono sinaliza "isto é dado".

## Iconografia

Ícones esclarecem, não decoram — se remover um ícone não perde nenhum significado, remova-o. Escolha um conjunto de ícones consistente e mantenha-o em todo o produto.

Dê presença a ícones isolados com containers de background sutis. Ícones ao lado de texto devem alinhar opticamente, não matematicamente.

## Animação

Mantenha rápido e funcional. Microinterações (hover, focus) devem parecer instantâneas — em torno de 150ms. Transições maiores (modais, painéis) podem ser um pouco mais longas — 200-250ms.

Use easing de desaceleração suave (variantes de ease-out). Evite efeitos de spring/bounce em interfaces profissionais — eles parecem lúdicos, não sérios.

## Hierarquia de Contraste

Construa um sistema de quatro níveis: foreground (primary) → secondary → muted → faint. Use os quatro de forma consistente.

## Cor Carrega Significado

Cinza constrói estrutura. Cor comunica — status, ação, ênfase, identidade. Cor sem motivação é ruído. Cor que reforça o mundo do produto é caráter.

## Contexto de Navegação

Telas precisam de ancoragem. Uma tabela de dados flutuando no espaço parece uma demo de componente, não um produto. Considere incluir:

- **Navegação** — sidebar ou navegação superior mostrando onde você está no app
- **Indicador de localização** — breadcrumbs, título da página ou estado ativo de navegação
- **Contexto de usuário** — quem está logado, qual workspace/organização

Ao construir sidebars, considere usar o mesmo background da área de conteúdo principal. Conte com uma borda sutil para a separação, em vez de cores de background diferentes.

## Dark Mode

Interfaces escuras têm necessidades diferentes:

**Bordas em vez de sombras** — Sombras são menos visíveis em backgrounds escuros. Apoie-se mais em bordas para definição.

**Ajuste as cores semânticas** — Cores de status (success, warning, error) frequentemente precisam ser levemente dessaturadas para backgrounds escuros.

**Mesma estrutura, valores diferentes** — O sistema de hierarquia continua se aplicando, apenas com valores invertidos.
