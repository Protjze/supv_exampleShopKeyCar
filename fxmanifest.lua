fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

author 'SUP2Ak'
version '1.0'

description 'Un exemple'

shared_scripts {'@es_extended/imports.lua', '@supv_core/import.lua', 'config.lua'}

--[[ Your libs RageUI v2.1.7 or v2
client_scripts {
	"src/RMenu.lua",
	"src/m/RageUI.lua",
	"src/m/Menu.lua",
	"src/m/MenuController.lua",
	"src/c/*.lua",
	"src/m/elements/*.lua",
	"src/m/items/*.lua",
	"src/m/panels/*.lua",
	"src/m/windows/*.lua",
}
--]]


client_script 'client.lua'
server_scripts {'@oxmysql/lib/MySQL.lua', 'server.lua'}
