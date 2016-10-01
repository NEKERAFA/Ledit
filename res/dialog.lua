--[[
	Lua Editor 1.0
	Creado por NEKERAFA (nekerafa@gmail.com) el lun 03 nov 2014 11:54:46 CET 
	Licenciado por Creative Commons Reconocimiento-CompartirIgual 4.0
	http://creativecommons.org/licenses/by-sa/4.0/

	# dialog.lua
	# Dialogos de Ledit
]]

-- ## TABLA PRINCIPAL DE DIALOGOS ##
dialog = {}

-- ## MUESTRA EL DIALOGO DE ABRIR ARCHIVO ##
function dialog.file_open()
	close_dialog = false
	editor.head = msg.open
	explorer.restart()
	while not close_dialog do
		-- Leo los controles
		buttons.read()
		-- Leo los dispositivos
		explorer.update_device()
		-- Muestro la interfaz
		editor.show_bg()
		editor.show_header()
		menu.bar_explorer(0)
		-- Muestro el explorador
		explorer.show()
		if explorer.pos == 0 then
			if explorer.bar_pos == 1 then editor.show_footer(editor.fullname.." - "..msg.cancel)
			elseif explorer.bar_pos == 2 then editor.show_footer(editor.fullname.." - "..msg.parentfolder) end
		end
		screen.flip()
		-- Cargar el archivo
		if buttons.square and explorer.pos > 0 and not explorer.list[explorer.pos].directory then
			if not explorer.list[explorer.pos].ext
			or explorer.list[explorer.pos].ext == 'txt'
			or explorer.list[explorer.pos].ext == 'lua'
			or explorer.list[explorer.pos].ext == 'c'
			or explorer.list[explorer.pos].ext == 'h'
			or explorer.list[explorer.pos].ext == 'hh'
			or explorer.list[explorer.pos].ext == 'hpp'
			or explorer.list[explorer.pos].ext == 'hxx'
			or explorer.list[explorer.pos].ext == 'h++'
			or explorer.list[explorer.pos].ext == 'cc'
			or explorer.list[explorer.pos].ext == 'cpp'
			or explorer.list[explorer.pos].ext == 'cxx'
			or explorer.list[explorer.pos].ext == 'c++'
			or explorer.list[explorer.pos].ext == 'cs'
			or explorer.list[explorer.pos].ext == 'xml'
			or explorer.list[explorer.pos].ext == 'py'
			or explorer.list[explorer.pos].ext == 'pyc'
			or explorer.list[explorer.pos].ext == 'pyd'
			or explorer.list[explorer.pos].ext == 'pyo'
			or explorer.list[explorer.pos].ext == 'pyw'
			or explorer.list[explorer.pos].ext == 'htm'
			or explorer.list[explorer.pos].ext == 'html'
			or explorer.list[explorer.pos].ext == 'pas'
			or explorer.list[explorer.pos].ext == 'java'
			or explorer.list[explorer.pos].ext == 'class' then
				files.open(explorer.list[explorer.pos].path)
			end
		end
		-- Controles del explorador
		explorer.controls()
	end
end

-- ## MUESTRA EL DIALOGO PARA CARGAR UN FONDO DE PANTALLA ##
function dialog.bg_open()
	close_dialog = false
	editor.head = msg.open
	explorer.restart()
	while not close_dialog do
		-- Leo los controles
		buttons.read()
		-- Leo los dispositivos
		explorer.update_device()
		-- Muestro la interfaz
		editor.show_bg()
		editor.show_header()
		menu.bar_explorer(0)
		-- Muestro el explorador
		explorer.show()
		if explorer.pos == 0 then
			if explorer.bar_pos == 1 then editor.show_footer(editor.fullname.." - "..msg.cancel)
			elseif explorer.bar_pos == 2 then editor.show_footer(editor.fullname.." - "..msg.parentfolder) end
		end
		screen.flip()
		-- Cargar el archivo
		if buttons.square and explorer.pos > 0 and not explorer.list[explorer.pos].directory then
			if explorer.list[explorer.pos].ext == 'jpg'
			or explorer.list[explorer.pos].ext == 'jpeg'
			or explorer.list[explorer.pos].ext == 'png'
			or explorer.list[explorer.pos].ext == 'gif' then
				bg_image = image.load(explorer.list[explorer.pos].path); image.resize(bg_image, 480, 272)
				bg_path_image = explorer.list[explorer.pos].path
				bg_opacity = bg_opacity or 100
				close_dialog = true
			end
		end
		-- Controles del explorador
		explorer.controls()
	end
end

-- ## MUESTRA EL DIALOGO DE GUARDAR ARCHIVO ##
function dialog.file_save()
	close_dialog = false
	editor.head = msg.save
	name_file = editor.files[editor.cfile].name
	explorer.restart()
	while not close_dialog do
		-- Leo los controles
		buttons.read()
		-- Leo los dispositivos
		explorer.update_device()
		-- Muestro la interfaz
		editor.show_bg()
		editor.show_header()
		menu.bar_explorer(1)
		-- Nombre del archivo
		system.label(90, 24, 280, name_file, (explorer.bar_pos == 5 and explorer.pos == 0))
		-- Muestro el explorador
		explorer.show()
		if explorer.pos == 0 then
			if explorer.bar_pos == 1 then editor.show_footer(editor.fullname.." - "..msg.cancel)
			elseif explorer.bar_pos == 2 then editor.show_footer(editor.fullname.." - "..msg.apply) 
			elseif explorer.bar_pos == 3 then editor.show_footer(editor.fullname.." - "..msg.parentfolder) 
			elseif explorer.bar_pos == 4 then editor.show_footer(editor.fullname.." - "..msg.newfolder) 
			elseif explorer.bar_pos == 5 then editor.show_footer(editor.fullname.." - "..msg.name) end
		end
		-- Nombre elemento
		if explorer.bar_pos == 5 then name_file = nkb.show(name_file); nkb.open()
		elseif explorer.bar_pos ~= 5 and nkb.opened and not creating_folder then nkb.opened = false end
		-- Nombre de la carpeta
		if explorer.pos == 1 and creating_folder then
			explorer.list[1].name = nkb.show(explorer.list[1].name)
			if buttons.triangle then
				files.mkdir(explorer.path..explorer.list[1].name)
				explorer.list = files.list(explorer.path)
				explorer.lenlist = #explorer.list
				explorer.pos = 1
				nkb.opened = false
				creating_folder = false
			end
		end
		screen.flip()
		-- Controles del explorador
		if not creating_folder and not nkb.opened then explorer.controls() end
	end
end

-- ## MUESTRA EL DIALOGO DE CONFIGURACIÖN ##
function dialog.settings()
	close_dialog = false
	editor.head = msg.settings
	system.pos = 1
	system.bar_pos = 1
	-- Declaramos las variables locales para no interferir con el programa principal
	local bg_path_image = bg_path_image
	local bg_image = bg_image
	local bg_opacity = bg_opacity
	local number_line = number_line
	local current_line = current_line
	local tab_size = tab_size
	while not close_dialog do
		-- Leo los controles
		buttons.read()
		-- Muestro la interfaz
		editor.show_bg()
		editor.show_header()
		menu.bar_settings()
		-- Fondo
		draw.fillrect(39, 46, 402, 202, theme.bg_explorer)
		icon.logo:blit(240, 146, 192)
		draw.rect(39, 46, 402, 202, theme.line_color)
		-- Muestro el menu de ajustes
		if system.pos > 0 then draw.fillrect(62, 67+20*(system.pos-1), 356, 20, theme.current_line) end
		system.show_settinglabels()
		system.show_settingobjects()
		-- Pie de página
		if system.pos == 0 then
			if system.bar_pos == 1 then editor.show_footer(editor.fullname.." - "..msg.cancel)
			elseif system.bar_pos == 2 then editor.show_footer(editor.fullname.." - "..msg.apply) end
		elseif system.pos == 7 and bg_path_image then editor.show_footer(bg_path_image)
		else editor.show_footer(editor.fullname) end
		screen.flip()
		-- Controles
		system.controls()
	end
end
