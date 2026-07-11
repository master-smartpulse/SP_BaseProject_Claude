# Arquitetura do Sistema

Este documento descreve a arquitetura do sistema, incluindo padrões arquiteturais, estruturas e decisões técnicas de cada componente. É a **referência obrigatória** para o Arquiteto e para o Dev; todas as integrações externas devem seguir o padrão de Adapters descrito abaixo. Adapte título, stack e nomes ao seu projeto.

---

## Índice

1. [Backend](#backend)
2. [Frontend Web](#frontend-web)
3. [Landing Page](#landing-page-opcional)
4. [Mobile](#mobile-react-native--expo)
5. [Arquitetura Geral](#arquitetura-geral)
6. [Deploy e Infraestrutura](#deploy-e-infraestrutura)

---

## Backend

### Stack Tecnológica (oficial)

Stack oficial do backend (Constitution, Regra Geral 6). Desvios devem ser justificados no `plan.md` da feature, conforme o Processo de Desvio:

- **Framework**: Node.js com TypeScript (NestJS)
- **Linguagem**: TypeScript em strict mode
- **Banco de Dados**: PostgreSQL
- **ORM**: Prisma, com sistema de migrações
- **Autenticação**: JWT, Passport, hash de senhas (ex.: bcrypt)
- **Validação**: class-validator / class-transformer ou equivalente
- **Filas** (opcional): Bull + Redis ou equivalente
- **WebSocket** (opcional): Socket.io ou equivalente
- **Documentação**: Swagger/OpenAPI
- **Logging**: Logging estruturado (ex.: Winston)

### Idioma: Código em Inglês, UI em pt-BR

Arquivos, pastas, variáveis, funções, classes, DTOs, paths de API, propriedades JSON e comentários DEVEM estar em inglês. Mensagens exibidas ao usuário final (UI, erros de API) e documentação para stakeholders em português (pt-BR). Ver Constituição, Regras Gerais.

### Convenções de Banco de Dados (obrigatório)

Se usar Prisma (ou ORM com schema), siga estas convenções para consistência:

- **Idioma**: Todas as tabelas, colunas, índices e nomes no esquema do banco DEVEM estar em **inglês** — assim como o código (Regra Geral 5). O mapeamento no Prisma usa `@map()` e `@@map()` para converter o camelCase do código em snake_case no banco.
- **Migrations**: toda alteração de schema DEVE ter migration correspondente (`prisma migrate dev` em desenvolvimento, `prisma migrate deploy` no deploy). Migrations aditivas e reversíveis; mudanças breaking seguem expand-contract (adicionar → migrar dados → remover). Ver checklist da skill `data-modeler`.
- **Colunas no banco**: snake_case em inglês. Todo campo camelCase no código deve mapear para snake_case em inglês (ex.: no Prisma use `@map("snake_case")`):
  - `userId` → `@map("user_id")`
  - `createdAt` → `@map("created_at")`
  - `isActive` → `@map("is_active")`
  - (padrão: camelCase no código → snake_case em inglês no banco)
- **Tabelas**: snake_case em inglês (ex.: `@@map("users")`, `@@map("user_preferences")`).
- **Código**: camelCase para propriedades de modelos e DTOs.

**Exemplo (Prisma):**
```prisma
model ProjectParticipant {
  id        String   @id @default(uuid())
  projectId String   @map("project_id")
  userId    String   @map("user_id")
  role      String   @default("viewer")
  joinedAt  DateTime @default(now()) @map("joined_at")
  @@map("project_participants")
}
```

### Padrão Arquitetural: Clean Architecture

O backend deve seguir separação clara de responsabilidades em camadas:

```
modules/
  {module-name}/
    ├── {module-name}.module.ts          # Módulo (configuração)
    ├── controllers/                     # Camada de apresentação (HTTP)
    │   ├── {module-name}.controller.ts
    │   └── index.ts
    ├── services/                        # Lógica de negócio
    │   ├── {module-name}.service.ts
    │   └── index.ts
    ├── repositories/                    # Acesso a dados
    │   ├── {module-name}.repository.ts
    │   └── index.ts
    ├── use-cases/                       # Casos de uso específicos
    │   ├── create-{entity}/
    │   │   ├── create-{entity}.use-case.ts
    │   │   └── index.ts
    │   └── index.ts
    ├── dto/                             # Data Transfer Objects (validação)
    │   ├── create-{entity}.dto.ts
    │   ├── update-{entity}.dto.ts
    │   └── index.ts
    ├── types/                           # Types/Interfaces (opcional)
    ├── events/                          # Eventos (opcional)
    ├── gateways/                        # WebSocket (opcional)
    └── ...                              # Outros conforme necessidade
```

### Fluxo de Dados

```
HTTP Request
    ↓
Controller (validação de entrada)
    ↓
Service (orquestrador)
    ↓
Use Case (caso de uso específico)   ← dispensável em CRUD trivial (ver regra abaixo)
    ↓
Repository (acesso a dados)
    ↓
ORM / Banco de Dados
```

**Regra de dispensa do UseCase (Constitution, Princípio 1):** operações CRUD triviais — sem regra de negócio composta, sem orquestração de múltiplos repositórios/adapters e sem reuso entre entrypoints — PODEM fluir Controller → Service → Repository. O UseCase é obrigatório quando qualquer uma dessas condições existir. A dispensa não elimina Service nem Repository e deve ser consistente dentro do módulo.

### Padrões Implementados

#### 1. Repository Pattern
- Abstração da camada de acesso a dados
- Facilita testes e manutenção
- Isolamento de lógica de persistência

#### 2. Use Case Pattern
- Casos de uso isolados e reutilizáveis
- Todo use case DEVE implementar a interface `IUseCase<Input, Output>`:

```typescript
export interface IUseCase<TInput = unknown, TOutput = unknown> {
  execute(params: TInput): Promise<TOutput>;
}

// Exemplo
export class CreateUserUseCase implements IUseCase<CreateUserArgs, { success: boolean; message: string }> {
  async execute(params: CreateUserArgs): Promise<{ success: boolean; message: string }> { ... }
}
```

- Args/Input tipados (ex.: `CreateUserArgs`, `GetUserByIdArgs`)
- Facilita testes unitários e consistência estrutural

#### 3. Dependency Injection
- Dependências injetadas (constructor injection)
- Facilita testes com mocks
- Baixo acoplamento entre módulos

#### 4. Event-Driven (opcional)
- EventEmitter ou message bus para eventos assíncronos
- Desacoplamento entre módulos

#### 5. Modular Architecture
- Módulos independentes por domínio
- Cada módulo auto-contido

#### 6. Adapters para Integrações Externas (obrigatório)

Toda integração com serviço externo (e-mail, SMS, pagamento, armazenamento de arquivos) **DEVE** ser abstraída por um **Adapter**: interface única + implementações trocáveis (mock em dev, real em prod).

**Regras:**

- **E-mail**: Interface (ex.: `IEmailAdapter`) com método de envio (destinatário, assunto, corpo). Implementações: provedor real (SMTP, SendGrid, etc.), mock. Nenhum módulo deve chamar diretamente o provedor; deve injetar o adapter.
- **SMS**: Interface (ex.: `ISmsAdapter`) com método de envio (número, mensagem). Implementações: provedor real, mock.
- **Pagamento**: Interface (ex.: `IPaymentAdapter`) com operações de cobrança/assinatura. Implementações: gateway real, mock.
- **Armazenamento**: Interface (ex.: `IStorageAdapter`) para upload/delete de arquivos. Implementações: local, S3 ou outro; nenhum módulo deve usar diretamente o cliente do provedor.

**Estrutura esperada:**

- `shared/{dominio}/` contém: interface, factory que escolhe a implementação conforme env/config, e implementações em subpastas (ex.: `mock/`, `real/`).
- O módulo registra o adapter via provider/useFactory.
- Testes usam mocks que implementam a mesma interface.

**Exemplo (NestJS — adapter com token + useFactory):**

```typescript
// shared/email/email.adapter.ts
export const EMAIL_ADAPTER = Symbol('EMAIL_ADAPTER');

export interface IEmailAdapter {
  send(to: string, subject: string, body: string): Promise<void>;
}

// shared/email/email.module.ts
// Premissa: ConfigModule.forRoot({ isGlobal: true }) registrado no AppModule
// (senão, adicione imports: [ConfigModule] aqui)
@Module({
  providers: [
    {
      provide: EMAIL_ADAPTER,
      useFactory: (config: ConfigService): IEmailAdapter =>
        config.get('EMAIL_PROVIDER') === 'smtp'
          ? new SmtpEmailAdapter(config)
          : new MockEmailAdapter(),
      inject: [ConfigService],
    },
  ],
  exports: [EMAIL_ADAPTER],
})
export class EmailModule {}

// consumo em um use case (constructor injection)
constructor(@Inject(EMAIL_ADAPTER) private readonly email: IEmailAdapter) {}
```

**Exemplo (binding de repository por token):**

```typescript
export const USER_REPOSITORY = Symbol('USER_REPOSITORY');

@Module({
  providers: [{ provide: USER_REPOSITORY, useClass: PrismaUserRepository }],
  exports: [USER_REPOSITORY],
})
export class UsersModule {}
```

#### 7. Convenções de Nomenclatura (Clean Code)

- **Variáveis de entidades**: Nomes completos e autoexplicativos. Evitar abreviações.
  - Evitar: `u.id`, `p` para project, `b` para budget
  - Preferir: `user.id`, `project`, `budget`

### Filas e Processamento Assíncrono (opcional)

Se o projeto usar filas (ex.: Bull + Redis):

- Jobs pesados (importações, notificações em lote) devem ser enfileirados
- Retry com backoff exponencial
- Timeout e retenção configuráveis
- Opcional: progresso via WebSocket para o cliente

### WebSocket (opcional)

Se usar comunicação em tempo real:

- Autenticação via JWT no handshake
- Eventos bem definidos (subscribe, progress, completed, error)
- Documentar contrato de eventos no plano da feature

### Pipeline HTTP (NestJS)

Configuração idiomática obrigatória do pipeline de request:

- **ValidationPipe global** com `whitelist: true` e `forbidNonWhitelisted: true` (rejeita campos não declarados no DTO) e `transform: true`:

```typescript
app.useGlobalPipes(new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true, transform: true }));
```

- **Guards** para autenticação/autorização (`JwtAuthGuard`, guards de role/ownership) — controllers não checam permissão manualmente.
- **Exception filters** para mapear erros de domínio em respostas HTTP com o `ErrorResponse` padrão — sem stack trace ao cliente.
- **Interceptors** para logging de request/response com correlation id.

### Autenticação e Sessão (obrigatório)

- **Access token curto** (~15 min) + **refresh token com rotação** (refresh usado uma vez é invalidado; reuso detectado → sessão revogada).
- **Logout** invalida o refresh token no servidor.
- **Armazenamento no cliente**:
  - **Web**: cookie `httpOnly` + `Secure` + `SameSite` (preferido) **ou** access token somente em memória com refresh silencioso. **PROIBIDO** token em `localStorage`/`sessionStorage`.
  - **Mobile**: somente `expo-secure-store` (ver seção Mobile).

### Variáveis de Ambiente

Manter secrets e configuração em variáveis de ambiente (ex.: `DATABASE_URL`, `JWT_SECRET`, provedores de e-mail/SMS/pagamento, etc.). Não commitar valores reais. No NestJS, acesso via `ConfigModule`/`ConfigService` tipado — registre `ConfigModule.forRoot({ isGlobal: true })` no AppModule e nunca use `process.env` espalhado pelos módulos.

### Testes

- Testes unitários para lógica de negócio e use cases
- Testes de integração HTTP para endpoints
- Mocks para repositórios e adapters

---

## Frontend Web

### Design System Obrigatório

Todo desenvolvimento de interface DEVE seguir o design e os padrões definidos em `design-boilerplate/`, **quando a pasta existir no projeto**. O boilerplate utiliza React, TypeScript, shadcn/ui e Tailwind CSS (tooling de build conforme a stack web escolhida — Vite ou Next.js). Componentes de UI, tokens de cor (CSS variables), tipografia e layout devem ser consistentes com o design-boilerplate. A aplicação web real reside em `frontend-web/` e consome o design system. Enquanto a pasta não existir, registre os padrões de design adotados no plan.md da primeira feature com UI. Ver Regras Gerais na Constituição.

### Stack (oficial)

Stack oficial do frontend web (Constitution, Regra Geral 6). Desvios devem ser justificados no `plan.md` da feature:

- **Framework**: React com TypeScript
- **Build**: Vite ou Next.js (conforme o projeto)
- **Roteamento**: React Router (Vite) ou App Router (Next.js)
- **Estado servidor**: React Query (TanStack Query)
- **HTTP**: Axios ou fetch
- **Formulários**: React Hook Form + Zod (ou equivalente)
- **Estilo**: Tailwind CSS, componentes (ex.: shadcn/ui, Radix UI)
- **Testes E2E**: Playwright ou equivalente
- **Sessão/tokens**: cookie httpOnly+Secure+SameSite ou token somente em memória com refresh silencioso — nunca em localStorage (ver "Autenticação e Sessão" na seção Backend)

### Estrutura de Pastas (exemplo)

```
src/
  ├── api/                    # Configuração HTTP (Axios, interceptors)
  ├── components/             # Componentes reutilizáveis
  │   └── ui/
  ├── pages/                  # Páginas/rotas
  ├── repository/             # Hooks React Query (camada de dados)
  │   ├── use-{entity}-queries.ts
  │   └── use-{entity}-mutations.ts
  ├── contexts/               # Context API (Auth, Theme, etc.)
  ├── hooks/                  # Custom hooks
  ├── lib/                    # Utilitários
  ├── types/                  # TypeScript types
  ├── utils/
  ├── constants/
  └── schemas/                # Validação Zod (opcional)
```

### Padrões

1. **Repository Pattern**: Hooks React Query abstraem chamadas HTTP
2. **Component-Based**: Componentes reutilizáveis e isolados
3. **Custom Hooks**: Lógica reutilizável em hooks
4. **Context API**: Estado global quando necessário (Auth, Theme, etc.)

### Fluxo de Dados

```
User Action → Component → Hook (useMutation/useQuery) → Repository Hook → API → Backend
```

---

## Landing Page (opcional)

Se o projeto tiver landing page separada:

- Estrutura típica: components (sections, forms, layout), pages, services/api, repository (hooks), hooks, schemas, types, lib, assets
- Integração com backend via endpoints públicos documentados (ex.: planos, registro, contato)

Adapte seções (Hero, Features, Pricing, FAQ, Contact, Register, Checkout) ao produto.

---

## Mobile (React Native / Expo)

> **Seção condicional**: aplica-se apenas quando o projeto possui aplicativo mobile (Tipo de Projeto `mobile` ou `web+mobile` no plan.md). Projetos apenas web ignoram esta seção. A stack mobile oficial é React Native + Expo com TypeScript (Constitution, Regra Geral 6) — sem nativo Swift/Kotlin.

### Stack (exemplo)

- **Framework**: React Native + Expo SDK (TypeScript strict)
- **Navegação**: Expo Router (file-based) ou React Navigation com rotas tipadas
- **Estado servidor**: TanStack Query (mesmo padrão do frontend web)
- **Estado cliente**: Zustand ou Context API
- **HTTP**: Axios ou fetch (client compartilhável com o web quando em monorepo)
- **Formulários**: React Hook Form + Zod
- **Armazenamento seguro**: `expo-secure-store` para tokens e credenciais
- **Listas**: FlashList (ou FlatList otimizada)
- **Imagens**: `expo-image`
- **Testes**: Jest + React Native Testing Library; E2E com Maestro (ou Detox)
- **Build/Distribuição**: EAS Build e EAS Submit (TestFlight / Play Console)

### Estrutura de Pastas (exemplo)

```
mobile-app/
  ├── app/                    # Rotas (Expo Router, file-based)
  │   ├── (auth)/             # Grupo de rotas autenticadas
  │   └── (public)/           # Grupo de rotas públicas
  ├── src/
  │   ├── api/                # Client HTTP (interceptors, refresh de token)
  │   ├── components/         # Componentes reutilizáveis
  │   ├── features/           # Telas e lógica por feature
  │   ├── repository/         # Hooks TanStack Query (camada de dados)
  │   ├── contexts/           # Auth, Theme, etc.
  │   ├── hooks/              # Custom hooks (useAppState, usePermissions)
  │   ├── lib/                # Utilitários
  │   ├── schemas/            # Validação Zod
  │   └── types/
  ├── assets/
  ├── app.json                # Configuração Expo
  └── eas.json                # Perfis de build EAS
```

### Padrões

1. **Repository Pattern**: Hooks TanStack Query abstraem chamadas HTTP — telas nunca chamam a API diretamente (mesmo padrão do frontend web)
2. **Credenciais seguras**: Tokens **somente** em `expo-secure-store`; PROIBIDO token em AsyncStorage ou estado persistido em texto plano
3. **Offline e rede instável**: Toda tela com dados remotos DEVE tratar estados de loading, erro de rede e vazio; usar cache do TanStack Query para degradação suave
4. **Permissões**: Solicitar permissões (câmera, localização, notificações) em contexto de uso, com tratamento do fluxo de negação (fallback ou orientação ao usuário)
5. **Ciclo de vida**: Reagir a `AppState` (background/foreground) quando houver dados sensíveis ou sessões com expiração
6. **Deep linking**: Rotas relevantes acessíveis via deep link/universal link configurados no Expo Router
7. **UI de plataforma**: Respeitar safe areas, touch targets ≥ 44pt e comportamento de teclado (KeyboardAvoidingView)

### Fluxo de Dados

```
User Action → Screen → Hook (useQuery/useMutation) → Repository Hook → API Client → Backend
```

### Performance

- Listas longas com FlashList (`estimatedItemSize`, `keyExtractor`)
- Imagens com `expo-image` (cache e placeholder)
- Evitar re-renders: memoização medida, seletores no Zustand
- Bundles: verificar tamanho com `npx expo-doctor` e EAS build profiles

---

## Arquitetura Geral

### Estrutura do Monorepo (exemplo)

```
{project-root}/
  ├── backend/             # API (NestJS ou equivalente)
  ├── frontend-web/        # Aplicação web (app real)
  ├── mobile-app/          # App mobile React Native/Expo (opcional)
  ├── design-boilerplate/  # Design system (componentes UI, tokens, Tailwind)
  ├── landing-page/        # Landing (opcional)
  ├── scripts/             # Scripts utilitários
  ├── specs/               # Especificações e documentação
  └── docker-compose.yml   # Orquestração (opcional)
```

### Comunicação entre Componentes

- Frontend e Landing consomem a API via HTTP/REST
- WebSocket quando houver necessidade de tempo real
- Contratos de API documentados (Swagger/OpenAPI)

### Contrato compartilhado backend ↔ clientes (decisão oficial)

- **Backend** valida entrada com class-validator/class-transformer (idiomático NestJS com ValidationPipe) e publica o contrato via Swagger/OpenAPI.
- **Clientes (web e mobile)** geram os tipos TypeScript a partir do contrato com `openapi-typescript` (script `generate:api-types` apontando para o JSON do Swagger) — **sem redeclarar shapes manualmente**.
- Os **schemas Zod** do cliente (formulários, validação em runtime) devem se alinhar aos tipos gerados; divergência entre schema Zod e tipo gerado é bug de contrato.
- Alternativa registrada: Zod ponta a ponta via `nestjs-zod` com schemas em `packages/shared` — desvio permitido se justificado no plan.md.

### Decisões de engenharia (padrão)

- **Package manager**: pnpm (workspaces para monorepo). Desvios via plan.md.
- **Monorepo**: estrutura simples com workspaces; adotar Turborepo apenas quando builds/testes ficarem lentos o suficiente para justificar.
- **Versões mínimas**: Node LTS ≥ 22; TypeScript ≥ 5.5.
- **Código compartilhado**: `packages/shared` para tipos, schemas e utilitários usados por backend, web e mobile.

### Princípios

1. **Separation of Concerns**: Cada camada com responsabilidade única
2. **DRY**: Código reutilizável
3. **SOLID**: Princípios de design orientado a objetos
4. **API-First**: Contratos definidos antes da implementação
5. **Type Safety**: TypeScript em todo o stack
6. **Testability**: Código testável e coberto por testes

### Segurança

- Autenticação (ex.: JWT) e controle de acesso (RBAC)
- Rate limiting, validação de entrada, CORS
- Secrets em variáveis de ambiente

### Performance

- Cache (ex.: React Query), lazy loading, code splitting
- Índices no banco, processamento pesado em background quando aplicável

### Observabilidade

- Logging estruturado, health checks, documentação da API (Swagger)
- Monitoramento de erros/performance conforme necessidade

---

## Deploy e Infraestrutura

- Docker e docker-compose para serviços (DB, cache, backend) conforme necessidade
- CI/CD: pipeline com lint, type-check, testes e deploy

---

**Última atualização**: 2026-07-11 (template-base — substitua pela data do seu projeto ao adotar)
