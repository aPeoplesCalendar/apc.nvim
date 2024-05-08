---@text
---A People's Calendar (aPC) is a project that seeks to promote the worldwide
---history of working class movements and liberation struggles in the form of a
---searchable "On This Day" calendar.
---
---This plugin is a neovim interface to the aPC database.
---You can contribute to the project by adding events to the database, or by
---writing code for this plugin.
---@text

local M = {}

---Sets up the plugin
---@param opts table @Configuration options
---@usage `require("apeoplescalendar").setup()`
---@usage `require("apeoplescalendar").setup({auto_teaser_filetypes = {"alpha", "dashboard", "starter"}})`
function M.setup(opts)
	require("apeoplescalendar.config").setup(opts)
end

---Shows all events of the day
---@param opts table @Configuration options
---@usage `require("apeoplescalendar").today()`
function M.today(opts)
	require("apeoplescalendar.apeoplescalendar").today()
end

---Shows teaser for one random event of the day
---@usage `require("apeoplescalendar").today_teaser()`
function M.today_teaser()
	require("apeoplescalendar.apeoplescalendar").today_teaser()
end

return M
