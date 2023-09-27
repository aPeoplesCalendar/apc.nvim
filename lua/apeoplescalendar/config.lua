---@mod apeoplescalendar.config Configuration
local M = {}

---@class Config
---@field defaults ConfigDefaults @Default configuration

---@class ConfigDefaults
---@field auto_teaser_filetypes string[] @List of filetypes to enable auto teaser for
M.defaults = {
	auto_teaser_filetypes = {
		"alpha",
		"dashboard",
		"starter",
	}, -- will enable running the teaser automatically for listed filetypes
}

---@comment
---@param opts Config
---@return nil
---@usage `require("apeoplescalendar.config").setup({auto_teaser_filetypes = {"alpha", "dashboard", "starter"}})
function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

	if #M.options.auto_teaser_filetypes > 0 then
		vim.api.nvim_create_autocmd("FileType", {
			pattern = M.options.auto_teaser_filetypes,
			callback = function(event)
				M.today_teaser()
			end,
		})

		vim.defer_fn(function()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.tbl_contains(M.options.auto_teaser_filetypes, vim.bo[buf].filetype) then
					require("apeoplescalendar").today_teaser()
					break
				end
			end
		end, 100)
	end
end

return M
