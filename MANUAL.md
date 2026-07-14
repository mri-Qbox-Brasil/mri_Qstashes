# mri_Qstashes — Manual

Criador de baús (stashes) do `ox_inventory` direto no jogo: um admin mira no lugar, preenche um formulário e o baú passa a existir para todos, com restrição por job, gangue, cargo, item, senha e log no Discord.

---

## Sumário

1. [Dependências](#dependências)
2. [Instalação](#instalação)
3. [Permissões (ACE)](#permissões-ace)
4. [Configuração](#configuração)
5. [Comandos](#comandos)
6. [Criando um baú](#criando-um-baú)
7. [Propriedades de um baú](#propriedades-de-um-baú)
8. [Restrições de acesso](#restrições-de-acesso)
9. [Gerenciando baús existentes](#gerenciando-baús-existentes)
10. [Persistência (`data.json`)](#persistência-datajson)
11. [Log no Discord](#log-no-discord)
12. [Limitações conhecidas](#limitações-conhecidas)
13. [Entrypoints para outros recursos](#entrypoints-para-outros-recursos)
14. [Localização](#localização)
15. [Estrutura de arquivos](#estrutura-de-arquivos)

---

## Dependências

| Recurso | Obrigatório | Observação |
|---|---|---|
| `qbx_core` | Sim | Usa `@qbx_core/modules/lib.lua` e `playerdata.lua`. As restrições leem `QBX.PlayerData` (job, gang, citizenid) e `QBX.HasItem` |
| `ox_lib` | Sim | Menus de contexto, diálogos, raycast, TextUI, notificações, callbacks, locale, `lib.addCommand` |
| `ox_inventory` | Sim | Registro dos baús (`RegisterStash`), abertura (`openInventory`) e hook de log (`registerHook`). Sem ele, o recurso avisa no console e não registra nada |
| `ox_target` | Sim | Todas as interações com o baú são box zones do `ox_target` |

Não usa banco de dados: os baús ficam em `data.json`, dentro da própria pasta do recurso.

---

## Instalação

1. Copie a pasta `mri_Qstashes` para `resources/`.
2. Adicione ao `server.cfg`, **depois** do `ox_inventory`:
   ```
   ensure mri_Qstashes
   ```
3. Libere a ACE de admin (ver [Permissões (ACE)](#permissões-ace)).
4. Entre no jogo e use `/bau` para criar o primeiro baú. O arquivo `data.json` já vem no repositório com uma lista vazia (`[]`) e é preenchido pelo próprio recurso.

Não há SQL para importar e não há conflito conhecido com outros recursos. Os IDs registrados no `ox_inventory` são prefixados com `mri_Qstashes`, então não colidem com stashes de outros scripts.

---

## Permissões (ACE)

O recurso tem **dois** gates, e os dois precisam estar liberados para o admin:

1. **O comando** é registrado com `lib.addCommand(..., restricted = 'group.admin')`. O `ox_lib` cria a ACE `command.bau` para o grupo `admin` automaticamente.
2. **As operações** (abrir o menu, criar, editar, mover, apagar) são verificadas no servidor com `IsPlayerAceAllowed` contra cada string de `Config.AdminPerms` — por padrão, a ACE `admin`.

No `server.cfg`:

```
add_ace group.admin admin allow
add_principal identifier.license:<licenca_do_admin> group.admin
```

Se preferir outra ACE, troque `Config.AdminPerms` (aceita várias, ex.: `{ "admin", "god" }`) — basta que **uma** delas seja permitida ao jogador.

---

## Configuração

Arquivo: `shared/Config.lua`. É curto de propósito — o resto da configuração é por baú, feita em jogo.

| Campo | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| `Config.Command` | string | Sim | Nome do comando que abre o menu de gerenciamento. Padrão: `bau` |
| `Config.Defaultslot` | number | Sim | Slots usados quando o campo é deixado em branco na criação. Padrão: `50` |
| `Config.Defaultweight` | number | Sim | Peso em **kg** usado quando o campo é deixado em branco na criação. Padrão: `1000`. Internamente é convertido para gramas (`× 1000`) antes de ir para o `ox_inventory` |
| `Config.DefaultMessage` | string | Sim | Texto do target quando o baú não define um próprio. Padrão: `Abrir baú` |
| `Config.Debug` | bool | Sim | Desenha as box zones dos baús para conferir posição e tamanho |
| `Config.AdminPerms` | array de string | Sim | ACEs que dão acesso de admin ao recurso. Basta uma delas. Padrão: `{ "admin" }` |

---

## Comandos

| Comando | Permissão | Descrição |
|---|---|---|
| `/bau` | `group.admin` + ACE de `Config.AdminPerms` | Abre o menu de gerenciamento: buscar, criar e editar baús. Nome configurável em `Config.Command` |

---

## Criando um baú

1. Rode `/bau` e escolha **Criar novo baú**.
2. O jogo entra em modo raycast: um marcador vermelho acompanha o ponto para onde você olha, e o TextUI mostra as coordenadas em tempo real.
   - **E** confirma a posição.
   - **Backspace** cancela.
3. Preencha o formulário (ver [Propriedades de um baú](#propriedades-de-um-baú)). Só o **nome** é obrigatório.
4. O baú é salvo no `data.json` e a box zone aparece imediatamente para **todos** os jogadores online — sem restart.

Um admin também pode criar um baú a partir do próprio menu de contexto, sem passar pelo comando: a opção "Criar novo baú" existe no topo do menu do `/bau`.

---

## Propriedades de um baú

Campos do formulário de criação e de edição, na ordem em que aparecem:

| Campo | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| Nome do Baú | texto | Sim | Nome exibido dentro do inventário. É o único campo obrigatório — sem ele, a criação é cancelada |
| Job | texto | Não | Nome do emprego que pode abrir o baú. Em branco = qualquer um |
| Gang | texto | Não | Nome da gangue que pode abrir o baú. Em branco = qualquer uma |
| Cargo | número | Não | Nível mínimo de cargo (grade) no job ou na gangue |
| Item | texto | Não | Item que o jogador precisa ter no inventário para abrir |
| Quantidade de Slots | número | Não | Slots do baú. Em branco usa `Config.Defaultslot` |
| Peso do baú | número (kg) | Não | Capacidade em kg. Em branco usa `Config.Defaultweight`. Convertido para gramas ao registrar |
| Senha | número | Não | Senha numérica pedida ao abrir. `0` ou em branco = sem senha |
| ID do Cidadão | texto | Não | Citizen ID autorizado. Ver [Limitações conhecidas](#limitações-conhecidas) |
| Descrição do Target | texto | Não | Texto da opção de target. Em branco usa `Config.DefaultMessage` |
| Discord Webhook | texto | Não | Webhook que recebe o log de itens depositados e retirados deste baú |

Cada baú recebe um `id` numérico aleatório (6 dígitos) na criação. O ID registrado no `ox_inventory` é `mri_Qstashes<id>`.

---

## Restrições de acesso

As restrições são acumulativas: um baú com `job = police` e `Cargo = 3` só abre para policiais de cargo 3 ou mais. Um baú sem nenhuma restrição preenchida abre para qualquer jogador.

| Restrição | Como é verificada |
|---|---|
| Job | `QBX.PlayerData.job.name` precisa bater com o job do baú |
| Cargo | `QBX.PlayerData.job.grade.level` (ou o grade da gangue) precisa ser **maior ou igual** ao cargo do baú |
| Gang | `QBX.PlayerData.gang.name` precisa bater com a gangue do baú |
| Item | `QBX.HasItem` — o jogador precisa ter o item no inventário. O item **não** é consumido |
| Senha | Diálogo pedido no momento de abrir. Senha errada simplesmente não abre o baú, sem mensagem de erro |

Job, gang, cargo e item são checados no `canInteract` do target: quando o jogador não tem acesso, a opção nem aparece. A senha é o único gate pedido depois da interação.

---

## Gerenciando baús existentes

Todo baú já criado aparece na lista do `/bau`, com um resumo (peso, slots, job, gangue, cargo, item, se tem senha). O menu de topo tem um campo de **busca** que filtra por nome, job, gang, citizenID, item, cargo ou peso.

Ao selecionar um baú, quatro ações:

| Ação | Descrição |
|---|---|
| Editar | Reabre o formulário com os valores atuais preenchidos. Campos deixados em branco mantêm o valor anterior |
| Mover | Entra no modo raycast de novo para escolher uma nova posição |
| Teleportar | Move o admin até o baú |
| Excluir | Apaga o baú, com confirmação |

Admins também podem editar um baú pelo target: ao mirar nele, além da opção de abrir, aparece uma opção **Editar (apenas admin)** que leva direto a esse mesmo submenu.

---

## Persistência (`data.json`)

Todos os baús vivem em `data.json`, na raiz do recurso, escrito com `SaveResourceFile` a cada alteração. Não há banco de dados. O **conteúdo** dos baús (os itens) é do `ox_inventory` e fica na tabela `ox_inventory` do banco dele — o `data.json` guarda só a definição.

Formato de uma entrada:

```json
{
  "id": 482913,
  "name": "Cofre da Polícia",
  "job": "police",
  "gang": "",
  "rank": "3",
  "item": "",
  "slotSize": 50,
  "weight": 1000000,
  "password": 0,
  "citizenID": "",
  "targetlabel": "Abrir Baú",
  "webhookURL": "",
  "loc": { "x": 441.2, "y": -974.5, "z": 30.7 }
}
```

O `weight` é gravado em **gramas** (o formulário pede kg e multiplica por 1000). Faça backup deste arquivo antes de mexer nele à mão; ele é reescrito inteiro a cada criação, edição ou exclusão.

---

## Log no Discord

O webhook é definido **por baú**, no campo "Discord Webhook" do formulário — não há webhook global. Baús sem webhook não geram log.

O recurso registra um hook `swapItems` no `ox_inventory` e envia um embed a cada item que entra ou sai do baú, contendo:

- Ação (item depositado ou retirado) e nome do baú
- Nome do jogador, menção do Discord e identifier
- Item, quantidade e metadata
- Coordenadas do jogador no momento
- ID no servidor e horário

URLs que não comecem com `http://` ou `https://` são ignoradas silenciosamente.

---

## Limitações conhecidas

- **A restrição por Citizen ID não é aplicada.** O campo é salvo em `data.json` como `citizenID` e aparece no resumo do menu admin, mas o `canInteract` do target compara contra uma chave `cid` que nunca é preenchida — o resultado é que a checagem sempre passa. Use job, gangue, item ou senha para restringir um baú a um grupo específico.
- **Senha errada não avisa nada.** O diálogo fecha e o baú não abre, sem notificação. É o comportamento atual do código.

---

## Entrypoints para outros recursos

O recurso não expõe exports. Os pontos de entrada são eventos de servidor (todos exigem ACE de admin, exceto o callback de leitura) e o callback de listagem.

### Listar todos os baús

```lua
local baus = lib.callback.await('stashesGetAll', false)
```

Callback de client. Retorna a tabela completa de baús, no mesmo formato do `data.json`.

### Criar um baú

```lua
TriggerServerEvent('insertStashesData', {
    'Cofre da Polícia', -- nome
    'police',           -- job
    '',                 -- gang
    '3',                -- cargo
    '',                 -- item
    50,                 -- slots
    1000000,            -- peso em gramas
    0,                  -- senha
    '',                 -- citizenID
    'Abrir Baú',        -- label do target
    ''                  -- webhook
}, vec3(441.2, -974.5, 30.7))
```

### Editar, mover e apagar

```lua
TriggerServerEvent('updateStashesData', id, input)     -- mesmo array de 11 posições do insert
TriggerServerEvent('updateStashLocation', id, vec3(x, y, z))
TriggerServerEvent('deleteStashesData', id)
```

O `id` é o número de 6 dígitos gerado na criação, visível no `data.json`. Qualquer uma dessas chamadas re-salva o arquivo e re-sincroniza as box zones de todos os clients.

### Abrir o menu admin em um jogador

```lua
TriggerClientEvent('mri_Qstashes:openAdm', source)
```

O client valida a ACE de admin antes de abrir e notifica "Acesso negado" caso contrário.

---

## Localização

As strings são traduzidas via `ox_lib` locale (`ox_lib 'locale'` no manifest). Os arquivos ficam em `locales/`:

- `en.json` — inglês
- `pt-br.json` — português do Brasil

O locale ativo é definido pela convar `ox:locale` no `server.cfg`:

```
setr ox:locale "pt-br"
```

Os títulos e campos dos embeds do Discord são fixos em português, no `server/server.lua`, e não passam pelo sistema de locale.

---

## Estrutura de arquivos

```
mri_Qstashes/
├── client/
│   └── client.lua      — menu admin (busca, criação, edição), raycast de posicionamento,
│                         box zones do ox_target e checagem de acesso (job, gang, cargo, item, senha)
├── server/
│   └── server.lua      — CRUD em data.json, registro dos baús no ox_inventory, gate de ACE,
│                         comando /bau e webhook do Discord via hook swapItems
├── shared/
│   └── Config.lua      — comando, padrões de slots/peso/label e ACEs de admin
├── locales/
│   ├── en.json
│   └── pt-br.json
├── data.json           — definição de todos os baús (fonte da verdade, reescrita pelo recurso)
└── fxmanifest.lua
```
