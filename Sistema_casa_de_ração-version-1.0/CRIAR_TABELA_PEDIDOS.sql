-- 📋 Criar tabela de PEDIDOS no Supabase
-- Execute este script no Supabase SQL Editor

CREATE TABLE pedidos (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  numero_pedido VARCHAR(20) NOT NULL UNIQUE,
  cliente_nome VARCHAR(100) NOT NULL,
  cliente_email VARCHAR(100),
  cliente_telefone VARCHAR(20),
  endereco_rua VARCHAR(200) NOT NULL,
  endereco_numero VARCHAR(10) NOT NULL,
  endereco_bairro VARCHAR(100) NOT NULL,
  itens JSON NOT NULL, -- Array com {nome, quantidade, preco}
  subtotal DECIMAL(10, 2) NOT NULL,
  cupom_codigo VARCHAR(50),
  desconto_cupom DECIMAL(10, 2) DEFAULT 0,
  valor_total DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'pendente', -- pendente, confirmado, em_entrega, entregue, cancelado
  data_pedido TIMESTAMP NOT NULL DEFAULT NOW(),
  data_atualizacao TIMESTAMP NOT NULL DEFAULT NOW(),
  notas TEXT
);

-- Criar índices para performance
CREATE INDEX idx_pedidos_cliente_email ON pedidos(cliente_email);
CREATE INDEX idx_pedidos_status ON pedidos(status);
CREATE INDEX idx_pedidos_data ON pedidos(data_pedido);
CREATE INDEX idx_pedidos_numero ON pedidos(numero_pedido);

-- ✅ Pronto! Agora a tabela está criada e pronta para uso.
