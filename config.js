/**
 * 🔐 CONFIGURAÇÃO SEGURA DA LOJA
 * 
 * IMPORTANTE: Este arquivo é ignorado pelo Git (.gitignore)
 * Nunca compartilhe este arquivo com ninguém!
 */

const CONFIG = {
  // ⚠️ Supabase - Suas chaves de acesso
  SUPABASE_URL: 'https://ktyripfxszotlojjxnlm.supabase.co',
  SUPABASE_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt0eXJpcGZ4c3pvdGxvamp4bmxtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTQ0MzYzOTgsImV4cCI6MjExMDAxMjM5OH0.gK_CoHRgk7b-F04NzhNT1_7ZnBUxpkwLp4eblEAYVc8',
  
  // 📞 WhatsApp - Número para contato (apenas números)
  TELEFONE_WHATSAPP: '5513992074922',
  
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
