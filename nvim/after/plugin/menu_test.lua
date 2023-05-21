local popup = require("plenary.popup")

HarpoonConfig = HarpoonConfig or {}

local function Mark_config_key()
    return "asdf"
    -- global_settings = global_settings or M.get_global_settings()
    -- if global_settings.mark_branch then
    --     return utils.branch_key()
    -- else
    --     return utils.project_key()
    -- end
end

local function Ensure_correct_config(config)
    local projects = config.projects
    local mark_key = Mark_config_key()
    if projects[mark_key] == nil then
        projects[mark_key] = {
            mark = { marks = {} },
            term = {
                cmds = {},
            },
        }
    end

    local proj = projects[mark_key]
    if proj.mark == nil then
        proj.mark = { marks = {} }
    end

    if proj.term == nil then
        proj.term = { cmds = {} }
    end

    local marks = proj.mark.marks

    for idx, mark in pairs(marks) do
        if type(mark) == "string" then
            mark = { filename = mark }
            marks[idx] = mark
        end

        marks[idx].filename = "asdf"
    end

    return config
end


function Get_mark_config()
    return Ensure_correct_config(HarpoonConfig).projects[Mark_config_key()].mark
end

local function Create_mark(filename)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    return {
        filename = filename,
        row = cursor_pos[1],
        col = cursor_pos[2],
    }
end

local function Emit_changed()
    if harpoon.get_global_settings().save_on_change then
        harpoon.save()
    end

    -- if not callbacks["changed"] then
    --     log.trace("_emit_changed(): no callbacks for 'changed', returning")
    --     return
    -- end

    -- for idx, cb in pairs(callbacks["changed"]) do
    --     log.trace(
    --         string.format(
    --             "_emit_changed(): Running callback #%d for 'changed'",
    --             idx
    --         )
    --     )
    --     cb()
    -- end
end


function Add_file()
    local found_idx = 1
    Get_mark_config().marks[found_idx] = Create_mark("asdf")
    Emit_changed()
end

function ShowMenu()
  local height = 10
  local width = 10
  local bufnr = vim.api.nvim_create_buf(false, false)
  local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

  local Harpoon_win_id, win = popup.create({ "asdf", "bbbb" }, {
        title = "Harpoon",
        highlight = "HarpoonWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
  })
  vim.api.nvim_win_set_option(
    win.border.win_id,
    "winhl",
    "Normal:HarpoonBorder"
  )
  print(win)
  print(Harpoon_win_id)
end

--ShowMenu()
