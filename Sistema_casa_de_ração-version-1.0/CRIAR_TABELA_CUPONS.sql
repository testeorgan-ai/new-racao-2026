-- 🎁 Criar tabela de CUPONS no Supabase
-- Execute este script no Supabase SQL Editor

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

-- Criar índice para buscas mais rápidas
CREATE INDEX idx_cupons_codigo ON cupons(codigo);
CREATE INDEX idx_cupons_ativo ON cupons(ativo);

-- Exemplos de cupons para testar:
INSERT INTO cupons (codigo, tipo, valor, ativo, limite_uso) VALUES
  ('DESCONTO10', 'percentual', 10, true, 100),
  ('DESC50', 'fixo', 50, true, 50),
  ('BEMVINDO5', 'percentual', 5, true, 1000);

-- ✅ Pronto! Agora a tabela está criada e pronta para uso.
