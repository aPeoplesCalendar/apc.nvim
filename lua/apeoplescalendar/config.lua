---@mod apeoplescalendar.config Configuration
local C = {}

---@class Config

---@class ConfigDefaults
C.defaults = {
	auto_teaser_filetypes = {
		"alpha",
		"dashboard",
		"starter",
	}, -- will enable running the teaser automatically for listed filetypes
}

---@param opts Config
---@usage `require("apeoplescalendar.config").setup({auto_teaser_filetypes = {"alpha", "dashboard", "starter"}})
function C.setup(opts)
	C.options = vim.tbl_deep_extend("force", C.defaults, opts or {})

	if #C.options.auto_teaser_filetypes > 0 then
		vim.api.nvim_create_autocmd("FileType", {
			pattern = C.options.auto_teaser_filetypes,
			callback = function(event)
				C.today_teaser()
			end,
		})

		vim.defer_fn(function()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.tbl_contains(C.options.auto_teaser_filetypes, vim.bo[buf].filetype) then
					require("apeoplescalendar").today_teaser()
					break
				end
			end
		end, 100)
	end
end

return C
