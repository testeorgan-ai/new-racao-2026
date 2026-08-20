/**
 * 🔐 CONFIGURAÇÃO SEGURA DA LOJA
 * 
 * IMPORTANTE: Este arquivo é ignorado pelo Git (.gitignore)
 * Nunca compartilhe este arquivo com ninguém!
 */

const CONFIG = {
  // ⚠️ Supabase - Suas chaves de acesso
  SUPABASE_URL: 'https://svryftctnjyhpwanzcgk.supabase.co',
  SUPABASE_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN2cnlmdGN0bmp5aHB3YW56Y2drIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk1NDA2NTYsImV4cCI6MjA5NTExNjY1Nn0._ci2If9BfGy2lx8p5P1il2obQtHoSTdHGtZu5O8TthA',
  
  // 📞 WhatsApp - Número para contato (apenas números)
  TELEFONE_WHATSAPP: '5513999999999',
  
  // 🏪 Informações da Loja
  NOME_LOJA: 'PetShop Express',
  EMAIL_SUPORTE: 'suporte@petshop.com.br',
  HORARIO_ATENDIMENTO: 'Segunda à Sábado, 9h às 22h',
  
  // 📍 Localização
  CIDADE: 'Mongaguá',
  ESTADO: 'SP'
};

// Não remova esta linha - permite uso em scripts
if (typeof module !== 'undefined' && module.exports) {
  module.exports = CONFIG;
}
