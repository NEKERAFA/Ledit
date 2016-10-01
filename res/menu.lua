--[[
	Lua Editor 1.0
	Creado por NEKERAFA (nekerafa@gmail.com) el sáb 01 nov 2014 22:05:09 CET 
	Licenciado por Creative Commons Reconocimiento-CompartirIgual 4.0
	http://creativecommons.org/licenses/by-sa/4.0/

	# menu.lua
	# Funciones del menu de Ledit
]]

-- ## TABLA PRINCIPAL DEL MENÚ ##
menu = {
	show = false,
	pos = 1
}

-- ## CONTROLES DEL MENÚ ##
function menu.controls()
	if buttons.left and menu.pos > 1 then menu.pos = menu.pos-1
	elseif buttons.right and menu.pos < 6 then menu.pos = menu.pos+1 end
	-- Funciones
	if buttons.square then
		if menu.pos == 1 then
			table.insert(editor.files, {name = msg.unsaved, path = explorer.root, text = {''}, lang = msg.lang_none, ln = 1, ch = 0, xmin = 0, lnmin = 1, modified = false})
			editor.files.opened = editor.files.opened+1
			editor.cfile = editor.files.opened
		elseif menu.pos == 2 and editor.files.opened > 1 then
			table.remove(editor.files, editor.cfile)
			editor.files.opened = editor.files.opened-1
			editor.cfile = math.min(editor.cfile, editor.files.opened)
		elseif menu.pos == 3 then
			dialog.file_open()
		elseif menu.pos == 4 then
			dialog.file_save()
		elseif menu.pos == 5 then
			dialog.settings()
		elseif menu.pos == 6 then
		end
		menu.show = false
	end
end

-- ## CONTROLES DEL MENÚ DEL EXPLORADOR (ABRIR) ##
function menu.controls_open()
	if buttons.left and explorer.bar_pos > 1 then explorer.bar_pos = explorer.bar_pos-1
	elseif buttons.right and explorer.bar_pos < 2 then explorer.bar_pos = explorer.bar_pos+1 end
	-- Funciones
	if buttons.square then
		if explorer.bar_pos == 1 then close_dialog = true
		elseif explorer.bar_pos == 2 and explorer.path ~= explorer.root then
			explorer.path = files.nofile(explorer.path)
			explorer.list = files.list(explorer.path)
			explorer.lenlist = #explorer.list
		end
	end
end

-- ## CONTROLES DEL MENÚ DEL EXPLORADOR (GUARDAR) ##
function menu.controls_save()
	if buttons.left and explorer.bar_pos > 1 then explorer.bar_pos = explorer.bar_pos-1
	elseif buttons.right and explorer.bar_pos < 5 then explorer.bar_pos = explorer.bar_pos+1 end
	-- Funciones
	if buttons.square then
		if explorer.bar_pos == 1 then close_dialog = true
		elseif explorer.bar_pos == 2 then
			files.save(explorer.path..name_file, table.concat(editor.files[editor.cfile].text, '\n')); close_dialog = true
		elseif explorer.bar_pos == 3 and editor.files.opened > 1 then
			explorer.path = files.nofile(explorer.path)
			explorer.list = files.list(explorer.path)
			explorer.lenlist = #explorer.list
			explorer.pos = 1
		elseif explorer.bar_pos == 4 then
			table.insert(explorer.list, 1, {name = msg.folder, directory = true})
			creating_folder = true
			explorer.pos = 1
			nkb.opened = true
		end
	end
end

-- ## CONTROLES DEL MENÚ DE AJUESTES ##
function menu.controls_settings()
	if buttons.left and system.bar_pos > 1 then system.bar_pos = 1
	elseif buttons.right and system.pos < 2 then system.bar_pos = 2 end
	-- Funciones
	if buttons.square then
		if system.bar_pos == 1 then close_dialog = true
		-- Guardo la configuración
		elseif system.bar_pos == 2 then
			-- Mensaje de carga
			system.wait_message()
			conf = io.open('conf/ledit.lua', 'w+')
			conf:write('-- Lua Editor configuration\n'); conf:flush()
			conf:write('-- Not modified this file\n\n'); conf:flush()
			conf:write('number_line = '..tostring(number_line)..'\n'); conf:flush()
			conf:write('current_line = '..tostring(current_line)..'\n'); conf:flush()
			conf:write('tab_size = '..tostring(tab_size)..'\n'); conf:flush()
			conf:write('lang = \''..system.lang[clang]..'\'\n'); conf:flush()
			conf:write('ledit_theme = \''..system.theme[ctheme]..'\'\n'); conf:flush()
			conf:write('nkb_theme = \''..system.nkb_theme[cnkb_theme]..'\'\n'); conf:flush()
			if bg_path_image then
				conf:write('bg_path_image = \''..bg_path_image..'\'\n'); conf:flush()
				conf:write('bg_opacity = '..bg_opacity..'\n'); conf:flush()
			end
			conf:close()
			conf = nil
			-- Recargo ledit
			dofile('conf/ledit.lua')
			editor.load()
			editor.load_nkb()
			close_dialog = true
		end
	end
end

-- ## MUESTRA LOS ICONOS DEL MENÚ ##
function menu.show_icon()
	icon.open:blit(2, 24)
	if editor.files.opened == 1 then icon.close:blit(24, 24, 128) else icon.close:blit(24, 24) end
	icon.newfile:blit(46, 24)
	icon.save:blit(68, 24)
	icon.conf:blit(90, 24)
	icon.help:blit(112, 24)
end

-- ## MUESTRA LOS ICONOS DEL MENÚ DEL EXPLORADOR (ABRIR) ##
function menu.show_explorericon_open()
	icon.cancel:blit(2, 24)
	if explorer.path == explorer.root then icon.parentfolder:blit(24, 24, 128) else icon.parentfolder:blit(24, 24) end
end

-- ## MUESTRA LOS ICONOS DEL MENÚ DEL EXPLORADOR (GUARDAR) ##
function menu.show_explorericon_save()
	icon.cancel:blit(2, 24)
	icon.ok:blit(24, 24)
	if explorer.path == explorer.root then icon.parentfolder:blit(46, 24, 128) else icon.parentfolder:blit(46, 24) end
	icon.newfolder:blit(68, 24)
end

-- ## MUESTRA LOS ICONOS DEL MENÚ DE AJUSTES ##
function menu.show_settings()
	icon.cancel:blit(2, 24)
	icon.ok:blit(24, 24)
end

-- ## PIE DE PÁGINA DEL MENU
function menu.footer()
	if menu.pos == 1 then editor.show_footer(editor.fullname..' - '..msg.new)
	elseif menu.pos == 2 then editor.show_footer(editor.fullname..' - '..msg.close)
	elseif menu.pos == 3 then editor.show_footer(editor.fullname..' - '..msg.open)
	elseif menu.pos == 4 then editor.show_footer(editor.fullname..' - '..msg.save)
	elseif menu.pos == 5 then editor.show_footer(editor.fullname..' - '..msg.settings)
	elseif menu.pos == 6 then editor.show_footer(editor.fullname..' - '..msg.help) end
end

-- ## BARRA DEL MENÚ ##
function menu.bar()
	if theme.menu_gradient then draw.gradrect(0, 22, 480, 20, theme.menu_top, theme.menu_bottom, 0) else draw.fillrect(0, 22, 480, 20, theme.menu_color) end
	draw.fillrect(0+22*(menu.pos-1), 22, 20, 20, theme.menu_selection)
	menu.show_icon()
	menu.controls()
	menu.footer()
end

-- ## BARRA DEL EXPLORADOR ##
function menu.bar_explorer(mode)
	if theme.menu_gradient then draw.gradrect(0, 22, 480, 20, theme.menu_top, theme.menu_bottom, 0) else draw.fillrect(0, 22, 480, 20, theme.menu_color) end
	if explorer.pos == 0 and explorer.bar_pos < 5 then draw.fillrect(0+22*(explorer.bar_pos-1), 22, 20, 20, theme.menu_selection) end
	if mode == 0 then menu.show_explorericon_open(); if explorer.pos == 0 then menu.controls_open() end
	elseif mode == 1 then menu.show_explorericon_save(); if explorer.pos == 0 and not nkb.opened then menu.controls_save() end end
end

-- ## BARRA DEL MEÚ DE AJUSTES ##
function menu.bar_settings()
	if theme.menu_gradient then draw.gradrect(0, 22, 480, 20, theme.menu_top, theme.menu_bottom, 0) else draw.fillrect(0, 22, 480, 20, theme.menu_color) end
	if system.pos == 0 and system.bar_pos < 3 then draw.fillrect(0+22*(system.bar_pos-1), 22, 20, 20, theme.menu_selection); menu.controls_settings() end
	menu.show_settings()
end
