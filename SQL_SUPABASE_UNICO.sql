-- =========================================================
-- PETSHOP EXPRESS - SQL ÚNICO PARA SUPABASE
-- Cria todas as tabelas essenciais do projeto e alguns dados iniciais.
-- Cole este conteúdo no SQL Editor do Supabase e execute.
-- =========================================================

-- 1) Tabela de configurações da loja
CREATE TABLE IF NOT EXISTS configuracoes (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  hero_imagem_url TEXT,
  hero_produto_nome TEXT,
  hero_produto_preco NUMERIC(10,2),
  banner_titulo TEXT,
  banner_subtitulo TEXT,
  pix_chave TEXT,
  pix_beneficiario VARCHAR(120),
  pix_cidade VARCHAR(80),
  pix_instrucoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE configuracoes
  ADD COLUMN IF NOT EXISTS hero_produto_nome TEXT,
  ADD COLUMN IF NOT EXISTS hero_produto_preco NUMERIC(10,2),
  ADD COLUMN IF NOT EXISTS pix_chave TEXT,
  ADD COLUMN IF NOT EXISTS pix_beneficiario VARCHAR(120),
  ADD COLUMN IF NOT EXISTS pix_cidade VARCHAR(80),
  ADD COLUMN IF NOT EXISTS pix_instrucoes TEXT;

-- Garantir a linha principal de configuração (id 1)
INSERT INTO configuracoes (id, hero_imagem_url, banner_titulo, banner_subtitulo, pix_chave, pix_beneficiario, pix_cidade, pix_instrucoes)
OVERRIDING SYSTEM VALUE
VALUES (
  1,
  'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?q=80&w=1200&auto=format&fit=crop',
  'Oferta Relâmpago',
  'Frete grátis em pedidos acima de R$ 199,90',
  '',
  '',
  'Mongaguá - SP',
  'Pagamento via PIX. Envie o comprovante pelo WhatsApp.'
)
ON CONFLICT DO NOTHING;

-- Como id=1 foi inserido explicitamente, sincronizar a identidade para evitar
-- que a próxima inserção automática tente reutilizar um identificador existente.
SELECT setval(
  pg_get_serial_sequence('configuracoes', 'id'),
  (SELECT COALESCE(MAX(id), 1) FROM configuracoes),
  TRUE
);

-- 2) Categorias
CREATE TABLE IF NOT EXISTS categorias (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  titulo VARCHAR(120) NOT NULL,
  slug VARCHAR(120) NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3) Produtos
CREATE TABLE IF NOT EXISTS produtos (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  sku VARCHAR(80),
  nome VARCHAR(200) NOT NULL,
  descricao TEXT,
  preco NUMERIC(10,2) NOT NULL CHECK (preco >= 0),
  categoria VARCHAR(120) NOT NULL,
  tag_texto VARCHAR(80),
  tag_cor VARCHAR(40) DEFAULT 'amber-600',
  imagem_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE produtos ADD COLUMN IF NOT EXISTS sku VARCHAR(80);
UPDATE produtos SET sku = 'PET-' || id::TEXT WHERE sku IS NULL OR BTRIM(sku) = '';
CREATE UNIQUE INDEX IF NOT EXISTS idx_produtos_sku ON produtos(sku);

-- 4) Cupons
CREATE TABLE IF NOT EXISTS cupons (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  codigo VARCHAR(50) NOT NULL UNIQUE,
  tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('percentual', 'fixo')),
  valor NUMERIC(10,2) NOT NULL CHECK (valor > 0),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  usos INTEGER NOT NULL DEFAULT 0,
  limite_uso INTEGER,
  data_criacao TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  data_atualizacao TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 5) Avaliações
CREATE TABLE IF NOT EXISTS avaliacoes (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  produto_id BIGINT NOT NULL REFERENCES produtos(id) ON DELETE CASCADE,
  cliente_nome VARCHAR(100) NOT NULL,
  cliente_email VARCHAR(100),
  classificacao SMALLINT NOT NULL CHECK (classificacao >= 1 AND classificacao <= 5),
  comentario TEXT,
  data_criacao TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  aprovada BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 6) Pedidos
CREATE TABLE IF NOT EXISTS pedidos (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  numero_pedido VARCHAR(20) NOT NULL UNIQUE,
  cliente_nome VARCHAR(100) NOT NULL,
  cliente_email VARCHAR(100),
  cliente_telefone VARCHAR(20),
  endereco_rua VARCHAR(200) NOT NULL,
  endereco_numero VARCHAR(20) NOT NULL,
  endereco_bairro VARCHAR(100) NOT NULL,
  itens JSONB NOT NULL,
  subtotal NUMERIC(10,2) NOT NULL,
  cupom_codigo VARCHAR(50),
  desconto_cupom NUMERIC(10,2) DEFAULT 0,
  valor_total NUMERIC(10,2) NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'pendente',
  forma_pagamento VARCHAR(30) NOT NULL DEFAULT 'whatsapp',
  status_pagamento VARCHAR(30) NOT NULL DEFAULT 'pendente',
  id_cobranca VARCHAR(120),
  pix_copia_cola TEXT,
  pix_qr_code TEXT,
  data_expiracao_pix TIMESTAMPTZ,
  data_pagamento TIMESTAMPTZ,
  data_pedido TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  data_atualizacao TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  notas TEXT
);

ALTER TABLE pedidos
  ADD COLUMN IF NOT EXISTS forma_pagamento VARCHAR(30) NOT NULL DEFAULT 'whatsapp',
  ADD COLUMN IF NOT EXISTS status_pagamento VARCHAR(30) NOT NULL DEFAULT 'pendente',
  ADD COLUMN IF NOT EXISTS id_cobranca VARCHAR(120),
  ADD COLUMN IF NOT EXISTS pix_copia_cola TEXT,
  ADD COLUMN IF NOT EXISTS pix_qr_code TEXT,
  ADD COLUMN IF NOT EXISTS data_expiracao_pix TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS data_pagamento TIMESTAMPTZ;

-- 7) Índices
CREATE INDEX IF NOT EXISTS idx_categorias_slug ON categorias(slug);
CREATE INDEX IF NOT EXISTS idx_produtos_categoria ON produtos(categoria);
CREATE INDEX IF NOT EXISTS idx_produtos_preco ON produtos(preco);
CREATE INDEX IF NOT EXISTS idx_cupons_codigo ON cupons(codigo);
CREATE INDEX IF NOT EXISTS idx_cupons_ativo ON cupons(ativo);
CREATE INDEX IF NOT EXISTS idx_avaliacoes_produto ON avaliacoes(produto_id);
CREATE INDEX IF NOT EXISTS idx_avaliacoes_aprovada ON avaliacoes(aprovada);
CREATE INDEX IF NOT EXISTS idx_pedidos_status ON pedidos(status);
CREATE INDEX IF NOT EXISTS idx_pedidos_data ON pedidos(data_pedido);
CREATE INDEX IF NOT EXISTS idx_pedidos_numero ON pedidos(numero_pedido);

-- 8) Trigger para atualizar updated_at
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_configuracoes_updated ON configuracoes;
CREATE TRIGGER trg_configuracoes_updated
BEFORE UPDATE ON configuracoes
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_categorias_updated ON categorias;
CREATE TRIGGER trg_categorias_updated
BEFORE UPDATE ON categorias
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_produtos_updated ON produtos;
CREATE TRIGGER trg_produtos_updated
BEFORE UPDATE ON produtos
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_avaliacoes_updated ON avaliacoes;
CREATE TRIGGER trg_avaliacoes_updated
BEFORE UPDATE ON avaliacoes
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_pedidos_updated ON pedidos;
CREATE TRIGGER trg_pedidos_updated
BEFORE UPDATE ON pedidos
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Atualiza data_atualizacao do cupom em alteracao
CREATE OR REPLACE FUNCTION set_cupom_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.data_atualizacao = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_cupons_updated ON cupons;
CREATE TRIGGER trg_cupons_updated
BEFORE UPDATE ON cupons
FOR EACH ROW EXECUTE FUNCTION set_cupom_updated_at();

-- 9) Dados iniciais
INSERT INTO categorias (titulo, slug)
VALUES
  ('Rações', 'racoes'),
  ('Medicamentos', 'medicamentos'),
  ('Brinquedos', 'brinquedos'),
  ('Acessórios', 'acessorios')
ON CONFLICT (slug) DO NOTHING;

INSERT INTO produtos (id, sku, nome, descricao, preco, categoria, tag_texto, tag_cor, imagem_url)
OVERRIDING SYSTEM VALUE
VALUES
  (1, 'RACAO-DEMO-001', 'Ração Premium para Cães Adultos', 'Formulação completa para cães adultos, com proteína e nutrientes essenciais.', 89.90, 'racoes', 'Destaque', 'amber-600', 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?q=80&w=1200&auto=format&fit=crop'),
  (2, 'RACAO-DEMO-002', 'Ração Premium para Gatos', 'Sabor carne e nutrientes para saúde do pelo e digestão.', 94.90, 'racoes', 'Popular', 'rose-500', 'https://images.unsplash.com/photo-1517849845537-4d257902454a?q=80&w=1200&auto=format&fit=crop'),
  (3, 'MED-DEMO-001', 'Vermífugo Pet Plus', 'Controle de vermes para cães e gatos com segurança.', 49.90, 'medicamentos', 'Saúde', 'emerald-500', 'https://images.unsplash.com/photo-1537151625747-768eb6cf92b9?q=80&w=1200&auto=format&fit=crop'),
  (4, 'BRINQ-DEMO-001', 'Osso de Borracha', 'Brinquedo resistente para mastigação e diversão.', 39.90, 'brinquedos', 'Novo', 'blue-500', 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?q=80&w=1200&auto=format&fit=crop')
ON CONFLICT DO NOTHING;

SELECT setval(
  pg_get_serial_sequence('produtos', 'id'),
  (SELECT COALESCE(MAX(id), 1) FROM produtos),
  TRUE
);

INSERT INTO cupons (codigo, tipo, valor, ativo, limite_uso)
VALUES
  ('DESCONTO10', 'percentual', 10, TRUE, 100),
  ('DESC50', 'fixo', 50, TRUE, 50),
  ('BEMVINDO5', 'percentual', 5, TRUE, 1000)
ON CONFLICT (codigo) DO NOTHING;

-- 10) RLS (Row Level Security)
ALTER TABLE configuracoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE categorias ENABLE ROW LEVEL SECURITY;
ALTER TABLE produtos ENABLE ROW LEVEL SECURITY;
ALTER TABLE cupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE avaliacoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE pedidos ENABLE ROW LEVEL SECURITY;

-- Política pública para leitura dos dados visíveis na loja
DROP POLICY IF EXISTS "public_read_configuracoes" ON configuracoes;
CREATE POLICY "public_read_configuracoes" ON configuracoes FOR SELECT USING (true);

DROP POLICY IF EXISTS "public_read_categorias" ON categorias;
CREATE POLICY "public_read_categorias" ON categorias FOR SELECT USING (true);

DROP POLICY IF EXISTS "public_read_produtos" ON produtos;
CREATE POLICY "public_read_produtos" ON produtos FOR SELECT USING (true);

DROP POLICY IF EXISTS "public_read_cupons" ON cupons;
CREATE POLICY "public_read_cupons" ON cupons FOR SELECT USING (ativo = TRUE);

-- Política de administração para autenticação
DROP POLICY IF EXISTS "admin_manage_configuracoes" ON configuracoes;
CREATE POLICY "admin_manage_configuracoes" ON configuracoes FOR ALL
USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "admin_manage_categorias" ON categorias;
CREATE POLICY "admin_manage_categorias" ON categorias FOR ALL
USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "admin_manage_produtos" ON produtos;
CREATE POLICY "admin_manage_produtos" ON produtos FOR ALL
USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "admin_manage_cupons" ON cupons;
CREATE POLICY "admin_manage_cupons" ON cupons FOR ALL
USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "admin_manage_avaliacoes" ON avaliacoes;
CREATE POLICY "admin_manage_avaliacoes" ON avaliacoes FOR ALL
USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "admin_manage_pedidos" ON pedidos;
CREATE POLICY "admin_manage_pedidos" ON pedidos FOR ALL
USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

-- Inserções públicas (cliente)
DROP POLICY IF EXISTS "public_insert_avaliacoes" ON avaliacoes;
CREATE POLICY "public_insert_avaliacoes" ON avaliacoes
FOR INSERT WITH CHECK (
  cliente_nome IS NOT NULL AND char_length(trim(cliente_nome)) > 0 AND
  classificacao BETWEEN 1 AND 5
);

DROP POLICY IF EXISTS "public_insert_pedidos" ON pedidos;
CREATE POLICY "public_insert_pedidos" ON pedidos
FOR INSERT WITH CHECK (
  cliente_nome IS NOT NULL AND char_length(trim(cliente_nome)) > 0 AND
  endereco_rua IS NOT NULL AND endereco_numero IS NOT NULL AND endereco_bairro IS NOT NULL AND
  itens IS NOT NULL AND valor_total >= 0
);

-- Permitir leitura dos pedidos/avaliações para usuários autenticados do admin
DROP POLICY IF EXISTS "authenticated_read_avaliacoes" ON avaliacoes;
CREATE POLICY "authenticated_read_avaliacoes" ON avaliacoes FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "authenticated_read_pedidos" ON pedidos;
CREATE POLICY "authenticated_read_pedidos" ON pedidos FOR SELECT USING (auth.role() = 'authenticated');

-- 11) Storage para imagens de produtos e banner
-- O painel converte as imagens para WebP e usa o bucket produtos-imagens.
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'produtos-imagens',
  'produtos-imagens',
  TRUE,
  5242880,
  ARRAY['image/webp']
)
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

DROP POLICY IF EXISTS "public_read_produtos_imagens" ON storage.objects;
CREATE POLICY "public_read_produtos_imagens" ON storage.objects
FOR SELECT USING (bucket_id = 'produtos-imagens');

DROP POLICY IF EXISTS "authenticated_upload_produtos_imagens" ON storage.objects;
CREATE POLICY "authenticated_upload_produtos_imagens" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'produtos-imagens' AND auth.role() = 'authenticated'
);

DROP POLICY IF EXISTS "authenticated_update_produtos_imagens" ON storage.objects;
CREATE POLICY "authenticated_update_produtos_imagens" ON storage.objects
FOR UPDATE USING (
  bucket_id = 'produtos-imagens' AND auth.role() = 'authenticated'
)
WITH CHECK (
  bucket_id = 'produtos-imagens' AND auth.role() = 'authenticated'
);

DROP POLICY IF EXISTS "authenticated_delete_produtos_imagens" ON storage.objects;
CREATE POLICY "authenticated_delete_produtos_imagens" ON storage.objects
FOR DELETE USING (
  bucket_id = 'produtos-imagens' AND auth.role() = 'authenticated'
);

-- Observação importante:
-- Se você quiser limitar a criação de pedidos apenas pelo cliente anon, mantenha as políticas acima.
-- Se o projeto for usado totalmente em ambiente autenticado, você pode ajustar depois.

-- Fim do script
SELECT 'Banco do PetShop Express configurado com sucesso.' AS status;
