local M = {}

function M.setup(opts)
  require("apeoplescalendar.config").setup(opts)
end

function M.today(opts)
  require("apeoplescalendar.apeoplescalendar").today()
end

function M.today_teaser()
  require("apeoplescalendar.apeoplescalendar").today_teaser()
end

return M
