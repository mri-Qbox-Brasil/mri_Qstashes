# MANUAL - mri_Qstashes

## O que o recurso faz
Criador de baús (stashes) in-game para QBOX, permitindo criar, gerenciar e proteger baús com sistemas avançados de permissão, senhas e restrições de acesso diretamente no jogo.

## Funcionalidades principais
- Criação de baús via raycast (mira do jogador) em tempo real
- Proteção por senha numérica
- Restrições de acesso por job, gangue, cargo e Citizen ID
- Requisito de itens específicos para abrir o baú
- Configuração de tamanho (slots) e peso por baú
- Sistema de busca administrativa para encontrar qualquer baú
- Teleporte/movimentação de baús
- Logs de inventário via webhook do Discord
- Suporte a múltiplos idiomas via ox_lib

## Como funciona (fluxo de trabalho)
1. Administradores abrem o menu de gerenciamento via comando `/bau`
2. Clicam em "Criar Baú" e usam raycast para posicionar o baú no local desejado
3. Preenchem as propriedades do baú (nome, restrições, senha, tamanho, etc.)
4. O baú é salvo em `data.json` e sincronizado com todos os jogadores
5. Jogadores interagem com o baú via target, validando restrições de acesso antes de abrir

## Opções de configuração disponíveis
Configurações em `shared/Config.lua`:
| Opção | Padrão | Descrição |
|-------|--------|-----------|
| `Config.Command` | `bau` | Comando de admin para abrir menu |
| `Config.Defaultslot` | 50 | Slots padrão para novos baús |
| `Config.Defaultweight` | 1000 | Peso padrão (gramas) para novos baús |
| `Config.DefaultMessage` | "Abrir baú" | Texto padrão do target |
| `Config.Debug` | false | Habilita mensagens de debug |
| `Config.AdminPerms` | ["admin"] | Permissões ACE para admin |

## Comandos disponíveis
| Comando | Descrição | Permissão |
|---------|-----------|-----------|
| `/bau` | Abre menu de gerenciamento de baús | Admin |

## Eventos que dispara/ouve
### Eventos Client
| Evento | Descrição |
|--------|-----------|
| `mri_Qstashes:openAdm` | Abre UI de gerenciamento admin |
| `mri_Qstashes:start` | Carrega baús do server |
| `mri_Qstashes:delete` | Remove targets dos baús |
| `mri_Qstashes:client:doray` | Inicia raycast para posicionar baú |

### Eventos Server
| Evento | Descrição |
|--------|-----------|
| `insertStashesData` | Cria novo baú |
| `deleteStashesData` | Remove baú |
| `updateStashesData` | Atualiza propriedades do baú |
| `updateStashLocation` | Move baú para nova localização |
| `mri_Qstashes:server:Load` | Carrega dados do baú para o jogador |
| `mri_Qstashes:server:Unload` | Descarrega dados do baú |

## Exports que fornece/consome
Nenhum export documentado (gerenciamento via eventos e `data.json`)

## Integração com outros recursos MRI Qbox
- `qbx_core`: Framework principal
- `ox_lib`: UI, callbacks e notificações
- `ox_inventory`: Sistema de inventário dos baús
- `ox_target`: Interação via target com os baús

## Casos de uso / exemplos práticos
- Criar baú da polícia restrito ao job "police" e cargo mínimo 2
- Configurar baú de gangue com senha numérica 1234
- Criar baú que exige o item "chave_bau" para abrir
- Admin buscar todos os baús de um jogador específico via menu de busca
- Configurar webhook do Discord para logar depósitos e retiradas do baú

## Dicas de solução de problemas
- Baú não aparece: Verifique se o `ox_target` e `ox_inventory` estão ativos
- Acesso negado: Confirme se o jogador atende a todas as restrições (job, cargo, item, senha)
- `data.json` corrompido: Faça backup do arquivo e delete para gerar um novo vazio
- Webhook não envia: Confirme se a URL do webhook está correta nas propriedades do baú
- Raycast não funciona: Verifique se o jogador está mirando em um local válido do mapa