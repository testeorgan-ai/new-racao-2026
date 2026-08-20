# 🎁 Guia de Cupons e Descontos - PetShop Express

## ✅ O que foi implementado

Sistema completo de cupons com:
- ✅ Criar cupons no painel admin
- ✅ Ativar/desativar cupons
- ✅ Descontos percentuais (%) ou fixos (R$)
- ✅ Aplicar cupom no carrinho
- ✅ Visualizar desconto antes de enviar pedido
- ✅ Cupom aparece na mensagem do WhatsApp

---

## 🚀 Setup - Criar Tabela no Banco

### 1️⃣ Acessar Supabase

1. Vá para [https://supabase.com](https://supabase.com)
2. Acesse seu projeto
3. Vá para **SQL Editor** (lado esquerdo)

### 2️⃣ Executar Script SQL

1. Clique em **"New query"**
2. Copie o conteúdo do arquivo `CRIAR_TABELA_CUPONS.sql`
3. Cole no editor
4. Clique em **"Run"** (ou Ctrl+Enter)

```sql
CREATE TABLE cupons (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  codigo VARCHAR(50) NOT NULL UNIQUE,
  tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('percentual', 'fixo')),
  valor DECIMAL(10, 2) NOT NULL CHECK (valor > 0),
  ativo BOOLEAN NOT NULL DEFAULT true,
  usos INTEGER NOT NULL DEFAULT 0,
  limite_uso INTEGER,
  data_criacao TIMESTAMP NOT NULL DEFAULT NOW(),
  data_atualizacao TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Índices para performance
CREATE INDEX idx_cupons_codigo ON cupons(codigo);
CREATE INDEX idx_cupons_ativo ON cupons(ativo);
```

✅ Se ver mensagem verde "Success", está feito!

---

## 💡 Como Usar

### Para ADMIN (no painel)

1. Abra `admin.html`
2. Vá até **"Cupons & Descontos"** (novo menu)
3. Preencha:
   - **Código do Cupom** (ex: `DESCONTO10`, `BLACKFRIDAY`)
   - **Tipo**: `% Percentual` ou `R$ Fixo`
   - **Valor**: valor do desconto
4. Clique em **"Criar Cupom"**

**Exemplo:**
- Código: `DESC50REAIS`
- Tipo: `R$ Fixo`
- Valor: `50`
- Resultado: Desconto de R$ 50,00

### Para CLIENTES (na vitrine)

1. Abra `index.html`
2. Adicione produtos ao carrinho
3. Clique no carrinho (ícone flutuante)
4. Na seção **"Cupom de Desconto"**:
   - Digite o código (ex: `DESC50REAIS`)
   - Clique em **"Aplicar"**
5. Veja o desconto refletido ✅
6. Envie o pedido com desconto incluído

---

## 📊 Exemplos de Cupons

| Código | Tipo | Valor | Uso | Descrição |
|--------|------|-------|-----|-----------|
| `DESC10` | % | 10 | 100 | 10% de desconto, máx 100 usos |
| `DESC50` | R$ | 50 | 50 | R$ 50 de desconto, máx 50 usos |
| `BEMVINDO5` | % | 5 | ∞ | 5% de desconto, sem limite |
| `PRIMEIRACOMPRA` | R$ | 30 | 1000 | R$ 30 de desconto primeira compra |
| `BLACKFRIDAY` | % | 30 | 500 | 30% Black Friday |

---

## 🎯 Casos de Uso

### Promoção Relâmpago
```
Código: TERACARAMELADA
Tipo: R$ Fixo
Valor: 15
Ativa por 1 hora para gerar urgência
```

### First Time Discount
```
Código: BEMVINDO20
Tipo: % Percentual
Valor: 20
Para novos clientes
```

### Fidelidade
```
Código: CLIENTE2024
Tipo: % Percentual
Valor: 10
Para clientes recorrentes
```

---

## 📈 Estatísticas

Depois que implementarmos histórico de pedidos, saberemos:
- Quantos cupons foram usados
- Quanto rendeu cada promoção
- Ticket médio com/sem desconto
- Taxa de conversão por cupom

---

## ⚙️ Configurações Avançadas

### Adicionar Limite de Uso (Supabase)

Se quiser limitar a quantidade de vezes que um cupom pode ser usado:

```sql
UPDATE cupons 
SET limite_uso = 50 
WHERE codigo = 'DESC50REAIS';
```

### Desativar Cupom Temporariamente

```sql
UPDATE cupons 
SET ativo = false 
WHERE codigo = 'DESC50REAIS';
```

### Ver Histórico de Cupons Usados

```sql
SELECT * FROM cupons 
ORDER BY data_criacao DESC;
```

---

## 🔍 Validações Automáticas

O sistema automaticamente:
- ❌ Rejeita cupom inativo
- ❌ Rejeita cupom inexistente
- ✅ Calcula desconto correto (percentual ou fixo)
- ✅ Não deixa desconto ser maior que o carrinho
- ✅ Mostra valor economizado
- ✅ Inclui na mensagem do WhatsApp

---

## 🚨 Troubleshooting

### Mensagem: "Cupom inválido ou expirado"
- ✅ Verifique se o código está **exatamente igual** (MAIÚSCULAS)
- ✅ Verifique se cupom está **ativo** no admin
- ✅ Verifique se cupom foi **criado** no banco

### Desconto não aparece no WhatsApp
- ✅ Recarregue a página
- ✅ Limpe o cache (Ctrl+Shift+Delete)
- ✅ Verifique se cupom foi aplicado (verde na tela)

### Erro "Erro ao validar cupom"
- ✅ Verifique conexão com internet
- ✅ Verifique se Supabase está online
- ✅ Recarregue a página

---

## 📊 Próximas Melhorias

- [ ] Tracking de quantas vezes cada cupom foi usado
- [ ] Histórico de cupons aplicados por cliente
- [ ] Relatório de ROI por cupom
- [ ] Cupons por categoria de produto
- [ ] Cupons com data de validade
- [ ] Cupons com valor mínimo de compra
- [ ] Integração com email/SMS (notificar cupom)

---

## 💬 Resumo

✅ **Sistema de Cupons** implementado com sucesso!

**Próximo passo:** Sistema de Avaliações de produtos

