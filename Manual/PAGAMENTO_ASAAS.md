# Pagamento PIX com Asaas

## 1. Aplicar a migracao

Execute no SQL Editor do Supabase:

`Sistema_casa_de_ração-version-1.0/MIGRACAO_PAGAMENTOS.sql`

## 2. Configurar os secrets

Na raiz do projeto Supabase, cadastre:

```text
ASAAS_API_KEY=chave_da_api
ASAAS_API_URL=https://sandbox.asaas.com/api/v3
ASAAS_WEBHOOK_TOKEN=token_criado_no_asaas
```

A chave nunca deve ser colocada em `config.js`, `index.html` ou outro arquivo publico.

## 3. Publicar as funcoes

Com o Supabase CLI conectado ao projeto:

```text
supabase functions deploy criar-cobranca-pix
supabase functions deploy webhook-asaas --no-verify-jwt
```

## 4. Configurar o webhook no Asaas

Use a URL abaixo no painel do Asaas:

```text
https://SEU-PROJETO.supabase.co/functions/v1/webhook-asaas
```

Envie os eventos de pagamento. A funcao trata confirmacao, recebimento, vencimento, exclusao e estorno.

## 5. Teste recomendado

1. Use primeiro a API Sandbox do Asaas.
2. Execute uma compra com PIX.
3. Confirme se o pedido foi salvo como `aguardando` em `status_pagamento`.
4. Simule o pagamento no Sandbox.
5. Confirme se o webhook alterou `status_pagamento` para `pago` e `status` para `confirmado`.
6. Troque `ASAAS_API_URL` e a chave somente depois do teste aprovado.