# 📋 Sistema de Histórico de Pedidos - PetShop Express

## ✅ O que foi implementado

Sistema completo de pedidos com:
- ✅ Pedidos salvos automaticamente no banco
- ✅ Estatísticas em tempo real (faturamento, ticket médio, etc)
- ✅ Admin pode mudar status do pedido
- ✅ Status: pendente, confirmado, em entrega, entregue, cancelado
- ✅ Histórico com data e detalhes
- ✅ Números únicos para cada pedido

---

## 🚀 Setup - Criar Tabela no Banco

### 1️⃣ Acessar Supabase

1. Vá para [https://supabase.com](https://supabase.com)
2. Acesse seu projeto
3. Vá para **SQL Editor** (lado esquerdo)

### 2️⃣ Executar Script SQL

1. Clique em **"New query"**
2. Copie o conteúdo do arquivo `CRIAR_TABELA_PEDIDOS.sql`
3. Cole no editor
4. Clique em **"Run"** (ou Ctrl+Enter)

```sql
CREATE TABLE pedidos (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  numero_pedido VARCHAR(20) NOT NULL UNIQUE,
  cliente_nome VARCHAR(100) NOT NULL,
  cliente_email VARCHAR(100),
  cliente_telefone VARCHAR(20),
  endereco_rua VARCHAR(200) NOT NULL,
  endereco_numero VARCHAR(10) NOT NULL,
  endereco_bairro VARCHAR(100) NOT NULL,
  itens JSON NOT NULL,
  subtotal DECIMAL(10, 2) NOT NULL,
  cupom_codigo VARCHAR(50),
  desconto_cupom DECIMAL(10, 2) DEFAULT 0,
  valor_total DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'pendente',
  data_pedido TIMESTAMP NOT NULL DEFAULT NOW(),
  data_atualizacao TIMESTAMP NOT NULL DEFAULT NOW(),
  notas TEXT
);

-- Índices para performance
CREATE INDEX idx_pedidos_cliente_email ON pedidos(cliente_email);
CREATE INDEX idx_pedidos_status ON pedidos(status);
CREATE INDEX idx_pedidos_data ON pedidos(data_pedido);
CREATE INDEX idx_pedidos_numero ON pedidos(numero_pedido);
```

✅ Se ver mensagem verde "Success", está feito!

---

## 💡 Como Funciona

### Para CLIENTES

1. Abra `index.html`
2. Adicione produtos e preencha dados de entrega
3. Clique em **"Enviar Pedido"**
4. Pedido é **salvo automaticamente** no banco
5. Mensagem é enviada ao WhatsApp com número do pedido
6. Cliente recebe confirmação e número do pedido

**Informações salvas:**
- Nome, email, endereço completo
- Itens e quantidades
- Preço total (com desconto se houver)
- Cupom aplicado (se houver)
- Hora do pedido

### Para ADMIN (no painel)

1. Abra `admin.html`
2. Vá até **"Pedidos"** (novo menu)
3. Veja dashboard com:
   - **Pedidos Pendentes** - aguardando confirmação
   - **Total de Pedidos** - histórico completo
   - **Faturamento Total** - tudo que foi vendido
   - **Ticket Médio** - valor médio por pedido
4. Clique no dropdown **"Mudar Status"** para atualizar
5. Opções de status:
   - **Confirmar** - cliente pagou
   - **Em Entrega** - saiu para entregar
   - **Entregue** - completado
   - **Cancelar** - cliente cancelou

---

## 📊 Fluxo de Status do Pedido

```
Pendente (recém-criado)
    ↓
Confirmado (cliente pagou)
    ↓
Em Entrega (sai do estoque)
    ↓
Entregue (chegou ao cliente) ✓
    
Cancelado (a qualquer momento) ✗
```

---

## 📈 Dashboard - Indicadores

### Pedidos Pendentes (🟠)
- Quantos pedidos ainda não foram confirmados
- **Ação:** Confirmar assim que receber pagamento

### Total de Pedidos (🔵)
- Quantidade total de pedidos histórico
- Crescimento da loja

### Faturamento Total (🟢)
- Soma de TODOS os pedidos
- Receita bruta

### Ticket Médio (⚪)
- Valor médio por pedido
- Indicador de valor de compra

**Exemplo de Dashboard:**
```
Pedidos Pendentes: 5
Total de Pedidos: 47
Faturamento Total: R$ 2.345,67
Ticket Médio: R$ 49,91
```

---

## 🔍 Informações Salvas por Pedido

| Campo | Tipo | Exemplo |
|-------|------|---------|
| número_pedido | Texto | PED-1727689456123 |
| cliente_nome | Texto | João Silva |
| cliente_email | Email | joao@email.com |
| endereco_rua | Texto | Rua das Flores |
| endereco_numero | Número | 42 |
| endereco_bairro | Texto | Centro |
| itens | JSON | [{nome: "Ração", qtd: 2, preco: 45}] |
| subtotal | Moeda | R$ 90,00 |
| cupom_codigo | Texto | DESC10 |
| desconto_cupom | Moeda | R$ 9,00 |
| valor_total | Moeda | R$ 81,00 |
| status | Status | pendente |
| data_pedido | Data/Hora | 2024-10-30 14:30:45 |

---

## 🚨 Troubleshooting

### Mensagem: "Pedido criado mas não foi salvo"
- ✅ Pedido foi criado mesmo assim, confira no admin
- ✅ Tente novamente em alguns minutos
- ✅ Verifique tabela de pedidos no Supabase

### Não consigo ver os pedidos no admin
- ✅ Refresque a página (F5)
- ✅ Verifique se está logado
- ✅ Verifique se tabela foi criada no Supabase

### Botão "Mudar Status" não funciona
- ✅ Refresque a página
- ✅ Teste com status diferente
- ✅ Confira se Supabase está online

---

## 🎯 Casos de Uso

### Gerenciar Entrega
- Cliente faz pedido (Status: Pendente)
- Você confirma pagamento (Status: Confirmado)
- Entregador sai com produto (Status: Em Entrega)
- Entrega é feita (Status: Entregue)

### Cancelamentos
- Cliente desiste (Status: Cancelado)
- Produto fora de estoque (Status: Cancelado)
- Você nega o pedido (Status: Cancelado)

### Acompanhamento
- Cliente quer saber se chegou
- Você verifica status no admin
- "Seu pedido está em entrega!"

### Análise de Vendas
- Faturamento total
- Ticket médio
- Produtos mais vendidos
- Horários de pico

---

## 📊 Próximas Melhorias

- [ ] Cliente visualizar status do pedido (sem login)
- [ ] Enviar notificação quando status mudar
- [ ] Email/SMS com atualizações
- [ ] Filtrar pedidos por status/data/cliente
- [ ] Exporte de relatório (CSV/PDF)
- [ ] Gráficos de vendas por dia/semana/mês
- [ ] Buscar pedido pelo número
- [ ] Adicionar notas internas ao pedido
- [ ] Integração com transportadora
- [ ] Cupom de compra próxima compra após entrega

---

## 💬 Automações Possíveis

Quando implementarmos mais:
- SMS: "Pedido confirmado! Chegará em 2-3 dias"
- Email: "Recebemos seu pedido #PED-xxx"
- WhatsApp Bot: "Status do seu pedido é: Em Entrega"
- Avaliação: "Como foi sua compra? Deixe uma avaliação!"

---

## 📊 Resumo

✅ **Sistema de Histórico de Pedidos** implementado com sucesso!

**Próximo passo:** Quick Wins (Notificações & Pequenas Melhorias)

