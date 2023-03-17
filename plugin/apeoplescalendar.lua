local api = vim.api

if vim.g.loaded_apeoplescalendar then
    return
end
vim.g.loaded_apeoplescalendar = true

if vim.fn.has "nvim-0.7" == 0 then
    api.nvim_echo({{"apeoplescalendar.nvim requires Neovim v0.8+", "WarningMsg"}}, true, {})
    return
end

api.nvim_create_user_command(
    "APeoplesCalendar",
    function(_)
        require("apeoplescalendar").today()
    end,
    {
        desc = "Shows all events of the day"
    }
)

api.nvim_create_user_command(
    "APeoplesCalendarTeaser",
    function(_)
        require("apeoplescalendar").today_teaser()
    end,
    {
        desc = "Shows teaser for one random event of the day"
    }
)

