# Craft em Ação

Este documento mostra como o princípio de camadas sutis se traduz em decisões reais. Aprenda o raciocínio, não o código. Seus valores serão diferentes — a abordagem, não.

---

## A Mentalidade das Camadas Sutis

Antes de olhar qualquer exemplo, internalize isto: **você mal deve notar o sistema funcionando.**

Quando você olha o dashboard da Vercel, não pensa "belas bordas". Você apenas entende a estrutura. Quando olha o Supabase, não pensa "boa elevação de surface". Você apenas sabe o que está acima do quê. O craft é invisível — é assim que você sabe que está funcionando.

---

## Exemplo: Dashboard com Sidebar e Dropdown

### As Decisões de Surface

**Por que tão sutil?** Cada salto de elevação deve ser de apenas alguns pontos percentuais de luminosidade. Você mal consegue ver a diferença isoladamente. Mas quando as surfaces se empilham, a hierarquia emerge. Este é o jeito Vercel/Supabase — mudanças em tom de sussurro, que você sente em vez de ver.

**O que NÃO fazer:** Não faça saltos dramáticos entre elevações. Isso é incômodo. Não use matizes (hues) diferentes para níveis diferentes. Mantenha o mesmo matiz, mude apenas a luminosidade.

### As Decisões de Borda

**Por que rgba, e não cores sólidas?** Bordas de baixa opacidade se misturam com seu background. Uma borda branca de baixa opacidade sobre uma surface escura quase não está lá — ela define a aresta sem exigir atenção. Bordas hex sólidas parecem duras em comparação.

**O teste:** Olhe para a sua interface à distância de um braço. Se as bordas são a primeira coisa que você nota, reduza a opacidade. Se você não consegue encontrar onde as regiões terminam, aumente levemente.

### A Decisão da Sidebar

**Por que o mesmo background do canvas, e não um diferente?**

Muitos dashboards fazem a sidebar de uma cor diferente. Isso fragmenta o espaço visual — agora você tem o "mundo da sidebar" e o "mundo do conteúdo".

Melhor: mesmo background, separação por borda sutil. A sidebar é parte do app, não uma região separada. A Vercel faz isso. O Supabase faz isso. A borda é suficiente.

### A Decisão do Dropdown

**Por que surface-200, e não surface-100?**

O dropdown flutua acima do card de onde surgiu. Se ambos fossem surface-100, o dropdown se misturaria ao card — você perderia a sensação de camadas. Surface-200 é claro apenas o suficiente para parecer "acima" sem ser dramaticamente diferente.

**Por que border-overlay em vez de border-default?**

Overlays (dropdowns, popovers) frequentemente precisam de um pouco mais de definição porque estão flutuando no espaço. Um toque a mais de opacidade na borda ajuda a parecerem contidos sem serem duros.

---

## Exemplo: Controles de Formulário

### Decisão de Background do Input

**Por que mais escuro, e não mais claro?**

Inputs são "inset" — eles recebem conteúdo, não o projetam. Um background levemente mais escuro sinaliza "digite aqui" sem precisar de bordas pesadas. Este é o princípio do background alternativo.

### Decisão do Estado de Focus

**Por que estados de focus sutis?**

O focus precisa ser visível, mas você não precisa de um anel brilhante ou de uma cor dramática. Um aumento perceptível na opacidade da borda é suficiente para uma mudança clara de estado. Sutil-mas-perceptível — o mesmo princípio das surfaces.

---

## Adapte ao Contexto

Seu produto pode precisar de:
- Matizes mais quentes (leve tom de amarelo/laranja)
- Matizes mais frios (base azul-acinzentada)
- Progressão de luminosidade diferente
- Light mode (os princípios se invertem — elevação maior = sombra, não luminosidade)

**O princípio é constante:** quase igual, ainda distinguível. Os valores se adaptam ao contexto.

---

## A Verificação de Craft

Aplique o teste de semicerrar os olhos (squint test) ao seu trabalho:

1. Desfoque os olhos ou dê um passo atrás
2. Você ainda consegue perceber a hierarquia?
3. Alguma coisa está saltando aos seus olhos?
4. Você consegue dizer onde as regiões começam e terminam?

Se a hierarquia está visível e nada está duro demais — as camadas sutis estão funcionando.
