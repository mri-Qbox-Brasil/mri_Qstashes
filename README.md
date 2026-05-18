# mri_Qstashes

Sistema avançado de baús (stashes) para servidores FiveM, totalmente gerenciável in-game por administradores, com permissões configuráveis, integração com ox_inventory, menus contextuais e suporte a múltiplos idiomas.

---

## 🚀 Funcionalidades Modernizadas

- **Persistência em Banco de Dados (MySQL):** Totalmente integrado ao `oxmysql`. Dados salvos de forma assíncrona, robusta e segura.
- **🔄 Migração de Dados Automática:** Possui sistema inteligente que detecta o arquivo `data.json` antigo, migra todos os baús automaticamente para o banco de dados e cria um backup de segurança (`data.json.bak`).
- **📋 Duplicação em Tempo Real:** Novo sistema de cópia/duplicação de baú in-game, copiando todas as permissões, itens de acesso, slots, peso e senha, restando apenas definir o novo nome e local (raycast).
- **📌 UX Aprimorada (Persistência de Estado):** Ao interagir, salvar, editar ou cancelar qualquer ação, o menu mantém o estado do menu anterior para um fluxo de trabalho contínuo e sem interrupções.
- **🔗 Webhook Inteligente (Sem Spam):** Otimizado para registrar apenas 1 único hook global no `ox_inventory`, evitando webhooks duplicados e melhorando a performance do servidor.
- **Criação, edição, teleporte e exclusão de baús** diretamente pelo jogo, via menu administrativo.
- **Permissões de administração** configuráveis via ace ou grupos customizados.
- **Proteção total**: apenas administradores podem acessar e executar ações administrativas com validações restritas no server-side.
- **Menu intuitivo**: todos os baús listados, com busca por texto integrada e submenu completo de edição rápida por baú.
- **Configuração fácil** de slots, peso, senha, job, gang, rank, item necessário, citizenID, label e webhook.
- **Integração com ox_inventory** e ox_target para interação 3D.
- **Logs via webhook** detalhados em embed rico com movimentações nos baús (Depósitos/Retiradas).

---

## 📦 Dependências

- [oxmysql](https://github.com/overextended/oxmysql)
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [qbx_core](https://github.com/qbcore-framework/qb-core) (ou similar)

---

## 💾 Instalação

1. Baixe e coloque a pasta `mri_Qstashes` em `resources/[mri]`.
2. O banco de dados será criado e estruturado **automaticamente** ao iniciar o servidor. Caso deseje executar manualmente, o arquivo `mri_qstashes.sql` está disponível na raiz do recurso.
3. Adicione no seu `server.cfg`:
   ```
   ensure mri_Qstashes
   ```
4. Dê permissão ace para os administradores no seu `server.cfg`:
   ```
   add_ace group.admin admin allow
   ```
   Ou ajuste conforme sua configuração de permissões em `shared/Config.lua`.

---

## ⚙️ Configuração

Arquivo: `shared/Config.lua`
```lua
Config = {}
Config.Command = "bau" -- Comando para abrir o menu admin
Config.Defaultslot = 50 -- Slots padrão do baú
Config.Defaultweight = 1000 -- Peso padrão (em kg)
Config.DefaultMessage = "Abrir baú" -- Mensagem padrão do alvo
Config.Debug = false -- Ativa debug
Config.AdminPerms = { "group.admin", "admin" } -- Permissões ace para admin (pode adicionar mais, ex: {"admin", "god"})
```

---

## 🎮 Como usar

- **Abertura do menu admin:**  
  Use o comando configurado (`/bau` por padrão) no chat. Apenas administradores podem abrir.
- **No menu:**  
  - "Criar novo baú": permite criar um novo baú no local desejado (usando raycast).
  - "Buscar baú...": permite filtrar baús por nome, job, gangue ou citizenID.
  - Clique em qualquer baú listado para abrir o submenu:
    - **✏️ Editar:** altera todas as configurações do baú.
    - **📍 Mover Localização:** altera a localização do baú usando o raycast.
    - **📋 Duplicar Baú:** clona o baú, permitindo escolher um novo nome e local mantendo as permissões.
    - **🚀 Teleportar:** leva seu personagem até o baú.
    - **🗑️ Excluir:** remove o baú de forma definitiva com popup de confirmação.
- **Acesso ao baú:**  
  Os jogadores interagem normalmente via ox_target, respeitando as restrições de job, gang, item, senha, etc.

---

## 🔒 Segurança

- Todas as ações administrativas são protegidas tanto no client quanto no server.
- Validação server-side estrita contra injeção de eventos (`isAdmin`).
- Apenas quem possui permissão definida em `Config.AdminPerms` pode executar qualquer ação no script.

---

## 👥 Créditos e Contribuições

- **Desenvolvedor Original:** [Murai Dev](https://github.com/mri-Qbox-Brasil)
- **Modernização e Otimização:** **SnowDeve** (Conversão para MySQL, migração segura, duplicação in-game, persistência de estado nas telas do menu, e correção de duplicidade de webhooks).
- **Referências de base:**
  - [wNpcCreator](https://github.com/WhereiamL/wNpcCreator/) (sistema de menus)
  - [md-stashes](https://github.com/Mustachedom/md-stashes) (base estrutural)
  - [ox_doors](https://github.com/overextended/ox_doors/) (raycast system)

---

# English Version

# mri_Qstashes

Advanced stash system for FiveM servers, fully manageable in-game by administrators, with configurable permissions, ox_inventory integration, contextual menus and multi-language support.

---

## 🚀 Modernized Features

- **Database Persistence (MySQL):** Fully integrated with `oxmysql` for secure and async operations.
- **🔄 Auto Data Migration:** Automatically detects legacy `data.json` files, migrates stashes to your SQL database, and generates a security backup (`data.json.bak`).
- **📋 Real-time Duplication:** In-game cloning of stashes with all configurations preserved (permissions, slots, weight, password). You only need to choose a new name and location!
- **📌 Enhanced UX (State Persistence):** Navigating through actions always returns the user to the previous menu context, ensuring a smooth workflow.
- **🔗 Smart Webhook (Zero Spam):** Registers only 1 global listener in `ox_inventory`, preventing duplicate discord webhook logs and boosting server performance.
- **In-game Management:** Create, edit, teleport, and delete stashes in real-time.
- **Comprehensive Permissions:** Configurable via ace groups or custom admin settings.
- **Rich Embed Logs:** Detailed logs of deposits and withdrawals sent directly to your Discord webhook.

---

## 📦 Dependencies

- [oxmysql](https://github.com/overextended/oxmysql)
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [qbx_core](https://github.com/qbcore-framework/qb-core) (or similar)

---

## 👥 Credits and Contributions

- **Original Developer:** [Murai Dev](https://github.com/mri-Qbox-Brasil)
- **Modernization & Optimization:** **SnowDeve** (MySQL conversion, auto-migration, in-game cloning, UI persistent states, and webhook deduplication).
