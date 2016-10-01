--[[
	Lua Editor 1.0
	Creado por NEKERAFA (nekerafa@gmail.com) el sáb 01 nov 2014 22:01:37 CET 
	Licenciado por Creative Commons Reconocimiento-CompartirIgual 4.0
	http://creativecommons.org/licenses/by-sa/4.0/

	# splash.lua
	# Splash de inicio de Ledit
]]

splash.wave = wave.new(8)

function splash.ledit()
	-- Splash de OneLua
	splash.show()

	-- Splash de Lua Script Editor
	for n = 255, 0, -8 do
		draw.gradrect(0, 0, 480, 272, color.new(0, 128, 255), color.new(192, 255, 255), 0)
		splash.wave:blit(color.new(255, 255, 255, 128), color.new(0,0,0,0))
		logo:blit(240, 136)
		screen.print(470, 10, editor.ver, 0.6, color.new(0, 0, 0), 0x01, __ARIGHT)
		icon.license:blit(10, 234)
		screen.print(470, 248, 'Created by NEKERAFA', 0.7, color.new(0, 0, 0), color.new(255, 255, 255, 128), __ARIGHT)
		draw.fillrect(0, 0, 480, 272, color.new(0, 0, 0, n))
		screen.flip()
	end
	local start_time = os.clock()
	while os.clock()-start_time < 2 do
		draw.gradrect(0, 0, 480, 272, color.new(0, 128, 255), color.new(192, 255, 255), 0)
		splash.wave:blit(color.new(255, 255, 255, 128), color.new(0,0,0,0))
		logo:blit(240, 136)
		screen.print(470, 10, editor.ver, 0.6, color.new(0, 0, 0), 0x01, __ARIGHT)
		icon.license:blit(10, 234)
		screen.print(470, 248, 'Created by NEKERAFA', 0.7, color.new(0, 0, 0), color.new(255, 255, 255, 128), __ARIGHT)
		screen.flip()
	end
	start_time = nil
	for n = 0, 255, 8 do
		draw.gradrect(0, 0, 480, 272, color.new(0, 128, 255), color.new(192, 255, 255), 0)
		splash.wave:blit(color.new(255, 255, 255, 128), color.new(0,0,0,0))
		logo:blit(240, 136)
		screen.print(470, 10, editor.ver, 0.6, color.new(0, 0, 0), 0x01, __ARIGHT)
		icon.license:blit(10, 234)
		screen.print(470, 248, 'Created by NEKERAFA', 0.7, color.new(0, 0, 0), color.new(255, 255, 255, 128), __ARIGHT)
		draw.fillrect(0, 0, 480, 272, color.new(0, 0, 0, n))
		screen.flip()
	end
end
