--[[
	Lua Editor 1.0
	Creado por NEKERAFA (nekerafa@gmail.com) el sáb 1 nov 2014 10:19:47 CET 
	Licenciado por Creative Commons Reconocimiento-CompartirIgual 4.0
	http://creativecommons.org/licenses/by-sa/4.0/

	# script.lua
	#
	# Lua Editor (Ledit) es una aplicación creada en ONELua con la que podrá editar archivos de textos y crear códigos desde tu propia PSP
	# Siéntase libre de ver y modificar el código fuente
]]

-- ## MENSAJE DE CARGA ##
screen.print(5, 5, 'Loading Ledit...'); screen.flip()

-- ## ARCHIVOS DE CONFIGURACIÓN ##
dofile('conf/ledit.lua')
dofile('lang/'..lang..'.lua')

-- ## BIBLIOTECAS DEL SISTEMA ##
dofile("lib/wavelib-1.0(onelua).lua")
dofile('lib/nkb-1.4(onelua).lua')
dofile("lib/utf8.lua")

-- ## ARCHIVOS DEL SISTEMA ##
dofile('res/dialog.lua')
dofile('res/editor.lua')
dofile('res/explorer.lua')
dofile('res/menu.lua')
dofile('res/spash.lua')
dofile('res/system.lua')
editor.load()
editor.load_nkb()

-- ## BUCLE PRINCIPAL ##
while true do
	-- Leo los controles y muestro el editor
	buttons.read()
	editor.main()
	screen.flip()

	if buttons.start then os.reset() end
	if buttons.select and not nkb.opened then menu.show = not menu.show end
end
