-- ⭐ Criar tabela de AVALIAÇÕES no Supabase
-- Execute este script no Supabase SQL Editor

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

-- Criar índices para performance
CREATE INDEX idx_avaliacoes_produto ON avaliacoes(produto_id);
CREATE INDEX idx_avaliacoes_classificacao ON avaliacoes(classificacao);
CREATE INDEX idx_avaliacoes_aprovada ON avaliacoes(aprovada);

-- ✅ Pronto! Agora a tabela está criada e pronta para uso.
