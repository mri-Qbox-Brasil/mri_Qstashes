<<<<<<< fork
fx_version 'cerulean'
games { 'gta5' }

author 'Murai Dev'
discord '.mur4i'
description 'In-game stashe creator for QBOX'
version '1.0.1'

ox_lib 'locale'

shared_scripts {
    '@ox_lib/init.lua',
	'@qbx_core/modules/lib.lua',
	'@qbx_core/modules/playerdata.lua',
	'shared/**.lua',
}

files {
	'locales/*.json'
}
||||||| base
name "mustache-stashes"
author "mustache_dom"
description "stashes by mustache dom"
fx_version "cerulean"
game "gta5"
version '2.1.0'
=======
name 'mustache-stashes'
author 'mustache_dom'
version '3.0.0'
description 'Stashes by mustache dom'
fx_version 'cerulean'
lua54 'yes'
use_experimental_fxv2_oal 'yes'
game 'gta5'

ui_page 'web/build/index.html' -- thanks @ThatMadCaptain for the help with this :)
>>>>>>> upstream

client_scripts {
	'client/**.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
  'server/**.lua',
}

files {
  'locales/*.lua',
  'web/build/index.html',
  'web/build/**/*'
}
