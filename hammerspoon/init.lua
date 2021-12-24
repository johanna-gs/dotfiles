--- ==========================================
--- Configs
--- ==========================================
hs.configdir = os.getenv("HOME") .. "/.dotfiles/hammerspoon"

-- remove animations
hs.window.animationDuration = 0.0

--- ==========================================
--- Window managers
--- ==========================================
local manager = {}

hyper = {"cmd", "alt", "ctrl", "shift"} -- caps-lock with Karabiner

hs.hotkey.bind(hyper, "h", function()
    manager.sendLeft()
end)

hs.hotkey.bind(hyper, "j", function()
    manager.sendDown()
end)

hs.hotkey.bind(hyper, "k", function()
    manager.sendUp()
end)

hs.hotkey.bind(hyper, "l", function()
    manager.sendRight()
end)

hs.hotkey.bind(hyper, "f", function()
    manager.maximize()
end)

hs.hotkey.bind(hyper, "r", function()
    hs.reload()
end)

--- ==========================================
--- Internal variables
--- ==========================================

manager.screen_margins = {
    top = 0,
    left = 0,
    right = 0,
    bottom = 0
}

--- ==========================================
--- Internal API
--- ==========================================

-- return currently focused window
function manager.win()
    return hs.window.focusedWindow()
end

function manager.setFrame(title, unit)
    -- hs.alert(title)
    local win = manager.win()
    return win:setFrame(unit)
end

function manager.screen()
    local screen = manager.win():screen():frame()
    local margins = manager.screen_margins
    return {
        x = screen.x + margins.left,
        y = screen.y + margins.top,
        w = screen.w - (margins.left + margins.right),
        h = screen.h - (margins.top + margins.bottom)
    }
end

function manager.maximize()
    manager.setFrame("Full Screen", manager.screen())
end

function manager.sendLeft()
    local s = manager.screen()
    manager.setFrame("Left", {
        x = s.x,
        y = s.y,
        w = s.w * .5,
        h = s.h
    })
end

function manager.sendDown()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local s = manager.screen()

    manager.setFrame("Down", {
        x = f.x,
        y = s.y + s.h * .5,
        w = f.w,
        h = s.h * .5
    })
end

function manager.sendUp()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local s = manager.screen()

    manager.setFrame("Up", {
        x = f.x,
        y = s.y,
        w = f.w,
        h = s.h * .5
    })
end

function manager.sendRight()
    local s = manager.screen()
    manager.setFrame("Right", {
        x = s.w * .5,
        y = s.y,
        w = s.w * .5,
        h = s.h
    })
end

--- ==========================================
--- Reload this config if it changes
--- ==========================================

hs.pathwatcher.new(hs.configdir, function(changedfiles)
    local function is_lua_file(filename)
        if string.match(filename, '%.lua$') then
            print(filename)
        end
        return string.match(filename, '%.lua$')
    end
    if not require("hs.fnutils").every(changedfiles, is_lua_file) then
        return
    end
    hs.reload()
end):start()

hs.alert("Config loaded")
