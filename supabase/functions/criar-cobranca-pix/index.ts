import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type'
};

const jsonResponse = (body: unknown, status = 200) => new Response(JSON.stringify(body), {
  status,
  headers: { ...corsHeaders, 'Content-Type': 'application/json' }
});

Deno.serve(async request => {
  if (request.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });

  try {
    const { pedidoId } = await request.json();
    if (!pedidoId) return jsonResponse({ error: 'pedidoId é obrigatório' }, 400);

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    );
    const asaasApiKey = Deno.env.get('ASAAS_API_KEY');
    const asaasApiUrl = Deno.env.get('ASAAS_API_URL') || 'https://sandbox.asaas.com/api/v3';
    if (!asaasApiKey) return jsonResponse({ error: 'ASAAS_API_KEY não configurada' }, 500);

    const { data: pedido, error: pedidoError } = await supabase
      .from('pedidos')
      .select('*')
      .eq('id', pedidoId)
      .single();
    if (pedidoError || !pedido) return jsonResponse({ error: 'Pedido não encontrado' }, 404);

    if (pedido.id_cobranca && pedido.pix_copia_cola) {
      return jsonResponse({
        invoiceUrl: pedido.notas?.match(/https?:\/\/\S+/)?.[0] || null,
        payload: pedido.pix_copia_cola,
        qrCode: pedido.pix_qr_code
      });
    }

    const headers = { access_token: asaasApiKey, 'Content-Type': 'application/json' };
    const customerResponse = await fetch(`${asaasApiUrl}/customers`, {
      method: 'POST',
      headers,
      body: JSON.stringify({ name: pedido.cliente_nome })
    });
    const customer = await customerResponse.json();
    if (!customerResponse.ok) return jsonResponse({ error: customer.errors || 'Erro ao criar cliente no Asaas' }, 502);

    const paymentResponse = await fetch(`${asaasApiUrl}/payments`, {
      method: 'POST',
      headers,
      body: JSON.stringify({
        customer: customer.id,
        billingType: 'PIX',
        value: Number(pedido.valor_total),
        dueDate: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString().slice(0, 10),
        description: `Pedido ${pedido.numero_pedido}`,
        externalReference: String(pedido.id)
      })
    });
    const payment = await paymentResponse.json();
    if (!paymentResponse.ok) return jsonResponse({ error: payment.errors || 'Erro ao criar cobrança PIX' }, 502);

    const pixResponse = await fetch(`${asaasApiUrl}/payments/${payment.id}/pixQrCode`, { headers });
    const pix = await pixResponse.json();
    if (!pixResponse.ok) return jsonResponse({ error: pix.errors || 'Erro ao gerar QR Code PIX' }, 502);

    await supabase.from('pedidos').update({
      id_cobranca: payment.id,
      pix_copia_cola: pix.payload,
      pix_qr_code: pix.encodedImage,
      data_expiracao_pix: pix.expirationDate,
      status_pagamento: 'aguardando'
    }).eq('id', pedido.id);

    return jsonResponse({
      invoiceUrl: payment.invoiceUrl,
      payload: pix.payload,
      qrCode: pix.encodedImage,
      expirationDate: pix.expirationDate
    });
  } catch (error) {
    console.error(error);
    return jsonResponse({ error: 'Erro interno ao criar cobrança PIX' }, 500);
  }
});