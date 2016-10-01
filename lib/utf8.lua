--[[
Provides UTF-8 aware string functions implemented in pure lua,

All functions behave as their non UTF-8 aware counterparts with the exception
that UTF-8 characters are used instead of bytes for all units.

Copyright (c) 2006-2007, Kyle Smith
Modified by Alexander Yakushev, 2010-2013.
Modified by NEKERAFA, 2014.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
* Neither the name of the author nor the names of its contributors may be
used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS'
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


Table of decimal bytes ranges of utf8 characters

size	byte 1		byte 2		byte 3		byte 4		first character
-----------------------------------------------------------------------
1		0-127											0
2		194-223		128-191								128
3		224-224		160-191		128-191					2048
3		225-236		128-191		128-191					4096
3		237-237		128-159		128-191					53248
3		238-239		128-191		128-191					57344
4		240-240		144-191		128-191		128-191		65536
4		241-243		128-191		128-191		128-191		262144
4		244-244		128-143		128-191		128-191		1048576   
--]]

-- Return true if the number is in the range
function math.range(number, from, to) return number >= from and number <= to end

-- Return binary number from hexadecimal
function math.hexbin(hex, w)
	local hex = tostring(hex)
	local bin = ''
	-- Table of hexadecimal-binary conversion
	local hex_bin = {[0]='0000', [1]='0001', [2]='0010', [3]='0011', [4]='0100', [5]='0101', [6]='0110', [7]='0111', [8]='1000', [9]='1001', [10]='1010', [11]='1011', [12]='1100', [13]='1101', [14]='1110', [15]='1111'}
	for n in hex:gmatch('.') do bin=bin..hex_bin[tonumber(n, 16)] end
	if w and #bin<w then while #bin<w do bin='0'..bin end end
	return bin
end

utf8 = {}

-- The pattern which matches one UTF-8 sequence
utf8.charpatt = '([%z\1-\127\194-\244][\128-\191]*)'

-- Number of first character in the range 
utf8.uc_start = {128, 2048, 4096, 53248, 57344, 65536, 262144, 10488576}

-- returns the number of bytes used by the UTF-8 character at byte i in s
-- also doubles as a UTF-8 character validator
function utf8.charbytes(s, i)
	local s = tostring(s)
	local byte1, byte2, byte3, byte4 = string.byte(s, i, i+4)
   
	-- determine bytes needed for character, based on RFC 3629
	-- UTF8-1
	if math.range(byte1, 0, 127) then return 1
	-- UTF8-2
	elseif math.range(byte1, 194, 223) and math.range(byte2, 128, 191) then return 2
	-- UTF8-3 (first range)
	elseif (byte1 == 224 and math.range(byte2, 160, 191) and math.range(byte3, 128, 191)) or
	-- UTF8-3 (second range)
	(math.range(byte1, 225, 236) and math.range(byte2, 128, 191) and math.range(byte3, 128, 191)) or
	-- UTF8-3 (third range)
	(byte1 == 237 and math.range(byte2, 128, 159) and math.range(byte3, 128, 191)) or
	-- UTF8-3 (fourth range)
	(math.range(byte1, 238, 239) and math.range(byte2, 128, 191) and math.range(byte3, 128, 191)) then return 3
	-- UTF8-4 (first range)
	elseif (byte1 == 240 and math.range(byte2, 144, 191) and math.range(byte3, 128, 191) and math.range(byte4, 128, 191)) or
	-- UTF8-4 (second range)
	(math.range(byte1, 241, 243) and math.range(byte2, 128, 191) and math.range(byte3, 128, 191) and math.range(byte4, 128, 191)) or
	-- UTF8-4 (third range)
	(byte1 == 244 and math.range(byte2, 128, 143) and math.range(byte3, 128, 191) and math.range(byte4, 128, 191)) then return 4 end
end

-- returns the number of characters in a UTF-8 string
function utf8.len(s)
	local s = tostring(s)
   local s, len = s:gsub(utf8.charpatt, '')
   return len
end

-- function identically to string.sub except that i and j are UTF-8 characters
-- instead of bytes
function utf8.sub(s, i, j)
	local s = tostring(s)
	local j = j or -1
	if i == nil then return '' end
   
	local pos = 1
	local bytes = string.len(s)
	local len = 0

	-- only set l if i or j is negative
	local l = (i >= 0 and j >= 0) or utf8.len(s)
	local startChar = (i >= 0) and i or l + i + 1
	local endChar = (j >= 0) and j or l + j + 1

	-- can't have start before end!
	if startChar > endChar then return '' end
   
	-- byte offsets to pass to string.sub
	local startByte, endByte = 1, bytes
   
	while pos <= bytes do
		len = len + 1
		if len == startChar then startByte = pos end
		pos = pos + utf8.charbytes(s, pos)
		if len == endChar then endByte = pos - 1; break end
	end
	return string.sub(s, startByte, endByte)
end

-- replace UTF-8 characters based on a mapping table
function utf8.replace(s, mapping)
   local s = tostring(s)
   local pos = 1
   local bytes = string.len(s)
   local charbytes
   local newstr = ''

   while pos <= bytes do
      charbytes = utf8.charbytes(s, pos)
      local c = string.sub(s, pos, pos + charbytes - 1)
      newstr = newstr .. (mapping[c] or c)
      pos = pos + charbytes
   end

   return newstr
end

-- Identical to string.reverse except that it supports UTF-8
function utf8.reverse(s)
	local s = tostring(s)
	local newstr = ''
	for char in s:gmatch(utf8.charpatt) do newstr = char..newstr end
	return newstr
end

-- Return decimal unicode point from UTF-8 character
-- This function only works with UTF-8 character based on RFC 3629
function utf8.codepoint(utf8_char)
	local byte1, byte2, byte3, byte4 = string.byte(utf8_char, 1, 4)
	-- UFT8 (1 byte)
	if math.range(byte1, 0, 127) then return byte1
	-- UTF8 (2 bytes)
	elseif math.range(byte1, 194, 223) and math.range(byte2, 128, 191) then 
		return (byte1-194)*64+(byte2-128)+utf8.uc_start[1]
	-- UTF8 (3 bytes, first range)
	elseif byte1 == 224 and math.range(byte2, 160, 191) and math.range(byte3, 128, 191) then
		return (byte2-160)*64+(byte3-128)+utf8.uc_start[2]
	-- UTF8 (3 bytes, second range)
	elseif math.range(byte1, 225, 236) and math.range(byte2, 128, 191) and math.range(byte3, 128, 191) then 
		return (byte1-225)*4096+(byte2-128)*64+(byte3-128)+utf8.uc_start[3]
	-- UTF8 (3 bytes, third range)
	elseif byte1 == 237 and math.range(byte2, 128, 159) and math.range(byte3, 128, 191) then
		return (byte2-128)*64+(byte3-128)+utf8.uc_start[4]
	-- UTF8 (3 bytes, fourth range)
	elseif math.range(byte1, 238, 239) and math.range(byte2, 128, 191) and math.range(byte3, 128, 191) then
		return (byte1-225)*4096+(byte2-128)*64+(byte3-128)+utf8.uc_start[5]
	-- UTF8 (4 bytes, first range)
	elseif byte1 == 240 and math.range(byte2, 144, 191) and math.range(byte3, 128, 191) and math.range(byte4, 128, 191) then
		return (byte2-144)*4096+(byte3-128)*64+(byte4-128)+utf8.uc_start[6]
	-- UTF8 (4 bytes, second range)
	elseif math.range(byte1, 241, 243) and math.range(byte2, 128, 191) and math.range(byte3, 128, 191) and math.range(byte4, 128, 191) then
		return (byte1-241)*262144+(byte2-128)*4096+(byte3-128)*64+(byte4-128)+utf8.uc_start[7]
	-- UTF8 (4 bytes, third range)
	elseif byte1 == 244 and math.range(byte2, 128, 143) and math.range(byte3, 128, 191) and math.range(byte4, 128, 191) then
		return (byte2-128)*4096+(byte3-128)*64+(byte4-128)+utf8.uc_start[8]
	end
end

-- Return decimal codes in UTF-8 based on RFC 3629 from unicode point
function utf8.codes(unicode)
	-- UTF8 (1 byte)
	if math.range(unicode, 0, 127) then return tonumber(unicode)
	-- UTF8 (2 bytes)
	elseif math.range(unicode, 128, 2047) then
		local bin = math.hexbin(string.format('%X', unicode), 32)
		return tonumber('110'..bin:sub(22,26), 2), tonumber('10'..bin:sub(27), 2)
	-- UTF8 (3 bytes)
	elseif math.range(unicode, 2048, 65536) then
		local bin = math.hexbin(string.format('%X', unicode), 32)
		return tonumber('1110'..bin:sub(17,20), 2), tonumber('10'..bin:sub(21,26), 2), tonumber('10'..bin:sub(27), 2)
	-- UTF8 (4 bytes)
	elseif math.range(unicode, 65537, 1048576) then
		local bin = math.hexbin(string.format('%X', unicode), 32)
		return tonumber('11110'..bin:sub(12,14), 2), tonumber('10'..bin:sub(15,20), 2), tonumber('10'..bin:sub(21,26), 2), tonumber('10'..bin:sub(27), 2)
	end
end

-- Return char in UTF-8 based on RFC 3629 from hexadecimal codepoint
function utf8.char(unicode)
	unicode = tonumber(unicode, 16)
	-- UTF8 (1 byte)
	if math.range(unicode, 0, 127) then return string.char(tonumber(unicode))
	-- UTF8 (2 bytes)
	elseif math.range(unicode, 128, 2047) then
		local bin = math.hexbin(string.format('%X', unicode), 32)
		return string.char(tonumber('110'..bin:sub(22,26), 2), tonumber('10'..bin:sub(27), 2))
	-- UTF8 (3 bytes)
	elseif math.range(unicode, 2048, 65536) then
		local bin = math.hexbin(string.format('%X', unicode), 32)
		return string.char(tonumber('1110'..bin:sub(17,20), 2), tonumber('10'..bin:sub(21,26), 2), tonumber('10'..bin:sub(27), 2))
	-- UTF8 (4 bytes)
	elseif math.range(unicode, 65537, 1048576) then
		local bin = math.hexbin(string.format('%X', unicode), 32)
		return string.char(tonumber('11110'..bin:sub(12,14), 2), tonumber('10'..bin:sub(15,20), 2), tonumber('10'..bin:sub(21,26), 2), tonumber('10'..bin:sub(27), 2))
	end
end
