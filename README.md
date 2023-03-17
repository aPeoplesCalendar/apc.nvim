<div align="center">

# apc.nvim

[About](#about) • [Install](#install) • [Usage](#usage) • [Contribute](#contribute)

</div>

---

This Neovim plugin is written in Lua and provides daily information from [apeoplescalendar.org](https://www.apeoplescalendar.org/).

## About

A People's Calendar (aPC) is a project that seeks to promote the worldwide history of working class movements and liberation struggles in the form of a searchable "On This Day" calendar.

This repository hosts the aPC neovim plugin, implemented in Lua.

This project is open source and the information contained in our event database is non-proprietary and will _always_ be freely available for users, developers, and the public.

## Install

**Using [lazy.nvim](https://github.com/folke/lazy.nvim/):**

```lua
{
    "aPeoplesCalendar/apc.nvim",
    dependencies = {
        "rcarriga/nvim-notify",
    },
    name = "apeoplescalendar",
}
```

### Requirements

- Linux or Mac operating system
- Neovim
- Plugin [rcarriga/nvim-notify](https://github.com/rcarriga/nvim-notify)
- curl

## Usage

**`:APeoplesCalendar`**

Opens a new buffer showing today's events. In normal mode it can be closed with key `q`.

**`:APeoplesCalendarTeaser`**

Opens a popup with one randomly picked event for today's date. It disappears automatically after a few seconds.

### Example configurations

**Open the teaser every time Neovim is opened:**

```lua
{
    "aPeoplesCalendar/apc.nvim",
    dependencies = {
        "rcarriga/nvim-notify",
    },
    event = "VeryLazy",
    name = "apeoplescalendar",
    config = function ()
        require("apeoplescalendar").today_teaser()
    end,
}
```

## Contribute

- A People's Calendar is [open source](https://github.com/aPeoplesCalendar).
- We are happy about feature requests, issue reports and code submissions
- Commit messages must correspond to _[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)_
