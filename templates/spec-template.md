# Especificação de Feature: [NOME DA FEATURE]

**Branch da feature**: `[###-nome-da-feature]` 
**Criado**: [DATA] 
**Status**: Rascunho 
**Entrada**: Descrição do usuário: "$ARGUMENTS"

## Fluxo de Execução (principal)

```
1. Interpretar descrição do usuário a partir da Entrada
   → Se vazio: ERRO "Nenhuma descrição da feature fornecida"
2. Extrair conceitos-chave da descrição
   → Identificar: atores, ações, dados, restrições
3. Para cada aspecto pouco claro:
   → Marcar com [PRECISA ESCLARECIMENTO: pergunta específica]
4. Preencher a seção Cenários do Usuário e Testes
   → Se não houver fluxo claro: ERRO "Não foi possível determinar cenários do usuário"
5. Gerar Requisitos Funcionais e Critérios de Sucesso
   → Cada requisito deve ser testável; cada critério de sucesso, mensurável
   → Marcar requisitos ambíguos
6. Identificar Entidades Principais (se houver dados) e Dependências/Premissas
7. Executar Checklist de Revisão
   → Se houver [PRECISA ESCLARECIMENTO]: AVISO "Especificação tem incertezas"
   → Se detalhes de implementação encontrados: ERRO "Remover detalhes técnicos"
8. Retornar: SUCESSO (especificação pronta para planejamento)
```

---

## ⚡ Diretrizes Rápidas

- ✅ Foque no QUE o usuário precisa e no PORQUÊ
- ❌ Evite COMO implementar (sem stack técnica, APIs, estrutura de código)
- 👥 Escrito para stakeholders de negócio, não desenvolvedores

### Exigências por Seção

- **Seções obrigatórias**: Devem ser preenchidas para toda feature
- **Seções opcionais**: Incluir apenas quando relevante para a feature
- Quando uma seção não se aplicar, remova-a por completo (não deixe como "N/A")

### Para Geração por IA

Ao criar esta especificação a partir de um prompt do usuário:

1. **Marque todas as ambiguidades**: Use [PRECISA ESCLARECIMENTO: pergunta específica] para qualquer suposição que você precisaria fazer
2. **Não adivinhe**: Se o prompt não especificar algo (ex.: "sistema de login" sem método de autenticação), marque
3. **Pense como testador**: Todo requisito vago deve falhar no item "testável e inequívoco" do checklist
4. **Áreas frequentemente subespecificadas**:
 - Tipos de usuário e permissões
 - Políticas de retenção/exclusão de dados
 - Metas de performance e escala
 - Comportamentos de tratamento de erros
 - Requisitos de integração
 - Necessidades de segurança/conformidade
5. **Resolução**: os marcadores [PRECISA ESCLARECIMENTO] são resolvidos pelo comando `/clarify`, que registra as respostas numa seção `## Esclarecimentos` (criada sob demanda, com subseções `### Sessão [DATA]`) e atualiza os requisitos afetados

---

## Cenários do Usuário e Testes _(obrigatório)_

### História de Usuário Principal

[Descreva a jornada principal do usuário em linguagem simples]

### Cenários de Aceite

1. **Dado** [estado inicial], **Quando** [ação], **Então** [resultado esperado]
2. **Dado** [estado inicial], **Quando** [ação], **Então** [resultado esperado]

### Casos de Borda

- O que acontece quando [condição de fronteira]?
- Como o sistema lida com [cenário de erro]?

## Requisitos _(obrigatório)_

### Requisitos Funcionais

- **RF-001**: O sistema DEVE [capacidade específica, ex.: "permitir que usuários criem contas"]
- **RF-002**: O sistema DEVE [capacidade específica, ex.: "validar endereços de e-mail"]
- **RF-003**: Os usuários DEVEM poder [interação-chave, ex.: "redefinir sua senha"]
- **RF-004**: O sistema DEVE [requisito de dados, ex.: "persistir preferências do usuário"]
- **RF-005**: O sistema DEVE [comportamento, ex.: "registrar todos os eventos de segurança"]

_Exemplo de marcação de requisitos pouco claros:_

- **RF-006**: O sistema DEVE autenticar usuários via [PRECISA ESCLARECIMENTO: método de autenticação não especificado - e-mail/senha, SSO, OAuth?]
- **RF-007**: O sistema DEVE reter dados do usuário por [PRECISA ESCLARECIMENTO: período de retenção não especificado]

### Entidades Principais _(incluir se a feature envolve dados)_

- **[Entidade 1]**: [O que representa, atributos principais sem implementação]
- **[Entidade 2]**: [O que representa, relacionamentos com outras entidades]

## Critérios de Sucesso _(obrigatório)_

Como saberemos que a feature cumpriu seu objetivo — critérios **mensuráveis**, de produto, não técnicos:

- **CS-001**: [métrica ou comportamento observável, ex.: "usuário conclui o cadastro em menos de 2 minutos"]
- **CS-002**: [ex.: "taxa de erro de validação visível ao usuário, não silenciosa, em 100% dos casos"]

## Dependências e Premissas _(opcional — remover se não houver)_

- **Dependências**: [features, integrações ou decisões externas de que esta feature depende]
- **Premissas**: [o que estamos assumindo como verdadeiro; se uma premissa cair, a spec precisa de revisão]

---

## Checklist de Revisão e Aceite

_PORTÃO: Verificações automáticas executadas durante o fluxo principal_

### Qualidade do Conteúdo

- [ ] Sem detalhes de implementação (linguagens, frameworks, APIs)
- [ ] Focado em valor para o usuário e necessidades de negócio
- [ ] Escrito para stakeholders não técnicos
- [ ] Todas as seções obrigatórias preenchidas

### Completude dos Requisitos

- [ ] Nenhum marcador [PRECISA ESCLARECIMENTO] restante
- [ ] Requisitos são testáveis e inequívocos
- [ ] Critérios de sucesso são mensuráveis
- [ ] Escopo claramente delimitado
- [ ] Dependências e premissas identificadas (ou ausência registrada ao remover a seção)

---

## Status de Execução

_Atualizado durante o processamento_

- [ ] Descrição do usuário interpretada
- [ ] Conceitos-chave extraídos
- [ ] Ambiguidades marcadas
- [ ] Cenários do usuário definidos
- [ ] Requisitos gerados
- [ ] Entidades identificadas
- [ ] Checklist de revisão aprovado

---
