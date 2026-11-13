# Importar produtos por planilha

O painel permite baixar um modelo CSV, importar e validar produtos em lote e exportar o catálogo atual.

## Preparar o banco

Antes de importar em uma base que já existe, execute `../Sistema_casa_de_ração-version-1.0/MIGRACAO_IMPORTACAO_PRODUTOS.sql` no SQL Editor do Supabase. Esse script adiciona a coluna única `sku`. Produtos antigos recebem um SKU temporário no formato `PET-<id>`; você pode trocá-lo pelo código comercial da empresa na planilha.

Em uma instalação nova, o script principal `../SQL_SUPABASE_UNICO.sql` já inclui essa alteração.

## Preparar o CSV

1. No painel, abra **Produtos** e clique em **Baixar modelo CSV**.
2. Edite o arquivo no Excel ou Google Sheets e salve/exporte como CSV UTF-8.
3. Use uma linha por produto. As colunas são:

   `sku;nome;descricao;preco;categoria;imagem_url;tag_texto;tag_cor`

- `sku`, `nome`, `preco` e `categoria` são obrigatórios. O SKU deve ser único.
- `categoria` deve ser o slug cadastrado em **Categorias**, por exemplo `racoes`.
- `preco` aceita formatos como `89,90` ou `89.90`. Se o CSV usar vírgula como separador de colunas, deixe o preço entre aspas (por exemplo, `"89,90"`); o modelo usa ponto e vírgula para evitar essa ambiguidade.
- `imagem_url` pode ficar vazia; o card exibirá um aviso de imagem ausente. URLs preenchidas devem começar com `http://` ou `https://`.
- `tag_cor` aceita `amber-600`, `emerald-600`, `rose-600`, `indigo-600` ou `blue-500`.
- O importador detecta CSV separado por ponto e vírgula, vírgula ou tabulação; aceita campos entre aspas e vírgulas decimais.

## Importar e atualizar

1. Clique em **Importar planilha**, selecione o CSV e confira a prévia.
2. Corrija linhas com erros antes de continuar. O importador informa SKUs repetidos, categorias não encontradas, preços inválidos e URLs inválidas.
3. Escolha um modo:
   - **Ignorar existentes e importar somente novos**: não altera produtos já cadastrados.
   - **Atualizar produto existente pelo SKU**: cria SKUs novos e atualiza os produtos correspondentes. Os valores da planilha substituem os atuais, inclusive campos opcionais vazios.
4. Confirme a operação. O processamento ocorre em lotes de até 50 produtos; o painel informa sucesso e falhas.

Para atualizar um catálogo, use **Exportar produtos**, edite a planilha exportada e importe no modo de atualização. Não apague nem reutilize os SKUs entre produtos. O SKU temporário não altera o nome nem os demais dados dos produtos antigos.

O limite do arquivo é 2 MB e a prévia mostra até 100 linhas por vez, sem limitar a importação ao total exibido.
