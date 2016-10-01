--[[
	NKeyboard 1.4 (Onelua)
	Created NEKERAFA (nekerafa@gmail.com) on sáb, 28 oct 2014 12:06:15 CEST  
	Licenced by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/

	# nkb-1.4(onelua).lua
	# Onscreen keyboard for PSP.
	#
	# -- Version 1.4 (Halloween Edition)) --
	# Support as text as tables like input
	# New improvements in the code
	#
	# -- Version 1.3 --
	# New shortcuts
	#
	# -- Version 1.2 --
	# New file with keyboard configuration
	#
	# -- Version 1.1 --
	# · You can put text position
	# · Some bugs fixed
]]

-- UTF-8 Utilities
-- dofile('utf8.lua')
-- Configuration
-- dofile('conf.lua')

-- Character maps
nkb = {maps = {}}
nkb.maps[1] = {
	{{'Q', '1', 'Ⅰ'}, {'W', '2', 'Ⅱ'}, {'E', 'É', 'È', 'Ë', 'Ê', 'Ě', 'Ē', 'Ε', '3', 'Ⅲ'}, {'R', 'Ρ', '4', 'Ⅳ'}, {'T', 'Τ', '5', 'Ⅴ'}, {'Y', 'Ý', 'Υ', '6', 'Ⅵ'}, {'U', 'Ú', 'Ù', 'Ü', 'Û', 'Ū', 'Θ', '7', 'Ⅶ'}, {'I', 'Í', 'Ì', 'Ï', 'Î', 'Ī', 'Ι', '8', 'Ⅷ'}, {'O', 'Ó', 'Ò', 'Ö', 'Ô', 'Õ', 'Ø', 'Ō', 'Œ', 'Ο', '9', 'Ⅸ'}, {'P', 'Π', '0', 'Ⅹ'}},
	{{'A', 'À', 'Á', 'Ä', 'Â', 'Ã', 'Å', 'Æ', 'Ā', 'Α'}, {'S', 'ß', 'Š', 'Σ'}, {'D', 'Ð', 'Δ'}, {'F', 'Φ'}, {'G', 'Γ'}, {'H', 'Η'}, {'J', 'Ξ'}, {'K', 'Κ'}, {'L', 'Λ'}},
	{{'Z', 'Ž', 'Ζ'}, {'X', 'Χ'}, {'C', 'Ç', 'Ć', 'Ψ'}, {'V', 'Ω'}, {'B', 'Β'}, {'N', 'Ñ', 'Ν'}, {'M', 'Μ'}}
}
nkb.maps[2] = {
	{{'q', '1', 'ⅰ'}, {'w', '2', 'ⅱ'}, {'e', 'é', 'è', 'ë', 'ê', 'ě', 'ē', 'ε', '3', 'ⅲ'}, {'r', 'ρ', '4', 'ⅳ'}, {'t', 'τ', '5', 'ⅴ'}, {'y', 'ý', 'υ', '6', 'ⅵ'}, {'u', 'ú', 'ù', 'ü', 'û', 'ū', 'θ', '7', 'ⅶ'}, {'i', 'í', 'ì', 'ï', 'î', 'ī', 'ι', '8', 'ⅷ'}, {'o', 'ó', 'ò', 'ö', 'ô', 'õ', 'ø', 'ō', 'œ', 'ο', '9', 'ⅸ'}, {'p', 'π', '0', 'ⅹ'}},
	{{'a', 'à', 'á', 'ä', 'â', 'ã', 'å', 'æ', 'ā', 'α'}, {'s', 'ß', 'š', 'σ'}, {'d', 'ð', 'δ'}, {'f', 'φ'}, {'g', 'γ'}, {'h', 'η'}, {'j', 'ξ'}, {'k', 'κ'}, {'l', 'λ'}},
	{{'z', 'ž', 'ζ'}, {'x', 'χ'}, {'c', 'ç', 'ψ'}, {'v', 'ω'}, {'b', 'β'}, {'n', 'ñ', 'ν'}, {'m', 'μ'}}
}
nkb.maps[3] = {
	{{'1', '!', '¡'}, {'2', '@', '©', '®', '™'}, {'3', '#'}, {'4', '$', '£', '€', '¥', '¢', '¤'}, {'5', '%', '‰'}, {'6', '^'}, {'7', '&'}, {'8', '*', 'º', 'ª'}, {'9', '('}, {'0', ')'}},
	{{'?', '¿'}, {'"', '“', '”'}, {'\'', '´', '`', '‘', '’'},  {'<', '«'}, {'>', '»'}, '{', '}', '[', ']'},
	{{'+', '±', '÷', '×', '√'}, {'-', '_'}, {'/', '\\', '|', '¦'}, '*', {'=', '≠', '~', '∞'}, {',', ';'}, {'.', ':', '·'}}
}
-- Variables
nkb.sel = 1 -- Selection
nkb.r = 1 -- Row
nkb.c = 1 -- Column
nkb.ch = 1 -- Char selection
nkb.opened = true -- Opened keyboard
--[[nkb.errase = image.load(nkb_errase) -- Errase
nkb.line = image.load(nkb_line) -- New Line
nkb.space = image.load(nkb_space) -- Space icon
nkb.more = image.load(nkb_more) -- More Options
if nkb_bg then nkb.bg = image.load(nkb_bg); image.resize(nkb.bg, 180, 54) end -- Background image]]

-- Print keys in the keyboard
function nkb.print_keys()
	-- Iterate a line
	for y, row in ipairs(nkb.maps[nkb.sel]) do
		-- Iterate each character
		for x, char in ipairs(row) do
			if type(char) == 'table' then
				if nkb.r == y and nkb.c == x then screen.print(159+18*(x-1), 221+18*(y-1), char[nkb.ch], 0.7, nkb_charcolor, 0x01, __ACENTER)
				else screen.print(159+18*(x-1), 221+18*(y-1), char[1], 0.7, nkb_charcolor, 0x01, __ACENTER) end
				nkb.more:blit(150+18*(x-1), 218+18*(y-1))
			elseif type(char) == 'string' then screen.print(159+18*(x-1), 221+18*(y-1), char, 0.7, nkb_charcolor, 0x01, __ACENTER) end
		end
	end
end

-- Keyboard controls
function nkb.controls()
	-- For strings
	if type(nkb.arg[1]) == 'string' then
		if buttons.cross then
			if nkb.r == 2 and nkb.c == 10 then nkb.arg[1] = utf8.sub(nkb.arg[1], 1, nkb.arg[2]-1)..utf8.sub(nkb.arg[1], nkb.arg[2]+1); nkb.arg[2] = nkb.arg[2]-1
			elseif nkb.r == 3 and nkb.c == 8 then nkb.arg[1] = utf8.sub(nkb.arg[1], 1, nkb.arg[2])..' '..utf8.sub(nkb.arg[1], nkb.arg[2]+1); nkb.arg[2] = nkb.arg[2]+1
			elseif nkb.r == 3 and nkb.c == 9 then nkb.sel = nkb.sel+1; if nkb.sel > 3 then nkb.sel = 1 end
			elseif nkb.r == 3 and nkb.c == 10 then nkb.arg[1] = utf8.sub(nkb.arg[1], 1, nkb.arg[2])..'\n'..utf8.sub(nkb.arg[1], nkb.arg[2]+1); nkb.arg[2] = nkb.arg[2]+1 end
		elseif buttons.circle then nkb.arg[1] = utf8.sub(nkb.arg[1], 1, nkb.arg[2]-1)..utf8.sub(nkb.arg[1], nkb.arg[2]+1); nkb.arg[2] = nkb.arg[2]-1
		elseif buttons.square then nkb.sel = nkb.sel+1; if nkb.sel > 3 then nkb.sel = 1 end
		elseif buttons.held.cross and type(nkb.maps[nkb.sel][nkb.r][nkb.c]) == 'table' then
			if buttons.left and nkb.ch ~= 1 then nkb.ch = nkb.ch-1
			elseif buttons.right and nkb.ch ~= #nkb.maps[nkb.sel][nkb.r][nkb.c] then nkb.ch = nkb.ch+1 end
		elseif buttons.released.cross then
			if type(nkb.maps[nkb.sel][nkb.r][nkb.c]) == 'table' then nkb.arg[1] = utf8.sub(nkb.arg[1], 1, nkb.arg[2])..nkb.maps[nkb.sel][nkb.r][nkb.c][nkb.ch]..utf8.sub(nkb.arg[1], nkb.arg[2]+1); nkb.arg[2] = nkb.arg[2]+1
			elseif type(nkb.maps[nkb.sel][nkb.r][nkb.c]) == 'string' then nkb.arg[1] = utf8.sub(nkb.arg[1], 1, nkb.arg[2])..nkb.maps[nkb.sel][nkb.r][nkb.c]..utf8.sub(nkb.arg[1], nkb.arg[2]+1); nkb.arg[2] = nkb.arg[2]+1 end
		else nkb.move_chars() end
	-- For string tables
	elseif type(nkb.arg[1]) == 'table' then
		if buttons.cross then
			if nkb.r == 2 and nkb.c == 10 and nkb.arg[3] ~= 0 then nkb.arg[1][nkb.arg[2]] = utf8.sub(nkb.arg[1][nkb.arg[2]], 1, nkb.arg[3]-1)..utf8.sub(nkb.arg[1][nkb.arg[2]], nkb.arg[3]+1); nkb.arg[3] = nkb.arg[3]-1
			elseif nkb.r == 2 and nkb.c == 10 and nkb.arg[3] == 0 and nkb.arg[2] > 1 then
				nkb.arg[2] = nkb.arg[2]-1
				nkb.arg[3] = utf8.len(nkb.arg[1][nkb.arg[2]])
				nkb.arg[1][nkb.arg[2]] = nkb.arg[1][nkb.arg[2]]..nkb.arg[1][nkb.arg[2]+1]
				table.remove(nkb.arg[1], nkb.arg[2]+1)
			elseif nkb.r == 3 and nkb.c == 8 then nkb.arg[1][nkb.arg[2]] = utf8.sub(nkb.arg[1][nkb.arg[2]], 1, nkb.arg[3])..' '..utf8.sub(nkb.arg[1][nkb.arg[2]], nkb.arg[3]+1); nkb.arg[3] = nkb.arg[3]+1
			elseif nkb.r == 3 and nkb.c == 9 then nkb.sel = nkb.sel+1; if nkb.sel > 3 then nkb.sel = 1 end
			elseif nkb.r == 3 and nkb.c == 10 then
				nkb.arg[2] = nkb.arg[2]+1
				table.insert(nkb.arg[1], nkb.arg[2], utf8.sub(nkb.arg[1][nkb.arg[2]-1], nkb.arg[3]+1))
				nkb.arg[1][nkb.arg[2]-1] = utf8.sub(nkb.arg[1][nkb.arg[2]-1], 1, nkb.arg[3])
				nkb.arg[3] = 0
			end
		elseif buttons.circle and nkb.arg[3] ~= 0 then nkb.arg[1][nkb.arg[2]] = utf8.sub(nkb.arg[1][nkb.arg[2]], 1, nkb.arg[3]-1)..utf8.sub(nkb.arg[1][nkb.arg[2]], nkb.arg[3]+1); nkb.arg[3] = nkb.arg[3]-1
		elseif buttons.circle and nkb.arg[3] == 0 and nkb.arg[2] > 1 then
				nkb.arg[2] = nkb.arg[2]-1
				nkb.arg[3] = utf8.len(nkb.arg[1][nkb.arg[2]])
				nkb.arg[1][nkb.arg[2]] = nkb.arg[1][nkb.arg[2]]..nkb.arg[1][nkb.arg[2]+1]
				table.remove(nkb.arg[1], nkb.arg[2]+1)
		elseif buttons.square then nkb.sel = nkb.sel+1; if nkb.sel > 3 then nkb.sel = 1 end
		elseif buttons.held.cross and type(nkb.maps[nkb.sel][nkb.r][nkb.c]) == 'table' then
			if buttons.left and nkb.ch ~= 1 then nkb.ch = nkb.ch-1
			elseif buttons.right and nkb.ch ~= #nkb.maps[nkb.sel][nkb.r][nkb.c] then nkb.ch = nkb.ch+1 end
		elseif buttons.released.cross then
			if type(nkb.maps[nkb.sel][nkb.r][nkb.c]) == 'table' then nkb.arg[1][nkb.arg[2]] = utf8.sub(nkb.arg[1][nkb.arg[2]], 1, nkb.arg[3])..nkb.maps[nkb.sel][nkb.r][nkb.c][nkb.ch]..utf8.sub(nkb.arg[1][nkb.arg[2]], nkb.arg[3]+1); nkb.arg[3] = nkb.arg[3]+1
			elseif type(nkb.maps[nkb.sel][nkb.r][nkb.c]) == 'string' then nkb.arg[1][nkb.arg[2]] = utf8.sub(nkb.arg[1][nkb.arg[2]], 1, nkb.arg[3])..nkb.maps[nkb.sel][nkb.r][nkb.c]..utf8.sub(nkb.arg[1][nkb.arg[2]], nkb.arg[3]+1); nkb.arg[3] = nkb.arg[3]+1 end
		else nkb.move_chars() end
	end
end

-- To move in character keys
function nkb.move_chars()
	if nkb.ch ~= 1 then nkb.ch = 1 end
	if buttons.up then nkb.r = nkb.r-1 elseif buttons.down then nkb.r = nkb.r+1 end
	if buttons.left then nkb.c = nkb.c-1 elseif buttons.right then nkb.c = nkb.c+1 end
	if nkb.r < 1 then nkb.r = 3 elseif nkb.r > 3 then nkb.r = 1 end
	if nkb.c < 1 then nkb.c = 10 elseif nkb.c > 10 then nkb.c = 1 end
end

-- For open or close keyboard
function nkb.open()
	if buttons.triangle then nkb.opened = not nkb.opened end
end

-- Function to show keyboard on screen
function nkb.show(...)
	-- Table of arguments
	nkb.arg = {...}
	if type(nkb.arg[1]) == 'string' then
		if not nkb.arg[2] then nkb.arg[2] = #nkb.arg[1] end
		nkb.arg[2] = math.max(nkb.arg[2], 0)
	elseif type(nkb.arg[1]) == 'table' then
		if not nkb.arg[2] or not nkb.arg[3] then nkb.arg[2] = #nkb.arg[1]; nkb.arg[3] = #nkb.arg[1][nkb.arg[2]] end
		nkb.arg[2] = math.min(math.max(nkb.arg[2], 0), #nkb.arg[1])
		nkb.arg[3] = math.min(math.max(nkb.arg[3], 0), #nkb.arg[1][nkb.arg[2]])
	end

	if nkb.opened then
		-- Controls
		nkb.controls()

		-- Print the keyboard
		draw.line(150, 217, 330, 217, nkb_border)
		draw.line(149, 218, 149, 272, nkb_border)
		draw.line(330, 218, 330, 272, nkb_border)
		if nkb.bg then screen.bilinear(1); nkb.bg:blit(150, 218); screen.bilinear(0)
		else draw.gradrect(150, 218, 180, 54, nkb_boxup, nkb_boxup, nkb_boxdown, nkb_boxdown) end
		if buttons.held.cross then draw.fillrect(150+18*(nkb.c-1), 218+18*(nkb.r-1), 18, 18, nkb_charpress)
		else draw.fillrect(150+18*(nkb.c-1), 218+18*(nkb.r-1), 18, 18, nkb_onchar) end
		nkb.print_keys()

		-- Print icons
		nkb.errase:blit(312, 236)
		nkb.space:blit(276, 254)
		if nkb.sel == 1 then screen.print(303, 256, 'ab', 0.6, nkb_charcolor, 0x01, __ACENTER)
		elseif nkb.sel == 2 then screen.print(303, 256, '$1', 0.6, nkb_charcolor, 0x01, __ACENTER)
		elseif nkb.sel == 3 then screen.print(303, 256, 'AB', 0.6, nkb_charcolor, 0x01, __ACENTER) end
		nkb.line:blit(312, 254)
	end

	-- nkb.open()
	return nkb.arg[1], nkb.arg[2], nkb.arg[3]
end
