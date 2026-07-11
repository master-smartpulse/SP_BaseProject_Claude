# Gerenciamento de Memória

Quando e como atualizar `.specify-design/system.md`.

## Quando Adicionar Padrões

Adicione ao system.md quando:
- O componente é usado 2+ vezes
- O padrão é reutilizável em todo o projeto
- Tem medidas específicas que valem a pena lembrar

## Formato de Padrão

```markdown
### Button Primary
- Height: 36px
- Padding: 12px 16px
- Radius: 6px
- Font: 14px, 500 weight
```

## Não Documente

- Componentes pontuais (one-off)
- Experimentos temporários
- Variações melhor resolvidas com props

## Reuso de Padrões

Antes de criar um componente, verifique o system.md:
- O padrão existe? Use-o.
- Precisa de variação? Estenda, não crie um novo.

A memória se acumula: cada padrão salvo torna o trabalho futuro mais rápido e mais consistente.
