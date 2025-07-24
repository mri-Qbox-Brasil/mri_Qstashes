# mri_Qstashes

Sistema avançado de baús (stashes) para servidores FiveM, totalmente gerenciável in-game por administradores, com permissões configuráveis, integração com ox_inventory, menus contextuais e suporte a múltiplos idiomas.

---

## Funcionalidades

- **Criação, edição, teleporte e exclusão de baús** diretamente pelo jogo, via menu administrativo.
- **Permissões de administração** configuráveis via ace ou grupos customizados.
- **Proteção total**: apenas administradores podem acessar e executar ações administrativas.
- **Menu intuitivo**: todos os baús listados, com submenu para cada ação (editar, teleportar, excluir).
- **Configuração fácil** de slots, peso, senha, job, gang, rank, item necessário, citizenID, label e webhook.
- **Integração com ox_inventory** e ox_target para interação 3D.
- **Logs via webhook** para movimentações nos baús.
- **Suporte a múltiplos idiomas** (en, pt-br).

---

## Dependências

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [qbx_core](https://github.com/qbcore-framework/qb-core) (ou similar)

---

## Instalação

1. Baixe e coloque a pasta `mri_Qstashes` em `resources/[mri]`.
2. Adicione no seu `server.cfg`:
   ```
   ensure mri_Qstashes
   ```
3. Dê permissão ace para os administradores no seu `server.cfg`:
   ```
   add_ace group.admin admin allow
   ```
   Ou ajuste conforme sua configuração de permissões.

---

## Configuração

Arquivo: `shared/Config.lua`
```lua
Config = {}
Config.Command = "bau" -- Comando para abrir o menu admin
Config.Defaultslot = 50 -- Slots padrão do baú
Config.Defaultweight = 1000 -- Peso padrão (em kg)
Config.DefaultMessage = "Abrir baú" -- Mensagem padrão do alvo
Config.Debug = false -- Ativa debug
Config.AdminPerms = { "admin" } -- Permissões ace para admin (pode adicionar mais, ex: {"admin", "god"})
```

---

## Como usar

- **Abertura do menu admin:**  
  Use o comando configurado (`/bau` por padrão) no chat. Apenas administradores podem abrir.
- **No menu:**  
  - "Criar novo baú": permite criar um novo baú no local desejado (usando raycast).
  - Clique em qualquer baú listado para abrir o submenu:
    - **Editar:** altera todas as configurações do baú.
    - **Teleportar:** leva seu personagem até o baú.
    - **Excluir:** remove o baú do servidor.
- **Acesso ao baú:**  
  Os jogadores interagem normalmente via ox_target, respeitando as restrições de job, gang, item, senha, etc.

---

## Localização

- Arquivos de idioma em `locales/en.json` e `locales/pt-br.json`.
- Adapte conforme necessário para seu servidor.

---

## Segurança

- Todas as ações administrativas são protegidas tanto no client quanto no server.
- Apenas quem possui permissão definida em `Config.AdminPerms` pode criar, editar ou excluir baús.

---

## Créditos

- [wNpcCreator](https://github.com/WhereiamL/wNpcCreator/) (menu system)
- [md-stashes](https://github.com/Mustachedom/md-stashes) (base)
- [ox_doors](https://github.com/overextended/ox_doors/) (raycast system)
