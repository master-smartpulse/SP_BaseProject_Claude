# Constituição do Projeto

**Versão:** 1.5.1  
**Ratificada em:** a definir — preencher ao adotar o template em um projeto (o histórico de versões abaixo refere-se ao template-base)  
**Última emenda:** 2026-07-11 — v1.1.0: Stack Padrão TypeScript (Regra Geral 6); v1.2.0: Regra Geral 3 condicional, Checklist condicional por aplicação, Tipo web+mobile; v1.3.0: `no-explicit-any` como error (Princípio 2); v1.4.0: review.md sancionado (Regra Geral 2), gatilho de atualização de estado restrito e DoD operacional (Princípio 8); v1.5.0: dispensa do UseCase para CRUD trivial e entidades = modelos Prisma (Princípio 1), testes obrigatórios no CI (Princípio 7), TDD por história (Princípio 5); v1.5.1: esclarecimentos — use-cases/ condicionado à Dispensa nos barrels/validação/checklist (Princípio 1), item de CI no Checklist de Conformidade, /taskstoissues e /constitution classificados no gatilho de atualização (Princípio 8)

---

## Preâmbulo

Esta constituição estabelece os princípios fundadores, os padrões arquiteturais e as regras de governança do projeto. O produto DEVE ser desenvolvido com qualidade, seguindo estas diretrizes em todo o tempo.

Todo o trabalho de desenvolvimento DEVE estar alinhado a estes princípios, salvo justificativa explícita pelo processo de emenda da governança. A constituição garante consistência, manutenibilidade e qualidade em todos os componentes do repositório (API backend, aplicação web, app mobile, painel admin e landing page, conforme aplicável).

**Documentação de governança e estado do produto:** O projeto DEVE manter atualizados a constituição (`memory/constitution.md`), o documento de arquitetura (`docs/arquitetura.md`), a wiki de features (`FEATURE_LIST.md`) e o status de implementação (`IMPLEMENTATION_STATUS.md`, em percentual por spec/feature). Esses documentos são a fonte única de verdade para regras e estado atual.

---

## Visão Geral do Produto

(Descreva aqui o produto de forma genérica. Este template serve como base para novos projetos.)

### Objetivo

(Defina o objetivo do produto.)

### Aplicações do Produto

| Aplicação   | Função        |
|------------|----------------|
| Frontend web | (a definir) |
| Backend API | (a definir) |
| App mobile | (a definir — remova esta linha se o projeto não tiver mobile) |

---

## Princípios Fundamentais

### Princípio 1: Clean Architecture

**DEVE:** Todos os módulos do backend seguem Clean Architecture com separação clara de camadas:

- **Controllers:** apenas endpoints HTTP e validação de entrada
- **Services:** orquestração da lógica de negócio
- **Use Cases:** operações de negócio específicas e isoladas
- **Repositories:** abstração de acesso a dados

**Entidades:** os modelos do Prisma (schema) e os tipos em `types/` cumprem o papel de entidade de domínio — não há camada `models/` separada na estrutura de módulos.

**Dispensa do UseCase (CRUD trivial):** operações CRUD triviais — sem regra de negócio composta, sem orquestração de múltiplos repositórios/adapters e sem reuso entre entrypoints — PODEM fluir Controller → Service → Repository, sem UseCase. O UseCase é obrigatório quando qualquer uma dessas condições existir. A dispensa não elimina o Service nem o Repository, e deve ser aplicada de forma consistente dentro do módulo.

**Justificativa:** Permite testabilidade, manutenção e baixo acoplamento sem impor boilerplate onde não há domínio. Cada camada tem uma única responsabilidade e as dependências fluem para dentro.

**DEVE:** Cada subpasta de módulo (controllers/, services/, repositories/, dto/ — e use-cases/ quando o módulo tiver use cases, ver Dispensa acima) DEVE ter arquivo `index.ts` (barrel exports). Cada use case em `use-cases/{action-name}/` DEVE ter seu próprio `index.ts`.

**DEVE:** Todo use case DEVE implementar a interface `IUseCase<Input, Output>` com método `execute(params: Input): Promise<Output>`.

**Validação:** Todo módulo em `backend/src/modules/` (ou equivalente no seu projeto) DEVE seguir a estrutura padrão com diretórios controllers/, services/, repositories/ e dto/ — e use-cases/ quando o módulo tiver use cases (Dispensa acima) — cada um com index.ts.

---

### Princípio 2: Type Safety em Primeiro Lugar

**DEVE:** TypeScript em modo strict em todos os projetos. Todo o código DEVE ser totalmente tipado, sem uso de `any`, exceto quando explicitamente justificado.

**DEVE:** Backend usa Prisma como ORM type-safe para acesso ao banco (ver Stack Padrão, Regra Geral 6). Frontend usa Zod (ou equivalente) para validação em tempo de execução alinhada aos tipos TypeScript.

**Justificativa:** Reduz erros em runtime, melhora a experiência do desenvolvedor e permite detectar bugs em tempo de compilação.

**Validação:**

- `tsconfig.json` DEVE ter `strict: true` (ou flags strict equivalentes)
- Regra ESLint `@typescript-eslint/no-explicit-any` DEVE estar habilitada como **error**; exceções apenas via `// eslint-disable-next-line @typescript-eslint/no-explicit-any` acompanhado de comentário com a justificativa
- Todos os contratos de API DEVE ter tipos TypeScript correspondentes

---

### Princípio 3: Padrão Repository

**DEVE:** Todo acesso a dados DEVE ocorrer por classes de repositório. O uso direto do cliente do ORM (Prisma Client) em services ou controllers é PROIBIDO.

**DEVE:** Repositórios abstraem operações de banco e oferecem interface consistente para testes com mocks.

**Justificativa:** Isola a lógica de persistência, facilita testes e permite futuras migrações de banco sem alterar a lógica de negócio.

**Validação:** Nenhuma chamada ao cliente do ORM fora de classes de repositório. Todos os repositórios DEVE implementar interfaces para injeção de dependência.

---

### Princípio 4: Design API-First

_Aplica-se a aplicações backend; features sem backend não geram estas obrigações (ver Regra Geral 6)._

**DEVE:** Todos os endpoints de API DEVE ser documentados com Swagger/OpenAPI antes da implementação.

**DEVE:** Contratos de API DEVE ser definidos em `specs/[feature]/contracts/` antes do início da implementação.

**DEVE:** Testes de contrato DEVE ser escritos e DEVE falhar antes da implementação (TDD).

**Justificativa:** Garante contratos claros entre frontend e backend, permite desenvolvimento paralelo e evita breaking changes.

**Validação:** Todo endpoint nos controllers DEVE ter decorators Swagger (ou equivalente). Testes de contrato DEVE existir para todos os endpoints públicos.

---

### Princípio 5: Desenvolvimento Orientado a Testes (TDD)

**DEVE:** Testes DEVE ser escritos antes da implementação em todas as features novas:

- Testes de contrato para endpoints de API
- Testes de integração para cenários de usuário
- Testes unitários para lógica de negócio

**DEVE:** Os testes DEVE falhar inicialmente; em seguida a implementação fazê-los passar.

**Justificativa:** Garante que os requisitos estão compreendidos, evita over-engineering e mantém alta qualidade de código.

**Validação:** No tasks.md, toda task de implementação DEVE ser precedida pela(s) task(s) de teste correspondente(s) — dentro de cada bloco de user story, as tasks de teste vêm antes das de implementação, independentemente da numeração. Todos os testes DEVE ser executáveis e documentados.

---

### Princípio 6: Separação de Responsabilidades

**DEVE:** Cada módulo, componente e caso de uso DEVE ter uma única responsabilidade bem definida.

**DEVE:** Lógica de negócio NÃO DEVE estar em controllers ou componentes de UI. Controllers tratam HTTP; componentes tratam apresentação.

**DEVE:** Serviços compartilhados DEVE ficar no diretório `shared/` (ou equivalente).

**DEVE:** Integrações com serviços externos (e-mail, SMS, pagamento, armazenamento de arquivos) DEVE seguir o padrão de **Adapters** definido em `docs/arquitetura.md`: interface única e implementações trocáveis (mock em dev, real em prod). Nenhum módulo DEVE chamar diretamente o provedor; DEVE injetar o adapter.

**Justificativa:** Reduz acoplamento, melhora manutenção e permite reuso. Adapters garantem testabilidade e troca de provedor sem alterar regras de negócio.

**Validação:** Nenhuma lógica de negócio em controllers além de validação e delegação. Nenhum acesso a dados em componentes além dos hooks de dados (ex.: React Query).

---

### Princípio 7: Padrões de Qualidade de Código

**DEVE:** Todo o código DEVE passar em checagens ESLint e Prettier antes do commit.

**DEVE:** Commits DEVE seguir o formato Conventional Commits: `<type>(<scope>): <subject>`

**DEVE:** Hooks de pre-commit (ex.: Husky) DEVE executar lint-staged nos arquivos modificados.

**DEVE:** A checagem de tipos DEVE passar (`tsc --noEmit`) antes do merge.

**Justificativa:** Mantém estilo de código consistente, permite automação e melhora a eficiência de code review.

**Validação:** O pipeline de CI/CD DEVE executar lint, type-check, **testes** e validação de build (workflow base em `.github/workflows/ci.yml`). Todos os commits DEVE seguir o formato.

---

### Princípio 8: Documentação e Observabilidade

**DEVE:** Todos os endpoints de API DEVE ser documentados no Swagger acessível em `/api/docs` (ou path equivalente).

**DEVE:** Comentários no código apenas quando essenciais (ex.: rationale não óbvio em lógica complexa). Ver Regras Gerais.

**DEVE:** Especificações de features DEVE estar em `specs/[feature]/spec.md` antes da implementação.

**DEVE:** Planos de implementação DEVE estar em `specs/[feature]/plan.md` com contexto técnico e decisões de design.

**DEVE:** O projeto DEVE manter atualizados: `docs/arquitetura.md` (regras de arquitetura e padrão de Adapters), `FEATURE_LIST.md` (wiki de features do produto: o que cada parte faz, o que o usuário pode fazer) e `IMPLEMENTATION_STATUS.md` (tabela simples: spec × nível de completude em %).

**Justificativa:** Facilita onboarding, reduz silos de conhecimento, torna decisões rastreáveis e mantém o estado do produto e da implementação visível para lançamento e operação.

**Validação:** Documentação Swagger DEVE estar atualizada. Todas as specs DEVE seguir os templates em `templates/`. FEATURE_LIST e IMPLEMENTATION_STATUS DEVE ser atualizados quando features ou progresso de implementação mudarem — os comandos que mudam estado de feature (`/specify`, `/specify-tech`, `/implement`, `/review` e `/specify-design` quando cria/altera funcionalidade visível) DEVEM atualizá-los ao concluir; **todos os demais comandos** (`/plan`, `/tasks`, `/clarify`, `/analyze`, `/constitution`, `/taskstoissues`) não geram essa obrigação (o estágio é derivável dos artefatos em `specs/`). A completude e a Definição de Pronto seguem a fórmula operacional definida em `IMPLEMENTATION_STATUS.md` (% = tasks [X]/total; PRONTA = 100% + review APROVADO com verificação executável).

---

## Regras Gerais

Estas regras aplicam-se a todo o desenvolvimento, incluindo trabalho assistido por IA:

1. **Sem comentários no código a não ser que sejam essenciais.** Código autoexplicativo é preferível. Comentários são permitidos apenas quando explicam o "porquê" não óbvio (ex.: workaround de biblioteca, decisão de negócio crítica, restrição de performance). Evite comentários que descrevem o "o quê" — o código deve falar por si.

2. **Sem criar arquivos MD se o usuário não pedir.** Não criar README.md, CHANGELOG.md, CONTRIBUTING.md, documentação adicional ou qualquer arquivo Markdown além dos artefatos sancionados do fluxo em `specs/[feature]/`: spec.md (ou spec-tech.md), plan.md, research.md, data-model.md, quickstart.md, contracts/, tasks.md e review.md. Exceção: os documentos de governança (constitution, arquitetura, FEATURE_LIST, IMPLEMENTATION_STATUS) são mantidos conforme Princípio 8.

3. **Design System (Frontend):** Todo desenvolvimento de interface do usuário (páginas, componentes, formulários) DEVE seguir o design e os padrões definidos na pasta `design-boilerplate/`, **quando ela existir no projeto**. O boilerplate utiliza React, TypeScript, shadcn/ui e Tailwind CSS (tooling de build conforme a stack web escolhida — Vite ou Next.js, ver Regra Geral 6). Componentes de UI, tokens de cor (CSS variables), tipografia e layout DEVE ser consistentes com o design-boilerplate. Enquanto a pasta não existir, os padrões de design adotados DEVEM ser registrados no plan.md da primeira feature com UI e seguidos nas demais.

4. **Banco de dados em inglês:** Todas as tabelas, colunas, índices e nomes no esquema do banco de dados DEVEM estar em inglês. Justificativa: consistência técnica, portabilidade e alinhamento a convenções internacionais.

5. **Código e artefatos em inglês; comunicação com cliente em pt-BR:** Arquivos, pastas, nomes de variáveis, funções, classes, comentários no código, commits, DTOs, paths de API, propriedades JSON da API e artefatos técnicos DEVEM estar em inglês. Apenas a comunicação direta com o usuário final (mensagens de UI, textos de erro exibidos ao cliente, documentação para stakeholders) e especificações em `specs/` DEVE estar em português (pt-BR). Justificativa: código e estrutura em inglês facilitam colaboração internacional e convenções técnicas; pt-BR na interface garante experiência adequada ao público-alvo.

6. **Stack Padrão (TypeScript em todas as camadas):** O projeto usa **TypeScript strict** de ponta a ponta. A stack oficial, **por aplicação presente no projeto**, é:
   - **Backend:** Node.js + NestJS + Prisma + PostgreSQL
   - **Frontend web:** React + TypeScript (Vite ou Next.js) + TanStack Query + Zod
   - **Mobile:** React Native + Expo (TypeScript) — apps nativos Swift/Kotlin não fazem parte da stack padrão

   Aplicações que o projeto não possui não geram obrigação (um projeto apenas web ignora a stack mobile, e vice-versa). O **Tipo de Projeto** declarado no `plan.md` (single/web/mobile/**web+mobile**) determina quais stacks e skills se aplicam à feature — `web+mobile` combina as obrigações de frontend web e mobile. Desvios de stack DEVEM ser registrados e justificados no `plan.md` da feature conforme o Processo de Desvio. Justificativa: uma única linguagem em todas as camadas maximiza reuso de tipos, contratos e conhecimento; a escolha condicional por aplicação evita impor obrigações de plataformas inexistentes no projeto.

---

## Governança

### Processo de Emenda

1. **Proposta:** Criar documento de proposta com a mudança, justificativa e impacto
2. **Revisão:** Liderança técnica revisa em relação aos objetivos do projeto e princípios existentes
3. **Aprovação:** Exige consenso da equipe core
4. **Atualização:** Constituição atualizada com bump de versão conforme versionamento semântico
5. **Propagação:** Todos os templates e documentação dependentes atualizados

### Política de Versionamento

- **MAJOR (X.0.0):** Mudanças incompatíveis com versões anteriores, remoção de princípios ou redefinições fundamentais
- **MINOR (x.Y.0):** Novos princípios ou expansão material de princípios existentes
- **PATCH (x.y.Z):** Esclarecimentos, redação, correções de typo, refinamentos não semânticos

### Revisão de Conformidade

- **Por feature:** O Constitution Check DEVE ser realizado na fase de planejamento (ver `plan-template.md`)
- **Por release:** Todas as features DEVE passar na validação constitucional antes do merge
- **Trimestral:** Auditoria de conformidade de todos os módulos e componentes

### Processo de Desvio

Se um princípio não puder ser seguido em uma feature específica:

1. Documentar o desvio em `specs/[feature]/plan.md` em "Complexity Tracking"
2. Explicar por que o princípio não pode ser seguido
3. Justificar por que alternativas mais simples foram rejeitadas
4. Obter aprovação explícita da liderança técnica
5. Atualizar a constituição se o desvio virar padrão

---

## Checklist de Conformidade

Toda implementação de feature DEVE verificar. Itens marcados com condição ("se houver X") aplicam-se apenas quando a feature envolve a aplicação correspondente (Regra Geral 6):

- [ ] TypeScript strict, sem tipos `any`
- [ ] Testes escritos antes da implementação (TDD)
- [ ] Responsabilidade única por módulo/componente
- [ ] ESLint e Prettier aprovados
- [ ] Formato Conventional Commits
- [ ] Spec e plan completos
- [ ] Comentários apenas quando essenciais (Regras Gerais)
- [ ] Nenhum arquivo MD criado sem solicitação explícita do usuário (Regras Gerais)
- [ ] Código e artefatos em inglês; UI/stakeholders em pt-BR (Regras Gerais)
- [ ] Stack Padrão TypeScript respeitada conforme o Tipo de Projeto, ou desvio justificado no plan.md (Regras Gerais)
- [ ] Se houver backend: camadas da Clean Architecture respeitadas, sem bypass
- [ ] Se houver backend: Padrão Repository para todo acesso a dados
- [ ] Se houver backend: contratos de API definidos e Documentação Swagger atualizada (Princípio 4)
- [ ] Se houver backend: index.ts em controllers, services, repositories, dto e — quando existir — use-cases (Princípio 1)
- [ ] Se houver backend: use cases, quando existirem, implementam IUseCase (Princípio 1; CRUD trivial pode dispensá-los)
- [ ] CI verde: pipeline executa lint, type-check, testes e build (Princípio 7)
- [ ] Se houver banco de dados: esquema em inglês (Regras Gerais)
- [ ] Se houver frontend web: alinhado ao design system (design-boilerplate quando existir — Regras Gerais); dados via repository hooks
- [ ] Se houver mobile: credenciais em armazenamento seguro; estados offline tratados; dados via repository hooks (docs/arquitetura.md, seção Mobile)

---

## Documentos Relacionados

- **Arquitetura:** `docs/arquitetura.md` — Arquitetura técnica detalhada e padrão de Adapters
- **Features:** `FEATURE_LIST.md` — Inventário de features do produto
- **Status:** `IMPLEMENTATION_STATUS.md` — Status atual de implementação

---

**Esta constituição é um documento vivo. Todos os membros da equipe são responsáveis por defender estes princípios e propor melhorias pelo processo de governança.**
