--[[
	WaveLib 1.0 ONELua (PORT)
	Creado por NEKERAFA (nekerafa@gmail.com) el lun 06 de jun de 2014, 00:44:23 (CEST) 
	Licenciado por Creative Commons Reconocimiento-CompartirIgual 4.0
	http://creativecommons.org/licenses/by/4.0/

	# wavelib-1.0(onelua).lua
	#
	# WaveLib es una biblioteca gráfica para la creación de ondas en ONELua y LuaDEV
]]

-- Tabla principal
wave = {}
	-- wave = wave.new(...): Crea una nueva onda. Los valores son los siguientes:
	-- · wave.new( velocidad )
	-- · wave.new( desplazamiento, fase, amplitud, longitud, velocidad )
	function wave.new(...)
		-- Variables locales
		local arg = {...}
		local obj = {}
		-- Variables de la onda
		if #arg == 0 then obj.d = 140; obj.f = 0; obj.a = 20; obj.l = 480; obj.v = 1
		elseif #arg == 1 then obj.d = 140; obj.f = 0; obj.a = 20; obj.l = 480; obj.v = arg[1]
		elseif #arg == 5 then obj.d = arg[1]; obj.f = arg[2]; obj.a = arg[3]; obj.l = arg[4]; obj.v = arg[5] end

		-- Funciones
		-- wave:blit(...): Muestra la onda. Los valores son los siguientes:
		-- · wave:blit( color ): Muestra la onda de un color
		-- · wave:blit( color 1, color 2 ): Muestra la onda con un gradiente
		function obj:blit(...)
			-- Variables locales
			local arg = {...}
			-- Compruebo que existan los valores
			if self.d and self.f and self.a and self.l and self.v then
				-- Imprimo la onda
				for x = 0, 480 do
					y = self.d+self.a*math.sin(2*math.pi*(x+self.f)/self.l)
					if #arg == 0 then draw.fillrect(x, y, 1, 272, color.new(255, 255, 255))
					elseif #arg == 1 then draw.fillrect(x, y, 1, 272, arg[1])
					elseif #arg == 2 then draw.gradrect(x, y, 1, 272, arg[1], arg[2], __HORIZONTAL) end
				end
				-- Cambio la fase de la ola
				if self.f ~= self.l then self.f = self.f+self.v else self.f = 0 end
			end
		end

		-- Retorno la nueva ola
		return obj
	end
