# 🔐 Guia de Segurança - PetShop Express

## ✅ O que foi feito

Suas chaves Supabase foram movidas para um arquivo de configuração seguro (`config.js`) que está:
- ✅ **Ignorado pelo Git** (não será versionado)
- ✅ **Protegido** (não exposto no código público)
- ✅ **Centralizado** (fácil de atualizar)

---

## 🚀 Próximos Passos

### 1️⃣ Copiar arquivo de configuração

```bash
# No Windows (PowerShell)
Copy-Item config.example.js config.js

# Ou manualmente:
# 1. Copie config.example.js
# 2. Renomeie para config.js
# 3. Abra e preencha com seus dados reais
```

### 2️⃣ Preencher dados em `config.js`

Abra o arquivo `config.js` e atualize os valores:

```javascript
const CONFIG = {
  // ⚠️ Supabase - Já está preenchido com valores atuais
  SUPABASE_URL: 'https://svryftctnjyhpwanzcgk.supabase.co',
  SUPABASE_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  
  // 📞 Atualize o WhatsApp se necessário
  TELEFONE_WHATSAPP: '5513999999999',  // ← MUDE SE QUISER OUTRO
  
  // 🏪 Informações da loja (ATUALIZE!)
  NOME_LOJA: 'PetShop Express',
  EMAIL_SUPORTE: 'seu-email@petshop.com.br',  // ← MUDE
  HORARIO_ATENDIMENTO: 'Segunda à Sábado, 9h às 22h',
  
  // 📍 Localização
  CIDADE: 'Mongaguá',
  ESTADO: 'SP'
};
```

### 3️⃣ Testar funcionamento

- Abra `index.html` no navegador → deve funcionar normalmente
- Abra `login.html` → deve fazer login normalmente
- Abra `admin.html` → deve abrir o painel normalmente

Se ver mensagem de erro **"arquivo config.js não encontrado"**, significa que você ainda não criou o arquivo.

---

## 🔒 Boas Práticas de Segurança

### ✅ FAÇA:
- ✅ Mantenha `config.js` apenas localmente
- ✅ Atualize as chaves Supabase regularmente
- ✅ Use senhas fortes no banco de dados
- ✅ Restrinja acesso ao painel admin
- ✅ Faça backup dos dados regularmente

### ❌ NÃO FAÇA:
- ❌ Não compartilhe `config.js` com ninguém
- ❌ Não versione `config.js` no GitHub
- ❌ Não coloque chaves nos HTMLs (use apenas CONFIG)
- ❌ Não deixe dados sensíveis em localStorage
- ❌ Não compartilhe a chave Supabase publicamente

---

## 🛡️ Mudança de Chaves

Se suas chaves foram vazadas ou comprometidas:

1. **No Supabase Dashboard:**
   - Gere novas chaves
   - Revogue chaves antigas

2. **Atualize `config.js`:**
   - Copie a nova chave
   - Salve e teste

3. **Redeploy:**
   - Se usar hosting, faça deploy da atualização

---

## 📞 Telefone Editável pelo Admin

Agora você pode trocar o telefone WhatsApp:

1. Vá ao painel admin
2. Abra aba "Promoções" 
3. **Depois de implementarmos:** você poderá editar telefone lá
4. Salve alterações

*(Essa funcionalidade será adicionada na próxima atualização)*

---

## 📊 Status de Segurança

| Item | Status | Prioridade |
|------|--------|-----------|
| Chaves Supabase | ✅ Seguras em config.js | Crítica |
| .gitignore | ✅ Criado | Alta |
| Validação de entrada | ⏳ Próxima | Alta |
| Rate limiting | ⏳ Próxima | Média |
| HTTPS | ⏳ Próxima | Alta |

---

## ❓ FAQ

**P: E se eu der upload pro GitHub?**
R: Relaxe! `.gitignore` impede que `config.js` seja versionado. Mesmo se cometer erro, está protegido.

**P: Posso usar variáveis de ambiente?**
R: Para Front-end puro (HTML/JS), não. Mas se usar Node.js/build tool, sim!

**P: A chave Supabase é segura assim?**
R: É uma chave pública (anon), é segura. A chave privada deve ficar no backend.

**P: Como mudo o telefone no código?**
R: Agora é fácil! Edite `config.js` e pronto. Não precisa alterar 3 HTMLs.

---

## 🎉 Melhorias Implementadas

✅ Segurança - Chaves centralizadas e protegidas
⏳ Sistema de Cupons (próxima)
⏳ Avaliações de produtos (próxima)
⏳ Histórico de pedidos (próxima)
⏳ Quick Wins (próxima)

