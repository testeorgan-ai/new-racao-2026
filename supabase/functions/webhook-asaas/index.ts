import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

Deno.serve(async request => {
  if (request.method !== 'POST') return new Response('Método não permitido', { status: 405 });

  const tokenEsperado = Deno.env.get('ASAAS_WEBHOOK_TOKEN');
  if (tokenEsperado && request.headers.get('asaas-access-token') !== tokenEsperado) {
    return new Response('Não autorizado', { status: 401 });
  }

  try {
    const evento = await request.json();
    const pagamento = evento.payment;
    if (!pagamento?.id) return new Response('Evento ignorado', { status: 200 });

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    );
    const pagamentosConfirmados = ['PAYMENT_CONFIRMED', 'PAYMENT_RECEIVED'];
    const pagamentosCancelados = ['PAYMENT_OVERDUE', 'PAYMENT_DELETED', 'PAYMENT_REFUNDED'];
    const atualizacao: Record<string, unknown> = {};

    if (pagamentosConfirmados.includes(evento.event)) {
      atualizacao.status_pagamento = 'pago';
      atualizacao.data_pagamento = new Date().toISOString();
      atualizacao.status = 'confirmado';
    } else if (pagamentosCancelados.includes(evento.event)) {
      atualizacao.status_pagamento = 'cancelado';
    } else {
      return new Response('Evento não utilizado', { status: 200 });
    }

    const { error } = await supabase.from('pedidos').update(atualizacao).eq('id_cobranca', pagamento.id);
    if (error) return new Response('Erro ao atualizar pedido', { status: 500 });
    return new Response('OK', { status: 200 });
  } catch (error) {
    console.error(error);
    return new Response('Payload inválido', { status: 400 });
  }
});