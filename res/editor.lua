--[[
	Lua Editor 1.0
	Creado por NEKERAFA (nekerafa@gmail.com) el sáb 1 nov 2014 10:28:23 CET 
	Licenciado por Creative Commons Reconocimiento-CompartirIgual 4.0
	http://creativecommons.org/licenses/by-sa/4.0/

	# editor.lua
	# Funciones del editor de Ledit
]]

-- ## TABLA PRINCIPAL DEL EDITOR ##
editor = {
	-- Titulo de la ventana
	head = 'Lua Editor',
	-- Nombre completo
	fullname = 'Lua Editor 1.0',
	-- Version del programa
	version = '1.0',
	cfile = 1,
	point = timer.new()
}

-- ## TABLA CON LA INFORMACIÓN DE CADA ARCHIVO ##
editor.files = {
	{name = msg.unsaved, path = 'ms0:/', text = {''}, lang = msg.lang_none, ln = 1, ch = 0, xmin = 0, lnmin = 1, modified = false },
	opened = 1
}

-- ## CARGA EL TECLADO NKEYBOARD ##
function editor.load_nkb()
	-- Archivo de configuración
	dofile('theme/nkb-'..nkb_theme..'.lua')
	-- Iconos nkeyboard
	nkb.errase = image.load('icon/nkb/'..nkb_theme..'/'..nkb_errase)
	nkb.line = image.load('icon/nkb/'..nkb_theme..'/'..nkb_line)
	nkb.space = image.load('icon/nkb/'..nkb_theme..'/'..nkb_space)
	nkb.more = image.load('icon/nkb/'..nkb_theme..'/'..nkb_more)
	if nkb_bg then nkb.bg = image.load('icon/nkb/'..nkb_theme..'/'..nkb_bg); image.resize(nkb.bg, 180, 54) end -- Background image
end

-- ## CARGA LOS ARCHIVOS DEL EDITOR ##
function editor.load()
	-- Cargo el tema actual
	dofile('theme/ledit-'..ledit_theme..'.lua')
	-- Cargo el fondo de pantalla
	if bg_path_image then bg_image = image.load(bg_path_image); image.resize(bg_image, 480, 272) end
	-- Iconos Ledit
	icon = {
		open = image.load('icon/'..theme.icons..'/document-new.png'),
		save = image.load('icon/'..theme.icons..'/document-save.png'),
		newfile = image.load('icon/'..theme.icons..'/document-open.png'),
		close = image.load('icon/'..theme.icons..'/document-close.png'),
		conf = image.load('icon/'..theme.icons..'/configure.png'),
		help = image.load('icon/'..theme.icons..'/help-about.png'),
		newfolder = image.load('icon/'..theme.icons..'/folder-new.png'),
		cancel = image.load('icon/'..theme.icons..'/dialog-cancel.png'),
		ok = image.load('icon/'..theme.icons..'/dialog-apply.png'),
		parentfolder = image.load('icon/'..theme.icons..'/go-parent-folder.png'),
		executable = image.load('icon/'..theme.icons..'/application-x-executable.png'),
		package = image.load('icon/'..theme.icons..'/package-x-generic.png'),
		audio = image.load('icon/'..theme.icons..'/audio-x-generic.png'),
		image = image.load('icon/'..theme.icons..'/image-x-generic.png'),
		video = image.load('icon/'..theme.icons..'/video-x-generic.png'),
		folder = image.load('icon/'..theme.icons..'/inode-directory.png'),
		text = image.load('icon/'..theme.icons..'/text-plain.png'),
		h = image.load('icon/'..theme.icons..'/text-x-chdr.png'),
		c = image.load('icon/'..theme.icons..'/text-x-csrc.png'),
		hpp = image.load('icon/'..theme.icons..'/text-x-c++hdr.png'),
		cpp = image.load('icon/'..theme.icons..'/text-x-c++src.png'),
		csharp = image.load('icon/'..theme.icons..'/text-x-csharp.png'),
		xml = image.load('icon/'..theme.icons..'/text-xml.png'),
		python = image.load('icon/'..theme.icons..'/text-x-python.png'),
		html = image.load('icon/'..theme.icons..'/text-html.png'),
		lua = image.load('icon/'..theme.icons..'/text-x-lua.png'),
		pascal = image.load('icon/'..theme.icons..'/text-x-pascal.png'),
		java = image.load('icon/'..theme.icons..'/text-x-java.png'),
		explorer = image.load('icon/'..theme.icons..'/system-file-manager.png'),
		logo = image.load('ledit.png'),
		license = image.load('icon/cc_by-sa.png')
	}
	icon.logo:center()
	-- Carga las direcciones de los temas
	t_lang_tmp = files.listfiles('lang/')
	t_theme_tmp = files.listfiles('theme/')
	system.lang = {}
	system.theme = {}
	system.nkb_theme = {}
	for index = 1, #t_lang_tmp do
		if t_lang_tmp[index].name:match('(.+).lua') == lang then clang = index end
		table.insert(system.lang, t_lang_tmp[index].name:match('(.+).lua'))
	end
	t_lang_tmp = nil; if not clang then error('Can\'t open '..lang..'.lua') end
	l_index = 1
	kb_index = 1
	for index = 1, #t_theme_tmp do
		local tmp_name = t_theme_tmp[index].name:match('(.+).lua')
		if tmp_name:find('ledit%-') then
			tmp_name = tmp_name:match('ledit%-(.+)')
			if tmp_name == ledit_theme then ctheme = l_index end
			table.insert(system.theme,tmp_name)
			l_index = l_index+1
		elseif tmp_name:find('nkb%-') then
			tmp_name = tmp_name:match('nkb%-(.+)')
			if tmp_name == nkb_theme then cnkb_theme = kb_index end
			table.insert(system.nkb_theme, tmp_name)
			kb_index = kb_index+1
		end
	end
	t_theme_tmp = nil
	if not ctheme then error('Can\'t open '..ledit_theme..'.lua') end
	if not cnkb_theme then error('Can\'t open '..nkb_theme) end
	-- Inicia el cursor
	editor.point:start()
end

-- ## MUESTRA LA CABECERA DEL EDITOR ##
function editor.show_header()
	-- Actualizo la cabecera
	local info_text = screen.fps()..'f/s | '..batt.lifepercent()..'%'
	local info_width = 474-screen.textwidth(info_text)
	-- Cabecera
	if theme.head_gradient then draw.gradrect(0, 0, 480, 22, theme.head_top, theme.head_bottom, 0)
	else draw.fillrect(0, 0, 480, 22, theme.head_color) end
	screen.print(3, 5, editor.head, 0.7, theme.head_colortitle)
	if theme.head_gradient then draw.gradrect(info_width, 0, info_width, 22, theme.head_top, theme.head_bottom, 0)
	else draw.fillrect(info_width, 0, info_width, 22, theme.head_color) end
	draw.line(info_width, 0, info_width, 21, theme.line_color)
	screen.print(info_width+3, 5, info_text, 0.7, theme.head_colorsubtitle)
	draw.line(0, 21, 480, 21, theme.line_color)
end

-- ## MUESTRA EL PIE DE PÁGINA DEL EDITOR ##
function editor.show_footer(arg1, arg2)
	if theme.footer_gradient then draw.gradrect(0, 525, 480, 20, theme.footer_top, theme.footer_bottom, 0)
	else draw.fillrect(0, 252, 480, 20, theme.footer_color) end
	screen.print(3, 256, arg1, 0.6, theme.footer_colortext)
	-- Si hay un segundo argumento lo muestra en el otro lado
	if arg2 then
		local footer_width = 474-screen.textwidth(arg2, 0.6)
		if theme.footer_gradient then draw.gradrect(footer_width, 252, 476-footer_width, 20, theme.footer_top, theme.footer_bottom, 0)
		else draw.fillrect(footer_width, 252, 476-footer_width, 20, theme.footer_color) end
		draw.line(footer_width, 252, footer_width, 272, theme.line_color)
		screen.print(footer_width+3, 256, arg2, 0.6, theme.footer_colortext)
	end
	draw.line(0, 252, 480, 252, theme.line_color)
end

-- ## MUESTRA EL CURSOR DEL EDITOR ##
function editor.show_point()
	-- Variables
	local pos = screen.textwidth(utf8.sub(editor.files[editor.cfile].text[editor.files[editor.cfile].ln], 1, editor.files[editor.cfile].ch), 0.8)
	local xpos = 6-editor.files[editor.cfile].xmin+pos
	if number_line then xpos = xpos+screen.textwidth(editor.lnmax, 0.6)+2 end
	local ytop = 27+20*(editor.files[editor.cfile].ln-editor.files[editor.cfile].lnmin)
	local ybottom = 27+20*(editor.files[editor.cfile].ln-editor.files[editor.cfile].lnmin+1)
	-- Muestro la linea del cursor
	if editor.point:time() < 1000 then draw.line(xpos, ytop, xpos, ybottom, theme.cursor) end
	if editor.point:time() > 2000
	or buttons.l or buttons.r or buttons.cross or buttons.circle
	or (not nkb.opened and (buttons.left or buttons.right or buttons.up or buttons.down))
	then editor.point:reset() end
end

-- ## MUESTRA LA POSICIÓN DEL CURSOR ##
function editor.show_position() 
	draw.fillrect(476, 27+(220/editor.lnmax)*(editor.files[editor.cfile].ln-1), 4, 220/editor.lnmax, theme.bar_pos_color)
end

-- ## MUESTRA LA LINEA ACTUAL ##
function editor.show_current_line()
	if current_line then draw.fillrect(0, 27+20*(editor.files[editor.cfile].ln-editor.files[editor.cfile].lnmin), 480, 20, theme.current_line) end
end

-- ## MUESTRA EL TEXTO ACTUAL ##
function editor.show_file()
	-- Variables
	local current_line = editor.files[editor.cfile].lnmin
	local lines_width = screen.textwidth(editor.lnmax, 0.6)
	local xpos = 6-editor.files[editor.cfile].xmin
	if number_line then xpos = xpos+lines_width+2 end
	-- Marco la linea actual y el cursor
	editor.show_current_line()
	editor.show_point()
	-- Imprimo el texto
	while current_line <= math.min(editor.files[editor.cfile].lnmin+10, #editor.files[editor.cfile].text) do
		screen.print(xpos, 31+20*(current_line-editor.files[editor.cfile].lnmin), editor.files[editor.cfile].text[current_line], 0.8, theme.normal_text)
		if number_line then
			draw.fillrect(0, 27+20*(current_line-editor.files[editor.cfile].lnmin), lines_width+4, 20, theme.number_line_bg)
			screen.print(lines_width+2, 30+20*(current_line-editor.files[editor.cfile].lnmin), current_line, 0.6, theme.number_line, 0x01, __ARIGHT)
		end
		current_line = current_line+1
	end
end

-- ## CONTROLES DEL EDITOR ##
function editor.controls()
	if not nkb.opened then
		-- Desplazamiento entre archivos
		if buttons.l and editor.cfile > 1 then editor.cfile = editor.cfile-1
		elseif buttons.r and editor.cfile < editor.files.opened then editor.cfile = editor.cfile+1 end
		-- Desplazamiento entre lineas
		if buttons.up and editor.files[editor.cfile].ln > 1 then editor.files[editor.cfile].ln = editor.files[editor.cfile].ln-1
		elseif buttons.down and editor.files[editor.cfile].ln < editor.lnmax then editor.files[editor.cfile].ln = editor.files[editor.cfile].ln+1 end
		-- Ajuste de lineas
		if editor.files[editor.cfile].ch > utf8.len(editor.files[editor.cfile].text[editor.files[editor.cfile].ln]) then
			editor.files[editor.cfile].ch = utf8.len(editor.files[editor.cfile].text[editor.files[editor.cfile].ln])
		end
		-- Desplazamiento entre caracteres
		if buttons.left then editor.files[editor.cfile].ch = editor.files[editor.cfile].ch-1
		elseif buttons.right then editor.files[editor.cfile].ch = editor.files[editor.cfile].ch+1 end
		-- Teclas rápidas
		if buttons.cross then
			editor.files[editor.cfile].ln = editor.files[editor.cfile].ln+1
			table.insert(editor.files[editor.cfile].text, editor.files[editor.cfile].ln, utf8.sub(editor.files[editor.cfile].text[editor.files[editor.cfile].ln-1], editor.files[editor.cfile].ch+1))
			editor.files[editor.cfile].text[editor.files[editor.cfile].ln-1] = utf8.sub(editor.files[editor.cfile].text[editor.files[editor.cfile].ln-1], 1, editor.files[editor.cfile].ch)
			editor.files[editor.cfile].ch = 0
		elseif buttons.circle and editor.files[editor.cfile].ch ~= 0 then
			editor.files[editor.cfile].text[editor.files[editor.cfile].ln] = utf8.sub(editor.files[editor.cfile].text[editor.files[editor.cfile].ln], 1, editor.files[editor.cfile].ch-1)..utf8.sub(editor.files[editor.cfile].text[editor.files[editor.cfile].ln], editor.files[editor.cfile].ch+1)
			editor.files[editor.cfile].ch = editor.files[editor.cfile].ch-1
		elseif buttons.circle and editor.files[editor.cfile].ch == 0 and editor.files[editor.cfile].ln > 1 then
			editor.files[editor.cfile].ln = editor.files[editor.cfile].ln-1
			editor.files[editor.cfile].ch = utf8.len(editor.files[editor.cfile].text[editor.files[editor.cfile].ln])
			editor.files[editor.cfile].text[editor.files[editor.cfile].ln] = editor.files[editor.cfile].text[editor.files[editor.cfile].ln]..editor.files[editor.cfile].text[editor.files[editor.cfile].ln+1]
			table.remove(editor.files[editor.cfile].text, editor.files[editor.cfile].ln+1)
		end
	else
		-- Desplazamiento entre caracteres
		if  buttons.l then editor.files[editor.cfile].ch = editor.files[editor.cfile].ch-1
		elseif buttons.r then editor.files[editor.cfile].ch = editor.files[editor.cfile].ch+1 end
	end
end

-- ## AJUSTA EL TEXTO ##
function editor.check_text()
	local lines_width = screen.textwidth(#editor.files[editor.cfile].text, 0.6)
	-- Ajustes de longitud de lineas/saltos no permitidos
	if editor.files[editor.cfile].ch > utf8.len(editor.files[editor.cfile].text[editor.files[editor.cfile].ln]) and editor.files[editor.cfile].ln < #editor.files[editor.cfile].text then
		editor.files[editor.cfile].ln = editor.files[editor.cfile].ln+1; editor.files[editor.cfile].ch = 0
	elseif editor.files[editor.cfile].ch > utf8.len(editor.files[editor.cfile].text[editor.files[editor.cfile].ln]) and editor.files[editor.cfile].ln == #editor.files[editor.cfile].text then
		editor.files[editor.cfile].ch = utf8.len(editor.files[editor.cfile].text[editor.files[editor.cfile].ln])
	elseif editor.files[editor.cfile].ch < 0 and editor.files[editor.cfile].ln > 1 then
		editor.files[editor.cfile].ln = editor.files[editor.cfile].ln-1
		editor.files[editor.cfile].ch = utf8.len(editor.files[editor.cfile].text[editor.files[editor.cfile].ln])
	elseif editor.files[editor.cfile].ch < 0 and editor.files[editor.cfile].ln == 1 then editor.files[editor.cfile].ch = 0 end
	-- Actualizo el ancho del texto a mostrar
	if number_line then
		editor.files[editor.cfile].xmin = math.max(0, -466+lines_width+screen.textwidth(utf8.sub(editor.files[editor.cfile].text[editor.files[editor.cfile].ln], 1, editor.files[editor.cfile].ch+1), 0.8))
	else
		editor.files[editor.cfile].xmin = math.max(0, -468+screen.textwidth(utf8.sub(editor.files[editor.cfile].text[editor.files[editor.cfile].ln], 1, editor.files[editor.cfile].ch+1), 0.8))
	end
	-- Cambiar las lineas mostradas
	if editor.files[editor.cfile].ln < editor.files[editor.cfile].lnmin then editor.files[editor.cfile].lnmin = editor.files[editor.cfile].ln
	elseif editor.files[editor.cfile].ln > editor.files[editor.cfile].lnmin+10 then editor.files[editor.cfile].lnmin = editor.files[editor.cfile].ln-10 end
end

-- ## FONDO DEL EDITOR ##
function editor.show_bg()
	if theme.bg_color then draw.fillrect(0, 0, 480, 272, theme.bg_color)
	else draw.fillrect(0, 0, 480, 272, color.new(255, 255, 255)) end
	if bg_image and bg_opacity then screen.bilinear(1); bg_image:blit(0, 0, bg_opacity*255/100); screen.bilinear(0)
	elseif bg_image and not bg_opacity then screen.bilinear(1); bg_image:blit(0, 0); screen.bilinear(0)
	elseif theme.bg_image and theme.bg_opacity then screen.bilinear(1); theme.bg_image:blit(0, 0, theme.bg_opacity*255/100); screen.bilinear(0)
	elseif theme.bg_image and not theme.bg_opacity then screen.bilinear(1); theme.bg_image:blit(0, 0); screen.bilinear(0) end
end

-- ## FUNCIÓN PRINCIPAL ##
function editor.main()
	-- Actualizo la cabecera
	if editor.files[editor.cfile].modified then editor.head = editor.cfile..'. *'..editor.files[editor.cfile].name
	else editor.head = editor.cfile..'. '..editor.files[editor.cfile].name end
	-- Actualizo las lineas máximas del archivo
	editor.lnmax = #editor.files[editor.cfile].text
	-- Muesto la interfaz gráfica
	editor.show_bg()
	editor.show_header()
	editor.show_file()
	editor.show_position()
	if menu.show then menu.bar()
	else editor.show_footer(editor.fullname, editor.files[editor.cfile].lang..' | Ln '..editor.files[editor.cfile].ln..', Ch '..(editor.files[editor.cfile].ch+1)) end

	-- Controles
	if not menu.show then
		-- Muestro el teclado
		local old_line = editor.files[editor.cfile].text[editor.files[editor.cfile].ln]
		local old_lines = editor.lnmax
		editor.files[editor.cfile].text, editor.files[editor.cfile].ln, editor.files[editor.cfile].ch = nkb.show(editor.files[editor.cfile].text, editor.files[editor.cfile].ln, editor.files[editor.cfile].ch)
		if old_line ~= editor.files[editor.cfile].text[editor.files[editor.cfile].ln] or old_lines ~= #editor.files[editor.cfile].text then editor.files[editor.cfile].modified = true end
		nkb.open()
		-- Controles del editor
		editor.controls()
		editor.check_text()
	end
end
