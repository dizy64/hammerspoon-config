local function detectConfigDir()
	if _G.hs and hs.configdir then
		return hs.configdir
	end
	local source = debug.getinfo(1, "S").source or ""
	local path = source:match("^@(.+)%/init%.lua$")
	return path or "."
end

local configDir = detectConfigDir()
package.path = configDir .. "/?.lua;" .. configDir .. "/?/init.lua;" .. package.path

local sizeup = require("sizeup")

sizeup.setup({
	center = { mode = "absolute", width = 800, height = 600 },
})
