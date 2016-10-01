--[[
	Lua Editor 1.0
	Creado por NEKERAFA (nekerafa@gmail.com) el sáb 1 nov 2014 10:28:23 CET 
	Licenciado por Creative Commons Reconocimiento-CompartirIgual 4.0
	http://creativecommons.org/licenses/by-sa/4.0/

	# explorer.lua
	# Funciones del explorador de Ledit
]]

-- ## TABLA PRINCIPAL DEL EXPLORADOR ##
explorer = {
	root = string.sub(files.cdir(), 1, 5),
	pos = 1,
	bar_pos = 1,
	min = 1
}
explorer.path = explorer.root
explorer.list = files.list(explorer.path)
explorer.lenlist = #explorer.list

-- ## REINICIA EL EXPLORADOR ##
function explorer.restart()
	explorer.root = string.sub(files.cdir(), 1, 5)
	explorer.pos = 1
	explorer.bar_pos = 1
	explorer.min = 1
	explorer.path = explorer.root
	explorer.list = files.list(explorer.path)
	explorer.lenlist = #explorer.list
end

-- ## DETECTA LAS MEMORIAS PRESENTES EN LA PSP ##
function explorer.update_device()
	explorer.total_dev = 0
	if files.exists('ms0:/') then explorer.ms = true; explorer.total_dev = explorer.total_dev+1 else explorer.ms = false end
	if files.exists('ef0:/') then explorer.ef = true; explorer.total_dev = explorer.total_dev+1 else explorer.ef = false end
	if explorer.total_dev == 0 then error('No media detected.', 10) end
end

-- ## CONTROLES DEL EXPLORADOR ##
function explorer.controls()
	-- Navegar entre archivos abiertos
	if buttons.up and explorer.pos > 0 then explorer.pos = explorer.pos-1
	elseif buttons.down and explorer.pos < explorer.lenlist then explorer.pos = explorer.pos+1; explorer.bar_pos = 1 end
	-- Modifica la cantidad de archivos a mostrar
	if math.max(explorer.pos, 1) < explorer.min then explorer.min = explorer.pos
	elseif explorer.pos > explorer.min+9 then explorer.min = explorer.pos-9 end
	-- Entrar en un directorio
	if buttons.cross and explorer.pos > 0 and explorer.list[explorer.pos].directory then
		explorer.path = explorer.list[explorer.pos].path..'/'
		explorer.list = files.list(explorer.path)
		explorer.lenlist = #explorer.list
		explorer.pos = 1
	-- Salir de un directorio
	elseif buttons.circle and explorer.path ~= explorer.root then
		explorer.path = files.nofile(explorer.path)
		explorer.list = files.list(explorer.path)
		explorer.lenlist = #explorer.list
		explorer.pos = 1
	end
end

-- ## MUESTRA EL EXPLORADOR ##
function explorer.show()
	-- Fondo
	draw.fillrect(39, 46, 402, 202, theme.bg_explorer)
	icon.logo:blit(240, 146, 192)
	draw.rect(39, 46, 402, 202, theme.line_color)
	-- Lista de archivos
	if explorer.lenlist > 0 then
		if explorer.pos > 0 then draw.fillrect(40, 47+20*(explorer.pos-explorer.min), 400, 20, theme.current_line) end
		local index = explorer.min
		while index <= math.min(explorer.lenlist, explorer.min+9) do
			-- Iconos del archivo/directorio listado
			if explorer.list[index].directory then
				icon.folder:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'pbp' or explorer.list[index].ext == 'iso' or explorer.list[index].ext == 'cso' then
				icon.executable:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'zip' or explorer.list[index].ext == 'rar' then
				icon.package:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'mp4' or explorer.list[index].ext == 'avi' then
				icon.video:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'mp3' or explorer.list[index].ext == 's3m' or explorer.list[index].ext == 'bgm' or explorer.list[index].ext == 'wav' then
				icon.audio:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'jpg' or explorer.list[index].ext == 'jpeg' or explorer.list[index].ext == 'png' or explorer.list[index].ext == 'gif' or explorer.list[index].ext == 'bmp' or explorer.list[index].ext == 'tiff' then
				icon.image:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'h' then
				icon.h:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'c'then
				icon.c:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'hh' or explorer.list[index].ext == 'hpp' or explorer.list[index].ext == 'hxx' or explorer.list[index].ext == 'h++' then
				icon.hpp:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'cc' or explorer.list[index].ext == 'cpp' or explorer.list[index].ext == 'cxx' or explorer.list[index].ext == 'c++' then
				icon.cpp:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'cs' then
				icon.csharp:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'xml' then
				icon.xml:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'py' or explorer.list[index].ext == 'pyc' or explorer.list[index].ext == 'pyd' or explorer.list[index].ext == 'pyo' or explorer.list[index].ext == 'pyw' then
				icon.python:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'htm' or explorer.list[index].ext == 'html' then
				icon.html:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'lua' then
				icon.lua:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'pas' then
				icon.pascal:blit(42, 49+20*(index-explorer.min))
			elseif explorer.list[index].ext == 'java' or explorer.list[index].ext == 'class' or explorer.list[index].ext == 'jar' or explorer.list[index].ext == 'jad' then
				icon.java:blit(42, 49+20*(index-explorer.min))
			else
				icon.text:blit(42, 49+20*(index-explorer.min))
			end
			-- Nombre
			screen.print(61, 50+20*(index-explorer.min), explorer.list[index].name, 0.6, theme.normal_text)
			index = index+1
		end
	-- En caso de que el directorio esté vacio
	else screen.print(44, 50, msg.empty, 0.6, theme.normal_text); if explorer.pos > 0 then explorer.pos = 1 end end
	if explorer.pos > 0 and explorer.lenlist > 0 and explorer.list[explorer.pos].size then
		editor.show_footer(explorer.path, files.sizehr(explorer.list[explorer.pos].size))
	elseif explorer.pos > 0 and explorer.lenlist > 0 and not explorer.list[explorer.pos].size then
		editor.show_footer(explorer.path)
	end
end
