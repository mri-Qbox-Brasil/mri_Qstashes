<<<<<<< fork
# mri_Qstashes
||||||| base
<h1>md-stashes</h1>
<div align="center">
  <a href="https://discord.gg/sAMzrB4DDx">
    <img align="center" src="https://cdn.discordapp.com/attachments/1164709522691076120/1185676859363557457/Discord_logo.svg.png?ex=65907aa0&is=657e05a0&hm=dd2a8924c3a3d84507747ab2bac036e5fc219c697e084c9aa13ba468ff725bde&" width="100">
  </a><br>
  <a href="https://discord.gg/sAMzrB4DDx">Mustache Scripts Discord</a><br>
</div>
=======
#  md-stashes 
  ### An easy way to place stashes throughout your server

## Discord
<div align="center">
  <a href="https://discord.gg/sAMzrB4DDx">
    <img src="https://i.imgur.com/t65G9Z0.png" width="200" alt="Mustache Scripts Logo">
  </a>
  <br>
  <a href="https://discord.gg/sAMzrB4DDx"><strong>Join Mustache Scripts Discord</strong></a>
</div>
>>>>>>> upstream

<<<<<<< fork
Sistema avançado de baús (stashes) para servidores FiveM, totalmente gerenciável in-game por administradores, com permissões configuráveis, integração com ox_inventory, menus contextuais e suporte a múltiplos idiomas.
||||||| base
<h1>Credits</h1>
=======
## 📦 Dependencies

| Dependency | Link |
|----------|------|
| `ps_lib` | [GitHub - Project-Sloth/ps_lib](https://github.com/Project-Sloth/ps_lib) |
| `Read`   | [Read Docs](https://letters.hookedonphonics.com/us/read-guaranteed-G14.html) |

> ⚠️ Ensure all dependencies are installed, up to date, and ensure **BEFORE** this script, before proceeding.

<h1>Credits</h1>
>>>>>>> upstream

<<<<<<< fork
---
||||||| base
- Big Credit to [Bostra](https://discord.gg/5ncbwMNq). if you have been around you may have seen him post some free scripts and help people, There was definetly times I dm'd him saying what the fuck am I doing and he helped keep me sane as well as making the raycast thing.
=======
- [MadCap](https://discord.gg/dTNWpmPGyc) for redesigning the Ui! it looks beautiful so please check out his [store](https://madcap-scripts.tebex.io/) and his [FREE STUFF](https://github.com/ThatMadCap)
>>>>>>> upstream

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

   ensure mri_Qstashes

3. Dê permissão ace para os administradores no seu `server.cfg`:

   add_ace group.admin admin allow

   Ou ajuste conforme sua configuração de permissões.

---

## Configuração

Arquivo: `shared/Config.lua`
lua
Config = {}
Config.Command = "bau" -- Comando para abrir o menu admin
Config.Defaultslot = 50 -- Slots padrão do baú
Config.Defaultweight = 1000 -- Peso padrão (em kg)
Config.DefaultMessage = "Abrir baú" -- Mensagem padrão do alvo
Config.Debug = false -- Ativa debug
Config.AdminPerms = { "admin" } -- Permissões ace para admin (pode adicionar mais, ex: {"admin", "god"})


---

## Como usar

<<<<<<< fork
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
||||||| base
- **STEP 1**
Drag Resource into your script folder
=======
### STEP 1
- `Run SQL`
    - if you dont know how, click this image below
    - [![YouTube Video](https://img.youtube.com/vi/8QpFOluK_xo/hqdefault.jpg)](https://www.youtube.com/watch?v=8QpFOluK_xo)
>>>>>>> upstream

<<<<<<< fork
---
||||||| base
- **STEP 2** 
fill out your config
=======
### STEP 2
  
- Fill out your config
>>>>>>> upstream

<<<<<<< fork
## Localização
||||||| base
<h1>How It Works</h1>
You can either 
=======
### STEP 3 (optional)
- Install backpack items in your framework/inventory
- backpacks will need to be purchased through the ped OR use admin command `giveBag playerID itemName`
>>>>>>> upstream

- Arquivos de idioma em `locales/en.json` e `locales/pt-br.json`.
- Adapte conforme necessário para seu servidor.

# How It Works

<<<<<<< fork
---
||||||| base
A) type out manually where you want the stashes 
=======
- use command newStash and fill in the things you want
- use command editStash to edit the required data to open stashes
>>>>>>> upstream

## Segurança

- Todas as ações administrativas são protegidas tanto no client quanto no server.
- Apenas quem possui permissão definida em `Config.AdminPerms` pode criar, editar ou excluir baús.

# Common Questions

<<<<<<< fork
---

## Créditos

- [wNpcCreator](https://github.com/WhereiamL/wNpcCreator/) (menu system)
- [md-stashes](https://github.com/Mustachedom/md-stashes) (base)
- [ox_doors](https://github.com/overextended/ox_doors/) (raycast system)

---

# English Version

# mri_Qstashes

Advanced stash system for FiveM servers, fully manageable in-game by administrators, with configurable permissions, ox_inventory integration, contextual menus and multi-language support.

---

## Features

- **Create, edit, teleport and delete stashes** directly in-game via the admin menu.
- **Configurable admin permissions** via ace or custom groups.
- **Full protection**: only admins can access and perform administrative actions.
- **Intuitive menu**: all stashes listed, with a submenu for each action (edit, teleport, delete, move).
- **Easy configuration** of slots, weight, password, job, gang, rank, required item, citizenID, label and webhook.
- **Integration with ox_inventory** and ox_target for 3D interaction.
- **Webhook logs** for stash item movements.
- **Multi-language support** (en, pt-br).

---

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [qbx_core](https://github.com/qbcore-framework/qb-core) (or similar)

---

## Installation

1. Download and place the `mri_Qstashes` folder in `resources/[mri]`.
2. Add to your `server.cfg`:
   ```
   ensure mri_Qstashes
   ```
3. Give ace permission to admins in your `server.cfg`:
   ```
   add_ace group.admin admin allow
   ```
   Or adjust according to your permission system.

---

## Configuration

File: `shared/Config.lua`
```lua
Config = {}
Config.Command = "bau" -- Command to open the admin menu
Config.Defaultslot = 50 -- Default stash slots
Config.Defaultweight = 1000 -- Default weight (in kg)
Config.DefaultMessage = "Open stash" -- Default target message
Config.Debug = false -- Enable debug
Config.AdminPerms = { "admin" } -- Ace permissions for admin (can add more, e.g.: {"admin", "god"})
```

---

## How to use

- **Open admin menu:**  
  Use the configured command (`/bau` by default) in chat. Only admins can open.
- **In the menu:**  
  - "Create new stash": allows you to create a new stash at the desired location (using raycast).
  - Click any listed stash to open the submenu:
    - **Edit:** change all stash settings.
    - **Move:** change the stash location.
    - **Teleport:** teleport your character to the stash.
    - **Delete:** remove the stash from the server.
- **Accessing the stash:**  
  Players interact normally via ox_target, respecting job, gang, item, password, etc. restrictions.

---

## Localization

- Language files in `locales/en.json` and `locales/pt-br.json`.
- Adapt as needed for your server.

---

## Security

- All admin actions are protected both on client and server.
- Only those with permission defined in `Config.AdminPerms` can create, edit or delete stashes.

---

## Credits

- [wNpcCreator](https://github.com/WhereiamL/wNpcCreator/) (menu system)
- [md-stashes](https://github.com/Mustachedom/md-stashes) (base)
- [ox_doors](https://github.com/overextended/ox_doors/) (raycast system)
||||||| base
=======
- ###     the items wont get out of the inventory and into my pockets
  - #### `not my scripts problem. This is merely a way to **open** stashes. thats it. once you open the stash my script stops.`
- ###    weapons lose durability when i put them in the stash
  - #### `again, not my script.`
>>>>>>> upstream
