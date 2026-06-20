# Crítica

Sua primeira construção entregou a estrutura. Agora olhe para ela como um design lead revisa o trabalho de um júnior — não perguntando "isso funciona?", mas "eu colocaria meu nome nisso?".

---

## A Lacuna

Existe uma distância entre o correto e o feito com craft. Correto significa que o layout se sustenta, o grid alinha, as cores não brigam. Com craft significa que alguém se importou com cada decisão até o último pixel. Você sente a diferença imediatamente — do mesmo jeito que distingue uma caneca feita à mão no torno de uma moldada por injeção. Ambas seguram café. Uma tem presença.

Seu primeiro output vive no correto. Este comando o puxa em direção ao craft.

---

## Veja a Composição

Dê um passo atrás. Olhe para o todo.

O layout tem ritmo? Grandes interfaces respiram de forma desigual — áreas densas de ferramentas dão lugar a conteúdo aberto, elementos pesados se equilibram com leves, o olho percorre a página com propósito. Layouts padrão são monótonos: mesmo tamanho de card, mesmos gaps, mesma densidade em todo lugar. A planura é o som de ninguém decidindo.

As proporções estão trabalhando? Uma sidebar de 280px ao lado de conteúdo de largura total diz "a navegação serve ao conteúdo". Uma sidebar de 360px diz "estes são pares". O número específico declara o que importa. Se você não consegue articular o que suas proporções estão dizendo, elas não estão dizendo nada.

Existe um ponto focal claro? Toda tela tem uma coisa que o usuário veio fazer ali. Essa coisa deve dominar — por tamanho, posição, contraste ou pelo espaço ao seu redor. Quando tudo compete igualmente, nada vence e a interface parece um estacionamento.

---

## Veja o Craft

Aproxime-se. À distância de um pixel.

O grid de espaçamento é inegociável — todo valor múltiplo de 4, sem exceções — mas correção sozinha não é craft. Craft é saber que um painel de ferramentas com padding de 16px parece justo como uma bancada de trabalho, enquanto o mesmo card com 24px parece um folheto. O mesmo número pode estar certo em um contexto e ser preguiçoso em outro. Densidade é uma decisão de design, não uma constante.

A tipografia deve ser legível mesmo com os olhos semicerrados. Se tamanho é a única coisa separando seu headline do seu body e do seu label, a hierarquia está fraca demais. Peso, tracking e opacidade criam camadas que o tamanho sozinho não consegue.

Surfaces devem sussurrar hierarquia. Não bordas grossas, não sombras dramáticas — mudanças tonais silenciosas em que você sente o depth sem vê-lo. Remova mentalmente todas as bordas do seu CSS. Você ainda consegue perceber a estrutura apenas pela cor das surfaces? Se não, suas surfaces não estão trabalhando o suficiente.

Elementos interativos precisam de vida. Todo botão, link e região clicável deve responder a hover e ao pressionar. Não dramaticamente — uma mudança sutil de background, um escurecimento suave. Estados ausentes fazem a interface parecer uma fotografia de software em vez de software.

---

## Veja o Conteúdo

Leia cada string visível como um usuário leria. Não procurando erros de digitação — procurando verdade.

Esta tela conta uma história coerente? Uma pessoa real, em uma empresa real, poderia estar olhando exatamente para esses dados agora? Ou o título da página pertence a um produto, o corpo do artigo a outro e as métricas da sidebar a um terceiro?

Incoerência de conteúdo quebra a ilusão mais rápido que qualquer falha visual. Uma interface lindamente desenhada com conteúdo sem sentido é um cenário de cinema sem roteiro.

---

## Veja a Estrutura

Abra o CSS e encontre as mentiras — os lugares que parecem certos, mas estão presos com fita adesiva.

Margens negativas desfazendo o padding do pai. Valores de calc() que existem apenas como contornos. Posicionamento absoluto para escapar do fluxo do layout. Cada um é um atalho onde existe uma solução limpa. Cards com divisores de largura total usam flex column e padding no nível da seção. Conteúdo centralizado usa max-width com margens auto. A resposta correta é sempre mais simples que a gambiarra.

---

## De Novo

Olhe para o seu output uma última vez.

Pergunte: "Se dissessem que isto carece de craft, para o que apontariam?"

Aquela coisa em que você acabou de pensar — corrija. Depois pergunte de novo.

A primeira construção foi o rascunho. A crítica é o design.
