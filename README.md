<div align="center">

# apc.nvim

[About](#about) • [Requirements](#requirements) • [Installation](#installation) • [Configuration](#configuration) • [Features](#features) • [Contribute](#contribute)

</div>

---

This Neovim plugin is written in Lua and provides daily information from [apeoplescalendar.org](https://www.apeoplescalendar.org/).

## About

A People's Calendar (aPC) is a project that seeks to promote the worldwide history of working class movements and liberation struggles in the form of a searchable "On This Day" calendar.

This repository hosts the aPC neovim plugin, implemented in Lua.

This project is open source and the information contained in our event database is non-proprietary and will _always_ be freely available for users, developers, and the public.

## Requirements

- Linux or Mac operating system
- Neovim
- Plugin [rcarriga/nvim-notify](https://github.com/rcarriga/nvim-notify)
- curl

## Installation

**Using [lazy.nvim](https://github.com/folke/lazy.nvim/):**

```lua
{
    "aPeoplesCalendar/apc.nvim",
    dependencies = {
        "rcarriga/nvim-notify",
    },
    event = "VeryLazy",
    config = function ()
        require("apeoplescalendar").setup() -- configuration options are described below
    end,
}
```

## Configuration

**apc.nvim** comes with the following defaults:

```lua
{
    auto_teaser_filetypes = { "dashboard", "alpha", "starter", }, -- will enable running the teaser automatically for listed filetypes
}
```

## Features

**`:APeoplesCalendar`**

Opens a new buffer showing today's events. In normal mode it can be closed with key `q`.

![showcase for detailed event view](https://user-images.githubusercontent.com/52743746/225929058-10c30fed-416b-4eca-8ec0-2cd126493487.png)

**`:APeoplesCalendarTeaser`**

Opens a popup with one randomly picked event for today's date. It disappears automatically after a few seconds.

![showcase for teaser](https://user-images.githubusercontent.com/52743746/225929068-cae08eba-6ba5-4af2-953b-235a98dd1df0.png)

## Contribute

- A People's Calendar is [open source](https://github.com/aPeoplesCalendar).
- We are happy about feature requests, issue reports and code submissions
- Commit messages must correspond to _[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)_
