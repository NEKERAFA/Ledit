--[[
	Lua Editor 1.0
	Creado por NEKERAFA (nekerafa@gmail.com) el lun 03 nov 2014 11:39:21 CET 
	Licenciado por Creative Commons Reconocimiento-CompartirIgual 4.0
	http://creativecommons.org/licenses/by-sa/4.0/

	# system.lua
	# Funciones extra del sistema
]]

-- ## DEVUELVE EL TAMAÑO DE UN ARCHIVO EN FORMATO LEGIBLE ##
function files.sizehr(size)
	if not size then size = 0 end
	if size >= 0 and size <= 10^3 then return size..' B'
	elseif size > 10^3 and size <= 10^6 then size = string.match((size/10^3), '(%d+.%d%d)') return size..' kB'
	elseif size > 10^6 and size <= 10^9 then size = string.match((size/10^6), '(%d+.%d%d)') return size..' MB'
	elseif size > 10^9 then size = string.match((size/10^9), '(%d+.%d%d)') return size..' GB' end
end

-- ## CARGA UN ARCHIVO ##
function files.open(path)
	table.insert(editor.files, {name = files.nopath(path), path = path, text = {}, lang = (files.ext(path) or msg.lang_none), ln = 1, ch = 0, xmin = 0, lnmin = 1, modified = false})
	editor.files.opened = editor.files.opened+1
	tmp_file = io.open(path, 'r+')
	for tmp_line in tmp_file:lines() do
		if #tmp_line == 0 then tmp_line = '' end
		if tab_size == 2 then tmp_line = string.gsub(tmp_line, '\t', '  ')
		elseif tab_size == 3 then tmp_line = string.gsub(tmp_line, '\t', '   ')
		elseif tab_size == 4 then tmp_line = string.gsub(tmp_line, '\t', '    ')
		elseif tab_size == 5 then tmp_line = string.gsub(tmp_line, '\t', '     ')
		elseif tab_size == 6 then tmp_line = string.gsub(tmp_line, '\t', '      ')
		elseif tab_size == 7 then tmp_line = string.gsub(tmp_line, '\t', '       ')
		elseif tab_size == 8 then tmp_line = string.gsub(tmp_line, '\t', '        ') end
		table.insert(editor.files[editor.files.opened].text, tmp_line)
	end
	table.insert(editor.files[editor.files.opened].text, '')
	tmp_file:flush(); tmp_file:close()
	editor.files[editor.files.opened].lnmax = #editor.files[editor.files.opened].text
	editor.cfile = editor.files.opened
	close_dialog = true
end

-- ## GUARDAR UN ARCHIVO ##
function files.save(path, str_file)
	if files.exists(path) then
		option = os.message(msg.file_exist, 1)
		if option == 1 then
			tmp_file = io.open(path, "w+")
			tmp_file:write(str_file)
			tmp_file:flush(); tmp_file:close()
			editor.files[editor.cfile].modified = false
			close_dialog = true
		elseif option == 0 then
			n = 1
			while not files.exists(path.." ("..n..")") do n = n+1 end
			tmp_file = io.open(path.." ("..n..")", "w+")
			tmp_file:write(str_file)
			tmp_file:flush(); tmp_file:close()
			editor.files[editor.cfile].modified = false
			close_dialog = true
		end
	else
		tmp_file = io.open(path, "w+")
		tmp_file:write(str_file)
		tmp_file:flush(); tmp_file:close()
		editor.files[editor.cfile].modified = false
		close_dialog = true
	end
end

-- ## TABLA PRINCIPAL DE LOS AJUSTES ##
system = {
	pos = 1,
	bar_pos = 1
}

-- ## MUESTRA UNA CASILLA DE VERIFICACIÓN ##
function system.checkbox(x, y, value, mode)
	if mode then draw.rect(x, y, 12, 12, theme.menu_selection) else draw.rect(x, y, 12, 12, theme.line_color) end
	if value and theme.checkbox_gradient then draw.gradrect(x+1, y+1, 10, 10, theme.checkbox_on_top, theme.checkbox_on_bottom, 0)
	elseif not value and theme.checkbox_gradient then draw.gradrect(x+1, y+1, 10, 10, theme.checkbox_off_top, theme.checkbox_off_bottom, 0)
	elseif value and not theme.checkbox_gradient then draw.fillrect(x+1, y+1, 10, 10, theme.checkbox_on_color)
	else draw.fillrect(x+1, y+1, 10, 10, theme.checkbox_off_color) end
end

-- ## MUESTRA UNA ETIQUETA DE TEXTO ##
function system.label(x, y, w, value, mode, align)
	if mode then draw.rect(x, y, w, 16, theme.menu_selection) else draw.rect(x, y, w, 16, theme.line_color) end
	if theme.input_gradient then draw.gradrect(x+1, y+1, w-2, 14, theme.input_top, theme.input_bottom, 0)
	else draw.fillrect(x+1, y+1, w-2, 14, theme.input_color) end
	if not align or align == __ALEFT then screen.print(x+3, y+1, value, 0.5, theme.input_text)
	elseif align == __ACENTER then screen.print(x+(w/2), y+1, value, 0.5, theme.input_text, 0x01, __ACENTER)
	elseif align == __ARIGHT then screen.print(x+w-3, y+1, value, 0.5, theme.input_text, 0x01, __ARIGHT) end
end

-- ## MUESTRA LAS ETIQUETAS DE LAS OPCIONES DE AJUSTES ##
function system.show_settinglabels()
	screen.print(66, 70, msg.show_lines, 0.6, theme.normal_text)
	screen.print(66, 90, msg.show_current_line, 0.6, theme.normal_text)
	screen.print(66, 110, msg.indentation, 0.6, theme.normal_text)
	screen.print(66, 130, msg.language, 0.6, theme.normal_text)
	screen.print(66, 150, msg.theme, 0.6, theme.normal_text)
	screen.print(66, 170, msg.kb_theme, 0.6, theme.normal_text)
	screen.print(66, 190, msg.bg, 0.6, theme.normal_text)
	if bg_opacity then screen.print(66, 210, msg.bg_opacity, 0.6, theme.normal_text) else screen.print(66, 210, msg.bg_opacity, 0.6, theme.inactive_text) end
end

-- ## MUESTRA LOS OBJETOS DE LAS OPCIONES DE AJUSTES ##
function system.show_settingobjects()
	system.checkbox(400, 71, number_line, system.pos == 1)
	system.checkbox(400, 91, current_line, system.pos == 2)
	system.label(398, 109, 16, tab_size, system.pos == 3, __ARIGHT)
	system.label(339, 129, 75, system.lang[clang], system.pos == 4, __ARIGHT)
	system.label(339, 149, 75, system.theme[ctheme], system.pos == 5, __ARIGHT)
	system.label(339, 169, 75, system.nkb_theme[cnkb_theme], system.pos == 6, __ARIGHT)
	icon.explorer:blit(395, 189)
	if bg_opacity then system.label(380, 209, 34, bg_opacity..'%', system.pos == 8, __ARIGHT) end
end

-- ## CONTROLES DE AJUSTES #
function system.controls()
	-- Cambiar entre opciones
	if buttons.up and system.pos > 0 then system.pos = system.pos-1
	elseif buttons.down and bg_opacity and system.pos < 8 then system.pos = system.pos+1; system.bar_pos = 1
	elseif buttons.down and not bg_opacity and system.pos < 7 then system.pos = system.pos+1; system.bar_pos = 1 end
	-- Cambiar una opción
	if system.pos == 1 and (buttons.left or buttons.right) then number_line = not number_line
	elseif system.pos == 2 and (buttons.left or buttons.right) then current_line = not current_line
	elseif system.pos == 3 then
		if buttons.left and tab_size > 2 then tab_size = tab_size-1 elseif buttons.right and tab_size < 8 then tab_size = tab_size+1 end
	elseif system.pos == 4 then
		if buttons.left and clang > 1 then clang = clang-1 elseif buttons.right and clang < #system.lang then clang = clang+1 end
	elseif system.pos == 5 then
		if buttons.left and ctheme > 1 then ctheme = ctheme-1 elseif buttons.right and ctheme < #system.theme then ctheme = ctheme+1 end
	elseif system.pos == 6 then
		if buttons.left and cnkb_theme > 1 then cnkb_theme = cnkb_theme-1 elseif buttons.right and cnkb_theme < #system.nkb_theme then cnkb_theme = cnkb_theme+1 end
	elseif system.pos == 7 then
		if buttons.square then dialog.bg_open(); close_dialog = false elseif buttons.circle then bg_image = nil; bg_path_image = nil; bg_opacity = nil end
	elseif system.pos == 8 and bg_opacity then
		if buttons.left and bg_opacity > 0 then bg_opacity = bg_opacity-1 elseif buttons.right and bg_opacity < 100 then bg_opacity = bg_opacity+1 end
	end
end

-- ## IMPRIME UN MENSAJE DE ESPERA ##
function system.wait_message()
	draw.fillrect(0, 0, 480, 272, color.new(0, 0, 0, 128))
	screen.print(240, 130, msg.waiting, 1, color.new(255, 255, 255), 0x01, __ACENTER)
	screen.flip()
end
