local M = {}

local function generate_tmp_file_path()
   local path = os.getenv("TMPDIR") or os.getenv("TEMP") or os.getenv("TMP") or "/tmp"
   return path
end

local function test_internet_connection()
    local cmd = "ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && echo ok || echo error | grep \"ok\""
    local handle = io.popen(cmd)
    if handle ~= nil then
        local output = handle:read("*a")
        handle:close()
        if output:find("ok") then
            return true
        end
    end
    return false
end

local function command_capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

local function fetch_apc_events()
    local filename = generate_tmp_file_path() .. "/apeoplescalendar_".. os.date("%Y%m%d")
    local result = nil
    local file = io.open(filename, "r")
    if file ~= nil then
        result = file:read("*all")
        file:close()
    else
        file = io.open(filename, "w")
        if test_internet_connection() then
            local api_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN0YWhtYXhmZmNxYW5raWVudWxoIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTcwNDAzOTUsImV4cCI6MTk3MjYxNjM5NX0.-YZmaNQcoQXbC0_VZYD_jNuOgVbFEu9fbpL_lRDBIH0"
            local request_url = string.format("https://stahmaxffcqankienulh.supabase.co/rest/v1/events?select=*&day=eq.%d&month=eq.%d&order=title.asc", os.date("%d"), os.date("%m") )
            local curl_command = string.format("curl -s '%s' -H \"apikey: %s\"", request_url, api_key)
            result = command_capture(curl_command, true)
            file:write(result)
        end
    end
    return result
end

local function format_up_to_x(s, x, indent)
    x = x or 79
    indent = indent or ""
    local t = {""}
    local function cleanse(s)
        return s:gsub("@x%d%d%d", ""):gsub("@r", "")
    end
    for prefix, word, suffix, newline in s:gmatch("([ \t]*)(%S*)([ \t]*)(\n?)") do
        if #(cleanse(t[#t])) + #prefix + #cleanse(word) > x and #t > 0 then
            table.insert(t, word .. suffix) -- add new element
        else
            t[#t] = t[#t] .. prefix .. word .. suffix
        end
        if #newline > 0 then
            table.insert(t, "")
        end
    end
    return indent .. table.concat(t, "\n" .. indent)
end

local function string_to_table_by_linebreak(table, plain)
    for s in plain:gmatch("[^\r\n]+") do
        table.insert(table, s)
    end
    return table
end

local function json_to_table(encoded)
    local json = require "json"
    local decoded = json.decode( encoded )
    return decoded
end

local function table_to_rst(events)
  local result = "================================\nA People's Calendar [" .. os.date("%Y-%m-%d") .. "] \n================================\n "
  result = result .. "\n  You can follow the A People's Calendar on https://www.apeoplescalendar.org/ \n  To help add an event to the aPC database or to submit a correction, go here:\n  https://docs.google.com/forms/d/e/1FAIpQLScWvVl15jwOMNyltSzl3elc_mEQzRqamlkKy0HpEvX3fYt_sA/viewform\n "
  for _,v in ipairs(events) do
      result = result .. "\n \n" .. v["title"] .. "\n"
      for _=1,string.len(v["title"]) do
        result = result .. "-"
      end
      result = result .. "\n \n"
      result = result .. v["description"] .. "\n \n"
      result = result .. "**Tags:**"
      for _, tag in ipairs(v["tags"]) do
          result = result .. " ``" .. tag .. "``,"
      end
      result = result .. "\n \n**Links:**\n"
      for _, link in ipairs(v["links"]) do
          result = result .. "\n  * " .. link
      end
    end
    return result
end

function M.today_teaser()
    local events = {}
    if test_internet_connection() then
        events = vim.json.decode(fetch_apc_events())
    end
    local event = events[ math.random( #events ) ]
    local teaser = "No server connection..."
    if event ~= nil then
        teaser = event["otd"]
    end
    teaser = format_up_to_x(teaser, 50)
    require("notify").notify(teaser .. "\n \nSee all events of today with :APeoplesCalendar", "error", {
      title = "APeoplesCalendar",
      timeout = 8000,
      render = "simple",
      stages = "fade",
    })
end

function M.today()
    local content = "No server connection...\nPress `q` to close."
    if test_internet_connection() then
        local fetched = fetch_apc_events()
        if fetched then
            content = table_to_rst(vim.json.decode(fetched))
        else
            content = "No events found for today..."
        end
    end
    local lines = {}
    for s in content:gmatch("[^\r\n]+") do
      table.insert(lines, s)
    end

    local width = vim.api.nvim_win_get_width(0)
    local height = vim.api.nvim_win_get_height(0)

    local opts = {
      relative = "editor",
      width = math.floor(width * 0.7),
      height = math.floor(height * 0.8),
      row = math.floor((height - height * 0.8) / 2),
      col = math.floor((width - width * 0.8) / 2),
      style = "minimal",
      focusable = true,
      border = "rounded",
    }

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
    vim.api.nvim_buf_set_option(buf, "filetype", "rst")
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
    local win = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_win_set_cursor(win, {1, 0})
    vim.api.nvim_win_set_option(win, "winhighlight", "Normal:NormalFloat,Border:NormalFloat")
    vim.api.nvim_win_set_option(win, 'wrap', true)
end

return M
