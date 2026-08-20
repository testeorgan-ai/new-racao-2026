# ⭐ Sistema de Avaliações - PetShop Express

## ✅ O que foi implementado

Sistema completo de avaliações com:
- ✅ Clientes podem avaliar produtos com 1-5 estrelas
- ✅ Comentários opcionais
- ✅ Admin aprova/rejeita avaliações
- ✅ Estatísticas (média, pendentes, aprovadas)
- ✅ Botão de avaliação no cartão de produto
- ✅ Modal elegante para avaliar

---

## 🚀 Setup - Criar Tabela no Banco

### 1️⃣ Acessar Supabase

1. Vá para [https://supabase.com](https://supabase.com)
2. Acesse seu projeto
3. Vá para **SQL Editor** (lado esquerdo)

### 2️⃣ Executar Script SQL

1. Clique em **"New query"**
2. Copie o conteúdo do arquivo `CRIAR_TABELA_AVALIACOES.sql`
3. Cole no editor
4. Clique em **"Run"** (ou Ctrl+Enter)

```sql
CREATE TABLE avaliacoes (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  produto_id BIGINT NOT NULL REFERENCES produtos(id) ON DELETE CASCADE,
  cliente_nome VARCHAR(100) NOT NULL,
  cliente_email VARCHAR(100),
  classificacao SMALLINT NOT NULL CHECK (classificacao >= 1 AND classificacao <= 5),
  comentario TEXT,
  data_criacao TIMESTAMP NOT NULL DEFAULT NOW(),
  aprovada BOOLEAN NOT NULL DEFAULT false
);

-- Índices para performance
CREATE INDEX idx_avaliacoes_produto ON avaliacoes(produto_id);
CREATE INDEX idx_avaliacoes_classificacao ON avaliacoes(classificacao);
CREATE INDEX idx_avaliacoes_aprovada ON avaliacoes(aprovada);
```

✅ Se ver mensagem verde "Success", está feito!

---

## 💡 Como Usar

### Para CLIENTES (na vitrine)

1. Abra `index.html`
2. Nos cartões de produtos, veja o botão **⭐** (Avaliar)
3. Clique para abrir o modal de avaliação
4. Selecione de 1 a 5 estrelas
5. Digite seu nome (obrigatório)
6. Adicione email (opcional)
7. Deixe comentário (opcional)
8. Clique em **"Enviar Avaliação"**
9. Admin revisará e publicará em breve

**Exemplos:**
- ⭐ = Péssimo
- ⭐⭐ = Ruim
- ⭐⭐⭐ = Bom
- ⭐⭐⭐⭐ = Muito Bom
- ⭐⭐⭐⭐⭐ = Excelente

### Para ADMIN (no painel)

1. Abra `admin.html`
2. Vá até **"Avaliações"** (novo menu)
3. Veja:
   - **Avaliações Pendentes** - aguardando aprovação
   - **Avaliações Aprovadas** - já publicadas
   - **Média de Estrelas** - classificação geral
4. Revise cada avaliação
5. Clique em **✅ Aprovar** para publicar
6. Clique em **🗑️ Excluir** para rejeitar

---

## 📊 Exemplos de Avaliações

| Cliente | Produto | Classificação | Status | Ação |
|---------|---------|--|--------|------|
| João Silva | Ração Premium 25kg | ⭐⭐⭐⭐⭐ | ✅ Aprovada | Excluir |
| Maria Santos | Coleira Vermelha | ⭐⭐⭐⭐ | ⏳ Pendente | Aprovar / Excluir |
| Pedro Costa | Brinquedo Bolinha | ⭐⭐⭐ | ✅ Aprovada | Excluir |

---

## 🎯 Casos de Uso

### Aumentar Confiança
- Novos clientes veem reviews de outros
- "Este produto tem 4.8 ⭐ de 250 avaliações"
- Reduz insegurança na compra

### Feedback do Produto
- Saber qual ração os clientes gostam mais
- Identificar problemas com produtos
- Decisões de reposição baseadas em reviews

### Moderar Conteúdo
- Rejeitar críticas ofensivas
- Aceitar críticas construtivas
- Manter reputação limpa

### Marketing
- "Nossos clientes nos deram 4.7 ⭐"
- Usar reviews em campanha
- Social proof aumenta conversão

---

## ⚙️ Validações Automáticas

O sistema automaticamente:
- ✅ Obriga cliente a digitar nome
- ✅ Valida classificação (1-5 estrelas)
- ✅ Limita comentário a texto razoável
- ✅ Mostra estatísticas em tempo real
- ✅ Cria índices para busca rápida
- ✅ Impede avaliações duplicadas (manual)

---

## 📈 Estatísticas Disponíveis

**Dashboard de Avaliações mostra:**
- Total de avaliações pendentes
- Total de avaliações aprovadas
- Média de estrelas de TODOS os produtos
- Lista completa com filtros

---

## 🚨 Troubleshooting

### Mensagem: "Erro ao enviar avaliação"
- ✅ Preencha todos os campos obrigatórios
- ✅ Verifique conexão com internet
- ✅ Recarregue a página
- ✅ Tente novamente

### Avaliação não aparece no admin
- ✅ Verifique se está na aba "Avaliações"
- ✅ Refresque a página (F5)
- ✅ Verifique se tabela foi criada no Supabase

### Botão de avaliar não aparece
- ✅ Refresque a página
- ✅ Limpe cache (Ctrl+Shift+Delete)
- ✅ Verifique se config.js está carregando

---

## 🔍 Próximas Melhorias

- [ ] Mostrar avaliações aprovadas nos produtos
- [ ] Filtrar por classificação (mostrar só 5 ⭐)
- [ ] Ordenar por "mais úteis"
- [ ] Responder a avaliações (admin)
- [ ] Fotos nas avaliações
- [ ] Verificar compra antes de avaliar
- [ ] Email de confirmação
- [ ] Relatório de satisfação por categoria
- [ ] Gráficos de distribuição de estrelas

---

## 💬 Integração com Outros Sistemas

### Com Histórico de Pedidos (próximo):
- Mostrar apenas produtos que cliente comprou
- Marcar "Avaliação verificada"
- Evitar spam de avaliações

### Com Cupons:
- Cupom para clientes que avaliam
- "Avalie e ganhe 5% de desconto"

### Com Email:
- Notificar cliente quando avaliação for aprovada
- Pedir avaliação 7 dias após compra
- Resenhas periódicas

---

## 📊 Resumo

✅ **Sistema de Avaliações** implementado com sucesso!

**Próximo passo:** Histórico de Pedidos

