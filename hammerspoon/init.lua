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

hs.hotkey.bind(hyper, "p", function()
    manager.nextScreen()
end)

hs.hotkey.bind(hyper, "o", function()
    manager.nextScreen()
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
    local win = manager.win()

    -- print("x: " .. unit.x .. ", w: " .. unit.w)

    return win:setFrame(unit, 0)
end

function manager.screen()
    return manager.win():screen():frame()
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
        x = s.x + s.w * .5,
        y = s.y,
        w = s.w * .5,
        h = s.h
    })
end

function manager.nextScreen()
    local win = hs.window.focusedWindow()
    local screen = win:screen():frame()
    local nextScreen = win:screen():next():frame()
    local wf = win:frame()

    -- Calculate the coordinates of the window frame in the next screen and retain aspect ratio
    wf.x = ((((wf.x - screen.x) / screen.w) * nextScreen.w) + nextScreen.x)
    wf.y = ((((wf.y - screen.y) / screen.h) * nextScreen.h) + nextScreen.y)
    wf.h = ((wf.h / screen.h) * nextScreen.h)
    wf.w = ((wf.w / screen.w) * nextScreen.w)

    -- Set the focused window's new frame dimensions
    win:setFrame(wf)
end

function manager.previousScreen()
    local win = hs.window.focusedWindow()
    local screen = win:screen():frame()
    local nextScreen = win:screen():previous():frame()
    local wf = win:frame()

    -- Calculate the coordinates of the window frame in the next screen and retain aspect ratio
    wf.x = ((((wf.x - screen.x) / screen.w) * nextScreen.w) + nextScreen.x)
    wf.y = ((((wf.y - screen.y) / screen.h) * nextScreen.h) + nextScreen.y)
    wf.h = ((wf.h / screen.h) * nextScreen.h)
    wf.w = ((wf.w / screen.w) * nextScreen.w)

    -- Set the focused window's new frame dimensions
    win:setFrame(wf)
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
